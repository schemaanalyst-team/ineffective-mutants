require_relative 'include/common'

def process_schema(dbms, schema, lines)
  puts "#{dbms} #{schema}"
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
        current_schema = line.partition("#{dbms},1,").last
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

