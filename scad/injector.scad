/* Ball bearing injector, mk 2 */

include <globs.scad>;

ball_bearing_diameter = 6.35; // Overrides globs.

$fn = 20;

// Distance between raiser slots
slot_distance = ball_bearing_diameter * 30;

columns = 8;
centre_x = ball_bearing_diameter*16;

module injector_tray() {
       offset = 8;
       hole_diameter = ball_bearing_diameter*1.1;
  difference() {
    square([columns*pitch+20,20]);
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
    square([35,60]);
    // Axis for holder
    translate([70-54-5-ball_bearing_diameter/2,10]) {
      circle(d=3);
      // Make a slot allowing the catcher plate to rotate
      hull() {
	fudge =2;
	rotate(-10) translate([-1.5,5]) square([3,20+fudge]);
	rotate(10) translate([-1.5,5]) square([3,20+fudge]);
      }
    }

    // Axis for injector cranks
    translate([70-54+13,10+42]) circle(d=3);

    // Slots for mounting a stage2 distributor
    translate([5,40]) {
      rotate(5) {
	square([3,50]);
	translate([10,0]) square([3,50]);
      }
    }
  }
}

module input_plate()
{
  slot_width = 3.4;
  difference() {
    square([columns*pitch+20,30]);
    for(x=[1:columns])
      translate([x*pitch-slot_width/2, -1]) square([slot_width, 16]);
  }
}

/* -------------------- 3D Assembly -------------------- */

module injector_assembly() {
  tray_rotate = 45;
  translate([0,-30,25]) {
    rotate([-tray_rotate,0,0]) {
      rotate([0,0,0]) rotate([90,0,0]) translate([0,5,-1.5]) linear_extrude(height=3) injector_tray();
      rotate([90,0,0]) rotate([0,90,0]) translate([0,0,10]) linear_extrude(height=3) injector_tray_support();
      rotate([90,0,0]) rotate([0,90,0]) translate([0,0,columns*pitch-10]) linear_extrude(height=3) injector_tray_support();
    }
    rotate([-45,0,0]) {
    color([1.0,0,0]) rotate([90,0,0]) translate([0,13,-6]) linear_extrude(height=3) input_plate();
    }
  }
  for(x=[1:columns]) {
    translate([x*pitch-1.5,13,42]) rotate([0,90,0]) linear_extrude(height=3) injector_crank();
  }
}


translate([centre_x - (columns*pitch/2),-54,-170]) injector_assembly();

// Axis for injector tray
translate([-300,-54-5-ball_bearing_diameter/2,-170]) rotate([0,90,0]) cylinder(d=3,h=500);

// Axis for injector cranks
translate([-300,-54+13,-170+42]) rotate([0,90,0]) cylinder(d=3,h=500);

translate([-310,-70,-180]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) end_plate();

// Output bearings in the injector assembly, for reference
for(x=[1:columns]) {
		   //  translate([10 + pitch*x, -70,-130]) sphere(d=ball_bearing_diameter);
}

