/* Ball bearing injector, mk 2 - laser layout */

include <globs.scad>;

ball_bearing_diameter = 6.35; // Overrides globs.

$fn = 20;

// Distance between raiser slots
slot_distance = ball_bearing_diameter * 30;

columns = 8;
centre_x = ball_bearing_diameter*16;

internal_width = columns*pitch-6;
eject_offset = 5;

support_positions = [10, (columns-1)*pitch-3];

use <injector.scad>;

kerf = 0.1;

offset(r=kerf)
{
  for(x=[0:1]) {
    translate([45+40*x,10]) injector_tray_support();
  }
  translate([10,80]) input_plate();
  translate([10,115]) separator_plate();
  translate([10,145]) front_plate();
  translate([10,180]) returner_plate();
  translate([10,240]) injector_tray();
  for(x=[0:columns-1]) {
    translate([x*20+10,50]) injector_crank();
  }
  translate([20,310]) end_plate();
  translate([100,310]) end_plate();
  translate([170,10]) mounting_plate();
  translate([160,55]) mounting_plate();
  translate([10,395]) waste_plate();

}
