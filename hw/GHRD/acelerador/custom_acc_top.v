
module custom_acc_top(
   input clk,
   input reset,
	
	//input [7:0] i_controle,
	//output [7:0] o_controle
	
	input i_start,
	output o_finish
	);

	parameter NUM_CICLOS = 50000000;
	
	// Estados da FSM (codificados em one-hot)
	parameter IDLE = 3'b001,
             WORK = 3'b010,
             ACK  = 3'b100;

	reg [2:0] r_estado;
	reg [63:0] r_contador;
	
	wire w_start;
	reg r_finish;
	
	assign w_start = i_start;
	assign o_finish = r_finish;
	
	always@(posedge clk)
	begin
		if(reset)
		begin
			r_estado <= IDLE;
			r_contador <= 0;
			r_finish <= 0;
		end
		else
		begin
			case (r_estado)
				IDLE:
				begin
					if(w_start == 1) begin
						r_estado <= WORK;
						r_finish <= 0;
					end
					else begin
						r_estado <= IDLE;
						r_contador <= 0;
						r_finish <= 0;
					end
				end
				
				WORK:
				begin
					if(r_contador == NUM_CICLOS) begin
						r_estado <= ACK;
						r_finish <= 1;
					end
					else begin
						r_estado <= WORK;
						r_contador <= (r_contador + 1);
						r_finish <= 0;
					end
				end
				
				ACK:
				begin
					if(w_start == 0) begin
						r_estado <= IDLE;
						r_contador <= 0;
						r_finish <= 0;
					end
					else begin
						r_estado <= ACK;
						r_finish <= 1;
					end
				end
				
				//default:
				//begin
				//end
			endcase
		end
		
	end

endmodule
