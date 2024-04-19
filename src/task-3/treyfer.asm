;;;
;;; Copyright (c) 2024, Voinea Radu-Mihai <contact@voinearadu.com>
;;;

;;; Notes:
;;; Each sub-routine has the following signature:
;;;     sub_routine_name: ;; (arguments) ;; <local_variables>

%include "../include/io.mac"

%define block_size 8
%define num_rounds 10

section .rodata
	global sbox
	sbox db 126, 3, 45, 32, 174, 104, 173, 250, 46, 141, 209, 96, 230, 155, 197, 56, 19, 88, 50, 137, 229, 38, 16, 76, 37, 89, 55, 51, 165, 213, 66, 225, 118, 58, 142, 184, 148, 102, 217, 119, 249, 133, 105, 99, 161, 160, 190, 208, 172, 131, 219, 181, 248, 242, 93, 18, 112, 150, 186, 90, 81, 82, 215, 83, 21, 162, 144, 24, 117, 17, 14, 10, 156, 63, 238, 54, 188, 77, 169, 49, 147, 218, 177, 239, 143, 92, 101, 187, 221, 247, 140, 108, 94, 211, 252, 36, 75, 103, 5, 65, 251, 115, 246, 200, 125, 13, 48, 62, 107, 171, 205, 124, 199, 214, 224, 22, 27, 210, 179, 132, 201, 28, 236, 41, 243, 233, 60, 39, 183, 127, 203, 153, 255, 222, 85, 35, 30, 151, 130, 78, 109, 253, 64, 34, 220, 240, 159, 170, 86, 91, 212, 52, 1, 180, 11, 228, 15, 157, 226, 84, 114, 2, 231, 106, 8, 43, 23, 68, 164, 12, 232, 204, 6, 198, 33, 152, 227, 136, 29, 4, 121, 139, 59, 31, 25, 53, 73, 175, 178, 110, 193, 216, 95, 245, 61, 97, 71, 158, 9, 72, 194, 196, 189, 195, 44, 129, 154, 168, 116, 135, 7, 69, 120, 166, 20, 244, 192, 235, 223, 128, 98, 146, 47, 134, 234, 100, 237, 74, 138, 206, 149, 26, 40, 113, 111, 79, 145, 42, 191, 87, 254, 163, 167, 207, 185, 67, 57, 202, 123, 182, 176, 70, 241, 80, 122, 0

section .data
    plain_text dd 0
    key dd 0
    encrypted_text dd 0

    index dd 0
    round dd 0
    t db 0


section .text
    extern printf
	global treyfer_crypt
	global treyfer_dcrypt

treyfer_crypt: ;; (plain_text, key) ;; <>
	push ebp
	mov ebp, esp
	pusha

	mov eax, [ebp + 8]  ; plain_text
	mov ebx, [ebp + 12] ; key

    mov [plain_text], eax
    mov [key], ebx

    mov DWORD [round], 0
    round_loop:
        mov DWORD [index], 0
        encrypt_loop:
            call encrypt_step_0
            call encrypt_step_1
            call encrypt_step_2
            call encrypt_step_3
            call encrypt_step_4
            call encrypt_step_5

            mov eax, [index]
            add eax, 1
            mov [index], eax
            cmp eax, block_size
            jl encrypt_loop

        mov eax, [round]
        add eax, 1
        mov [round], eax
        cmp eax, num_rounds
        jl round_loop

	popa
	leave
	ret
	
encrypt_step_0: ;; () ;; <plain_text, index, t>
    push ebp
    mov ebp, esp
    pusha

    mov eax, [plain_text]
    mov ebx, [index]
    mov eax, [eax + ebx]

    mov [t], al

    ;PRINTF32 `t = %hhu\n\x0`, eax

    popa
    leave
    ret
    
    
encrypt_step_1: ;; () ;; <key, index, t>
    push ebp
    mov ebp, esp
    pusha

    mov eax, [key]
    mov ebx, [index]
    mov eax, [eax + ebx]

    ;PRINTF32 `key = %hhu\n\x0`, eax

    ;mov ecx, [t] ; TODO delete, only for debug
    add [t], eax

    ;PRINTF32 `t = %hhu + %hhu = %hhu\n\x0`, ecx, eax, [t]

    popa
    leave
    ret


encrypt_step_2: ;; () ;; <sbox, index, t>
    push ebp
    mov ebp, esp
    pusha

    xor eax, eax
    mov al, [t]
    mov al, [sbox + eax]

    ;mov ebx, [t] ; TODO Delete, only for debug

    mov [t], al

    ;PRINTF32 `t = sbox[%hhu] = %hhu\n\x0`, ebx, [t]

    popa
    leave
    ret

encrypt_step_3: ;; () ;; <index, plain_text, t>
    push ebp
    mov ebp, esp
    pusha

    mov eax, [index]
    add eax, 1
    cmp eax, block_size
    jne skip_set_to_zero

    mov eax, 0

    skip_set_to_zero:
    mov ebx, [plain_text]
    mov ebx, [ebx + eax]

    ;PRINTF32 `plain[%d] = %hhu\n\x0`, eax, ebx

    ;mov ecx, [t] ; TODO delete, only for debug

    add [t], ebx

    ;PRINTF32 `t = %hhu + %hhu = %hhu\n\x0`, ecx, ebx, [t]

    popa
    leave
    ret

encrypt_step_4: ;; () ;; <t, index>
    push ebp
    mov ebp, esp
    pusha

    mov eax, [t]
    mov ebx, [t] ; first bit

    and ebx, 1000_0000b
    shr ebx, 7

    shl eax, 1
    and eax, 1111_1110b

    or eax, ebx

    ;mov ecx, [t] ; TODO delete, only for debug

    mov [t], al

    ;PRINTF32 `t = %hhu <<< 1 = %hhu\n\x0`, ecx, [t]

    popa
    leave
    ret

encrypt_step_5: ;; () ;; <t>
    push ebp
    mov ebp, esp
    pusha

    mov eax, [index]
    add eax, 1
    cmp eax, block_size
    jne .skip_set_to_zero

    mov eax, 0

    .skip_set_to_zero:

    mov ebx, [plain_text]
    mov cl, [t]
    mov BYTE[ebx + eax], cl

    ;PRINTF32 `plain[%d] = %hhu\n\x0`, eax, [t]

    popa
    leave
    ret

treyfer_dcrypt: ;; (encrypted_text, key) ;; <>
	push ebp
	mov ebp, esp
	pusha

    mov eax, [ebp + 8]  ; encrypted_text
    mov ebx, [ebp + 12] ; key



	popa
	leave
	ret

