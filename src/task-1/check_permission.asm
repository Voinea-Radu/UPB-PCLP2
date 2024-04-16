%include "../include/io.mac"

extern ant_permissions

extern printf
global check_permission

section .data
    ant_index dd 0
    requested_permissions dd 0

section .text

check_permission:
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; id and permission
    mov     ebx, [ebp + 12] ; address to return the result

    ;; Get the ant id
    mov ecx, eax
    and ecx, 0xFF000000
    shr ecx, 24
    mov [ant_index], ecx

    ;; Get the requested permissions
    mov edx, eax
    and edx, 0x00FFFFFF
    mov [requested_permissions], edx

    ;; Get the ant permissions
    mov eax, [ant_permissions + ecx * 4]

    mov DWORD[ebx], 1 ; assume the ant has the requested permissions

    ;; Check if the ant has the requested permissions
    and eax, [requested_permissions]
    cmp eax, [requested_permissions]
    jz end

    mov DWORD[ebx], 0 ; the ant does not have the requested permissions

end:
    popa
    leave
    ret
