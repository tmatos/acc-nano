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

      
      //#2000 $finish;
      #200 $finish;

   end

   always #20 begin
      i = i + 1;
   end

/*
   kernel_atax_top duv ( 
      .clk(clk),
      .reset(reset),
      .start(start),
      .finish(finish),

      .main_y_write_enable_a(),
      .main_y_in_a(),
      .main_y_byteena_a(),
      .main_y_enable_a(),
      .main_y_address_a(),
      .main_y_out_a(),
      .main_y_write_enable_b(),
      .main_y_in_b(),
      .main_y_byteena_b(),
      .main_y_enable_b(),
      .main_y_address_b(),
      .main_y_out_b(),

      .main_x_write_enable_a(),
      .main_x_in_a(),
      .main_x_byteena_a(),
      .main_x_enable_a(),
      .main_x_address_a(),
      .main_x_out_a(),
      .main_x_write_enable_b(),
      .main_x_in_b(),
      .main_x_byteena_b(),
      .main_x_enable_b(),
      .main_x_address_b(),
      .main_x_out_b(),

      .main_A_a0_a0_write_enable_a(),
      .main_A_a0_a0_in_a(),
      .main_A_a0_a0_byteena_a(),
      .main_A_a0_a0_enable_a(),
      .main_A_a0_a0_address_a(),
      .main_A_a0_a0_out_a(),
      .main_A_a0_a0_write_enable_b(),
      .main_A_a0_a0_in_b(),
      .main_A_a0_a0_byteena_b(),
      .main_A_a0_a0_enable_b(),
      .main_A_a0_a0_address_b(),
      .main_A_a0_a0_out_b()

   );
*/


defparam duv.BUS_SIZE = 64;
defparam duv.BUS_BYTES = 8;

legup_atax_top duv (

   .clk(clk),
   .reset(reset),
   .coe_start_export(start),
   .coe_finish_export(finish),

   .cso_avmclk_clk(),
   .rso_avmrst_reset(),


   // A (2d array)

   .avm_arg_A_read(),
   .avm_arg_A_write(),
   .avm_arg_A_address(),
   .avm_arg_A_readdata(),
   .avm_arg_A_writedata(),
   .avm_arg_A_waitrequest(),
   .avm_arg_A_byteenable(),

   // x (1d array)

   .avm_arg_x_read(),
   .avm_arg_x_write(),
   .avm_arg_x_address(),
   .avm_arg_x_readdata(),
   .avm_arg_x_writedata(),
   .avm_arg_x_waitrequest(),
   .avm_arg_x_byteenable(),

   // y (1d array)

   .avm_arg_y_read(),
   .avm_arg_y_write(),
   .avm_arg_y_address(),
   .avm_arg_y_readdata(),
   .avm_arg_y_writedata(),
   .avm_arg_y_waitrequest(),
   .avm_arg_y_byteenable()


   // temp (1d array)
   // not needed
   );

endmodule
