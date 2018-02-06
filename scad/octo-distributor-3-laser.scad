/* Ball bearing injector, mk 5. This is meant for 8 ball bearings at a
   time, and may be extended to 32 if successful.
   This version is meant for a laser cutter. */

include <globs.scad>;
use <octo-distributor-3.scad>;


// Pitch of ball bearings after passing through each stage:
stage1_output_pitch = 8;
stage1_output_length = 8*stage1_output_pitch;

$fn=20;
channel_length = 8*ball_bearing_diameter;
channel_radius = (ball_bearing_diameter+1)/2;

explode = 50;

ramp_angle = 5;

axis_height = 80;

top_wall_mounting_holes = [10, channel_length-10];
injector_mounting_holes_x = [10, 70, 90];

peg_mounting_y_offset = -5;

// Constants necessary for the stage1 distributor
plate_thickness = 5;
// Mouting positions(y) for the stage1 distributor
mounting_position_y1 = floor(stage1_output_length/2+5);
mounting_position_y2 = floor(channel_length/2+5);

rotator_axis_distance = 10;  // Distance between centres - swing axle to channel axis

mounting_hole_positions = [ [-14, mounting_position_y1],
			    [-14, -mounting_position_y1],
			    [-35, mounting_position_y2],
			    [-35, -mounting_position_y2] ];


kerf=0.1;

offset(r=kerf) {
  input_chamber_base();
  translate([0,0]) input_ramp_top();
  translate([105,0]) injector_end_wall();
  translate([130,0]) injector_input_wall();
  translate([180,-10]) swing_arm();
  translate([175,90]) rotate(180) swing_arm();
  translate([155,85]) top_wall();
  translate([50,40]) side_wall();
  translate([50,70]) side_wall();
  translate([-60,20]) ramp_wall();
  translate([-60,60]) ramp_wall();
  translate([220,0]) rotate(90) mid_mounting_plate();
  translate([245,0]) rotate(90) top_mounting_plate();
  translate([0,100]) external_feed_pipe();
  translate([140,110]) rotate(90) external_feed_wall();
  translate([220,110]) rotate(90) external_feed_wall();
  translate([290,50]) rotate(90) stage1_mounting_plate();
}

// A4 plate for reference
translate([-5,-5,-5]) color([0.5,0.5,0.5,0.5]) cube([297,210,3]);
