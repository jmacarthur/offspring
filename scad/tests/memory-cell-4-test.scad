/* A 16x16 memory cell */
include <globs.scad>;
use <memory.scad>;

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

column_height = height+50;

union() {
  // Base plate
  actual_width = width + border_width*2-10;
  actual_height = height + border_height*2-28;
  linear_extrude(height=base_plate_thickness) {
    difference() {
      translate([0,-10]) polygon(points = [[0,0], [actual_width, -actual_width*tan(memory_slope)],
			[actual_width, -actual_width*tan(memory_slope)-actual_height],
			[0,-actual_height]]);
      // Holes for mounting the whole frame
      for(y=[0:1]) {
	translate([10,-border_height-3.5*memory_cell_pitch_y+5-305*y]) circle(d=6);
	translate([width+border_width+10,-border_height-3.5*memory_cell_pitch_y+5-305*y
		   - (width+border_width)*tan(memory_slope)]) circle(d=6);
      }

      // Cut-offs for ease of printing
      translate([0,-150]) square([20,50]);
      translate([0,-90]) square([20,50]);
      translate([0,-30]) square([20,50]);
      translate([-1,-150]) square([11,200]);
      translate([100,-170]) square([20,50]);
      translate([100,-110]) square([20,50]);
      translate([100,-50]) square([20,50]);
   }
  }
  translate([border_width, -border_width*tan(memory_slope) - border_height])
  for(x = [0:cols]) {
    for(y = [0:rows-1]) {
      color([1.0,0,0]) translate([memory_cell_pitch_x * x,
				  -delta_y * x - memory_cell_pitch_y*y,0]) union() {
	linear_extrude(height=cell_thickness+base_plate_thickness) memory_block();
	// Bumps to help align the column bars
	translate([3,-10]) cube([1,1,cell_thickness+base_plate_thickness+1]) ;
      }
    }
  }

  // Gutter
  translate([border_width,-border_height-memory_cell_pitch_y*rows-border_width*tan(memory_slope),0])
  linear_extrude(height=base_plate_thickness+cell_thickness-0.5) {
    polygon(points = [[0,0], [width, -width*tan(memory_slope)],
		      [width, -width*tan(memory_slope)-2],
		      [0,-2]]);
  }

  // Support for the column select bars
  for(y=[0,0.5]) {       // Modified for the 4-cell case: move selector supports up a bit
    for(x=[0:1]) {
      translate([10+x*memory_cell_pitch_x*(cols+2),-40-x*memory_cell_pitch_x*(cols+2)*tan(memory_slope)-120*y,0]) rotate([0,0,-memory_slope])
	difference() {
	cube([3,8,17]);
	clearance = 0.5;
	translate([-1,0,0])  translate([0,5,base_plate_thickness+cell_thickness+selector_base_thickness+1.5+clearance]) rotate([0,90,0]) cylinder(d=3,h=10,$fn=20);
      }
    }
  }
}
