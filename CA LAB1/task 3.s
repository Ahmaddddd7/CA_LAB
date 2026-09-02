.text
.globl main
main:
    
    li x01, 5   
    li x02, 0         #a = x1
    addi x02, x02, 0      #b = x2
    addi x01, x02, 32     
    add x03, x01, x02           #d = x3
    addi x03, x03, -5         
    sub x04, x01, x03             #e = x4
    sub x05, x02, x01                    #(b-a) = x5
    add x04, x04, x05
    add x04, x04, x03
    add x04, x01, x04
    add x04, x04, x02
    add x04, x04, x03
end:
    j end   