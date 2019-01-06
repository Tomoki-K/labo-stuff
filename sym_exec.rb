require "digest"
require "open3"
require "./result"
require "./io_utils/reader"
require "./io_utils/writer"

RESULTCSV = "result.csv"

def main
  reader = Reader.new(RESULTCSV)
  mutants = reader.read_csv

  results = []
  klee_index = -1
  failure_count = 0
  mutants.each do |mutant|
    puts "\n===> #{mutant[:filename]}"
    bc_filename = mutant[:filename].split('/').last.gsub('.c', '.bc')
    begin
      # compile file to LLVM bitcode
      res, err = system_exec("wc #{mutant[:filename]}") # for testing
      # res, err = system_exec("clang -I ./klee_src/include -emit-llvm -c -g #{mutant[:filename]}") && system_exec("klee #{bc_filename}")
      raise err if !err.nil?
      klee_index += 1
      puts "compile to LLVM: success"

      # run klee test to generate hash
      hash = klee_test(klee_index)
      raise "hash generation failed" if hash.nil?
      puts "generate hash: success"

      mutant[:hash] = hash
      mutant[:mutant_type] = 'TRIVIAL'
    rescue => exception
      mutant[:mutant_type] = 'STILLBORN'
      puts "ERROR: #{exception.message}"
      failure_count += 1
    ensure
      results.push(mutant)
    end
  end

  # csv output
  writer = Writer.new(RESULTCSV)
  writer.write_csv(Result::HEADER, results)
  # console output
  puts "\n============="
  puts "success: #{mutants.length - failure_count} failure: #{failure_count}"
end

def klee_test(idx)
  begin
    klee_res = []
    k_base = "./test/klee-out-#{idx}"
    k_tests = Dir.glob('*.ktest', base: k_base).sort
    raise "no ktest files where found in #{k_base}" if k_tests.empty?
    k_tests.each do |test|
      filename = "#{k_base}/#{test}"
      res, err = system_exec("cat #{filename}") # for testing
      # res, err = system_exec("ktest-tool #{filename}")
      raise err if !err.nil?
      res.each_line do |line|
        klee_res.push(line) if line.include?("object")
      end
    end
    return Digest::SHA256.hexdigest(klee_res.join("\n"))
  rescue => exception
    puts "ERROR: #{exception.message}"
    return nil
  end
end

def system_exec(command)
  out, err, status = Open3.capture3(command)
  err = nil if status.exitstatus == 0
  return [out, err]
end

main
