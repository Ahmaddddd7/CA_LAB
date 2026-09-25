.text
.globl main

main:
    addi x10, x0,5
    jal  x1, fibonacci          
    addi x11, x10, 0         
    addi x10, x0, 1           
    ecall
    beq  x0, x0, end          
fibonacci:
    addi x5, x10, -2
    bge  x5, x0, recursive
    jalr x0, 0(x1)
recursive:
    addi sp, sp, -12
    sw   x1, 8(sp)
    sw   x10, 4(sp)
    addi x10, x10, -1
    jal  x1, fibonacci
    sw   x10, 0(sp)
    lw   x10, 4(sp)
    addi x10, x10, -2
    jal  x1, fibonacci
    lw   x6, 0(sp)
    lw   x1, 8(sp)
    addi sp, sp, 12
    add  x10, x10, x6
    jalr x0, 0(x1)
end:
    j end