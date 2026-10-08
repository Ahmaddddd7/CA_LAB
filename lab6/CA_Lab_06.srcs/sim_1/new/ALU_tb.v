`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 02:19:14 PM
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb();
    reg  [31:0] A, B;
    reg  [3:0]  ALUControl;
    wire [31:0] ALUResult;
    wire Zero;

    ALU dut (.A(A), .B(B), .ALUControl(ALUControl),
             .ALUResult(ALUResult), .Zero(Zero));

    initial begin
         A = 32'hAAAAAAAA; B = 32'h55555555;

        ALUControl = 4'b0000; #10;  // ADD = FFFFFFFF
        ALUControl = 4'b0001; #10;  // SUB = 55555555
        ALUControl = 4'b0010; #10;  // AND = 00000000, Zero = 1
        ALUControl = 4'b0011; #10;  // OR  = FFFFFFFF
        ALUControl = 4'b0100; #10;  // XOR = FFFFFFFF

        A = 32'h00000001; B = 32'h00000004;
        ALUControl = 4'b0101; #10;  // SLL = 00000010

        A = 32'h80000000; B = 32'h0000001F;
        ALUControl = 4'b0110; #10;  // SRL = 00000001

        A = 32'h12345678; B = 32'h12345678;
        ALUControl = 4'b0111; #10;  // BEQ equal = 00000000, Zero = 1

        B = 32'h12345679;
        ALUControl = 4'b0111; #10;  // BEQ not equal = FFFFFFFF, Zero = 0

        $finish;
    end
   

endmodule
