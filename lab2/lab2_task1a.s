.text
.globl main
main:
        li x20, 4
        li x21, 3
        li x22, 2
        li x23, 1

        bne x22, x23, else
        add x19, x20, x21
        beq x0, x0, exit
        else: 
        sub x19, x20, x21

    exit:
end: 
    j end
    