/* Ball bearing injector, mk 6. This is meant for 8 ball bearings at a
   time, and may be extended to 32 if successful.
   This version is meant for a laser cutter. */

include <globs.scad>;
columns = 8;
use <diverter-parts.scad>;

$fn=20;
explode = 0;

input_channel_slope = 10;
channel_height = 30;
support_tab_x = [10,8*pitch+10];
bearing_stop_y = 60;
diverter_y = 15;
diverter_width = (columns-1)*pitch+channel_width;
output_tab_x = [-1,ejector_xpos(4)-pitch/2-2.5, 195];
spring_bar_width = support_tab_x[1] - support_tab_x[0] - 3;
interplate_support_y=70;

module generic_plate_shape() {
  width = 200;
  left_height = 40+bearing_stop_y;
  right_height = left_height+width*sin(input_channel_slope);
  difference() {
    polygon([[0,0], [width,0], [width,right_height], [0,left_height]]);
    translate([width-10, right_height-7]) circle(d=3);
    translate([5, left_height-7]) circle(d=3);
  }
}

module core_plate_2d() {
  difference() {
    union() {
      generic_plate_shape();
      for(x=output_tab_x) {
	translate([x,-10]) square([6,10]);
      }

      // Loader extension
      translate([ejector_xpos(0),channel_height+bearing_stop_y]) {
	rotate(input_channel_slope) translate([175,-channel_width/2-10]) square([25,10]);
	rotate(input_channel_slope) translate([175,-channel_width/2+channel_width]) square([25,10]);
      }
    }

    for(c=[0:columns-1]) {
      translate([ejector_xpos(c)-channel_width/2, bearing_stop_y]) square([channel_width, channel_height+c*pitch*sin(input_channel_slope)]);
      translate([ejector_xpos(c), bearing_stop_y]) circle(d=channel_width);
    }
    translate([ejector_xpos(0),channel_height+bearing_stop_y]) {
      rotate(input_channel_slope) translate([0,-channel_width/2]) square([200,channel_width]);
      rotate(input_channel_slope) translate([0,-channel_width/2]) translate([185,channel_width/2-5.5]) square([200,11]);
      circle(d=channel_width);
    }

    translate([0,diverter_y]) diverter_cutout();
  }
}

module base_plate_2d() {
  difference() {
    union() {
      generic_plate_shape();
      // Loader extension
      translate([ejector_xpos(0),channel_height+bearing_stop_y]) {
	rotate(input_channel_slope) translate([0,-channel_width/2]) square([185,channel_width]);
      }
    }

    // Cut off bottom of plate
    translate([-1,-1]) square([202, 51]);

    translate([support_tab_x[0]+3,bearing_stop_y+35]) square([spring_bar_width,3]);

    // Holes for ejector arms
    for(c=[0:columns-1]) {
      xpos = 20+c*pitch;
      translate([xpos + channel_width/2,bearing_stop_y-2]) translate([-3.5/2,0]) square([3.5,10]);
    }
    // tab holes to mount the ejector arms
    for(x=support_tab_x) {
      translate([x,bearing_stop_y+5]) square([3,25]);
    }
  }
}

module ejector_support_2d() {
  difference() {
    union() {
      translate([0,3]) square([20,25]);
      translate([10,0]) square([7,36]);
      translate([10,-30]) square([7,30]);
      translate([10,-62]) square([13,50]);
      slope_start = 0;
      polygon([[0,-62], [0,-62+slope_start], [20,-62+20+slope_start], [20,-62]]);
    }
    // Hole for ejector axle
    translate([5,23]) circle(d=3);
  }
}

module ejector_arm_2d() {
  difference() {
    union() {
      translate([-5,-5]) square([10,50]);
      translate([-5,-5]) square([30,10]);
      translate([20,-15]) polygon([[4,0], [0,20], [5,20], [6,0]]);
      translate([-18,15]) square([16,11]); // Return spring support
    }
    circle(d=3);
    translate([-13,23]) square([3,4]); // Cutout for return spring
    translate([-6,33]) square([3,4]); // Cutout for drive spring
  }
}

module upper_plate_2d() {
  difference() {
    union() {
      generic_plate_shape();
      for(x=[output_tab_x[0], output_tab_x[2]]) {
	translate([x,-3]) square([6,4]);
      }
      // Loader extension
      translate([ejector_xpos(0),channel_height+bearing_stop_y]) {
	rotate(input_channel_slope) translate([0,-channel_width/2]) square([185,channel_width]);
      }

    }
    output_channel_width = ball_bearing_diameter;
    for(c=[0:columns-1]) {
      translate([ejector_xpos(c) - channel_width/2, bearing_stop_y-25]) square([channel_width,25]);
      translate([ejector_xpos(c), bearing_stop_y]) circle(d=output_channel_width);
    }
    translate([ejector_xpos(0) - channel_width/2, -1]) square([pitch*7+channel_width,30]);
    translate([0,diverter_y]) diverter_cutout();
    translate([20,interplate_support_y]) square([160,3]);
  }
}

module upper_output_separator_2d() {
  difference() {
    square([pitch-channel_width, 17]);
    translate([(pitch-channel_width)/2-2.5,-1]) square([5,4]);
  }
}

module top_plate_2d() {
  difference() {
    union() {
      generic_plate_shape();
      for(x=output_tab_x) {
	translate([x,-3]) square([6,4]);
      }
    }
    translate([0,diverter_y]) diverter_cutout();
    for(x=support_tab_x) {
      translate([x,15]) square([3,30]);
    }
    translate([10,interplate_support_y]) square([180,3]);
  }
}

module diverter_support_2d() {
  difference() {
    union() {
      translate([-2,0]) square([15,30]);
      translate([3,-3]) square([5,36]);
    }
    translate([7,20]) circle(d=3);
  }
}

module output_plate_2d() {
  extend_back = 40; // Projection behind zero
  difference() {
    translate([0,-extend_back]) square([200,extend_back+13]);
    for(c=[0:7]) {
      translate([ejector_xpos(c), 5+1.5]) circle(d=channel_width);
    }
    // Connecting tabs
    for(x=output_tab_x) {
      translate([x,0]) square([6,3]);
      translate([x,10]) square([6,3]);
    }
    for(x=[output_tab_x[0], output_tab_x[2]]) {
      translate([x,5]) square([6,3]);
    }

    // Holes for conduit
    clearance = 0.5;
    for(c=[0:7]) {
      translate([ejector_xpos(c)-clearance-8, -30-clearance]) square([16+clearance*2,10+clearance*2]);
    }

    // Gaps for otuput separator plates

    difference() {
      translate([ejector_xpos(0),5]) square([pitch*7,3]);
      for(c=[0:6]) {
	translate([ejector_xpos(c)+pitch/2-2.5,5]) square([5,3]);
      }
    }
  }
}

module ejector_comb_2d() {
  clearance = 0.1;
  difference() {
    square([200,20]);
    for(c=[0:7]) {
      translate([ejector_xpos(c)-1.5-clearance,-1]) square([3+clearance*2,10]);
    }
    for(x=support_tab_x) {
      translate([x,-1]) square([3,10]);
    }
  }
}


module diverted_output_plate_2d() {
  difference() {
    square([200,23]);
    for(x=support_tab_x) {
      translate([x,7]) square([3,20]);
    }
    for(c=[0:columns-1]) {
      if(c<columns-1) { translate([ejector_xpos(c) + channel_width/2,5]) square([3,10]);}
      translate([ejector_xpos(c+1) - channel_width/2-3,5]) square([3,10]);
    }
  }
}


module diverter_output_rib_2d() {
  union() {
    square([10,6]);
    polygon([[-12,3], [-6,6], [10,6], [13,3]]);
  }
}

module diverted_output_assembly() {
  linear_extrude(height=3) diverted_output_plate_2d();
  for(c=[1:columns-1]) {
    color([0,1,0]) translate([ejector_xpos(c)-channel_width/2-3,0,0]) rotate([0,90,0]) rotate([0,0,-90])  translate([-15,-3,0]) linear_extrude(height=3) diverter_output_rib_2d();
    color([0,1,0]) translate([ejector_xpos(c-1)+channel_width/2,0,0]) rotate([0,90,0]) rotate([0,0,-90])  translate([-15,-3,0]) linear_extrude(height=3) diverter_output_rib_2d();
  }
}

module spring_bar_2d()
{
  difference() {
    square([spring_bar_width,22]);
    for(c=[0:columns-1]) {
      translate([ejector_xpos(c)-support_tab_x[0]-3,6]) circle(d=3);
      translate([ejector_xpos(c)-support_tab_x[0]-3,22+1.5]) circle(d=channel_width);
    }
    translate([0,20]) square([ejector_xpos(3),10]);
  }
}

module input_tube_holder_2d() {
  difference() {
    translate([-10,-20]) square([20,40]);
    slot_width = 20+channel_width;
    translate([-1.5,-slot_width/2]) square([3,slot_width]);
    circle(d=11);
  }
}

module interplate_support_2d() {
  difference() {
    union() {
      translate([0,0]) square([200,10]);
      translate([10,5]) square([180,10]);
	translate([20,10]) square([160,10]);
    }
    for(c=[0:columns-1]) {
      translate([ejector_xpos(c),20]) circle(d=channel_width);
    }
    for(x=[ejector_xpos(0)+channel_width/2+1.5, ejector_xpos(7)-channel_width/2-1.5]) {
      translate([x,5]) circle(d=3);
    }
  }
}

module 3d_assembly() {
  color([0.6,0.6,0.9]) linear_extrude(height=3) core_plate_2d();
  translate([0,0,-5]) color([0.5,0.7,0.7]) linear_extrude(height=3) base_plate_2d();
  translate([support_tab_x[0]+3,bearing_stop_y+35+3,-22]) rotate([90,0,0]) color([0.6,0.7,0.7]) linear_extrude(height=3) spring_bar_2d();

  translate([0,0,5]) color([0.5,0.7,0.7,0.5]) linear_extrude(height=3) upper_plate_2d();
  for(c=[0:6]) translate([ejector_xpos(c)+channel_width/2,-3,5]) color([0.5,0.7,0.7,0.5]) linear_extrude(height=3) upper_output_separator_2d();

  translate([0,0,10]) color([0.5,0.7,0.7,0.5]) linear_extrude(height=3) top_plate_2d();

  translate([0,interplate_support_y,23]) color([0.5,0.7,0.2]) rotate([-90,0,0]) linear_extrude(height=3) interplate_support_2d();

  // Diverter and support arms
  translate([208,diverter_y+20,17])
  {
    rotate([$t*40,0,0]) rotate([0,180,0]) centred_diverter_assembly();
  }
  for(x=support_tab_x) {
    translate([x+3,15,10]) rotate([0,-90,0]) linear_extrude(height=3) diverter_support_2d();
  }
  // Axle
  color([1.0,0,0]) translate([0,diverter_y+20,17]) rotate([0,90,0]) cylinder(d=3, h=300);
  for(x=support_tab_x) {
    translate([x+3,bearing_stop_y+2,-25+3-explode]) rotate([0,-90,0]) color([0.5,0.7,0.5]) linear_extrude(height=3) ejector_support_2d();
  }
  for(c=[0:columns-1]) {
    translate([ejector_xpos(c)-1.5,bearing_stop_y+25,-17]) {
      rotate([-90,0,0]) rotate([0,90,0]) linear_extrude(height=3) ejector_arm_2d();
    }
  }

  rotate([90,0,0]) linear_extrude(height=3) output_plate_2d();

  plate_adjust = 16;
  translate([0,plate_adjust-9,-35+plate_adjust]) rotate([45,0,0]) diverted_output_assembly();

  for(dist=[185,198]) {
    translate([20+dist,bearing_stop_y+channel_height+dist*sin(input_channel_slope),1.5]) rotate([0,0,input_channel_slope]) rotate([0,90,0])  color([0.5,0.9,0.9]) linear_extrude(height=3) input_tube_holder_2d();
  }

  translate([0,65,-20]) rotate([-90,0,0]) linear_extrude(height=3) ejector_comb_2d();

}

3d_assembly();


// Example ball bearings
translate([ejector_xpos(0),bearing_stop_y,ball_bearing_radius-2]) sphere(d=ball_bearing_diameter);

// A stand to make testing easierm
module stand_2d() {
  gap = 53;
  difference() {
    polygon([[0,0], [20,24], [20,10], [20+gap,10], [20+gap,20], [20+gap+15,0]]);
    translate([0,-1]) square([20,4]);
    translate([70,-1]) square([20,4]);
  }
}

module stand_joiner_2d() {
  square([183,20]);
}

translate([10,-13,33]) rotate([0,90,0]) linear_extrude(height=3) stand_2d();
translate([190,-13,33]) rotate([0,90,0]) linear_extrude(height=3) stand_2d();
translate([10,-10,13]) rotate([90,0,0]) linear_extrude(height=3) stand_joiner_2d();
translate([10,-10,13-70]) rotate([90,0,0]) linear_extrude(height=3) stand_joiner_2d();

