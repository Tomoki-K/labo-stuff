require "csv"

class Writer
  def initialize(output_file, header)
    @output_file = output_file
    @header = header
  end

  def get_header_ordered_array(row_hash)
    row_array = []
    @header.each do |col|
      row_array.push(row_hash[col.to_sym])
    end
    row_array
  end

  def write_csv(results_arr)
    CSV.open(@output_file, 'w') do |csv|
      csv << @header
      results_arr.each do |result|
        csv << get_header_ordered_array(result)
      end
      csv.close
    end
  end
end