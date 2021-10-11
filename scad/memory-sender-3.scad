include <globs.scad>;
use <generic_conrods.scad>;

use <interconnect.scad>;

memory_rod_spacing = 10;
memory_travel = 14;
$fn=20;
clearance = 0.1;
bump = 1;


// Mounting relative to openbeam
hole_to_mid_openbeam_x = 92;
hole_to_frontplate_y = 41.5;


module mounting_holes() {
    translate([30-20,memory_rod_spacing*2.5]) circle(d=4);
    translate([30+20,memory_rod_spacing*2.5]) circle(d=4);
}

module sender_centre_plate_2d()
{
  union() {
    difference() {
      square([40,60]);
      for(i=[0:4]) {
	offset(clearance) {
	  translate([25,memory_rod_spacing*i+10]) {
	    hull() {
	      circle(d=ball_bearing_diameter);
	      // Add a small drop to keep the bearing in place.
	      translate([bump,0]) circle(d=ball_bearing_diameter);
	    }
	    translate([-30,-1.5]) square([40,3]);
	  }
	}
      }
    }
    for(i=[0:5]) {
      translate([-4,memory_rod_spacing*i+5-1.5]) {
	square([10,3]);
      }
    }
  }
}

module front_plate_2d() {
  union() {
    difference() {
      square([35,60]);
      for(i=[0:4]) {
	translate([25,memory_rod_spacing*i+10]) {
	  circle(d=pipe_outer_diameter);
	}
      }
    }
    translate([-4,10]) square([5,10]);
    translate([-4,40]) square([5,10]);
  }
}

module ejector_plate_2d() {
  union() {
    difference() {
      translate([6,0]) square([24,60]);
      offset(clearance) {
	for(i=[0:4]) {
	  translate([30+bump,memory_rod_spacing*i+10]) {
	    circle(d=ball_bearing_diameter);
	  }
	}
	translate([30+bump, 10-ball_bearing_radius]) square([20,memory_rod_spacing*4+ball_bearing_diameter]);
      }
      translate([10,25]) cable_clamp_cutout_with_cable_2d();
    }
    translate([-20,10]) square([35,10]);
    translate([-20,40]) square([35,10]);
 }
}


module top_plate_cutout_2d() {
    mounting_holes();

    offset(clearance) {
      for(i=[0:4]) {
	translate([30+1.5,memory_rod_spacing*i+10]) {
	  circle(d=3);
	}
      }
    }
    for(i=[0:5]) {
      translate([30,memory_rod_spacing*i+5-1.5]) {
	square([3,3]);
      }
    }
    offset(clearance) {
      translate([35,10]) square([3,10]);
      translate([35,40]) square([3,10]);
    }
    translate([25,10]) square([3,10]);
    translate([25,40]) square([3,10]);
    translate([35+1.5,26.5]) circle(d=bowden_cable_inner_diameter);

}

module top_plate_2d() {
  difference() {
    offset(5) hull() top_plate_cutout_2d();
    top_plate_cutout_2d();
  }
}

module lower_layer_cutout_2d() {
  translate([25,0]) square([3,60]);
  translate([30,0]) square([3,60]);
  translate([25,3]) square([20,54]);
  translate([30+20,memory_rod_spacing*2.5]) circle(d=4);
}

module mid_plate_2d() {
  difference() {
    offset(5) hull() {
      mounting_holes();
      translate([25,0]) square([10,60]);
    }
    translate([25,3]) square([13,54]);
    translate([25,0]) square([3,60]);
    translate([30,0]) square([3,60]);
    translate([35,0]) offset(clearance) square([3,60]);
    translate([33,24]) square([7,12]);
    mounting_holes();
  }
}

module lower_layer_2d() {
  difference() {
    offset(5) hull() {
      lower_layer_cutout_2d();
    }
    lower_layer_cutout_2d();
  }
}

module mounting_plate_2d() {
  difference() {
    translate([-40,10-hole_to_frontplate_y+1]) square([100,70]);
    translate([-16,10-hole_to_frontplate_y+1+10]) circle(d=3);
    translate([-31,10-hole_to_frontplate_y+1+25]) circle(d=3);
    translate([20,0]) square([20,100]);
    top_plate_cutout_2d();
  }
}

module mounting_bracket() {
  difference() {
    union() {
      cube([15,15,50]);

      intersection() {
	translate([0,0,20]) cube([35,35,10]);
	cylinder(r=40,h=50);
      }
      translate([0,0,15]) cube([20,20,20]);
    }
    for(z=[10,40]) {
      translate([7.5,-1,z]) rotate([-90,0,0]) cylinder(d=6,h=50);
    }

    for(z=[15,35]) {
      translate([20,-1,z]) rotate([-90,0,0]) cylinder(r=5,h=100);
      translate([20,20,z]) rotate([0,0,90]) rotate([-90,0,0]) cylinder(r=5,h=100);
    }
    translate([-1,-1,25-2.5]) cube([50,50,5]);

    translate([25,10,-1]) cylinder(d=3,h=100);
    translate([10,25,-1]) cylinder(d=3,h=100);
  }
}

color([0.5,0.5,0.5]) rotate([0,90,0]) linear_extrude(height=3) sender_centre_plate_2d();
color([0.8,0.5,0.5]) translate([-5,0,0]) rotate([0,90,0]) linear_extrude(height=3) front_plate_2d();
translate([5,0,6]) rotate([0,90,0]) linear_extrude(height=3) ejector_plate_2d();


translate([-30,0,3]) color([0,1,0]) linear_extrude(height=5) mounting_plate_2d();
translate([-30,0,0]) linear_extrude(height=3) top_plate_2d();
translate([-30,0,-15]) linear_extrude(height=3) mid_plate_2d();
translate([-30,0,-35]) linear_extrude(height=3) lower_layer_2d();

// Fake OpenBeam
translate([1.5-7.5-hole_to_mid_openbeam_x,10-41.5,-50]) color([0.5,0.5,0.5]) cube([15,15,100]);

// Fake Perf Angle iron

translate([1.5+7.5-hole_to_mid_openbeam_x,10-hole_to_frontplate_y,-50])
difference() {
  cube([27,27,100]);
  translate([1,1,-1]) cube([27,27,102]);
  #translate([19.5,-1,10]) rotate([-90,0,0]) cylinder(d=6,h=10);
}

translate([-7.5+1.5-hole_to_mid_openbeam_x+7.5+19.5, -hole_to_frontplate_y+10+1,-19.5]) mounting_bracket();
