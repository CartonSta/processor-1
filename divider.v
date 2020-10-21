module divider(clk,rst,dmem_clk,reg_clk,pro_clk);

	input clk;
	input rst;
	output reg dmem_clk;
	output reg reg_clk;
	output reg pro_clk;

	reg[1:0] cnt;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			cnt <= 2'b0;
			reg_clk <= 1'b0;
			pro_clk <= 1'b0;
			dmem_clk <= 1'b0;
		end
		else begin
			dmem_clk <= ~dmem_clk;
			if (cnt == 1) begin
				reg_clk <= ~reg_clk;
				pro_clk <= ~pro_clk;
				cnt <= 2'b0;
			end
			else begin 
				cnt <= cnt + 2'b1;
			end
		end
	end
endmodule