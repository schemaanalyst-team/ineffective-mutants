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
    puts "#{dbms} #{schema}"
    return 'MUTANTS-DO-NOT-EXIST'
  end
end

def process_schema(dbms, schema, lines)
  total = 0
  list = lines.split(/\n/)
  list.each_with_index do |line, i|
    if line == 'FINE: Redundant mutant pair:'
      operator1 = lookup_operator(dbms, schema, list[i+1])
      operator2 = lookup_operator(dbms, schema, list[i+2])
      total += 1      
      #puts "#{dbms}, #{schema}, #{operator1}, #{operator2}"    
    end
  end
  #puts "#{dbms}, #{schema}, #{total}"
end

# get data
dbmses.each do |dbms|
  file = path_to_data_dir("mutants/logs/#{dbms}DBMS")
  File.open(file) do |file|
    current_schema = ''
    current_lines = ''
    file.each do |line|
      if line.start_with?("#{dbms},1,")
        process_schema(dbms, current_schema, current_lines) unless current_schema == ''
        current_schema = line.partition("#{dbms},1,").last.strip
        current_lines = ''
      elsif line.start_with?("#{dbms},2,")
        process_schema(dbms, current_schema, current_lines) unless current_schema == ''
        break
      else
        current_lines += line
      end
    end
  end
end

