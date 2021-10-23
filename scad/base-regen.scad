include <globs.scad>;

radius = 40;
input_arc_thickness = 5;

input_x = 48; // Position of input relative to left edge of openbeam; 48 matches subtractor

centre_x = input_x-10; // Centre line for arms

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


module input_arc_2d() {
  difference() {
    union() {
      sector_2d(radius-5, radius+3, 90);
      sector_2d(radius-10, radius+3, 70);
      translate([10,-5]) square([radius-10+3+20, 10]);
      translate([10,-5]) square([radius-10+3+25, 5]);
    }

    // Angle the end to hold the bearing in place durig push
    polygon([[0,radius-5], [3, radius+3], [0, radius+3]]);
    translate([15,0]) circle(d=3);
    translate([35,0]) circle(d=3);
  }
}

module input_arc()
{
  rotate([-90,0,0]) linear_extrude(height=input_arc_thickness) input_arc_2d();
}

module output_arc_2d() {
  arc = 80;
  difference() {
    union() {
      sector_2d(radius-3, radius+3, arc);
      rotate(10) sector_2d(radius-6, radius+3, arc-10);
      rotate(arc) translate([0,-5]) square([radius+3+40, 10]);
      circle(d=10);
    }

    for(x=[0:5]) {
      rotate(arc) translate([radius+3+x*5+10,-6]) square([1,3]);
      rotate(arc) translate([radius+3+x*5+10,3]) square([1,3]);
    }

    circle(d=3);
  }
}

module output_arc()
{
  rotate([0,100,0]) rotate([-90,0,0]) linear_extrude(height=3) output_arc_2d();
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

module backing_plate_2d(shift) {
  difference() {
    translate([0, 0]) square([250+15,41]);
    for(x=[0,250]) {
      translate([7.5+x,10]) circle(d=3);
      translate([7.5+x,30]) circle(d=3);
    }
    translate([shift,0]) {
      for(i=[0:7]) {
	translate([centre_x-2+pitch*i, 11]) offset(r=1) square([4,18]);
      }
      for(i=[1,6]) {
	translate([centre_x+pitch*i+pitch/2, 10]) circle(d=3);
      }
    }
  }
}

module backing_plate(shift) {
  rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) backing_plate_2d(shift);
}

module housing() {
  height = 17;
  depth = 50;
  difference() {
    union() {
      translate([-depth/2,0,-radius-6]) cube([depth,pitch*8+9,height]);

      // Axle posts
      hull() {
	translate([-10,0,-radius-5]) cube([20,pitch*8+5,10]);
	rotate([-90,0,0]) cylinder(d=10,h=pitch*8+5);
      }
      // Catchment area
      for(i=[0:7]) {
	difference() {
	  translate([-depth/2,pitch/2+pitch*i,-40]) cube([20,20,20]);
          // Drain cone, +Y
          translate([0,pitch/2+pitch*i,0]) rotate([-90,0,0]) cylinder(h=18, r1=radius-7, r2=radius-11, $fn=200);
	}
      }
    }
    for(i=[0:7]) {
      // Main channel
      translate([0,pitch/2+pitch*i-3.5,0]) rotate([-90,0,0]) cylinder(h=7, r=radius+4, $fn=200);

      // Drain cone, +Y
      translate([0,pitch/2+pitch*i,0]) rotate([-90,0,0]) cylinder(h=12, r1=radius-3, r2=radius-10, $fn=200);
      // Spacing cylinder, -Y
      translate([0,pitch/2+pitch*i-7,0]) rotate([-90,0,0]) cylinder(h=5, r=22, $fn=200);
    }

    
    // Drain holes
    for(i=[0:7]) {
      translate([0,pitch/2+pitch*i-3.5,-radius-10-1]) cube([7,7,20]);
    }

    // Assistance slope for the drain holes
    for(i=[0:7]) {
      translate([-7,pitch/2+pitch*i-3.5,-radius-4+0.4]) rotate([0,10,0]) cube([8,7,7]);
    }
    // Axle hole
    translate([0,-5,0]) rotate([-90,0,0]) cylinder(d=3.2, h=pitch*8+50);

    // Mounting holes
    for(i=[2,7]) {
        #translate([-26, pitch*i, -radius-6+10]) rotate([0,90,0]) cylinder(d=3, h=20);
    }

  }
}

module base_regen(shift)
{
  translate([0,shift,0]) {
    translate([0,centre_x-pitch/2,0]) housing();
    for(i=[0:7]) {
      translate([0,centre_x+pitch*i-1.5,0]) output_arc();
      color([0,1,0]) translate([0,centre_x+pitch*i-input_arc_thickness/2,0]) input_arc();
      
      translate([0, centre_x+pitch*i-input_arc_thickness/2,0]) rotate([90,0,0]) linear_extrude(height=3) input_coupler_2d();
      translate([0, centre_x+pitch*i+input_arc_thickness/2+3,0]) rotate([90,0,0]) linear_extrude(height=3) input_coupler_2d();
    }
    translate([-3.5,centre_x,-35]) sphere(r=ball_bearing_radius, $fn=40);
  }
  color([0,1,0]) translate([-25-3,0,-radius-6]) backing_plate(shift);

}

// Illustrate data
color([1,0,0]) translate([0,input_x,0]) cylinder(r=1, h=100);

base_regen(0);
