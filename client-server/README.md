# Simple client and server on NASM

Code is implemented client and multithreaded echo-server.

## Build client 
```
nasm -g -f elf -o client.o client.asm
ld -m elf_i386 -o client client.o
```

## Build Server
```
nasm -g -f elf -o server.o server.asm
ld -m elf_i386 -o server server.o
```

## Run 
Run server and clients in different tabs.
```
./client
./server
```
