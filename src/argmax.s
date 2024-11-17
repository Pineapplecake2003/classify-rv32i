.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)

    li t1, 0
    li t2, 1
loop_start:
    # TODO: Add your own implementation

    # t0: maximum value in array
    # t1: index of maximum
    # t2: i
    beq a1, t6, ARGMAX_RETURN

    addi a0, a0, 4
    lw t3 0(a0)
    
    # if MEM[a0+1] > MEM[a0]
    blt t0, t3, IF_BIGGER
    j IF_BIGGER_END
    IF_BIGGER:
        # t1 <= maximum index
        mv t1, t2
        # update t0
        mv   t0, t3
    IF_BIGGER_END:

    # i ++
    addi t2, t2, 1
    # i < len(array)
    blt  t2, a1, loop_start

ARGMAX_RETURN:
    mv a0, t1
    ret

handle_error:
    li a0, 36
    j exit
