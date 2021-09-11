include <globs.scad>;

radius = 50;
input_arc_thickness = 5;
module sector_2d(min_radius, max_radius, degrees)
{
  // degrees must be <= 90
  intersection() {
    difference() {
      circle(r=max_radius);
      circle(r=min_radius);
      rotate(degrees) square([max_radius+1, max_radius+1]);
    }
    square([max_radius+1, max_radius+1]);
  }
  
}


module input_arc()
{
  rotate([-90,0,0]) linear_extrude(height=input_arc_thickness) {
    difference() {
      union() {
	sector_2d(radius-5, radius+3, 90);
	translate([10,-5]) square([radius-10+3+10, 10]);
      }

      // Angle the end to hold the bearing in place durig push
      polygon([[0,radius-5], [3, radius+3], [0, radius+3]]);
      translate([15,0]) circle(d=3);
      translate([35,0]) circle(d=3);
    }
  }
}

module output_arc()
{
  arc = 80;
  rotate([0,100,0]) rotate([-90,0,0]) linear_extrude(height=3) difference() {
    union() {
      sector_2d(radius-3, radius+3, arc);
      rotate(arc) translate([0,-5]) square([radius+3+30, 10]);
      circle(d=10);
    }
    circle(d=3);
  }
}

module input_coupler_2d() {
  difference() {
    union() {
      translate([0,-5]) square([45,10]);
      circle(d=10);
    }
    translate([15,0]) circle(d=3);
    translate([35,0]) circle(d=3);
    circle(d=3);
  }
}


module housing() {
  difference() {
    union() {
      translate([-50,0,-70]) cube([100,pitch*8,40]);
      translate([-10,0,-70]) cube([20,pitch*8,80]);
    }
    for(i=[0:7]) {
      translate([0,pitch/2+pitch*i-3.5,0]) rotate([-90,0,0]) cylinder(h=7, r=radius+4, $fn=200);
      translate([0,pitch/2+pitch*i-7,0]) rotate([-90,0,0]) cylinder(h=14, r=30, $fn=200);
    }

    // Drain holes
    for(i=[0:7]) {
      translate([0,pitch/2+pitch*i-3.5,-71]) cube([7,7,20]);
    }

    // Assistance slope for the drain holes
    for(i=[0:7]) {
      translate([-7,pitch/2+pitch*i-3.5,-radius-4+0.4]) rotate([0,10,0]) cube([8,7,7]);
    }
    // Axle hole
    translate([0,-5,0]) rotate([-90,0,0]) cylinder(d=3.2, h=pitch*8+50);
  }
}


module base_regen()
{
  housing();
  for(i=[0:7]) {
    translate([0,pitch/2+pitch*i-1.5,0]) output_arc();
    color([0,1,0]) translate([0,pitch/2+pitch*i-input_arc_thickness/2,0]) input_arc();

    translate([0, pitch*i+pitch/2-input_arc_thickness/2,0]) rotate([90,0,0]) linear_extrude(height=3) input_coupler_2d();
    translate([0, pitch*i+pitch/2+input_arc_thickness/2+3,0]) rotate([90,0,0]) linear_extrude(height=3) input_coupler_2d();
  }
  translate([-3.5,pitch/2,-48]) sphere(r=ball_bearing_radius, $fn=40);
}
  
base_regen();
