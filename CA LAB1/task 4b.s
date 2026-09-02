.text
.globl main
main:

    li x01, 0x100
    li x02, 0x200
    li x03, 0x300

    lb x20, 0(x01)
    lh x21, 0(x02)
    add x22, x20, x21
    sw x23, 0(x03)

    lb x20, 1(x01)
    lh x21, 2(x02)
    add x22, x20, x21
    sw x23, 4(x03)

    lb x20, 2(x01)
    lh x21, 4(x02)
    add x22, x20, x21
    sw x23, 8(x03)

    lb x20, 3(x01)
    lh x21, 6(x02)
    add x22, x20, x21
    sw x23, 12(x03)

end:
    j end 






