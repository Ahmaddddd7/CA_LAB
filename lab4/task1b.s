.text
.globl main

main:
    li x10, 3
    li x13, 1
loop:
    beq x10, x0, done
    mul x13, x13, x10
    addi x10, x10, -1
    beq x0, x0, loop
done:
    addi x10, x13, 0
    addi x11, x10, 0
    li x10, 1
    ecall
end:
    j end