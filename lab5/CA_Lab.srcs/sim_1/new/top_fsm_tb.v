`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2026 02:16:08 PM
// Design Name: 
// Module Name: top_fsm_tb
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


module top_fsm_tb();
    reg clk;
    reg pbin;
    reg [15:0] physical_sw;
    wire [15:0] physical_leds;
    
    top_fsm_system aj(.clk(clk), .pbin(pbin), .physical_sw(physical_sw), .physical_leds(physical_leds) );
    
    initial  
    clk=0;
    always 
    #5 
    clk = ~clk;  //toggling clock every 5ns

    initial begin

        // Starting with reset pressed and  switches at 0
        pbin        = 1;   // reset active 
        physical_sw = 16'd0;
        #10;

        pbin = 0; // reset released
        #10;

        // Apply a switch value of 3 applied while in idle state 
        // transitions to count state : loads counter and start countdown
        physical_sw = 16'd3;
        #10;

        // clear switches back to 0, FSM remains in count state
        physical_sw = 16'd0;

        // 4 Wait  for the counter to count down to 0
        #150;

        //Trying countdown value of 5
        physical_sw = 16'd5;
        #10;
        physical_sw = 16'd0; //switch reset to zero, FSM stays in count
        #200;

        // Testing reset while mid-count:
        physical_sw = 16'd10; //countdown from 10
        #10;
        physical_sw = 16'd0;
        #40;                // let it start counting down
        pbin = 1;           // press reset in the middle of counting
        #10;
        pbin = 0;           // release reset
        #10;

        // Confirm FSM is back in idle by starting a fresh count
        physical_sw = 16'd4; //countdown set to 4
        #10;
        physical_sw = 16'd0;
        #150;

       
        $finish; //end simulation
    end

endmodule
    

