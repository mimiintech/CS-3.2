# CS 218 Summer 2024 Assignment #7
# Simple make file for asst #7

OBJS		= hw7.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: hw7

hw7.o: hw7.asm 
	$(ASM) hw7.asm -l hw7.lst

hw7: hw7.o
	$(LD) -o hw7 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
