require "./io_utils/reader"
require "./io_utils/writer"

RESULTCSV = "result.csv"
# HEADER = [:name, :hash, :is_em]
HEADER = [:id, :filename, :operator, :hash, :mutant_type]

reader = Reader.new(RESULTCSV)
results = reader.read_csv

new_results = [results[0]]
original_hash = results[0][:hash]
results[1..].each do |res|
  new_result_hash = {
    name: res[:name],
    hash: res[:hash],
    is_em: res[:hash] == original_hash
  }
  new_results.push(new_result_hash)
end

out = Writer.new(RESULTCSV)
out.write_csv(HEADER, new_results)
