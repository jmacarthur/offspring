// All internal parts of the subtractor

include <globs.scad>;
use <subtractor.scad>;
kerf = 0.1;

offset(delta = kerf, chamfer = true) {
  
  translate([10,0]) {
    for(i=[0:3]) {
      translate([10+35*i,5]) input_toggle_2d();
      translate([20+35*i,30]) rotate(180) input_toggle_2d();
    }
  }
  translate([10,40]) {
    for(i=[0:3]) {
      translate([20*i,5]) reset_toggle_2d(); 
      translate([10+20*i,27]) rotate(180) reset_toggle_2d();
    }
  }
  translate([90,40]) {
    for(i=[0:3]) {
      translate([15*i,5]) output_toggle_2d();
      translate([7.5+15*i,35]) rotate(180) output_toggle_2d();
    }
  }
}

