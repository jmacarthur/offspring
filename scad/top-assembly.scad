/* Top Assembly

   This includes the distributor, diverter and injector - all the
   parts of the machine above the memory. This is a perspex box which
   contains all the parts and holds them together on top of the memory
   case.

*/

include <globs.scad>;
use <interconnect.scad>;

use <diverter-v2.scad>;
use <stage2-distributor.scad>;
use <octo-distributor-3.scad>;
use <injector.scad>;

translate([0,2,200]) {
  translate([pitch*4,0,0])
  // Octo injector translated so the centre line is on x=0
  translate([-4-ball_bearing_diameter*4+3,0,0]) 3d_injector_assembly();
}
translate([pitch*4+3,0,170]) rotate([0,0,180]) 3d_stage2_assembly();
translate([0,-2,60]) injector_assembly();


$fn= 20;


// Backplane - the main attachment point for all parts

module backplane_2d() {
  difference() {
    translate([-10,0]) square([210,297]);

    // Cutout for octo distributor
    translate([65,195]) square([100,40]);
    translate([65,195]) square([60,90]);
    translate([65,290]) square([60,10]);

    // Holes for octo distributor
    for(y=[0, -12*3]) {
      for(x=[0, 12*7]) {
	translate([54+x,291+y]) circle(d=4, $fn=20);
      }
    }

    // Mounting holes for stage2 distributor
    for(x=[0,3*12,12*13,12*16]) {
      translate([x,160]) circle(d=4);
    }

    // Cutout for injector
    translate([-3,125]) square([3,5]);
    translate([178,125]) square([3,5]);
    translate([-3,10]) square([3,110]);
    translate([178,10]) square([3,110]);
    translate([0,30]) square([181,85]);
  }
}

// Side plates

module sideplate_2d() {
  difference() {
    square([50,297]);
    // Cutout for mounting stage2 distributor
    translate([41,155]) square([3,10]);
  }
}

color([0.5,0.5,0.5,0.5]) translate([0,4,0]) rotate([90,0,0]) linear_extrude(height=3) { backplane_2d(); }
for(x=[-6,185]) {
  color([0.5,0.5,0.5,0.5]) translate([x,-50+1,0]) rotate([0,0,90]) rotate([90,0,0]) linear_extrude(height=3) { sideplate_2d(); }
 }

