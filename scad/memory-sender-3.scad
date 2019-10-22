include <globs.scad>;
use <generic_conrods.scad>;
memory_rod_spacing = 10;
memory_travel = 14;
$fn=20;
clearance = 0.1;
bump = 1;
module sender_centre_plate_2d()
{
  union() {
    difference() {
      square([50,60]);
      for(i=[0:4]) {
	offset(clearance) {
	  translate([25,memory_rod_spacing*i+10]) {
	    hull() {
	      circle(d=ball_bearing_diameter);
	      // Add a small drop to keep the bearing in place.
	      translate([bump,0]) circle(d=ball_bearing_diameter);
	    }
	    translate([-30,-1.5]) square([40,3]);
	  }
	}
      }
    }
    for(i=[0:5]) {
      translate([-4,memory_rod_spacing*i+5-1.5]) {
	square([10,3]);
      }
    }
  }
}

module front_plate_2d() {
  union() {
    difference() {
      square([50,60]);
      for(i=[0:4]) {
	translate([25,memory_rod_spacing*i+10]) {
	  circle(d=pipe_outer_diameter);
	}
      }
    }
    translate([-4,10]) square([5,10]);
    translate([-4,40]) square([5,10]);
  }
}

module ejector_plate_2d() {
  union() {
    difference() {
      translate([10,0]) square([30,60]);
      offset(clearance) {
	for(i=[0:4]) {
	  translate([30+bump,memory_rod_spacing*i+10]) {
	    circle(d=ball_bearing_diameter);
	  }
	}
	translate([30+bump, 10-ball_bearing_radius]) square([20,memory_rod_spacing*4+ball_bearing_diameter]);
      }
    }
    translate([-20,10]) square([35,10]);
    translate([-20,40]) square([35,10]);
 }
}


module top_plate_2d() {
  difference() {
    square([70,60]);
    offset(clearance) {
      for(i=[0:4]) {
	translate([30+1.5,memory_rod_spacing*i+10]) {
	  circle(d=3);
	}
      }
    }
    for(i=[0:5]) {
      translate([30,memory_rod_spacing*i+5-1.5]) {
	square([3,3]);
      }
    }
    translate([30-20,memory_rod_spacing*2.5]) circle(d=4);
    translate([30+20,memory_rod_spacing*2.5]) circle(d=4);

    offset(clearance) {
      translate([35,10]) square([3,10]);
      translate([35,40]) square([3,10]);
    }
    translate([25,10]) square([3,10]);
    translate([25,40]) square([3,10]);
  }
}

color([0.5,0.5,0.5]) rotate([0,90,0]) linear_extrude(height=3) sender_centre_plate_2d();
color([0.8,0.5,0.5]) translate([-5,0,0]) rotate([0,90,0]) linear_extrude(height=3) front_plate_2d();
translate([5,0,0]) rotate([0,90,0]) linear_extrude(height=3) ejector_plate_2d();


translate([-30,0,0]) linear_extrude(height=3) top_plate_2d();
