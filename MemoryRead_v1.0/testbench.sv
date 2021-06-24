// Code your testbench here
// or browse Examples

module tb();
  integer counter;
  reg CLK;
  reg RST;
  reg [5:0] ADD;
  wire CLR;
  wire [5:0] OUT;
  wire [5:0] COUNTADD;
  
  memory memory0(CLK, RST, ADD, CLR, OUT);
  counter counter0(CLK, RST, COUNTADD);
  
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
    
    // RST is pulsed once to reset counter to 0
    RST = 1;
    RST <= 0;
    
    // Initialise Address to be called as 5
    ADD <= 5;
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
      RST <= 0;

      counter <= counter + 1;
      
      $display("============================");
      $display("ADD = %d", ADD);
      $display("OUT = %b or %d", OUT, OUT);
      $display("COUNTADD = %d", COUNTADD);    
      
      // CLR signal from Memory module triggers RST
      if (CLR == 0)
        begin
          RST <= 1;
        end
      
      // After counter reaches 5, change Address to 7.
      // This is to demonstrate calling an address when
      // counter has not been reset in time
      if (counter == 5)
        begin
          ADD <= 7;
        end
      
      // After 25 input entries, end simulation
      if (counter == 25)
        begin
          $finish;
        end
    end
endmodule