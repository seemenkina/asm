all: main
cipher.o: cipher.asm
	nasm -felf -o cipher.o cipher.asm

main: cipher.o cipher.c
	gcc -g -m32 cipher.c cipher.o

clean:
	rm cipher.o