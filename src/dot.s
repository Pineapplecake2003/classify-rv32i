.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate 

    li t0, 0            
    li t1, 0         

loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation
    # t1: i
    # t0: result

    lw t2, 0(a0)
    lw t3, 0(a1)
    
    # MEM[a0] * MEM[a1]
    # result += MEM[a0] * MEM[a1]
    addi sp, sp, -4
    sw  t0, 0(sp)
    MUL:
        # result(t0) = t2 * t3 
        # t0: result of mul
        li t0, 0
        # t4: counter
        li t4, 0
        # t5: 32 bits
        li t5, 32
        mul_loop:
            beq  t4, t5, END_MEL
            andi t6, t3, 1
            beq  t6, x0, skip
            add  t0, t0, t2

        skip:
            slli t2, t2, 1
            srli t3, t3, 1
            addi t4, t4, 1
            j mul_loop
    END_MEL:
    # t2 = t2 * t3
    mv t2, t0
    
    lw  t0, 0(sp)
    addi sp, sp, 4

    # result += t2 * t3    
    add t0, t0, t2



    slli t4, a3, 2
    slli t5, a4, 2

    # shift with strides
    add a0, a0, t4
    add a1, a1, t5

    # i++
    addi t1, t1, 1

    j loop_start

loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
