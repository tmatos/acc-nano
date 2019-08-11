
module custom_acc_top(
   input clk,
   input reset,
	
	//input [7:0] i_controle,
	//output [7:0] o_controle
	
	input i_start,
	output o_finish
	);

	parameter NUM_CICLOS = 50000000;

	reg r_estado;
	reg [63:0] r_contador;
	
	wire w_start;
	reg r_finish;
	
	assign w_start = i_start;
	assign o_finish = r_finish;
	
	always@(posedge clk)
	begin
		if(reset)
		begin
			r_estado <= 0;
			r_contador <= 0;
			r_finish <= 0;
		end
		else
		begin
			case (r_estado)
				0:
				begin
					if(w_start == 1) begin
						r_estado <= 1;
						r_contador <= (r_contador + 1);
						r_finish <= 0;
					end
					else begin
						r_estado <= 0;
						r_contador <= 0;
					end
				end
				
				1:
				begin
					if(r_contador == NUM_CICLOS) begin
						r_estado <= 0;
						r_contador <= 0;
						r_finish <= 1;
					end
					else begin
						r_estado <= 1;
						r_contador <= (r_contador + 1);
						r_finish <= 0;
					end
				end
				
				//default:
				//begin
				//end
			endcase
		end
		
	end

endmodule
