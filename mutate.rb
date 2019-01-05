require "./mutation_patterns.rb"
require "./reader.rb"
require "./writer.rb"

INPUTFILE = "./test/sample.c"
OUTPUTDIR = "./test/mutants"

def main
  reader = Reader.new(INPUTFILE)
  source_code = reader.read_lines

  mutant_count = 0
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
            "==> @Line: #{line_num + 1}:#{mutate_at_index} type: #{mutation[:type]}",
            "Original Line: #{line.strip}",
            "Mutated Line : #{mutated_line.strip}"
          ]
          create_mutant("#{OUTPUTDIR}/mutant_#{mutant_count}.c",
                        source_code, line_num, mutated_line, mutant_info)
          mutant_count += 1
        end
      end
    end
  end
  puts "\n============="
  puts "#{mutant_count} mutants generated"
end

def create_mutant( filename, source_code, line_num, mutated_line, comment = [] )
  source_code[line_num] = mutated_line
  content = []
  content = comment.map{|line| "// #{line}"}
  content += [ "" ]
  content += source_code
  writer = Writer.new(filename)
  writer.write(content)
  # console output
  puts "\n#{filename}"
  puts comment
end

main