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
bearing_stop_y = 50;
function ejector_xpos(col) =20+col*pitch+channel_width/2;

diverter_width = (columns-1)*pitch+channel_width;

module generic_plate_shape() {
  left_height = 40+bearing_stop_y;
  polygon([[0,0], [200,0], [200,left_height+200*sin(input_channel_slope)], [0,left_height]]);
}


module core_plate_2d() {
  difference() {
    generic_plate_shape();
    for(c=[0:columns-1]) {
      translate([ejector_xpos(c)-channel_width/2, bearing_stop_y]) square([channel_width, channel_height+c*pitch*sin(input_channel_slope)]);
      translate([ejector_xpos(c), bearing_stop_y]) circle(d=channel_width);
    }
    translate([ejector_xpos(0),channel_height+bearing_stop_y]) {
      rotate(input_channel_slope) translate([0,-channel_width/2]) square([200,channel_width]);
      circle(d=channel_width);
    }
    // Hole for the diverter
    clearance = 1;
    translate([ejector_xpos(0)-channel_width/2-clearance, 5-clearance]) square([diverter_width+clearance*2,31+clearance*2]);
  }
}

module base_plate_2d() {
  difference() {
    generic_plate_shape();

    // Cut off bottom of plate
    translate([-1,-1]) square([202, 41]);

    // Holes for ejector arms
    for(c=[0:columns-1]) {
      xpos = 20+c*pitch;
      translate([xpos + channel_width/2,bearing_stop_y-2]) translate([-3.5/2,0]) square([3.5,10]);
    }
    // tab holes to mount the ejector arms
    for(x=support_tab_x) {
      translate([x,bearing_stop_y+5]) square([3,30]);
    }
  }
}

module ejector_support_2d() {
  difference() {
    union() {
      translate([0,3]) square([20,25]);
      translate([10,0]) square([7,36]);
      translate([10,-30]) square([7,30]);
      translate([10,-35]) square([13,23]);
    }
    // Hole for ejector axle
    translate([5,23]) circle(d=3);
    // Hole for diverter axle
    translate([18,-27]) circle(d=3);
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


module upper_plate_2d() {
  difference() {
    generic_plate_shape();
    // Cut off bottom of plate
    translate([-1,-1]) square([202, 41]);
    for(c=[0:columns-1]) {
      translate([ejector_xpos(c) - channel_width/2, -1]) square([channel_width,bearing_stop_y+5]);
    }
  }
}

module top_plate_2d() {
  difference() {
    generic_plate_shape();
  }
}

module diverter_2d() {
  difference() {
    translate([20,0]) square([diverter_width,30]);
    for(c=[0:columns-1]) {
      translate([ejector_xpos(c) + channel_width/2,5]) square([3,20]);
      translate([ejector_xpos(c+1) - channel_width/2-3,5]) square([3,20]);
    }
  }
}

module diverter_rotate_arm_2d() {
  translate([-10,-15]) {
    difference() {
      union() {
	square([20,20]);
	translate([0,-3]) polygon([[0,3], [3,0], [3,26], [0,23]]);
      }
      translate([10,15]) circle(d=3);
    }
  }
}

module centred_diverter_assembly() {
  translate([0, -20, 4]) color([0.5,0.7,0.7]) linear_extrude(height=3) diverter_2d();
  translate([ejector_xpos(0)+channel_width/2,0,0]) rotate([0,90,0]) linear_extrude(height=3) diverter_rotate_arm_2d();
  translate([ejector_xpos(7)-channel_width/2-3,0,0]) rotate([0,90,0]) linear_extrude(height=3) diverter_rotate_arm_2d();
}

module 3d_assembly() {
  linear_extrude(height=3) core_plate_2d();
  translate([0,0,-5]) color([0.5,0.7,0.7]) linear_extrude(height=3) base_plate_2d();
  translate([0,0,5]) color([0.5,0.7,0.7,0.5]) linear_extrude(height=3) upper_plate_2d();
  //translate([0,0,10]) color([0.5,0.7,0.7,0.5]) linear_extrude(height=3) top_plate_2d();

  // Diverter and support arms
  translate([0,25,-4])
  {
    rotate([$t,0,0]) centred_diverter_assembly();
  }

  // Axle
  color([1.0,0,0]) translate([0,25,-4]) rotate([0,90,0]) cylinder(d=3, h=300);
  for(x=support_tab_x) {
    translate([x+3,bearing_stop_y+2,-25+3-explode]) rotate([0,-90,0]) color([0.5,0.7,0.7]) linear_extrude(height=3) ejector_support_2d();
  }
  for(c=[0:columns-1]) {
    translate([ejector_xpos(c)-1.5,bearing_stop_y+25,-17]) {
      rotate([-90,0,0]) rotate([0,90,0]) linear_extrude(height=3) ejector_arm_2d();
    }
  }
}

3d_assembly();


// Example ball bearings
translate([ejector_xpos(0),bearing_stop_y,ball_bearing_radius-2]) sphere(d=ball_bearing_diameter);
