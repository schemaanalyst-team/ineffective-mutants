require_relative 'include/common'

# A script to select mutants to check at random

NUM_MUTANTS = 100

for i in 1..NUM_MUTANTS
  schema = schemas[rand(schemas.length)]
  schema = 'IsoFlav_R2Repaired' if schema == 'IsoFlav_R2'

  dbms = dbmses[rand(dbmses.length)]

  dir = "mutants/#{dbms.downcase}-minus-stillborn/#{schema}/"
  path = path_to_data_dir(dir)

  files = Dir.entries(path)
  last_mutant = 0
  files.each do |file|
    mutant_no = file.to_i
    last_mutant = mutant_no if mutant_no > last_mutant
  end

  mutant = rand(last_mutant) + 1

  puts "#{i}: #{dbms} #{schema} #{mutant} (#{dir}#{mutant})"
end