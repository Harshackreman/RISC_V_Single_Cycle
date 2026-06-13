`timescale 1ns / 1ps

module tb_ALU_BLOCK();

    // 1. Declare inputs as 'reg' so we can assign them in an initial block
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] alucontrol;

    // 2. Declare outputs as 'wire' to connect to the module
    wire [31:0] result;
    wire zero;

    // 3. Instantiate the Device Under Test (DUT)
    ALU_BLOCK uut (
        .a(a),
        .b(b),
        .alucontrol(alucontrol),
        .result(result),
        .zero(zero)
    );

    // 4. Apply Stimulus (Test Cases)
    initial begin
        // Set initial values
        a = 32'd10;  // Decimal 10
        b = 32'd5;   // Decimal 5
        
        $display("Starting ALU Tests...");
        $display("--------------------------------------------------");

        // Test Case 1: Addition (alucontrol[1:0] = 00)
        alucontrol = 3'b000;
        #10; // Wait 10 nanoseconds for logic to settle
        $display("ADD:  %d + %d = %d | Zero Flag: %b", a, b, result, zero);

        // Test Case 2: Subtraction (alucontrol[1:0] = 01)
        // alucontrol[0] is 1, so it does a + ~b + 1 (which is a - b)
        alucontrol = 3'b001; 
        #10;
        $display("SUB:  %d - %d = %d  | Zero Flag: %b", a, b, result, zero);

        // Test Case 3: AND (alucontrol[1:0] = 10)
        alucontrol = 3'b010;
        #10;
        $display("AND:  %b & %b = %b | Zero Flag: %b", a[3:0], b[3:0], result[3:0], zero);

        // Test Case 4: OR (alucontrol[1:0] = 11)
        alucontrol = 3'b011;
        #10;
        $display("OR:   %b | %b = %b | Zero Flag: %b", a[3:0], b[3:0], result[3:0], zero);

        // Test Case 5: Testing the Zero Flag
        a = 32'd15;
        b = 32'd15;
        alucontrol = 3'b001; // Subtraction (15 - 15)
        #10;
        $display("ZERO: %d - %d = %d  | Zero Flag: %b", a, b, result, zero);

        $display("--------------------------------------------------");
        $display("Testing Complete.");
        
        $finish; // End the simulation
    end

endmodule