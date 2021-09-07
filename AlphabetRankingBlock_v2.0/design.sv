// 6-bit RST Counter
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

// Single Full Subtractor
module full_sub(
  input X,
  input Y,
  input Bin,
  output DIFF,
  output Bout
);
  
  wire X1;
  wire X2;
  wire X3;
  
  xor(X1, X, Y);
  and(X2, ~X, Y);
  and(X3, ~X1, Bin);
  xor(DIFF, X1, Bin);
  or(Bout, X3, X2);
  
endmodule

// 15-bit Full Subtractor
module full_sub12(
  input [14:0] X, Y,
  input Bin,
  output [14:0] DIFF,
  output Bout);
  
  wire [13:0] borrow;
  
  // Applying single full-subtractors to implement 12-bit subtractor
  full_sub fs0(
    .X(X[0]),
    .Y(Y[0]),
    .Bin(Bin),
    .DIFF(DIFF[0]),
    .Bout(borrow[0])
  );
  
  full_sub fs1(
    .X(X[1]),
    .Y(Y[1]),
    .Bin(borrow[0]),
    .DIFF(DIFF[1]),
    .Bout(borrow[1])
  );
  
  full_sub fs2(
    .X(X[2]),
    .Y(Y[2]),
    .Bin(borrow[1]),
    .DIFF(DIFF[2]),
    .Bout(borrow[2])
  );
  
  full_sub fs3(
    .X(X[3]),
    .Y(Y[3]),
    .Bin(borrow[2]),
    .DIFF(DIFF[3]),
    .Bout(borrow[3])
  );
  
  full_sub fs4(
    .X(X[4]),
    .Y(Y[4]),
    .Bin(borrow[3]),
    .DIFF(DIFF[4]),
    .Bout(borrow[4])
  );
  
  full_sub fs5(
    .X(X[5]),
    .Y(Y[5]),
    .Bin(borrow[4]),
    .DIFF(DIFF[5]),
    .Bout(borrow[5])
  );
  
  full_sub fs6(
    .X(X[6]),
    .Y(Y[6]),
    .Bin(borrow[5]),
    .DIFF(DIFF[6]),
    .Bout(borrow[6])
  );
  
  full_sub fs7(
    .X(X[7]),
    .Y(Y[7]),
    .Bin(borrow[6]),
    .DIFF(DIFF[7]),
    .Bout(borrow[7])
  );
  
  full_sub fs8(
    .X(X[8]),
    .Y(Y[8]),
    .Bin(borrow[7]),
    .DIFF(DIFF[8]),
    .Bout(borrow[8])
  );
  
  full_sub fs9(
    .X(X[9]),
    .Y(Y[9]),
    .Bin(borrow[8]),
    .DIFF(DIFF[9]),
    .Bout(borrow[9])
  );
  
  full_sub fs10(
    .X(X[10]),
    .Y(Y[10]),
    .Bin(borrow[9]),
    .DIFF(DIFF[10]),
    .Bout(borrow[10])
  );
  
  full_sub fs11(
    .X(X[11]),
    .Y(Y[11]),
    .Bin(borrow[10]),
    .DIFF(DIFF[11]),
    .Bout(borrow[11])
  );
  
  full_sub fs12(
    .X(X[12]),
    .Y(Y[12]),
    .Bin(borrow[11]),
    .DIFF(DIFF[12]),
    .Bout(borrow[12])
  );
  
  full_sub fs13(
    .X(X[13]),
    .Y(Y[13]),
    .Bin(borrow[12]),
    .DIFF(DIFF[13]),
    .Bout(borrow[13])
  );
  
  full_sub fs14(
    .X(X[14]),
    .Y(Y[14]),
    .Bin(borrow[9]),
    .DIFF(DIFF[14]),
    .Bout(Bout)
  );
  
endmodule 

// Cache Memory for Accelerator
module memory(CLK, addr, data_in, RW_, CS, data_out, addr_out);
  input CLK;
  input [5:0] addr;
  input [14:0] data_in;
  input RW_, CS;	//ReadWrite, Chip Select
  output reg [14:0] data_out;
  output reg [5:0] addr_out;
  
  // Address Space in Chip = 64 pages
  // Data Space in a Cell = 15 bits
  reg [14:0] ram[63:0];
  reg [14:0] min;
  reg [5:0] smallest_addr;  
  
  integer i;

  // Initialise memory with Z values
  initial begin
    for (i = 0; i < 64; i = i+ 1) begin
      ram[i[5:0]] <= 15'bz;
    end
    
    min <= 63;
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
              // Sorting starts here
              for (i = 0; i < 64; i = i+ 1) 
                begin
                  if (ram[i[5:0]] < min)
                    begin
                      min <= ram[i[5:0]];
                      smallest_addr <= i;
                    end
                end
              
              addr_out <= smallest_addr;
              // Output the address (alphabet)
              data_out <= ram[addr[5:0]];
            end
          else if (RW_ == 0)	// RW Low means Write
            begin
              ram[addr[5:0]] <= data_in;
            end
        end
    end
endmodule

// Subtractor submodule
module subtractor_module(
  input CLK,
  input DE,
  input [14:0] SENSOR_IN,
  input [14:0] REF,
  input BIN,
  output reg OE,
  output reg [14:0] NEW_OUT,
  output BOUT
);
  
  wire [5:0] count;
  wire [14:0] OUT;
  
  full_sub12 fs12_0(SENSOR_IN, REF, BIN, OUT, BOUT);
  
  always @(posedge CLK)
    begin
      if (DE == 1)
        begin
          NEW_OUT <= 15'bz;
          OE <= 1;
        end
      else if (DE == 0)
        begin
          if (BOUT == 1)
            begin
              NEW_OUT <= ~OUT + 1'b1;
              OE <= 0;
            end
          else if (BOUT == 0)
            begin
              NEW_OUT <= OUT;
              OE <= 0;
            end
        end
    end
endmodule

module sorting(CLK, addr_in, data_in, RW_, CS, addr_out);
  input CLK;
  input [5:0] addr_in;
  input [14:0] data_in;
  input RW_, CS;	//ReadWrite, Chip Select
  output reg [5:0] addr_out;
  
  reg [14:0] ram[63:0];
  
  always @(posedge CLK)
    begin
      ram[addr_in[5:0]] <= data_in;
    end
  
endmodule