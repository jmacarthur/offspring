/* Ball bearing injector, mk 3. This is meant for 8 ball bearings at a
   time, and may be extended to 32 if successful. It is also meant
   for production with a 3D printer rather than laser cutter. */

include <globs.scad>;

// Pitch of ball bearings after passing through each stage:
stage1_output_pitch = 8;
$fn=20;
channel_length = 8*ball_bearing_diameter;
channel_radius = (ball_bearing_diameter+1)/2;

ejecting = 1;

channel_rotation = (ejecting==1? -45: 45);

module rotating_input_channel() {
  difference() {
    union() {
      cylinder(d=8, h=3);
      translate([0,0,channel_length-3]) cylinder(d=8,h=3);
      translate([0,0,channel_length/2]) cylinder(d=8,h=3);
      difference() {
	cube([10,12,channel_length]);
	translate([7,7,-1]) cylinder(r=channel_radius,h=channel_length+10);
	translate([7,7-channel_radius,-1]) cube([10,2*channel_radius, channel_length+10]);
      }
    }
    translate([0,0,-1]) cylinder(d=3, h=110);
  }
}

module input_plate() {
  difference() {
    cylinder(d=30,h=3);
    translate([0,0,-1]) cylinder(d=3,h=5);
    rotate([0,0,45]) translate([7,7,-1]) cylinder(r=channel_radius,h=5);
  }
}

module end_stop() {
  difference() {
    cylinder(d=30,h=3);
    translate([0,0,-1]) cylinder(d=3,h=5);
  }
}

module input_assembly() {
  rotate([90,0,0]) {
    rotate([0,0,channel_rotation]) rotating_input_channel();
    translate([0,0,channel_length]) end_stop();
    translate([0,0,-3]) input_plate();
  }
}

input_assembly();
