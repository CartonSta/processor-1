module extend(imme,exImme);
	input[16:0] imme;
	output [31:0] exImme;
	
	assign exImme[16:0] = imme[16:0];
	assign exImme[31:17] = {15{imme[16]}};
	
endmodule