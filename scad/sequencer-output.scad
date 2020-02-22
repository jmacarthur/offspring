// Sequencer output assembly

include <globs.scad>;
include <sequencer_globs.scad>;

$fn=20;

module fake_cam() {
  rotate([0,90,0]) {
    translate([0,0,-5.5]) cylinder(d=170,h=3);
    translate([0,0,-2.5]) color([0.4,0.4,0.4]) cylinder(d=150,h=5);
    translate([0,0,2.5]) cylinder(d=170,h=3);
  }
}

// Example cams, not part of finished assembly
module fake_cams() {
  for(i=[0:3]) {
    translate([cam_spacing*i, 0, 0]) fake_cam();
  }
  
  for(i=[1:5]) {
    translate([cam_spacing*3 + fixed_cam_spacing*i, 0, 0]) fake_cam();
  }
}

function profile_position(x) = ( (x<8) ? cam_spacing*floor(x/2) : fixed_cam_spacing*floor((x-6)/2) + cam_spacing*3 ) -4 + 8*(x%2);
function follower_position(x) = ( (x<8) ? -3 + 6 * (x%2) : 0 ) + profile_position(x);
function notch_position(x) = x<0? -12: (follower_position(x)+follower_position(x+1))/2;

bar_width = follower_position(17) - follower_position(0) + 30;

module input_bar_2d() {
  difference() {
    translate([-15,0]) square([bar_width, 20]);

    // Cutouts for cables
    for(i=[0:17]) {
      w1 = bowden_cable_outer_diameter;
      w2 = bowden_cable_inner_diameter+0.1;
      translate([follower_position(i)-w1/2, 10]) square([w1,11]);
      translate([follower_position(i)-w2/2, -1]) square([w2,11]);
    }

    // Cutouts to mount holes
    for(i=[-1:17]) {

      translate([notch_position(i)-1.5, -1]) square([3,6]);
      translate([notch_position(i)-1.5, 17]) square([3,6]);
    }
  }
}

module top_bar_2d() {
  difference() {
    translate([-15,0]) square([bar_width, 20]);
    // Cutouts to mount holes
    for(i=[-1:17]) {
      translate([notch_position(i)-1.5, -1]) square([3,6]);
      translate([notch_position(i)-1.5, 17]) square([3,6]);
    }
  }
}

module base_bar_2d() {
  difference() {
    union() {
      top_bar_2d();
      difference() {
	translate([-15,10]) circle(d=20);
	translate([-14.9,0]) square([30,30]);
      }
      difference() {
	translate([-15+bar_width,10]) circle(d=20);
	translate([-15+bar_width-30,0]) square([29.9,30]);
      }
      translate([follower_position(7)-5.5,10]) square([10,20]);
    }
    translate([-20,10]) circle(d=3);
    translate([-15+bar_width+5,10]) circle(d=3);
    translate([follower_position(7),25]) circle(d=3);
  }
}



module input_support_2d() {
  difference() {
    square([20,20]);
    translate([18,8.5]) square([3,3]);
    translate([18,-1]) square([3,4]);
    translate([18,17]) square([3,4]);
  }
}


module front_plate_2d() {
  difference() {
    union() {
      translate([-15,0]) square([bar_width, 5.5]);
      translate([-15,8.5]) square([bar_width, 5.5]);
      for(i=[-1:17]) {
	x1 = notch_position(i);
	translate([x1-1.5,-3]) square([3,20]);
      }
    }
    for(i=[-1:17]) {
      x1 = follower_position(i);
      translate([x1,7]) circle(d=5, $fn=20);
    }
  }  
}

module input_assembly() {
  linear_extrude(height=3) input_bar_2d();

    for(i=[-1:17]) {
      x1 = notch_position(i);
      translate([x1-1.5,-15+2-10,-10+1.5]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) input_support_2d();
    }
    translate([0,0,-8.5]) linear_extrude(height=3) base_bar_2d();
    translate([0,0,8.5]) linear_extrude(height=3) top_bar_2d();
    color([1,0,0]) translate([0,20,-5.5]) rotate([90,0,0]) linear_extrude(height=3) front_plate_2d();
}

translate([0,90,0]) input_assembly();

  
