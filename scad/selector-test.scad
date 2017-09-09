/* A 3d printed small test of the memory cell selector unit */
include <globs.scad>;
use <memory.scad>;

rotate([0,180,0]) 

union() {
  difference() {
    translate([8,-90,5]) cube([memory_cell_pitch_x - 1, 90,2]);
    translate([16,-5,-1]) cylinder(d=3, h=10, $fn=20);
  }
  for(y = [0:2]) {

    translate([0,-10-memory_cell_pitch_y*y,0]) {
    color([1.0,0,0]) translate([8.5, -8.5*tan(memory_slope)]) linear_extrude(height=7) horizontal_stop_bar();
    color([0,1.0,0]) translate([16.5, -16.5*tan(memory_slope)-12]) linear_extrude(height=7) vertical_stop_bar();
  }
  }
}
