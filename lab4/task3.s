.text
.globl main
main:
    addi x11, x0, 5
    addi x10, x0, 0x100
    addi x5, x0, 1
    sw x5, 0(x10)
    addi x5, x0, 8
    sw x5, 4(x10)
    addi x5, x0, 2
    sw x5, 8(x10)
    addi x5, x0, 6
    sw x5, 12(x10)
    addi x5, x0, 5
    sw x5, 16(x10)
    beq x10, x0, end
    beq x11, x0, end
bubble_sort:
    addi x20, x0, 0
bigloop:
    bge x20, x11, end
    addi x21, x20, 0
smallloop:
    bge x21, x11, outerloopnext
    slli x22, x20, 2
    add x22, x22, x10
    lw x24, 0(x22)
    slli x23, x21, 2
    add x23, x23, x10
    lw x25, 0(x23)
    bge x24, x25, swapnotdone 
    sw x25, 0(x22)
    sw x24, 0(x23)
swapnotdone:
    addi x21, x21, 1
    beq x0, x0, smallloop
outerloopnext:
    addi x20, x20, 1
    beq x0, x0, bigloop
end:
    j end