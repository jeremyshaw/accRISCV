module accRISCV(	// RV32I
    input clock, reset,
    output [31:0] inst,
    output reg [31:0] acc,
    output reg [31:0] x,
    output reg sr
    );
    
    reg [5:0] pp; //program pointer, points to next instruction
    reg [6:0] opcode;
    reg [31:7] operand; //may need to split this up into the RISCV subformat
    reg [31:0] result;
    assign inst = {operand, opcode};
    wire [4:0] imAddress  = pp[5:1];
    wire [4:0] dmAddress = operand[31:27];
    
    (*ramstyle = "M512" *) reg [31:0] IM[0:15]; //instruction memory setup as 16 x 32
    (*ramstyle = "M512" *) reg [31:0] DM[0:15]; //data memory
    
    parameter
        NOP = 0,				// not RISCV, No Op (bubble)
        LB = 1,				// Load Halfword
        LH = 2,				// Load Word
        LW = 3,				// Load Byte Unsigned
        LBU = 4,				// Load Half Unsigned
        SB = 5,				// Store Byte
        SH = 6,				// Store Halfword
		  SW = 7,				// Store Word
		  SLL = 8,				// Shift Left
		  SLLI = 9,				// Shift Left Immediate
		  SRL = 10,				// Shift Right
		  SRLI = 11,			// Shift Right Immediate
		  SRA = 12,				// Shift Right Arithmetic
		  SRAI = 13,			// Shift Right Arith Immediate
		  ADD = 14,				// Add
		  ADDI = 15,			// Add Immediate
		  SUB = 16,				// Subtract
		  LUI = 17,				// Load Upper Immediate
		  AUIPC = 18,			// Add Upper Immediate to PC
		  XOR = 19,				// XOR
		  XORI = 20,			// XOR Immediate
		  OR = 21,				// OR
		  ORI = 22,				// OR Immediate
		  AND = 23,				// AND
		  ANDI = 24,			// AND Immediate
		  SLT = 25,				// Set <
		  SLTI = 26,			// Set < Immediate
		  SLTU = 27,			// Set < Unsigned
		  SLTIU = 28,			// Set < Immedate Unsigned
		  BEQ = 29,				// Branch =
		  BNE = 30,				// Branch !=
		  BLT = 31,				// Branch <
		  BGE = 32,				// Branch >=
		  BLTU = 33,			// Branch < Unsigned
		  BGEU = 34,			// Branch >= Unsigned
		  JAL = 35,				// Jump and Link
		  JALR = 36,			// Jump and Link Register
		  FENCE = 37,			// Synchronize thread
		  FENCE_I = 38,		// Synchronize Instruction and Data; CHANGED from FENCE.I
		  SCALL = 39,			// System Call
		  SBREAK = 40,			// System Break - how similar is this to NOP?
		  RDCYCLE = 41,		// Read Cycle
		  RDCYCLEH = 42,		// Read Cycle Upper Half
		  RDTIME = 43,			// Read time
		  RDTIMEH = 44,		// Read time upper half
		  RDINSTRET = 45,		// Read Instr Retired
		  RDINSTRETH = 46;	// Rear Instr Upper Half
    
    //initialize IM with machine instructions
    initial
    begin
        IM[0] = 32'h0000; // NOP
        IM[1] = 32'h0000; // NOP
    end
    
    //read instruction memory
    always@(*)
    begin
        opcode <= IM[imAddress][6:0];
        operand <= IM[imAddress][31:7];
    end
    
    //decode and execute
    always@(*)
    begin
        case(opcode)
            NOP: result = 32'hx;
            LB: result = DM[dmAddress];
            SB: result = acc;
            ADD: result = acc + DM[dmAddress];
            XOR: result = acc ^ DM[dmAddress];
            JAL: result = 32'hx;
            default: result = 32'hx;
        endcase
    end
        
    //fetch and writeback
    always@(posedge clock or posedge reset)
    begin
    if(reset == 1)
        begin
            pp <= 0;
            acc <= 0;
            x <= 0;
            sr <= 0;
        end
    else
        case(opcode)
            NOP: pp = pp + 2; //incrementing in bytes, not words
            LB: begin acc <= result; pp <= pp + 2; end
            SB: begin DM[dmAddress] <= result; pp <= pp + 2; end
            ADD: begin acc <= result; pp <= pp + 2; end
            XOR: begin acc <= result; pp <= pp + 2; end
            JAL: begin pp <= operand[31:7]; end		// not correct, need UJ Instruction Format decode            
        endcase
    end
    
endmodule
