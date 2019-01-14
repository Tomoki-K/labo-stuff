require "./result"
require "./mutation_patterns"
require "./io_utils/reader"
require "./io_utils/writer"

INPUTFILE = ARGV[0] || ENV['ROOT'] + "/test/sample.c"
OUTPUTDIR = ARGV[1] || ENV['ROOT'] + "/results/mutants"
OUTPUTCSV = ARGV[2] || ENV['ROOT'] + "/results/summary.csv"

def main
  reader = Reader.new(INPUTFILE)
  source_code = reader.read_lines

  result = [Result::create_result_hash(0, INPUTFILE, "ORIGINAL")]
  mutant_count = 1
  source_code.each_with_index do |line, line_num|
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
          mutant_info = [
            "==> @Line: #{line_num}:#{mutate_at_index} type: #{mutation[:type]}",
            "Original Line: #{line.strip}",
            "Mutated Line : #{mutated_line.strip}"
          ]
          filename= "#{OUTPUTDIR}/mutant_#{mutant_count}.c"
          result.push(Result::create_result_hash(mutant_count, filename, mutation[:type]))
          create_mutant(filename, source_code, line_num, mutated_line, mutant_info)
          mutant_count += 1
        end
      end
    end
  end
  # csv output
  writer = Writer.new(OUTPUTCSV)
  writer.write_csv(Result::HEADER, result)
  # console output
  puts "\n====== SUMMARY ======="
  puts "#{mutant_count - 1} mutants generated"
end

def create_mutant( filename, source_code, line_num, mutated_line, comment = [] )
  content = []
  content = comment.map{|line| "// #{line}"}
  content += [ "" ]
  content += source_code[0..line_num - 1]
  content += [ mutated_line ]
  content += source_code[line_num + 1..]

  writer = Writer.new(filename)
  writer.write(content)
  # console output
  puts "\n#{filename}"
  puts comment
end

main