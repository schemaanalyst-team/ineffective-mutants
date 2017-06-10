require_relative 'include/common'
require_relative 'include/formatting'
require_relative 'include/analyse_pipeline_data_file'
require_relative 'include/ineffective_mutant_types_data_file'

def get_data_for_element(element, dbms, produced, quasi, impaired, equivalent, redundant)
  line = element + ' '
  line = ' ' * line.length unless dbms == 'Postgres'

  line += "& " + dbms[0,1] + " "
  line += "& #{produced} "
  line += "& #{quasi} "
  line += "& #{impaired} "
  line += "& #{equivalent} "
  line += "& #{redundant} "

  effective = produced - quasi - impaired - equivalent - redundant
  ineffective = produced - effective

  line += "& #{ineffective} "
  line += "& #{effective} "

  reduction = f1dp(percen(produced-effective, produced))

  line += "& #{reduction} "

  return line
end

def generate_table(elements, file_name, elements_per_line)
  file = File.open(path_to_generated_data_dir(file_name), 'w')

  apdf = AnalysePipelineDataFile.new

  total_produced = Hash.new
  total_quasi = Hash.new
  total_impaired = Hash.new
  total_equivalent = Hash.new
  total_redundant = Hash.new

  dbmses.each do |dbms|
    total_produced[dbms] = 0
    total_quasi[dbms] = 0
    total_impaired[dbms] = 0
    total_equivalent[dbms] = 0
    total_redundant[dbms] = 0
  end

  elements.each do |element|
    dbmses.each do |dbms|
      line = ''
      element.each do |subelement|
        line += '&& ' unless line == ''

        if subelement.nil?
          line += '\multicolum{9}{c}{} '
        else
          # get data
          produced = apdf.mutants_produced(dbms, subelement)
          imdf = IneffectiveMutantsDataFile.new(dbms)
          mutants = imdf.count_for(subelement)

          line += get_data_for_element(latex_name(subelement), dbms, produced,
                mutants[:quasi], mutants[:impaired],
                mutants[:equivalent], mutants[:redundant])

          total_produced[dbms] += produced
          total_quasi[dbms] += mutants[:quasi]
          total_impaired[dbms] += mutants[:impaired]
          total_equivalent[dbms] += mutants[:equivalent]
          total_redundant[dbms] += mutants[:redundant]
        end
      end

      line += "\\\\\n"
      output(file, line)
    end

    hhline = ''
    element.each do |subelement|

      hhline += '~' unless hhline == ''

      if subelement.nil?
        hhline += '~~~~~~~~~~'
      else
        hhline += '----------'
      end
    end

    output(file, "\\hhline{#{hhline}}\n")
  end

  hhline = ('~~~~~~~~~~~' * (elements_per_line-1)) + '----------'
  output(file, "\\hhline{#{hhline}}\n")

  dbmses.each do |dbms|
    line = '\multicolumn{11}{c}{} & ' * (elements_per_line - 1)
    line += get_data_for_element('Total', dbms, total_produced[dbms],
          total_quasi[dbms], total_impaired[dbms],
          total_equivalent[dbms], total_redundant[dbms])
    line += "\\\\\n"
    output(file, line)
  end
  file.close
end

puts "Writing mutants for individual schemas ..."
schemas_per_line = 2
generate_table(group_array(schemas, schemas_per_line), 'mutants-by-schema.tex', schemas_per_line)

puts "Writing mutants for individual operators..."
operators_per_line = 1
generate_table(group_array(operators, operators_per_line), 'mutants-by-operator.tex', operators_per_line)


