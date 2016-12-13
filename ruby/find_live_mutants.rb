require_relative 'include/common'

$handled = []
$data = {}

def find_live(file_name)
  first_row = true
  identifier = ''
  schema = ''

  count = 1

  CSV.foreach(file_name) do |row|
    # ignore the first row
    if first_row
      first_row = false
      next
    end

    if identifier != row[0]
      identifier = row[0]
      count = 1
      if schema != '' && !$handled.include?(schema)
        $handled << schema
      end
      schema = row[2]
    else
      count += 1
    end

    if row[4] == 'NORMAL'
      $data[schema] = [] unless $data.key? schema

      if !$handled.include?(schema) && row[5] == 'false'
        $data[schema] << count unless $data[schema].include?(count)
      end

      if row[5] == 'true' # => && $data[schema].include?(count)
        if count == 412
          puts row
        end
        $data[schema].delete(count)
      end
    end

  end
end

find_live(path_to_data_dir("#{ARGV[0]}-avmdefaults.dat"))
find_live(path_to_data_dir("#{ARGV[0]}-random.dat"))

out = "schema,ids\n"
$data.each do |key, array|
  if array.size > 0
    out += "#{key},\"#{array.join(',')}\"\n"
  end
end
puts out

