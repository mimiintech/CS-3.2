# CS 218 Summer 2023 Assignment #3
# Simple make file for asst #3

OBJS		= hw3.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: hw3

hw3.o: hw3.asm 
	$(ASM) hw3.asm -l hw3.lst

hw3: hw3.o
	$(LD) -o hw3 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
