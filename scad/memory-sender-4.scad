include <globs.scad>;

decoder_pitch = 10;

intake_slope = 10;
pipe_outer_diameter = 10.5;

$fn=20;

module hold_release_lever() {
  difference() {
    union() {
      translate([-20,0,0]) cube([40-1.5,5*decoder_pitch,3]);
      translate([20-1.5,0,1.5]) rotate([-90,0,0]) cylinder(d=3,h=5*decoder_pitch, $fn=20);
      rotate([-90,0,0]) cylinder(d=10,h=5*decoder_pitch);
      intersection() {
	i = 12;
	rotate([-90,0,0]) cylinder(d=i*2,h=5*decoder_pitch);
	translate([-i,0,0]) cube([i*2,5*decoder_pitch,i]);
      }
      rotate([0,-109,0]) cube([20,5*decoder_pitch,3]);
    }
    rotate([-90,0,0]) translate([0,0,-1]) cylinder(d=3,h=5*decoder_pitch+2);
    translate([-16,2.5*decoder_pitch,-1]) cylinder(d=3,h=10);
  }
}

module release_lever_bracket() {
  translate([0,3,0]) rotate([90,0,0]) linear_extrude(height=3) {
    //square([30,23]);

    hull() {
      translate([5,6]) circle(d=10);
      translate([0,20]) square([30,3]);
    }
    
  }
}


module sender() {
  rod_x = ball_bearing_radius;
  rod_y_offset = 10;
  difference() {
    union() {
      // Main body
      translate([0,0,0]) cube([20,decoder_pitch*5+10,23]);

      // Mounting plate
      translate([0,0,22]) linear_extrude(height=3) hull() {
	translate([-25,0]) square([45,60]);
	translate([rod_x+22.5, rod_y_offset+decoder_pitch*1.5]) circle(d=15);
	translate([rod_x-17.5, rod_y_offset+decoder_pitch*1.5]) circle(d=15);
      }

      // Plates to mount release lever
      clearance = 0.5;
      for(y=[-clearance,5*decoder_pitch+3+clearance]) {
	translate([-25,y+rod_y_offset-8,0]) {
	  release_lever_bracket();
	}
      }
    }

    // Holes for address rods
    for(i=[0:4]) {
      translate([rod_x,i*decoder_pitch+rod_y_offset,-1]) cylinder(d=3.5, h=102);
    }

    // BB slots
    for(i=[0:4]) {
      translate([0,i*decoder_pitch+rod_y_offset,7.5]) rotate([0,90-intake_slope,0]) union() {
	translate([0,0,-5]) cylinder(d=8, h=110);
	translate([0,0,10]) cylinder(d=pipe_outer_diameter, h=110);
      }
    }

    // Mounting holes
    offset = 17.5;
    for(i=[0:1]) {
      translate([i*40-offset+rod_x, 1.5*decoder_pitch+rod_y_offset, -4]) cylinder(d=4,h=102);
    }

    // Hole for release axle
    translate([-20,rod_y_offset-10,7.5-1.5]) rotate([-90,0,0]) cylinder(d=3,h=100);

  }

  color([1,0,0]) translate([-20,rod_y_offset-5,7.5-1.5]) hold_release_lever();
}

sender();
//hold_release_lever();
