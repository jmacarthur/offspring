/* A 3d printed small test of the memory cell unit */
include <globs.scad>;
use <memory.scad>;

/** delta_y is how much a cell moves down for each cell across we move. */
delta_y  = memory_cell_pitch_x * tan(memory_slope);


translate([0,-85,0]) cube([65,85,1]);

for(x = [0:3]) {
  for(y = [0:2]) {
    translate([memory_cell_pitch_x * x,
	       -delta_y * x - memory_cell_pitch_y*y]) linear_extrude(height=7) memory_block();
  }
}
