include <globs.scad>;
use <memory-sender-3.scad>;

memory_rod_spacing = 10;
memory_travel = 14;
$fn=20;
clearance = 0.1;
bump = 1;
kerf=0.08;


offset(kerf) {
  sender_centre_plate_2d();
  translate([50,0]) front_plate_2d();
  translate([110,0]) ejector_plate_2d();

  translate([10,50]) rotate(30) top_plate_2d();
  translate([60,60]) rotate(25) mid_plate_2d();
  translate([90,70]) lower_layer_2d();

  translate([200,50]) mounting_plate_2d();
}
