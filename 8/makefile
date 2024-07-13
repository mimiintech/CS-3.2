# CS 218 Summer 2024 Assignment #8
#Makefile to create the object files from both C and x86 and then link them

OBJS	 	= parallel_max.o seq_max.o hw8.o
PAR_OBJS 	= parallel_max.o hw8.o
DEBUG_OBJS 	= parallel_max_debug.o hw8.o
ASM		= yasm -g dwarf2 -f elf64
LD		= gcc -g -pthread  -no-pie
ARGS		= -g -Wall -c -std=c++11

all: max_prog_par max_prog_seq par_debug

parallel_max.o: parallel_max.cpp
	g++ $(ARGS) parallel_max.cpp
	
seq_max.o:
	g++ $(ARGS) seq_max.cpp
	
parallel_max_debug.o: parallel_max.cpp
	g++ $(ARGS) -o parallel_max_debug.o -D DEBUG parallel_max.cpp
	
hw8.o: hw8.asm 
	$(ASM) hw8.asm -l hw8.lst

par_debug: $(DEBUG_OBJS)
	$(LD) -o par_debug $(DEBUG_OBJS) -lstdc++
	
max_prog_par: $(PAR_OBJS)
	$(LD) -o max_prog_par $(PAR_OBJS) -lstdc++

max_prog_seq: seq_max.o
	g++ -g -o max_prog_seq -no-pie seq_max.o -lstdc++

# -----
# clean by removing object file.

clean:
	@rm	-f $(OBJS)
	@rm	-f max_prog_seq
	@rm	-f max_prog_par
	@rm	-f par_debug
	@rm	-f hw8.lst
