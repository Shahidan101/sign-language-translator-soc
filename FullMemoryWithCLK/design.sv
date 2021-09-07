// Code your design here
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

module memory(CLK, RST, addr, data_in, RW_, CS, data_out);
  input CLK;
  input RST;
  input [5:0] addr;
  input [14:0] data_in;
  input RW_, CS;	//ReadWrite and Chip Select
  output reg [14:0] data_out;
  
  // Address Space in Chip = 64 pages
  // Data Space in a Cell = 12 bits
  reg [14:0] ram[63:0];
  wire [5:0] countADD;
  
  integer i;
  
  counter count0(CLK, RST, countADD);

  // Initialise memory with zeros
  initial begin
    for (i = 0; i < 64; i = i+ 1) begin
      ram[i[5:0]] <= 0;
    end
  end
  
  always @(posedge CLK) 
    begin
      if (CS == 0) 	// If CS is LOW, return high impedance
        begin
          data_out <= 15'bz;
        end
      else if (CS == 1)
        begin
          if (RW_ == 1)		//RW High means Read 
            begin
              if (countADD[5:0] == addr[5:0])
                data_out <= ram[addr[5:0]];
            end
          else if (RW_ == 0)	// RW Low means Write
            begin
              ram[addr[5:0]] <= data_in;
            end
        end
    end
endmodule