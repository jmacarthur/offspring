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
translate([pitch*4+3,0,160]) rotate([0,0,180]) 3d_stage2_assembly();
translate([0,-2,53]) injector_assembly();


$fn= 20;

tab_heights = [135,250];
sidewall_x = [-6,185];
crossbar_height = [240];
crossbar_tab_x = [10,160];

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
      translate([x,150]) circle(d=4);
    }

    // Cutout for injector
    translate([-3,118]) square([3,5]);
    translate([178,118]) square([3,5]);
    translate([-3,10]) square([3,103]);
    translate([178,10]) square([3,103]);
    translate([0,23]) square([181,85]);

    // Tab holes for side plate
    for(x=sidewall_x) {
      for(y=tab_heights) {
	translate([x,y]) square([3,20]);
      }
    }

    // Tab holes for crossbars
    for(y=crossbar_height) {
      for(x=crossbar_tab_x) {
	translate([x,y]) square([20,3]);
      }
    }
  }
}

// Side plates

module sideplate_2d() {
  difference() {
    union() {
      square([50,297]);
      // Connecting tabs
      for(y=tab_heights) {
	translate([47,y]) square([6,20]);
      }
    }
    // Cutout for mounting stage2 distributor
    translate([41,145]) square([3,10]);

    // Cutout for crossbars
    for(y=concat(crossbar_height,[0])) {
      translate([20,y]) square([20,3]);
    }

    // Cutout for ball bearing supply hole
    translate([40,222]) circle(d=12);

    // Cutout for the injector axle
    translate([17,78]) circle(d=5);
  }
}


module crossbar_2d() {
  width = sidewall_x[1]-sidewall_x[0]-3;
  union() {
    polygon(points=[[0,0], [width,0], [width,51], [crossbar_tab_x[0]+3+20, 51], [width/2-25,25], [width/2+25, 25], [crossbar_tab_x[1]+3, 51], [0,51]]);
    translate([-3,20]) square([width+6,20]);
    for(x=crossbar_tab_x) {
      translate([x+3,0]) square([20,50+6]);
    }
  }
}

module baseplate_2d() {
  width = sidewall_x[1]-sidewall_x[0]-3;
  difference() {
    union() {
      square([width, 51]);
      translate([-6,20]) square([width+12,20]);
      translate([-6,0]) square([3,51]);
      translate([width+3,0]) square([3,51]);
    }
    for(x=[0:7]) {
      translate([x*pitch+8, 50-ball_bearing_radius]) circle(d=ball_bearing_diameter*1.20);
    }

    // Mounting holes
    for(x=[20,160]) {
      translate([x,25]) circle(d=6);
    }
  }
}

color([0.5,0.5,0.5,0.5]) translate([0,4,0]) rotate([90,0,0]) linear_extrude(height=3) { backplane_2d(); }
for(x=sidewall_x) {
  color([0.5,0.5,0.8,0.5]) translate([x,-50+1,0]) rotate([0,0,90]) rotate([90,0,0]) linear_extrude(height=3) { sideplate_2d(); }
}
for(z=crossbar_height) {
  color([0.8,0.5,0.5,0.5]) translate([sidewall_x[0]+3,-50,z]) linear_extrude(height=3) crossbar_2d();
}

color([0.8,0.5,0.5,0.5]) translate([sidewall_x[0]+3,-50,0]) linear_extrude(height=3) baseplate_2d();
