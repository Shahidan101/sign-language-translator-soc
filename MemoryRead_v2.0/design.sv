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

  reg DELAY = 0;
  // Introduce 2 stall registers to delay 2 clock cycles
  reg STALLONE = 0;
  reg STALLTWO = 0;
  wire [5:0] countADD;
  
  counter count0(CLK, RST, countADD);
  
  always @(posedge CLK)
    begin
      // When DELAY initiated, initialise second stall
      if (DELAY == 1)
        begin
          STALLTWO <= 1;
        end
      if (STALLTWO == 1)
        begin
          // When STALLTWO reached, reset registers to 0
          DELAY <= 0;
          STALLONE <= 0;
          STALLTWO <= 0;
        end
      CLR <= 1;
      DATA <= 63;
      // Check if there's no stall
      if ((ADD == countADD) && (STALLONE == 0))
        begin
          DATA <= countADD;
          CLR <= 0;
          // Start the Delay sequence
          DELAY <= 1;
          // First stall begins
          STALLONE <= 1;
        end
    end
  
endmodule