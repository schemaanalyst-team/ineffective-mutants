#
# SHOWS THE NUMBER OF DISTINCT RUNS IN EACH
# OF THE MUTATION ANALYSIS FILES
#

require_relative "include/mutation_analysis_data_file"

dbmses.each do |dbms|
  data_generators.each do |data_generator|
    file = MutationAnalysisDataFile.new(dbms, data_generator)
    num_runs = file.num_runs
    puts "#{file.file_name_minus_path}: #{num_runs}"
  end
end