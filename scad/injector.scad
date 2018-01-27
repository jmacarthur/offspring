/* Ball bearing injector, mk 2 */

include <globs.scad>;

ball_bearing_diameter = 6.35; // Overrides globs.

$fn = 20;

// Distance between raiser slots
slot_distance = ball_bearing_diameter * 30;

columns = 8;
centre_x = ball_bearing_diameter*16;
support_positions = [10, columns*pitch-10];
module injector_tray() {
  offset = 8;
  hole_diameter = ball_bearing_diameter*1.1;
  difference() {
    translate([0,-3])
      square([columns*pitch+20,23]);
    for(z=support_positions) {
      translate([z,-4]) square([3,4]);
    }
    for(x=[1:columns]) {
      translate([x*pitch,0]) polygon(points = [[-pitch/2+offset,20],[pitch/2+offset,20], [hole_diameter/2,15], [-hole_diameter/2,15]]);
      translate([x*pitch,15]) circle(d=hole_diameter);
    }
  }
}

module injector_tray_support() {
  difference() {
    polygon(points = [ [-5,-5], [-5,5], [0,15], [5,5], [5,-5] ]);
    translate([-1.5,5]) square([3,10]);
    circle(d=3);
  }
}

module injector_crank() {
  difference() {
    union() {
      rotate(-45) translate([0,-5]) square([25,10]);
      translate([-5,-5]) square([10,30]);
      rotate(-45) translate([20,-15]) square([5,20]);
    }
    circle(d=3);
  }
}

module end_plate() {
  difference() {
    square([60,60]);
    // Axis for holder
    translate([6,35]) {
         circle(d=3);
    }

    // Axis for injector cranks
    translate([70-21,10+42]) circle(d=3);

    // Holes for input plate tabs
    rotate(45) translate([52,14.5]) square([10,3]);
    // Holes for separator plate tabs
    translate([6+1.5,15]) rotate(90) square([10,3]);

  }
}

module input_plate()
{
  slot_width = 3.4;
  difference() {
    union() {
      translate([-3,10]) square([columns*pitch+20+6,10]);
      square([columns*pitch+20,30]);
    }
    for(x=[1:columns])
      translate([x*pitch-slot_width/2, -1]) square([slot_width, 16]);
  }
}

module separator_plate()
{
	difference() {
	union() {
          translate([-3,5]) square([columns*pitch+26,10]);
          square([columns*pitch+20,23]);
	}
	for(z=support_positions) {
	  translate([z-0.5,15]) square([4,10]);
	}
	}
}

/* -------------------- 3D Assembly -------------------- */

module injector_assembly() {
  tray_rotate = 45;
  translate([0,-30,25]) {
    rotate([-tray_rotate,0,0]) {
      rotate([0,0,0]) rotate([90,0,0]) translate([0,5,-1.5]) linear_extrude(height=3) injector_tray();
      for(z=support_positions) {
        rotate([90,0,0]) rotate([0,90,0]) translate([0,0,z]) linear_extrude(height=3) injector_tray_support();
      }
    }
    rotate([-45,0,0]) {
      color([1.0,0,0]) rotate([90,0,0]) translate([0,13,-6]) linear_extrude(height=3) input_plate();
    }
  }
  translate([0,-25-3,0]) rotate([90,0,0]) linear_extrude(height=3) separator_plate();
  for(x=[1:columns]) {
    translate([x*pitch-1.5,13,42]) rotate([0,90,0]) linear_extrude(height=3) injector_crank();
  }
}


translate([centre_x - (columns*pitch/2),-54,0]) injector_assembly();

// Axis for injector tray
translate([-300,-84,25]) rotate([0,90,0]) cylinder(d=3,h=500);

// Axis for injector cranks
translate([-300,-54+13,42]) rotate([0,90,0]) cylinder(d=3,h=500);

//translate([0,-90,-10]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) end_plate();
translate([columns*pitch+31,-90,-10]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) end_plate();

// Output bearings in the injector assembly, for reference
for(x=[1:columns]) {
  translate([10 + pitch*x, -70,40]) sphere(d=ball_bearing_diameter);
}

// Waste channel - 20mm u-channel?
translate([25,-78,0])
rotate([0,3,0]) 
difference() {
  cube([180,20,20]);
  translate([-1,2,2]) cube([300,16,20]);
}