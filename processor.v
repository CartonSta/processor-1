/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 
	 //control signals
	  wire Rs2,Rwe,ALUinB,Rwd,DMwe;
     wire[4:0] ALUop,shiftamt;
     wire[31:0] data_operandB,extendImd;
     wire[31:0] data_result;
     wire isNotEqual,isLessThan,overflow;
     
	  
	  reg[31:0] inner_write1,inner_writeData;
	  reg[4:0] inner_RegA,inner_RegB,inner_writeReg;
	  reg inner_rwe,inner_wren;
	  
	  //assign data_operandB, s2 or immd
		assign extendImd[16:0] = q_imem[16:0];
		assign extendImd[31:17] = {15{q_imem[16]}};
		assign data_operandB=ALUinB?extendImd:data_readRegB;

	  
	  //output for regfile
     assign ctrl_readRegA=inner_RegA;
	  assign ctrl_readRegB=inner_RegB;
	  assign ctrl_writeReg=inner_writeReg;
	  assign data_writeReg=inner_writeData;
	  assign ctrl_writeEnable=inner_rwe;
	  
	  //outputs for Dmem
	  reg[11:0] inner_addrD;
	  reg[31:0] inner_data;
	  assign address_dmem=inner_addrD;
	  assign data=inner_data;
	  assign wren=inner_wren;
	  
	  pc myPC(clock,reset,address_imem);
     controlSignals myControl(q_imem,Rwe,Rs2,ALUinB,DMwe,Rwd,ALUop,shiftamt);
     alu myAlu(data_readRegA, data_operandB, ALUop, shiftamt, data_result, isNotEqual, isLessThan, overflow);

	 always @(posedge clock) begin

		 //for Regfile
		 inner_RegA=q_imem[21:17];
		 inner_RegB=Rs2?q_imem[26:22]:q_imem[16:12];
		 inner_writeReg=overflow?5'b11110:q_imem[26:22];
		 inner_write1=Rwd?q_dmem:data_result;
		 inner_writeData=overflow?1'b1:inner_write1;
		 inner_rwe=Rwe;

		 //for Dmem, assign data and address_dmem
		 inner_addrD=data_result[11:0];
		 inner_data=data_readRegB;
		 inner_wren=DMwe;
	 end
endmodule