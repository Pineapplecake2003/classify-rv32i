# Assignment 2: Classify
This file explains how I implement each function in each file.

## 1. abs.s
In this file, I use the `srai` instruction to create a mask that is -1 when the input is less than 0, and 0 when the input is greater than or equal to 0. Then, I use the `xor` instruction with the input and the mask. Finally, I use the sub instruction with the mask. If the input is less than 0, it will be XORed with -1 (complemented) and then 1 will be added. If the input is greater than or equal to 0, there will be no change.


## 2. relu.s  
In this file, I use the `srai` instruction to create a mask that is -1 when the input is less than 0, and 0 when the input is greater than or equal to 0. Then, I use the `not` instruction to invert the mask bitwise, so that the mask will be 0 if the input is less than 0, and -1 when the input is greater than or equal to 0. Finally, I use the `and` instruction with the input and the mask. If the input is less than 0, it will become 0. If the input is greater than or equal to 0, there will be no change. This implements the function $f(x) = \max(0, x)$.

## 3. argmax.s
In this file
* t0: maximum value in array
* t1: index of maximum value
* t2: counter(`i`)  

At the start of the loop, `t3` register will load `*(a0 + i)` value and compare it with current maximum value, if the loaded value is greater, the maximum value and the index of the maximum value will be updated.  
And use 
```asm=
# i ++
addi t2, t2, 1
# i < len(array)
blt  t2, a1, loop_start
```
as counter increment and stop condition of loop.

## 4. dot.s
In this file
* t0: result
* t1: counter(`i`)  

At the start of the loop, `t2` and `t3` register will load `*(a0 + i)` and  `*(a1 + i)` and use simple add and shift multiply algorithm:
```asm=
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
```
This implements a 32-bit multiplication. After multiplying t2 and t3, the result is added to t0 (result).

Use the following code to shift pointers a0 and a1 with strides:
```asm=
slli t4, a3, 2 
slli t5, a4, 2
# shift with strides
add a0, a0, t4
add a1, a1, t5
```
The reason of `slli` is to shift pointer with words(4bytes).

## 5. matmul.s
Add following code in `inner_loop_end:`
```asm=
slli t2, a2, 2
add s3, s3, t2
# outer counter ++
addi s0, s0, 1
j outer_loop_start
```
Use `slli t2, a2, 2` and `add s3, s3, t2` to shift `s3` by `a2` words.

## 6. read_matrix.s/write_matrix.s/classify.s
The content I need to implement is 32-bit multiply. I use similar code in each file.
```asm=
<Save used registers>
<multiply_label>:
    li <result register>, 0
    li <counter>, 0
    li <-1 constant register>, 32

    <mul_loop_label>:
        beq  <counter>, <-1 constant register>, <end_multiply_label>
        andi <temp register>, <multiplicand>, 1
        beq  <temp register>, x0, <skip_label>
        add  <result register>, <result register>, <multiplier>

    <skip_label>:
        slli <multiplier>, <multiplier>, 1
        srli <multiplicand>, <multiplicand>, 1
        addi <counter>, <counter>, 1
        j <mul_loop_label>
<end_multiply_label>:

mv <target register> <result register>

<Load used registers>
```
The labels `<multiply_label>`, `<mul_loop_label>`, `<end_multiply_label>`, `<skip_label>`, and `<end_multiply_label>` are different in each file.

Instead of using another function, this approach can reduce redundant branch instructions.

# Result
```
test_abs_minus_one (__main__.TestAbs.test_abs_minus_one) ... ok
test_abs_one (__main__.TestAbs.test_abs_one) ... ok
test_abs_zero (__main__.TestAbs.test_abs_zero) ... ok
test_argmax_invalid_n (__main__.TestArgmax.test_argmax_invalid_n) ... ok
test_argmax_length_1 (__main__.TestArgmax.test_argmax_length_1) ... ok
test_argmax_standard (__main__.TestArgmax.test_argmax_standard) ... ok
test_chain_1 (__main__.TestChain.test_chain_1) ... ok
test_classify_1_silent (__main__.TestClassify.test_classify_1_silent) ... ok
test_classify_2_print (__main__.TestClassify.test_classify_2_print) ... ok
test_classify_3_print (__main__.TestClassify.test_classify_3_print) ... ok
test_classify_fail_malloc (__main__.TestClassify.test_classify_fail_malloc) ... ok
test_classify_not_enough_args (__main__.TestClassify.test_classify_not_enough_args) ... ok
test_dot_length_1 (__main__.TestDot.test_dot_length_1) ... ok
test_dot_length_error (__main__.TestDot.test_dot_length_error) ... ok
test_dot_length_error2 (__main__.TestDot.test_dot_length_error2) ... ok
test_dot_standard (__main__.TestDot.test_dot_standard) ... ok
test_dot_stride (__main__.TestDot.test_dot_stride) ... ok
test_dot_stride_error1 (__main__.TestDot.test_dot_stride_error1) ... ok
test_dot_stride_error2 (__main__.TestDot.test_dot_stride_error2) ... ok
test_matmul_incorrect_check (__main__.TestMatmul.test_matmul_incorrect_check) ... ok
test_matmul_length_1 (__main__.TestMatmul.test_matmul_length_1) ... ok
test_matmul_negative_dim_m0_x (__main__.TestMatmul.test_matmul_negative_dim_m0_x) ... ok
test_matmul_negative_dim_m0_y (__main__.TestMatmul.test_matmul_negative_dim_m0_y) ... ok
test_matmul_negative_dim_m1_x (__main__.TestMatmul.test_matmul_negative_dim_m1_x) ... ok
test_matmul_negative_dim_m1_y (__main__.TestMatmul.test_matmul_negative_dim_m1_y) ... ok
test_matmul_nonsquare_1 (__main__.TestMatmul.test_matmul_nonsquare_1) ... ok
test_matmul_nonsquare_2 (__main__.TestMatmul.test_matmul_nonsquare_2) ... ok
test_matmul_nonsquare_outer_dims (__main__.TestMatmul.test_matmul_nonsquare_outer_dims) ... ok
test_matmul_square (__main__.TestMatmul.test_matmul_square) ... ok
test_matmul_unmatched_dims (__main__.TestMatmul.test_matmul_unmatched_dims) ... ok
test_matmul_zero_dim_m0 (__main__.TestMatmul.test_matmul_zero_dim_m0) ... ok
test_matmul_zero_dim_m1 (__main__.TestMatmul.test_matmul_zero_dim_m1) ... ok
test_read_1 (__main__.TestReadMatrix.test_read_1) ... ok
test_read_2 (__main__.TestReadMatrix.test_read_2) ... ok
test_read_3 (__main__.TestReadMatrix.test_read_3) ... ok
test_read_fail_fclose (__main__.TestReadMatrix.test_read_fail_fclose) ... ok
test_read_fail_fopen (__main__.TestReadMatrix.test_read_fail_fopen) ... ok
test_read_fail_fread (__main__.TestReadMatrix.test_read_fail_fread) ... ok
test_read_fail_malloc (__main__.TestReadMatrix.test_read_fail_malloc) ... ok
test_relu_invalid_n (__main__.TestRelu.test_relu_invalid_n) ... ok
test_relu_length_1 (__main__.TestRelu.test_relu_length_1) ... ok
test_relu_standard (__main__.TestRelu.test_relu_standard) ... ok
test_write_1 (__main__.TestWriteMatrix.test_write_1) ... ok
test_write_fail_fclose (__main__.TestWriteMatrix.test_write_fail_fclose) ... ok
test_write_fail_fopen (__main__.TestWriteMatrix.test_write_fail_fopen) ... ok
test_write_fail_fwrite (__main__.TestWriteMatrix.test_write_fail_fwrite) ... ok

----------------------------------------------------------------------
Ran 46 tests in 267.233s

OK
```