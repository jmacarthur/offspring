/* This simply extracts the input toggles from the memory file and
   lays out 16 of them for easy laser cutting. */

include <globs.scad>;
use <../subtractor.scad>;

// Sample A3 sheet

//color([0.1,0.1,0.1]) translate([0,0,-5]) square([420,297]);

kerf = 0.1;

offset(delta = kerf, chamfer = true) {


  // Various toggles - the 'top set'. All the toggles are in here,
  // in case we want to make them out of a different colour.

  translate([10,0]) {
    for(i=[0:3]) {
      translate([10+35*i,30]) input_toggle_2d();
      translate([20+35*i,55]) rotate(180) input_toggle_2d();
    }
  }
  translate([10,40]) {
    for(i=[0:3]) {
      translate([10+35*i,30]) input_toggle_2d();
      translate([20+35*i,55]) rotate(180) input_toggle_2d();
    }
  }
}


