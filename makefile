CC=g++
ASMBIN=nasm

all : asm cc link
asm :
		$(ASMBIN) -o func.o -f elf -g -l func.lst func.asm
cc :
		$(CC) -m32 -c -g -O0 main.cpp &> errors.txt
link :
		$(CC) -m32 -g -o test main.o func.o
clean :
		rm -rf *.o
		rm -rf test
		rm -rf errors.txt
		rm -rf func.lst