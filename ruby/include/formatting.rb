def f1dp(value)
  i = value.to_f
  i.round(1)
  sprintf('%.1f', i)
end

def percen(num, denom)
  return 100 * (num / denom.to_f)
end

def fmutscore(scores)
  numerators = []
  denominators = []
  decimal_scores = []

  scores.each do |score|
    numerators << score[:killed]
    denominators << score[:total]
    decimal_scores << score[:score]
  end
  mean_numerator = sprintf('%.1f', mean(numerators))
  mean_denominator = mean(denominators).round(0)
  mean_score = sprintf('%.1f', (mean(decimal_scores) * 100))

  #return "#{mean_score} & (#{mean_numerator}/#{mean_denominator})"
  mean_score
end

def frawmutscore(scores)
  sprintf('%.1f', (mean(scores) * 100))
end
