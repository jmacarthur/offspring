// A mould for pressing memory cells out of brass strip

include <globs.scad>;
use <memory.scad>;

shim_thickness = 0.4;

// Part 1 - base former

linear_extrude(height=12)
difference() {
  square([25,35]);
  translate([10,30]) memory_block();
  translate([17,9.0]) polygon(points=[[0,0], [10,-2], [10,18], [0,20]]);
  translate([10,29.0]) polygon(points=[[0,0], [17,-3], [17,8], [0,10]]);
}

// Part 2 - top former

linear_extrude(height=12)
offset(-shim_thickness)
union() {
  translate([20,30]) memory_block();
  translate([27,9.0]) polygon(points=[[0,0], [10,-2], [10,18], [0,20]]);
  translate([20,29.0]) polygon(points=[[0,0], [17,-3], [17,8], [0,10]]);
}
