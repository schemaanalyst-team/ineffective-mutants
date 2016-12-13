require_relative 'common'

class IneffectiveMutantsDataFile
  TYPE_COL = 0
  SCHEMA_COL = 1
  OPERATOR_COL = 2

  EQUIVALENT = 'equivalent'
  REDUNDANT = 'redundant'
  QUASI = 'quasimutant'
  IMPAIRED = 'impaired'

  def initialize(dbms)
    @dbms = dbms
    @file_name = path_to_data_dir(file_name_minus_path)
  end

  def file_name_minus_path
    return "#{@dbms.downcase}-ineffective-mutants.dat"
  end

  def count_for(element)
    col = -1
    if schemas.include?(element)
      col = SCHEMA_COL
    elsif operators.include?(element)
      col = OPERATOR_COL
    else
      abort("* ERROR unknown element #{element}")
    end

    equivalent = 0
    redundant = 0
    quasi = 0
    impaired = 0

    CSV.foreach(@file_name) do |row|
      if row[col] == element
        equivalent += 1 if row[TYPE_COL] == EQUIVALENT
        redundant += 1 if row[TYPE_COL] == REDUNDANT
        quasi += 1 if row[TYPE_COL] == QUASI
        impaired += 1 if row[TYPE_COL] == IMPAIRED
      end
    end

    return {
      equivalent: equivalent,
      redundant: redundant,
      quasi: quasi,
      impaired: impaired
    }
  end
end

