/* Generic regenerator unit for use above and below subtractor */

include <globs.scad>;

/* Actuator arm - the bit pushed by the ball bearing, if any, which then pulls down the cable
   to inject more ball bearings. */

module actuator_arm_2d() {
  difference() {
    union() {
      translate([-5,-5]) square([50,10]);
      translate([-5,-5]) square([10,35]);
      translate([-25,25]) polygon([[1,5], [10,5], [10,5], [10,0], [30,-10], [30,10], [10,20], [0,10]]);
    }
    circle(d=3);
    translate([25,0]) circle(d=3);
    translate([35,0]) circle(d=3);
  }
}

module regen_pusher_2d(extra_clearance) {
  width = 172;
  difference() {
    polygon([[0,0], [width,0], [width,10], [width-20,20], [20,20], [0,10], [0,20]]);
    for(c=[0:7]) {
      translate([ejector_xpos(c)-20,0]) circle(d=channel_width+extra_clearance);
    }
    for(x=pusher_support_x) {
      translate([x, 10]) square([3,20]);
    }
    translate([ejector_xpos(3)+pitch/2-20,10]) circle(d=3);
  }
}

module regen_swing_arm_2d() {
  difference() {
    union() {
      translate([0,-7.5]) square([80,15]);
      circle(d=15);
    }
    translate([70,-8.5]) square([6,4]);
    translate([30,-8.5]) square([6,4]);// Cutout for rubber band
    circle(d=3);
  }
}

module regen_rib_2d()
{
  union() {
    polygon([[0,0], [0,7], [15,7], [35,13], [35,4], [45,4], [50,7], [60,7], [60,0]]);
    // Connecting tabs
    translate([0,-3]) square([10,13]);
    translate([50,-3]) square([10,13]);
  }
}

module regen_output_comb_2d() {
  clearance = 0.1;
  width = 190 -3;
  difference() {
    union() {
      translate([13,0]) square([width,30]);
      translate([10,20]) square([width+6,10]);
    }
    for(c=[0:7]) {
      translate([ejector_xpos(c)-1.5-clearance, -1]) square([3+clearance*2,22]);
    }
  }
}
