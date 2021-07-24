# Index of OpenSCAD files

## Components, roughly in order from top to bottom

* octo-distributor-5.scad - current combined injector which can selectively pass ball bearings into memory and divert them to the subtractor.
* vertical-memory-2.scad - current candidate for vertical, 8x8 memory.
* decoder.scad - 16 word memory address decoder, placed alongside the memory.
* planar-diverter.scad - for diverting memory output to accumulator, PC and instruction decoder, and also the first regenerator
* subtractor.scad - subtractor/accumulator unit, used for both the main accumulator and PC
* memory-sender-3.scad - transmits memory addresses back up to the decoder.
* base-regenerator.scad - the regenerator below the accumulator
* sequencer.scad - Main timing cam and instruction decoder.

## Assemblies

TBC

## Library files

* regenerator.scad - Common parts for the two regenerators.
* globs.scad - Constants for all files, such as the diameter of ball bearings.
* generic_conrods.scad - for producing rounded rectangles (stadia) with holes in each end, used as connecting rods.
* interconnect.scad - for connecting Bowden cables to other moving parts.
