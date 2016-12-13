require_relative 'include/overview_file'
require_relative 'include/formatting'
require_relative 'include/r'

file_name = 'test-suite-factors.tex'
file = File.open(path_to_generated_data_dir(file_name), 'w')

of = OverviewFile.new

schemas.each do |schema|
  line = "#{latex_name(schema)} "

  dbmses.each do |dbms|
    data_generators.each do |data_generator|
      stats = of.get_coverage_and_test_suite_size(schema, dbms, data_generator)

      coverage = f1dp(mean(stats[:coverage]))
      num_tests = f1dp(mean(stats[:num_tests]))

      line += "& #{coverage} & #{num_tests} "
    end
  end

  line += "\\\\\n"
  output(file, line)
end

file.close