[bits 32]

%include "../include/io.mac"

section .data
    string dd 0
    loop_index dd 0

    push_count dd 0

    return_value dd 0

section .text
    global check_parantheses
    extern printf

; int check_parantheses(char *str)
check_parantheses:
    enter 0,0
    pusha

    mov eax, [ebp + 8] ; str

    mov DWORD [string], eax
    mov DWORD [loop_index], 0
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
        cmp al, 0
        je valid_finish

        jmp pop_from_stack

        push_to_stack:
            push eax
            inc DWORD [push_count]
            jmp loop_end

        pop_from_stack:
            xor ebx, ebx
            cmp DWORD [push_count], 0
            je invalid_finish

            pop ebx
            dec DWORD [push_count]
            ; PRINTF32 `%c%c\n\0x`, ebx, eax

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
        mov DWORD [return_value], 0
        ; PRINTF32 `VALID\n\0x`, ebx
        jmp pops

    invalid_finish:
        mov DWORD [return_value], 1
        ; PRINTF32 `INVALID\n\0x`, ebx
        jmp pops

    pops:
        cmp DWORD [push_count], 0
        je finish
        mov DWORD [return_value], 1
        ; PRINTF32 `INVALID\n\0x`, ebx

        pop eax
        dec DWORD [push_count]
        jmp pops

    finish:

    popa
    leave
    mov eax, [return_value]
    ret
