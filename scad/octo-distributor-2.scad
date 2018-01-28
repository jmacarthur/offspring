/* Ball bearing injector, mk 4. This is meant for 8 ball bearings at a
   time, and may be extended to 32 if successful. It is also meant
   for production with a 3D printer rather than laser cutter. */

include <globs.scad>;

// Pitch of ball bearings after passing through each stage:
stage1_output_pitch = 8;
stage1_output_length = 8*stage1_output_pitch;

$fn=20;
channel_length = 8*ball_bearing_diameter;
channel_radius = (ball_bearing_diameter+1)/2;

ejecting = 1;
thin = 1;
//channel_rotation = (ejecting==1? -45: 45);
channel_rotation = 135;

module rotating_input_channel() {
  difference() {
    union() {
      for(z = [0, channel_length-3, channel_length/2]) {
	translate([0,0,z]) cylinder(d=8,h=3);
	// End stops to stop the channel rotating too far
	translate([0,-2.5,z]) cube([10,3,3]);
      }
      // The actual channel
      difference() {
	cube([10,12,channel_length+3]);
	translate([7,7,-thin]) cylinder(r=channel_radius,h=channel_length+thin);
	translate([7,7-channel_radius,-thin]) cube([10,2*channel_radius, channel_length+thin]);
      }
      // Blanking plate to stop more data entering
      difference() {
	cylinder(d=23,h=3);
	translate([0,0,-thin]) cube([12,40,3+thin*2]);
	translate([10,-20,-thin]) cube([12,40,3+thin*2]);
      }


      // Control lever
      translate([5,12,0]) cube([5,10,3]);
      translate([7.5,22,0]) cylinder(d=6,h=3);

    }
    translate([0,0,-1]) cylinder(d=3, h=110);
    // Hole in control lever
    translate([7.5,22,-1]) cylinder(d=3,h=5);
  }
}

module input_chute() {
  difference() {
    // Big block
    union() {
      translate([0,0,-5]) cube([30,80,20]);
      translate([13,0,7]) rotate([10,0,0]) translate([0,3,0]) rotate([270,0,0]) cylinder(r=channel_radius+4, h=80);
    }

    // Input channel
    translate([13,0,7]) rotate([10,0,0]) translate([0,-5,0]) rotate([270,0,0]) cylinder(r=channel_radius, h=100);

    // Axle hole for rotating part
    translate([20,-thin,0]) rotate([270,0,0]) cylinder(d=3, h=100);
  }
}


module stage1_assembly() {
  rotate([0,-90+channel_rotation,0]) rotate([90,0,0]) rotating_input_channel();
  translate([-20,0,0]) input_chute();
}


stage1_assembly();

