;;;
;;; Copyright (c) 2024, Voinea Radu-Mihai <contact@voinearadu.com>
;;;

;;; Notes:
;;; Each sub-routine has the following signature:
;;;     sub_routine_name: ;; (arguments) ;; <local_variables>

%include "../include/io.mac"

%define struct_size 55

section .data
    requests dd 0
    requests_length dd 0
    connected dd 0

    passkey dw 0

    loop_index_1 dd 0
    loop_index_2 dd 0

    check_flag db 0

section .text
    global check_passkeys
    extern printf

check_passkeys:
    enter 0, 0
    pusha

    mov eax, [ebp + 8]      ; requests
    mov ebx, [ebp + 12]     ; length
    mov ecx, [ebp + 16]     ; connected

    mov [requests], eax
    mov [requests_length], ebx
    mov [connected], ecx

    mov DWORD [loop_index_1], 0
    loop_1:
        mov eax, [loop_index_1]
        mov byte[ecx + eax], 0
        imul eax, struct_size

        mov ebx, [requests]
        mov bx, [ebx + eax + 2]

        mov [passkey], bx

        push check_flag
        push WORD [passkey]
        call check_first_and_last_bit
        add esp, 6

        cmp BYTE [check_flag], 0
        je loop_1_continue

        push check_flag
        push WORD [passkey]
        call check_first_7_bits
        add esp, 6

        cmp BYTE [check_flag], 0
        je loop_1_continue

        push check_flag
        push WORD [passkey]
        call check_last_7_bits
        add esp, 6

        cmp BYTE [check_flag], 0
        je loop_1_continue

        mov ecx, [connected]
        mov eax, [loop_index_1]
        mov byte[ecx + eax], 1


        loop_1_continue:
        inc DWORD [loop_index_1]
        mov eax, [loop_index_1]
        cmp eax, [requests_length]
        jb loop_1


    popa
    leave
    ret




check_first_and_last_bit: ;; ([2]passkey, [4]return_value) ;; <>
    enter 0,0
    pusha

    mov bx,  [ebp + 8]     ; passkey
    mov ecx, [ebp + 10]    ; return_value

    mov bx, [ebp + 8]
    and bx, 1000_0000_0000_0000b
    shr bx, 15

    cmp bx, 1
    jne check_first_and_last_bit_negative

    mov bx, [ebp + 8]
    and bx, 0000_0000_0000_0001b

    cmp bx, 1
    je check_first_and_last_bit_positive

    check_first_and_last_bit_negative:
        mov BYTE [ecx], 0
        jmp check_first_and_last_bit_end

    check_first_and_last_bit_positive:
        mov BYTE [ecx], 1
        jmp check_first_and_last_bit_end

    check_first_and_last_bit_end:

    popa
    leave
    ret



check_first_7_bits: ;; ([2]passkey, [4]return_value) ;; <>
    enter 0,0
    pusha

    mov ax, [ebp + 8]      ; passkey
    mov ebx, [ebp + 10]    ; return_value

    mov ax, [ebp + 8]
    and ax, 0111_1111_0000_0000b
    shr ax, 8

    mov bx, 0 ; loop counter

    xor edx, edx
    mov dx, 0 ; bits counter
    check_first_7_bits_loop:
        mov cx, ax
        and cx, 1
        add dx, cx
        shr ax, 1

        inc bx
        cmp bx, 8
        jb check_first_7_bits_loop

    mov ebx, [ebp + 10]
    mov BYTE [ebx], 0

    and edx, 1
    cmp edx, 1
    jne check_first_7_bits_end

    mov ebx, [ebp + 10]
    mov BYTE [ebx], 1

    check_first_7_bits_end:
    popa
    leave
    ret



check_last_7_bits: ;; ([2]passkey, [4]return_value) ;; <>
    enter 0,0
    pusha

    mov ax, [ebp + 8]      ; passkey
    mov ebx, [ebp + 10]    ; return_value

    mov ax, [ebp + 8]
    and ax, 0000_000_1111_1110b

    mov bx, 0 ; loop counter

    xor edx, edx
    mov dx, 0 ; bits counter
    check_last_7_bits_loop:
        mov cx, ax
        and cx, 1
        add dx, cx
        shr ax, 1

        inc bx
        cmp bx, 8
        jb check_last_7_bits_loop

    mov ebx, [ebp + 10]
    mov BYTE [ebx], 0

    and edx, 1
    cmp edx, 0
    jne check_last_7_bits_end

    mov ebx, [ebp + 10]
    mov BYTE [ebx], 1

    check_last_7_bits_end:
    popa
    leave
    ret