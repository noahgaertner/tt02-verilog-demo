![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# CHIP DOCS
Documentation for the actual design

### ***NOTE: MUST SEND SYNCHRONOUS RESET IMMEDIATELY BEFORE OPERATION***
  ## PINS: 
  - IN:
    - IN[0]: clock
    - IN[1]: reset
    - IN[2]: instruction[0]
    - IN[3]: instruction[1]
    - IN[4]: DATA[0]
    - IN[5]: DATA[1]
    - IN[6]: DATA[2]
    - IN[7]: DATA[3]
  - OUT:
    - OUT[0]: program counter[0]
    - OUT[1]: program counter[1]
    - OUT[2]: program counter[2]
    - OUT[3]: program counter[3]
    - OUT[4]: register value[0]
    - OUT[5]: register value[1]
    - OUT[6]: register value[2]
    - OUT[7]: register value[3]
  ## INSTRUCTIONS:
  ```sv
    LOADPROG = 2'd0, //loads a program into the program "file" using IN[7:4]
    LOADDATA = 2'd1, //loads data into the data "file" using IN[7:4]
    SETRUNPT = 2'd2, //designed to be used right before run, but can also be used to input additional data i guess
    RUNPROG  = 2'd3 //run the program
  ```
  ## ISA:
  ```sv
    LOAD = 4'd0, //loads a value from data file into register
    STORE = 4'd1, //stores value from register to data file
    ADD = 4'd2, //adds datac to register value
    MUL = 4'd3, //multiples register value by datac
    SUB = 4'd4, //subtracts datac from register value
    SHIFTL = 4'd5, //shifts register value left by datac
    SHIFTR = 4'd6, //shifts register value right by datac
    JUMPTOIF = 4'd7, //jumps pc to data[value] if io_in[7] is a 1, else 
    //does nothing
    LOGICAND = 4'd8,
    //logical and between register value and datac
    LOGICOR = 4'd9,
    //logical or between register value and datac
    EQUALS = 4'd10,
    //equality check between register value and datac
    NEQ = 4'd11,
    //inequality check between register value and datac
    BITAND = 4'd12,
    //bitwise and between register value and datac    
    BITOR = 4'd13,
    //bitwise or between register value and datac
    LOGICNOT = 4'd14,
    //logical not on register value 
    BITNOT = 4'd15
    //bitwise not on register value
  ```





# What is Tiny Tapeout?

TinyTapeout is an educational project that aims to make it easier and cheaper than ever to get your digital designs manufactured on a real chip!

Go to https://tinytapeout.com for instructions!

## How to change the Wokwi project

Edit the [info.yaml](info.yaml) and change the wokwi_id to match your project.

## How to enable the GitHub actions to build the ASIC files

Please see the instructions for:

* [Enabling GitHub Actions](https://tinytapeout.com/faq/#when-i-commit-my-change-the-gds-action-isnt-running)
* [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## How does it work?

When you edit the info.yaml to choose a different ID, the [GitHub Action](.github/workflows/gds.yaml) will fetch the digital netlist of your design from Wokwi.

After that, the action uses the open source ASIC tool called [OpenLane](https://www.zerotoasiccourse.com/terminology/openlane/) to build the files needed to fabricate an ASIC.

## Resources

* [FAQ](https://tinytapeout.com/faq/)
* [Digital design lessons](https://tinytapeout.com/digital_design/)
* [Join the community](https://discord.gg/rPK2nSjxy8)

## What next?

* Share your GDS on Twitter, tag it [#tinytapeout](https://twitter.com/hashtag/tinytapeout?src=hashtag_click) and [link me](https://twitter.com/matthewvenn)!
