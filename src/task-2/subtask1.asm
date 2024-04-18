;;;
;;; Copyright (c) 2024, Voinea Radu-Mihai <contact@voinearadu.com>
;;;

;;; Notes:
;;; Each sub-routine has the following signature:
;;;     sub_routine_name: ;; (arguments) ;; <local_variables>

%include "../include/io.mac"

%define username_length 50
%define struct_size 55

section .data
    loop_index_1 dd 0
    loop_index_2 dd 0
    requests dd 0
    requests_length dd 0

    admin_1 db 0
    priority_1 db 0
    passkey_1 dw 0
    username_1 times 51 db 0

    admin_2 db 0
    priority_2 db 0
    passkey_2 dw 0
    username_2 times 51 db 0

section .text
    global sort_requests
    extern printf
    extern debug_print


sort_requests:
    enter 0,0
    pusha

    mov eax, [ebp + 8]      ; requests
    mov ebx, [ebp + 12]     ; length

    mov [requests], eax
    mov [requests_length], ebx

    mov DWORD [loop_index_1], 0
    loop_1:
        mov eax, [loop_index_1]
        inc eax
        mov DWORD [loop_index_2], eax
        loop_2:
            ;; Read the request with index loop_index_1
            push admin_1
            push DWORD [loop_index_1]
            call read_admin
            add esp, 8

            push priority_1
            push DWORD [loop_index_1]
            call read_priority
            add esp, 8

            push passkey_1
            push DWORD [loop_index_1]
            call read_passkey
            add esp, 8

            push username_1
            push DWORD [loop_index_1]
            call read_username
            add esp, 8

            ;; Read the request with index loop_index_2
            push admin_2
            push DWORD [loop_index_2]
            call read_admin
            add esp, 8

            push priority_2
            push DWORD [loop_index_2]
            call read_priority
            add esp, 8

            push passkey_2
            push DWORD [loop_index_2]
            call read_passkey
            add esp, 8

            push username_2
            push DWORD [loop_index_2]
            call read_username
            add esp, 8

            call compare_requests

            inc dword [loop_index_2]
            mov ebx, [requests_length]
            cmp dword [loop_index_2], ebx
            jl loop_2

       inc dword [loop_index_1]
       mov ebx, [requests_length]
       dec ebx
       cmp dword [loop_index_1], ebx
       jl loop_1

    popa
    leave
    ret


read_admin: ;; (index, return_value) ;; <requests>
    enter 0,0
	pusha

    mov ebx, [ebp + 8]  ; index
    mov ecx, [ebp + 12]  ; return_value

    imul ebx, struct_size

    mov eax, [requests]
    mov al, [eax + ebx]
    mov [ecx], al

    popa
    leave
    ret

read_priority: ;; (index, return_value) ;; <requests>
    enter 0,0
    pusha

    mov ebx, [ebp + 8]   ; index
    mov ecx, [ebp + 12]  ; return_value

    imul ebx, struct_size

    mov eax, [requests]
    mov al, [eax + ebx + 1]
    mov [ecx], al

    popa
    leave
    ret

read_passkey: ;; (index, return_value) ;; <requests>
    enter 0,0
    pusha

    mov ebx, [ebp + 8]   ; index
    mov ecx, [ebp + 12]  ; return_value

    imul ebx, struct_size

    mov eax, [requests]
    mov ax, [eax + ebx + 2]
    mov [ecx], ax

    popa
    leave
    ret

read_username: ;; (index, return_value) ;; <requests>
    enter 0,0
    pusha

    mov ebx, [ebp + 8]   ; index
    mov ecx, [ebp + 12]  ; return_value

    imul ebx, struct_size

    mov edx, 0 ; username index
    read_username_loop:
        mov eax, [requests]
        add eax, ebx
        mov al, [eax + edx + 4]
        mov [ecx + edx], al

        inc edx
        cmp edx, username_length
        jl read_username_loop

    popa
    leave
    ret

compare_admin: ;; () ;; <admin_1, admin_2>
    enter 0,0
    pusha

    mov al, BYTE [admin_1]
    cmp al, BYTE [admin_2]

    jb admin_1_lower
    je admin_1_equal
    ja admin_1_greater

    admin_1_lower: ; admin1 < admin2
        call swap_requests
        jmp compare_admin_end
    admin_1_equal: ; admin1 == admin2
        call compare_priority
        jmp compare_admin_end
    admin_1_greater: ; admin1 > admin2
        jmp compare_admin_end

    compare_admin_end:
    popa
    leave
    ret

compare_priority: ;; () ;; <priority_1, priority_2>
    enter 0,0
    pusha

    mov al, BYTE [priority_1]
    cmp al, BYTE [priority_2]

    jb priority_1_lower
    je priority_1_equal
    ja priority_1_greater

    priority_1_equal: ; priority1 == priority2
        call compare_username
        jmp compare_priority_end
    priority_1_lower: ; priority1 < priority2
        jmp compare_priority_end
    priority_1_greater: ; priority1 > priority2
        call swap_requests
        jmp compare_priority_end

    compare_priority_end:
    popa
    leave
    ret

compare_username: ;; () ;; <username_1, username_2>
    enter 0,0
    pusha

    xor eax, eax
    compare_username_loop:
        mov bl, [username_1 + eax]
        cmp bl, [username_2 + eax]

        jb username_1_lower
        je username_1_equal
        ja username_1_greater

        username_1_lower: ; username1 < username2
            jmp compare_username_end
        username_1_greater: ; username1 > username2
            call swap_requests
            jmp compare_username_end
        username_1_equal: ; username1 == username2
            jmp compare_username_loop_continue

        compare_username_loop_continue:

        inc eax
        cmp eax, username_length
        jl compare_username_loop

    compare_username_end:
    popa
    leave
    ret

move_username: ;; (source, target) ;; <>
    enter 0,0
    pusha

    mov ecx, [ebp + 8]   ; source
    mov edx, [ebp + 12]  ; target

    mov eax, 0
    loop_3_1:
        mov bl, [ecx + eax]
        mov [edx + eax], bl

        inc eax
        cmp eax, username_length
        jl loop_3_1

    popa
    leave
    ret

swap_requests: ;; () ;; <admin_1, priority_1, passkey_1, username_1, admin_2, priority_2, passkey_2, username_2>
    enter 0,0
    pusha

    ;; Copy request 2 to the main array at index 1
    mov eax, [requests]

    mov ebx, [loop_index_1]
    imul ebx, struct_size
    add eax, ebx

    mov cl, [admin_2]
    mov [eax], cl

    mov cl, [priority_2]
    mov [eax + 1], cl

    mov cx, [passkey_2]
    mov [eax + 2], cx

    add eax, 4
    push eax
    push username_2
    call move_username
    add esp, 8

    ;; Copy request 1 to the main array at index 2
    mov eax, [requests]

    mov ebx, [loop_index_2]
    imul ebx, struct_size
    add eax, ebx

    mov cl, [admin_1]
    mov [eax], cl

    mov cl, [priority_1]
    mov [eax + 1], cl

    mov cx, [passkey_1]
    mov [eax + 2], cx

    add eax, 4
    push eax
    push username_1
    call move_username
    add esp, 8

    popa
    leave
    ret

compare_requests: ;; () ;; <>
    enter 0,0
    pusha

    call compare_admin

    popa
    leave
    ret