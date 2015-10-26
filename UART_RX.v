module UART_RX(clk,clk_div,rst,data,rd,ce,error,rdc,rdf,Rxd);
input clk,rst,rd,ce;
inout data;
output 	error,
		rdc,//receive data complete
		rdf;//read data flag	
output clk_div;

input Rxd;

wire [7:0] data;
wire clk_div;
wire clk_en;

reg [7:0] data_buf;
reg error,rdc,rss,rdf;
reg [3:0] t;
reg [2:0] c;
reg [1:0] state ;



parameter idle=2'b00,read=2'b01,finish=2'b11;

divider U1(.En(rdf),.Rst(rst),.Clk_in(clk),.Clk_out(clk_div));//12 frequency division

//start dectection
always@(posedge clk)
begin

	if(Rxd==0 && rdf == 0 && ce == 1 && rd ==1)
		c<=c+1;
	else
		c<=0;
	
	if(c == 6)
	begin
		c<=0;
		rdf<=1;
	end
	
	if(rdc == 1 || error ==1)
		rdf<=0;
end

//state control
always@(posedge clk_div)
begin
	if(!rst)
		state <= idle;
	else
	case(state)
		idle:
		begin
			if(ce == 1 && rd ==1)
			begin
				if(rdf == 1)
				begin
					rss<=1;
					state<=read;
				end
			end
			else
				state <= idle;
		end
		
		read:
		begin
			if(t==7)
			begin
				state <= finish;
				rss<=0;
				t<=0;
			end
			else
				t<=t+1;
		end
		
		finish:
		begin
			state <=idle;
			if(Rxd == 1)
				rdc<=1;
			else
				error<=1;
		end
	endcase
end 

//read data
always@(posedge clk_div)
case(state)
read:
begin
	data_buf=data_buf>>1;
	data_buf[7]=Rxd;
end

default:;
endcase

assign data=(rdc==1)?data_buf:8'hzz;
endmodule 