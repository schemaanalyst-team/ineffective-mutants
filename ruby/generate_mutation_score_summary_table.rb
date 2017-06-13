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
  decrease = 0
  increase = 0
  adequate = 0

  schemas.each do |schema|
    scores = madf.mutation_scores(schema, mode)
    last_scores = madf.mutation_scores(schema, last_mode) unless last_mode.nil?

    unless (last_mode.nil? || scores.length == last_scores.length)
      abort("* ERROR: scores arrays not equal in length")
    end

    mean_this = mean_mutuation_score(scores)
    mean_last = mean_mutuation_score(last_scores) unless last_mode.nil?

    adequate +=1 if mean_this == 1.0
    increase +=1 if mean_this > mean_last unless last_mode.nil?
    decrease +=1 if mean_this < mean_last unless last_mode.nil?

    puts "#{data_generator} #{mode} #{last_mode} #{dbms} #{schema} #{mode} #{last_mode} #{adequate}"
  end

  decrease_percen = f1dp(percen(decrease, num_schemas))
  increase_percen = f1dp(percen(increase, num_schemas))
  adequate_percen = f1dp(percen(adequate, num_schemas))

  data = ""
  #data += "#{decrease} (#{decrease_percen}) & #{increase} (#{increase_percen}) & "  unless last_mode.nil?
  data += "#{decrease} & #{increase} & "  unless last_mode.nil?
  data += "#{adequate} (#{adequate_percen}) "

  return data
end

# generate summary table
file_name = "mutation-scores-summary.tex"
file = File.open(path_to_generated_data_dir(file_name), 'w')

dbmses.each do |dbms|

  line = "\\#{dbms} "

  data_generators.reverse_each do |data_generator|

    last_mode = nil
    Mode::modes.each do |mode|

      if mode == Mode::MINUS_I && (dbms == 'HyperSQL' || dbms == 'Postgres')
        line += "& & & "
        next
      end

      madf = MutationAnalysisDataFile.new(dbms, data_generator)
      result = schemas_compare(dbms, data_generator, madf, mode, last_mode)

      line += "& #{result} "

      last_mode = mode
    end
  end

  line += "\\\\\n"
  output(file, line)
end

file.close