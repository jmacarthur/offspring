// A device which sits at the end of the diverter, on top of the subtractor (PC) and catches overrunning ball bearings into pipes.

include <globs.scad>;
$fn=50;

module side_clip_2d() {
  difference() {

    union () {
      hull() {
	translate([20,0]) circle(d=3);
	translate([10,10]) circle(d=3);
	translate([36,0]) circle(d=3);
	translate([36,15]) circle(d=3);
	translate([15,25]) circle(d=3);
      }
      hull() {
	translate([10,10]) circle(d=3);
	translate([17,10]) circle(d=3);
	translate([10,30]) circle(d=10);
      }
    }
    translate([25,-5]) square([3,15]);
    translate([35,-5]) square([3,15]);

    translate([10,30]) circle(d=3);
  }
}

module mid_section() {
  
  difference() {
    union() {
      translate([3,3,10]) cube([199, 14,10]);
      for(i=[1:8]) {
	translate([pitch*i-3,10,0]) cylinder(d=14,h=11);
      }
    }

    // First exit
    for(i=[1:8]) {
      translate([pitch*i-3,3+7,0]) {
	hull() {
	  translate([0,0,20]) cube([pitch-3,8,1], center=true);
	  translate([0,0,10]) cylinder(d=8, h=0.1);
	}
	translate([0,0,-1]) cylinder(d=8, h=12);
	translate([0,0,-1]) cylinder(d=10.5, h=10);
      }
    }

    // Mounting holes - side
    translate([2,10,15]) rotate([0,90,0]) cylinder(d=3,h=8);
    translate([195,10,15]) rotate([0,90,0]) cylinder(d=3,h=8);

    // Mounting holes - front
    for(i=[2,6]) {
      translate([pitch*i-3+pitch/2,2,15]) {
	rotate([-90,0,0]) cylinder(d=3,h=8);
      }
    }

  }


}

module end_clip() {
  translate([0,0,15]) mid_section();

  for(x=[0]) {
    translate([x,0,0]) color([1,0,0]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) side_clip_2d();
  }
}


end_clip();
