section .bss
    buffer resb 1024
    client resd 1
    socket resd 1
    data_len resd 1

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
    push edx       ; IPPROTO_IP
    push 0x1        ; SOCK_STREAM
    push 0x2        ; AF_INET
    mov ecx, esp    ; pointer to args

    mov bl, 0x1     ; SYS_SOCKET function
    mov al, 0x66    ; sys socket()
    int 80h

    cmp eax, 0
    jl err_exit

    mov [socket], eax   ;sockfd

    push edx 
    push word 0x8813           ; port 5000
    push word 2                 ; AF_INET (IPv4)
    mov ecx, esp                ; move to our socket address variable
    
    push 0x10
    push ecx
    push dword [socket]

    mov ecx, esp         ; push vars from stack to params
    mov eax, 102         ;sys_socket 
    mov ebx, 2           ; sys bind()
    int 80h

    cmp eax, 0
    jl err_exit

    push byte 20
    push dword [socket]

    mov ecx, esp        ; move stack as variables
    mov eax, 102        ; socket call
    mov ebx, 4          ; sys listen()
    int 80h

    cmp eax, 0
    jl err_exit

s_while:
    ;accept:
    push edx
    push edx
    push dword [socket]
    mov ecx, esp
    mov eax, 102
    mov ebx, 5
    int 80h

    cmp eax, 0
    jl err_exit

    mov [client], eax
    mov eax, 2      ;fork
    int 80h

    cmp eax, -1
    je fork_err

    cmp eax, 0
    je f_client

    jmp pid

fork_err:
	mov	eax, 6              ; close socket
	mov	ebx, [socket]
	int 80h

	mov	eax, 6          ; close client
	mov	ebx, [client]
	int 80h

	jmp	s_while

f_client:           
	mov	eax, 6              ; close socket
	mov	ebx, [socket]
	int 80h

read:
    mov edx, buffer_len
    mov ecx, buffer
    mov ebx, [client]
    mov eax, 3
    int 80h

    mov [data_len], eax
    cmp eax, 0
    je end_read


    cmp dword [data_len], end_str_len
    jne write

    mov edi, buffer
    mov esi, endstr
    mov edx, [data_len]
    call cmpfunc

    cmp eax, 0
    je end_read

write:

    mov eax, 4     
    mov ebx, [client]
	mov ecx, buffer
	mov edx, [data_len]
	int 80h

    jmp read

end_read:
    mov eax, 4     
    mov ebx, [client]
	mov ecx, goodbye
	mov edx, goodbye_len
	int 80h

    mov	eax, 6          ; close client
	mov	ebx, [client]
	int 80h

    jmp exit 

pid:
    mov eax, 6		; close() syscall
    mov ebx, [client]	
    int 0x80

    jmp s_while

err_exit:
    mov eax, 1
    mov ebx, 1
    int 80h

exit:
    mov eax, 1
    mov ebx, 0
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