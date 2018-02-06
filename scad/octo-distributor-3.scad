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

// For the 3D printed stage1 distributor
module mounting_holes_2d() {
  // Mounting holes
  for(p=mounting_hole_positions) {
    translate(p) circle(d=3);
  }
}

module mounting_holes_3d() {
  for(p=mounting_hole_positions) {
    translate([0,0,-1]) translate(p) cylinder(d=3, h=plate_thickness+2);
  }
}


module input_chamber_base() {
  difference() {
    square([100,20]);
    translate([-1,10]) square([channel_length+5,20]);
    translate([channel_length+4,10]) rotate(ramp_angle) square([100,20]);
    for(x=injector_mounting_holes_x) {
      translate([x, 5]) circle(d=3);
    }
  }
}

module input_ramp_top() {
  difference() {
    union() {
      translate([channel_length+4.5, 15]) square([20,5+1]);
      rotate(ramp_angle) translate([channel_length+12,10]) square([60,15]);
    }
    // Square off the end
    translate([100, -1]) square([30,50]);
    translate([channel_length+4,10]) rotate(ramp_angle) square([100,channel_radius*2]);
    for(x=injector_mounting_holes_x) {
      translate([x, 25]) circle(d=3);
    }
  }
}


module injector_end_wall() {
  difference() {
    union() {
      square([20,90]);
      translate([15,90-1]) square([5,11]);
      translate([10,95]) square([6,5]);
    }
    translate([10,5]) square([3,10]);
    translate([10+1.5,18]) circle(d=2.5);// Adjustment screw hole
    translate([10+1.5,axis_height]) circle(d=3); // Swing axis hole
    translate([17,55]) square([20,10]); // Gap for support plate
  }
}

module injector_input_wall() {
  difference() {
    union() {
      square([20,90]);
      translate([15,90-1]) square([5,11]);
      translate([10,95]) square([6,5]);
    }
    translate([10,5]) square([3,15]); // Hole for input chamber base, extended up
    hull() {
      translate([10+1.5,10+5+channel_radius]) circle(r=channel_radius); // Input hole
      translate([10+1.5,20+channel_radius]) circle(r=channel_radius); // Input hole
    }
    translate([10+1.5,axis_height]) circle(d=3); // Swing axis hole
    translate([17,55]) square([20,10]); // Gap for support plate
  }
}

module swing_arm() {
  difference() {
    union() {
      translate([0,30]) square([20,50]);
      translate([10+1.5,80]) circle(d=20-3);
      translate([-20,80]) square([30+1.5,8.5]); // Control levers
    }
    translate([-15,84]) circle(d=3); // Holes in control levers
    translate([10+1.5,axis_height]) circle(d=3); // Swing axis hole
    translate([10-1.5 - channel_radius,30-1]) square([3,11]); // Sidewall 1
    translate([10+1.5 + channel_radius,30-1]) square([3,11]); // Sidewall 2
    translate([15,50]) square([20,20]); // Gap for support plate
  }
}

module side_wall() {
  difference() {
    square([channel_length,25-1]);
    for(x=top_wall_mounting_holes) {
      translate([x,5+channel_radius*2]) circle(d=3);
    }
  }
}

module top_wall() {
  difference() {
    translate([0,channel_radius*2-1]) square([channel_length, 10]);
    for(x=top_wall_mounting_holes) {
      translate([x,5+channel_radius*2]) circle(d=3);
    }
  }
}

module ramp_wall() {
  difference() {
    translate([channel_length+9, 0]) square([40,30]);
    for(x=injector_mounting_holes_x) {
      translate([x,5]) circle(d=3);
      translate([x,25]) circle(d=3);
    }
  }
}

module mid_mounting_plate() {
  xpos_list = [20, 25+channel_length ];
  drill_holes = [ 8, 8+12*7] ;
  difference() {
    union() {
      square([100,10]);
      for(x=xpos_list) {
	translate([x+1.5,5]) circle(d=18);
      }
    }
    for(x=xpos_list) {
      translate([x,10]) square([3,15]);
      translate([x,-10]) square([3,10]);
    }
    for(x=drill_holes) {
      translate([x,5]) circle(d=4);
    }
  }
}

module top_mounting_plate() {
  xpos_list = [20, 25+channel_length ];
  drill_holes = [ 8, 8+12*7] ;
  difference() {
    union() {
      square([100,15]);
    }
    for(x=xpos_list) {
      translate([x,5]) square([3,5]);
    }
    for(x=drill_holes) {
      translate([x,6]) circle(d=4);
    }
  }
}

module feed_pipe() {
  output_height = 10+(100-channel_length-4)*sin(ramp_angle);
  union() {
    translate([0,output_height]) rotate(ramp_angle) square([20,channel_radius*2]);
    translate([0,output_height]) rotate(ramp_angle) translate([20,channel_radius]) circle(r=channel_radius);
    x = 40; // Turn radius
    intersection() {
      difference() {
	translate([20/cos(ramp_angle),x]) circle(r=x-output_height-20*sin(ramp_angle));
	translate([20/cos(ramp_angle),x]) circle(r=x-output_height-20*sin(ramp_angle)-channel_radius*2);
      }
      translate([20/cos(ramp_angle),x-50]) square([50,50]);
    }
    translate([20/cos(ramp_angle)+x-output_height-20*sin(ramp_angle)-channel_radius*2,x]) square([channel_radius*2, 30]);

    // Funnel feeder - can be filled in when better feeds are available
    hull() {
      translate([20/cos(ramp_angle)+x-output_height-20*sin(ramp_angle)-channel_radius,x+10]) circle(r=channel_radius);
      translate([10,x+30]) circle(r=channel_radius);
      translate([50,x+30]) circle(r=channel_radius);
    }
  }
}

module external_feed_holes() {
  translate([20-12,12+peg_mounting_y_offset]) circle(d=4);
  translate([20+12*3,12*4+peg_mounting_y_offset]) circle(d=4);
  translate([20-12,12*4+peg_mounting_y_offset]) circle(d=4);
  translate([20,12*4+peg_mounting_y_offset]) circle(d=4);
  translate([20+12*2,12+peg_mounting_y_offset]) circle(d=4);
}

module external_feed_pipe() {
  difference() {
    square([60,70]);
    feed_pipe();
    external_feed_holes();
  }
}

module external_feed_wall() {
  difference() {
    square([60,70]);
    external_feed_holes();
  }
}

/* Rather than make large mountings on 3D printed components, this
   backing plate mounts the stage1 distributor parts to the 12mm
   spaced backplate. */

stage1_centre_x = channel_length/2+4;

module stage1_mounting_plate() {
  difference() {
    translate([-50,10]) square([100,30]);
    translate([0,0]) rotate(-90) mounting_holes_2d();
    for(x=[-12,12*6]) {
      translate([x-stage1_centre_x,45-12*2]) circle(d=4);
    }
  }
}

module stage1_distributor(bonus_height) {
  difference() {
    union() {
      // Upper plate
      translate([-50-bonus_height,-channel_length/2,0]) cube([30+bonus_height, channel_length, plate_thickness]);

      // Lower plate
      translate([-38,-stage1_output_length/2,0]) cube([28,stage1_output_length, plate_thickness]);

      // Extending bars at the bottom which connect mounting holes
      translate([-18,-stage1_output_length/2-8,0]) cube([8,stage1_output_length+16, plate_thickness]);

      translate([-35, -mounting_position_y2, 0]) cylinder(d=8,h=plate_thickness);
      translate([-35, mounting_position_y2, 0]) cylinder(d=8,h=plate_thickness);

    }
    mounting_holes_3d();
    channel_depth = plate_thickness+1;

    for(i=[0:7]) {
      input_y = ball_bearing_diameter*i-7*ball_bearing_diameter/2;
      output_y = stage1_output_pitch*i-7*stage1_output_pitch/2;
      translate([-50-bonus_height-1,input_y,channel_depth]) rotate([0,90,0]) cylinder(d=ball_bearing_diameter, h=20+bonus_height+1);
      translate([-30,input_y,channel_depth]) rotate([0,90,0]) sphere(d=ball_bearing_diameter);
      translate([-20,output_y,channel_depth]) rotate([0,90,0]) cylinder(d=ball_bearing_diameter, h=21);
      translate([-20,output_y,channel_depth]) rotate([0,90,0]) sphere(d=ball_bearing_diameter);
      pipe_dx = 10;
      pipe_dy = output_y-input_y;
      pipe_length = sqrt(pipe_dx*pipe_dx + pipe_dy*pipe_dy);
      pipe_rotate = atan2(pipe_dy, pipe_dx);
      translate([-30,ball_bearing_diameter*i-7*ball_bearing_diameter/2,channel_depth]) rotate([0,0,pipe_rotate]) rotate([0,90,0]) cylinder(d=ball_bearing_diameter, h=pipe_length);
    }
  }
}

module 3d_injector_assembly() {
  rotate([90,0,0]) linear_extrude(height=3) input_chamber_base();
  rotate([90,0,0]) linear_extrude(height=3) input_ramp_top();
  translate([0,-13,-5]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) injector_end_wall();
  translate([channel_length+5,-13,-5]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) injector_input_wall();

  color([0,1,1]) translate([3+1,-13,-5]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) swing_arm();
  color([0,1,1]) translate([channel_length+1,-13,-5]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) swing_arm();
  translate([3+1, -1.5-channel_radius, 11]) rotate([90,0,0]) linear_extrude(height=3) side_wall();
  translate([3+1, 1.5-channel_radius+2, 11]) rotate([90,0,0]) linear_extrude(height=3) top_wall();
  translate([3+1, 1.5+channel_radius, 11]) rotate([90,0,0]) linear_extrude(height=3) side_wall();
  translate([0,-5,0]) rotate([90,0,0]) linear_extrude(height=3) ramp_wall();
  translate([0,5,0]) rotate([90,0,0]) linear_extrude(height=3) ramp_wall();
  translate([-20,10,50]) rotate([90,0,0]) linear_extrude(height=3) mid_mounting_plate();
  translate([-20,10,85]) rotate([90,0,0]) linear_extrude(height=3) top_mounting_plate();
}

module external_feed_assembly() {
  color([1,0,0.5]) rotate([90,0,0]) linear_extrude(height=3) external_feed_pipe();
  color([1,0,0.5]) translate([0,-5,0]) rotate([90,0,0]) linear_extrude(height=3) external_feed_wall();
  color([1,0,0.5]) translate([0,5,0]) rotate([90,0,0]) linear_extrude(height=3) external_feed_wall();
}



3d_injector_assembly();
translate([8*pitch,0]) 3d_injector_assembly();
translate([100,0]) external_feed_assembly();
translate([60,-1.5,10+ball_bearing_diameter/2]) sphere(d=ball_bearing_diameter);


// Alignment pegs
translate([0,-50,0]) rotate([90,0,0]) cylinder(d=4,h=50);
translate([-12*1,30,12*8-5]) rotate([90,0,0]) cylinder(d=4,h=50);
translate([-12*1,30,12*5-5]) rotate([90,0,0]) cylinder(d=4,h=50);
translate([12*6,30,12*5-5]) rotate([90,0,0]) cylinder(d=4,h=50);

translate([9*12,30,12*4-5]) rotate([90,0,0]) cylinder(d=4,h=50);
translate([12*12,30,12*1-5]) rotate([90,0,0]) cylinder(d=4,h=50);

translate([12*6,30,-24-5]) rotate([90,0,0]) cylinder(d=4,h=50);
translate([-12,30,-24-5]) rotate([90,0,0]) cylinder(d=4,h=50);

translate([stage1_centre_x,-12,-50])rotate([-90,0,0]) rotate([0,0,90]) stage1_distributor(10);
translate([stage1_centre_x,0,-50])rotate([0,0,180]) rotate([-90,0,0]) rotate([0,0,90]) stage1_distributor(-1);
translate([stage1_centre_x,3,-50]) rotate([90,0,0]) linear_extrude(height=3) stage1_mounting_plate();

// Ultimate width

translate([0,-50,0]) cube([8*pitch,10,10]);
