.text
.globl main
main:
    addi sp, sp, -8
    addi x5, x0, 78      
    sb   x5, 0(sp)       
    addi x5, x0, 111     
    sb   x5, 1(sp)       
    sb   x0, 2(sp)      

    addi x11, sp, 0      
    addi x10, sp, 4      
    jal  x1, strcpy

    lb   x12, 4(sp)      
    lb   x13, 5(sp)      
    lb   x14, 6(sp)      
    addi sp, sp, 8
end:
    j end

strcpy:
    addi sp, sp, -4
    sw   x19, 0(sp)

    addi x19, x0, 0      

loop:
    add  x5, x11, x19    
    lb   x6, 0(x5)       
    add  x7, x10, x19    
    sb   x6, 0(x7)       
    beq  x6, x0, leave
    addi x19, x19, 1
    jal  x0, loop

leave:
    lw   x19, 0(sp)
    addi sp, sp, 4
    jalr x0, 0(x1)