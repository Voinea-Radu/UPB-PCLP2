; Set the file to be interpreted as 32 bit assembly
[bits 32]

%include "../include/io.mac"

section .data
    ; the string containing the parentheses
    string dd 0

    ; the loop index
    loop_index dd 0

    ; number of pushed to the stack
    push_count dd 0

    ; the return value of the function
    return_value dd 0

section .text
    global check_parantheses
    extern printf

; int check_parantheses(char *str)
check_parantheses:
    ; Enter a new stack frame
    enter 0,0
    pusha

    ; str
    mov eax, [ebp + 8]

    mov DWORD [string], eax

    ; Initialize loop index with 0
    mov DWORD [loop_index], 0
    ; Initialize push count with 0
    mov DWORD [push_count], 0

    loop1:
    mov eax, DWORD [string]
    mov ebx, DWORD [loop_index]
    mov al, BYTE [eax + ebx]

    cmp al, '('
    je push_to_stack
    cmp al, '['
    je push_to_stack
    cmp al, '{'
    je push_to_stack
    ; Check if it is the end of the string
    cmp al, 0
    je valid_finish

    jmp pop_from_stack

    push_to_stack:
    push eax
    inc DWORD [push_count]
    jmp loop_end

    pop_from_stack:
    xor ebx, ebx
    ; Check if all the pushes have been already popped
    cmp DWORD [push_count], 0
    je invalid_finish

    pop ebx
    dec DWORD [push_count]

    check_1:
    cmp bl, '('
    jne check_2
    cmp al, ')'
    jne invalid_finish
    jmp loop_end

    check_2:
    cmp bl, '['
    jne check_3
    cmp al, ']'
    jne invalid_finish
    jmp loop_end

    check_3:
    cmp bl, '{'
    jne loop_end
    cmp al, '}'
    jne invalid_finish
    jmp loop_end

    jmp loop_end

    loop_end:

    inc DWORD [loop_index]
    jmp loop1

    valid_finish:
    ; Set the return value to 0
    mov DWORD [return_value], 0
    jmp pops

    invalid_finish:
    ; Set the return value to 1
    mov DWORD [return_value], 1
    jmp pops

    pops:
    ; Check if all the pushes have been popped
    cmp DWORD [push_count], 0
    je finish
    ; Set the return value to 1
    mov DWORD [return_value], 1

    pop eax
    dec DWORD [push_count]
    jmp pops

    finish:

    popa
    leave
    mov eax, [return_value]
    ret
