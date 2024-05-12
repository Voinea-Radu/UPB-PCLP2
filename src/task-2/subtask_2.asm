; subtask 2 - bsearch

section .text
    global binary_search
    ;; no extern functions allowed

binary_search:
    ;; create the new stack frame
    enter 0, 0

    ;; save the preserved registers

    ;; recursive bsearch implementation goes here

    ;; restore the preserved registers

    leave
    ret
