`timescale 1ns / 1ps
module ALU_BLOCK(
    input [31:0] a,
    input [31:0] b,
    input [2:0] alucontrol,
    output reg  [31:0] result ,
    output zero 
   );
    wire [31:0] a_and_b;
    wire [31:0] a_or_b;
    //assigning the wires to the operations of & and |
    
    assign a_and_b=a&b;
    assign a_or_b=a|b;
    
    //this code segment contains 2:1 Mux which decides what to send to adder block ;
    
    wire [31:0] mux_1 ;
    assign  mux_1=(alucontrol[0]==1'b0)?(b):(~b);
     // here we are deciding wether the mux would throw b or ~b and then we would roceed further ;
     
     //sum block ;
    wire [31:0] sum;
    assign sum=a+mux_1+alucontrol[0];
    //sum block has been completed ;
     
     //bigger mux of order 4x1 is being established ;
      
      
    wire [31:0] mux_2;
    
   assign mux_2 = (alucontrol[1:0] == 2'b00 || alucontrol[1:0] == 2'b01) ? sum :
                   (alucontrol[1:0] == 2'b10) ? a_and_b : a_or_b;
            // 2nd mux has been done 
            
   always @(*) begin 
   result = mux_2;
   end 
    
assign zero = (result == 32'b0) ? 1'b1 : 1'b0;   
endmodule
