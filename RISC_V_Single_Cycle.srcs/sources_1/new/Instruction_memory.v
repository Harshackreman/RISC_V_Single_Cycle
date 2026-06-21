`timescale 1ns / 1ps
//this the book and pc counter is the book mark we use to read it .

module instruction_memory(
    input [31:0] pc_address,
    output [31:0] instruction
    );
   reg [31:0] rom_memory [0:255];
   initial begin
   $readmemh("program.mem",rom_memory); //this acts as rom of memory and we have to make rom so its not writable we are here uploading the data from txt file thorugh readmemh command 
   end 
    
    assign instruction = rom_memory[pc_address>>2];
  
endmodule
