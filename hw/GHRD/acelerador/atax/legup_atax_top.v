
module legup_atax_top

#(parameter
   BUS_SIZE = 64,
   BUS_BYTES = 8
)

(
   input clk,
   input reset,

   input coe_start_export,
   output coe_finish_export,

   //output cso_avmclk_clk,
   //output rso_avmrst_reset,


   // A (2d array)

   output avm_arg_A_read,
   output avm_arg_A_write,
   output [12:0] avm_arg_A_address, // 13 bits wide (8 kB)
   input [BUS_SIZE-1:0] avm_arg_A_readdata,
   output [BUS_SIZE-1:0] avm_arg_A_writedata,
   input avm_arg_A_waitrequest,
   output [BUS_BYTES-1:0] avm_arg_A_byteenable,

   // x (1d array)

   output avm_arg_x_read,
   output avm_arg_x_write,
   output [7:0] avm_arg_x_address, // 8 bits wide (256 B)
   input [BUS_SIZE-1:0] avm_arg_x_readdata,
   output [BUS_SIZE-1:0] avm_arg_x_writedata,
   input avm_arg_x_waitrequest,
   output [BUS_BYTES-1:0] avm_arg_x_byteenable,

   // y (1d array)

   output avm_arg_y_read,
   output avm_arg_y_write,
   output [7:0] avm_arg_y_address, // 8 bits wide (256 B)
   input [BUS_SIZE-1:0] avm_arg_y_readdata,
   output [BUS_SIZE-1:0] avm_arg_y_writedata,
   input avm_arg_y_waitrequest,
   output [BUS_BYTES-1:0] avm_arg_y_byteenable

   // temp (1d array)
   // not needed
);

   wire w_finish_capture;
   reg r_finish_capture;

   assign coe_finish_export = r_finish_capture;

   always@(posedge clk, posedge reset)
   begin
   	  if(reset) begin
   	     r_finish_capture <= 0;
   	  end
   	  else begin
         if( coe_start_export ) begin
            r_finish_capture <= 0;
         end
         else begin
            if( w_finish_capture ) begin
   	           r_finish_capture <= 1;
            end
         end
   	  end
   end


   kernel_atax_top kernel_0 (
      .clk(clk),
      .reset(reset),
      .start(coe_start_export),
      .finish(w_finish_capture),

      .main_y_write_enable_a(),
      .main_y_in_a(),
      .main_y_byteena_a(),
      .main_y_enable_a(),
      .main_y_address_a(),
      .main_y_out_a(),
      .main_y_write_enable_b(avm_arg_y_write),
      .main_y_in_b(avm_arg_y_writedata),
      .main_y_byteena_b(avm_arg_y_byteenable),
      .main_y_enable_b(avm_arg_y_read),
      .main_y_address_b(avm_arg_y_address),
      .main_y_out_b(avm_arg_y_readdata),

      .main_x_write_enable_a(),
      .main_x_in_a(),
      .main_x_byteena_a(),
      .main_x_enable_a(),
      .main_x_address_a(),
      .main_x_out_a(),
      .main_x_write_enable_b(avm_arg_x_write),
      .main_x_in_b(avm_arg_x_writedata),
      .main_x_byteena_b(avm_arg_x_byteenable),
      .main_x_enable_b(avm_arg_x_read),
      .main_x_address_b(avm_arg_x_address),
      .main_x_out_b(avm_arg_x_readdata),
      
      .main_A_a0_a0_write_enable_a(),
      .main_A_a0_a0_in_a(),
      .main_A_a0_a0_byteena_a(),
      .main_A_a0_a0_enable_a(),
      .main_A_a0_a0_address_a(),
      .main_A_a0_a0_out_a(),
      .main_A_a0_a0_write_enable_b(avm_arg_A_write),
      .main_A_a0_a0_in_b(avm_arg_A_writedata),
      .main_A_a0_a0_byteena_b(avm_arg_A_byteenable),
      .main_A_a0_a0_enable_b(avm_arg_A_read),
      .main_A_a0_a0_address_b(avm_arg_A_address),
      .main_A_a0_a0_out_b(avm_arg_A_readdata)
   );

endmodule
