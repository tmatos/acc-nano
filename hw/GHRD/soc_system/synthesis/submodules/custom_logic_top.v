
module custom_logic_top(

   input clk,
   input reset,

   output cso_avmclk_clk,
   output rso_avmrst_reset,

   output reg avm_read,
   output reg avm_write,

   output reg [9:0] avm_address,

   input [31:0] avm_readdata,
   output reg [31:0] avm_writedata,

   input avm_waitrequest,
   output [3:0] avm_byteenable,

   input coe_start_export,
   output reg coe_finish_export

   );

// para a interface avalon
assign cso_avmclk_clk = clk;
assign rso_avmrst_reset = reset;
assign avm_byteenable = 4'b1111;

// offsets para as posicoes dos dados de
// entrada e saida na memoria interna
parameter OFFSET_ENTRADA = 0,
          OFFSET_SAIDA = 512;

// Estados da FSM (codificados em one-hot)
parameter ESPERANDO  = 4'b0001,
          CARREGANDO = 4'b0010,
          CALCULANDO = 4'b0100,
          PRONTO     = 4'b1000;

// NUMERO DE AMOSTRAS (int32) DO BLOCO DE DADOS
parameter SIZE = 16'd128;

reg [3:0] estado;
reg [15:0] posicao;

reg cmd_executar;

reg enable_calcular;
reg reset_filtro;

//reg [31:0] mem [0:2047];
reg [31:0] mem [0:127];

reg [31:0] filtro_in;

// controlador baseado em FSM
always@(posedge clk) begin

   cmd_executar <= coe_start_export;

   if(reset) begin  // reset
      estado <= ESPERANDO;
      filtro_in <= 32'd0;
      enable_calcular <= 0;
   end
   else begin
      case(estado)
         ESPERANDO:
            begin 
               if(cmd_executar) begin
                  estado <= CARREGANDO;
                  avm_write <= 0;
                  avm_read <= 1;
                  avm_address <= OFFSET_ENTRADA;
                  posicao <= 0;
                  coe_finish_export <= 0;
                  reset_filtro <= 1;
               end
               else begin
                  estado <= ESPERANDO;
                  avm_write <= 0;
                  avm_read <= 0;
                  enable_calcular <= 0;
                  reset_filtro <= 0;
               end
            end

         CARREGANDO:
            begin
               reset_filtro <= 0;

               if( ~avm_waitrequest ) begin

                  mem[posicao] <= avm_readdata;

                  if( posicao == (SIZE-1) ) begin
                     estado <= CALCULANDO;
                     posicao <= 0;
                     enable_calcular <= 1;
                     filtro_in <= mem[0]; // necessario, filtro tem atraso de 1 pulso
                     avm_write <= 0;
                     avm_read <= 0;
                     avm_address <= 0;
                     avm_writedata <= 0;
                  end
                  else begin
                     estado <= CARREGANDO;
                     avm_write <= 0;
                     avm_read <= 1;
                     avm_address <= (OFFSET_ENTRADA + posicao*4 + 4);
                     posicao <= posicao+1;
                  end
                  
               end
            end

         CALCULANDO:
            begin
               if( ~avm_waitrequest ) begin

                  if( posicao == (SIZE-1) ) begin
                     estado <= PRONTO;
                     avm_write <= 1;
                     avm_read <= 0;
                     avm_address <= (OFFSET_SAIDA + posicao*4);
                     avm_writedata <= filtro_out;
                     posicao <= posicao+1;
                     enable_calcular <= 0;
                     filtro_in <= 0;
                  end
                  else begin
                     estado <= CALCULANDO;
                     avm_write <= 1;
                     avm_read <= 0;
                     avm_address <= (OFFSET_SAIDA + posicao*4);
                     avm_writedata <= filtro_out; // ja ha valor no 1o pulso do estado
                     posicao <= posicao+1;
                     enable_calcular <= 1;
                     filtro_in <= mem[posicao+1];
                  end

               end
            end

         PRONTO:
            begin
               if( ~avm_waitrequest ) begin

                  coe_finish_export <= 1; // indica conclusao ao processo

                  avm_write <= 0;
                  avm_read <= 0;
                  avm_address <= 0;
                  avm_writedata <= 0;
                  posicao <= 0;
                  enable_calcular <= 0;
                  filtro_in <= 0;

                  if(~cmd_executar) begin
                     estado <= ESPERANDO;
                  end
                  else begin
                     estado <= PRONTO;
                  end

               end
            end

         default:
            estado <= ESPERANDO;
      endcase
   end
end

wire [31:0] filtro_out;

filtro f0 ( .clk(clk),
            .reset( reset_filtro ),
            .enable(enable_calcular),
            .entrada( filtro_in ),
            .saida( filtro_out )
          );

endmodule



/////////////////////////////////////////////////
// A PARTIR DAQUI
// Modulos separados que eu fiz
/////////////////////////////////////////////////


// filtro fir
// com coefs fixos
module filtro(
   input clk,
   input reset,
   input enable,
   input signed [31:0] entrada,
   output reg signed [31:0] saida
   );

   // numero de coeficientes do filtro
   parameter N = 13;

   // coeficientes do filtro (literal de 32 bits em decimal eh padrao no verilog)
   parameter signed [31:0]
      C0  = -24738871,
      C1  = -112681234,
      C2  = -170991139,
      C3  = -74200673,
      C4  = 241328526,
      C5  = 620061218,
      C6  = 792031499,
      C7  = 620061218,
      C8  = 241328526,
      C9  = -74200673,
      C10 = -170991139,
      C11 = -112681234,
      C12 = -24738871;
   
   reg signed [31:0] buff [0:N-1];
   
   wire signed [63:0] p0, p1, p2, p3, p4, p5;
   wire signed [63:0] p0p1, p2p3, p4p5;
   wire signed [63:0] soma;
   
   assign p0 = buff[0]*C0 + buff[1]*C1;
   assign p1 = buff[2]*C2 + buff[3]*C3;
   assign p2 = buff[4]*C4 + buff[5]*C5;
   assign p3 = buff[6]*C6 + buff[7]*C7;
   assign p4 = buff[8]*C8 + buff[9]*C9;
   assign p5 = buff[10]*C10 + buff[11]*C11 + buff[12]*C12;
   
   assign p0p1 = p0 + p1;
   assign p2p3 = p2 + p3;
   assign p4p5 = p4 + p5;
   
   assign soma = p0p1 + p2p3 + p4p5 + 64'sh0000_0000_8000_0000;

   integer i, k;
   
   // por a entrada no buffer
   // e atualizar a saida
   always @(posedge clk or posedge reset) begin
      if (reset) begin

         for ( i=0 ; i<N ; i=i+1 ) begin
            buff[i] <= 32'd0;
         end
         
         saida <= 32'd0;
      end
      else if (enable) begin

         for ( k=1 ; k<N ; k=k+1 ) begin
            buff[k-1] <= buff[k];
         end
         
         buff[N-1] <= entrada;
         
         saida = soma[63:32];
      end
      
   end

endmodule
