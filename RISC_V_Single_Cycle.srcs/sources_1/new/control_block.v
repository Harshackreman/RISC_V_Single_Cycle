`timescale 1ns / 1ps

module control_unit(
    input [6:0] opcode,      // Bits [6:0] of the instruction
    input [2:0] funct3,      // Bits [14:12] of the instruction
    input [6:0] funct7,      // Bits [31:25] of the instruction
    output reg regwire,      // 1 if we are writing to a register, 0 if not
    output reg [2:0] alu_control, // Tells the ALU what math to do
    output  reg alusrc, // 0: ALU uses readData2 | 1: ALU uses Immediate Generator
    output reg memtoreg,     // 0: Register gets ALU answer | 1: Register gets Data Memory answer
    output reg memwrite,     // 1: Write data into Data Memory (RAM)
    output reg memread,      // 1: Read data from Data Memory (RAM)
    output reg branch        // 1: This is a branch instruction (like BEQ)
    
);

   //this is a combinational unit and any changes in the input or anything would result in the activation so we would  use always @(*).
   always @(*) begin
     regwire=1'b0;
     alu_control=3'b000; //these are the two default values given the to the alu_control and regwire so that verilog doesnot creates memory latches
     memtoreg = 1'b0;
     memwrite = 1'b0;
     memread = 1'b0;
     branch = 1'b0;
     alu_control = 3'b000;
     
     
//look up table,
     case(opcode)
       7'b0110011: begin // This is the standard RISC-V opcode for R-Type (Math) instructions
       regwire=1'b1;//if rewire is logic 1 we write else we dont write;
       alusrc=1'b0;
       if(funct3==7'b0000000 && funct7==7'b0000000) 
          alu_control=3'b000;//lets say its for add operation;     
      else if (funct3 == 3'b111) 
                    alu_control = 3'b010; // AND
     else if (funct3 == 3'b110) 
                    alu_control = 3'b011; // OR
                    
       end
       
       // ==========================================
        // I-TYPE (Immediate Math: ADDI, ANDI, ORI)
       // ==========================================
       
       7'b0010011: begin
                regwire = 1'b1; // We want to save the answer
                alusrc = 1'b1;  // MUX Switch! Use the Immediate Generator instead of Register 2
                
                if (funct3 == 3'b000) 
                    alu_control = 3'b000; // ADDI (Add Immediate)
                else if (funct3 == 3'b111) 
                    alu_control = 3'b010; // ANDI
                else if (funct3 == 3'b110) 
                    alu_control = 3'b011; // ORI
            end

            // ==========================================
            // LOAD (Read from RAM: LW)
            // ==========================================
            7'b0000011: begin
                regwire = 1'b1;   // Save the loaded data to a register
                alusrc = 1'b1;    // ALU uses Immediate to calculate memory address
                memread = 1'b1;   // Turn ON Data Memory read mode
                memtoreg = 1'b1;  // MUX Switch! Route RAM data to the register, not ALU data
                alu_control = 3'b000; // ALU just adds the base address + offset
            end

            // ==========================================
            // STORE (Write to RAM: SW)
            // ==========================================
            7'b0100011: begin
                regwire = 1'b0;   // Do NOT save to register
                alusrc = 1'b1;    // ALU uses Immediate to calculate memory address
                memwrite = 1'b1;  // Turn ON Data Memory write mode
                alu_control = 3'b000; // ALU adds base address + offset
            end

            // ==========================================
            // BRANCH (If Equal: BEQ)
            // ==========================================
            7'b1100011: begin
                regwire = 1'b0;   // Do NOT save to register
                alusrc = 1'b0;    // ALU uses Register 2 to compare
                branch = 1'b1;    // Tell the PC it might need to jump!
                alu_control = 3'b001; // Tell ALU to SUBTRACT. (If Reg1 - Reg2 == 0, they are equal!)
            end
            
            
            //we are gonna add more conditions and operations here like or and &&;
         default: begin
           ;
          end
     
       endcase
     
     
    end
 

endmodule