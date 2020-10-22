module controlSignals(q_imem,Rwe,Rs2,ALUinB,DMwe,Rwd,ALUop,shiftamt);

input [31:0] q_imem;
output Rwe,Rs2,ALUinB,DMwe,Rwd;
output [4:0] ALUop,shiftamt;

reg inner_Rwe,inner_Rs2,inner_ALUinB,inner_DMwe,inner_Rwd;
reg[4:0] inner_ALUop,inner_shiftamt;

assign Rwe=inner_Rwe;
assign Rs2=inner_Rs2;
assign ALUinB=inner_ALUinB;
assign DMwe=inner_DMwe;
assign Rwd=inner_Rwd;

assign ALUop=inner_ALUop;
assign shiftamt=inner_shiftamt;

always @* begin
	if(q_imem[31:27]==5'b00000) begin //add,sub,and,or,sll,sra
		inner_Rwe=1'b1;
		inner_Rs2=1'b0;
		inner_ALUinB=1'b0;
		inner_DMwe=1'b0;
		inner_Rwd=1'b0;
		inner_ALUop=q_imem[6:2];
		inner_shiftamt=q_imem[11:7];
	 end
	 
	 if(q_imem[31:27]==5'b00101) begin //addi
		inner_Rwe=1'b1;
		inner_Rs2=1'b0;  
		inner_ALUinB=1'b1;
		inner_DMwe=1'b0;
		inner_Rwd=1'b0;
		inner_ALUop=5'b00000;
		inner_shiftamt=5'b00000;
	 end
	 
	 if(q_imem[31:27]==5'b00111) begin //sw
		inner_Rwe=1'b0;
		inner_Rs2=1'b1;  
		inner_ALUinB=1'b1;
		inner_DMwe=1'b1;
		inner_Rwd=1'b0;
		inner_ALUop=5'b00000;
		inner_shiftamt=5'b00000;
	 end
	 
	 if(q_imem[31:27]==5'b01000) begin //lw
		inner_Rwe=1'b1;
		inner_Rs2=1'b0;  
		inner_ALUinB=1'b1;
		inner_DMwe=1'b0;
		inner_Rwd=1'b1;
		inner_ALUop=5'b00000;
		inner_shiftamt=5'b00000;
	 end
end
endmodule
