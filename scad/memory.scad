include <globs.scad>;

$fn = 20;

/** delta_y is how much a cell moves down for each cell across we move. */
delta_y  = memory_cell_pitch_x * tan(memory_slope);


/*

       |
       |
       |
       |
       |
       |
       |


/** Memory block - the shape which holds and releases a ball bearing. This is designed for a 6mm ball bearing - it will have to be redesigned if not. */
module memory_block()
{
  block_height = memory_cell_pitch_y - 8*cos(memory_slope);
  difference() {
    // Outline/bounding box of the block
    polygon(points = [[0,0], [memory_cell_pitch_x, -delta_y],
		      [memory_cell_pitch_x, -delta_y-block_height], [0, -block_height]]);
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

    // Right chamber cut-out
    hull() {
    polygon(points = [[8,0],[memory_cell_pitch_x+0.1,0],
      [memory_cell_pitch_x+0.1,-block_height+1-delta_y],[8,-block_height+3.5-8*tan(memory_slope)+1]]);
    translate([11.5,-11.5*tan(memory_slope)-11-3.5]) circle(d=7);
  }

  }
}

/* Test objects */
for(x = [0:3]) {
  for(y = [0:3]) {
    translate([memory_cell_pitch_x * x,
	       -delta_y * x - memory_cell_pitch_y*y])  memory_block();
  }
}


/* Test balls */
translate([3,-4.5]) sphere(d=6);
