# About
VHDL-FIFO implements a single clock domain FIFO. The test bench was written for GHDL.

![Block Diagram](Fifo.svg)

# Running
First makesure GHDL is installed
```
which ghdl
```
If no path is returned, download, compile and install GHDL, the source code is here:  [https://github.com/tgingold/ghdl](https://github.com/tgingold/ghdl).

If it is then run the test script file, which will call all the nessesary GHDL commands to compile and run the sim.
```
./FifoTest.sh
```
If there are no errors the test passed. 

