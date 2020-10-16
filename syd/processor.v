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
	 wire Rwe,Rs2,ALUinB,DMwe,Rwd;
	 wire[4:0] ALUop,shiftamt;
	 
	 //control signals
	 controlSignals myControl(q_imem,Rwe,Rs2,ALUinB,DMwe,Rwd,ALUop,shiftamt);
	 
	 //assign s1 and s2
	 assign ctrl_readRegA=q_imem[21:17];
	 assign ctrl_readRegB=Rs2?q_imem[26:22]:q_imem[16:12];
	 
	 //
	 wire [31:0] data_operandB, extendImd;
	 //do sign extend for [16:0], not finished yet!!!
	 assign data_operandB=ALUinB?extendImd:data_readRegB;
	 
	 //alu part
	 wire [31:0] data_result;
	 wire isNotEqual,isLessThan,overflow;
	 alu myAlu(data_readRegA, data_operandB, ALUop, shiftamt, data_result, isNotEqual, isLessThan, overflow);
	 
	 //change rd to 30 if overflow
	 assign ctrl_writeReg=overflow?5'b11110:q_imem[26:22];
	 
	 //assign data_writeReg
	 wire [31:0] data_wrietReg;
	 assign data_writeReg=Rwd?q_dmem:data_result;
	 
	 //regfile part
	 //不懂这里data_readRegA B要怎么处理
	 //regClock not implement!!!
	 regfile myReg(regClock, Rwe, reset, ctrl_writeReg,ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB);
	
	//dmem 没写
	//PC 没写
	//clock 没写

endmodule