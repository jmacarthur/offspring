/* Vertical 16x16 memory cell, 3D assembly */

include <globs.scad>;
use <vertical-memory.scad>;

rows = 8;
cell_height = 14;

for(col=[0:7]) {
  union() {
    for(row=[0:rows]) {
      translate([col*30+10,row*cell_height]) memory_cell();
      translate([col*30+15,row*cell_height+14]) rotate(180) memory_cell();
    }
  }
 }

translate([20,130]) base_plate();

for(y=[0:7]) translate([30,260+15*y]) row_selector();

for(x=[0:3])
translate([220+15*x,130]) row_comb();
