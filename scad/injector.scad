/* Ball bearing injector, mk 2 */

include <globs.scad>;

ball_bearing_diameter = 6.35; // Overrides globs.

$fn = 20;

// Distance between raiser slots
slot_distance = ball_bearing_diameter * 30;

centre_x = ball_bearing_diameter*16;
stage2_total_width = 33*pitch;
stage2_half_width = stage2_total_width/2;

module injector_tray() {
  difference() {
    square([stage2_total_width,20]);
    for(x=[1:32]) {
      translate([x*pitch,0]) polygon(points = [[-pitch/2,20],[pitch/2,20], [0,10]]);
    }
  }
}

module injector_tray_support() {
  difference() {
    polygon(points = [ [-10,-5], [-10,5], [0,15], [10,5], [10,-5] ]);
    translate([-1.5,5]) square([3,10]);
    circle(d=3);
  }
}

module injector_crank() {
  difference() {
    union() {
      translate([-5,-5]) square([30,10]);
      translate([-5,-5]) square([10,30]);
      translate([20,-15]) square([5,20]);
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
/* -------------------- 3D Assembly -------------------- */

module injector_assembly() {
  tray_rotate = 10;
  translate([0,-5-ball_bearing_diameter/2,0]) {
    rotate([-tray_rotate,0,0]) {
      rotate([0,0,0]) rotate([90,0,0]) translate([0,5,-1.5]) linear_extrude(height=3) injector_tray();
      rotate([90,0,0]) rotate([0,90,0]) translate([0,0,10]) linear_extrude(height=3) injector_tray_support();
      rotate([90,0,0]) rotate([0,90,0]) translate([0,0,stage2_total_width-10]) linear_extrude(height=3) injector_tray_support();
    }
  }
  for(x=[1:32]) {
    translate([x*pitch-1.5,13,42]) rotate([0,90,0]) linear_extrude(height=3) injector_crank();
  }
}


translate([centre_x - stage2_half_width,-54,-170]) injector_assembly();

// Axis for injector tray
translate([-300,-54-5-ball_bearing_diameter/2,-170]) rotate([0,90,0]) cylinder(d=3,h=500);

// Axis for injector cranks
translate([-300,-54+13,-170+42]) rotate([0,90,0]) cylinder(d=3,h=500);

translate([-310,-70,-180]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) end_plate();


// Output bearings in the injector assembly, for reference
for(x=[-16:15]) {
  translate([11.5+centre_x + 23*x, -59,-151]) sphere(d=ball_bearing_diameter);
}

