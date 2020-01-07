/* Dropper - meant to catch bearings from the injector and connect to pipes for the subtractor lower down */

include <globs.scad>;
$fn=50;
difference() {
  cube([15,15,10]);
  translate([7.5,7.5,-1]) cylinder(d=pipe_outer_diameter, h=6);
  translate([7.5,7.5,-1]) cylinder(d=pipe_inner_diameter, h=12);
  translate([7.5,7.5,10.1]) scale([1,1,-1]) rotate([0,0,45]) cylinder(d1=20, d2=0, h=7, $fn=4);


}


