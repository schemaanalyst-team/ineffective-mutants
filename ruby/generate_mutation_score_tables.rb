require_relative 'include/common'
require_relative 'include/formatting'
require_relative 'include/r'
require_relative 'include/mutation_analysis_data_file'

def format_score(scores, last_scores)
  text = ''

  unless last_scores.nil?
    sig = wilcox_test(scores, last_scores)

    if !sig[:p_value].nil? && sig[:p_value] < 0.01
      a12 = a12_test(scores, last_scores)
      text += '$\star$ ' if a12[:size] == 'large'
      text += '$\APLdown$ ' if sig[:side] == 1
      text += '$\APLup$ ' if sig[:side] == 2
    end
  end

  text += " " + frawmutscore(scores)

  return text
end


def generate_table(data_generator)
  file_name = "mutation-scores-by-schema-#{data_generator}.tex"
  file = File.open(path_to_generated_data_dir(file_name), 'w')

  schemas.each do |schema|

    line = "#{latex_name(schema)} "
    dbmses.each do |dbms|

      madf = MutationAnalysisDataFile.new(dbms, data_generator)
      last_scores = nil

      Mode.modes_for_dbms(dbms).each do |mode|
        scores = madf.raw_mutation_scores(schema, mode)
        line += ' & ' + format_score(scores, last_scores)
        last_scores = scores
      end
    end

    line += "\\\\\n"
    output(file, line)
  end

  file.close
end

#def compare(scores, last_scores)
#  change = 0
#  adequate = 0
#
#  for i in 0..scores.length-1
#    change +=1 unless last_scores.nil? || scores[i][:score] == last_scores[i][:score]
#    adequate +=1 if scores[i][:score] == 1
#  end
#
#  return {
#    change: change,
#    adequate: adequate
#  }
#end
#
#def schemas_compare(madf, mode, last_mode)
#  change = 0
#  adequate = 0
#  number = 0
#
#  schemas.each do |schema|
#    scores = madf.mutation_scores(schema, mode)
#    last_scores = nil
#    last_scores = madf.mutation_scores(schema, last_mode) unless last_mode.nil?
#
#    unless (last_mode.nil? || scores.length == last_scores.length)
#      abort("* ERROR: scores arrays not equal in length")
#    end
#
#    result = compare(scores, last_scores)
#
#    change += result[:change]
#    adequate += result[:adequate]
#    number += scores.length
#  end
#
#  return {
#    change: change,
#    adequate: adequate,
#    number: number
#  }
#end

# generate big table for each data generator
data_generators.each do |data_generator|
  generate_table(data_generator)
end

# generate summary table
#file_name = "mutation-scores-summary.tex"
#file = File.open(path_to_generated_data_dir(file_name), 'w')
#
#dbmses.each do |dbms|
#
#  line = "#{dbms} "
#
#  data_generators.each do |data_generator|
#
#    last_mode = nil
#    Mode::modes.each do |mode|
#
#      if mode == Mode::MINUS_I && (dbms == 'HyperSQL' || dbms == 'Postgres')
#        line += ' & & '
#        next
#      end
#
#      madf = MutationAnalysisDataFile.new(dbms, data_generator)
#      result = schemas_compare(madf, mode, last_mode)
#
#      change_percen = f1dp(percen(result[:change], result[:number]))
#      adequate_percen = f1dp(percen(result[:adequate], result[:number]))
#
#      line += "& #{change_percen} " unless mode == Mode::ALL
#      line += "& #{adequate_percen} "
#
#      last_mode = mode
#    end
#  end
#
#  line += "\\\\\n"
#  output(file, line)
#end
#
#file.close