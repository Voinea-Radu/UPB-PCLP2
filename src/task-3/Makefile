.PHONY: all clean run build

all: checker

build: checker

run: checker
	./checker

treyfer.o: treyfer.asm
	nasm -f elf $^ -o $@

check_treyfer.o: check_treyfer.c
	gcc -c -g -m32 $^ -o $@

checker: check_treyfer.o  treyfer.o
	gcc -m32 -no-pie -g $^ -o $@

clean:
	rm -f checker
	rm *.o

