`timescale 1ns / 1ps

module RF_ALU_FSM_tb();
    reg clk, rst, start;
    reg WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteData;
    reg [3:0] ALUControl;
    wire [31:0] ReadData1, ReadData2, ALUResult;
    wire Zero;
 
    RegisterFile rf (.clk(clk), .rst(rst), .WriteEnable(WriteEnable),
                     .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
                     .ReadData1(ReadData1), .ReadData2(ReadData2));
 
    ALU alu (.A(ReadData1), .B(ReadData2), .ALUControl(ALUControl),
             .ALUResult(ALUResult), .Zero(Zero));
 
    // FSM states
    localparam IDLE            = 3'd0,
               WRITE_REGS      = 3'd1,   // write constants into x1, x2, x3
               READ_REGISTERS  = 3'd2,   // pick registers and ALU operation
               ALU_OPERATION   = 3'd3,   // ALU computes
               WRITE_REGISTERS = 3'd4;   // write result into rd
 
    reg [2:0] state = IDLE;
    reg [3:0] op = 0;       // current operation number (0 to 8)
    reg [1:0] step = 0;     // current constant being written
 
    initial
        clk = 0;
    always
        #5
        clk = ~clk;   //toggling clock every 5ns
 
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            op <= 0;
            step <= 0;
            WriteEnable <= 0;
        end
        else begin
            case (state)
                IDLE: if (start) state <= WRITE_REGS;
 
                WRITE_REGS: begin
                    case (step)
                        0: begin rd <= 1; WriteData <= 32'h10101010; WriteEnable <= 1; step <= 1; end // x1 = A
                        1: begin rd <= 2; WriteData <= 32'h01010101; step <= 2; end                   // x2 = B
                        2: begin rd <= 3; WriteData <= 32'h00000005; step <= 3; end                   // x3 = 5
                        3: begin WriteEnable <= 0; step <= 0; state <= READ_REGISTERS; end
                    endcase
                end
 
                READ_REGISTERS: begin
                    case (op)
                        0: begin rs1 <= 1; rs2 <= 2; rd <= 4;  ALUControl <= 4'b0000; end // x4  = x1 + x2  = 11111111
                        1: begin rs1 <= 4; rs2 <= 2; rd <= 5;  ALUControl <= 4'b0001; end // x5  = x4 - x2  = 10101010 (reads x4 right after write)
                        2: begin rs1 <= 1; rs2 <= 2; rd <= 6;  ALUControl <= 4'b0010; end // x6  = x1 & x2  = 00000000
                        3: begin rs1 <= 1; rs2 <= 2; rd <= 7;  ALUControl <= 4'b0011; end // x7  = x1 | x2  = 11111111
                        4: begin rs1 <= 1; rs2 <= 2; rd <= 8;  ALUControl <= 4'b0100; end // x8  = x1 ^ x2  = 11111111
                        5: begin rs1 <= 1; rs2 <= 3; rd <= 9;  ALUControl <= 4'b0101; end // x9  = x1 << x3 = 02020200
                        6: begin rs1 <= 1; rs2 <= 3; rd <= 10; ALUControl <= 4'b0110; end // x10 = x1 >> x3 = 00808080
                        7: begin rs1 <= 1; rs2 <= 1; rd <= 11; ALUControl <= 4'b0111; end // BEQ x1,x1: Zero = 1, flag x11 = 1
                        8: begin rs1 <= 1; rs2 <= 2; rd <= 12; ALUControl <= 4'b0111; end // BEQ x1,x2: Zero = 0, flag x12 stays 0
                    endcase
                    state <= ALU_OPERATION;
                end
 
                ALU_OPERATION: begin
                    if (ALUControl == 4'b0111) begin   // BEQ: write flag only if Zero = 1
                        WriteData <= 32'd1;
                        WriteEnable <= Zero;
                    end
                    else begin
                        WriteData <= ALUResult;
                        WriteEnable <= 1;
                    end
                    state <= WRITE_REGISTERS;
                end
 
                WRITE_REGISTERS: begin
                    WriteEnable <= 0;
                    if (op == 8) begin                 // all operations done
                        op <= 0;
                        state <= IDLE;
                    end
                    else begin
                        op <= op + 1;
                        state <= READ_REGISTERS;
                    end
                end
 
                default: state <= IDLE;
            endcase
        end
    end
 
    initial begin
        rst = 1; start = 0;
        #20;
        rst = 0;
        #10;
        start = 1;
        #10;
        start = 0;
        #400;
    end
 
endmodule