/* A 16x16 memory cell */
include <globs.scad>;
use <memory.scad>;
$fn =20;
base_plate_thickness = 2;
selector_base_thickness = 2;
cell_thickness = 7; // The spacing between plates for ball bearings to roll through
delta_y  = memory_cell_pitch_x * tan(memory_slope);

cols = 4;
rows = 4;

width = memory_cell_pitch_x * (cols+1);
height = memory_cell_pitch_y * rows;

border_width = 20;
border_height = 20;

column_height = height+30;

// The column selector bars
rotate([0,180,0]) 
for(x = [0:0]) {
  drop = (x==5?-8:0);
  translate([x*memory_cell_pitch_x, - x*memory_cell_pitch_x*tan(memory_slope)+drop, 0])
    union() {
    translate([border_width+4,-column_height,cell_thickness+base_plate_thickness])
      difference() {
      column_width = memory_cell_pitch_x-1;
      color([0.5,0.5,0.5,0.5]) cube([column_width,column_height,selector_base_thickness]);
      // Holes to attach control rods
      translate([column_width/2,column_height-10,-1]) cylinder(d=3,h=5);
      translate([column_width/2,10,-1]) cylinder(d=3,h=5);
    }

    // Deflector plates
    for(y = [0:rows]) {
      xpos = border_width;
      translate([xpos,-xpos*tan(memory_slope)-y*memory_cell_pitch_y-20,0]) {
	translate([0,0,base_plate_thickness]) {
	  if(y<rows) color([1.0,0,0]) translate([8.5, -8.5*tan(memory_slope),0]) linear_extrude(height=6+selector_base_thickness) horizontal_stop_bar();
	  color([0,1.0,0]) translate([15.5, -15.5*tan(memory_slope)-14+memory_cell_pitch_y,0]) linear_extrude(height=6+selector_base_thickness) vertical_stop_bar();
	}
      }
    }
  }
 }
