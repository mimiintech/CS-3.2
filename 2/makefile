# CS 218 Summer 2023 Assignment #1
# Simple make file for asst #1

OBJS		= hw2.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: hw2

hw2.o: hw2.asm 
	$(ASM) hw2.asm -l hw2.lst

hw2: hw2.o
	$(LD) -o hw2 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
