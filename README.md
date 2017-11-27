# Millihertz Model F ("Offspring")

This is a project to create a working replica of the Manchester small-scale experimental machine, otherwise known as the Manchester Baby.

It will be implemented fully mechanically, that is, without any electronic or electric components. All power must be taken from a single rotating shaft input.

The finished machine should be a complete, binary-compatible implementation of the original SSEM, capable of running the same programs.

It will be significantly slower than the original machine. It is meant to operate at about one cycle every 10 seconds (100mHz) compared to the 1kHz+ operation of the original machine.

The machine is not intended to be a useful tool; it's done mainly for fun, and to act as a visual demonstration of the operation of a stored-program computer.

## Overview diagram

![Overview diagram](millihertz5.png)

The machine is organised to take as much advantage of gravity as possible. The datapath runs down the machine, from the distributor at the top to the memory and then into the subtractor and accumulator. It is 32 bits wide, as was the original SSEM.

The major parts of the design have their own description pages in `docs/`.

* [Memory](docs/vertical-memory.md) - a 32x32 bit random-access memory, with address decoder.
* [Subtractor-accumulator](docs/subtractor-accumulator.md) - remembers its current value and subtracts whatever ball bearings are passed to it - a ball bearing in column 4 subtracts 16 from the accumulator, for example. Subtraction is the only arithmetic operation needed.

Parts not yet described are:

* The distributor, at the top of the machine, which measures out exactly 32 ball bearings and spreads them apart so they are the right pitch to enter the memory cell
* The memory injector, which allows selected ball bearings into the memory. There are 32 cables or rods connecting the regenerator (below) to the injector. When one is pulled down, the injector releases one of the ball bearings (which came out of the distributor) into the memory. There's also a separate control to discard any unused ball bearings in the injector.
* The regenerator samples the data coming out of the memory and pulls the rods leading to the injector, effectively sending the same pattern back into the top of the memory. This is important as reading is a destructive operation on the current memory.
* A series of diverters can send the data to the subtractor-accumulator, or the program counter, or the instruction register.
* A second regenerator below the subtractor-accumulator reads the values in the accumulator and sends them to the injector, for use in store operations.

Finally, at the bottom, all discarded ball bearings are collected and recirculated (perhaps by conveyor belt) to the distributor.
