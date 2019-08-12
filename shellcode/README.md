# Shellcode

## shell-code 1
The shell is execute command `/bin/sh -c date` using system call *execve*.

### Build and run 
```
nasm -g -f elf -o shell1.o shell-code1.asm
ld -m elf_i386 -o shell1 shell1.o
./shell1
```

## shell-code 2
A reverse shell connects back to the attacker machine, then executes a shell redirects all input&output to the socket. 
Netcat is used to listen for the reverse shell connection on port 43690.

### Build
```
nasm -g -f elf -o shell2.o shell-code2.asm
ld -m elf_i386 -o shell2 shell2.o
```
### Run netcat
```
nc -lvnp 43960
./shell2
```
