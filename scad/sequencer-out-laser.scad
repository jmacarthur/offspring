include <globs.scad>;
include <sequencer_globs.scad>;
include <interconnect.scad>;
use <sequencer-output.scad>;

kerf = 0.08;

offset(r=kerf) {

  for(i=[0:8]) {
    translate([i*30,0]) horizontal_rod_2d();
    translate([i*30+15,-170]) rotate([180]) horizontal_rod_2d();
  }

  translate([20,30]) base_comb_2d();

  translate([0,140]) base_comb_support_2d();
  translate([50,140]) base_comb_support_2d();
  translate([0,230]) base_comb_support_side_2d();
  translate([50,230]) base_comb_support_side_2d();

  translate([0,260]) input_bar_2d();
  for(i=[0:19]) {
    translate([i*30,290]) input_support_2d();
  }

  translate([0,330]) base_bar_2d();
  translate([0,370]) top_bar_2d();
  translate([0,400]) front_plate_2d();

}
