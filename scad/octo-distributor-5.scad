// Octo-distributor 5
// Combined metering unit, distributor and injector for top end

include <globs.scad>

intake_slope = 5; // Degrees

intake_channel_x_size = ball_bearing_diameter/2 + ball_bearing_diameter*7*cos(intake_slope);
intake_chamber_delta_y = -intake_channel_x_size*sin(intake_slope);
$fn=20;


module intake_chamber_2d()
{
  difference() {
    union() {
      square([110,50]);
      translate([40,20]) {
	rotate(-180-intake_slope) translate([5,-channel_width/2-5]) square([40,channel_width+10]);
      }
    }
    translate([40,20]) {
      rotate(-180-intake_slope) translate([-5,-channel_width/2]) square([70,channel_width]);
    }

    translate([intake_channel_x_size+40,20+intake_chamber_delta_y]) {
      circle(d=channel_width);
      rotate(-180-intake_slope) translate([0,-channel_width/2]) square([80,channel_width]);
    }
    translate([40,20]) input_parallelogram(intake_channel_x_size, 20);
    translate([40,30]) intake_chamber_holes();
    // Holes for grade tabs
    translate([37,5]) square([3,10]);
    translate([37,30]) square([3+0.1,10]);
  }
}

explode = 0;

module input_parallelogram(width, height) {
  polygon([[0,0], [width, -width*sin(intake_slope)], [width, -width*sin(intake_slope)+height], [0,height]]);
}

module intake_chamber_holes()
{
  translate([10,0]) circle(d=3);
  translate([40,-40*sin(intake_slope)] ) circle(d=3);
}

module intake_moving_top_2d() {
  difference() {
    translate([0,channel_width]) input_parallelogram(intake_channel_x_size, 10);
    translate([0,30-17]) intake_chamber_holes();
  }
}

module intake_sidebar_2d(extend) {
  difference() {
    input_parallelogram(intake_channel_x_size+extend, 20);
    translate([0,30-17]) intake_chamber_holes();
  }
}

module rotating_plate_2d(drop) {
  difference() {
    union() {
      translate([0,-drop]) {
	square([13,60]);
      }
      translate([-20,42]) square([30,10]);
    }
    translate([0,-drop]) {
      translate([-1,-1]) square([4,11]);
      translate([5,-1]) square([3,8]);
      translate([10,-1]) square([4,11]);
    }
    translate([0,48]) circle(d=3);
  }
}

module intake_grade_2d(side) {
  difference() {
    union() {
      square([10,side==0?50:80]);
      // Tabs
      translate([-3,5+5*side]) square([4,5]);
      translate([-3,30+5*side]) square([4,5]);
    }
    hull() {
      translate([0,20-1]) circle(d=channel_width);
      translate([0,20+1]) circle(d=channel_width);
    }
    if(side==1) translate([5,75]) circle(d=3);
  }
}


module 3d_octo5_assembly() {
  //rotate([90,0,0]) linear_extrude(height=3) intake_chamber_2d();
  color([0.8,0.0,0]) translate([40,-5,17]) rotate([90,0,0]) linear_extrude(height=3) intake_sidebar_2d(10);
  color([0.8,0.0,0]) translate([40,5,17]) rotate([90,0,0]) linear_extrude(height=3) intake_sidebar_2d(0);
  color([0.8,0.0,0]) translate([40,0,17]) rotate([90,0,0]) linear_extrude(height=3) intake_moving_top_2d();
  color([0.8,0.5,0]) translate([40,-3-explode,0]) rotate([0,0,-90]) rotate([90,0,0]) linear_extrude(height=3) intake_grade_2d(0);
  color([0.8,0.5,0]) translate([40-3,explode,0]) rotate([0,0,90]) rotate([90,0,0]) linear_extrude(height=3) intake_grade_2d(1);
  color([0.4,0,0.4]) translate([43,5,17+10]) rotate([0,0,-90]) rotate([90,0,0]) linear_extrude(height=3) rotating_plate_2d(0);
  color([0.4,0,0.4]) translate([43+44,5,17+10]) rotate([0,0,-90]) rotate([90,0,0]) linear_extrude(height=3) rotating_plate_2d(44*sin(intake_slope));
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
