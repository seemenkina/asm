global _start
_start:
    xor edx, edx
    push edx                  ; 0x00000000
    push dword 0x68732f       ; hs/
    push dword 0x6e69622f     ; nib/
    mov ebx,esp

    push edx                   ; 0x00000000
    push word 0x632d           ; c-
    mov eax, esp

    push edx                   ; 0x00000000
    push dword 0x65746164      ; etad 
    mov ecx, esp
    
    push edx            ; 0x00000000 
    push ecx            ; date
    push eax            ; -c
    push ebx            ; /bin/sh
    mov ecx, esp
    
    mov eax, 0x0b
    int 0x80            ; execve("/bin/sh",**argv,0)
