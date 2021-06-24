// Code your design here

// Module for a single full-adder
module full_adder(
  input A, B, Cin,
  output S, Cout
);
  
  // Nets in-between the gate stages
  wire net1, net2, net3;
  
  // Referring to Digital Circuit of Full Adder
  xor (net1, A, B);
  xor (S, net1, Cin);
  and (net3, A, B);
  and (net2, net1, Cin);
  or (Cout, net2, net3);
endmodule

// Module for an 6-bit Ripple Carry Full Adder
module full_adder6(
  input [5:0] A, B,
  input Cin,
  output [5:0] S,
  output Cout);
  
  wire [4:0] carry;
  
  // Applying single full-adders to implement 8-bit adder
  full_adder fa0(
    .A(A[0]),
    .B(B[0]),
    .Cin(Cin),
    .S(S[0]),
    .Cout(carry[0])
  );
  
  full_adder fa1(
    .A(A[1]),
    .B(B[1]),
    .Cin(carry[0]),
    .S(S[1]),
    .Cout(carry[1])
  );
  
  full_adder fa2(
    .A(A[2]),
    .B(B[2]),
    .Cin(carry[1]),
    .S(S[2]),
    .Cout(carry[2])
  );
  
  full_adder fa3(
    .A(A[3]),
    .B(B[3]),
    .Cin(carry[2]),
    .S(S[3]),
    .Cout(carry[3])
  );
  
  full_adder fa4(
    .A(A[4]),
    .B(B[4]),
    .Cin(carry[3]),
    .S(S[4]),
    .Cout(carry[4])
  );
  
  full_adder fa5(
    .A(A[5]),
    .B(B[5]),
    .Cin(carry[4]),
    .S(S[5]),
    .Cout(Cout)
  );
endmodule 

// Module for simplified representation of 64x64 Flash Memory
module flashMem(
  input OE,		// Output Enable
  input [63:0] add,
  input CE,		// Chip Enable
  input RW,		// Read-Write
  output [63:0] data
  output BUSY_OFF_MEM,	// BusyOff to allow new input
);
  
  wire [63:0] mem [63:0][0];	// Array of Memory
  wire counter_cout;
  integer i;
  integer counter = 0;
  
  // Pre-assign voltage data to each alphabet
  // Total of 37 characters:
  //	26 Alphabets
  //	10 Numbers
  //	1 ClearScreen Gesture
  
  // Write Voltage Value Part
//   mem[0][0] <= ;
//   mem[1][0] <= ;
//   mem[2][0] <= ;
//   mem[3][0] <= ;
//   mem[4][0] <= ;
//   mem[5][0] <= ;
//   mem[6][0] <= ;
//   mem[7][0] <= ;
//   mem[8][0] <= ;
//   mem[9][0] <= ;
//   mem[10][0] <= ;
//   mem[11][0] <= ;
//   mem[12][0] <= ;
//   mem[13][0] <= ;
//   mem[14][0] <= ;
//   mem[15][0] <= ;
//   mem[16][0] <= ;
//   mem[17][0] <= ;
//   mem[18][0] <= ;
//   mem[19][0] <= ;
//   mem[20][0] <= ;
//   mem[21][0] <= ;
//   mem[22][0] <= ;
//   mem[23][0] <= ;
//   mem[24][0] <= ;
//   mem[25][0] <= ;
//   mem[26][0] <= ;
//   mem[27][0] <= ;
//   mem[28][0] <= ;
//   mem[29][0] <= ;
//   mem[30][0] <= ;
//   mem[31][0] <= ;
//   mem[32][0] <= ;
//   mem[33][0] <= ;
//   mem[34][0] <= ;
//   mem[35][0] <= ;
//   mem[36][0] <= ;
//   mem[37][0] <= ;
  
  // Dummy voltage value assign
  for (i = 0; i < 38; i = i + 1)
    begin
      mem[i][0] <= i;
    end
  
  if (CE == 0)
    begin
      begin
        if (add == counter)
          begin
            data <= mem[counter][0];
          end
        full_adder6 fa6_0(counter, 1, 0, counter, counter_cout);
        if (counter == 64)
          begin
            counter <= 0;
          end
      end
    end
endmodule