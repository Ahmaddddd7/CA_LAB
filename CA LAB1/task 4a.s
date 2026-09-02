.text
.globl main
main:
    li x10, 0x78786464
    li x02, 0x100
    sw x10, 0(x2)
    li x03, 0x1F0
    sw x11, 0(x03)

    lhwu x12, 0(x02) 
    lhw x13, 0(x03)

    lb x14, 0(x03)

end:
    j end 
  
