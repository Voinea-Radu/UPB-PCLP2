%include "../include/io.mac"

section .data
    struct_size dd 55

    username_length dd 50

    loop_index_1 dd 0
    loop_index_2 dd 0
    loop_index_3 dd 0
    requests dd 0
    requests_length dd 0

    is_admin_1 db 0
    priority_1 db 0
    passkey_1 dw 0
    username_1 times 51 db 0

    is_admin_2 db 0
    priority_2 db 0
    passkey_2 dw 0
    username_2 times 51 db 0

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
            mov eax, [eax + ebx]
            and eax, 0xFF
            mov [is_admin_1], eax

            mov eax, [requests]
            mov eax, [eax + ebx + 1]
            and eax, 0xFF
            mov [priority_1], eax

            mov eax, [requests]
            mov eax, [eax + ebx + 2]
            and eax, 0xFFFF
            mov [passkey_1], eax

            mov DWORD [loop_index_3], 0
            loop_3_1:
                mov ecx, [loop_index_3]

                mov eax, [requests]
                add eax, ebx
                mov eax, [eax + ecx + 4]
                and eax, 0xFF
                mov [username_1 + ecx], eax

                inc dword [loop_index_3]
                cmp dword [loop_index_3], 50
                jl loop_3_1

            mov byte[username_1 + 51], 0

            PRINTF32 `[1] Is admin? %hhd\n\x0`, [is_admin_1]
            PRINTF32 `[1] Priority: %hhu\n\x0`, [priority_1]
            PRINTF32 `[1] Passkey: %hu\n\x0`, [passkey_1]
            PRINTF32 `[1] Usename: %s\n\x0`, username_1
            PRINTF32 `\nVS\n\n\x0`


            ;; Read the request with index loop_index_2
            mov ebx, [loop_index_2]
            imul ebx, [struct_size]

            mov eax, [requests]
            mov eax, [eax + ebx]
            and eax, 0xFF
            mov [is_admin_2], eax

            mov eax, [requests]
            mov eax, [eax + ebx + 1]
            and eax, 0xFF
            mov [priority_2], eax

            mov eax, [requests]
            mov eax, [eax + ebx + 2]
            and eax, 0xFFFF
            mov [passkey_2], eax

            mov DWORD [loop_index_3], 0
            loop_3_2:
                mov ecx, [loop_index_3]

                mov eax, [requests]
                add eax, ebx
                mov eax, [eax + ecx + 4]
                and eax, 0xFF
                mov [username_2 + ecx], eax

                inc dword [loop_index_3]
                cmp dword [loop_index_3], 50
                jl loop_3_2

            mov byte[username_2 + 51], 0

            PRINTF32 `[2] Is admin? %hhd\n\x0`, [is_admin_2]
            PRINTF32 `[2] Priority: %hhu\n\x0`, [priority_2]
            PRINTF32 `[2] Passkey: %hu\n\x0`, [passkey_2]
            PRINTF32 `[2] Usename: %s\n\x0`, username_2
            PRINTF32 `\n\n\n\n\x0`

            ;; Compare the requests



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
