/* Ball bearing injector, mk 3. This is meant for 8 ball bearings at a
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

//channel_rotation = (ejecting==1? -45: 45);
channel_rotation = 45-80*$t;

module rotating_input_channel() {
  difference() {
    union() {
      for(z = [0, channel_length-3, channel_length/2]) {
	translate([0,0,z]) cylinder(d=8,h=3);
	// End stops to stop the channel rotating too far
	translate([0,-2.5,z]) cube([10,3,3]);
      }
      difference() {
	cube([10,12,channel_length]);
	translate([7,7,-1]) cylinder(r=channel_radius,h=channel_length+10);
	translate([7,7-channel_radius,-1]) cube([10,2*channel_radius, channel_length+10]);
      }
      // Blanking plate to stop more data entering
      translate([-7.8,5,0]) cube([10,7,3]);

      // Control lever
      translate([5,12,0]) cube([5,10,3]);
      translate([7.5,22,0]) cylinder(d=6,h=3);

    }
    translate([0,0,-1]) cylinder(d=3, h=110);
    // Hole in control lever
    translate([7.5,22,-1]) cylinder(d=3,h=5);
  }
}

module part_circle() {
  difference() {
    cylinder(d=33,h=3,$fn=50);
    // Centre axle hole
    translate([0,0,-1]) cylinder(d=3,h=5);
    // Cut off the bottom of the circle
    rotate([0,0,-20]) translate([-50,-20,-1]) cube([100,15,11]);
  }
}

module buttress() {
  translate([0,-5,5]) linear_extrude(height=3) polygon(points=[[0,0], [10,0], [0,19]]);
}

module input_plate() {
  difference() {
    union () {
      part_circle();
      rotate([0,0,-20]) translate([5,-5,-7]) cube([11,3,10]);
      translate([0,0,0]) rotate([20,90,0]) buttress();
    }
    // Input hole
    rotate([0,0,45]) {
      translate([7,7,-10]) cylinder(r=channel_radius,h=15);
      translate([7,7-channel_radius,-10]) cube([2,channel_radius*2,15]);
      translate([9,7,-10]) cylinder(r=channel_radius,h=15);
    }

    translate([15,3,-4]) rotate([90,0,-20]) cylinder(d=3,h=15);
  }
}

module end_stop() {
  difference() {
    union() {
      part_circle();
      rotate([0,0,-20]) translate([-16,-5,0]) cube([11,3,11]);
      translate([0,0,3]) rotate([-20,-90,0]) buttress();
    }
    translate([-12,3,7]) rotate([90,0,-20]) cylinder(d=3,h=10);
  }
}

module input_fixed_assembly() {
  translate([0,channel_length/2,0])
  rotate([90,0,0]) {
    translate([0,0,channel_length+0.5]) end_stop();
    translate([0,0,-3.5]) input_plate();
  }
}

module input_rotating_assembly() {
  translate([0,channel_length/2,0])
  rotate([90,0,0]) {
    rotate([0,0,channel_rotation]) rotating_input_channel();
  }
}


plate_thickness = 5;
mounting_position_y1 = floor(stage1_output_length/2+5);
mounting_position_y2 = floor(channel_length/2+5);

module mounting_holes() {
  // Mounting holes
  translate([-14, mounting_position_y1, -1]) cylinder(d=3,h=plate_thickness+2);
  translate([-14, -mounting_position_y1, -1]) cylinder(d=3,h=plate_thickness+2);
  translate([-35, mounting_position_y2, -1]) cylinder(d=3,h=plate_thickness+2);
  translate([-35, -mounting_position_y2, -1]) cylinder(d=3,h=plate_thickness+2);
}

// Top plate mounting distance can be adjusted for a good fit.
module top_plate() {
  difference() {
    union () {
      translate([-45,-channel_length/2,0]) cube([35,channel_length, 3]);
      translate([-40,-stage1_output_length/2-4,0]) cube([30,stage1_output_length+8, 3]);
      translate([-18,-stage1_output_length/2-8,0]) cube([8,stage1_output_length+16, 3]);
    }
    mounting_holes();
  }
}

module stage1_distributor() {
  difference() {
    union() {
      // Joiner, which connects the distributor to the input wheels
      translate([-50,-channel_length/2-3,0]) cube([5, channel_length+6, plate_thickness]);
      translate([-50,-channel_length/2,0]) cube([30, channel_length, plate_thickness]);
      translate([-38,-stage1_output_length/2,0]) cube([28,stage1_output_length, plate_thickness]);
      translate([-18,-stage1_output_length/2-8,0]) cube([8,stage1_output_length+16, plate_thickness]);
      translate([-35, -mounting_position_y2, 0]) cylinder(d=8,h=plate_thickness);
      translate([-35, mounting_position_y2, 0]) cylinder(d=8,h=plate_thickness);

    }
    mounting_holes();
    for(i=[0:7]) {
      input_y = ball_bearing_diameter*i-7*ball_bearing_diameter/2;
      output_y = stage1_output_pitch*i-7*stage1_output_pitch/2;
      translate([-51,input_y,plate_thickness]) rotate([0,90,0]) cylinder(d=ball_bearing_diameter, h=21);
      translate([-30,input_y,plate_thickness]) rotate([0,90,0]) sphere(d=ball_bearing_diameter);
      translate([-20,output_y,plate_thickness]) rotate([0,90,0]) cylinder(d=ball_bearing_diameter, h=21);
      translate([-20,output_y,plate_thickness]) rotate([0,90,0]) sphere(d=ball_bearing_diameter);
      pipe_dx = 10;
      pipe_dy = output_y-input_y;
      pipe_length = sqrt(pipe_dx*pipe_dx + pipe_dy*pipe_dy);
      pipe_rotate = atan2(pipe_dy, pipe_dx);
      translate([-30,ball_bearing_diameter*i-7*ball_bearing_diameter/2,plate_thickness]) rotate([0,0,pipe_rotate]) rotate([0,90,0]) cylinder(d=ball_bearing_diameter, h=pipe_length);
    }
  }
}

module stage1_assembly() {
  rotate([0,20,0]) {
    translate([61,-0,-5]) {
      stage1_distributor();
      translate([0,0,5+ball_bearing_diameter/2+1]) {
	//top_plate();
      }
    }
  }
}



// Assembled layout
/*
input_fixed_assembly();
input_rotating_assembly();
stage1_assembly();
*/

// Printing layout
rotate([0,-20,0]) {
input_fixed_assembly();
stage1_assembly();
}

