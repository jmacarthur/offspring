include <globs.scad>;
$fn=50;

module pulley_holder_2d() {
  hole_pos = [[0,0], [0,-30], [50,50], [-50,50]];
  difference() {
    union() {

      hull() {
	for(i=hole_pos) {
	  translate(i) circle(d=15);
	}
	rotate(-45) translate([-7.5,0]) square([15,sqrt(50*50*2)]);
	rotate(45) translate([-7.5,0]) square([15,sqrt(50*50*2)]);
      }
    }
    for(i=hole_pos) {
      translate(i) circle(d=3.1);
    }
    n=80;
    translate([-n,-30]) circle(r=n-7.5);
    translate([n,-30]) circle(r=n-7.5);
  }
}

module pulley_holder() {
  linear_extrude(height=5) pulley_holder_2d();
}

module injector_clip() {
  difference() {
    cube([13,10,10]);
    translate([4,-1,3]) cube([5.2,12,12]);
  }
}


//injector_clip();

pulley_holder();
