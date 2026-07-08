`timescale 1ns / 1ps

module datapath(
    input clk,
    input rst,
    // FIXED: Removed regwire and alu_control from here. They are internal now!
    output [31:0] alu_result_out
    );
    
    wire [31:0] current_pc;
    wire [31:0] pc_next;
    wire [31:0] instruction;
    wire [31:0] readData1;
    wire [31:0] readData2;
    wire [31:0] alu_result;
    
    //  Control Unit Wires
    wire regwire;            // FIXED: Uncommented! 
    wire [2:0] alu_control;  // FIXED: Uncommented!
    wire alusrc;
    wire memtoreg;
    wire memwrite;
    wire memread;
    wire branch;
    
    // --- NEW: Branching Wires ---
    wire zero_flag;
    wire [31:0] branch_target;
    wire pc_src;
    
    // Immediate Generator & MUX Wires 
    wire [31:0] imm_out;
    wire [31:0] alu_b_input;
    
    // Data Memory & Final MUX Wires 
    wire [31:0] mem_readdata;
    wire [31:0] reg_write_data; 
    
    // UPDATED: Program Counter Routing (The Branch MUX)
    wire [31:0] pc_plus_4;
    assign pc_plus_4 = current_pc + 32'd4;
    assign branch_target = current_pc + imm_out;
    
    // The AND Gate: Jump ONLY if it's a branch instruction AND the registers are equal!
    assign pc_src = branch & zero_flag;
    
    // The PC MUX: If pc_src is 1, jump! Otherwise, just go to the next line (PC + 4).
    assign pc_next = (pc_src == 1'b1) ? branch_target : pc_plus_4;  
    
    // 1. Program Counter
    pc_counter main_pc_counter(
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(current_pc)
    );
    
    // 2. Instruction Memory
    instruction_memory main_instruction_memory(
        .pc_address(current_pc),
        .instruction(instruction)
    );
    
    // 3. THE BRAIN: Control Unit
    control_unit main_control(
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .regwire(regwire),            
        .alu_control(alu_control),    
        .alusrc(alusrc),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .memread(memread),
        .branch(branch)
    );
    
    // 4. Register File
    register_file main_register_file(
        .clk(clk),
        .regwire(regwire),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .writedata(reg_write_data),  // FIXED: Plugs into the Final MUX!
        .read_data1(readData1),
        .read_data2(readData2)
    );
                                         
    // 5. Immediate Generator 
    imm_gen main_imm_gen(
        .instruction(instruction), 
        .imm_out(imm_out)          
    );
    
    // 6.  The ALU Multiplexer (Railroad Switch) ---
    assign alu_b_input = (alusrc == 1'b1) ? imm_out : readData2;
    
    // 7. ALU Block
    alu_block main_alu_block(
        .a(readData1),
        .b(alu_b_input),             
        .alucontrol(alu_control),
        .result(alu_result),
        .zero(zero_flag)             // UPDATED: Now catching the zero signal!
    );
   
    // 8. Data Memory (RAM)
    data_memory main_data_memory(
        .clk(clk),
        .memwrite(memwrite),
        .memread(memread),
        .address(alu_result),     
        .writedata(readData2),    
        .readdata(mem_readdata)   
    );
   
    // 9. The Final Multiplexer (Write-Back Switch)
    assign reg_write_data = (memtoreg == 1'b1) ? mem_readdata : alu_result;
   
    assign alu_result_out = alu_result;
   
endmodule