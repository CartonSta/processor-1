module controlSignals(q_imem,Rwe,Rs2,ALUinB,DMwe,Rwd,ALUop,shiftamt);

input [31:0] q_imem;
output Rwe,Rs2,ALUinB,DMwe,Rwd;
output [4:0] ALUop,shiftamt;

	if(q_imem[31:27]==5'b00000) begin
		//Rtype
		assign Rwe=1'b1;
		assign Rs2=1'b0;
		assign ALUinB=1'b0;
		assign DMwe=1'b0;
		assign Rwd=1'b0;
		assign ALUop=q_imem[6:2];
		assign shiftamt=q_imem[11:7];
	 end
	 
	 if(q_imem[31:27]==5'b00101) begin
	 //addi
		assign Rwe=1'b1;
		assign Rs2=1'b0;  //question? : how to indicate X
		assign ALUinB=1'b1;
		assign DMwe=1'b0;
		assign Rwd=1'b0;
		assign ALUop=5'b00000;
		assign shiftamt=5'b00000;
	 end
	 
	 if(q_imem[31:27]==5'b00111) begin
	 //sw
		assign Rwe=1'b0;
		assign Rs2=1'b1;  //question? : how to indicate X
		assign ALUinB=1'b1;
		assign DMwe=1'b1;
		assign Rwd=1'b0;
		assign ALUop=5'b00000;
		assign shiftamt=5'b00000;
	 end
	 
	 if(q_imem[31:27]==5'b01000) begin
	 //lw
		assign Rwe=1'b1;
		assign Rs2=1'b0;  //question? : how to indicate X
		assign ALUinB=1'b1;
		assign DMwe=1'b0;
		assign Rwd=1'b1;
		assign ALUop=5'b00000;
		assign shiftamt=5'b00000;
	 end
	 
endmodule
