.text
.globl main
main:

    li x20, 4
    li x21, 2
    li x22, 3
    li x23, 4
    li x24, 1
    li x25, 2
    li x26, 3
    li x27, 4 

    beq x20, x24, case1
    beq x20,x25, case2
    beq x20, x26, case3
    beq x20, x27, case4
    beq x0, x0, default

    case1:
    add x21, x22, x23
    beq x0,x0, exit
    case2:
    sub x21, x22, x23
    beq x0, x0, exit
    case3:
    slli x21, x22, 1
    beq x0, x0, exit
    case4:
    srli x21, x22, 1
    beq x0, x0, exit
    default:
    li x21, 0
    beq x0, x0, exit

    exit:

    end:
        j end
