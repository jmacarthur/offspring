// Bowden cable interconnect module

include <globs.scad>;

slider_body_length = 22;

module bowden_cable_stator()
{
  difference() {
    stator_length = slider_body_length+5+bowden_cable_travel+15;
    square([stator_length,28]);
    translate([10,10.5]) square([60,bowden_cable_inner_diameter]);
    translate([stator_length-5,10.5+bowden_cable_inner_diameter/2-bowden_cable_outer_diameter/2]) square([60,bowden_cable_outer_diameter]);
    translate([10,5]) square([slider_body_length+bowden_cable_travel,18]);

    // Mounting holes
    for(x=[5,stator_length-5]) {
      for(y=[5,28-5]) {
	translate([x,y]) circle(d=3,$fn=10);
      }
    }
  }
}

module stator_clamp()
{
  difference() {
    square([10,28]);
    for(y=[5,28-5]) {
      translate([5,y]) circle(d=3,$fn=10);
    }
  }
}

connector_inner_diameter = 2.5;
connector_width = 3.9;
connector_body_height = 4.5;
connector_total_height = 8; // That varies with compression of the cable
connector_length = 10;
peg_spacing = 5.6;
peg_top_diameter = 3.4;
peg_thread_diameter = 2.4;

module cable_clamp_cutout_2d() {
  union() {
    square([connector_length, connector_body_height]);
    for(side = [-1,1]) {
      translate([connector_length/2 + side*peg_spacing/2 - peg_thread_diameter/2,0]) square([peg_thread_diameter,connector_total_height]);
      translate([connector_length/2 + side*peg_spacing/2 - peg_top_diameter/2,connector_total_height-2]) square([peg_top_diameter,2]);
    }
  }
}

module cable_connector_2d()
{
  union() {
    difference() {
      square([slider_body_length,18]);
      translate([8,5]) {
	cable_clamp_coutout_2d();
	// exit path for cable
	translate([0,0.5]) square([50,bowden_cable_inner_diameter]);
      }
      // Drive hole
      translate([4,5.5+bowden_cable_inner_diameter/2]) circle(d=3, $fn=10);
    }
  }
}

