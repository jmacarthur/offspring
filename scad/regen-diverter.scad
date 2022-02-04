// Regenerator and diverter unit
include <globs.scad>;
use <base-regen.scad>;


pipe_diameter = 7;

arc_radius = 31;
subtractor_flap_width = 15;
diverter_slope = 10;
collector_width = pitch*8+9;
flap_box_x = 30;
flap_rotate = 0;
regen_offset = 0;
module pyramid(width, depth, apex_height) {
  polyhedron(
  points=[ [width/2,depth/2,0],[width/2,-depth/2,0],[-width/2,-depth/2,0],[-width/2,depth/2,0], // the four points at base
           [0,0,apex_height]  ],                                 // the apex point 
  faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],              // each triangle side
              [1,0,3],[2,1,3] ]                         // two triangles for square base
 );
}

module discard_flap() {
  translate([data7_x-pitch/2,0,0]) {
    difference() {
      union() {
	hull() {
	  translate([0,-3,0]) cube([pitch*8, 3, 27]);
	  rotate([0,90,0]) cylinder(h=pitch*8, d=6);
	}
	for(i=[0:7]) {
	  for(x=[-5, 5+3]) {
	    translate([i*pitch+x+pitch/2, 0, 0]) rotate([90,0,0]) rotate([0,-90,0]) linear_extrude(height=3) {
	      polygon([[0,0], [13,10], [13,27], [0,27]]);
	    }
	  }
	}
      }
      translate([-1,0,0]) rotate([0,90,0]) cylinder(h=11, d=3);
      translate([pitch*8-10,0,0]) rotate([0,90,0]) cylinder(h=12, d=3);
    }
  }
}

module discard_flap_holder() {
  difference() {
    union() {
      translate([-13,-10,-5]) cube([11,15,20]);
      translate([-13,3,-5]) cube([11,3,30]);
    }
    translate([1,0,0]) rotate([0,-90,0]) cylinder(d=3.5,h=15);
    hull() {
      translate([1,0,0]) rotate([0,-90,0]) cylinder(d=7,h=6);
      translate([-5,0,0]) cube([10,3,30]);
      translate([-5,-3,0]) rotate([30,0,0]) cube([10,3,30]);
    }
    translate([-10,0,20]) rotate([-90,0,0]) cylinder(d=3,h=15);
  }
}

module discard_assembly() {
  translate([0,0,0]) rotate([0,0,0]) discard_flap();
  translate([data7_x-pitch/2+5,0,0]) discard_flap_holder();
  translate([data7_x-pitch/2-5,0,0]) translate([pitch*8,0,0]) scale([-1,1,1]) discard_flap_holder();
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

module upward_curved_pipe() {
  translate([0,0,20]) 
  union() {
    rotate([-45,0,0]) rotate([0,90,0]) rotate_extrude(angle = 90) { translate([20,0]) circle(d=pipe_diameter); }
  }
}


module discard_backing_plate_2d() {
  difference() {
    translate([0,5]) square([250+15,40]);
    for(y=[10,30]) {
      for(x=[7.5,7.5+250]) {
	translate([x,y]) circle(d=3);
	translate([x,y]) circle(d=3);
      }
    }
    translate([15,0]) square([250-35,35]);
    translate([28,15]) square([250-64,40]);

    translate([data7_x-pitch/2-5,40]) circle(d=3);
    translate([data7_x-pitch/2+pitch*8+5,40]) circle(d=3);
  }
}

module discard_backing_plate() {
  color([0.5,0.5,0.5,0.5]) rotate([90,0,0]) linear_extrude(height=3) discard_backing_plate_2d();
}

module subtractor_flap() {
  width = subtractor_flap_width;
  translate([-pitch/2-3,0,0])
  difference() {
    union() {
      rotate([0,90,0])cylinder(d=6, h=pitch*8-1);
      difference() {
	translate([0,-width,0]) cube([pitch*8-1, width, 3]);
	for(i=[1:7]) {
	  translate([i*pitch+4, -width-1,-3]) cube([3,width, 7]);
	}
      }
    }

    // Holes in each end to place axles in
    translate([-1,0,0]) rotate([0,90,0]) cylinder(d=3, h=11);
    translate([pitch*8-10,0,0]) rotate([0,90,0])cylinder(d=3, h=11);

    // Cutout for next flap
    translate([-1,-width,0]) rotate([0,90,0]) cylinder(d=6.5, h=pitch*8+2);
  }
}

module subtractor_flap_pulley() {
  min_diameter = 8;
  max_diameter = 10;
  rotate([0,90,0]) difference() {
    union() {
      translate([0,0,0]) cylinder(d=max_diameter,h=1);
      translate([0,0,1]) cylinder(d1=max_diameter,d2=min_diameter,h=1);
      translate([0,0,3]) cylinder(d1=min_diameter,d2=max_diameter,h=1);
      translate([0,0,4]) cylinder(d=max_diameter,h=1);
      cylinder(d=min_diameter,h=5);
    }
    translate([0,0,-1]) cylinder(d=3, h= 15);
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


module diverter_bracket(x1, y1) {
  color([1,0,0])
  difference() {
    union() {
      translate([x1-3,-y1,-58])  cube([3,y1-10,22]);
      translate([0,-3,-58])  cube([x1-10,3,22]);
      translate([x1-10,-10,-58])  cylinder(r=10,h=22);

      translate([x1,-y1+10,-58])  cube([3,3,22]);

    }
    translate([-1,-y1-1,-61])  cube([x1-11+1,y1-3+1,30]);
    translate([-1,-y1-1,-61])  cube([x1-3+1,y1-11+1,30]);
    translate([x1-3-10,-10-3,-61])  cylinder(r=10, h=50);
    translate([0,-y1+5,-53]) rotate([0,90,0]) cylinder(d=3, h=50);
    translate([0,-y1+5,-43]) rotate([0,90,0]) cylinder(d=3, h=50);
    translate([7.5,-5,-53]) rotate([-90,0,0]) cylinder(d=3, h=50);
    translate([7.5,-5,-43]) rotate([-90,0,0]) cylinder(d=3, h=50);
  }
}


module left_diverter_bracket() {
  diverter_bracket(25, 32);
}

module right_diverter_bracket() {
  translate([250+15,0,0]) scale([-1,1,1]) diverter_bracket(37,32);
}


module returner() {
  difference() {
    union() {
      translate([data7_x-pitch/2-5,-40,0])
	cube([pitch*8, 47, 10]);
      translate([0,-2,0]) cube([250+15, 5, 10]);
    }
    for(i=[0:7]) {
      translate([data7_x-pitch/2+pitch*i,-40,0]) {
	hull() {
	  translate([pitch/2+regen_offset-3,10,10]) sphere(d=10);
	  translate([pitch/2,40,5]) sphere(d=8);
	  translate([pitch/2,40,10]) sphere(d=8);
	}
	translate([pitch/2,40,-1]) cylinder(d=8, h=5);
	
	// This isn't necessary - it's just reducing print volume
	if(i>0) {
	  hull() {
	    translate([regen_offset-5,0,10]) sphere(d=10);
	    translate([0,47,10]) sphere(d=8);
	  }
	}

      }
    }

    for(x=[0,250]) {
      translate([x+7.5,-3,5]) {
	rotate([-90,0,0]) cylinder(d=3,h=10);
      }
    }
  } 
}

module regen_diverter_assembly() {
  translate([0,-3,20]) discard_assembly();
  translate([0,0,0]) discard_backing_plate();
  translate([0,-25-3,5]) rotate([0,0,-90]) base_regen(regen_offset);

  translate([0,-3,-71]) returner();

  translate([0,0,-60]) {
    translate([flap_box_x,0]) flap_assembly();  
    left_diverter_bracket();
    right_diverter_bracket();
  }
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
