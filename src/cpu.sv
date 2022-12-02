`default_nettype none
module noahgaertner_cpu (
    input  logic [7:0] io_in,
    output logic [7:0] io_out
);
  logic clock, reset;
  assign clock = io_in[0];  //clock
  assign reset = io_in[1];  //reset to clear everything
  typedef enum logic [3:0] {
    LOAD = 4'd0, //loads a value from data file into operation register
    STORE = 4'd1, //stores value from operation register to data file
    ADD = 4'd2, //adds data[pc] to operation register value
    MUL = 4'd3, //multiples operation register value by data[pc]
    SUB = 4'd4, //subtracts data[pc] from operation register value
    SHIFTL = 4'd5, //shifts operation register value left by data[pc] or 3, 
    //whichever is less
    SHIFTR = 4'd6, //shifts operation register value right by data[pc] or 3,
    //whichever is less
    JUMPTOIF = 4'd7, //jumps pc to data[value] if io_in[7] is a 1, else 
    //increments pc by 1 instead 
    LOGICAND = 4'd8,
    //logical and between operation register value and data[pc]
    LOGICOR = 4'd9,
    //logical or between operation register value and data[pc]
    EQUALS = 4'd10,
    //equality check between operation register value and data[pc]
    NEQ = 4'd11,
    //inequality check between operation register value and data[pc]
    BITAND = 4'd12,
    //bitwise and between operation register value and data[pc]    
    BITOR = 4'd13,
    //bitwise or between operation register value and data[pc]
    LOGICNOT = 4'd14,
    //logical not on operation register value 
    BITNOT = 4'd15
    //bitwise not on operation register value
  } prog_t;
  //yosys doesn't like it if i enum directly instead of typedef w/ memories for 
  //some reason
  prog_t prog[15:0];  //program storage "file"
  logic [3:0] data[15:0];  //data storage :file
  enum logic [1:0] {
    LOADPROG = 2'd0,
    LOADDATA = 2'd1,
    SETRUNPT = 2'd2,
    RUNPROG  = 2'd3
  } instruction;
  assign instruction = io_in[3:2];  //current instruction
  logic [3:0] pc;  //program counter
  logic [3:0] regval;  //current value being operated on (accumulator)
  assign io_out = {regval, pc};
  logic [3:0] nextpc;  //next program counter
  assign nextpc = pc + 1;
  logic [3:0] inputdata;  //input data
  assign inputdata = io_in[7:4];

  always_ff @(posedge clock) begin
    if (reset) begin
      case (instruction)

        LOADPROG: begin  //loads a program into the program "file"
          prog[pc] <= inputdata;
          pc <= nextpc;
        end
        LOADDATA: begin  //loads data into the data "file"
          data[pc] <= inputdata;
          pc <= nextpc;
        end
        SETRUNPT: begin //designed to be used right before run, but can also be used to input additional data i guess
          pc <= inputdata;
        end
        RUNPROG: begin  //run the program
          case (prog[pc])
            LOAD: begin
              //loads a value from the data file
              regval <= data[pc];
              pc = nextpc;
            end
            STORE: begin
              //stores a value into the data file
              data[data[pc]] <= regval;
              pc <= nextpc;
            end
            ADD: begin
              //adds the value at the appropriate data address to the register
              regval <= regval + data[pc];
              pc <= nextpc;
            end
            SUB: begin
              //subtracts the value at the appropriate addr from the register
              pc <= regval - data[pc];
              pc <= nextpc;
            end
            WAIT: begin
              //waits a clock cycle - not sure why you would ever, but whatever
              pc <= nextpc;
            end
            MUL: begin
              //multiplies the register by the value at the appropriate addr
              pc <= nextpc;
              regval <= regval * data[pc];
            end
            SHIFTL: begin
              //shifts the register left by the value at the appropriate addr, 
              //or 3, whichever is less.
              pc <= nextpc;
              regval <= ((data[pc]<4) ? regval<<data[pc] : regval << 3);
            end
            SHIFTR: begin
              //shifts the register right by the value at the appropriate addr, 
              //or 3, whichever is less
              pc <= nextpc;
              regval <= ((data[pc]<4) ? regval>>data[pc] : regval >> 3);
            end
            JUMPTOIF: //jumps to value if input pin 7 is a one
              //not unconditional to avoid looping forever
              //weird external condition because of single-register/stack 
              //design due to space limits & effective max of 16 
              //microinstructions, which is theoretically circumventable
              //by serializing IO and reassembling, but that takes too much 
              //space
            begin
              if (inputdata[3] == 1) begin
                pc <= data[pc];
              end else begin
                pc <= nextpc;
              end
            end
            LOGICAND: begin
              //logical and between regval and data[pc]
              pc <= nextpc;
              regval <= regval && data[pc];
            end
            LOGICOR: begin
              //logical or between regval and data[pc]
              pc <= nextpc;
              regval <= regval || data[pc];
            end
            EQUALS: begin
              //equality check between regval and data[pc]
              pc <= nextpc;
              regval <= (regval == data[pc]);
            end
            NEQ: begin
              //inequality check between regval and data[pc]
              pc <= nextpc;
              regval <= (regval != data[pc]);
            end
            BITAND: begin
              //bitwise and between regval and data[pc]
              pc <= nextpc;
              regval <= (regval & data[pc]);
            end
            BITNOT: begin
              //bitwise inversion on regval
              pc<= nextpc;
              regval <= ~(regval);
            end
            BITOR: begin
              //bitwise or between regval and data[pc]
              pc<= nextpc;
              regval <= (regval | data[pc]);
            end
            LOGICNOT: begin
              //logical NOT on regval
              pc <= nextpc;
              regval <= !regval;
            end
          endcase
        end
      endcase
    end else begin
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
