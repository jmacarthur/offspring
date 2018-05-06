// Octo-distributor 5
// Combined metering unit, distributor and injector for top end

include <globs.scad>
use <stage2-distributor.scad>;
use <diverter-parts.scad>;
intake_slope = 5; // Degrees

intake_channel_x_size = ball_bearing_diameter/2 + ball_bearing_diameter*7*cos(intake_slope);
intake_chamber_delta_y = -intake_channel_x_size*sin(intake_slope);
$fn=20;
tube_diameter = 11;

stage1_output_pitch = 8;
explode = 20;

function bb_centre_position(x) = ball_bearing_diameter+cos(intake_slope)*(x+0.5)*ball_bearing_diameter;
function bb_divider_position(x) = ball_bearing_diameter+cos(intake_slope)*(x)*ball_bearing_diameter;
function stage1_output_position(x) = stage1_output_pitch*x;
chamber_x = 40;
data_centre_line_x = stage1_output_position(3)+chamber_x;
diverter_y = -90;

module intake_chamber_holes()
{
  translate([0,0]) circle(d=3);
  translate([20,-20*sin(intake_slope)] ) circle(d=3);
}

module distributor_holes() {
  for(x=[0:7]) {
    descend = 5*sin(180*x/6);
    translate([bb_divider_position(x),-descend]) circle(d=stage1_wire_diameter);
    translate([bb_divider_position(x),12-bb_divider_position(x)*sin(intake_slope)]) circle(d=stage1_wire_diameter);
    translate([stage1_output_position(x),-10]) circle(d=stage1_wire_diameter);
  }
  // Mounting holes
  translate([55,5]) circle(d=3);
  translate([-10,-5]) circle(d=3);
}

module intake_chamber_2d()
{
  overall_backplate_length = 150;
  difference() {
    union() {
      translate([0,-50]) square([100,100]);
      translate([-45,50-overall_backplate_length]) square([215,overall_backplate_length-50]);
      translate([chamber_x,20]) {
	input_channel_size = channel_width+15;
	rotate(-180-intake_slope) translate([5,-input_channel_size/2]) square([50,input_channel_size]);
      }
    }

    // Main input channel
    translate([intake_channel_x_size+40,20+intake_chamber_delta_y]) {
      circle(d=channel_width);
      rotate(-180-intake_slope) translate([0,-channel_width/2]) square([100,channel_width]);
      rotate(-180-intake_slope) translate([90,-tube_diameter/2]) square([50,tube_diameter]);
    }

    translate([chamber_x,20]) input_parallelogram(intake_channel_x_size+1, 90);
    translate([chamber_x,30]) intake_chamber_holes();

    // Holes for grade tabs
    translate([37,5]) square([3,10]);
    translate([37,30]) square([3+0.1,10]);

    translate([10,10]) intake_chamber_holes();
    translate([10,40]) intake_chamber_holes();

    translate([chamber_x,0,0]) distributor_holes();
    // Fixing hole
    translate([95,35]) circle(d=3);

    // Mounting holes for stage2
    for(x=[-37,-1,123,123+36]) translate([x,-30]) circle(d=4);
    translate([data_centre_line_x,diverter_y]) diverter_cutout();
  }
}

module distributor_cover_2d() {
  difference() {
    polygon([[-15,-10], [-15,0], [0,0], [0,15], [60,15-60*sin(intake_slope)], [60,-10]]);
    distributor_holes();
  }
}

module input_parallelogram(width, height) {
  polygon([[0,0], [width, -width*sin(intake_slope)], [width, -width*sin(intake_slope)+height], [0,height]]);
}

module right_swing_support_2d()
{
  difference() {
    square([18,40]);
    translate([5,-1]) square([3,10]);
    translate([13,35]) circle(d=3);
  }
}

module intake_sidewalls_2d()
{
  difference() {
    translate([0,5]) input_parallelogram(37,40);
    translate([10,10]) intake_chamber_holes();
    translate([10,40]) intake_chamber_holes();
  }
}


module intake_rotator_holes()
{
  translate([10,0]) circle(d=3);
  translate([40,-40*sin(intake_slope)] ) circle(d=3);
}

module intake_moving_top_2d() {
  difference() {
    translate([0,channel_width]) input_parallelogram(intake_channel_x_size, 10);
    translate([0,30-17]) intake_rotator_holes();
  }
}

module intake_sidebar_2d(extend) {
  difference() {
    input_parallelogram(intake_channel_x_size+extend, 20);
    translate([0,30-17]) intake_rotator_holes();
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
      translate([0,5]) square([10,side==0?45:75]);
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

stage1_slope = 10;
module output_slopes_2d() {
  polygon([[0,0], [23,0], [23,5-10*sin(stage1_slope)], [13,5], [10,5], [10,10], [5,10], [5,20],[0,20]]);
}


module stage1_constructor_holes() {
  for(x=[-7,55])
    for(y=[12])
      translate([x,y]) circle(d=3);
}

module stage1_distributor_2d() {
  difference() {
    union() {
      square([55,30]);
      translate([-12,0]) square([74,17]);
    }
    for(x=[0:6]) {
      descend = 5*sin(180*x/6);
      translate([bb_divider_position(x),15-descend]) circle(d=stage1_wire_diameter);
      translate([bb_divider_position(x),15-descend-stage1_wire_diameter]) circle(d=stage1_wire_diameter);
      translate([stage1_output_position(x),5]) circle(d=stage1_wire_diameter);
    }
    stage1_constructor_holes();
  }
}

module stage1_distributor_top_2d() {
  difference() {
    union() {
      square([55,21]); // The length of this determines the swing of the injector arm
      translate([-12,0]) square([74,17]);
    }
    for(x=[0:6]) {
      descend = 5*sin(180*x/6);
      translate([bb_divider_position(x),15-descend]) circle(d=stage1_wire_diameter);
      translate([bb_divider_position(x),15-descend-stage1_wire_diameter]) circle(d=stage1_wire_diameter);
      translate([stage1_output_position(x),5]) circle(d=stage1_wire_diameter);
    }
    stage1_constructor_holes();
  }
}


module stage1_distributor_assembly() {
  rotate([stage1_slope, 0,0]) translate([0,-30,0]) {
    color([0.3,0.3,0.3])     linear_extrude(height=3) stage1_distributor_2d();

    color([0.3,0.3,0.3,0.3])     translate([0,0,10]) linear_extrude(height=3) stage1_distributor_top_2d();

    // Example wires
    for(x=[0:6]) {
      color([0.6,0.3,0.0]) rotate([90,0,0]) translate([bb_divider_position(x),3,-30]) cylinder(d=1,h=15);
    }
  }
}

module 3d_octo5_assembly() {
  rotate([90,0,0]) linear_extrude(height=3) intake_chamber_2d();
  translate([0,5,0]) rotate([90,0,0]) linear_extrude(height=3) intake_sidewalls_2d();
  translate([0,-5,0]) rotate([90,0,0]) linear_extrude(height=3) intake_sidewalls_2d();



  color([0.8,0.0,0]) translate([40,-5,17]) rotate([90,0,0]) linear_extrude(height=3) intake_sidebar_2d(10);
  color([0.8,0.0,0]) translate([40,5,17]) rotate([90,0,0]) linear_extrude(height=3) intake_sidebar_2d(0);
  color([0.8,0.0,0]) translate([40,0,17]) rotate([90,0,0]) linear_extrude(height=3) intake_moving_top_2d();
  color([0.8,0.5,0]) translate([40,-3-explode,0]) rotate([0,0,-90]) rotate([90,0,0]) linear_extrude(height=3) intake_grade_2d(0);
  color([0.8,0.5,0]) translate([40-3,explode,0]) rotate([0,0,90]) rotate([90,0,0]) linear_extrude(height=3) intake_grade_2d(1);
  color([0.4,0,0.4]) translate([43,5,17+10]) rotate([0,0,-90]) rotate([90,0,0]) linear_extrude(height=3) rotating_plate_2d(0);
  color([0.4,0,0.4]) translate([43+44,5,17+10]) rotate([0,0,-90]) rotate([90,0,0]) linear_extrude(height=3) rotating_plate_2d(44*sin(intake_slope));

  //color([0.4,0.4,0]) translate([53,10,0]) rotate([0,0,-90]) rotate([90,0,0]) linear_extrude(height=3) output_slopes_2d();
  //color([0.4,0.4,0]) translate([83,10,0]) rotate([0,0,-90]) rotate([90,0,0]) linear_extrude(height=3) output_slopes_2d();

  color([0.8,0.5,0]) translate([90,-8,40]) rotate([0,0,90]) rotate([90,0,0]) linear_extrude(height=3) right_swing_support_2d();

  color([0.5,0.5,0.5,0.5]) translate([40,-10,0]) rotate([90,0,0]) linear_extrude(height=3) distributor_cover_2d();

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
translate([40+stage1_output_position(3),-3,-20]) rotate([0,0,180]) 3d_stage2_assembly();
translate([40+stage1_output_position(3), -17, diverter_y+20]) rotate([90,0,0]) rotate([0,180,0]) centred_diverter_assembly();
