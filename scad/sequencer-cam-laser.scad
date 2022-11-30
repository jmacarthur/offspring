include <sequencer_globs.scad>;
use <sequencer.scad>;

trim = 0.6;

module dropped_cam_mounting_holes(trim) {
  for(i=[0:3]) {
    rotate(i*360/4) {
      for(side=[0,1]) {
	  rotate((360/16)-(side*360/8)) translate([0, bolt_circle_diameter/2]) {
	    union() {
	      circle(d=8);
	      rotate(360/16-((1-side)*360/8)) translate([-4+trim/2,-10]) square([8-trim,10]);
	    }
	  }
      }
    }
  }
}

$fn = 100;
module cam_ring_segment_2d(trim) {
  difference() {
    intersection() {
      circle(d=cam_top_diameter);
      rotate(45) square([cam_top_diameter,cam_top_diameter]);
    }
    circle(d=cam_lower_diameter);
    dropped_cam_mounting_holes(trim);
  }
}

kerf = 0.1;

offset(r=kerf) { 
  for(i=[1:4])
    translate([0,i*40]) cam_ring_segment_2d(trim);
}


