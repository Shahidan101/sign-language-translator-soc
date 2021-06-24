// Code your design here

module counter(
  input CLK,
  input RST,
  output reg [5:0] count
);
  
  always @ (posedge CLK)
    begin
      if (RST == 1)
        begin
          // RST High sets counter to 0
          count <= 0;
        end
      else
        begin
          count <= count + 1;
        end
    end
  
endmodule