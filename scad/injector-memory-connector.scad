// Very simple part to connect the injector to the memory.
// In later versions, see if we can roll this into the injector.

include <globs.scad>;

rib_offset = 5;

module rib_2d() {
  union() {
    square([9,9]);
    translate([3,0]) square([6,9+11+6]);
    translate([3,9]) square([10,11+6]);
    translate([3,9]) square([13,10]);
  }
}

module connecting_plate_2d() {
  difference() {
    translate([-rib_offset, 0]) square([8*pitch, 20]);
      for(i=[0:7]) {
	translate([i*pitch, 5]) {
	  square([3,10]);
	}
	translate([i*pitch+10, 5]) {
	  square([3,10]);
	}
      }
  }
}


for(i=[0:7]) {
  translate([0, 0, i*pitch]) {
    translate([0,0,-1.5]) linear_extrude(height=3) rib_2d();
    translate([0,0,1.5+7]) linear_extrude(height=3) rib_2d();
  }
}

 translate([16,4,-1.5]) color([1,0,0])  rotate([0,-90,0]) linear_extrude(height=3) connecting_plate_2d();
