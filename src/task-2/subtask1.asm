%include "../include/io.mac"

; declare your structs here

section .data
    loop_index_1 dw 0
    loop_index_2 dw 0
    requests dw 0
    requests_length dw 0

section .text
    global sort_requests
    extern printf

sort_requests:
    enter 0,0
    pusha

    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length

    mov [requests], ebx
    mov [requests_length], ecx

    mov [loop_index_1], ebx
    mov [loop_index_2], ebx

    loop_1:
        loop_2:
            mov eax, loop_index_2
            mov ebx, [requests + eax] ; admin
            ;mov ecx, [requests + eax + 1] ; priority
            PRINTF32 `Is admin? %d\n\x0`, ebx
            ;PRINTF32 `Priority: %d\n\x0`, ecx

    popa
    leave
    ret
