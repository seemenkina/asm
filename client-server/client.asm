section .bss
    buffer resb 1024
    data_len resd 1
    socket resd 1

section .data
    buffer_len equ 1024
    goodbye db	"Bye", 0xa
    goodbye_len equ	$-goodbye
    endstr db	"end", 0xa
    end_str_len equ	$-endstr
section .text

global _start
_start:

    xor edx, edx 
    push edx        ; IPPROTO_IP
    push 0x1        ; SOCK_STREAM
    push 0x2        ; AF_INET
    mov ecx, esp    ; pointer to args

    mov bl, 0x1     ; SYS_SOCKET function
    mov al, 0x66    ; sys socket()
    int 80h

    cmp eax, 0
    jl err_exit

    mov [socket], eax    ; save socket_desc

    push dword 0x0100007f
    push word 0x8813     ; port 5000
    push word 2        ; AF_INET
    mov ecx, esp

    push 0x10       ;
    push ecx        ; param
    push dword [socket]        ; socket_desc
    mov ecx, esp

    mov al, 0x66
    mov bl, 0x3
    int 80h

    cmp eax, 0
    jl err_exit

while:
    mov edx, buffer_len
    mov ecx, buffer
    mov ebx, 2
    mov eax, 3
    int 80h 

    mov [data_len], eax

    mov edx, [data_len]
    mov ecx, buffer
    mov ebx, [socket]
    mov eax, 4
    int 80h

    mov edx, buffer_len
    mov ecx, buffer
    mov ebx, [socket]
    mov eax, 3
    int 80h

    mov [data_len], eax

    mov eax, 4     
    mov ebx, 1
	mov ecx, buffer
	mov edx, [data_len]
	int 80h

    cmp dword [data_len], end_str_len
    jne while

    mov edi, buffer
    mov esi, goodbye
    mov edx, [data_len]
    call cmpfunc

    cmp eax, 0
    je end

    jmp while
end:

    mov eax, 6		    ; close() syscall
    mov ebx, [socket]	; The socket descriptor
    int 0x80


err_exit:
    mov eax, 1
    mov ebx, 1
    int 80h

exit:
    mov eax, 1
    xor ebx, ebx
    int 80h


cmpfunc:
    push ebp
    mov ebp, esp

    xor eax, eax
.begin:
    mov ebx, [edi]
    cmp bl, byte [esi]
    jne .fail

    inc esi
    inc edi 
    dec edx 

    cmp edx, 0
    je .end 

    jmp .begin
.fail:
    mov al, bl 
    mov ebx, [esi]
    sub al, bl
    jmp .end
.end:
    mov esp, ebp 
    pop ebp 
    ret 