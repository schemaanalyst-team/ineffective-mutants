require_relative 'common'
require_relative 'analyse_pipeline_data_file'

class MutationAnalysisDataFile
  ID_COL = 0
  DBMS_COL = 1
  SCHEMA_COL = 2
  OPERATOR_COL = 3
  MUTANT_TYPE_COL = 4
  KILLED_COL = 5
  TIME_COL = 6

  NORMAL_MUTANT_TYPE = 'NORMAL'
  IMPAIRED_MUTANT_TYPE = 'IMPAIRED'
  EQUIVALENT_MUTANT_TYPE = 'EQUIVALENT'
  REDUNDANT_MUTANT_TYPE = 'DUPLICATE'

  def initialize(dbms, data_generator)
    @dbms = dbms
    @data_generator = data_generator
    @file_name = path_to_data_dir(file_name_minus_path)
  end

  def file_name_minus_path
    "#{@dbms.downcase}-#{@data_generator}.dat"
  end

  def run_ids
    unique_column_values(@file_name, ID_COL)
  end

  def num_runs
    run_ids.length / num_schemas
  end

  def include_mutant_row(mode, row)
    normal = row[MUTANT_TYPE_COL] == NORMAL_MUTANT_TYPE
    impaired = row[MUTANT_TYPE_COL] == IMPAIRED_MUTANT_TYPE
    equivalent = row[MUTANT_TYPE_COL] == EQUIVALENT_MUTANT_TYPE
    redundant = row[MUTANT_TYPE_COL] == REDUNDANT_MUTANT_TYPE

    include_all = mode == Mode::ALL
    include_minus_i = mode == Mode::MINUS_I && (normal || equivalent || redundant)
    include_minus_ie = mode == Mode::MINUS_IE && (normal || redundant)
    include_minus_ier = mode == Mode::MINUS_IER && normal

    include_all || include_minus_i || include_minus_ie || include_minus_ier
  end

  def mutation_scores(schema, mode)
    scores = []
    current_run = ''
    current_killed = 0
    current_total = 0

    # total up the number of mutants killed and the overall total
    # for each type of mutant according to the 'mode' (i.e., include impaired, equivalent etc.)
    CSV.foreach(@file_name) do |row|
      if row[SCHEMA_COL] == schema
        if row[ID_COL] != current_run
          if current_run != ''
            scores << {
              killed: current_killed,
              total: current_total,
              score: current_killed / current_total.to_f
            }
            current_killed = 0
            current_total = 0
          end
          current_run = row[ID_COL]
        end

        if include_mutant_row(mode, row)
          current_killed += 1 if row[KILLED_COL] == 'true'
          current_total += 1
        end
      end
    end
    if current_run != ''
      scores << {
        killed: current_killed,
        total: current_total,
        score: current_killed / current_total.to_f
      }
    end

    return scores
  end

  def mutation_times(schema, mode)
    times = []
    current_run = ''
    current_time = 0

    # total up the time for each mutant row
    # depending on whether that mutant should be included in the analysis
    # (i.e., according to the 'mode' -- impaired, equivalent etc.)
    CSV.foreach(@file_name) do |row|
      if row[SCHEMA_COL] == schema
        if row[ID_COL] != current_run
          if current_run != ''
            times << current_time
            current_time = 0
          end
          current_run = row[ID_COL]
        end
        if include_mutant_row(mode, row)
          current_time += row[TIME_COL].to_i
        end
      end
    end
    times << current_time if current_run != ''

    # add removal times if we're doing static analysis
    apdf = AnalysePipelineDataFile.new
    removal_times = apdf.ier_mutant_removal_times(@dbms, schema, mode)

    for i in 0..times.length-1
      times[i] += removal_times[i]
    end

    return times
  end

  def validate
    puts "Checking #{file_name_minus_path}..."
    same_num_runs_per_schema
    all_schemas_present
    only_this_dbms
    lines_checksum
  end

  def same_num_runs_per_schema
    num_runs_precise = run_ids.length / num_schemas.to_f
    res = (num_runs_precise - num_runs_precise.round(0)) == 0
    puts "* WARNING: number of runs per schema is not a round number in #{file_name_minus_path}" unless res
  end

  def all_schemas_present
    schemas_present = unique_column_values(@file_name, SCHEMA_COL)
    schemas.each do |schema|
      if !schemas_present.include? schema
        puts "* WARNING: #{schema} not present in #{file_name_minus_path}"
      end
    end
  end

  def only_this_dbms
    dbmses = unique_column_values(@file_name, DBMS_COL)
    res = (dbmses.length == 1 && dbmses[0] == @dbms)
    puts "* WARNING: DBMS is not always set to #{@dbms} in #{file_name_minus_path}" unless res
  end

  def lines_checksum
    # cache this value
    num_runs = self.num_runs

    schemas.each do |schema|
      lines = 0
      CSV.foreach(@file_name) do |row|
        lines += 1 if row[SCHEMA_COL] == schema
      end
      av_lines = lines / num_runs.to_f
      res = (av_lines - av_lines.round(0)) == 0
      puts "* WARNING: #{schema} has an inconsistent line count in #{file_name_minus_path}" unless res
    end
  end

  def self.validate_all
    dbmses.each do |dbms|
      data_generators.each do |data_generator|
        MutationAnalysisDataFile.new(dbms, data_generator).validate
      end
    end
  end
end
