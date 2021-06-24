// Code your testbench here
// or browse Examples

module tb();
  integer counter;
  reg CLK;
  reg RST;
  wire [5:0] OUT;
  
  counter count0(CLK, RST, OUT);
  
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
      
      counter = counter + 1;

      $display("============================");
      $display("OUT = %b or %d", OUT, OUT);

      // After 68 input entries, end simulation
      // Exceeding counter limit to demonstrate overflow
      if (counter == 68)
        begin
          $finish;
        end
    end
endmodule