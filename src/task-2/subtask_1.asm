%include "../include/io.mac"

section .data
    return_value dd 0

    ;; partition variables
    pivot dd 0
    index dd 0
    loop_index dd 0
    start_index dd 0
    end_index dd 0


section .text
    global quick_sort
    extern printf

;; void quick_sort(int32_t *buff, uint32_t start, uint32_t end);
quick_sort:
    enter 0,0
    pusha

    mov ebx, [ebp + 8]  ; buff
    mov ecx, [ebp + 12] ; start
    mov edx, [ebp + 16] ; end

    cmp ecx, edx
    jge .end

    push edx
    push ecx
    push ebx
    call partition
    add esp, 12

    dec eax
    push eax
    push ecx
    push ebx
    call quick_sort
    add esp, 12

    add eax, 2
    push edx
    push eax
    push ebx
    call quick_sort
    add esp, 12

    .end:
    popa
    leave
    ret

;; int partition(int32_t *buff, uint32_t start, uint32_t end);
partition:
    enter 0,0
    pusha

    mov eax, [ebp + 8]  ; buff
    mov ebx, [ebp + 12] ; start
    mov ecx, [ebp + 16] ; end

    mov DWORD [return_value], 0

    mov [start_index], ebx
    mov [end_index], ecx

    mov edx, DWORD [eax + ecx * 4]
    mov DWORD [pivot], edx

    mov ebx, DWORD [start_index]
    mov DWORD [index], ebx
    dec DWORD [index]

    mov ebx, [start_index]
    mov DWORD [loop_index], ebx

    .loop:
        mov ebx, DWORD [loop_index]
        mov ecx, DWORD [pivot]
        mov edx, [eax + ebx * 4]
        cmp edx, ecx
        jg .skip

        inc DWORD [index]
        mov ebx, DWORD [index]
        mov ecx, DWORD [loop_index]
        mov edx, [eax + ebx * 4]
        mov esi, [eax + ecx * 4]
        mov [eax + ebx * 4], esi
        mov [eax + ecx * 4], edx

        .skip:
        inc DWORD [loop_index]
        mov ebx, DWORD [loop_index]
        cmp ebx, DWORD [end_index]
        jl .loop

    mov ebx, DWORD [index]
    inc ebx
    mov ecx, DWORD [end_index]
    mov edx, [eax + ebx * 4]
    mov esi, [eax + ecx * 4]
    mov [eax + ebx * 4], esi
    mov [eax + ecx * 4], edx

    mov DWORD [return_value], ebx

    popa
    leave

    mov eax, DWORD [return_value]

    ret