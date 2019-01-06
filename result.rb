class Result
  HEADER = [:id, :filename, :operator, :ktest_path, :hash, :mutant_type]

  def self.create_result_hash(id, filename, operator, ktest_path = nil, hash = nil, type = nil)
    record_hash = {
      id: id,                 # unique serial number
      filename: filename,     # mutant's filename
      operator: operator,     # mutant operator
      ktest_path: ktest_path, # location of .ktest files
      hash: hash,             # symbolic hash
      mutant_type: type       # STILLBORN | TRIVIAL | EQUIVALENT
    }
  end
end