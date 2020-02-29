/* Dropper - meant to catch bearings from the injector and connect to pipes for the subtractor lower down */

include <globs.scad>;
$fn=50;
width=23;
join=0.1;

union(){
  for(i=[0:3]) {
    translate([i*width,0,0]) 
    difference() {
      cube([width+join,15,10]);
      translate([width/2,7.5,-1]) cylinder(d=pipe_outer_diameter, h=6);
      translate([width/2,7.5,4.9]) cylinder(d1=pipe_outer_diameter, d2=pipe_inner_diameter, h=2);
      translate([width/2,7.5,10.1]) scale([width/15,1,-1]) rotate([0,0,45]) cylinder(d1=20, d2=0, h=7, $fn=4);
}

  }
}
