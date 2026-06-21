`timescale 1ns / 1ps
module pc_counter(
    input clk,
    input rst,
    input [31:0] pc_next,
    output reg [31:0] pc
    );
    always @(posedge clk)
       begin
         if(rst==1'b0) begin
          pc<=pc_next;
          end
          else begin
            pc<=32'b0;
            end
             
            
        end
   
endmodule
