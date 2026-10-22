module RegisterFile_tb();
    reg clk, rst, WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] WriteData;
    wire [31:0] ReadData1, ReadData2;
 
    RegisterFile dut (.clk(clk), .rst(rst), .WriteEnable(WriteEnable),
                      .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
                      .ReadData1(ReadData1), .ReadData2(ReadData2));
 
    initial
        clk = 0;
    always
        #5
        clk = ~clk;   //toggling clock every 5ns
 
    initial begin
        // Starting with reset on
        rst = 1; WriteEnable = 0; rs1 = 0; rs2 = 0; rd = 0; WriteData = 0;
        #20;
        rst = 0; // reset released
 
        // Test 1: write DEADBEEF into x5, then read it from both ports
        rd = 5'd5; WriteData = 32'hDEADBEEF; WriteEnable = 1;
        #10;
        WriteEnable = 0;
        rs1 = 5'd5; rs2 = 5'd5;
        #10; // ReadData1 = DEADBEEF, ReadData2 = DEADBEEF
 
        // Test 2: try to write x0, it must stay 0
        rd = 5'd0; WriteData = 32'hFFFFFFFF; WriteEnable = 1;
        #10;
        WriteEnable = 0;
        rs1 = 5'd0; rs2 = 5'd0;
        #10; // ReadData1 = 00000000, ReadData2 = 00000000
 
        // Test 3: two different registers read at the same time
        rd = 5'd10; WriteData = 32'h11111111; WriteEnable = 1;
        #10;
        rd = 5'd11; WriteData = 32'h22222222;
        #10;
        WriteEnable = 0;
        rs1 = 5'd10; rs2 = 5'd11;
        #10; // ReadData1 = 11111111, ReadData2 = 22222222
 
        // Test 4: overwrite x5, old value must be replaced
        rd = 5'd5; WriteData = 32'h48454C4F; WriteEnable = 1;
        #10;
        WriteEnable = 0;
        rs1 = 5'd5;
        #10; // ReadData1 = 48454C4F ("HELO" in ASCII)
 
        // Test 5: WriteEnable = 0, x7 must not change
        rd = 5'd7; WriteData = 32'h12345678; WriteEnable = 0;
        #10;
        rs1 = 5'd7;
        #10; // ReadData1 = 00000000
 
        // Test 6: reset clears the registers
        rst = 1;
        #10;
        rst = 0;
        rs1 = 5'd5; rs2 = 5'd11;
        #10; // ReadData1 = 00000000, ReadData2 = 00000000
 
        #20;
    end
 
endmodule