.text
.globl main
main:
    addi x10, x0, 5
    addi x18, x0, 2
    jal  x1, nitri
    addi x11, x10, 0
    addi x10, x0, 1
    ecall
    beq  x0, x0, end
nitri:
    blt  x10, x18, basecase
    addi sp, sp, -8
    sw   x10, 0(sp)
    sw   x1, 4(sp)
    addi x10, x10, -1
    jal  x1, nitri
    addi x19, x10, 0
    lw   x1, 4(sp)
    lw   x10, 0(sp)
    addi sp, sp, 8
    add  x10, x19, x10
    jalr x0, 0(x1)
basecase:
    addi x10, x0, 1
    jalr x0, 0(x1)
end:
    j end