// Code your testbench here
// or browse Examples

`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb();
  integer counter;
  reg CLK;
  reg RST;
  reg [5:0] ADD;
  reg [14:0] DATAIN;
  reg RW;
  reg CS;
  wire [5:0] COUNTADD;
  wire [14:0] DATAOUT;
  
  memory memory0(CLK, RST, ADD, DATAIN, RW, CS, DATAOUT);
  counter count0(CLK, RST, COUNTADD);
  
  // Initialise Registers
  initial begin
    //creating a file to store simulation waveform data
    $dumpfile("dump.vcd");
    //dump the waveform data to the file
    $dumpvars(1, tb);
    
    // Counter to determine simulation stop
    counter = -1;
    // Initialise Clock as 0 (LOW signal)
    CLK = 1'b0;
    
    // Blip the RST register
    RST <= 1;
    
    ADD <= 6'b111111;
    DATAIN <= 15'b111111111111111;
    
    RW = 0;
    CS = 1; 
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
      
      if (counter == -1)
        RST <= 0;
      counter <= counter + 1;
      
      if (counter < 64)
        begin
          RW <= 0;
          ADD <= ADD + 1;
          DATAIN <= DATAIN + 1;
        end
      else if (counter > 63)
        begin
          RW <= 1;
          ADD <= 5;
        end
      
      if (counter > 127)
        $finish;
      
      $display("============================");
      $display("ADD = %b", ADD);
      $display("RW = %b", RW);
      $display("CS = %b", CS);
      $display("DATAIN = %b", DATAIN);
      $display("COUNTADD = %b", COUNTADD);
      $display("DATAOUT = %b", DATAOUT);
      
    end
endmodule