`timescale 1ns / 1ps
module data_memory(
    input clk,
    input memwrite,//from control unit if 1 then writing/saving data
    input memread,// from control unit if 1 reading  the data 
    input [31:0] address,//address from the alu of the data
    input [31:0] writedata,//exact data that has to be executed
    output reg [31:0] readdata//final read data that is to be forwarded as an output.
    );
     // Create a block of memory: 1024 slots, each exactly 32 bits wide
    reg [31:0] memory [0:1023];
    
  //next block ensures that the cpu is initially filled entirely with 0's
  integer i ;
  initial begin
     for(i=0;i<1024;i=i+1)
       memory[i]=32'b0;
    end
  //reading is always done when change in clock occurs ;
  always @(posedge clk)
    begin
      if(memwrite) begin
         memory[address[31:2]]<=writedata;//we are shifting the bits to right as the words stored are in bytes i.e. 8 bits so we have to divide it by 4 to make it work
        end
    end  
   
   //reading the data happens instantly
   always @(*) 
     begin
        if(memread)
         begin
           readdata=memory[address[31:2]];
         end
        else 
          begin
            readdata=32'b0;
          end 
     end 
  
    
endmodule
