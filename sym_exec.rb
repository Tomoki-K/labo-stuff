require "digest"
require "./writer"

OUPUTFILE = ARGV[0] || 'result.csv'
HEADER = [:name, :hash, :is_em]

results = []
k_outs = Dir.glob('klee-out-*').sort
k_outs.each do |k_base|
  klee_res = []
  k_tests = Dir.glob('*.ktest', base: k_base).sort
  k_tests.each do |test|
    filepath = "#{k_base}/#{test}"
    begin
      # res = `ktest-tool #{filepath}`
      res = `cat #{filepath}` # for testing
      res.each_line do |line|
        klee_res.push(line) if line.include?("object")
      end
    rescue => exception
      p "ERROR: failed to execute #{test}"
      p exception
    end
  end
  res_hash = Digest::SHA256.hexdigest(klee_res.join("\n"))
  result = {
    name: k_base,
    hash: res_hash,
    is_em: false
  }
  results.push(result)
end

out = Writer.new(OUPUTFILE)
out.write_csv(HEADER, results)
