require_relative 'include/common'
require_relative 'include/formatting'
require_relative 'include/r'
require_relative 'include/mutation_analysis_data_file'

def schemas_compare(dbms, data_generator, madf, mode, last_mode)
  decrease = 0
  increase = 0
  decrease_large = 0
  increase_large = 0
  adequate = 0

  schemas.each do |schema|
    scores = madf.raw_mutation_scores(schema, mode)
    last_scores = madf.raw_mutation_scores(schema, last_mode) unless last_mode.nil?

    adequate +=1 if mean(scores) == 1.0

    unless (last_mode.nil? || scores.length == last_scores.length)
      abort("* ERROR: scores arrays not equal in length")
    end

    unless last_mode.nil?
      sig = wilcox_test(scores, last_scores)
      a12 = a12_test(scores, last_scores)

      if !sig[:p_value].nil? && sig[:p_value] < 0.01
        if sig[:side] == 1
          decrease += 1
          decrease_large +=1 if a12[:size] == 'large'
        end
        if sig[:side] == 2
          increase += 1
          increase_large +=1 if a12[:size] == 'large'
        end
      end
    end

    puts "#{data_generator} #{mode} #{last_mode} #{dbms} #{schema} #{mode} #{last_mode} #{decrease} #{decrease_large} #{increase} #{increase_large}"
    puts "#{data_generator} #{mode} #{last_mode} #{dbms} #{schema} #{mode} #{last_mode} #{adequate}"
  end

  adequate_percen = f1dp(percen(adequate, num_schemas))

  data = ""
  data = "#{decrease} (#{decrease_large}) & #{increase} (#{increase_large}) & " unless last_mode.nil?
  data += "#{adequate} (#{adequate_percen}\\%) "

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
        line += "& \\multicolumn{1}{c}{-} & \\multicolumn{1}{c}{-} & "
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