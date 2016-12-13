require_relative 'include/common'
require_relative 'include/formatting'
require_relative 'include/r'
require_relative 'include/mutation_analysis_data_file'

def mean_mutuation_score(scores)
  decimal_scores = []

  scores.each do |score|
    decimal_scores << score[:score]
  end

  mean(decimal_scores)
end

def schemas_compare(dbms, data_generator, madf, mode, last_mode)
  total = 0

  schemas.each do |schema|
    scores = madf.mutation_scores(schema, mode)
    last_scores = madf.mutation_scores(schema, last_mode)

    unless (last_mode.nil? || scores.length == last_scores.length)
      abort("* ERROR: scores arrays not equal in length")
    end

    total += 1 if mean_mutuation_score(scores) != mean_mutuation_score(last_scores)

    puts "#{data_generator} #{dbms} #{schema} #{mode} #{last_mode} #{total}"
  end

  total
end

# generate summary table
file_name = "mutation-scores-by-total-schema-changes.tex"
file = File.open(path_to_generated_data_dir(file_name), 'w')

dbmses.each do |dbms|

  line = "#{dbms} "

  data_generators.each do |data_generator|

    last_mode = nil
    Mode::modes.each do |mode|

      unless mode == Mode::ALL
        if mode == Mode::MINUS_I && (dbms == 'HyperSQL' || dbms == 'Postgres')
          line += ' & '
          next
        end

        madf = MutationAnalysisDataFile.new(dbms, data_generator)
        result = schemas_compare(dbms, data_generator, madf, mode, last_mode)

        line += "& #{result} "
      end

      last_mode = mode
    end
  end

  line += "\\\\\n"
  output(file, line)
end

file.close