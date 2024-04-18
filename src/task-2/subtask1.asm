%include "../include/io.mac"

%define username_length 50
%define struct_size 55

section .data

    loop_index_1 dd 0
    loop_index_2 dd 0
    loop_index_3 dd 0
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

    username_tmp times 51 db 0

    return_value dd 0

section .text
    global sort_requests
    extern printf
    extern debug_print


read_admin: ;; (requests, index, return_value)
    enter 0,0
	pusha

    mov eax, [ebp + 8]   ; requests
    mov ebx, [ebp + 12]  ; index
    mov ecx, [ebp + 16]  ; return_value

    mov al, [eax + ebx]
    mov [ecx], al

    popa
    leave
    ret

read_priority: ;; (requests, index, return_value)
    enter 0,0
    pusha

    mov eax, [ebp + 8]   ; requests
    mov ebx, [ebp + 12]  ; index
    mov ecx, [ebp + 16]  ; return_value

    mov al, [eax + ebx + 1]
    mov [ecx], al

    popa
    leave
    ret

read_passkey: ;; (requests, index, return_value)
    enter 0,0
    pusha

    mov eax, [ebp + 8]   ; requests
    mov ebx, [ebp + 12]  ; index
    mov ecx, [ebp + 16]  ; return_value

    mov ax, [eax + ebx + 2]
    mov [ecx], ax

    popa
    leave
    ret

read_username: ;; (requests, index, username)
    enter 0,0
    pusha

    mov eax, [ebp + 8]   ; requests
    mov ebx, [ebp + 12]  ; index
    mov ecx, [ebp + 16]  ; username

    mov edx, 0 ; username index
    read_username_loop:
        mov eax, [ebp + 8]
        add eax, ebx
        mov al, [eax + edx + 4]
        mov [ecx + edx], al

        inc edx
        cmp edx, username_length
        jl read_username_loop

    popa
    leave
    ret

sort_requests:
    enter 0,0
    pusha

    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length

    ;; Init variables
    mov DWORD [requests], 0
    mov DWORD [requests_length], 0

    mov [requests], ebx
    mov [requests_length], ecx

    mov DWORD [loop_index_1], 0
    loop_1:
        mov eax, [loop_index_1]
        inc eax
        mov DWORD [loop_index_2], eax
        loop_2:
            ;; Read the request with index loop_index_1
            mov ebx, [loop_index_1]
            imul ebx, struct_size

            push admin_1
            push ebx
            push DWORD [requests]
            call read_admin
            add esp, 12

            push priority_1
            push ebx
            push DWORD [requests]
            call read_priority
            add esp, 12

            push passkey_1
            push ebx
            push DWORD [requests]
            call read_passkey
            add esp, 12

            push username_1
            push ebx
            push DWORD [requests]
            call read_username
            add esp, 12

            ;; Read the request with index loop_index_2
            mov ebx, [loop_index_2]
            imul ebx, struct_size

            push admin_2
            push ebx
            push DWORD [requests]
            call read_admin
            add esp, 12

            push priority_2
            push ebx
            push DWORD [requests]
            call read_priority
            add esp, 12

            push passkey_2
            push ebx
            push DWORD [requests]
            call read_passkey
            add esp, 12

            push username_2
            push ebx
            push DWORD [requests]
            call read_username
            add esp, 12

            ;; Compare the requests' admin status

            mov al, BYTE [admin_1]
            cmp al, BYTE [admin_2]

            jb admin_1_lower
            je admin_1_equal
            ja admin_1_greater

            jmp compare_end

            admin_1_lower: ; admin1 < admin2
                jmp swap_requests
            admin_1_equal: ; admin1 == admin2
                ;; Compare the requests' priorities
                mov al, BYTE [priority_1]
                cmp al, BYTE [priority_2]

                jb priority_1_lower
                je priority_1_equal
                ja priority_1_greater
                jmp compare_end

                priority_1_equal: ; priority1 == priority2
                    ;; Comparing the requests' usernames
                    mov DWORD [loop_index_3], 0
                    loop_3_9:
                        mov eax, [loop_index_3]
                        mov bl, [username_1 + eax]
                        cmp bl, [username_2 + eax]

                        jb username_1_lower
                        je username_1_equal
                        ja username_1_greater
                        jmp loop_3_9_continue

                        username_1_lower: ; username1 < username2
                            jmp compare_end
                        username_1_greater: ; username1 > username2
                            jmp swap_requests
                        username_1_equal: ; username1 == username2
                            jmp loop_3_9_continue

                        loop_3_9_continue:

                        inc dword [loop_index_3]
                        cmp dword [loop_index_3], username_length
                        jl loop_3_9

                    jmp compare_end
                priority_1_lower: ; priority1 < priority2
                    jmp compare_end
                priority_1_greater: ; priority1 > priority2
                    jmp swap_requests
                jmp compare_end
            admin_1_greater: ; admin1 > admin2
                jmp compare_end

            swap_requests:
                ;; sawp admin
                mov al, [admin_1]
                mov bl, [admin_2]
                mov [admin_1], bl
                mov [admin_2], al

                ;; sawp priority
                mov al, [priority_1]
                mov bl, [priority_2]
                mov [priority_1], bl
                mov [priority_2], al

                ;; sawp passkey
                mov ax, [passkey_1]
                mov bx, [passkey_2]
                mov [passkey_1], bx
                mov [passkey_2], ax

                ;; sawp username
                mov DWORD [loop_index_3], 0
                loop_3_3:
                    mov eax, [loop_index_3]
                    mov bl, [username_1 + eax]
                    mov [username_tmp + eax], bl

                    inc dword [loop_index_3]
                    cmp dword [loop_index_3], username_length
                    jl loop_3_3

                mov DWORD [loop_index_3], 0
                loop_3_4:
                    mov eax, [loop_index_3]
                    mov bl, [username_2 + eax]
                    mov [username_1 + eax], bl

                    inc dword [loop_index_3]
                    cmp dword [loop_index_3], username_length
                    jl loop_3_4

                mov DWORD [loop_index_3], 0
                loop_3_5:
                    mov eax, [loop_index_3]
                    mov bl, [username_tmp + eax]
                    mov [username_2 + eax], bl

                    inc dword [loop_index_3]
                    cmp dword [loop_index_3], username_length
                    jl loop_3_5

                ;; Copy request 1 to the main array
                mov eax, [requests]

                mov ebx, [loop_index_1]
                imul ebx, struct_size
                add eax, ebx

                mov cl, [admin_1]
                mov [eax], cl
                mov cl, [priority_1]
                mov [eax + 1], cl
                mov cx, [passkey_1]
                mov [eax + 2], cx

                mov DWORD [loop_index_3], 0
                loop_3_6:
                    mov ebx, [loop_index_3]
                    mov cl, [username_1 + ebx]
                    mov [eax + ebx + 4], cl

                    inc dword [loop_index_3]
                    cmp dword [loop_index_3], username_length
                    jl loop_3_6

                ;; Copy request 2 to the main array
                mov eax, [requests]

                mov ebx, [loop_index_2]
                imul ebx, struct_size
                add eax, ebx

                mov cl, [admin_2]
                mov [eax], cl
                mov cl, [priority_2]
                mov [eax + 1], cl
                mov cx, [passkey_2]
                mov [eax + 2], cx

                mov DWORD [loop_index_3], 0
                loop_3_7:
                    mov ebx, [loop_index_3]
                    mov cl, [username_2 + ebx]
                    mov [eax + ebx + 4], cl

                    inc dword [loop_index_3]
                    cmp dword [loop_index_3], username_length
                    jl loop_3_7

                mov eax, [requests]
                mov ebx , [loop_index_1]

                jmp compare_end
            compare_end:

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
