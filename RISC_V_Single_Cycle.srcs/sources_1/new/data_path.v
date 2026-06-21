`timescale 1ns / 1ps

module datapath(
    input clk,
    input rst,
    input regwire,
    input [2:0] alu_control,
    output [31:0] alu_result_out
    );
    wire [31:0] current_pc;
    wire [31:0] next_pc;
    wire [31:0] instruction;
    wire [31:0] readData1;
    wire [31:0] readData2;
    wire [31:0] alu_result;
    
    assign next_pc=current_pc+32'd4;  // this basically means next_pc=pc+4
    //integration of the pc counter in the main CPU circuit,
    
    pc_counter main_pc_counter(.clk(clk),
                               .rst(rst),
                               .pc_next(pc_next),
                                .pc(current_pc));
    
    //integration of the main_instruction_memory.
    instruction_memory main_instruction_memory(.pc_address(current_pc),.instruction(instruction));
    
    //here we have to now plug in the register the file into the main circuit now we do it .
    
    register_file main_register_file(
                                      .clk(clk),
                                     .regwire(regwire),
                                     .rs1(instruction[19:15]),
                                     .rs2(instruction[24:20]),
                                     .rd(instruction[11:7]),
                                     .writedata(alu_result),
                                     .readData1(readData1),
                                     .readData2(readData2)
                                     );
  //now this phase we integrate the alu_block.
   alu_block main_alu_block(.a(readData1),.b(readData2),.alucontrol(alu_control),.result(alu_result),.zero());
   
   assign alu_result_out=alu_result;
   
    

   
endmodule