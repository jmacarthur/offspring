// This is a planar diverter, which is meant to be "More 2D" than previous attempts.
// It's based on the version used in the Box2D simulation.

// This also includes the regenerator.

include <globs.scad>;
include <generic_conrods.scad>;

diverter_rotate = -10+20*$t;
$fn=20;
module diverter_tab_2d(len) {
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
  for(i=[0:7]) {
    translate([0,i*pitch])
      rotate(diverter_rotate) diverter_tab_2d(30);
  }
}

module base_plate_2d()
{
  difference() {
    square([200,200]);
    for(i=[0:7]) {
      // Diverter axle
      translate([10,10+pitch*i]) circle(d=3);
      // Output holes
      translate([42,15+pitch*i]) circle(d=8);

      // Regen axle holes
      translate([60,14+pitch+pitch*i]) circle(d=6);
    }
  }
}

module exit_plate_2d()
{
  difference() {
    square([20,200]);
    for(i=[0:7]) {
      translate([15,26+pitch*i]) circle(d=8);
      translate([15,26+pitch*i-4]) square([8,8]);
    }
  }
}

module diverter_top_plate_2d() {
  difference() {
    square([20,200]);
    for(i=[0:7]) {
      // Diverter axle
      translate([10,10+pitch*i]) circle(d=3);
    }
  }
}

module diverter_slider_plate_2d() {
  difference() {
    square([20,220]);
    for(i=[0:7]) {
      translate([10,10+pitch*i]) circle(d=3);
      translate([10,8.5+pitch*i]) square([10,3]);
    }
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
      translate([0,0]) square([14,200]);
      for(i=[0:7]) {
	translate([9,16+pitch*i]) square([6,6+3.5]);
	translate([9,16+pitch*i]) square([11,6]);
      }
    }
    for(i=[0:7]) {
      translate([12+3.5,16+6+3.5+pitch*i]) circle(d=7);
    }
  }
}

module regen_assembly() {
  for(i=[0:7]) {
    color([0.75,0.5,0.5]) translate([50,pitch+4+i*pitch,0]) linear_extrude(height=3) regen_crank_2d();
  }
}

module planar_diverter_assembly()
{  
  linear_extrude(height=3) diverter_array_2d();
  color([0.5,0.5,0.5]) translate([-10,-10,-5]) linear_extrude(height=3) base_plate_2d();
  color([0.5,0.5,0.5]) translate([-10,-10,5]) linear_extrude(height=3) diverter_top_plate_2d();
  color([0.5,0.5,0.5]) translate([12,-10,5]) linear_extrude(height=3) diverter_slider_plate_2d();

  translate([36,-10,20-2]) rotate([0,90,0]) linear_extrude(height=3) exit_plate_2d();
  translate([62,-10,20-2]) rotate([0,90,0]) linear_extrude(height=3) regen_pusher_bar_2d();
  regen_assembly();
}

planar_diverter_assembly();

translate([63.5,15,2]) sphere(d=25.4/4, $fn=20);
