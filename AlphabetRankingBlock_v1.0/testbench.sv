// Code your testbench here
// or browse Examples

`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb();
  reg CLK;
  
  reg RST;
  reg [5:0] buffer_outcount_0;
  reg [5:0] buffer_outcount_1;
  wire [5:0] out_count;
  
  reg DE;
  reg BUFFER_DE;
  // NEED TO CHANGE TO 15 BITS
  reg [11:0] X;
  // NEED TO CHANGE TO 15 BITS
  reg [11:0] Y;
  reg Bin;
  wire OE;
  // NEED TO CHANGE TO 15 BITS
  wire [11:0] DIFF;
  wire Bout;
  
  reg RW_;
  reg CS;
  // NEED TO CHANGE TO 15 BITS
  reg [11:0] BUFFER_DIFF;
  // NEED TO CHANGE TO 15 BITS
  wire [11:0] DIFF_OUT;
  
  wire [5:0] addr_out;
  
  integer counter;
  
  counter co0(CLK, RST, out_count);
  subtractor_module sm(CLK, DE, X, Y, Bin, OE, DIFF, Bout);
  memory mem(CLK, buffer_outcount_1, BUFFER_DIFF, RW_, CS, DIFF_OUT, addr_out);
  
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
    
    RST <= 1;
    
    X <= 0;
    Y <= 0;
    DE <= 1;
    Bin <= 0;
    
    CS <= 0;
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
      buffer_outcount_0 <= out_count;
      buffer_outcount_1 <= buffer_outcount_0;
      
      BUFFER_DE <= DE;
      BUFFER_DIFF <= DIFF;
      RST <= 0;
      
      RW_ <= OE;
      
      counter <= counter + 1;
      
      if (counter < 5)
        begin
          DE <= 0;
          X <= $urandom%63;
          Y <= $urandom%63;
          if (counter == 4)
            begin
              X <= 2;
              Y <= 1;
            end
          if (OE == 0)
            begin
              CS <= 1;
            end
        end
      
      $display("============================");
      $display("X = %d", X);
      $display("Y = %d", Y);
      $display("DIFF = %d", DIFF);
      $display("OE = %d", OE);
      
      // I need a way to trigger DE -> 1 
      // Rather than using time-based
      // Maybe some way to detect no-more-input?
      if (counter == 5)
        begin
          RST <= 1;
          DE <= 1;
        end
      
      // After 20 input entries, end simulation
      if (counter == 20)
        begin
          $finish;
        end
    end
endmodule