require_relative 'common'

class LiveMutantDataFiles

  def initialize
  end

  def live_mutant_hash
    live_mutants = {}
    operators.each do |operator|
      live_mutants[operator] = 0
    end
    return live_mutants
  end

  def live_mutants(schema, dbms, initial_live_mutants=nil)
    if initial_live_mutants.nil?
      live_mutants = live_mutant_hash
    else
      live_mutants = initial_live_mutants
    end

    path = path_to_data_dir("mutants/#{dbms}-alive/#{schema}/")
    if Dir.exists?(path)
      Dir.entries(path).each do |file|
        if file != '.' && file != '..'
          operator = File.foreach("#{path}#{file}").first.strip
          live_mutants[operator] += 1
        end
      end
    end

    return live_mutants
  end

  def live_mutant_operators
    live_mutants = live_mutant_hash
    dbmses.each do |dbms|
      schemas.each do |schema|
        live_mutants = live_mutants(schema, dbms, live_mutants)
      end
    end

    live_mutant_operators = []
    operators.each do |operator|
      live_mutant_operators << operator if live_mutants[operator] > 0
    end
    return live_mutant_operators
  end

  def live_mutant_schemas
    live_mutant_schemas = Set.new
    dbmses.each do |dbms|
      schemas.each do |schema|
        live_mutants_for_schema = live_mutants(schema, dbms)
        total = 0
        operators.each do |operator|
          total += live_mutants_for_schema[operator]
        end

        live_mutant_schemas << schema if total > 0
      end
    end

    live_mutant_schemas_alph = []
    schemas.each do |schema|
      live_mutant_schemas_alph << schema if live_mutant_schemas.include?(schema)
    end
    return live_mutant_schemas_alph
  end
end
