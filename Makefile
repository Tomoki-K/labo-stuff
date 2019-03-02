# create mutants of a .c file
mutate:
	ruby ./src/mutate.rb $(input)

# symbolically execute mutants
sym_exec:
	ruby ./src/sym_exec.rb

# compare results
compare:
	ruby ./src/comparator.rb
