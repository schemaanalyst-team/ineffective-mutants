require_relative 'include/common'
require_relative 'include/formatting'
require_relative 'include/analyse_pipeline_data_file'
require_relative 'include/ineffective_mutant_types_data_file'

file = File.open(path_to_generated_data_dir('mutant-type-by-schema-totals.tex'), 'w')

dbmses.each do |dbms|

  total_quasi = 0
  total_impaired = 0
  total_equivalent = 0
  total_redundant = 0

  imdf = IneffectiveMutantsDataFile.new(dbms)

  schemas.each do |schema|
    mutants = imdf.count_for(schema)

    total_quasi += 1 if mutants[:quasi] > 0
    total_impaired +=1 if mutants[:impaired] > 0
    total_equivalent +=1 if mutants[:equivalent] > 0
    total_redundant +=1 if mutants[:redundant] > 0

  end

  output(file, "#{dbms} & #{total_quasi} & #{total_impaired} & #{total_equivalent} & #{total_redundant} \\\\\n")

end
