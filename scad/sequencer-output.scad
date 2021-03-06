// Sequencer output assembly

include <globs.scad>;
include <sequencer_globs.scad>;
include <interconnect.scad>;

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


module horizontal_rod_2d() {
  len = 150;
  difference() {
    union() {
      hull() {
	translate([0,-10]) square([20,30]);
	translate([10,-20]) circle(d=10);
      }
      translate([5,-len]) square([10,len+1]);
      translate([10,-len]) circle(d=10);
    }
    translate([10-0.5-bowden_cable_inner_diameter/2-1.5,11]) rotate(-90) cable_clamp_cutout_with_cable_2d();
    translate([10,-len]) circle(d=3);
  }
}

explode = 0;

module base_comb_2d() {
  clearance = 0.5;
  difference() {
    translate([-20,0]) square([250,100]);
    for(i=[0:17]) {
      translate([follower_position(i)+1.5-clearance,-1]) square([3 + clearance*2,(i<8? 50:80)]);
    }

    // Mounting holes
    translate([-15,20]) square([3,10]);
    translate([220,20]) square([3,10]);
    translate([-15,70]) square([3,10]);
    translate([220,70]) square([3,10]);
  }
}

// Base comb supports
module base_comb_support_2d() {
  difference() {
    union() {
      square([37,80]);
      translate([36,10]) square([4,10]);
      translate([36,60]) square([4,10]);
    }
    translate([20,40]) square([10,3]);
  }
}
module base_comb_support_side_2d() {
  union() {
    square([37,10]);
    translate([20,-3]) square([10,13]);
    translate([0,7]) square([40,5]);
  }
}


module input_assembly() {
  linear_extrude(height=3) input_bar_2d();

    for(i=[-1:17]) {
      x1 = notch_position(i);
      translate([x1-1.5,-15+2-explode,-10+1.5]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) input_support_2d();
    }
    translate([0,0,-8.5]) linear_extrude(height=3) base_bar_2d();
    translate([0,0,8.5]) linear_extrude(height=3) top_bar_2d();
    color([1,0,0]) translate([0,20,-5.5]) rotate([90,0,0]) linear_extrude(height=3) front_plate_2d();
    for(i=[0:17]) {
      translate([follower_position(i)-1.5,-50,10]) rotate([0,90,0]) linear_extrude(height=3) horizontal_rod_2d();
    }
    translate([-0.5, -250,20]) linear_extrude(height=3) base_comb_2d();
    color([0.9,0.2,0.0]) translate([-0.5-12, -240,-17]) rotate([0,-90,0]) linear_extrude(height=3) base_comb_support_2d();
    color([0.9,0.5,0.0]) translate([-0.5-15, -240+3+40,-17]) rotate([90,-90,0]) linear_extrude(height=3) base_comb_support_side_2d();
    color([0.9,0.2,0.0]) translate([-0.5+223, -240,-17]) rotate([0,-90,0]) linear_extrude(height=3) base_comb_support_2d();
    color([0.9,0.5,0.0]) translate([-0.5+223, -240+40,-17]) rotate([-90,-90,0]) linear_extrude(height=3) base_comb_support_side_2d();
}





translate([0,90,0]) input_assembly();
