`default_nettype none `timescale 1ns / 1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb (
    // testbench is controlled by test.py
    input  clk,
    input  rst,
    output outputs[7:0]
);

  // this part dumps the trace to a vcd file that can be viewed with GTKWave
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end
  enum logic [1:0] {
    LOADPROG = 2'd0,
    LOADDATA = 2'd1,
    SETRUNPT = 2'd2,
    RUNPROG  = 2'd3
  } instruction;
  logic [3:0] datain;
  // wire up the inputs and output 
  logic [7:0] inputs;
  assign inputs = {data, instruction, rst, clk};

  // instantiate the DUT
  noahgaertner_cpu cpu_dut (
      .io_in (inputs),
      .io_out(outputs)
  );

endmodule
