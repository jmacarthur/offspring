// 6th iteration distributor, for 3D printers

include <globs.scad>;

// Generally, use small_pipe_diameter when location is important, otherwise large_pipe_diameter
large_pipe_diameter = 8;
small_pipe_diameter = 7;
pipe_diameter = large_pipe_diameter;

module mounting_holes() {
  for(x=[1,7]) translate([pitch*x-pitch/2, 15, -10]) cylinder(d=3, h=40);
}

module horizontal_mounting_holes() {
  for(x=[2,6]) translate([pitch*x-pitch/2, -1, 0]) rotate([-90,0,0]) cylinder(d=3, h=50);
}


module upward_curved_pipe() {
  translate([0,0,20]) 
  union() {
    rotate([-45,0,0]) rotate([0,90,0]) rotate_extrude(angle = 90) { translate([20,0]) circle(d=pipe_diameter); }
    rotate([45,0,0]) translate([0,-20,0]) sphere(d=pipe_diameter);
  }
}

module injector_arm() {
  difference() {
    union() {
      rotate([0,0,0]) rotate([0,90,0]) rotate_extrude(angle = 90) {
	intersection() {
	  translate([20,0]) circle(d=pipe_diameter-1);
	  translate([20-pipe_diameter/2,-1.5]) square([pipe_diameter, 3]);
	}
      }
      translate([-1.5,0,-2.5]) cube([3,40,5]);
      translate([-1.5,0,0]) rotate([0,90,0]) cylinder(d=6, h=3);
    }
  translate([-10,0,0]) rotate([0,90,0]) cylinder(d=3, h=20);
  }
}

module injector_arm_2() {
  difference() {
    union() {
      rotate([0,0,0]) rotate([0,90,0]) rotate_extrude(angle = 90) {
	intersection() {
	  translate([20,0]) circle(d=pipe_diameter-1);
	  translate([20-pipe_diameter/2,-1.5]) square([pipe_diameter, 3]);
	}
      }
      translate([-1.5,20,-2.5]) cube([3,20,5]);
      translate([-8,20,-2.5]) cube([16,5,5]);
      for(x=[-8, 8]) {
	translate([x-1.5,0,-2.5]) cube([3,25,5]);
	translate([x-1.5,0,0]) rotate([0,90,0]) cylinder(d=10, h=3);
	translate([x-1.5+(x>0?-3:0),0,0]) rotate([0,90,0]) cylinder(d=3, h=6);
      }

    }
  }
}


module feed_channel() {
  union() {
    hull() {
      sphere(d=pipe_diameter);
      translate([0,-10,10]) sphere(d=pipe_diameter);
    }
    translate([0,-10,10]) cylinder(d=pipe_diameter, h=10);
  }
}

module injector() {
  union() {
    difference() {
      translate([-pitch/2, 0, -1]) cube([pitch*8, 30, 13]);
      for(x=[0:7]) translate([pitch*x, 25, 5]) cylinder(d=small_pipe_diameter, h=20);
      for(x=[0:7]) translate([pitch*x, 11, -5]) cylinder(d=small_pipe_diameter, h=20);
      for(x=[0:7]) translate([pitch*x, 25, 5]) upward_curved_pipe();
      mounting_holes();
      translate([0,0,5]) horizontal_mounting_holes();
    }
    for(x=[0:7]) translate([pitch*x+2, 29, 0]) cube([3,1,10]);
    for(x=[0:7]) translate([pitch*x-5, 29, 0]) cube([3,1,10]);
  }
}

module block_2() {
  difference() {
    translate([-pitch/2, 0, 0]) cube([pitch*8, 30, 13]);
    for(x=[0:7]) translate([pitch*x,0,0]) {
	translate([0,25,0]) feed_channel();
	translate([-2.5,25,13]) rotate([0,90,0]) cylinder(d=7,h=5);
	translate([-2.5,25,7]) cube([5,10,10]);
	translate([-10,25,13]) rotate([0,90,0]) cylinder(d=3.5,h=20);
      }
    mounting_holes();
  }
}

module block_2b() {
  difference() {
    union() {
      for(x=[0:7]) translate([pitch*x,0,0]) {
	  translate([0,25,0]) cylinder(d=pipe_diameter+5, h=29);
	}
      translate([0,25-1.5,0]) cube([pitch*7,3,7]);
      for(x=[0,6]) translate([pitch*x,10,0]) cube([pitch,15,3]);
    }
    for(x=[0:7]) translate([pitch*x,0,0]) {
	translate([0,25,-1]) cylinder(d=pipe_diameter-1, h=31);
	translate([-10,25,13]) rotate([0,90,0]) cylinder(d=3.5, h=25);
	hull() {
	  translate([0,10,13]) rotate([0,90,90]) cylinder(d=3, h=25);
	  translate([0,10,23]) rotate([0,90,90]) cylinder(d=3, h=25);
	}
      }
    translate([-pitch/2,30,20]) cube([pitch*8,3,15]);
    mounting_holes();
  }
}

module block_3() {
  difference() {
    union() {
      translate([-pitch/2+4, 8, 5]) rotate([-90,0,0]) linear_extrude(height=small_pipe_diameter+6) polygon([[0,0], [pitch*8, -15], [pitch*8, 5], [0,5]]);
      translate([-pitch/2+4, 8, 0]) cube([pitch*8-4, 3, 30]);
            translate([-pitch/2+4, 8+small_pipe_diameter+3.5, 0]) cube([pitch*8-4, 3, 30]);
            translate([-pitch/2+4, 8, 0]) cube([3, 12, 30]);
    }
    for(x=[0:7]) translate([pitch*x, 15, -1]) cylinder(d=small_pipe_diameter, h=30);

    // I wanted to put a recess here to clip onto block_2b, but it becomes difficult to print.
    // for(x=[0:7]) translate([pitch*x, 15, -1]) cylinder(d=pipe_diameter+5.5, h=2);
  }
}

module returning_block() {
  // Move ball bearings back towards the base plate, to line up with memory
  difference() {
    union() {
      translate([-pitch/2, 0, 0]) cube([pitch*8, 30, 15]);
      for(x=[0:7]) translate([pitch*x, 21.5, -9]) {
	  cylinder(d=10,h=11);
	}
      translate([-pitch/2, 10, -3]) cube([pitch*8, 10, 5]);
    }
    for(x=[0:7]) translate([pitch*x, 21.5, -1]) {
	feed_channel();
      }

    for(x=[0:7]) translate([pitch*x, 21.5, -11]) {
	cylinder(d=7, h=11);
      }

    // Cutout for the back plate of the memory
    translate([-pitch/2-1, 28, -1]) cube([pitch*8+2, 4, 18]);

    // Cut out some more bits to suit memory
    translate([-pitch/2-1, 9, -10]) rotate([45,0,0]) cube([pitch*8+2, 10, 25]);
    translate([-pitch/2-1, -1, -10]) cube([6, 35, 28]);
    mounting_holes();

    for(x=[1,7]) translate([pitch*x-pitch/2, 15, -11]) cylinder(d=8, h=11);

  }
}

module mounting_plate_2d() {
  difference() {
    translate([-30,0]) square([300,50]);
    for(y=[10,40])  {
      translate([7.5,y]) circle(d=3);
      translate([250+7.5,y]) circle(d=3);
    }
    for(x=[0:7]) {
      offset(r=2) translate([x*pitch+data7_x-8, 24]) square([16,16]);
      translate([x*pitch+data7_x-5, 10]) square([10,31]);
    }
    for(x=[2,6]) {
      translate([x*pitch-pitch/2+data7_x, 15]) circle(d=3);
    }
  }
}


module distributor() {

  color([0,1,0]) translate([0,0,-10]) rotate([90,0,0]) linear_extrude(height=3) mounting_plate_2d();

  translate([data7_x,-33, 0]) {
    injector();
    translate([0,25,25]) rotate([-25,0,0]) injector_arm_2();
    
    color([1,0,0]) translate([0,0,12]) block_2b();
    translate([0,10,12+13+15]) block_3();
    
    color([1,0,0]) translate([0,0,-16]) returning_block();
  }
}

distributor();

// Indicate where memory input is

color([0,1,1]) translate([data7_x, -11.5, -50]) cylinder(d=ball_bearing_diameter, h=50);
