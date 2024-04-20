%include "../include/io.mac"

extern printf
extern position
global solve_labyrinth

section .data
    out_line dd 0
    out_column dd 0

    lines dd 0
    columns dd 0

    is_solved db 0

    labyrinth db 0


section .text

;; void solve_labyrinth(int *out_line, int *out_col, int m, int n, char **labyrinth);
solve_labyrinth:
	push ebp
	mov ebp, esp
	pusha

    mov eax, [ebp + 8]  ; unsigned int *out_line, pointer to structure containing exit position
    mov [out_line], eax

    mov eax, [ebp + 12] ; unsigned int *out_col, pointer to structure containing exit position
    mov [out_column], eax

    mov eax, [ebp + 16] ; unsigned int m, number of lines in the labyrinth
    mov [lines], eax

    mov eax, [ebp + 20] ; unsigned int n, number of colons in the labyrinth
    mov [columns], eax

    mov eax, [ebp + 24] ; char **a, matrix represantation of the labyrinth
    mov [labyrinth], eax

    mov eax, [lines]
    sub eax, 1
    mov [lines], eax

    mov eax, [columns]
    sub eax, 1
    mov [columns], eax

    mov byte[is_solved], 0

    push 0
    push 0
    call solve
    add esp, 8

    popa
    leave
    ret

;; void solve(int y, int x);
solve:
	push ebp
	mov ebp, esp
	pusha

    .check_solved:
	mov al, [is_solved]
    cmp al, 1
    je .end

    mov eax, [ebp + 8]  ; int y - current line
    mov ebx, [ebp + 12] ; int x - current column

    .check_lines:
    cmp eax, [lines]
    jne .check_columns
    jmp .solved

    .check_columns:
    cmp ebx, [columns]
    jne .fill
    jmp .solved

    .solved:
    mov byte [is_solved], 1
    mov ecx, [out_line]
    mov [ecx], eax
    mov ecx, [out_column]
    mov [ecx], ebx
    ; PRINTF32 `SOLVED %u %u \n\x0`, [out_line], [out_column]

    jmp .end

    .fill:
    ; labyrinth[y][x] = '1'
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    mov ecx, [labyrinth]
    mov ecx, [ecx + eax * 4]
    mov byte [ecx + ebx], '1'

    .fill_1: ; labyrinth[y][x+1]
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    add ebx, 1

    ; PRINTF32 `[1] labyrinth[%u][%u] = \x0`, eax, ebx

    mov ecx, [labyrinth]
    mov ecx, [ecx + eax * 4]
    mov cl, [ecx + ebx]

    ; PRINTF32 `%c \n\x0`, ecx

    cmp cl, '1'
    je .fill_2
    push ebx
    push eax
    call solve
    add esp, 8

    .fill_2: ; labyrinth[y+1][x]
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    add eax, 1

    ; PRINTF32 `[2] labyrinth[%u][%u] = \x0`, eax, ebx

    mov ecx, [labyrinth]
    mov ecx, [ecx + eax * 4]
    mov cl, [ecx + ebx]

    ; PRINTF32 `%c \n\x0`, ecx

    cmp cl, '1'
    je .fill_3
    push ebx
    push eax
    call solve
    add esp, 8

    .fill_3: ; labyrinth[y][x-1]
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]

    cmp ebx, 0
    je .fill_4

    sub ebx, 1

    ; PRINTF32 `[3] labyrinth[%u][%u] = \x0`, eax, ebx

    mov ecx, [labyrinth]
    mov ecx, [ecx + eax * 4]
    mov cl, [ecx + ebx]

    ; PRINTF32 `%c \n\x0`, ecx

    cmp cl, '1'
    je .fill_4
    push ebx
    push eax
    call solve
    add esp, 8

    .fill_4: ; labyrinth[y-1][x]
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]

    cmp eax, 0
    je .end

    sub eax, 1

    ; PRINTF32 `[4] labyrinth[%u][%u] = \x0`, eax, ebx

    mov ecx, [labyrinth]
    mov ecx, [ecx + eax * 4]
    mov cl, [ecx + ebx]

    ; PRINTF32 `%c \n\x0`, ecx

    cmp cl, '1'
    je .end
    push ebx
    push eax
    call solve
    add esp, 8

    .end:
    popa
    leave
    ret