class Result
  HEADER = [:id, :filename, :operator, :hash, :mutant_type]

  def self.create_result_hash(id, filename, operator, hash, type)
    record_hash = {
      id: id,             # unique serial number
      filename: filename, # mutant's filename
      operator: operator, # mutant operator
      hash: hash,         # symbolic hash
      mutant_type: type   # STILLBORN | TRIVIAL | EQUIVALENT
    }
  end
end