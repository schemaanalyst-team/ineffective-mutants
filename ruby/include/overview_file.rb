require_relative 'common'

# Note that "parsecasestudy." may need removing from the file
# for this to work properly....

class OverviewFile

  DBMS_COL = 0
  SCHEMA_COL = 1
  DATA_GENERATOR_COL = 3
  COVERAGE_COL = 6
  NUM_TESTS_COL = 8
  PIPELINE_COL = 9

  PIPELINE_OF_INTEREST = 'AllOperatorsNoFKANormalisedWithClassifiers'

  NUM_RUNS = 30

  def initialize()
    @file_name = path_to_data_dir(file_name_minus_path)
  end

  def file_name_minus_path
    'mutation-analysis.dat'
  end

  def get_coverage_and_test_suite_size(schema, dbms, data_generator)
    data_generator = 'avsDefaults' if data_generator == 'avmdefaults'
    coverage = []
    num_tests = []

    CSV.foreach(@file_name) do |row|
      if row[DBMS_COL] == dbms &&
          row[SCHEMA_COL] == schema &&
          row[DATA_GENERATOR_COL] == data_generator &&
          row[PIPELINE_COL] == PIPELINE_OF_INTEREST

        coverage << row[COVERAGE_COL].to_i
        num_tests << row[NUM_TESTS_COL].to_i
      end
    end

    return {
      coverage: coverage,
      num_tests: num_tests
    }
  end

  def validate
    schemas.each do |schema|
      dbmses.each do |dbms|
        data_generators.each do |data_generator|
          stats = get_coverage_and_test_suite_size(schema, dbms, data_generator)
          runs = stats[:coverage].length
          if runs != NUM_RUNS
            puts "* WARNING: num runs for #{schema}, #{dbms}, #{data_generator} is only #{runs}"
          end
        end
      end
    end
  end
end
