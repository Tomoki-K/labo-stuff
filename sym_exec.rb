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
      res, err = system_exec("clang -I ./klee_src/include -emit-llvm -c -g #{mutant[:filename]}")
      # res, err = system_exec("wc #{mutant[:filename]}") # for testing
      checkpoint('compile to LLVM', err.nil?)

      # run KLEE on the bitcode file to generate ktest cases
      res, err = system_exec("klee #{bc_filename}")
      # res, err = system_exec("wc #{mutant[:filename]}") # for testing
      checkpoint('generate ktests', err.nil?)
      mutant[:ktest_path] = "klee-out-#{klee_index}"
      klee_index += 1

      # run klee test to generate hash
      hash = klee_test(klee_index)
      checkpoint('generate hash', !hash.nil?)
      puts hash

      mutant[:hash] = hash
      mutant[:mutant_type] = 'TRIVIAL'
    rescue => exception
      mutant[:mutant_type] = 'STILLBORN'
      puts exception.message
      failure_count += 1
    ensure
      results.push(mutant)
    end
  end

  # csv output
  writer = Writer.new(RESULTCSV)
  writer.write_csv(Result::HEADER, results)
  # console output
  puts "\n====== SUMMARY ======="
  puts "success: #{mutants.length - failure_count} failure: #{failure_count}"
end

def klee_test(idx)
  begin
    klee_res = []
    k_base = "./klee-out-#{idx}"
    k_tests = Dir.glob('*.ktest', base: k_base).sort
    raise "no ktest files where found in #{k_base}" if k_tests.empty?
    k_tests.each do |test|
      filename = "#{k_base}/#{test}"
      # res, err = system_exec("cat #{filename}") # for testing
      res, err = system_exec("ktest-tool #{filename}")
      raise err if !err.nil?
      res.each_line do |line|
        klee_res.push(line) if line.include?("object")
      end
    end
    return Digest::SHA256.hexdigest(klee_res.join("\n"))
  rescue => exception
    puts "\e[31mERROR\e[0m\t#{exception.message}"
    return nil
  end
end

# executes external commands
def system_exec(command)
  out, err, status = Open3.capture3(command)
  err = nil if status.exitstatus == 0
  return [out, err]
end

# logs and raises error if condition is false
def checkpoint(description, success_condition)
  raise "[LOG]\t#{description}: \e[31mfail\e[0m" unless success_condition
  puts "[LOG]\t#{description}: \e[32msuccess\e[0m"
end

main
