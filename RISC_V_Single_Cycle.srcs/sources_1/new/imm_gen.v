/* =========================================================================
  MODULE: Immediate Generator (The "Number Stretcher")
   THE PROBLEM: 
  The RISC-V 32-bit instruction envelope only has 12 bits of space left 
  to hold raw numbers (Immediates). But the ALU requires 32-bit inputs!
  THE SOLUTION: 
  This module extracts the 12-bit number and stretches it to 32 bits using 
  "Sign Extension" (padding the front by copying the 31st sign bit 20 times).
 
  WHY THE WEIRD S-TYPE & B-TYPE CONDITIONS?
  Register addresses (rs1, rs2) MUST stay in fixed physical locations. 
  Therefore, instructions like STORE and BRANCH are forced to chop up and 
  scramble their 12-bit numbers to flow around the registers. 
  We read the Opcode so we know which "treasure map" to use to un-scramble them!
  ========================================================================= */
`timescale 1ns / 1ps
module imm_gen(
    input [31:0] instruction,
    output reg [31:0] imm_out
    );
 wire [6:0] op_code=instruction[6:0];

  //it happens immediately so we don't need clock;
 always @(*) begin
   case(op_code) 
     // we are now gonna write the conditions ;
     7'b0010011, 7'b0000011:begin // certain opcode certain operations are done and immediate number is stored there 
     // The {20{instruction[31]}} trick copies the sign bit 20 times because in 2's compliment form if we copy the sign bits n number of times then also there is no change in the entire number ; 
       imm_out={{20{instruction[31]}},instruction[31:20]};
     end
     
     //storing instructions like SW.
     7'b0100011:begin
       imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
      end
      //B-TYPE Branch Instruction like BEQ in this imm is split around rs1 and rs2 because we need both of them intact as comparison is done .
      7'b1100011: begin
        imm_out={{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            
     end
    default:begin
        imm_out=32'b0;
    end
   endcase
end
 
 endmodule
