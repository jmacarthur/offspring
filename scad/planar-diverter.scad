// This is a planar diverter, which is meant to be "More 2D" than previous attempts.
// It's based on the version used in the Box2D simulation.

// This also includes the regenerator.

include <globs.scad>;
include <generic_conrods.scad>;
include <interconnect.scad>;
diverter_rotate = -10+20*$t;
$fn=20;

diverter_2_offset = 10;
diverter_2_y = 75;
diverter_3_offset = 15;
diverter_3_y = 120;

function diverter_offsets() = [0, diverter_2_offset, diverter_3_offset];
diverter_y = [0, diverter_2_y, diverter_3_y];
clearance=0.1;

// Animation settings
regen_pusher_translate = 6*$t;
regen_crank_rotate = 25*$t;

hex_axle_hole_diameter = 6;

bowden_cable_clearance = 0.5;
bowden_cable_hole_size = bowden_cable_inner_diameter+bowden_cable_clearance;

bowden_cable_clamp_width = 4;
bowden_cable_clamp_clearance = 0.5;

module diverter_tab_2d(len) {
  // This is a single diverter tab.
  difference() {
    union() {
      intersection() {
	translate([0,-5]) square([len+10,10]);
	translate([0,0]) circle(r=len+5);
      }
      polygon([[0,0], [len+5,0], [len+4,-5-3]]);
      translate([0,0]) circle(d=10);
    }
    translate([0,0]) circle(d=3);
    translate([len,0]) circle(d=3);
  }
}

module diverter_array_2d() {
  // This is a set of 9 diverter tabs.
  for(i=[0:8]) {
    translate([0,i*pitch])
      rotate(diverter_rotate) diverter_tab_2d(30);
  }
}

module output_holes(d) {
  for(i=[0:8]) {
    // Output holes
    translate([42,15+pitch*i]) circle(d=d);
  }
}

module diverter_holes() {
  for(i=[0:8]) {
    // Diverter axle
    translate([10,10+pitch*i]) circle(d=3);
  }
  output_holes(pipe_inner_diameter);
}

module diverter_edge_holes() {
  // Like the diverter holes, but only drill the first and last.
  // This is for mounting the pipe plate.
  for(i=[0,8]) {

    translate([10,10+pitch*i]) circle(d=3);
  }
  output_holes(pipe_inner_diameter);
}

module hex_axle_holes() {
  for(i=[0:7]) {
    // Regen axle holes
    translate([60,14+pitch+pitch*i]) circle(d=hex_axle_hole_diameter);
  }
}

module base_plate_2d()
{
  difference() {
    translate([-10,-10]) square([190,270]);
    hex_axle_holes();
    for(i=[0:2]) {
      translate([diverter_y[i], diverter_offsets()[i]]) diverter_holes();
    }
    // Mounting holes for openbeam
    translate([0,0]) circle(d=3);
    translate([0,250]) circle(d=3);


    // Mounting holes for diverter exit plates
    for(d=[0:2]) {
      offset = diverter_offsets()[d];
      offset_y = diverter_y[d];
      for(i=[0:7]) {
	translate([46+offset_y-2,offset+12+pitch*i]) square([5,5]);
      }
    }

    // Mounting holes for regen exit plate
    for(i=[0:7]) {
      translate([76,22+pitch*i]) square([3,6]);
    }


    // Mounting holes for side plate
    for(x=[0,223,253]) {
      for(i=[0:4]) {
	translate([10+i*40,-3+x]) square([5,3]);
      }
    }

    // Mounting holes for rear regen axle support
    translate([50,20]) square([5,3]);
    translate([65,20]) square([5,3]);
    translate([50,210]) square([5,3]);
    translate([65,210]) square([5,3]);
  }
}

module pipe_mounting_plate_2d()
{
  difference() {
    translate([75,10]) square([100,210]);
    hex_axle_holes();
    for(i=[0:2]) {
      translate([diverter_y[i], diverter_offsets()[i]]) output_holes(pipe_outer_diameter);
    }
    for(i=[0:2]) {
      translate([diverter_y[i], diverter_offsets()[i]]) diverter_edge_holes();
    }
  }
}

module exit_plate_2d(offset)
{
  difference() {
    union() {
      square([20,220]);
      for(i=[0:7]) {
	translate([15,offset+12+pitch*i]) square([5+3,5]);
      }
    }
    for(i=[0:7]) {
      translate([15,offset+26+pitch*i]) circle(d=8);
      translate([15,offset+26+pitch*i-4]) square([8,8]);
    }
  }
}

module regen_exit_plate_2d()
{
  difference() {
    union() {
      translate([0,0]) square([14,220]);
      for(i=[0:7]) {
	translate([9,20+pitch*i]) square([4,6+3.5]);
	translate([9,22+pitch*i]) square([11+3,6]);
      }
    }
    for(i=[0:7]) {
      translate([12+3.5,22+6+3.5+pitch*i]) circle(d=7);
    }
  }
}

module diverter_top_plate_2d(offset) {
  // This is the static plate which holes the top of all the diverters.
  difference() {
    union() {
      translate([-5,0]) square([16,220]);
      translate([-5,-3]) square([5,226]);
    }
    for(i=[0:8]) {
      // Diverter axle
      translate([0,10+offset+pitch*i]) circle(d=3);
    }
  }
}

module diverter_slider_plate_2d(offset) {
  difference() {
    union() {
      translate([0,-8]) square([25,258]);
      translate([-5,-8]) square([35,5]);
    }
    for(i=[0:8]) {
      translate([10,15+pitch*i+offset]) circle(d=3);
      translate([10,13.5+pitch*i+offset]) square([15,3]);
    }
    translate([17,230]) rotate(90) cable_clamp_cutout_2d();
    translate([14.5,230]) square([bowden_cable_hole_size,30]);
  }
}


module regen_crank_2d()
{
  // Regen cranks use the same hexagon rods to transmit force as the subtractor.
  difference() {
    union() {
      polygon([[0,-8], [0,8], [10,8], [10,0], [17,0], [19,-1], [19,-7]]);
      circle(d=16);
    }
    hex_bar_2d();
  }
}

module regen_output_2d()
{
  l1 = 30;
  difference() {
    union() {
      circle(d=10);
      rotate(45) translate([-3,-l1]) square([6,l1]);
      rotate(45) translate([0,-l1]) circle(d=6);
      rotate(45) translate([0,-l1]) rotate(-45) translate([-3,-15]) square([6,15]);
    }
    for(i=[0,2]) rotate(45) translate([0,-l1]) rotate(-45) translate([0,-5-3*i]) circle(d=2);
    hex_bar_2d();
  }
}

module hex_stopper_2d()
{
  difference() {
    circle(d=10);
    hex_bar_2d();
  }
}



module regen_pusher_bar_2d() {
  difference() {
    union() {
      translate([-5,-15]) square([19,255]);
      translate([-5,-15]) square([23,5]);
      translate([-5,223]) square([23,5]);
      for(i=[0:7]) {
	translate([9,16+pitch*i]) square([6,6+3.5]);
	translate([9,16+pitch*i]) square([11,6]);
      }
    }
    for(i=[0:7]) {
      translate([12+3.5,16+6+3.5+pitch*i]) circle(d=7);
    }

    translate([10,225]) rotate(90) cable_clamp_cutout_2d();
    translate([7.5,225]) square([bowden_cable_hole_size, 30]);
  }
}

module regen_top_plate_2d() {
  difference() {
    union() {
      square([20-clearance,220]);
      translate([0,-3]) square([5,226]);
    }
    for(i=[0:7]) {
      // Regen axle holes
      translate([8,14+pitch+pitch*i]) circle(d=6);
    }
  }
}

module side_plate_2d() {
  difference() {
    union() {
      translate([0,5]) square([20,170]);
      // Tabs to enter base plate
      for(i=[0:4]) {
	translate([0,10+i*40]) square([23,5]);
      }
    }
    // Cutout for diverter sliders
    for(y=diverter_y) {
      translate([10-bowden_cable_clamp_clearance,27+y]) square([bowden_cable_clamp_width+bowden_cable_clamp_clearance*2,15]);
      translate([10-clearance,20+y]) square([3+clearance*2,27]);
      if(y==0) translate([10-clearance,30+y]) square([20,15]);
    }
    // Cutout for pusher rod
    translate([0,72-clearance]) square([14+clearance,3+clearance*2]);

    // Holes to attach a clip to keep the regen pusher in place
    translate([4.5,72+10]) circle(d=3);
    translate([4.5,72-7]) circle(d=3);

    // Cutout for regen top
    translate([10,52]) square([3,5]);

    // Cutout for diverter static plate
    for(y=diverter_y) {
      translate([10,5+y]) square([3,5]);
    }
    // Cutout for bowden clip
    for(y=[10,88,150]) {
      translate([-1,y]) square([6,3]);
    }
  }
}

module bowden_plate_2d() {
  difference() {
    union() {
      translate([0,5]) square([20,170]);
      // Tabs to enter base plate
      for(i=[0:4]) {
	translate([0,10+i*40]) square([23,5]);
      }
    }
    for(y=diverter_y) {
      translate([10+1.5,y+36.5]) circle(d=bowden_cable_hole_size);
    }
    translate([8,72+1.5]) circle(d=bowden_cable_hole_size);
    for(y=[10,88,150]) {
      translate([-1,y]) square([6,3]);
    }

  }
}

module bowden_plate_clip_2d() {
  // This holds the bowden cable plate onto the other side plate.
  difference() {
    square([45,10]);
    translate([5,-1]) square([3,5]);
    translate([35,-1]) square([3,5]);
  }
}

module regen_assembly() {
  for(i=[0:7]) {
    color([0.75,0.5,0.5]) translate([50,pitch+4+i*pitch,0]) linear_extrude(height=3) rotate(regen_crank_rotate) regen_crank_2d();
    color([0.75,0.5,0.5]) translate([50,pitch+4+i*pitch,-15-5*(i%4)]) linear_extrude(height=3) rotate(regen_crank_rotate) regen_output_2d();
  }
}

module m3_screw(length) {
  color([0.5,0.5,0.5]) {
    cylinder(d=3, h=length);
    translate([0,0,length-2]) cylinder(d=6,h=2);
  }
}

module regen_support_2d() {
  difference() {
    square([20,8*pitch+9]);
    translate([5,-1]) square([10,4]);
    translate([-50,-20]) hex_axle_holes();
    translate([5,8*pitch+9-3]) square([10,4]);
  }
}

module regen_clip_2d() {
  clearance = 0.5;
  difference() {
    hull() {
      translate([13,4.5]) circle(d=8);
      translate([30,4.5]) circle(d=8);
      translate([21.5,16]) circle(d=8);
    }
    translate([20-clearance,-1]) square([3+clearance*2,16]);
    translate([13,4.5]) circle(d=3);
    translate([30,4.5]) circle(d=3);
  }
}

module regen_riser_2d() {
  difference() {
    union() {
      square([20,30]);
      translate([5,30-1]) square([10,4]);
    }
    translate([5,-1]) square([10,4]);
  }
}

module regen_bracket_assembly() {
  translate([40,10,0]) {
    translate([0,0,-35]) linear_extrude(height=3) regen_support_2d();
    color([1,0,0]) translate([0,0,-2]) rotate([-90,0,0]) linear_extrude(height=3) regen_riser_2d();
    color([1,0,0]) translate([0,8*pitch+9-3,-2]) rotate([-90,0,0]) linear_extrude(height=3) regen_riser_2d();
  }
}

module planar_diverter_assembly()
{
  linear_extrude(height=3) diverter_array_2d();
  translate([diverter_2_y,diverter_2_offset]) linear_extrude(height=3) diverter_array_2d();
  translate([diverter_3_y,diverter_3_offset]) linear_extrude(height=3) diverter_array_2d();
  color([0.5,0.5,0.5]) translate([-10,-10,-5]) linear_extrude(height=3) base_plate_2d();
  color([0.5,0.0,0.0,0.5]) translate([-10,-10,-10]) linear_extrude(height=3) pipe_mounting_plate_2d();
  for(i=[0:2]) {
    color([0.5,0.8,0.5]) translate([diverter_y[i],-10,5]) linear_extrude(height=3) diverter_top_plate_2d(diverter_offsets()[i]);
  }

  for(i=[0:2]) {
    color([0.8,0.3,0.3]) translate([diverter_y[i]-1,-10+10*$t,0]) translate([12,-10,5]) linear_extrude(height=3) diverter_slider_plate_2d(diverter_offsets()[i]);
  }

  for(i=[0:2]) {
    translate([36+diverter_y[i],-10,20-2]) rotate([0,90,0]) linear_extrude(height=3) exit_plate_2d(diverter_offsets()[i]);
  }
  translate([66,-10,20-2]) rotate([0,90,0]) linear_extrude(height=3) regen_exit_plate_2d();
  color([1.0,1.0,0.0,0.2]) translate([62,-10+regen_pusher_translate,20-2]) rotate([0,90,0]) linear_extrude(height=3) regen_pusher_bar_2d();
  color([0.5,0.5,0.5,0.5]) translate([42,-10,5]) linear_extrude(height=3) regen_top_plate_2d();

  translate([42,-13,9]) rotate([90,0,0]) linear_extrude(height=3) regen_clip_2d();
  translate([42,210,9]) rotate([90,0,0]) linear_extrude(height=3) regen_clip_2d();

  regen_assembly();

  for(x=[0,223]) {
    color([0.4,0.4,0.8]) translate([-10,-10+x,18]) rotate([90,90,0]) linear_extrude(height=3) side_plate_2d();
  }

  color([0.4,0.4,0.8]) translate([-10,-10+253,18]) rotate([90,90,0]) linear_extrude(height=3) bowden_plate_2d();
  for(y=[10,88,150]) {
    color([1.0,0.3,1.0]) translate([y-10,210-5,18]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) bowden_plate_clip_2d();
  }

  // Add screws
  for(i=[0:2]) {
    for(j=[0:7]) {
      translate([diverter_y[i], diverter_offsets()[i]+pitch*j,0]) m3_screw(20);
    }
  }

  // Regen back bracket
  regen_bracket_assembly();
}


// Angle clips which hold the whole diverter at an angle, to allow easier exit through pipes.
module angle_clip()
{
  slope = 5; // Degrees
  rotate([0,slope,0])
    difference() {
    union() {
      translate([0,10,0]) rotate([90,0,0]) linear_extrude(height=10) {
	polygon([[0,0],[20,0], [20,15-5*sin(slope)], [0,15-20*sin(slope)]]);
      }
      cube([40,10,3]);
      translate([20,0,0]) rotate([0,-slope*2,0]) cube([3,10,20]);
    }
    translate([30,5,-1]) cylinder(d=3,h=10);
  }
}


planar_diverter_assembly();

translate([170,-20,-20]) angle_clip();
translate([170,220,-20]) angle_clip();

translate([63.5,15+regen_pusher_translate,2]) sphere(d=25.4/4, $fn=20);
