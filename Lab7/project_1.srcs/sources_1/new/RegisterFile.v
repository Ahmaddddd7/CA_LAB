`timescale 1ns / 1ps

module RegisterFile(
    input         clk,           // Clock
    input         rst,           // Synchronous reset (clears all registers)
    input         WriteEnable,   // Write is performed on rising edge when high
    input  [4:0]  rs1,           // Read address 1
    input  [4:0]  rs2,           // Read address 2
    input  [4:0]  rd,            // Write address
    input  [31:0] WriteData,     // Data to be written into register rd
    output [31:0] ReadData1,     // Contents of register rs1
    output [31:0] ReadData2      // Contents of register rs2
    );
 
    reg [31:0] regs [31:0];      // Array of 32 registers, each 32 bits wide
    integer i;
 
    // Start every register at 0 
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'b0;
    end
 
    // Synchronous write port
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;                 // reset clears all registers
        end
        else if (WriteEnable && (rd != 5'd0)) begin
            regs[rd] <= WriteData;                // writes to x0 are ignored
        end
    end
 
    // Asynchronous read ports (x0 always reads as 0)
    assign ReadData1 = (rs1 == 5'd0) ? 32'b0 : regs[rs1];
    assign ReadData2 = (rs2 == 5'd0) ? 32'b0 : regs[rs2];
 
endmodule