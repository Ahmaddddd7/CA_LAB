`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 02:13:27 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input  [31:0] A,   // Operand A
    input [31:0] B,    // Operand B
    input  [3:0]  ALUControl,   // Selects which operation to perform
    output reg [31:0] ALUResult, // Result of the ALU
    output Zero           // high when the result is 0
    );
    
     always @(*) begin        //Used for combinational logic (creates its own sensitivity list)
        case (ALUControl)
            4'b0000: ALUResult = A + B;     // ADD
            4'b0001: ALUResult = A - B;     // SUB
            4'b0010: ALUResult = A & B;     // AND
            4'b0011: ALUResult = A | B;     // OR
            4'b0100: ALUResult = A ^ B;     // XOR
            4'b0101: ALUResult = A << B[4:0];  // SLL: shift A left by B[4:0] bits
            4'b0110: ALUResult = A >> B[4:0];  // SRL: shift A right by B[4:0] bits
            4'b0111: ALUResult = A - B;      // BEQ: subtract, Zero = 1 if A == B
            default: ALUResult = 32'b0;     // unused codes output 0
        endcase
    end
    assign Zero = (ALUResult == 32'b0);  // Zero flag: high when every bit of the result is 0

endmodule
