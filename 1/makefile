# CS 218 Summer 2023 Assignment #1
# Simple make file for asst #1

OBJS	= hw1.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: hw1

hw1.o: hw1.asm 
	$(ASM) hw1.asm -l hw1.lst

hw1: hw1.o
	$(LD) -o hw1 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)