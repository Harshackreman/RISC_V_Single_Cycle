`timescale 1ns / 1ps
module register_file(
    input [4:0] rs1,//5 bit address of the register we want to read
    input [4:0] rs2,
    input [4:0] rd,//this is the adress(5 bit) of register in which next input has to be sotred
    input  clk,
    input regwire ,//control input of the register 
    input [31:0] writedata,
    output [31:0] read_data1,
    output [31:0] read_data2
    );

//first register is reserved and no one can overwrite that data.
    reg [31:0] x [31:0];
    assign read_data1=(rs1==5'b0)?32'b0:x[rs1];
    assign read_data2=(rs2==5'b0)?32'b0:x[rs2];
                       
    always @(posedge clk) begin
     //only acitve when clk is positive
     if(regwire==1'b1 && rd!=5'b0) begin 
       //only when regwire active 
        x[rd]<=writedata;
        end
        
        end
       
    
endmodule
