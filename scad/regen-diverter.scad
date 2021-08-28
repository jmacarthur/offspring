// Regenerator and diverter unit
include <globs.scad>;

pipe_diameter = 7;

arc_radius = 31;
subtractor_flap_width = 15;
diverter_slope = 10;
collector_width = pitch*8+9;
flap_box_x = 30;
flap_rotate = 0;
module pyramid(width, depth, apex_height) {
  polyhedron(
  points=[ [width/2,depth/2,0],[width/2,-depth/2,0],[-width/2,-depth/2,0],[-width/2,depth/2,0], // the four points at base
           [0,0,apex_height]  ],                                 // the apex point 
  faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],              // each triangle side
              [1,0,3],[2,1,3] ]                         // two triangles for square base
 );
}

module discard_flap() {
  translate([-pitch/2-3,0,0])
  difference() {
    union() {
      rotate([0,90,0])cylinder(d=6, h=pitch*8+1);
      translate([0,-23,0]) cube([pitch*8-1, 23, 3]);
      for(i=[1:7]) {
	translate([i*pitch-1.5,0,0]) rotate([-90,0,0]) rotate([0,90,0]) linear_extrude(height=3) polygon([[0,0], [20,0], [15,5], [5,5]]);
      }
      rotate([-90,0,0]) rotate([0,90,0]) linear_extrude(height=pitch*8-1) polygon([[0,3], [20,0], [0,-3]]);
      
      // Control arm
      for(x=[0, pitch*8-2]) translate([x,0,0]) rotate([180,0,0]) translate([0,0,-3]) cube([3,50,6]);
    }
    translate([-1,0,0]) rotate([0,90,0])cylinder(d=3, h=6);
    translate([pitch*8+3-5,0,0]) rotate([0,90,0])cylinder(d=3, h=6);

    translate([3,-22,-2]) rotate([45,0,0]) cube([pitch*8-5, 3, 5]);
  }
}

module housing1() {
  translate([-pitch/2-4.5,0,0])
  difference() {
    cube([pitch*8+9, 31, 30]);
    translate([3,3,-1]) cube([pitch*8+3,30,32]);
    // Hole for the regen axle
    translate([-1,10,2]) rotate([0,90,0]) cylinder(d=3, h=300);
  }
}

module hopper1() {
  difference() {
    union() {
      translate([-pitch/2-4.5,0,0]) cube([pitch*8+9, 31,7]);
      for(x=[0, pitch*8+6]) translate([-pitch/2-4.5+x, 15,0]) cube([3,9,15]);
    }
    for(x=[0:7]) {
      translate([pitch*x, 10, 8])
	rotate([0,180,0]) pyramid(pitch, 20, 7);
      translate([pitch*x, 10, -1]) cylinder(d=7, h=32);
    }
    // Runoff channel
    translate([2+4.5-pitch/2,24,7]) rotate([0,2,0]) cube([pitch*8+10, 15, 7]);

    // Holes to mount diverter
    translate([-20,20,10]) rotate([0,90,0]) cylinder(d=3,h=300);
    
  }
}

module hopper2() {
  difference() {
    union() {
      for(x=[0:8]) translate([pitch*x+1.5-pitch/2,0,0]) rotate([0,-90,0]) linear_extrude(height=3) polygon([[0,0], [15,0], [0,17]]);
      translate([-pitch/2,-2,-5]) cube([pitch*8,6,30]);
    }
    translate([-pitch/2-1,1,22]) rotate([0,90,0]) cylinder(d=3,h=10);
    translate([-pitch/2-1+pitch*8-8,1,22]) rotate([0,90,0]) cylinder(d=3,h=10);
  }
}

module hopper() {
  difference() {
    union() {
      hopper1();
      translate([0,0,5]) hopper2();
    }
    for(x=[1,7]) translate([pitch*x-pitch/2,18,-1]) cylinder(d=3,h=30);
  }
}


module regen_intake_bar(offset) {
  r2 = 5;
  rotate([0,90,0]) translate([0,0,-1.5-offset]) linear_extrude(height=3+offset*2) {
    difference() {
      circle(r=arc_radius+r2/2+offset);
      circle(r=arc_radius-r2/2-offset);
      translate([-arc_radius-5, -arc_radius-5]) square([arc_radius+5, arc_radius+5]);
      translate([-arc_radius-5, 0]) square([arc_radius+50, arc_radius+5]);
    }
  }
}

module regen_pull_bar() {
  arm_length = arc_radius+5;
  axle_position = arc_radius;
  clearance = 0.125;
  axle_adjust = 2;
  translate([-pitch/2-4.5,0,0])
  difference() {
    union() {
      translate([-1,-25,35]) cube([pitch*8+10, 10,12+axle_adjust]);
      translate([-1,-25,35]) cube([3, arm_length, 12+axle_adjust]);
      translate([pitch*8+6,-25,35]) cube([3, arm_length, 12+axle_adjust]);
      for(x=[0,pitch*8-4]) {
	translate([x,-15,35]) cube([12,10,12+axle_adjust]);
      }
    }
    for(x=[0:7]) {
      translate([-(3+clearance)/2,10,32])
      translate([x*pitch+pitch/2+6,0,10]) regen_intake_bar(clearance);
      for(x=[12,pitch*8-4]) translate([x,-5,-1]) cylinder(r=10,h=55);
    }
    translate([-5,-25+axle_position,42+axle_adjust]) rotate([0,90,0]) cylinder(d=3,h=300);

  }
}



module regen_body() {
  intake_y = 15;
  depth = 31;
  translate([-pitch/2-4.5,0,0]) {
  difference() {
    cube([pitch*8+9, depth,15]);
    for(x=[0:7]) {
      translate([pitch*x+pitch/2+4.5,0,0]) {
	// Intake channel
	translate([0, intake_y-5, 10]) cylinder(d=7, h=32);

	// Channel sloping upwards which the bearing will fall through if allowed to by the push bar
	hull() {
	  translate([0,intake_y-3,10]) sphere(d=7);
	  translate([0,intake_y-10,8]) sphere(d=7);
	}

	
	// Also upward sloping channel?
	//translate([0,intake_y-5,8])rotate([-80,0,0])  cylinder(d=7,h=8);

	// Outtake channel
	translate([0,intake_y-10,-1]) cylinder(d=7,h=10);

	// plunger shaft hole
	translate([0,intake_y,10]) rotate([-90,0,0]) cylinder(d=3.5,h=30);

	// Plunger hole
	translate([0,intake_y-5,10]) rotate([-90,0,0]) cylinder(d=7,h=depth-intake_y+2);

	translate([0,intake_y-10,arc_radius+10]) rotate([20,0,0]) regen_intake_bar(0.5);
      }
    }
    // Horizontal mounting holes
    for(x=[2,6]) translate([pitch*x+4.5,20,5]) rotate([-90,0,0]) cylinder(d=3,h=100);

    // Vertical mounting holes
    for(x=[1,7]) translate([pitch*x+4.5,18,-1]) cylinder(d=3,h=30);
  }
  }
}

debug1 = 0;
module regen() {
  regen_body();
  for(x=[0:7]) {
    union() {
      translate([pitch*x,0,0]) {
	translate([0,14,10]) rotate([-90,0,0]) cylinder(d=6, h=3);
	translate([0,14,10]) rotate([-90,0,0]) cylinder(d=3, h=30);
	translate([0,31,10]) rotate([-90,0,0]) cylinder(d=6, h=3);
      }
    }
    translate([pitch*x+debug1,5,10+arc_radius]) rotate([0,0,0]) regen_intake_bar(0);
  }
  color([0.5,0.5,0.5,0.5]) translate([0,-5,0]) regen_pull_bar();
}

module output_lever_2d() {
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

    // Ridges
    for(x=[0:7]) {
      translate([-5,10+x*5]) circle(d=2);
      translate([5,10+x*5]) circle(d=2);
    }
  }
}

module output_lever() {
  rotate([0,90,0]) difference() {
    union() {
      rotate([0,180,0]) linear_extrude(height=3) output_lever_2d();
      cylinder(d=10,h=10);
    }
    translate([0,0,-1]) cylinder(d=3.2,h=12);
  }
}


module upward_curved_pipe() {
  translate([0,0,20]) 
  union() {
    rotate([-45,0,0]) rotate([0,90,0]) rotate_extrude(angle = 90) { translate([20,0]) circle(d=pipe_diameter); }
  }
}


module backing_plate_2d() {
  difference() {
    square([250+15,50]);
    for(y=[10,30]) {
      for(x=[7.5,7.5+250]) {
	translate([x,y]) circle(d=3);
	translate([x,y]) circle(d=3);
      }
    }
    translate([25,30]) square([195,60]);

    for(x=[0:7]) translate([x*pitch+data7_x,10]) circle(d=10);
    // Mounting holes
    for(x=[3,7]) translate([pitch*x+6,5]) circle(d=3);
  }
}

module backing_plate() {
  color([0.5,0.5,0.5,0.5]) rotate([90,0,0]) linear_extrude(height=3) backing_plate_2d();
}

module regen_diverter() {

  translate([0,0,0]) regen();

  color([1,0,0]) translate([1.5,50,-10]) output_lever();

  translate([0,0,15]) color([0,1,0]) hopper();
  translate([3,20,25]) rotate([-55,0,0]) discard_flap();
}

module subtractor_flap() {
  width = subtractor_flap_width;
  translate([-pitch/2-3,0,0])
  difference() {
    union() {
      rotate([0,90,0])cylinder(d=6, h=pitch*8-1);
      translate([0,-width,0]) cube([pitch*8-1, width, 3]);
    }

    // Holes in each end to place axles in
    translate([-1,0,0]) rotate([0,90,0]) cylinder(d=3, h=11);
    translate([pitch*8-10,0,0]) rotate([0,90,0])cylinder(d=3, h=11);


    translate([-1,-width,0]) rotate([0,90,0])cylinder(d=6.5, h=pitch*8+2);
  }
}

module subtractor_flap_pulley() {
  rotate([0,90,0]) union() {
    for(z=[0,4]) translate([0,0,z]) cylinder(d=10,h=1);
    cylinder(d=8,h=5);
  }
}

module subtractor_flap_frame() {
  difference() {
    translate([0,-4,-3]) cube([3,64,6]);

    for(i=[0:3]) {
      translate([-1,i*subtractor_flap_width, 0]) rotate([0,90,0]) cylinder(d=3.5, h=10);
    }
  }
}


module subtractor_collector(height) {
  input_spacing = subtractor_flap_width*cos(diverter_slope);
  output_spacing = 10;
  offset = 5;
  width = collector_width;
  union() {
    for(i=[0:2]) translate([0,i*-output_spacing,8.5]) cube([width, 3, 1.5]);
    for(i=[0:2]) translate([0,i*-input_spacing+offset,20]) cube([width, 3, height-i*2]);
    for(i=[0:2]) hull() {
	translate([0,i*-output_spacing+1.5,10]) rotate([0,90,0]) cylinder(d=3, h=width);
	translate([0,i*-input_spacing+1.5+offset,20]) rotate([0,90,0]) cylinder(d=3, h=width);
      }    
  }
}

module collector_side_bracket() {
  // Support jigs
  translate([-5,-6,10]) linear_extrude(height=20) polygon([[6,6], [6,0], [0,6]]);
  translate([-5,3,10]) linear_extrude(height=20) polygon([[5,5], [6,0], [0,0]]);
  translate([-5,-5,30]) linear_extrude(height=5) polygon([[6,10], [5,0], [0,5], [0,8], [5,13]]);
}

module collector() {
  translate([0,-3,-66]) {
    difference() {
      union() {
      
	subtractor_collector(13);
	translate([0,-29.5,0])  subtractor_collector(7);
	
	translate([0,-55,0]) {
	  for(x=[0,collector_width-3]) {
	    translate([x,0,8.5]) difference() {
	      cube([3,63,40]);
	      translate([-1,0,17]) rotate([diverter_slope, 0,0]) cube([5,80,30]);
	    }
	  }
	}
	// Y-axis plates
	for(i=[1:7]) {
	  h1 = 14;
	  translate([pitch*i-1.5,-53,8.5]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) polygon([[0,0], [60,0], [60,h1+10], [0,h1]]);
	}
	//collector_side_bracket();
	//translate([pitch*8+9,3,0]) rotate([0,0,180]) collector_side_bracket();

	// Mounting supports
	for(x=[-5,collector_width-1]) {translate([x,-29,8.5]) cube([6,10,20]);}
      }
      // Mounting holes

      for(z=[13,23]) {
	translate([-6,-24,z]) rotate([0,90,0]) cylinder(d=3,h=8);
	translate([collector_width-2,-24,z]) rotate([0,90,0]) cylinder(d=3,h=8);
      }
     
    }
  }
}

module collector_with_frame() {
  union() {
    for(x=[0, pitch*8+6]) {
      translate([x,-10-3*subtractor_flap_width*cos(diverter_slope),-30-3*subtractor_flap_width*sin(diverter_slope)]) rotate([diverter_slope,0,0]) subtractor_flap_frame();
    }
    collector();
  }
 
}

module flap_assembly() {
  translate([pitch*8-9,-10,-30]) rotate([diverter_slope,0,0]) {
    for(i=[0:3]) {
      color([1,i%2,0]) translate([0,-subtractor_flap_width*i, 0]) rotate([0,0,180]) rotate([flap_rotate,0,0]) subtractor_flap();
      color([0.5,0,0]) translate([0,-subtractor_flap_width*i, 0]) rotate([0,90,0]) cylinder(d=3,h=30);
      if(i%2==0) color([0.5,0,0]) translate([25,-subtractor_flap_width*i, 0]) subtractor_flap_pulley();
    }
  }
  collector_with_frame();
}


// Passive module which moves bearings toward the back of the machine
module returner() {
  channel_diameter = 7.5;
  intake_y = 5;
  output_y = 30;
  h1 = 10;
  h2 = 5;
  difference() {
    translate([-pitch/2,0,0]) cube([pitch*8, 35, 15]);

    // Intake holes
    for(i=[0:7]) {
      translate([pitch*i, intake_y, h1]) cylinder(d=channel_diameter, h=10);
      hull() {
	translate([pitch*i, intake_y, h1]) sphere(d=channel_diameter);
	translate([pitch*i, output_y, h2]) sphere(d=channel_diameter);
      }
      translate([pitch*i, output_y, -1]) cylinder(d=channel_diameter, h=h2+1);
      
    }
    // Vertical mounting holes
    for(x=[1,7]) translate([pitch*x-pitch/2,18,-1]) cylinder(d=3,h=30);

  }
}

module lever_support_holes_2d(diam) {
  translate([0,0]) circle(d=diam);
  translate([0,7.5]) circle(d=diam);
  translate([15,0]) circle(d=diam);
}


module lever_support() {
  translate([15,7.5,0])   rotate([0,90,0]) 
  linear_extrude(height=5) {
    difference() {
      hull() {
	lever_support_holes_2d(10);
      }
      lever_support_holes_2d(3);
    }
  }
}


module regen_diverter_assembly() {
  
  translate([data7_x,-16-18,0]) regen_diverter();
  translate([0,0,0]) backing_plate();
  translate([flap_box_x,0,0]) flap_assembly();  
  color([0,1,0]) translate([data7_x,-34,-15]) returner();

  translate([0,0,-10]) lever_support();
  translate([250-15-5,0,-10]) lever_support();
}

regen_diverter_assembly();


// Simulate rack rails
if(1) {
  color([0.5,0.5,0.5]) {
    translate([0,0,-100]) cube([15,15,150]);
    translate([250,0,-100]) cube([15,15,150]);
  }
}

// Illustrate data coming from memory
for(i=[0:7]) {
  translate([pitch*i+data7_x, data7_y,50]) cylinder(d=7, h=50);
}
