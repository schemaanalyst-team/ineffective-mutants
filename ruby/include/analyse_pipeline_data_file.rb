require_relative 'common'

class AnalysePipelineDataFile

  DBMS_COL = 0
  SCHEMA_COL = 1
  PIPELINE_COL = 2
  ACTION_COL = 3
  OPERATOR_COL = 4
  COUNT_COL = 5
  TIME_COL = 6

  NUM_RUNS = 30

  # Actions
  PRODUCED_ACTION = 'produced'
  REMOVED_ACTION = 'removed'

  # STATIC_ANALYSIS_PIPELINE uses static analysis to identify and remove mutants
  # DBMS_PIPELINE uses the DBMS (aka 'dynamic analysis') to remove quasis
  # DBMS_TRANSACTIONS_PIPELINE uses the DBMS with transactions enabled to remove quasis
  STATIC_ANALYSIS_PIPELINE = 'AllOperatorsNoFKANormalisedWithClassifiers'
  DBMS_PIPELINE = 'AllOperatorsNoFKANormalisedWithRemoversDBMSRemovers'
  DBMS_TRANSACTIONS_PIPELINE = 'AllOperatorsNoFKANormalisedWithRemoversTransactedDBMSRemovers'

  # Operators
  DBMS_REMOVER_OPERATOR = 'DBMSRemover'
  DBMS_TRANSACTED_REMOVER_OPERATOR = 'DBMSTransactedRemover'

  def initialize
    @file_name = path_to_data_dir(file_name_minus_path)
  end

  def file_name_minus_path
    'analyse-pipeline.dat'
  end

  def pipelines
    [DBMS_PIPELINE, DBMS_TRANSACTIONS_PIPELINE, STATIC_ANALYSIS_PIPELINE]
  end

  def mutants_produced(dbms, element)
    return mutants_produced_for_schema(dbms, element) if schemas.include?(element)
    return mutants_produced_for_operator(dbms, element) if operators.include?(element)
    abort("* ERROR unknown element #{element}")
  end

  def mutants_produced_for_schema(dbms, schema)
    started = false
    total = 0
    CSV.foreach(@file_name) do |row|
      if row[DBMS_COL] == dbms &&
          row[SCHEMA_COL] == schema &&
          row[PIPELINE_COL] == STATIC_ANALYSIS_PIPELINE

        if row[ACTION_COL] == PRODUCED_ACTION
          started = true
          total += row[COUNT_COL].to_i
        else
          return total if started
        end
      end
    end
    return total
  end

  def mutants_produced_for_operator(dbms, operator)
    produced = 0
    CSV.foreach(@file_name) do |row|
      if row[DBMS_COL] == dbms &&
          row[PIPELINE_COL] == STATIC_ANALYSIS_PIPELINE &&
          row[ACTION_COL] == PRODUCED_ACTION &&
          row[OPERATOR_COL] == operator
        produced += row[COUNT_COL].to_i
      end
    end

    produced /= NUM_RUNS
    return produced
  end

  def quasi_mutants_for_schema(dbms, schema, transactions=false)
    pipeline = DBMS_PIPELINE
    operator = DBMS_REMOVER_OPERATOR

    if transactions
      pipeline = DBMS_TRANSACTIONS_PIPELINE
      operator = DBMS_TRANSACTED_REMOVER_OPERATOR
    end

    pipleline = DBMS_TRANSACTIONS_PIPELINE if operator == DBMS_REMOVER_OPERATOR

    CSV.foreach(@file_name) do |row|
      if row[DBMS_COL] == dbms &&
          row[SCHEMA_COL] == schema &&
          row[PIPELINE_COL] == pipeline &&
          row[ACTION_COL] == REMOVED_ACTION &&
          row[OPERATOR_COL] == operator
        count = row[COUNT_COL].to_i
        return count
      end
    end
    return -1
  end

  def stillborn_mutant_removal_times(dbms, schema, pipeline)
    times = []

    unless dbms == 'SQLite'
      remover = "#{dbms}Remover" if pipeline == STATIC_ANALYSIS_PIPELINE
      remover = DBMS_REMOVER_OPERATOR if pipeline == DBMS_PIPELINE
      remover = DBMS_TRANSACTED_REMOVER_OPERATOR if pipeline == DBMS_TRANSACTIONS_PIPELINE

      CSV.foreach(@file_name) do |row|
        if row[DBMS_COL] == dbms &&
            row[SCHEMA_COL] == schema &&
            row[PIPELINE_COL] == pipeline &&
            row[ACTION_COL] == REMOVED_ACTION &&
            row[OPERATOR_COL] == remover
          times << row[TIME_COL].to_i
        end
      end
    end

    return times
  end

  def ier_mutant_removal_times(dbms, schema, mode)
    # set up an array of zeros, initially
    times = Array.new(NUM_RUNS, 0)

    impaired_mutant_removal_times = [0] * NUM_RUNS
    equivalent_mutant_removal_times = [0] * NUM_RUNS
    redundant_mutant_removal_times = [0] * NUM_RUNS

    run = -1
    last_action_was_removed = false

    # finds each 'critical region' of the file
    # for each schema, the static analysis pipeline
    # and the removed action for each experiment repetition
    # and add up the times taken.
    CSV.foreach(@file_name) do |row|
      if row[DBMS_COL] == dbms &&
          row[SCHEMA_COL] == schema &&
          row[PIPELINE_COL] == STATIC_ANALYSIS_PIPELINE &&
          row[ACTION_COL] == REMOVED_ACTION

        if !last_action_was_removed
          last_action_was_removed = true
          run += 1
        end

        if dbms == 'SQLite' && row[OPERATOR_COL] == 'SQLiteClassifier'
          impaired_mutant_removal_times[run] = row[TIME_COL].to_i
        end

        if row[OPERATOR_COL] == 'EquivalentMutantClassifier'
          equivalent_mutant_removal_times[run] += row[TIME_COL].to_i
        end

        if row[OPERATOR_COL] == 'RedundantMutantClassifier'
          redundant_mutant_removal_times[run] = row[TIME_COL].to_i
        end
      else
        last_action_was_removed = false
      end
    end

    if mode == Mode::MINUS_I || mode == Mode::MINUS_IE || mode == Mode::MINUS_IER
      for i in 0..NUM_RUNS-1
        times[i] += impaired_mutant_removal_times[i].to_i
      end
    end

    if mode == Mode::MINUS_IE || mode == Mode::MINUS_IER
      for i in 0..NUM_RUNS-1
        times[i] += equivalent_mutant_removal_times[i].to_i
      end
    end

    if mode == Mode::MINUS_IER
      for i in 0..NUM_RUNS-1
        times[i] += redundant_mutant_removal_times[i].to_i
      end
    end

    return times
  end

  def validate(verbose=false)
    puts "Checking #{file_name_minus_path}..."
    dbmses.each do |dbms|
      puts "... Checking #{dbms}" if verbose
      schemas.each do |schema|
        puts "...... Checking #{schema}" if verbose
        pipelines.each do |pipeline|
          puts "......... Checking #{pipeline}" if verbose
          if !count_runs(dbms, schema, pipeline)
            puts "* WARNING num runs not equal to #{NUM_RUNS} for #{dbms}, #{schema}, #{pipeline}"
          end
        end
      end
    end
  end

  def count_runs(dbms, schema, pipeline)
    runs = 0
    consecutive = false

    CSV.foreach(@file_name) do |row|
        if row[DBMS_COL] == dbms && row[SCHEMA_COL] == schema && row[PIPELINE_COL] == pipeline
          if !consecutive
            runs += 1
          end
          consecutive = true
        else
          consecutive = false
        end
    end

    runs == NUM_RUNS
  end
end