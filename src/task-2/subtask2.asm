%include "../include/io.mac"

%define struct_size 55

section .data
    requests dd 0
    requests_length dd 0
    connected dd 0

    passkey dw 0

    loop_index_1 dd 0
    loop_index_2 dd 0

section .text
    global check_passkeys
    extern printf

check_passkeys:
    enter 0, 0
    pusha

    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; connected

    mov [requests], ebx
    mov [requests_length], ecx
    mov [connected], eax

    mov DWORD [loop_index_1], 0
    loop_1:
        mov eax, [loop_index_1]
        imul eax, struct_size

        mov ebx, [requests]
        mov bx, [ebx + eax + 2]

        mov [passkey], bx
        PRINTF32 `Passkey: %hu\n\x0`, ebx

        xor ebx, ebx
        mov bx, [passkey]
        and bx, 1000_0000_0000_0000b
        shr bx, 15
        PRINTF32 `first bit of the passkey: %hu\n\x0`, ebx
        cmp bx, 1
        jne continue_loop_1

        xor ebx, ebx
        mov bx, [passkey]
        and bx, 0000_0000_0000_0001b
        PRINTF32 `last bit of the passkey: %hu\n\x0`, ebx
        cmp bx, 1
        jne continue_loop_1
        jmp check_for_hacker

        check_for_hacker:
            PRINTF32 `Checking for hacker...\n\x0`

            PRINTF32 `Checking for hacker (first 8 bits)...\n\x0`
            xor eax, eax
            mov ax, [passkey]
            and ax, 1111_1111_0000_0000b
            shr ax, 8

            PRINTF32 `eax: 0x%x...\n\x0`, eax

            mov ebx, 0 ; counter

            mov DWORD [loop_index_2], 0
            loop_2:
                xor ecx, ecx
                mov ecx, eax
                and ecx, 1
                add ebx, ecx

                shr eax, 1
                inc DWORD [loop_index_2]
                cmp DWORD [loop_index_2], 8
                jb loop_2

            PRINTF32 `Counter: %d\n\x0`, ebx
            and ebx, 1
            cmp ebx, 0
            jne continue_loop_1

            PRINTF32 `Checking for hacker (last 8 bits)...\n\x0`

            xor eax, eax
            mov ax, [passkey]
            and ax, 0000_0000_1111_1111b

            PRINTF32 `eax: 0x%x...\n\x0`, eax

            mov ebx, 0 ; counter

            mov DWORD [loop_index_2], 0
            loop_3:
                xor ecx, ecx
                mov ecx, eax
                and ecx, 1
                add ebx, ecx

                shr eax, 1
                inc DWORD [loop_index_2]
                cmp DWORD [loop_index_2], 8
                jb loop_3

            PRINTF32 `Counter: %d\n\x0`, ebx
            and ebx, 1
            cmp ebx, 1
            jne continue_loop_1



            PRINTF32 `\n\n\x0`


        continue_loop_1:

        inc DWORD [loop_index_1]
        mov eax, [loop_index_1]
        cmp eax, [requests_length]
        jb loop_1


    popa
    leave
    ret
