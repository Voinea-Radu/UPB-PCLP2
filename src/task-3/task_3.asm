%include "../include/io.mac"

; Constants
%define byte4 4

struc neighbours_t
    ; Neighbour count
    .neighbour_count resd 1
    ; Neighbours
    .neighbours resd 1
endstruc

section .bss
    ; Visited array of 10000 elements
    visited resd 10000
    global visited

section .data
    ; Output format string
    format_string db "%u", 10, 0
    ; Current node
    node dd 0
    ; Function pointer to expand
    expand dd 0

section .text
    global dfs
    extern printf

;; void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))
dfs:
    ; Enter a new stack frame
    enter 0,0
    pusha

    ; node
    mov ebx, [ebp + 8]
    ; expand
    mov ecx, [ebp + 12]

    mov DWORD [node], ebx
    mov DWORD [expand], ecx

    push ebx
    push format_string
    call printf
    ; Reset the stack pointer to its original state
    add esp, 8

    ; Mark the node as visited
    mov DWORD [visited + ebx * byte4], 1

    ; Free registers: eax, edx, esi, edi
    ; neighbours_t *neighbours = expand(node);
    mov ecx, DWORD [expand]
    push ebx
    call ecx
    ; Reset the stack pointer to its original state
    add esp, 4
    ; eax = neighbours

    mov edx, DWORD [eax + neighbours_t.neighbour_count]
    mov esi, DWORD [eax + neighbours_t.neighbours]

    ; Initialize the loop counter
    mov edi, 0
    .loop:
    cmp edi, edx
    jge .loop_end

    ; neighbour
    mov ebx, DWORD [esi + edi * byte4]

    ; Check if the node is visited
    cmp DWORD [visited + ebx * byte4], 0
    je .not_visited
    jmp .loop_continue

    .not_visited:
    mov ecx, DWORD [expand]
    push ecx
    push ebx
    call dfs
    ; Reset the stack pointer to its original state
    add esp, 8

    .loop_continue:
    inc edi
    jmp .loop

    .loop_end:
    popa
    leave
    ret
