include <globs.scad>;

/** delta_y is how much a cell moves down for each cell across we move. */
delta_y  = memory_cell_pitch_x * tan(memory_slope);


/** Memory block - the shape which holds and releases a ball bearing. This is designed for a 6mm ball bearing - it will have to be redesigned if not. */
module memory_block()
{
  block_height = memory_cell_pitch_y - 8*cos(memory_slope);
  polygon(points = [[0,0], [memory_cell_pitch_x, -delta_y],
		    [memory_cell_pitch_x, -delta_y-block_height], [0, -block_height]]);
}

/* Test objects */
for(x = [0:3]) {
  for(y = [0:3]) {
    translate([memory_cell_pitch_x * x,
	       -delta_y * x - memory_cell_pitch_y*y])  memory_block();
  }
 }
