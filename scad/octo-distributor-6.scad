// 6th iteration distributor, for 3D printers

include <globs.scad>;

use <vertical-memory-2.scad>;

// Generally, use small_pipe_diameter when location is important, otherwise large_pipe_diameter
large_pipe_diameter = 7;
small_pipe_diameter = 7;
pipe_diameter = large_pipe_diameter;

module mounting_holes() {
  for(x=[1,7]) translate([pitch*x-pitch/2, 15, -10]) cylinder(d=3, h=40);
}

module horizontal_mounting_holes() {
  for(x=[2,6]) translate([pitch*x-pitch/2, -1, 0]) rotate([-90,0,0]) cylinder(d=3, h=50);
}


travel = 5;

// Where memory takes its input
memory_x_7 = data7_x;
memory_y_7 = data7_y;

module injector() {
  h=6.5;
  difference() {
    union() {
      translate([1.5,-20,0]) rotate([0,-90,0]) linear_extrude(height=3) {
	polygon([[0,0], [h,0], [h,40], [3,43], [0,43]]);
      }
      translate([-6, -6, 0]) cube([12,12,h]);
      translate([-6,20,0]) cube([12,10,3]);
    }
    translate([0,0,-1]) cylinder(d=small_pipe_diameter,h=12);

    translate([-3,23,-1]) cube([6,4,5]);

  }
}

module injector_housing_base() {
  clearance = 0.25;
  travel = 5;
  difference() {
    translate([-pitch/2,0,0]) cube([pitch*8, 24.5,10+clearance]);
    for(x=[0:7]) {
      translate([pitch*x-1.5-clearance, -1, 3]) {
	cube([3+2*clearance, 50, 7+clearance*2]);
      }
      translate([pitch*x-6-clearance, 5-clearance, 3]) {
	cube([12+2*clearance, 12+travel+2*clearance, 7+clearance*2]);
      }
      translate([pitch*x, 11+travel, -1]) cylinder(d=small_pipe_diameter, h=10);
    }
    // Mounting holes
    for(x=[1,5]) {
      translate([pitch*x+pitch/2, -1, 5]) {
	rotate([-90,0,0]) cylinder(d=3, h=50);
      }
    }
    mounting_holes();
  }
  
}

module injector_housing_top() {
  clearance = 0.25;
  difference() {
    translate([-pitch/2,0,3]) union() {
      rotate([0,90,0]) linear_extrude(height=pitch*8) polygon([[-6,0], [3,0], [3,24], [0,24], [-6,24], [0, 11]]);
      for(x=[0,pitch*8-3]) translate([x,0,0]) cube([3,24,8]);
      
    }
    for(x=[0:7]) {
      translate([pitch*x, 11, -1]) cylinder(d=small_pipe_diameter, h=10);
    }
    mounting_holes();
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
      offset(r=2) translate([x*pitch+data7_x-3, 12]) square([6,25]);
    }
    for(x=[2,6]) {
      translate([x*pitch-pitch/2+data7_x, 15]) circle(d=3);
    }
  }
}

module backplate() {
  rotate([90,0,0]) linear_extrude(height=3) mounting_plate_2d();
}

module crank_arm_2d() {
  l1 = 50;
  l2 = 30;
  clearance = 0.5;
  difference() {
    union() {
      translate([-5,0]) square([10,l1]);
      translate([0,-5]) square([l2,10]);
      circle(d=10);
    }
    circle(d=3);
    translate([l2-10,-1.5-clearance]) square([20,3+clearance*2]);

    // Ridges
    for(x=[0:7]) {
      translate([-5,10+x*5]) circle(d=2);
      translate([5,10+x*5]) circle(d=2);
    }
  }
}

module crank_arm() {
  rotate([0,90,0]) difference() {
    union() {
      linear_extrude(height=3) crank_arm_2d();
      cylinder(d=10,h=10);
    }
    translate([0,0,-1]) cylinder(d=3.2,h=12);
  }
}

module injector_assembly() {
  translate([memory_x_7, memory_y_7-11-travel, 10]) {
    injector_housing_base();
    color([1,1,0]) translate([0,0,10+0.2]) injector_housing_top();
    for(x=[0:7]) {
      color([1,0,0]) translate([pitch*x, 16,3.2]) injector();
    }
  }
}


module lever_bracket_2d() {
  clip_step = 0.2;
  difference() {
    hull() {
      translate([5,5]) circle(d=10);
      translate([5,25]) circle(d=10);
      translate([27,10]) circle(d=10);
    }

    translate([7,12]) square([3,8]);
    translate([7+clip_step,-1]) square([3-clip_step*2,15]);
    translate([27,10]) circle(d=3);
  }

}


module lever_bracket() {
  union() {
    rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=5) lever_bracket_2d();
    translate([0,5,20]) cube([20,5,7]);
  }
}


module coupler() {
  difference() {
    union() {
      translate([0,-5,14]) cube([pitch*7,10,10]);
      for(x=[0:7]) {
	translate([pitch*x, 0, 0]) cylinder(d=12, h=24);
      }
    }
    for(x=[0:7]) {
      translate([pitch*x, 0, -1]) cylinder(d=7, h=30);
    }
    translate([-pitch,2.5,-1]) cube([pitch*10, 10, 5]);
    translate([0,memory_y_7-4.5]) mounting_holes();
  }
}


// Illustrate input channel into memory
for(x=[0:7]) {
  color([1,0,0,0.3]) translate([memory_x_7+pitch*x, memory_y_7, -30]) cylinder(d=7, h=50);
}

injector_assembly();
color([0,1,0]) backplate();

for(i=[0:7]) {
  translate([memory_x_7-1.5+i*pitch,17,40]) crank_arm();
 }
translate([32,-10,30]) lever_bracket();
translate([memory_x_7, memory_y_7, -14]) coupler();

translate([22.5,-5,-130-11]) rotate([90,0,0]) memory_assembly();
