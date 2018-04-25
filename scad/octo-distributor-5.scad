// Octo-distributor 5
// Combined metering unit, distributor and injector for top end

include <globs.scad>

intake_slope = 5; // Degrees

module intake_channel_2d()
{
  difference() {
    union() {
      square([40,50]);
      translate([40,20]) {
	rotate(-180-intake_slope) translate([5,-channel_width/2-5]) square([40,channel_width+10]);
      }
    }
    translate([40,20]) {
      rotate(-180-intake_slope) translate([-5,-channel_width/2]) square([70,channel_width]);
    }
  }
}

intake_channel_x_size = ball_bearing_diameter/2 + ball_bearing_diameter*7*cos(intake_slope);
intake_chamber_delta_y = -intake_channel_x_size*sin(intake_slope);
$fn=20;


module input_parallelogram(width, height) {
  polygon([[0,0], [width, -width*sin(intake_slope)], [width, -width*sin(intake_slope)+height], [0,height]]);
}

module intake_chamber_holes()
{
  translate([10,0]) circle(d=3);
  translate([50,-50*sin(intake_slope)] ) circle(d=3);
}

module intake_chamber_2d()
{
  difference() {
    union() {
      square([70,50]);
    }
    translate([intake_channel_x_size,20+intake_chamber_delta_y]) {
      circle(d=channel_width);
      rotate(-180-intake_slope) translate([0,-channel_width/2]) square([80,channel_width]);
    }
    translate([0,20]) input_parallelogram(intake_channel_x_size, 20);
    translate([0,30]) intake_chamber_holes();
  }
}

module intake_moving_top_2d() {
  difference() {
    translate([0,channel_width]) input_parallelogram(intake_channel_x_size, 10);
    translate([0,30-17]) intake_chamber_holes();
  }
}

module intake_sidebar_2d() {
  difference() {
    extend = 10;
    input_parallelogram(intake_channel_x_size+extend, 20);
    translate([0,30-17]) intake_chamber_holes();
  }
}


module 3d_octo5_assembly() {
  rotate([90,0,0]) linear_extrude(height=3) intake_channel_2d();
  color([1.0,0,0]) translate([40,0,0]) rotate([90,0,0]) linear_extrude(height=3) intake_chamber_2d();
  color([0.8,0.0,0]) translate([40,-5,17]) rotate([90,0,0]) linear_extrude(height=3) intake_sidebar_2d();
  color([0.8,0.0,0]) translate([40,5,17]) rotate([90,0,0]) linear_extrude(height=3) intake_sidebar_2d();
  color([0.8,0.0,0]) translate([40,0,17]) rotate([90,0,0]) linear_extrude(height=3) intake_moving_top_2d();
}


// Example ball bearings

for(i=[0:7]) {
  translate([40+ball_bearing_diameter/2,-1.5,20]) {
    translate([ball_bearing_diameter*i*cos(intake_slope), 0, -ball_bearing_diameter*i*sin(intake_slope)])
    { 
	sphere(d=ball_bearing_diameter,$fn=20);
    }
  }
 }

3d_octo5_assembly();
