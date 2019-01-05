require "./reader.rb"
require "./writer"

INPUTFILE = ARGV[0] || "result.csv"
OUPUTFILE = ARGV[1] || "result.csv"
HEADER = [:name, :hash, :is_em]

reader = Reader.new(INPUTFILE)
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

out = Writer.new(OUPUTFILE)
out.write_csv(HEADER, new_results)
