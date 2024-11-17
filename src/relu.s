.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             

loop_start:
    # TODO: Add your own implementation
    
    # t2 = a0[0]
    lw t2 0(a0)

    # t3: sign bit of t2
    srai t3, t2, 31

    # t2 = !sign bit & t2
    not t3, t3
    and t2, t2, t3
    # save ans
    sw t2 0(a0)
    
    # point to [a0+1]
    addi a0, a0, 4
    
    # i++
    addi t1, t1, 1

    # i < len(array)
    blt t1, a1, loop_start
ret
error:
    li a0, 36          
    j exit          
