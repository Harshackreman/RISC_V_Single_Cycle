`timescale 1ns / 1ps

module datapath(
    input clk,
    
    // Control and Instruction signals (for now, inputs to our top module)
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input regwire,
    input [2:0] alucontrol,
    
    // Outputs to observe what is happening in a testbench
    output [31:0] final_result,
    output zero_flag
);

    // ==========================================
    // 1. Declare Internal Wires (The Cables)
    // ==========================================
    wire [31:0] wire_readData1;
    wire [31:0] wire_readData2;
    wire [31:0] wire_alu_result;  // THE MAGIC WIRE

    // ==========================================
    // 2. Instantiate the Register File
    // ==========================================
    register_file uut (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .regwire(regwire),
        
        // Output ports driving internal wires
        .read_Data1(wire_readData1), 
        .read_Data2(wire_readData2), 
        
        // Input port receiving data from the ALU wire
        .writedata(wire_alu_result) 
    );

    // ==========================================
    // 3. Instantiate the ALU
    // ==========================================
    ALU_BLOCK dut (
        .alucontrol(alucontrol),
        
        // Input ports receiving data from the RegFile wires
        .a(wire_readData1), 
        .b(wire_readData2), 
        
        // Output port driving the result onto the wire
        .result(wire_alu_result), 
        .zero(zero_flag)
    );

    // ==========================================
    // 4. Output Assignments (For testing/visibility)
    // ==========================================
    assign final_result = wire_alu_result;

endmodule