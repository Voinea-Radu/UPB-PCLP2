%include "../include/io.mac"

struc neighbours_t
    .neighbour_count resd 1
    .neighbours resd 1
endstruc

section .bss
    visited resd 10000
    global visited

section .data
    format_string db "%u", 10, 0
    node dd 0
    expand dd 0

section .text
    global dfs
    extern printf

;; void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))
dfs:
    enter 0,0
    pusha

    mov ebx, [ebp + 8]  ; node
    mov ecx, [ebp + 12] ; expand

    mov DWORD [node], ebx
    mov DWORD [expand], ecx

    push ebx
    push format_string
    call printf
    add esp, 8

    mov DWORD [visited + ebx * 4], 1

    ; Free registers: eax, edx, esi, edi
    ; neighbours_t *neighbours = expand(node);
    mov ecx, DWORD [expand]
    push ebx
    call ecx
    add esp, 4
    ; eax = neighbours

    mov edx, DWORD [eax + neighbours_t.neighbour_count]
    mov esi, DWORD [eax + neighbours_t.neighbours]

    mov edi, 0
    .loop:
        cmp edi, edx
        jge .loop_end

        mov ebx, DWORD [esi + edi * 4] ; neighbour

        cmp DWORD [visited + ebx * 4], 0
        je .not_visited
        jmp .loop_continue

        .not_visited:
        mov ecx, DWORD [expand]
        push ecx
        push ebx
        call dfs
        add esp, 8

        .loop_continue:
        inc edi
        jmp .loop

    .loop_end:
    popa
    leave
    ret
