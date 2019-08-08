`timescale 1ns / 100 ps

module core_tb;
   
   // CONSTANTS
   parameter SHORT = 15;
   parameter INT = 31;
   parameter LONG = 63;
   
   // CLOCK (f = 50 MHz , T = 20 ns)
   reg clk = 0;
   always #10 clk = !clk;
   
   // RESET
   reg reset;

   reg start;
   wire finish;

   reg signed [INT:0] in;
   wire signed [INT:0] out;

   reg [INT:0] i = 0;

   initial
   begin
      $dumpfile("core-wave-sim.vcd");
      
      //$dumpvars(0, duv);
      $dumpvars;

      reset = 1;

      start = 0;

      #20 reset = 0;

      i = 0;

      #50 start = 1;

      #70 start = 0;

      
      #2000 $finish;

   end

   always #20 begin
      i = i + 1;
   end

   custom_acc_top duv ( .clk(clk),.reset(reset), .i_start(start), .o_finish(finish) );

endmodule
