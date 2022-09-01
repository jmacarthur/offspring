include <sequencer_globs.scad>;
use <sequencer.scad>;

module dropped_cam_mounting_holes() {
  for(i=[0:3]) {
    rotate(i*360/4) {
      for(side=[0,1]) {
	hull() {
	  rotate((360/16)-(side*360/8)) translate([0, bolt_circle_diameter/2]) circle(d=8);
	  translate([0,-20]) rotate((360/16)-(side*360/8)) translate([0, bolt_circle_diameter/2]) circle(d=8);
	}
      }
    }
  }
}
$fn = 100;
module cam_ring_segment_2d() {
  difference() {
    intersection() {
      circle(d=cam_top_diameter);
      rotate(45) square([cam_top_diameter,cam_top_diameter]);
    }
    circle(d=cam_lower_diameter);
    dropped_cam_mounting_holes();
  }
}

cam_ring_segment_2d();
