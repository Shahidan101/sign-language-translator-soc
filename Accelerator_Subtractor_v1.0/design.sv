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

// 12-bit Full Subtractor
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
    .Bin(borrow[13]),
    .DIFF(DIFF[14]),
    .Bout(Bout)
  ); 
  
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
            end
          else if (BOUT == 0)
            begin
              NEW_OUT <= OUT;
              OE <= 0;
            end
        end
    end
endmodule