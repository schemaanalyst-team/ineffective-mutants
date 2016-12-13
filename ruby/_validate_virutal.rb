require_relative 'include/common'

VM_DIR = File.dirname(__FILE__) + '/../../transformed-virtual-files/'
NORMAL_FILE = File.dirname(__FILE__) + '/../../transformed-files/mutation-analysis.dat'

def get_scores(file, dbms, schema, search='avsDefaults')
  numerators = []
  denominators = []

  CSV.foreach(file) do |row|
    if row[0] == dbms && row[1] == schema && row[3] == search
      numerators << row[10]
      denominators << row[11]
    end
  end

  return {numerators: numerators, denominators: denominators}
end

dbmses.each do |dbms|

  puts "Doing #{dbms}"

  schemas.each do |schema|

    vm_file = "#{VM_DIR}30-#{dbms}-all-mutationanalysis.dat"
    vm_results = get_scores(vm_file, dbms, schema)

    norm_results = get_scores(NORMAL_FILE, dbms, schema)

    if vm_results != norm_results
      puts "Results not equal for #{schema}"
      puts vm_results
      puts norm_results
    end
  end

end