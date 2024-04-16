%include "../include/io.mac"

section .data
    struct_size dd 55

    username_length dd 50

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

sort_requests:
    enter 0,0
    pusha

    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length

    ;; Init variables
    mov DWORD [username_length], 50

    mov DWORD [requests], 0
    mov DWORD [requests_length], 0

    mov [requests], ebx
    mov [requests_length], ecx

    mov DWORD [loop_index_1], 0
    loop_1:
        mov DWORD [loop_index_2], 0
        loop_2:
            ;; Read the request with index loop_index_1
            mov ebx, [loop_index_1]
            imul ebx, [struct_size]

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
                cmp dword [loop_index_3], 50
                jl loop_3_1

            mov byte[username_1 + 51], 0

            PRINTF32 `[BEFORE 1] Is admin? %hhd\n\x0`, [admin_1]
            PRINTF32 `[BEFORE 1] Priority: %hhu\n\x0`, [priority_1]
            PRINTF32 `[BEFORE 1] Passkey: %hu\n\x0`, [passkey_1]
            PRINTF32 `[BEFORE 1] Usename: %s\n\x0`, username_1
            PRINTF32 `\nVS\n\n\x0`


            ;; Read the request with index loop_index_2
            mov ebx, [loop_index_2]
            imul ebx, [struct_size]

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
                cmp dword [loop_index_3], 50
                jl loop_3_2

            mov byte[username_2 + 51], 0

            PRINTF32 `[BEFORE 2] Is admin? %hhd\n\x0`, [admin_2]
            PRINTF32 `[BEFORE 2] Priority: %hhu\n\x0`, [priority_2]
            PRINTF32 `[BEFORE 2] Passkey: %hu\n\x0`, [passkey_2]
            PRINTF32 `[BEFORE 2] Usename: %s\n\x0`, username_2

            PRINTF32 `\n\n\n\n\x0`

            ;; Compare the requests' admin status
            mov al, BYTE [admin_1]
            cmp al, BYTE [admin_2]

            jl admin_1_lower
            jg admin_1_greater
            jmp compare_admin_end

            admin_1_lower:
                ;; sawp the requests
                PRINTF32 `SWAP FOR ADMIN\n\n\n\x0`

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
                    cmp dword [loop_index_3], 50
                    jl loop_3_3

                mov DWORD [loop_index_3], 0
                loop_3_4:
                    mov eax, [loop_index_3]
                    mov bl, [username_2 + eax]
                    mov [username_1 + eax], bl

                    inc dword [loop_index_3]
                    cmp dword [loop_index_3], 50
                    jl loop_3_4

                mov DWORD [loop_index_3], 0
                loop_3_5:
                    mov eax, [loop_index_3]
                    mov bl, [username_tmp + eax]
                    mov [username_2 + eax], bl

                    inc dword [loop_index_3]
                    cmp dword [loop_index_3], 50
                    jl loop_3_5

                PRINTF32 `[AFTER 1] Is admin? %hhd\n\x0`, [admin_1]
                PRINTF32 `[AFTER 1] Priority: %hhu\n\x0`, [priority_1]
                PRINTF32 `[AFTER 1] Passkey: %hu\n\x0`, [passkey_1]
                PRINTF32 `[AFTER 1] Usename: %s\n\x0`, username_1
                PRINTF32 `\nVS\n\n\x0`

                PRINTF32 `[AFTER 2] Is admin? %hhd\n\x0`, [admin_2]
                PRINTF32 `[AFTER 2] Priority: %hhu\n\x0`, [priority_2]
                PRINTF32 `[AFTER 2] Passkey: %hu\n\x0`, [passkey_2]
                PRINTF32 `[AFTER 2] Usename: %s\n\x0`, username_2
                PRINTF32 `\n\n\n\n\x0`

                jmp compare_admin_end
            admin_1_greater:
                ;; Compare the requests' priorities
                mov al, BYTE [priority_1]
                cmp al, BYTE [priority_2]

                jl priority_1_lower
                jg priority_1_greater
                jmp compare_admin_end
                priority_1_lower:
                    ;; sawp the requests
                    PRINTF32 `SWAP FOR PRIORITY\n\n\n\x0`

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
                    loop_3_6:
                        mov eax, [loop_index_3]
                        mov bl, [username_1 + eax]
                        mov [username_tmp + eax], bl

                        inc dword [loop_index_3]
                        cmp dword [loop_index_3], 50
                        jl loop_3_6

                    mov DWORD [loop_index_3], 0
                    loop_3_7:
                        mov eax, [loop_index_3]
                        mov bl, [username_2 + eax]
                        mov [username_1 + eax], bl

                        inc dword [loop_index_3]
                        cmp dword [loop_index_3], 50
                        jl loop_3_7

                    mov DWORD [loop_index_3], 0
                    loop_3_8:
                        mov eax, [loop_index_3]
                        mov bl, [username_tmp + eax]
                        mov [username_2 + eax], bl

                        inc dword [loop_index_3]
                        cmp dword [loop_index_3], 50
                        jl loop_3_8

                    PRINTF32 `[AFTER 1] Is admin? %hhd\n\x0`, [admin_1]
                    PRINTF32 `[AFTER 1] Priority: %hhu\n\x0`, [priority_1]
                    PRINTF32 `[AFTER 1] Passkey: %hu\n\x0`, [passkey_1]
                    PRINTF32 `[AFTER 1] Usename: %s\n\x0`, username_1
                    PRINTF32 `\nVS\n\n\x0`

                    PRINTF32 `[AFTER 2] Is admin? %hhd\n\x0`, [admin_2]
                    PRINTF32 `[AFTER 2] Priority: %hhu\n\x0`, [priority_2]
                    PRINTF32 `[AFTER 2] Passkey: %hu\n\x0`, [passkey_2]
                    PRINTF32 `[AFTER 2] Usename: %s\n\x0`, username_2
                    PRINTF32 `\n\n\n\n\x0`



                    jmp compare_admin_end
                priority_1_greater:
                    jmp compare_admin_end

                jmp compare_admin_end
            compare_admin_end:



            inc dword [loop_index_2]
            mov ebx, [requests_length]
            cmp dword [loop_index_2], ebx
            jl loop_2

       inc dword [loop_index_1]
       mov ebx, [requests_length]
       cmp dword [loop_index_1], ebx
       jl loop_1

    popa
    leave
    ret
