[BITS 32]

section .text
; int check_parantheses(char *str)
global check_parantheses
check_parantheses:
	push ebp
	mov ebp, esp

	; sa-nceapa concursul

	leave
	ret