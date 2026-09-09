.text
.globl main
main:

    li x1, 0x100
    li x2, 0x200
    li x3, 0x300


    li x5, 10
    sb x5, 0(x1)        #a[0] = 10
    li x5, 20
    sb x5, 1(x1)        #a[1] = 20
    li x5, 30
    sb x5, 2(x1)        #a[2] = 30
    li x5, 40
    sb x5, 3(x1)        #a[3] = 40


    li x6, 10
    sh x6, 0(x2)        #b[0] = 10
    li x6, 20
    sh x6, 2(x2)        #b[1] = 20
    li x6, 30
    sh x6, 4(x2)        #b[2] = 30
    li x6, 40
    sh x6, 6(x2)        #b[3] = 40



    lb x20, 0(x1)
    lh x21, 0(x2)
    add x22, x20, x21
    sw x22, 0(x3)

    lb x20, 1(x1)
    lh x21, 2(x2)
    add x22, x20, x21
    sw x22, 4(x3)

    lb x20, 2(x1)
    lh x21, 4(x2)
    add x22, x20, x21
    sw x22, 8(x3)

    lb x20, 3(x1)
    lh x21, 6(x2)
    add x22, x20, x21
    sw x22, 12(x3)

end:
    j end 






