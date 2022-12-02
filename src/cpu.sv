`default_nettype none
module noahgaertner_cpu (input logic [7:0] io_in,
  output logic [7:0] io_out
);
  logic clock, reset;
  assign clock = io_in[0];
  assign reset = io_in[1];
  typedef enum logic [3:0]{LOAD = 4'd0, STORE = 4'd1, ADD = 4'd2, MUL = 4'd3, WAIT = 4'd4, MAC = 4'd5, SUB = 4'd6, SHIFTL = 4'd7, SHIFTR = 4'd8, JUMPTOIF = 4'd9} prog_t;
  prog_t prog[15:0];
  logic [3:0] data [15:0];
  enum logic [1:0] {LOADPROG=2'd0, LOADDATA=2'd1, SETRUNPT=2'd2,RUNPROG=2'd3} instruction;
  assign instruction = io_in[3:2];
  logic [3:0]   pc;
  logic [3:0]   regval;
  assign io_out = {regval, pc};
  logic [3:0]  nextpc;
  assign nextpc = pc + 1;
  logic [3:0]  inputdata;
  assign inputdata = io_in[7:4];
  genvar i;

  always_ff @(posedge clock) begin
    if (reset) begin
      case (instruction)
        
        LOADPROG: begin //loads a program into the program "file"
          prog[pc] <= inputdata;
          pc <= nextpc;
        end
        LOADDATA: begin //loads data into the data "file"
          data[pc] <= inputdata;
          pc <= nextpc;
        end
        SETRUNPT: begin //designed to be used right before run, but can also reset I guess?
          pc <= inputdata;
          regval <= 0;
        end
        RUNPROG: begin //run the program
          case (prog[pc])
            LOAD: begin 
              regval <= data[pc]; pc = nextpc; 
            end
             //loads a value from the data file
            STORE: begin 
              data[data[pc]] <= regval; pc <= nextpc;
            end
             //stores a value into the data file
            ADD: begin 
              regval <= regval + data[pc]; pc <= nextpc;
            end
             //adds the value at the appropriate data address to the register
            SUB: begin 
              pc <= regval - data[pc]; pc<= nextpc;
            end
             //subtracts the value at the appropriate addr from the register
            WAIT: begin
              pc <= nextpc; 
              end
             //waits a clock cycle - not sure why you would ever, but whatever
            MUL: begin 
              pc<= nextpc; regval <= regval * data[pc]; 
            end
             //multiplies the register by the value at the appropriate addr
            SHIFTL: begin 
              pc<= nextpc; regval <= regval << data[pc];
            end
              //shifts the register left by the value at the appropriate addr
            SHIFTR: begin 
              pc<= nextpc; regval <= regval >> data[pc]; 
            end
              //shifts the register right by the value at the appropriate addr
            MAC: begin 
              pc<= nextpc; regval <= regval + (data[pc] * inputdata);
            end
              //multiplies the value at the appropriate addr by the input data and adds it to the register
            JUMPTOIF: //jumps to value if input pin 7 is a one
              //not unconditional to avoid looping forever
            begin 
              if (inputdata[3]==1) begin 
                pc <= data[pc]; 
              end else begin 
                pc <= nextpc; 
                end
            end
          endcase
        end
      endcase
    end
    else begin
      pc <= 0;
      regval <= 0;
      data[0] <= 4'd0;
      data[1] <= 4'd0;
      data[2] <= 4'd0;
      data[3] <= 4'd0;
      data[4] <= 4'd0;
      data[5] <= 4'd0;
      data[6] <= 4'd0;
      data[7] <= 4'd0;
      data[8] <= 4'd0;
      data[9] <= 4'd0;
      data[10] <= 4'd0;
      data[11] <= 4'd0;
      data[12] <= 4'd0;
      data[13] <= 4'd0;
      data[14] <= 4'd0;
      data[15] <= 4'd0;
      prog[0] <= 4'd0;
      prog[1] <= 4'd0;
      prog[2] <= 4'd0;
      prog[3] <= 4'd0;
      prog[4] <= 4'd0;
      prog[5] <= 4'd0;
      prog[6] <= 4'd0;
      prog[7] <= 4'd0;
      prog[8] <= 4'd0;
      prog[9] <= 4'd0;
      prog[10] <= 4'd0;
      prog[11] <= 4'd0;
      prog[12] <= 4'd0;
      prog[13] <= 4'd0;
      prog[14] <= 4'd0;
      prog[15] <= 4'd0;
    end
  end
endmodule
