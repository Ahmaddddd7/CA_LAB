.text
.globl main
main:
    li x22, 0
    li x24, 2
    li x25, 0x100
    li x1, 2
    sw x1, 0(x25)
    li x2, 2
    sw x2, 4(x25)
    li x3, 4
    sw x3, 8(x25)
    li x4, 2
    sw x4, 12(x25)

    Loop:
    slli x10, x22 , 2 
    add x10, x10, x25
    lw x9, 0(x10)
    bne x24, x9, exit
    addi x22, x22, 1
    beq x0, x0, Loop
    exit:

end:
    j end


