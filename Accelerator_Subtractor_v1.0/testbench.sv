// Code your testbench here
// or browse Examples

`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb();
  reg CLK;
  reg DE;
  reg [14:0] X;
  reg [14:0] Y;
  reg Bin;
  wire OE;
  wire [14:0] DIFF;
  wire Bout;
  
  integer counter;
  
  subtractor_module sm(CLK, DE, X, Y, Bin, OE, DIFF, Bout);
  
  // Initialise Registers
  initial begin
    //creating a file to store simulation waveform data
    $dumpfile("dump.vcd");
    //dump the waveform data to the file
    $dumpvars(1, tb);
    
    // Counter to determine simulation stop
    counter = 0;
    // Initialise Clock as 0 (LOW signal)
    CLK = 1'b0;
    
    X <= 0;
    Y <= 0;
    DE <= 0;
    Bin <= 0;
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
      counter <= counter + 1;
      
      X <= $urandom%63;
      Y <= $urandom%63;
      
      $display("============================");
      $display("X = %d", X);
      $display("Y = %d", Y);
      $display("DIFF = %d", DIFF);
      $display("OE = %d", OE);
      
      // After 30 input entries, end simulation
      if (counter == 5)
        begin
          $finish;
        end
    end
endmodule