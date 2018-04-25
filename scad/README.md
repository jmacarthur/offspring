# Index of OpenSCAD files

## Components

* base-regenerator.scad - the regenerator below the subtractor
* decoder.scad - the 4-to-16 (expandable) decoder/demultiplexer for driving the memory rows.
* diverter-v2.scad - the older, super-simple diverter which is just a simple swinging plate for attaching conduit to.
* injector.scad - older injection system for selectively injecting ball bearings into memory. Requires a separate metering unit to measure out exactly 8 ball bearings and distribute them to the correct pitch.
* octo-distributor-3.scad - old top-end metering system for metering out exactly 8 ball bearings and doing the first stage of distribution.
* octo-distributor-4.scad - current combined injector which can selectively pass ball bearings into memory and divert them to the subtractor.
* regen-splitter.scad - a combination of regenerator and two splitters to go between the memory and subtractor.
* stage2-distributor.scad - takes the output from octo-distributor-3 and spreads the data further widthwise to feed into `injector.scad`.
* strip-tester.scad - old module for grading the size of cut needed for precise fit of brass strips.
* subtractor.scad - the subtractor/accumulator unit.
* vertical-memory-2.scad - current candidate for vertical, 8x8 memory.

## Assemblies

* datapath_assembly.scad - Now significantly out of date, this attempt to show an arrangement of all the datapath modules (i.e. injector, memory, diverters, subtractor-accumulator and regenerators)
* top-assembly.scad - A combination of `injector.scad`, `stage2-distributor.scad` and `octo-distributor-3.scad`, with a clear casing to hold them all together.

## Library files

* regenerator.scad - Common parts for the two regenerators.
* globs.scad - Constants for all files, such as the diameter of ball bearings.
* generic_conrods.scad - for producing rounded rectangles (stadia) with holes in each end, used as connecting rods.
* interconnect.scad - for connecting Bowden cables to other moving parts.

## Lasercut files

Most of these were checked into git to provide an audit of what was cut, however, not all laser cutting was recorded.

* decoder-laser-moving.scad
* decoder-laser.scad
* decoder-laser-static.scad
* april-laser.scad
* diverter-v2-laser.scad
* injector-laser.scad
* octo-distributor-3-laser.scad
* octo-distributor-4-laser.scad
* stage2-laser.scad
* subtractor_laser_layout.scad

