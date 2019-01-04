require "./reader.rb"

NULL_STRING = " "
mutation_trick = {
  " < ": [ " != ", " > ", " <= ", " >= ", " == " ],
  " > ": [ " != ", " < ", " <= ", " >= ", " == " ],
  "<=": [ " != ", " < ", " > ", " >= ", "==" ],
  ">=": [ " != ", " < ", " <= ", " > ", "==" ],
  "==": [ " != ", " = ", " < ", " > ", " <= ", " >= " ],
  "!=": [ " == ", " = ", " < ", " > ", " <= ", " >= " ],
  " = ": [ " == ", " != ", " < ", " > ", " <= ", " >= ", " = 0 * ", " = 0 ;//", " = NULL; //", " = ! " ],
  " + ": [ " - ", " * ", " / ", " % " ],
  " - ": [ " + ", " * ", " / ", " % " ],
  " * ": [ " + ", " - ", " / ", " % " ],
  " / ": [ " % ", " * ", " + ", " - " ],
  " % ": [ " / ", " + ", " - ", " * " ],
  " + 1": [ " - 1", "+ 0", "+ 2", "- 2" ],
  " - 1": [ " + 1", "+ 0", "+ 2", "- 2" ],
  " & ": [ " | ", " ^ " ],
  " | ": [ " & ", " ^ " ],
  " ^ ": [ " & ", " | " ],
  " ~": [ " !", NULL_STRING ],
  " !": [ " ~", NULL_STRING ],
  " && ": [ " & ", " || "," && !" ],
  " || ": [ " | ", " && ", " || !" ],
  " >> ": " << ",
  " << ": " >> ",
  " << 1": [ " << 0"," << -1", "<< 2" ],
  " >> 1": [ " >> 0", " >> -1", ">> 2" ],
  "++": "--",
  "--": "++",
  " true ": " false ",
  " false ": " true ",
  " int ": [" short int ", " char " ],
  " signed ": " unsigned ",
  " unsigned ": " signed ",
  " long ": [ " int ", " short int ", " char " ],
  " float ": " int ",
  " double ": " int ",
}

INPUTFILE = "./test/sample.c"

reader = Reader.new(INPUTFILE)
source_code = reader.read_lines
line_count = source_code.length

# try mutating random line
random_line = Random.rand(0..line_count)

# shuffle mutant operators
mutant_operators = mutation_trick.keys
mutant_operators.shuffle!

mutated_line = ""

source_code.each_with_index do |line, idx|
  # do not mutate preprocessor or assert statements
  next if line.strip.start_with?("#") || line.strip.start_with?("assert")

  mutant_operators.each do |mo|
    # search for mutatable substring
    mutatable_substring_count = line.scan(/(?=#{Regexp.quote(mo.to_s)})/).count
    next if mutatable_substring_count == 0

    # choose randomly if multiple substrings are found
    mutate_at_index = 0
    substring_index = Random.rand(1..mutatable_substring_count)
    for r in 1..substring_index do
      mutate_at_index = substring_index == 0 ? line.index(mo.to_s) : line.index(mo.to_s, mutate_at_index + 1)
    end

    # choose randomly if there are multiple ways of mutating the substring
    mutate_with = mutation_trick[mo].is_a?(String) ? mutation_trick[mo] : mutation_trick[mo].sample
    mutated_line = line[0..mutate_at_index - 1] + line[mutate_at_index..].sub(mo.to_s, mutate_with)

    # console output
    puts "\n==> @Line: #{idx + 1}:#{mutate_at_index}"
    puts "Original Line: #{line.strip}"
    puts "Mutated Line:  #{mutated_line.strip}"
  end
end

