# About
VHDL-FIFO implements a single clock domain FIFO. The test bench was written for GHDL.

![Block Diagram](Fifo.svg)

# Running
First makesure GHDL is installed
```
which ghdl
```
If no path is returned, download, compile and install GHDL, the source code is here:  [https://github.com/tgingold/ghdl](https://github.com/tgingold/ghdl).

If GHDL is installed then you can run the test script file, which will call all the nessesary GHDL commands to compile and run the sim.
```
./FifoTest.sh
```

If you see something like this, IE. No errors are reported, then the test passed. 
```
../../src/ieee2008/numeric_std-body.vhdl:1774:7:@0ms:(assertion warning): NUMERIC_STD."=": metavalue detected, returning FALSE
Fifo_tb.vhd:232:9:@220ns:(assertion note): end of test
```
