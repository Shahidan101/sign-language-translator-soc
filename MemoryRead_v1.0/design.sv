// Code your design here

// 6-bit reset counter
module counter(
  input CLK,
  input RST,
  output reg [5:0] count
);
  
  always @ (posedge CLK)
    begin
      if (RST == 1)
        begin
          count <= 0;
        end
      else if (RST == 0)
        begin
          count <= count + 1;
        end
    end
  
endmodule

module memory(
  input CLK,
  input RST,
  input [5:0] ADD,
  output reg CLR,
  output reg [5:0] DATA
);
  
  wire [5:0] countADD;
  
  counter count0(CLK, RST, countADD);
  
  always @(posedge CLK)
    begin
      // CLR is kept at HIGH, so no RST of counter
      CLR <= 1;
      // Default DATA is at 63
      DATA <= 63;
      // When there is a match with counter and ADD
      if (ADD == countADD)
        begin
          // Assuming the DATA at the address is the address value
          DATA <= countADD;
          // Output CLR signal to start RST
          CLR <= 0;
        end
    end
  
endmodule