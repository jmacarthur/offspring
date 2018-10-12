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

module diverter_holes() {
  for(i=[0:8]) {
    // Diverter axle
    translate([10,10+pitch*i]) circle(d=3);
    // Output holes
    translate([42,15+pitch*i]) circle(d=8);
  }
}

module base_plate_2d()
{
  difference() {
    translate([-10,-10]) square([190,270]);
    for(i=[0:8]) {
      // Regen axle holes
      translate([60,14+pitch+pitch*i]) circle(d=6);
    }
    diverter_holes();
    translate([diverter_2_y,diverter_2_offset]) diverter_holes(); 
    translate([diverter_3_y,diverter_3_offset]) diverter_holes();

    // Mounting holes for openbeam
    translate([0,0]) circle(d=3);
    translate([0,250]) circle(d=3);


    // Mounting holes for diverter exit plates
    for(d=[0:2]) {
      offset = diverter_offsets()[d];
      offset_y = diverter_y[d];
      for(i=[0:7]) {
	translate([46+offset_y,offset+12+pitch*i]) square([3,5]);
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
    square([25,250]);
    for(i=[0:8]) {
      translate([10,15+pitch*i+offset]) circle(d=3);
      translate([10,13.5+pitch*i+offset]) square([15,3]);
    }
    translate([17,230]) rotate(90) cable_clamp_cutout_2d();
    translate([14.5,230]) square([bowden_cable_inner_diameter,30]);
  }
}


module regen_crank_2d()
{
  // Regen cranks use the same hexagon rods to transmit force as the subtractor.
  difference() {
    union() {
      translate([0,-8]) square([20,10]);
      circle(d=16);
    }
    hex_bar_2d();
  }
}

module regen_pusher_bar_2d() {
  difference() {
    union() {
      translate([-5,-10]) square([19,250]);
      for(i=[0:7]) {
	translate([9,16+pitch*i]) square([6,6+3.5]);
	translate([9,16+pitch*i]) square([11,6]);
      }
    }
    for(i=[0:7]) {
      translate([12+3.5,16+6+3.5+pitch*i]) circle(d=7);
    }

    translate([10,225]) rotate(90) cable_clamp_cutout_2d();
    translate([7.5,225]) square([bowden_cable_inner_diameter, 30]);
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
      translate([10-clearance,20+y]) square([3+clearance*2,27]);
      if(y==0) translate([10-clearance,30+y]) square([20,15]);
    }
    // Cutout for pusher rod
    translate([0,72-clearance]) square([14+clearance,3+clearance*2]);
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
      translate([10+1.5,y+36.5]) circle(d=bowden_cable_inner_diameter);
    }
    translate([8,72+1.5]) circle(d=bowden_cable_inner_diameter);
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
    color([0.75,0.5,0.5]) translate([50,pitch+4+i*pitch,0]) linear_extrude(height=3) regen_crank_2d();
  }
}

module m3_screw(length) {
  color([0.5,0.5,0.5]) {
    cylinder(d=3, h=length);
    translate([0,0,length-2]) cylinder(d=6,h=2);
  }
}

module planar_diverter_assembly()
{  
  linear_extrude(height=3) diverter_array_2d();
  translate([diverter_2_y,diverter_2_offset]) linear_extrude(height=3) diverter_array_2d();
  translate([diverter_3_y,diverter_3_offset]) linear_extrude(height=3) diverter_array_2d();
  color([0.5,0.5,0.5]) translate([-10,-10,-5]) linear_extrude(height=3) base_plate_2d();
  for(i=[0:2]) {
    color([0.5,0.8,0.5]) translate([diverter_y[i],-10,5]) linear_extrude(height=3) diverter_top_plate_2d(diverter_offsets()[i]);
  }

  for(i=[0:2]) {
    color([0.8,0.3,0.3]) translate([diverter_y[i]-1,-10+10*$t,0]) translate([12,-10,5]) linear_extrude(height=3) diverter_slider_plate_2d(diverter_offsets()[i]);
  }

  translate([36,-10,20-2]) rotate([0,90,0]) linear_extrude(height=3) exit_plate_2d(0);
  translate([diverter_2_y+36,-10,20-2]) rotate([0,90,0]) linear_extrude(height=3) exit_plate_2d(diverter_2_offset);
  translate([diverter_3_y+36,-10,20-2]) rotate([0,90,0]) linear_extrude(height=3) exit_plate_2d(diverter_3_offset);
  translate([66,-10,20-2]) rotate([0,90,0]) linear_extrude(height=3) regen_exit_plate_2d();
  translate([62,-10,20-2]) rotate([0,90,0]) linear_extrude(height=3) regen_pusher_bar_2d();
  color([0.5,0.5,0.5,0.5]) translate([42,-10,5]) linear_extrude(height=3) regen_top_plate_2d();
  
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
  
}

planar_diverter_assembly();

translate([63.5,15,2]) sphere(d=25.4/4, $fn=20);
