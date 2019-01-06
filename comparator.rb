require './result'
require "./io_utils/reader"
require "./io_utils/writer"

RESULTCSV = "result.csv"

reader = Reader.new(RESULTCSV)
mutants = reader.read_csv

original_hash = mutants[0][:hash]
counter = {}

# compare each hash to original hash
mutants[1..].each do |mutant|
  # mark EQUIVALENT if matched
  if mutant[:hash] == original_hash then
    mutant[:mutant_type] = "EQUIVALENT"
  end

  type = mutant[:mutant_type]
  counter.key?(type) ? counter[type] += 1 : counter[type] = 1
end

# console output
puts "\n====== SUMMARY ======="
counter.each do |k, v|
  puts "#{k}: #{v}"
end


out = Writer.new(RESULTCSV)
out.write_csv(Result::HEADER, mutants)
