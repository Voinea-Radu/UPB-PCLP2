%include "../include/io.mac"

; Constants
%define byte4 4

section .data
    ; Return value
    return_value dd 0

section .text
    global binary_search
    extern printf


;; int32_t __attribute__((fastcall)) binary_search(int32_t *buff, uint32_t needle, uint32_t start, uint32_t end)
binary_search:
    ; Enter a new stack frame
    enter 0,0
    pusha

    ; mov ecx, buff
    ; mov edx, needle
    ; start
    mov eax, [ebp + 8]
    ; end
    mov ebx, [ebp + 12]

    cmp ebx, eax
    jl .not_found

    mov esi, ebx
    sub esi, eax
    ; esi = esi / 2
    shr esi, 1
    ; mid
    add esi, eax

    mov edi, [ecx + esi * byte4]
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
    ; Reset the stack pointer to its original state
    add esp, 8
    mov DWORD [return_value], eax
    jmp .return

    .right:
    inc esi

    push ebx
    push esi
    call binary_search
    ; Reset the stack pointer to its original state
    add esp, 8
    mov DWORD [return_value], eax
    jmp .return


    .not_found:
    ; Set the return value to -1
    mov DWORD [return_value], -1
    jmp .return


    .return:
    popa
    leave

    mov eax, DWORD [return_value]

    ret
