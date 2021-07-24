use <vertical-memory-2.scad>;
use <decoder.scad>;

rotate([90,0,0]) memory_assembly();
translate([200,50,115]) rotate([0,90,0]) address_decoder();
