# COMMON FUNCTIONS FOR PROCESSING DATA FILES
require 'csv'
require 'set'

module Mode
  ALL = 0
  MINUS_I = 1
  MINUS_IE = 2
  MINUS_IER = 3

  def modes
    [ALL, MINUS_I, MINUS_IE, MINUS_IER]
  end

  def modes_no_minus_i
    [ALL, MINUS_IE, MINUS_IER]
  end

  def modes_for_dbms(dbms)
    return Mode.modes_no_minus_i if dbms == 'HyperSQL' || dbms == 'Postgres'
    return Mode.modes if dbms == 'SQLite'
  end

  module_function :modes, :modes_no_minus_i, :modes_for_dbms
end

def data_generators
  %w(avmdefaults random)
end

def num_data_generators
  get_data_generators.length
end

def dbmses
  %w(HyperSQL Postgres SQLite)
end

def num_dbmses
  get_dbmses.length
end

def schemas
  %w(ArtistSimilarity
       ArtistTerm
       BankAccount
       BookTown
       BrowserCookies
       Cloc
       CoffeeOrders
       CustomerOrder
       DellStore
       Employee
       Examination
       Flights
       FrenchTowns
       Inventory
       Iso3166
       IsoFlav_R2
       iTrust
       JWhoisServer
       MozillaExtensions
       MozillaPermissions
       NistDML181
       NistDML182
       NistDML183
       NistWeather
       NistXTS748
       NistXTS749
       Person
       Products
       RiskIt
       StackOverflow
       StudentResidence
       UnixUsage
       Usda
       WordNet)
end

def num_schemas
  schemas.length
end

def latex_schema_name(name)
  name = 'Isoiii' if name == 'Iso3166'
  name = 'IsoFlav' if name == 'IsoFlav_R2'
  name = 'NistDMLi' if name == 'NistDML181'
  name = 'NistDMLii' if name == 'NistDML182'
  name = 'NistDMLiii' if name == 'NistDML183'
  name = 'NistXTSEight' if name == 'NistXTS748'
  name = 'NistXTSNine' if name == 'NistXTS749'
  name = "\\#{name}"
  return name
end

def operators
  # Removed FKCColumnPairA from this list
  %w(CCInExpressionRHSListExpressionElementR
       CCNullifier
       CCRelationalExpressionOperatorE
       FKCColumnPairE
       FKCColumnPairR
       NNCA
       NNCR
       PKCColumnA
       PKCColumnE
       PKCColumnR
       UCColumnA
       UCColumnE
       UCColumnR)
end

def latex_operator_name(operator_name)
  operators = {
    'CCInExpressionRHSListExpressionElementR' => 'CInListElementR',
    'CCNullifier' => 'CR',
    'CCRelationalExpressionOperatorE' => 'CRelOpE',
    'FKCColumnPairA' => 'FKColumnPairA',
    'FKCColumnPairE' => 'FKColumnPairE',
    'FKCColumnPairR' => 'FKColumnPairR',
    'NNCA' => 'NNA',
    'NNCR' => 'NNR',
    'PKCColumnA' => 'PKColumnA',
    'PKCColumnE' => 'PKColumnE',
    'PKCColumnR' => 'PKColumnR',
    'UCColumnA' => 'UColumnA',
    'UCColumnE' => 'UColumnE',
    'UCColumnR' => 'UColumnR'
  }
  name = "\\#{operators[operator_name]}"
  return name
end

def latex_name(name)
  return latex_schema_name(name) if schemas.include?(name)
  return latex_operator_name(name) if operators.include?(name)
  abort("* ERROR unknown name #{name}")
end

def path_to_data_dir(file)
  current_directory = File.dirname(__FILE__)
  "#{current_directory}/../../raw-data/#{file}"
end

def path_to_generated_data_dir(file)
  "./#{file}"
end

def unique_column_values(csv_file, position)
  values = Set.new

  first = true
  line = 0
  CSV.foreach(csv_file) do |row|
    if first
      # ignore header row
      first = false
    else
      value = row[position]
      values.add(value)
      puts line if value.nil?
      line += 1
    end
  end

  values_array = values.to_a
  values_array.sort
end

def output(file, line)
  puts line
  file.write(line)
  file.flush
end

def group_array(arr, num_per_group)
  groups = []
  offset = arr.length/num_per_group

  for i in 0..offset-1
    group = []
    for j in 0..num_per_group-1
      group << arr[i + (offset*j)]
    end
    groups << group
  end

  if arr.length % num_per_group != 0
    groups << [nil, arr.last]
  end

  groups
end