require_relative 'include/common'

def lookup_operator(dbms, schema, descriptor)
  dir = "../manual-tests/src/paper/ineffectivemutants/manualevaluation/mutants/#{schema}_#{dbms}"
  if Dir.exist?(dir)
    Dir.entries(dir).each do |file|
      if file != '.' && file != '..' && file != '0.sql'
        lines = File.read("#{dir}/#{file}").lines
        operator = lines[1].slice(3, lines[1].length).strip
        description = lines[2].slice(3, lines[2].length).strip

        if descriptor == description
          return operator
        end
      end
    end
    return 'MUTANT-DID-NOT-EXIST'
  else
    return 'MUTANTS-DO-NOT-EXIST'
  end
end

data_points = []

def process_schema(dbms, schema, lines, data_points)
  total = 0
  list = lines.split(/\n/)
  list.each_with_index do |line, i|
    if line == 'FINE: Redundant mutant pair:'
      operator1 = lookup_operator(dbms, schema, list[i+1])
      operator2 = lookup_operator(dbms, schema, list[i+2])
      total += 1
      data_points << [dbms, operator1, operator2]
      #puts "#{dbms}, #{schema}, #{operator1}, #{operator2}"
    end
  end
  #puts "#{dbms}, #{schema}, #{total}"
end

def find_total(data_points, dbms, operator1, operator2)
  total = 0
  data_points.each do |data_point|
    if data_point[0] == dbms && data_point[1] == operator1 && data_point[2] == operator2
      total += 1
    end
  end
  return total.to_s
end

# get data
dbmses.each do |dbms|
  file = path_to_data_dir("mutants/logs/#{dbms}DBMS")
  File.open(file) do |file|
    current_schema = ''
    current_lines = ''
    file.each do |line|
      if line.start_with?("#{dbms},1,")
        process_schema(dbms, current_schema, current_lines, data_points) unless current_schema == ''
        current_schema = line.partition("#{dbms},1,").last.strip
        current_lines = ''
      elsif line.start_with?("#{dbms},2,")
        process_schema(dbms, current_schema, current_lines, data_points) unless current_schema == ''
        break
      else
        current_lines += line
      end
    end
  end
end



rows = []
cols = []

data_points.each do |data_point|
  operator = data_point[1]
  rows << operator unless rows.include?(operator)
end

data_points.each do |data_point|
  operator = data_point[2]
  cols << operator unless cols.include?(operator)
end

rows = rows.sort
cols = cols.sort

table = '%'
table += ' & '
cols.each do |col|
  table += ' & '
  table += col
end
table += '\\\\'
table += "\n"

rows.each do |row|
  dbmses.each_with_index do |dbms, i|
    table += row if i == 1
    table += ' & '
    table += dbms[0]

    cols.each do |col|
      table += ' & '
      table += find_total(data_points, dbms, row, col)
    end
    table += '\\\\'
    table += "\n"
  end
  table += "\\hline\n"
end

file = File.open(path_to_generated_data_dir('redundant-mutant-pairs.tex'), 'w')
output(file, table)
file.close


