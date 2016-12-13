require_relative 'include/live_mutant_data_files'

file_name = 'live-mutants-summary.tex'
file = File.open(path_to_generated_data_dir(file_name), 'w')

lmdf = LiveMutantDataFiles.new

line = "\\begin{tabular}{l"
lmdf.live_mutant_operators.each do |operator|
  line += 'r@{~}r@{~}r'
end
line += "r@{~}r@{~}r}\n"
output(file, line)

line = ''
lmdf.live_mutant_operators.each do |operator|
  line += "& \\rotlowtb{\\bf #{latex_name(operator)}} "
end
line += "& \\multicolumn{3}{c}{\\bf Total} "
line += "\\\\\n"
output(file, line)

line = "{\\bf Schema} "
lmdf.live_mutant_operators.each do |operator|
  line += '& H & P & S '
end
line += '& H & P & S '
line += "\\\\\n"
output(file, line)

operator_totals_h = lmdf.live_mutant_hash
operator_totals_p = lmdf.live_mutant_hash
operator_totals_s = lmdf.live_mutant_hash

line = "\\hline\n"
output(file, line)

lmdf.live_mutant_schemas.each do |schema|
  line = "#{latex_name(schema)} "

  live_mutants_h = lmdf.live_mutants(schema, 'HyperSQL')
  live_mutants_p = lmdf.live_mutants(schema, 'Postgres')
  live_mutants_s = lmdf.live_mutants(schema, 'SQLite')

  total_h = 0
  total_p = 0
  total_s = 0

  lmdf.live_mutant_operators.each do |operator|

    line += "& #{live_mutants_h[operator]} "
    line += "& #{live_mutants_p[operator]} "
    line += "& #{live_mutants_s[operator]} "

    total_h += live_mutants_h[operator]
    total_p += live_mutants_p[operator]
    total_s += live_mutants_s[operator]

    operator_totals_h[operator] += live_mutants_h[operator]
    operator_totals_p[operator] += live_mutants_p[operator]
    operator_totals_s[operator] += live_mutants_s[operator]
  end

  line += "& #{total_h} "
  line += "& #{total_p} "
  line += "& #{total_s} "

  line += "\\\\\n"
  output(file, line)
end

line = "\\hline\n"
output(file, line)

line = 'Total '
total_h = 0
total_p = 0
total_s = 0
lmdf.live_mutant_operators.each do |operator|
  line += "& #{operator_totals_h[operator]} "
  line += "& #{operator_totals_p[operator]} "
  line += "& #{operator_totals_s[operator]} "

  total_h += operator_totals_h[operator]
  total_p += operator_totals_p[operator]
  total_s += operator_totals_s[operator]
end

line += "& #{total_h} "
line += "& #{total_p} "
line += "& #{total_s} "

line += "\\\\\n"
output(file, line)

line = "\\hline\n"
output(file, line)

line = "\\end{tabular}"
output(file, line)

file.close
