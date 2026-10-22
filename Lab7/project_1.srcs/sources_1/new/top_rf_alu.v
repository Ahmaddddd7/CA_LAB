`timescale 1ns / 1ps

module top_rf_alu (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);
 
    // DEBOUNCER (Cleans up the physical reset button signal)
    wire rst_clean;
    wire [31:0] switch_data;                // hold the value read from the switches
    reg [31:0] led_write_data = 32'd0;      // value shown on the LEDs
    wire slow_clk;
 
    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)                   //generated a clean signal
    );
 
    leds switch_reader (
        .clk(clk), .rst(rst_clean),
        .btns(16'd0),                       // Not used
        .writeData(32'd0),                  // We don't write to switches
        .writeEnable(1'b0),                 // Disabled
        .readEnable(1'b1),                  // Always ON so we can monitor switches
        .memAddress(30'd0),
        .switches(physical_sw),             // Plug in the physical switches
        .readData(switch_data)              // output data
    );
 
    switches led_writer (
        .clk(clk), .rst(rst_clean),
        .writeData(led_write_data),
        .writeEnable(1'b1),                 // Always ON so LEDs update instantly
        .readEnable(1'b0), .memAddress(30'd0),
        .readData(),                        // Ignored
        .leds(physical_leds)
    );
 
    clock_divider ticker (
        .clk_in(clk),                       // Feed it the 100MHz fast clock
        .rst(rst_clean),                    // Feed it the clean reset signal
        .clk_out(slow_clk)                  // slow clock
    );
 
    // Slow clk edge detection (same as Lab 5): FSM moves once per tick
    reg slow_clk_d = 1'b0;
    wire tick = (slow_clk != slow_clk_d);
 
    // Register File
    reg WriteEnable = 0;
    reg [4:0] rs1 = 0, rs2 = 0, rd = 0;
    reg [31:0] WriteData = 0;
    wire [31:0] ReadData1, ReadData2;
 
    RegisterFile rf (.clk(clk), .rst(rst_clean), .WriteEnable(WriteEnable),
                     .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
                     .ReadData1(ReadData1), .ReadData2(ReadData2));
 
    // ALU
    reg [3:0] ALUControl = 0;
    wire [31:0] ALUResult;
    wire Zero;
 
    ALU alu (.A(ReadData1), .B(ReadData2), .ALUControl(ALUControl),
             .ALUResult(ALUResult), .Zero(Zero));
 
    // FSM states
    localparam IDLE            = 3'd0,
               WRITE_REGS      = 3'd1,   // write A and B constants into x1, x2 (and 5 into x3)
               READ_REGISTERS  = 3'd2,   // select registers and ALU operation
               ALU_OPERATION   = 3'd3,   // ALU computes
               WRITE_REGISTERS = 3'd4;   // write result into rd
 
    reg [2:0] state = IDLE;
    reg [2:0] demo_idx = 0;              // which demo operation (0 to 7)
    reg [1:0] step = 0;                  // which constant is being written
    reg init_done = 0;                   // constants already written
    reg [31:0] result_reg = 0;           // result shown on LEDs
    reg zero_reg = 0;                    // Zero flag shown on LED
 
    wire demo_mode = switch_data[15];
 
    always @(posedge clk) begin
        slow_clk_d <= slow_clk;          // previous value of slow_clk
 
        if (rst_clean) begin
            state <= IDLE;
            demo_idx <= 0;
            step <= 0;
            init_done <= 0;
            WriteEnable <= 0;
            result_reg <= 0;
            zero_reg <= 0;
        end
        else if (tick) begin
            case (state)
                IDLE: begin
                    if (init_done)
                        state <= READ_REGISTERS;
                    else
                        state <= WRITE_REGS;
                end
 
                WRITE_REGS: begin
                    case (step)
                        2'd0: begin rd <= 5'd1; WriteData <= 32'h10101010; WriteEnable <= 1; step <= 1; end // x1 = A
                        2'd1: begin rd <= 5'd2; WriteData <= 32'h01010101; step <= 2; end                   // x2 = B
                        2'd2: begin rd <= 5'd3; WriteData <= 32'h00000005; step <= 3; end                   // x3 = 5
                        2'd3: begin WriteEnable <= 0; step <= 0; init_done <= 1; state <= IDLE; end
                    endcase
                end
 
                READ_REGISTERS: begin
                    if (demo_mode) begin
                        case (demo_idx)
                            3'd0: begin rs1 <= 5'd1; rs2 <= 5'd2; rd <= 5'd4;  ALUControl <= 4'b0000; end // x4  = x1 + x2
                            3'd1: begin rs1 <= 5'd4; rs2 <= 5'd2; rd <= 5'd5;  ALUControl <= 4'b0001; end // x5  = x4 - x2 (read after write)
                            3'd2: begin rs1 <= 5'd1; rs2 <= 5'd2; rd <= 5'd6;  ALUControl <= 4'b0010; end // x6  = x1 & x2
                            3'd3: begin rs1 <= 5'd1; rs2 <= 5'd2; rd <= 5'd7;  ALUControl <= 4'b0011; end // x7  = x1 | x2
                            3'd4: begin rs1 <= 5'd1; rs2 <= 5'd2; rd <= 5'd8;  ALUControl <= 4'b0100; end // x8  = x1 ^ x2
                            3'd5: begin rs1 <= 5'd1; rs2 <= 5'd3; rd <= 5'd9;  ALUControl <= 4'b0101; end // x9  = x1 << x3
                            3'd6: begin rs1 <= 5'd1; rs2 <= 5'd3; rd <= 5'd10; ALUControl <= 4'b0110; end // x10 = x1 >> x3
                            3'd7: begin rs1 <= 5'd1; rs2 <= 5'd1; rd <= 5'd11; ALUControl <= 4'b0111; end // BEQ x1, x1 -> flag x11
                        endcase
                    end
                    else begin                         // manual mode: A = x1, B = x2, operation from switches
                        rs1 <= 5'd1;
                        rs2 <= 5'd2;
                        rd <= switch_data[8:4];
                        ALUControl <= switch_data[3:0];
                    end
                    state <= ALU_OPERATION;
                end
 
                ALU_OPERATION: begin
                    result_reg <= ALUResult;           // result and Zero flag shown on LEDs
                    zero_reg <= Zero;
                    if (demo_mode && ALUControl == 4'b0111) begin   // demo BEQ: flag = 1 written only if Zero = 1
                        WriteData <= 32'd1;
                        WriteEnable <= Zero;
                    end
                    else begin
                        WriteData <= ALUResult;
                        if (demo_mode)
                            WriteEnable <= 1;
                        else
                            WriteEnable <= switch_data[9];          // WriteEnable from switch
                    end
                    state <= WRITE_REGISTERS;
                end
 
                WRITE_REGISTERS: begin
                    WriteEnable <= 0;
                    if (demo_mode && demo_idx == 3'd7) begin        // all demo operations done
                        demo_idx <= 0;
                        state <= IDLE;
                    end
                    else begin
                        if (demo_mode)
                            demo_idx <= demo_idx + 1;
                        state <= READ_REGISTERS;
                    end
                end
 
                default: state <= IDLE;
            endcase
        end
    end
 
    //Drive LEDs: FSM state, Zero flag, lower 12 bits of the result
    always @(*)
    begin
        led_write_data = {16'd0, state, zero_reg, result_reg[11:0]};
    end
 
endmodule