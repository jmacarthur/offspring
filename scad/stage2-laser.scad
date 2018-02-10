/* Stage2 Distributor, version 2 - open frame dual slope */

include <globs.scad>;

stage1_output_pitch = 8;
stage2a_output_pitch = 16;
stage2b_output_pitch = pitch;
overall_width = 180;

use <stage2-distributor.scad>;
$fn=20;

kerf = 0.1;

offset(r=kerf) {
  translate([90,0]) stage_plate(stage1_output_pitch, stage2a_output_pitch, 70,overall_width);
  translate([90,80]) stage_plate(stage2a_output_pitch, stage2b_output_pitch, 80,overall_width);
  translate([200,0] ) side_plate();
  translate([250,0] ) side_plate();
  translate([90,170]) front_plate();
  translate([10,12.5]) rotate(90) mounting_plate();
  translate([25,12.5]) rotate(90) mounting_plate();
}

