require_relative 'include/common'
require_relative 'include/formatting'
require_relative 'include/analyse_pipeline_data_file'
require_relative 'include/r'

file_name = 'stillborn-mutants-time-by-schema.tex'
file = File.open(path_to_generated_data_dir(file_name), 'w')

apdf = AnalysePipelineDataFile.new

NA_STRING = '{\it n/a}'

schemas.each do |schema|
  line = "#{latex_name(schema)} "
  %w(HyperSQL Postgres).each do |dbms|
    pipelines = apdf.pipelines

    pipelines.each do |pipeline|
      times = apdf.stillborn_mutant_removal_times(dbms, schema, pipeline)
      mean = mean(times).round(0)
      sd = sd(times).round(0)

      mean = '\textless~1' if mean < 1
      sd = '\textless~1' if sd < 1

      line += "& #{mean} & #{sd} "
    end
  end
  line += "\\\\\n"
  output(file, line)
end

file.close