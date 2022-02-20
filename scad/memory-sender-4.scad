include <globs.scad>;

decoder_pitch = 10;

intake_slope = 10;
pipe_outer_diameter = 11;

$fn=20;

rod_x = ball_bearing_radius;
rod_y_offset = 10;

// Mounting details:
// For the sensor rods to line up, the first sensor rod hole (closest to the front) must be:
// Recessed 43mm from the front face of the angle iron/openbeam
// 82mm in +X from the rightmost face of the right openbeam

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


module sender_clamp() {
  difference() {
    clearance = 0.3;
    union() {
      intersection() {
	translate([10,0,-1]) cube([10,decoder_pitch*5+10,23]);
	// Cut off the base of the body so we can print this in two parts
	translate([0,rod_y_offset+clearance,7.5]) rotate([0,90-intake_slope,0]) union() {
	  translate([0,-pipe_outer_diameter/2,10]) cube([50, decoder_pitch*4+pipe_outer_diameter-clearance*2, 20]);
	}
	
      }
      // Base bar
      translate([10,-15,-7]) cube([10,decoder_pitch*5+40,6]);
    }

    // BB slots
    for(i=[0:4]) {
      translate([0,i*decoder_pitch+rod_y_offset,7.5]) rotate([0,90-intake_slope,0]) union() {
	translate([0,0,9]) cylinder(d=pipe_outer_diameter, h=110);
      }
    }
    translate([15,-10,-8]) cylinder(d=3,h=10);
    translate([15,70,-8]) cylinder(d=3,h=10);
  }
}

module mount_plate_common_holes() {
    // Mounting holes
    offset = 17.5;
    for(i=[0:1]) {
      translate([i*40-offset+rod_x, 1.5*decoder_pitch+rod_y_offset]) circle(d=4);
    }

    // Holes for pipe clamp
    translate([15,-10]) circle(d=3);
    translate([15,70]) circle(d=3);

    // Hole for release cable
    translate([-40,30]) circle(d=10);

    // Hole to mount to mounting block
    translate([-75+rod_x,-17]) circle(d=3);
    translate([-75+rod_x+15,-17]) circle(d=3);

    // Material-saving cutout
    translate([-130,0]) rotate(-25) square([50,120]);
    
}

module generic_plate_2d() {
  translate([-81+rod_x,-22]) hull() {
    square([100,100]);
    translate([100,22+1.5*decoder_pitch+rod_y_offset]) circle(d=20);
  }
}

module top_mounting_plate_2d() {
  difference() {
    generic_plate_2d();
    mount_plate_common_holes();

    // Holes for address rods
    for(i=[0:4]) {
      translate([rod_x,i*decoder_pitch+rod_y_offset]) circle(d=6);
    }
  }
}

module base_mounting_plate_2d() {
  difference() {
    generic_plate_2d();

    mount_plate_common_holes();
    //Drain hole for bearings
    translate([-20,5]) offset(r=1) square([20,50]);
  }
}

module plate_mounting_block() {
  clearance=0.1;
  difference() {
    translate([0,0,-25]) cube([25,20,60]);

    translate([-1,10-clearance,-12-clearance]) cube([35,20,5+clearance*2]);
    translate([-1,10-clearance,25-clearance]) cube([35,20,5+clearance*2]);

    // Material-saving cutout
    translate([-1,13,0]) cube([35,30,20]);
    translate([-1,10,3]) cube([35,30,14]);
    translate([-1,10+3,3]) rotate([0,90,0]) cylinder(r=3,h=35);
    translate([-1,10+3,20-3]) rotate([0,90,0]) cylinder(r=3,h=35);

    translate([5,15,-26]) cylinder(d=3+clearance*2,h=70);
    translate([20,15,0]) cylinder(d=3+clearance*2,h=70);
    
    
    translate([15,-1,-20]) {
      rotate([-90,0,0]) cylinder(d=6,h=50);
      translate([0,0,30]) rotate([-90,0,0]) cylinder(d=6,h=50);
    }
  }
}



module sender() {
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

    // Cut off the base of the body so we can print this in two parts
    translate([0,rod_y_offset,7.5]) rotate([0,90-intake_slope,0]) union() {
      translate([0,-pipe_outer_diameter/2,10]) cube([50, decoder_pitch*4+pipe_outer_diameter, 20]);
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

  translate([0,0,25]) color([0.1,0.1,0.1,0.5]) linear_extrude(height=5) top_mounting_plate_2d();
  translate([0,0,-12]) color([0.1,0.1,0.1,0.5]) linear_extrude(height=5) base_mounting_plate_2d();
  
  sender_clamp();

  translate([-80+rod_x,-32]) plate_mounting_block();

}

module positioned_sender() {
  translate([98-rod_x, 33,0]) sender();
}

positioned_sender();

// Fake Openbeam

cube([15,15,100]);


// Where the sensor should be
color([1,0,0]) translate([15+83, 43,0]) cylinder(d=3, h=100);


// where bolts go for angle iron

translate([15+18,0,0]) rotate([90,0,0]) cylinder(d=6,h=40);
