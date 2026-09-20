.text
.globl main
main:
    addi sp, sp, -8
    li   x5, 10
    sw   x5, 0(sp)     
    li   x5, 20
    sw   x5, 4(sp)       
    mv   x10, sp         
    li   x11, 0          
    jal  x1, swap
    lw   x12, 0(sp)      
    lw   x13, 4(sp)     
    addi sp, sp, 8  
end:
    j end

swap:
    addi sp,sp,-12
    sw x5, 8(sp)
    sw x6, 4(sp)
    sw x7, 0(sp)

    slli x6, x11, 2
    add x6, x10, x6
    lw x5, 0(x6)
    lw x7, 4(x6)
    sw x7, 0(x6)
    sw x5, 4(x6)


    lw x7, 0(sp)
    lw x6, 4(sp)
    lw x5, 8(sp)
    addi sp, sp, 12
    jalr x0, 0(x1)


