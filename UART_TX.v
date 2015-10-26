module UART_TX(clk,clk_div,rst,data,wr,ce,dbf,tdf,Txd);
input clk,rst,wr,ce;
inout data;
output 	dbf,//data buffer full
		tdf;//transmit data flag

output clk_div;
output Txd;


wire clk_div;
reg Txd;
reg [7:0] data;
reg [7:0] data_buf;
reg [9:0] shift_reg;
reg error,dbf,tdf;
reg [3:0] t;
reg [1:0] state;

parameter idle=2'b00,ready=2'b01,transmit=2'b11;

divider U1(.En(1),.Rst(rst),.Clk_in(clk),.Clk_out(clk_div));//12 frequency division

//assign Txd=(state == transmit)?shift_reg[0]:1'b1;

//state control
always@(posedge clk_div)
begin
if(!rst)
	state <= idle;
else
case(state)
idle:
	begin 
		if(ce == 1 && wr == 1)
		begin 
			state<=ready;
			data_buf<=data;
		end
		else if(tdf == 1)
			state<=transmit;
		else
			state <= idle;		
	end
ready:
	begin 
		if(ce == 0 || wr ==0)
		begin
			state <= idle;
			tdf <= 1;
		end
		else
			state <= ready;
	end
transmit:
	begin
		if(t == 9)
		begin
			state<=idle;
			tdf <= 0;
			t<=0;
		end
		else
			t<=t+1;
	end
	
endcase
end


//load buffer and transmit
always@(posedge clk)
case(state)
idle:
begin
	if(tdf==0)
		dbf<=0;
end
ready:
begin
	shift_reg <= {1'b1,data_buf[7:0],1'b0};
	dbf<=1;
end

transmit:
begin
	shift_reg <= shift_reg>>1;
	Txd<=shift_reg[0];
end
default:;
endcase
endmodule 