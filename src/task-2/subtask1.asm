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

section .text
    global sort_requests
    extern printf
    extern debug_print

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

            mov eax, [requests]
            mov al, [eax + ebx]
            mov [admin_1], al

            mov eax, [requests]
            mov al, [eax + ebx + 1]
            mov [priority_1], al

            mov eax, [requests]
            mov ax, [eax + ebx + 2]
            mov [passkey_1], ax

            mov DWORD [loop_index_3], 0
            loop_3_1:
                mov ecx, [loop_index_3]

                mov eax, [requests]
                add eax, ebx
                mov al, [eax + ecx + 4]
                mov [username_1 + ecx], al

                inc dword [loop_index_3]
                cmp dword [loop_index_3], username_length
                jl loop_3_1

            ;; Read the request with index loop_index_2
            mov ebx, [loop_index_2]
            imul ebx, struct_size

            mov eax, [requests]
            mov al, [eax + ebx]
            mov [admin_2], al

            mov eax, [requests]
            mov al, [eax + ebx + 1]
            mov [priority_2], al

            mov eax, [requests]
            mov ax, [eax + ebx + 2]
            mov [passkey_2], ax

            mov DWORD [loop_index_3], 0
            loop_3_2:
                mov ecx, [loop_index_3]

                mov eax, [requests]
                add eax, ebx
                mov al, [eax + ecx + 4]
                mov [username_2 + ecx], al

                inc dword [loop_index_3]
                cmp dword [loop_index_3], username_length
                jl loop_3_2

            ;; DEBUG ;; TODO Delete

            ; PRINTF32 `Before\n\x0`
            ; PRINTF32 `Is admin? %hhd\n\x0`, [admin_1]
            ; PRINTF32 `Priority: %hhu\n\x0`, [priority_1]
            ; PRINTF32 `Passkey: %hu\n\x0`, [passkey_1]
            ; PRINTF32 `Usename: %s\n\x0`, username_1
            ; PRINTF32 `\nVS\n\n\x0`

            ; PRINTF32 `Is admin? %hhd\n\x0`, [admin_2]
            ; PRINTF32 `Priority: %hhu\n\x0`, [priority_2]
            ; PRINTF32 `Passkey: %hu\n\x0`, [passkey_2]
            ; PRINTF32 `Usename: %s\n\x0`, username_2

            ; PRINTF32 `\n\n\n\n\x0`

            ;; Compare the requests' admin status
            ; PRINTF32 `Comapring {%d} with \x0`, [loop_index_1]
            ; PRINTF32 `{%d}\n\x0`, [loop_index_2]

            mov al, BYTE [admin_1]
            cmp al, BYTE [admin_2]

            jb admin_1_lower
            je admin_1_equal
            ja admin_1_greater

            jmp compare_end

            admin_1_lower: ; admin1 < admin2
                ; PRINTF32 `admin_1 < admin_2. Swapping...\n\x0`
                jmp swap_requests
            admin_1_equal: ; admin1 == admin2
                ; PRINTF32 `admin_1 == admin_2. Correct order. Checking for priority\n\x0`
                ;; Compare the requests' priorities
                mov al, BYTE [priority_1]
                cmp al, BYTE [priority_2]

                jb priority_1_lower
                je priority_1_equal
                ja priority_1_greater
                jmp compare_end

                priority_1_equal: ; priority1 == priority2
                    ; PRINTF32 `priority_1 == priority_2. Correct. Check for username\n\x0`

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
                            ; PRINTF32 `username_1 < username_2. Correct order. Nothing to do\n\x0`
                            jmp compare_end
                        username_1_greater: ; username1 > username2
                            ; PRINTF32 `username_1 > username_2. Swapping...\n\x0`
                            jmp swap_requests
                        username_1_equal: ; username1 == username2
                            ; PRINTF32 `username_1 == username_2. Correct order. Nothing to do\n\x0`
                            jmp loop_3_9_continue

                        loop_3_9_continue:

                        inc dword [loop_index_3]
                        cmp dword [loop_index_3], username_length
                        jl loop_3_9

                    jmp compare_end
                priority_1_lower: ; priority1 < priority2
                    ; PRINTF32 `priority_1 < priority_2. Correct. Nothing to do\n\x0`
                    jmp compare_end
                priority_1_greater: ; priority1 > priority2
                    ; PRINTF32 `priority_1 > priority_2. Swapping...\n\x0`
                    ; PRINTF32 `SWAP FOR PRIORITY\n\x0`
                    jmp swap_requests
                jmp compare_end
            admin_1_greater: ; admin1 > admin2
                ; PRINTF32 `admin_1 > admin_2. Correct order. Nothing to do\n\x0`
                jmp compare_end

            swap_requests:
                ; PRINTF32 `Swaping {%d} with \x0`, [loop_index_1]
                ; PRINTF32 `{%d}\n\x0`, [loop_index_2]

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

                ;; DEBUG ;; TODO Delete
                ; PRINTF32 `After\n\x0`
                ; PRINTF32 `Is admin? %hhd\n\x0`, [admin_1]
                ; PRINTF32 `Priority: %hhu\n\x0`, [priority_1]
                ; PRINTF32 `Passkey: %hu\n\x0`, [passkey_1]
                ; PRINTF32 `Usename: %s\n\x0`, username_1
                ; PRINTF32 `\nVS\n\n\x0`

                ; PRINTF32 `Is admin? %hhd\n\x0`, [admin_2]
                ; PRINTF32 `Priority: %hhu\n\x0`, [priority_2]
                ; PRINTF32 `Passkey: %hu\n\x0`, [passkey_2]
                ; PRINTF32 `Usename: %s\n\x0`, username_2
                ; PRINTF32 `\n\n\n\n\x0`

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

                ;; DEBUG ;; TODO Delete
                ; call debug_print

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
