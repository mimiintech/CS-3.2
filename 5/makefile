# CS 218 Summer 2023 Assignment #5
# Simple make file for asst #5

OBJS		= hw5.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: hw5

hw5.o: hw5.asm 
	$(ASM) hw5.asm -l hw5.lst

hw5: hw5.o
	$(LD) -o hw5 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
