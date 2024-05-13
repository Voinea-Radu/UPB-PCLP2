%include "../include/io.mac"

section .data
    return_value dd 0

section .text
    global binary_search
    extern printf


;; int32_t __attribute__((fastcall)) binary_search(int32_t *buff, uint32_t needle, uint32_t start, uint32_t end)
binary_search:
    enter 0,0
    pusha

    ; mov ecx, buff
    ; mov edx, needle
    mov eax, [ebp + 8] ; start
    mov ebx, [ebp + 12] ; end

    cmp ebx, eax
    jl .not_found

    mov esi, ebx
    sub esi, eax
    shr esi, 1
    add esi, eax ; mid

    mov edi, [ecx + esi * 4]
    cmp edi, edx
    je .found
    jb .right
    ja .left

    .found:
        mov DWORD [return_value], esi
        jmp .return

    .left:
        dec esi

        push esi
        push eax
        call binary_search
        add esp, 8
        mov DWORD [return_value], eax
        jmp .return

    .right:
        inc esi

        push ebx
        push esi
        call binary_search
        add esp, 8
        mov DWORD [return_value], eax
        jmp .return


    .not_found:
        mov DWORD [return_value], -1
        jmp .return


    .return:
    popa
    leave

    mov eax, DWORD [return_value]

    ret
