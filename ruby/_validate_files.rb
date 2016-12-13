require_relative 'include/common'
require_relative 'include/analyse_pipeline_data_file'
require_relative 'include/ineffective_mutant_types_data_file'
require_relative 'include/mutation_analysis_data_file'

# checks quasi mutants identified via the DBMS and DBMS-transacted match those identified by the static analysis
def validate_quasis(apdf)
  dbmses.each do |dbms|
    schemas.each do |schema|
      puts "validating quasi data for #{schema} for #{dbms}"
      quasi_mutants = apdf.quasi_mutants_for_schema(dbms, schema)
      quasi_mutants_transacted = apdf.quasi_mutants_for_schema(dbms, schema, true)

      imdf = IneffectiveMutantsDataFile.new(dbms)
      mutants = imdf.count_for(schema)

      unless (quasi_mutants == quasi_mutants_transacted && quasi_mutants == mutants[:quasi])
        puts "FAILED when checking #{schema} with #{dbms} ... " +
          "#{quasi_mutants} - #{quasi_mutants_transacted} - #{mutants[:quasi]}"
      end
    end
  end
end

apdf = AnalysePipelineDataFile.new()

puts "validating analyse-pipeline.dat file ..."
apdf.validate(true)

puts "validating quasi mutant data ..."
validate_quasis(apdf)

puts "validating mutation analysis data files ..."
MutationAnalysisDataFile.validate_all

