/* A complete 3D assembly for a 16x16 memory cell using the older
   diagonal memory system. */

include <globs.scad>;
use <memory.scad>;

base_plate_thickness = 2;
selector_base_thickness = 2;
delta_y  = memory_cell_pitch_x * tan(memory_slope);

width = memory_cell_pitch_x * 17;
height = memory_cell_pitch_y * 16;

border_width = 20;
border_height = 20;

column_height = height+50;

union() {
  // Base plate
  actual_width = width + border_width*2;
  actual_height = height + border_height*2;
  linear_extrude(height=base_plate_thickness) {
    difference() {
      polygon(points = [[0,0], [actual_width, -actual_width*tan(memory_slope)],
			[actual_width, -actual_width*tan(memory_slope)-actual_height],
			[0,-actual_height]]);
      // Holes for mounting the whole frame
      for(y=[0:1]) {
	translate([10,-border_height-3.5*memory_cell_pitch_y+5-305*y]) circle(d=6);
	translate([width+border_width+10,-border_height-3.5*memory_cell_pitch_y+5-305*y
		   - (width+border_width)*tan(memory_slope)]) circle(d=6);
      }
    }
  }
  translate([border_width, -border_width*tan(memory_slope) - border_height])
  for(x = [0:16]) {
    for(y = [0:15]) {
      color([1.0,0,0]) translate([memory_cell_pitch_x * x,
		 -delta_y * x - memory_cell_pitch_y*y]) linear_extrude(height=6.5+base_plate_thickness) memory_block();
    }
  }

  // Gutter
  translate([border_width,-border_height-memory_cell_pitch_y*16-border_width*tan(memory_slope),0])
  linear_extrude(height=base_plate_thickness+6.5) {
    polygon(points = [[0,0], [width, -width*tan(memory_slope)],
		      [width, -width*tan(memory_slope)-2],
		      [0,-2]]);
  }

  // Support for the column select bars
  for(y=[0:3]) {
    for(x=[0:1]) {
      translate([10+x*memory_cell_pitch_x*18,-40-x*memory_cell_pitch_x*18*tan(memory_slope)-120*y,0]) rotate([0,0,-memory_slope])
	difference() {
	cube([3,10,20]);
	clearance = 0.5;
	translate([-1,0,0])  translate([0,5,base_plate_thickness+6.5+selector_base_thickness+1.5+clearance]) rotate([0,90,0]) cylinder(d=3,h=10,$fn=20);
      }
    }
  }
}

// The column selector bars
for(x = [0:16]) {
  drop = (x==5?-8:0);
  translate([x*memory_cell_pitch_x, - x*memory_cell_pitch_x*tan(memory_slope)+drop, 0])
    union() {
    translate([border_width+4,-column_height,6.5+base_plate_thickness])
      difference() {
      column_width = memory_cell_pitch_x-1;
      color([0.5,0.5,0.5,0.5]) cube([column_width,column_height,selector_base_thickness]);
      // Holes to attach control rods
      translate([column_width/2,column_height-10,-1]) cylinder(d=3,h=5);
      translate([column_width/2,10,-1]) cylinder(d=3,h=5);
    }

    // Deflector plates
    for(y = [0:16]) {
      xpos = border_width;
      translate([xpos,-xpos*tan(memory_slope)-y*memory_cell_pitch_y-20,0]) {
	translate([0,0,base_plate_thickness]) {
	  if(y<16) color([1.0,0,0]) translate([8.5, -8.5*tan(memory_slope),0]) linear_extrude(height=6+selector_base_thickness) horizontal_stop_bar();
	  color([0,1.0,0]) translate([15.5, -15.5*tan(memory_slope)-14+memory_cell_pitch_y,0]) linear_extrude(height=6+selector_base_thickness) vertical_stop_bar();
	}
      }
    }
  }
 }
