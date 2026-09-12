.text
.globl main

main:

    li x5, 10       # a
    li x6, 10       # b
    li x7, 0        # i
    li x29, 0       # j
    li x10, 0x100   #base address of array D

    for_loop1:
    beq x7, x5, end_for1
    li x29, 0
        for_loop2:
            beq x29, x6, end_for2
            slli x8, x29, 4  
            add x11, x10, x8  
            add x12, x7, x29
            sw x12, 0(x11)
            addi x29, x29, 1
            beq x0,x0,for_loop2
        end_for2:
            addi x7, x7, 1
            beq x0, x0, for_loop1
    end_for1:
        end:
            j end
