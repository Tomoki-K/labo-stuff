require "csv"
require "fileutils"

class Writer
  def initialize(output_file)
    dirname = File.dirname(output_file)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end
    @output_file = output_file
  end

  def get_header_ordered_array(header, row_hash)
    row_array = []
    header.each do |col|
      row_array.push(row_hash[col.to_sym])
    end
    row_array
  end

  def write_csv(header, results_arr)
    CSV.open(@output_file, 'w') do |csv|
      csv << header
      results_arr.each do |result|
        csv << get_header_ordered_array(header, result)
      end
      csv.close
    end
  end

  def write(content_array)
    File.open(@output_file, 'w') do |f|
      f.puts(content_array)
    end
  end
end