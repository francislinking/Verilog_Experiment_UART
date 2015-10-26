module UART(clk,clk_div,rst,data,wr,rd,ce,error,dbf,rdc,tdf,rdf,Txd,Rxd);
input clk,rst,wr,rd,ce;
input Rxd;

inout data;

output Txd;
output clk_div;
output 	error,
		dbf,//data buffer full
		rdc,//receive data complete
		tdf,//transmit data flag
		rdf;//read data flag

wire clk_div;
wire Txd;
wire [7:0] data;
wire error,rdf,rdc,dbf,tdf;


UART_TX U2(clk,clk_div,rst,data,wr,ce,dbf,tdf,Txd);

//UART_RX U3(clk,clk_div,rst,data,rd,ce,error,rdc,rdf,Rxd);

endmodule
