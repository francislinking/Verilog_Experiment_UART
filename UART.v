module UART(clk,clk_tx,clk_rx,rst,data,wr,rd,ce,error,dbf,rdc,tdf,rdf,Txd,Rxd);
input clk,rst,wr,rd,ce;
input Rxd;

inout data;

output Txd;
output clk_tx,clk_rx;

output 	error,
		dbf,//data buffer full
		rdc,//receive data complete
		tdf,//transmit data flag
		rdf;//read data flag

wire clk_tx,clk_rx;
wire Txd;
wire [7:0] data;
wire error,rdf,rdc,dbf,tdf;


UART_TX U2(clk,clk_tx,rst,data,wr,ce,dbf,tdf,Txd);

UART_RX U3(clk,clk_rx,rst,data,rd,ce,error,rdc,rdf,Rxd);

endmodule
