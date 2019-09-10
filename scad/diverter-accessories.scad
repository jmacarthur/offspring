// Laser layout for Diverter v2

include <globs.scad>;
use <planar-diverter.scad>;

$fn=20;

kerf=0.08;

offset(r=kerf) {

  regen_clip_2d();
  translate([30,0]) regen_clip_2d();
  translate([120,-10]) pipe_mounting_plate_2d();
  translate([10,60]) base_plate_2d();

  for(i=[0:7]) {
    translate([50+15*i,35]) regen_output_2d();
  }


  translate([0,400])  regen_support_2d();
  translate([100,400])   regen_riser_2d();
  translate([200,400]) regen_riser_2d();

}
