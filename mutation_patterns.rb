NULL_STRING = " "

# ref: https://www.tutorialspoint.com/cprogramming/c_operators.htm

MUTATION_TYPES = {
  # ABS: Absolute value insertion
  "ABS": {
    " = ": [ " = 0 * ", " = 0 ; //", " = NULL; //" ],
    " + 1": [ "+ 0", "+ 2" ],
    " - 1": [ "+ 0", "- 2" ],
    " true ": [ " false " ],
    " false ": [ " true " ],
    " a ": [ " b ", " c ", " 0 ", " 1 ", " true ", " false " ],
    " a; ": [ " b; ", " c; ", " 0; ", " 1; ", " true; ", " false; " ],
    " b ": [ " a ", " c ", " 0 ", " 1 ", " true ", " false " ],
    " b; ": [ " a; ", " c; ", " 0; ", " 1; ", " true; ", " false; " ],
    " c ": [ " a ", " b ", " 0 ", " 1 ", " true ", " false " ],
    " c; ": [ " a; ", " b; ", " 0; ", " 1; ", " true; ", " false; " ],
    " x ": [ " y ", " z ", " 0 ", " 1 ", " true ", " false " ],
    " x; ": [ " y; ", " z; ", " 0; ", " 1; ", " true; ", " false; " ],
    " y ": [ " x ", " z ", " 0 ", " 1 ", " true ", " false " ],
    " y; ": [ " x; ", " z; ", " 0; ", " 1; ", " true; ", " false; " ],
    " z ": [ " x ", " y ", " 0 ", " 1 ", " true ", " false " ],
    " z; ": [ " x; ", " y; ", " 0; ", " 1; ", " true; ", " false; " ],
  },
  # AOR: Arithmic operator replacement
  "AOR": {
    " + ": [ " - ", " * ", " / ", " % " ],
    " - ": [ " + ", " * ", " / ", " % " ],
    " * ": [ " + ", " - ", " / ", " % " ],
    " / ": [ " % ", " * ", " + ", " - " ],
    " % ": [ " / ", " + ", " - ", " * " ],
  },
  # ROR: Relational operator replacement
  "ROR": {
    " < ": [ " != ", " > ", " <= ", " >= ", " == " ],
    " > ": [ " != ", " < ", " <= ", " >= ", " == " ],
    " <= ": [ " != ", " < ", " > ", " >= ", " == " ],
    " >= ": [ " != ", " < ", " <= ", " > ", " == " ],
    " == ": [ " != ", " < ", " > ", " <= ", " >= " ],
    " != ": [ " == ", " < ", " > ", " <= ", " >= " ],
  },
  # LOR: Logical operator replacement
  "LOR": {
    " !": [ NULL_STRING ],
    " && ": [ " || ", " && !" ],
    " || ": [ " && ", " || !" ],
  },
  # ASR: Assignment operator replacement
  "ASR": {
    " = ": [ " += ", " -= ", " *= ", " /= ", " %= " ],
  },
  # UOI: Unary operator insertion
  "UOI": {
    "++": [ "--" ],
    "--": [ "++" ],
  },
}.freeze

def construct_mutation_patterns
  patterns = {}
  MUTATION_TYPES.each do |type, mutators|
    mutators.each do |target, replacements|
      # create mutation object for each mutation pattern
      replacements.map! {|r|{ type: type.to_s, substring: r } }
      patterns[target] = patterns.key?(target) ? (patterns[target] + replacements).uniq : replacements
    end
  end
  return patterns
end

MUTATION_PATTERNS = construct_mutation_patterns.freeze
