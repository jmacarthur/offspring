include <globs.scad>;
use <generic_conrods.scad>;
use <memory-sender-2.scad>;

kerf = 0.1;

offset(kerf) {
  intake_grid_2d();
  translate([65,0]) for(i=[0:4]) translate([i*30,0]) sender_slope_2d();
  translate([0,55]) sender_input_comb_2d();
  translate([65,35]) for(i=[0:2]) {
    translate([i*70,0]) sender_separator_2d();
    translate([i*70+60,40]) rotate(180) sender_separator_2d();
  }
  translate([5,100]) for(i=[0:4]) translate([i*15,0]) sender_toggle_2d();
  translate([100,100]) for(i=[0:2]) {
    translate([i*40+10,0]) sender_rod_2d();
    translate([i*40,103]) rotate(180) sender_rod_2d();
  }
  translate([0,140]) sender_lower_output_comb_2d();
  translate([210,100]) sender_top_plate_2d();
  translate([50,150]) for(i=[0:1]) translate([0,15*i]) sender_reset_arm_2d();
   
}

translate([-5,-5,-3]) color([0.5,0.5,0.5,0.5]) cube([297,220,3]);
