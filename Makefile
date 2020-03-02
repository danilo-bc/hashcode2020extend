all: a b c d e f
	
a:
	julia hashJulia.jl < ./dataset/a_example.txt                > ./res/a_dan.txt
	@echo [A] Done

b:
	 julia hashJulia.jl < ./dataset/b_read_on.txt                > ./res/b_dan.txt
	@echo [B] Done

c:
	 julia hashJulia.jl < ./dataset/c_incunabula.txt             > ./res/c_dan.txt
	@echo [C] Done

d:
	 julia hashJulia.jl < ./dataset/d_tough_choices.txt          > ./res/d_dan.txt
	@echo [D] Done

e:
	 julia hashJulia.jl < ./dataset/e_so_many_books.txt          > ./res/e_dan.txt
	@echo [E] Done

f:
	 julia hashJulia.jl < ./dataset/f_libraries_of_the_world.txt > ./res/f_dan.txt
	@echo [F] Done
