/* An earlier demonstration of the diagonal memory cell. For a full
   16x16 diagonal memory cell, see memory-cell-16.scad. This diagonal
   memory system is now obsolete. */

include <globs.scad>;

$fn = 20;

/** delta_y is how much a cell moves down for each cell across we move. */
delta_y  = memory_cell_pitch_x * tan(memory_slope);


/** Memory block - the shape which holds and releases a ball bearing. This is designed for a 6mm ball bearing - it will have to be redesigned if not. */
module memory_block()
{
  block_height = memory_cell_pitch_y - 8*cos(memory_slope);
  block_width = memory_cell_pitch_x - 1;
  difference() {
    // Outline/bounding box of the block
    polygon(points = [[0,0], [block_width, -delta_y],
		      [block_width, -delta_y-block_height], [0, -block_height]]);
    // Upper left chamber cut-out
    hull() {
      polygon(points = [[-0.1,-1], [1, -1.1*tan(memory_slope)-1],
			[1, 1.1*tan(memory_slope)-9],
			[-0.1, -1.1*tan(memory_slope)-9]]);
      translate([3.5,-3.5*tan(memory_slope)-4.5]) circle(d=7);
    }

    // Lower left chamber cut-out

    hull() {
      polygon(points = [[-0.1,-11], [1, -1.1*tan(memory_slope)-11],
			[1, -1.1*tan(memory_slope)-20],
			[-0.1, -1.1*tan(memory_slope)-20]]);
      polygon(points = [[-0.1,-20], [7, -7.1*tan(memory_slope)-20],
			[7, -7.1*tan(memory_slope)-22],
			[-0.1, -7.1*tan(memory_slope)-22]]);
      translate([3.5,-3.5*tan(memory_slope)-11-3.5]) circle(d=7);
    }

    // Right chamber cut out
    hull() {
      polygon(points = [[8,0],[memory_cell_pitch_x+0.1,0],[memory_cell_pitch_x+0.1,-block_height+1-delta_y],[8,-block_height+3.5-8*tan(memory_slope)+1]]);
      translate([11.5,-11.5*tan(memory_slope)-11-3.5]) circle(d=7);
    }
  } // end of difference
}

module horizontal_stop_bar()
{
  polygon(points = [[0,0],[7, -7*tan(memory_slope)],
		    [7, -7*tan(memory_slope)-1],[0,-1]]);
}

module vertical_stop_bar()
{
  polygon(points = [[0,0],[1, -1*tan(memory_slope)],
		    [1, -1*tan(memory_slope)-5.5],[0,-5.5]]);
}


/* ----------------- TEST SECTION ------------------------ */

/* Test objects */
for(x = [0:3]) {
  for(y = [0:3]) {
    translate([memory_cell_pitch_x * x,
	       -delta_y * x - memory_cell_pitch_y*y]) linear_extrude(height=6) memory_block();
  }
}
//  translate([5,-100,5]) cube([memory_cell_pitch_x - 1, 100,2]);

for(y = [0:3]) {
  translate([0,-8*0.5*(1+cos($t*360)) - y*memory_cell_pitch_y]) {
    color([1.0,0,0]) translate([8.5, -8.5*tan(memory_slope)]) linear_extrude(height=8) horizontal_stop_bar();
    color([0,1.0,0]) translate([15.5, -15.5*tan(memory_slope)-14]) linear_extrude(height=8) vertical_stop_bar();
  }
 }

/* Test balls */
translate([12,-25.5,3]) sphere(d=6);
