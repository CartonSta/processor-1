module pc(clk,rst,addr);

input clk;
input rst;
output reg[11:0] addr;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		addr <= 12'b0;
	end
	else begin
		addr <= addr + 12'b1;
	end
end
endmodule