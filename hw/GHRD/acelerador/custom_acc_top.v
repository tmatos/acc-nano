
module custom_acc_top(
   input clk,
   input rst_n,
	
	input [7:0] controle
	);

	reg estado;
	
	always@(posedge clk) begin
		if(~rst_n) begin  // reset
			estado <= 0;
		end
		else begin
			estado <= controle[0];
		end
	end

endmodule
