[bits 32]

%include "../include/io.mac"

section .text
global check_parantheses

; int check_parantheses(char *str)
check_parantheses:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8] ; str



    leave
    ret
