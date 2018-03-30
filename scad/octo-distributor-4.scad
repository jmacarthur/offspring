/* Ball bearing injector, mk 6. This is meant for 8 ball bearings at a
   time, and may be extended to 32 if successful.
   This version is meant for a laser cutter. */

include <globs.scad>;


$fn=20;
explode = 0;

input_channel_slope = 10;
columns = 8;
channel_width = 7;
channel_height = 30;
support_tab_x = [10,8*pitch+10];

function ejector_xpos(col) =20+col*pitch+channel_width/2;


module core_plate_2d() {
  difference() {
    square([200,80]);
    for(c=[0:columns-1]) {
      translate([ejector_xpos(c)-channel_width/2, 15]) square([channel_width, channel_height+c*pitch*sin(input_channel_slope)-15]);
      translate([ejector_xpos(c), 15]) circle(d=channel_width);
    }
    translate([ejector_xpos(0),channel_height]) {
      rotate(input_channel_slope) translate([0,-channel_width/2]) square([200,channel_width]);
      circle(d=channel_width);
    }
  }
}

module base_plate_2d() {
  difference() {
    square([200,80]);
    // Holes for ejector arms
    for(c=[0:columns-1]) {
      xpos = 20+c*pitch;
      translate([xpos + channel_width/2,15-2]) translate([-3.5/2,0]) square([3.5,10]);
    }
    // tab holes to mount the ejector arms
    for(x=support_tab_x) {
      translate([x,20]) square([3,30]);
    }
  }
}

module ejector_support_2d() {
  difference() {
    union() {
      translate([0,3]) square([20,30]);
      square([17,36]);
    }
    translate([5,23]) circle(d=3);
  }
}

module ejector_arm_2d() {
  difference() {
    union() {
      translate([-5,-5]) square([10,50]);
      translate([-5,-5]) square([30,10]);
      translate([20,-15]) polygon([[4,0], [0,20], [5,20], [6,0]]);
    }
    circle(d=3);
  }
}

module 3d_assembly() {
  linear_extrude(height=3) core_plate_2d();
  translate([0,0,-5]) color([0.5,0.7,0.7]) linear_extrude(height=3) base_plate_2d();
  for(x=support_tab_x) {
    translate([x+3,20-3,-25+3-explode]) rotate([0,-90,0]) color([0.5,0.7,0.7]) linear_extrude(height=3) ejector_support_2d();
  }
  for(c=[0:columns-1]) {
    translate([ejector_xpos(c)-1.5,40,-17]) {
      rotate([-90,0,0]) rotate([0,90,0]) linear_extrude(height=3) ejector_arm_2d();
    }
  }
}

3d_assembly();


// Example ball bearings
translate([ejector_xpos(0),15,ball_bearing_radius-2]) sphere(d=ball_bearing_diameter);
