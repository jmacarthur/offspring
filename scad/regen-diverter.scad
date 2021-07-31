// Regenerator and diverter unit
include <globs.scad>;

flap_rotate=-90;
pipe_diameter = 7;
module pyramid(width, depth, apex_height) {
  polyhedron(
  points=[ [width/2,depth/2,0],[width/2,-depth/2,0],[-width/2,-depth/2,0],[-width/2,depth/2,0], // the four points at base
           [0,0,apex_height]  ],                                 // the apex point 
  faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],              // each triangle side
              [1,0,3],[2,1,3] ]                         // two triangles for square base
 );
}

module flap() {
  difference() {
    union() {
      rotate([0,90,0])cylinder(d=6, h=pitch*8+3);
      translate([0,-23,0]) cube([pitch*8+3, 23, 3]);
      for(i=[0:8]) {
	translate([i*pitch,0,0]) rotate([-90,0,0]) rotate([0,90,0]) linear_extrude(height=3) polygon([[0,0], [20,0], [15,5], [5,5]]);
      }
      // Control arm
      for(x=[0, pitch*8]) translate([x,0,0]) rotate([90,0,0]) translate([0,0,-3]) cube([3,25,6]);
    }
    translate([-1,0,0]) rotate([0,90,0])cylinder(d=3, h=6);
    translate([pitch*8+3-5,0,0]) rotate([0,90,0])cylinder(d=3, h=6);

    translate([-1,-22,-2]) rotate([45,0,0]) cube([pitch*8+10, 3, 5]);
    
  }
}

module housing1() {
  difference() {
    cube([pitch*8+9, 30, 30]);
    translate([3,3,-1]) cube([pitch*8+3,30,32]);
    // Hole for the regen axle
    translate([-1,10,2]) rotate([0,90,0]) cylinder(d=3, h=300);
  }
}

module hopper1() {
  difference() {
    union() {
      cube([pitch*8+9, 31,20]);
      translate([10,28,19]) cube([pitch*8+9-20, 3, 20]);
    }
    for(x=[0:7]) {
      translate([pitch*x+pitch/2+4.5, 10, 21])
		   rotate([0,180,0]) pyramid(pitch, 20, 25);
      translate([pitch*x+pitch/2+4.5, 10, -1]) cylinder(d=7, h=32);
    }
    // Runoff channel
    translate([2,21,15]) rotate([0,3,0]) cube([pitch*8+10, 7, 25]);
  }
}


module regen_intake_pipe(outset) {
  r1 = 31;
  r2 = 5+outset;
  translate([-(3+outset)/2,10,32]) rotate([0,90,0]) linear_extrude(height=3+outset) {
    difference() {
      circle(r=r1+r2/2);
      circle(r=r1-r2/2);
      translate([-r1-5, -r1-5]) square([r1+5, r1+5]);
      translate([-r1-5, 0]) square([r1+50, r1+5]);
    }
  }
}

module regen_pull_bar() {
  arm_length = 40;
  axle_position = 35;
  difference() {
    union() {
      translate([-4,-25,35]) cube([pitch*8+16, 10,10]);
      translate([-4,-25,35]) cube([3, arm_length, 10]);
      translate([pitch*8+10,-25,35]) cube([3, arm_length, 10]);
    }
    for(x=[0:7]) {
      translate([x*pitch+pitch/2+4.5,0,10]) regen_intake_pipe(0.2);
    }
    translate([-5,-25+axle_position,42]) rotate([0,90,0]) cylinder(d=3,h=300);

  }
}

module regen_body() {
    difference() {
    translate([0, 0, 0]) cube([pitch*8+9, 31,20]);
    for(x=[0:7]) {
      translate([pitch*x+pitch/2+4.5,0,0]) {
	translate([0, 10, 10]) cylinder(d=7, h=32);
	hull() {
	  translate([0,10,10]) sphere(d=7);
	  translate([0,5,8]) sphere(d=7);
	}
	translate([0,5,8])rotate([-80,0,0])  cylinder(d=7,h=8);
	translate([0,5,-1]) cylinder(d=7,h=11);
	translate([0,10,10]) rotate([-90,0,0]) cylinder(d=3.5,h=30);
	translate([0,10,10]) rotate([-90,0,0]) cylinder(d=7,h=19);
	translate([0,0,10]) regen_intake_pipe(1);
      }
    }

  }
}
debug1 = 0;
module regen() {
  regen_body();
  for(x=[0:7]) {
    union() {
      translate([pitch*x+pitch/2+4.5,0,0]) {
	translate([0,14,10]) rotate([-90,0,0]) cylinder(d=6, h=3);
	translate([0,14,10]) rotate([-90,0,0]) cylinder(d=3, h=30);
	translate([0,31,10]) rotate([-90,0,0]) cylinder(d=6, h=3);
      }
    }
    translate([pitch*x+pitch/2+4.5+debug1,0,10]) regen_intake_pipe(0);
  }
  translate([0,0,0]) regen_pull_bar();
}


module upward_curved_pipe() {
  translate([0,0,20]) 
  union() {
    rotate([-45,0,0]) rotate([0,90,0]) rotate_extrude(angle = 90) { translate([20,0]) circle(d=pipe_diameter); }
  }
}

$fn=20;
module regen_diverter() {
  translate([3,18,3]) rotate([flap_rotate,0,0]) flap();
  color([1,0,0]) housing1();
  translate([10,10,0]) sphere(d=ball_bearing_diameter);
  color([0,1,0]) translate([0,0,-20]) hopper1();

  translate([0,0,-40]) regen();
}

regen_diverter();
