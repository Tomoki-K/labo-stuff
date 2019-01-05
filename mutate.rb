require "./mutation_patterns.rb"
require "./reader.rb"
require 'pry'

INPUTFILE = "./test/sample.c"

reader = Reader.new(INPUTFILE)
source_code = reader.read_lines

mutated_line = ""
source_code.each_with_index do |line, idx|
  # do not mutate preprocessor or assert statements
  next if line.strip.start_with?("#") || line.strip.start_with?("assert")

  MUTATION_PATTERNS.each do |pattern, mutations|
    # search for mutatable substring
    mutatable_substring_count = line.scan(/(?=#{Regexp.quote(pattern.to_s)})/).count
    next if mutatable_substring_count == 0

    # mutate each substring if multiple are found
    mutate_at_index = 0
    for r in 1..mutatable_substring_count do
      mutate_at_index = line.index(pattern.to_s, mutate_at_index == 0 ? 0 : mutate_at_index + 1)

      # create mutant for each way of mutating the substring
      mutations.each do |mutation|
        mutated_line = line[0..mutate_at_index - 1] + line[mutate_at_index..].sub(pattern.to_s, mutation[:substring])
        # TODO: create mutant
        puts "\n==> @Line: #{idx + 1}:#{mutate_at_index} type: #{mutation[:type]}"
        puts "Original Line: #{line.strip}"
        puts "Mutated Line : #{mutated_line.strip}"
      end
    end
  end
end

