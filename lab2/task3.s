.text
.globl main

main:
li x22, 0
li x23, 0
li x2, 0x200
li x3, 10

for_loop1:
    beq x22, x3, end_for1
    slli x4, x22, 2
    add x5, x4, x2          #a[i]
    sw x22, 0(x5)
    addi x22, x22, 1
    beq x0,x0,for_loop1
end_for1:


li x22, 0
li x23, 0

for_loop2:
    beq x22, x3, end_for2
    slli x4, x22, 2
    add x5, x4, x2           #a[i]
    lw x7, 0(x5)
    add x23, x23, x7         
    addi x22, x22, 1
    beq x0,x0,for_loop2

end_for2:

end:
    j end
