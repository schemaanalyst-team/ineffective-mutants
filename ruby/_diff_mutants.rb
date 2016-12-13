require_relative 'include/common'

def get_header(file)
  header = ''
  File.foreach(file).first(3).each do |line|
    header += line
  end
  return header
end

def get_file_contents(file)
  return File.open(file, 'rb') { |file| file.read }
end

def compare(files1, files2, path1, path2, dbms)
  files1.each do |file1|
  file1_header = get_header("#{path1}/#{file1}")

  found_match = false
  files2.each do |file2|
    file2_header = get_header("#{path2}/#{file2}")
    if file1_header == file2_header
      found_match = true
      break
    end
  end

  unless found_match
    puts '================='
    puts "#{dbms} #{file1}:"
    puts '================='
    puts get_file_contents("#{path1}/#{file1}")
  end
end


end

if ARGV.length < 3
  puts "USAGE: ruby diff_mutants.rb dbms1 dbms2 subject [live]"
  abort
end

dbms1 = ARGV[0]
dbms2 = ARGV[1]
subject = ARGV[2]
type = ARGV.length > 3 ? ARGV[3] : ''

dir = (type == 'live') ? '-avmdefaults-alive' : '-minus-stillborn'
dir += "/#{subject}"

dbms1_path = path_to_data_dir('mutants/' + dbms1.downcase + dir)
dbms2_path = path_to_data_dir('mutants/' + dbms2.downcase + dir)

puts "Comparing:"
puts "  -- #{dbms1_path}"
puts "  -- #{dbms2_path}"

dbms1_files = Dir.entries(dbms1_path).reject {|f| File.directory?(f) || f[0].include?('.')}
dbms2_files = Dir.entries(dbms2_path).reject {|f| File.directory?(f) || f[0].include?('.')}

compare(dbms1_files, dbms2_files, dbms1_path, dbms2_path, dbms1)
compare(dbms2_files, dbms1_files, dbms2_path, dbms1_path, dbms2)