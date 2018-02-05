/* Ball bearing injector, mk 5. This is meant for 8 ball bearings at a
   time, and may be extended to 32 if successful.
   This version is meant for a laser cutter. */

include <globs.scad>;

// Pitch of ball bearings after passing through each stage:
stage1_output_pitch = 8;
stage1_output_length = 8*stage1_output_pitch;

$fn=20;
channel_length = 8*ball_bearing_diameter;
channel_radius = (ball_bearing_diameter+1)/2;

explode = 50;

ramp_angle = 5;

module input_chamber_base() {
  difference() {
    square([60,10]);
  }
}

module injector_end_wall() {
  difference() {
    square([20,100]);
    translate([10,5]) square([3,10]);
    translate([10+1.5,18]) circle(d=2.5);// Adjustment screw hole
    translate([10+1.5,80]) circle(d=3); // Swing axis hole
  }
}

module injector_input_wall() {
  difference() {
    square([20,100]);
    translate([10,5]) square([3,15]); // Hole for input chamber base, extended up
    hull() {
      translate([10+1.5,10+5+channel_radius]) circle(r=channel_radius); // Input hole
      translate([10+1.5,20+channel_radius]) circle(r=channel_radius); // Input hole
    }
    translate([10+1.5,80]) circle(d=3); // Swing axis hole
  }
}

module 3d_injector_assembly() {
  rotate([90,0,0]) linear_extrude(height=3) input_chamber_base();
  translate([0,-13,-5]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) injector_end_wall();
  translate([60-3,-13,-5]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) injector_input_wall();
}

3d_injector_assembly();
