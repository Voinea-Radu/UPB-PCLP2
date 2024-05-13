[bits 64]

section .text
    global map
    global reduce

; void map(int64_t *dst, int64_t *src, int64_t n, int64_t(*f)(int64_t));
map:
    push rbp
    mov rbp, rsp

    ; mov rdi, rdi ; dst
    ; mov rsi, rsi ; src
    ; mov rdx, rdx ; n
    ; mov rcx, rcx ; f
    mov r8, rdi

    xor r9, r9
    .loop:
        cmp r9, rdx
        je .loop_finish

        mov rdi, [rsi + r9 * 8]
        call rcx
        mov rax, rax
        mov [r8 + r9 * 8], rax

        inc r9
        jmp .loop

    .loop_finish:

    leave
    ret

; int64_t reduce(int64_t *dst, int64_t *src, int64_t n, int64_t acc_init, int64_t(*f)(int64_t, int64_t));
reduce:
    push rbp
    mov rbp, rsp

    mov rdi, rdi ; dst ; ignored
    mov rsi, rsi ; src
    mov rdx, rdx ; n
    mov rcx, rcx ; acc_init
    mov r8, r8   ; f

    mov r10, rsi
    mov rdi, rcx

    xor r9, r9
    .loop:
        cmp r9, rdx
        je .loop_finish

        push rdx
        mov rsi, [r10 + r9 * 8]
        call r8
        pop rdx
        mov rdi, rax

        inc r9
        jmp .loop

    .loop_finish:
    mov rax, rdi

    leave
    ret

