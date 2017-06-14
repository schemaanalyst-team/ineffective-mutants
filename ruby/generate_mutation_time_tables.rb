require_relative 'include/common'
require_relative 'include/formatting'
require_relative 'include/r'
require_relative 'include/mutation_analysis_data_file'

def ftimes(times, compare_times = nil)
  mean_time = mean(times).round
  formatted_mean_time = mean_time.to_s #sprintf('%.1f', mean_time)

  if !compare_times.nil?
    sig = wilcox_test(times, compare_times)
    if !sig[:p_value].nil? && sig[:p_value] < 0.01
      markup = ''
      markup = '$\APLdown$' if sig[:side] == 1
      markup = '$\APLup$' if sig[:side] == 2

      a12 = a12_test(times, compare_times)
      stars = ''
      stars = '$\star$' if a12[:size] == 'large'
      #stars = '***' if a12[:size] == 'large'
      #stars = '**' if a12[:size] == 'medium'
      #stars = '*' if a12[:size] == 'small'

      formatted_mean_time = stars + " " + markup + " #{formatted_mean_time}"
    end
  end

  return formatted_mean_time
end

def generate_table(data_generator)
  file_name = "mutation-times-by-schema-#{data_generator}.tex"
  file = File.open(path_to_generated_data_dir(file_name), 'w')

  schemas.each do |schema|

    line = "#{latex_name(schema)} "
    dbmses.each do |dbms|

      madf = MutationAnalysisDataFile.new(dbms, data_generator)

      last_times = nil
      Mode.modes_for_dbms(dbms).each do |mode|
        times = madf.mutation_times(schema, mode)
        line += ' & ' + ftimes(times, last_times)
        last_times = times
      end
    end

    line += "\\\\\n"
    output(file, line)
  end

  file.close
end

def generate_summary_table()
  file_name = "mutation-times-summary.tex"
  file = File.open(path_to_generated_data_dir(file_name), 'w')

  dbmses.each do |dbms|
    line = "#{dbms} "

    data_generators.each do |data_generator|
      madf = MutationAnalysisDataFile.new(dbms, data_generator)

      last_times = nil

      Mode.modes.each do |mode|

        if mode == Mode::MINUS_I && (dbms == 'HyperSQL' || dbms == 'Postgres')
          line += ' & '
          next
        end

        first = true
        times = []
        schemas.each do |schema|
          schema_times = madf.mutation_times(schema, mode)

          if first
            times = Array.new(schema_times.length, 0)
            first = false
          end

          for i in 0..schema_times.length-1
            times[i] += schema_times[i]
          end
        end

        line += ' & ' + ftimes(times, last_times)
        last_times = times
      end
    end

    line += "\\\\\n"
    output(file, line)
  end

  file.close
end

data_generators.each do |data_generator|
  generate_table(data_generator)
end

#generate_summary_table