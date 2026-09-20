.text
.globl main
main:

    li x10, 4
    li x11, 3
    li x12, 2
    li x13, 1

    jal x1, longleaf
    j end
longleaf:
    addi sp,sp,-12
    sw x18, 8(sp)
    sw x19,4(sp)
    sw x20, 0(sp)
    add x18, x10, x11
    add x19, x12, x13
    sub x20, x18, x19
    addi x10, x20, 0
    lw x18, 8(sp)
    lw x19, 4(sp)
    lw x20, 0(sp)
    addi sp, sp, 12
    jalr x0, 0(x1)

end:
    j end



