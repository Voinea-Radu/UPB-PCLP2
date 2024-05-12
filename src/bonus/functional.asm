[BITS 64]

; nu uitati sa scrieti in feedback ca voiati
; assembly pe 64 de biti

section .text
global map
global reduce
map:
	push rbp        ; look at these fancy registers
	mov rbp, rsp

	; sa-nceapa turneu'

	leave
	ret


; int reduce(int *dst, int *src, int n, int acc_init, int(*f)(int, int));
; int f(int acc, int curr_elem);
reduce:
	push rbp        ; look at these fancy registers
	mov rbp, rsp

	; sa-nceapa festivalu'

	leave
	ret

