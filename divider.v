module divider(Rst,Clk_in,Clk_out);
input Rst,Clk_in;
output reg Clk_out;

reg[4:0] Q;
parameter N=6;

always @(posedge Clk_in)
begin
	if(~Rst)
		begin Q<=5'b00000; Clk_out<=0;end
	
	else 
		begin
			if(Q==(N-1))
			begin
				Clk_out<=~Clk_out;
				Q<=0;
			end
			else
				Q<=Q+1;
		end
end
endmodule 