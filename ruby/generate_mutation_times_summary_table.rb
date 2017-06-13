require_relative 'include/common'
require_relative 'include/formatting'
require_relative 'include/r'
require_relative 'include/mutation_analysis_data_file'

def schemas_compare(dbms, data_generator, madf, mode, last_mode)
  decrease = 0
  increase = 0
  decrease_large = 0
  increase_large = 0

  schemas.each do |schema|
    times = madf.mutation_times(schema, mode)
    compare_times = madf.mutation_times(schema, last_mode)

    unless (last_mode.nil? || times.length == compare_times.length)
      abort("* ERROR: scores arrays not equal in length")
    end

    sig = wilcox_test(times, compare_times)
    a12 = a12_test(times, compare_times)

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
    puts "#{data_generator} #{mode} #{last_mode} #{dbms} #{schema} #{mode} #{last_mode} #{decrease} #{decrease_large} #{increase} #{increase_large}"
  end

  data = "#{decrease} & (#{decrease_large}) & #{increase} & (#{increase_large})"
  return data
end

# generate summary table
file_name = "mutation-times-summary.tex"
file = File.open(path_to_generated_data_dir(file_name), 'w')

dbmses.each do |dbms|

  line = "\\#{dbms} "

  data_generators.reverse_each do |data_generator|
    madf = MutationAnalysisDataFile.new(dbms, data_generator)

    last_mode = nil
    Mode::modes.each do |mode|

      unless mode == Mode::ALL

        if mode == Mode::MINUS_I && (dbms == 'HyperSQL' || dbms == 'Postgres')
          line += "& & &"
          next
        end

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