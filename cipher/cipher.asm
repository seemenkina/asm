global cipher
global input_key

%define arg1 8
%define arg2 12
%define arg3 16

section .data
    outsymb: db "*"
    
section .bss
    terminal_params: resb 36

section .text
input_key:
push ebp
mov ebp, esp
push edi
push ebx

; Переключаю режим терминала на ввод ключа 
    mov eax, 54
	mov ebx, 0
	mov ecx, 0x5401
	mov edx, terminal_params
	int 80h
    
    push dword [terminal_params + 12]
    and [terminal_params + 12], dword ~(2 + 8)
    
    mov eax, 54
	mov ecx, 5402h
	int 80h
; ------------

	xor esi, esi
	mov edx, 1
	
.input_key:
    mov eax, 3
    mov ebx, 0
	mov ecx, [ebp + arg1]
	add ecx, esi
	int 80h
	
	cmp byte[ecx], 0xA
	je .enter_input
	
	mov eax, 4
	mov ebx, 1
	mov ecx, outsymb
	int 80h
	
	inc esi
	cmp esi, [ebp + arg2]
	jl .input_key
	jmp .end_read
	
.enter_input:
    cmp esi,0
    je .input_key
    mov [outsymb], byte 0xA
    mov eax, 4
    mov ebx, 1
    mov ecx, outsymb
    int 80h
    
.end_read:
    pop dword [terminal_params+12]
    mov eax, 54
	xor ebx, ebx
	mov ecx, 0x5402
	mov edx, terminal_params
	int 80h

	mov eax, esi

pop ebx
pop edi
mov esp, ebp
pop ebp
ret

cipher:
push ebp
mov ebp, esp
pusha
    
.encrypt:
	cmp [ebp + arg2], dword 0
	je .end
	xor esi, esi	;счетчик по буферу
.a1:
    xor edi, edi	;счетчик по ключю
.a2:
	xor eax, eax
	xor ebx, ebx

	mov edx, [ebp + arg1]
	mov al, [edx + esi]
	cmp al, 0xA
	je .a3

	mov edx, [ebp + arg3]
	mov bl,[edx + edi]
	xor al, bl

	mov edx, [ebp + arg1]
	mov [edx + esi], al
	inc edi
.a3:	
    inc esi
    cmp esi, [ebp + arg2]
    je .end

	mov edx, [ebp + arg3]
    mov eax,[edx + edi]
    cmp eax, 0xA
	je .a1
	jmp .a2
    
.end:

popa
mov esp, ebp
pop ebp
ret   

