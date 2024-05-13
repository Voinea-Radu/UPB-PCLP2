%include "../include/io.mac"

; Constants
%define byte4 4

section .data
    ; Return value for function
    return_value dd 0

    ;; partition variables
    pivot dd 0

    ; Index
    index dd 0

    ; Loop index
    loop_index dd 0

    ; Start index
    start_index dd 0

    ; End index
    end_index dd 0


section .text
    global quick_sort
    extern printf

;; void quick_sort(int32_t *buff, uint32_t start, uint32_t end);
quick_sort:
    ; Enter a new stack frame
    enter 0,0
    pusha
    ; buff
    mov ebx, [ebp + 8]
    ; start
    mov ecx, [ebp + 12]
    ; end
    mov edx, [ebp + 16]

    cmp ecx, edx
    jge .end

    push edx
    push ecx
    push ebx
    call partition
    ; Reset the stack pointer
    add esp, 12

    ; Left side
    dec eax
    push eax
    push ecx
    push ebx
    call quick_sort
    ; Reset the stack pointer
    add esp, 12

    ; Right side
    add eax, 2
    push edx
    push eax
    push ebx
    call quick_sort
    ; Reset the stack pointer
    add esp, 12

    .end:
    popa
    leave
    ret

;; int partition(int32_t *buff, uint32_t start, uint32_t end);
partition:
    ; Enter a new stack frame
    enter 0,0
    pusha

    ; buff
    mov eax, [ebp + 8]
    ; start
    mov ebx, [ebp + 12]
    ; end
    mov ecx, [ebp + 16]

    ; Initialize return value
    mov DWORD [return_value], 0

    mov [start_index], ebx
    mov [end_index], ecx

    mov edx, DWORD [eax + ecx * byte4]
    mov DWORD [pivot], edx

    mov ebx, DWORD [start_index]
    mov DWORD [index], ebx
    dec DWORD [index]

    mov ebx, [start_index]
    mov DWORD [loop_index], ebx

    .loop:
    mov ebx, DWORD [loop_index]
    mov ecx, DWORD [pivot]
    mov edx, [eax + ebx * byte4]
    cmp edx, ecx
    jg .skip

    inc DWORD [index]
    mov ebx, DWORD [index]
    mov ecx, DWORD [loop_index]
    mov edx, [eax + ebx * byte4]
    mov esi, [eax + ecx * byte4]
    mov [eax + ebx * byte4], esi
    mov [eax + ecx * byte4], edx

    .skip:
    inc DWORD [loop_index]
    mov ebx, DWORD [loop_index]
    cmp ebx, DWORD [end_index]
    jl .loop

    mov ebx, DWORD [index]
    inc ebx
    mov ecx, DWORD [end_index]
    mov edx, [eax + ebx * byte4]
    mov esi, [eax + ecx * byte4]
    mov [eax + ebx * byte4], esi
    mov [eax + ecx * byte4], edx

    mov DWORD [return_value], ebx

    popa
    leave

    mov eax, DWORD [return_value]

    ret