// Code your testbench here
// or browse Examples

`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module test_adder();
  integer counter;
  reg CLK;
  reg [5:0] X;
  reg [5:0] Y;
  reg Carry_IN;
  wire Carry_OUT;
  wire [5:0] BIN_OUT;
  
  full_adder6 full_adder6_1(X, Y, Carry_IN, BIN_OUT, Carry_OUT);
  
  // Initialise Registers
  initial begin
    //creating a file to store simulation waveform data
    $dumpfile("dump.vcd");
    //dump the waveform data to the file
    $dumpvars(1, test_adder);
    
    // Counter to determine simulation stop
    counter = 0;
    // Initialise Counter as 0
    CLK = 1'b0;
  end

  	// Runs indefinitely
    always
      begin
        // Pulsing of CLK
        CLK = 1'b1; 
    	#20; // high for 20 * timescale = 20 ns

    	CLK = 1'b0;
    	#20; // low for 20 * timescale = 20 ns
      end    
    
  	// Execute input and processing at positive edge of CLK
    always @(posedge CLK)
      begin
        counter = counter + 1;
        X = 30;
        Y = 20;
        Carry_IN = 0;
        
        // Add a delay before the displays
        // Cause the bits won't reach the module in time
        // Brrrrrr
        $display("============================");
        $display("A = %b or %d", X, X);
        $display("B = %b or %d", Y, Y);
        $display("CARRY_IN = %b", Carry_IN);    
        $display("SUM = %b or %d", BIN_OUT, BIN_OUT);
        $display("CARRY_OUT = %b", Carry_OUT);
        
        // After 5 input entries, end simulation
        if (counter == 6)
          begin
            $finish;
          end
      end
endmodule