include <globs.scad>;

use <diverter.scad>;
use <interconnect.scad>;
use <generic_conrods.scad>;

// Example A3 sheet
//translate([0,0,-10]) color([0.1,0.1,0.1]) cube([420,297,1]);
//translate([0,0,-9 ]) color([0.1,0.5,0.1]) cube([297,210,1]);
kerf = 0.1;
offset(kerf) {
  translate([5,5]) input_plate();
  translate([5,30]) input_plate();
  translate([45,70]) rotating_bar_support();
  translate([100,70]) rotating_bar_support();
  translate([5,100]) diverter_plate();
  translate([5,130]) side_wall();
  translate([265,20]) end_wall();
  translate([245,50]) rotate(180) end_wall();
  for(i=[0:16]) {
    translate([190, 10+i*10]) separator_plate();
  }

  translate([120,55]) bowden_cable_stator();
  translate([180,55]) stator_clamp();
  translate([5,175]) cable_connector_2d();
  translate([45,185]) conrod(35);
}
