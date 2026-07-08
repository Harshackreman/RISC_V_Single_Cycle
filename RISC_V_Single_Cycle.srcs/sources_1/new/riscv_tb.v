`timescale 1ns / 1ps

module datapath_tb();

    // 1. Declare Testbench Signals
    reg clk;
    reg rst;
    wire [31:0] alu_result_out;

    // Instantiating the datapath and then running test values on it ; 
    datapath my_cpu (
        .clk(clk),
        .rst(rst),
        .alu_result_out(alu_result_out)
    );

    // here we are creating the clock that will basically regulate the entire circuit;
    // the time period of this clock is 
    always #5 clk = ~clk;

    // 4. The Test Sequence
    initial begin
        // POWER ON: Hold the reset button down to clear out any random garbage data
        clk = 0;
        rst = 1;

        // Wait 10ns, then let go of the reset button. 
        // The CPU will now run 100% autonomously, fetching instructions from memory!
        #10 rst = 0;

        // Letting the simulation run for 200ns to give the CPU time to execute the code
        #200;
        
        // Stop the simulation
        $finish; 
    end

    // Optional: Monitor the output to print it to the console
    initial begin
        $monitor("Time=%0t | Reset=%b | ALU Output (Dec)=%0d", $time, rst, alu_result_out);
    end

endmodule