include <globs.scad>;

use <interconnect.scad>;

base_plate_tab_x = [ ejector_xpos(1)+pitch/2, ejector_xpos(5)+pitch/2 ];
$fn=20;
depth = 40;
hole_pos_y = 20;
t = 3; // Plate thickness
travel = channel_width;

animated_travel = travel*(1+sin($t*360))/2;
input_pushrod_length = 30;
output_pushrod_length = 40;
drive_plate_depth = 40;
vertical_plate_height = 35;

connector_pos_y = 13+channel_width/2;

module vertical_plate_holes() {
  clearance = 0.25;
  for(c=[0:7]) {
    translate([ejector_xpos(c)+channel_width/2,13]) square([3,channel_width]);
    translate([ejector_xpos(c)-t-channel_width/2,13]) square([3,channel_width]);
    translate([ejector_xpos(c)-t/2-clearance/2,13-clearance/2]) square([3+clearance,channel_width+clearance]);
  }
  // Mounting tabs
  for(x=base_plate_tab_x) {
    translate([x-2.5,10]) {
      square([5,3]);
    }
  }

  // For the drive cable
  translate([ejector_xpos(3)+pitch/2,13+channel_width/2]) circle(d=bowden_cable_inner_diameter+clearance);
  // For the pusher plate
  translate([ejector_xpos(0)-channel_width/2-t-20,13+channel_width/2-1.5]) square([20,3]);
  translate([ejector_xpos(7)+channel_width/2+t,13+channel_width/2-1.5]) square([20,3]);
}

module back_plate_2d()
{
  difference() {
    union() {
      square([200,vertical_plate_height]);
    }

    vertical_plate_holes();
    // For the bowden cable connector

    translate([ejector_xpos(3)+pitch/2-t/2,connector_pos_y+5]) square([3,5]);
    translate([ejector_xpos(3)+pitch/2-t/2,connector_pos_y-10]) square([3,5]);

    // For bolting to openbeam
    for(x=[1,5]) {
      translate([ejector_xpos(x)+pitch/2,vertical_plate_height-7.5]) circle(d=3);
    }

  }
}


module front_plate_2d()
{
  difference() {
    square([200,vertical_plate_height]);
    vertical_plate_holes();
  }
}


module base_plate_2d()
{
  difference() {
    union() {
      square([200,depth]);
      for(x=base_plate_tab_x) {
	translate([x-2.5,-3]) {
	  square([5,depth+6]);
	}
      }
    }
    for(c=[0:7]) {
      translate([ejector_xpos(c),hole_pos_y]) circle(d=channel_width);
    }
  }
}


module output_pushrod_2d() {
  difference() {
    union() {
      square([31,channel_width]);
      translate([depth-hole_pos_y+channel_width/2+3,0]) square([3,channel_width+3]);
    }
    translate([-3,channel_width/2]) circle(d=8);
  }
}

module input_pushrod_2d() {
  input_stop = 4; // TODO: Figure out why this is 4
  difference() {
    union() {
      square([input_pushrod_length,channel_width]);
      translate([input_pushrod_length-hole_pos_y+input_stop-travel,-3]) square([3,channel_width+6]);
    }
    translate([input_pushrod_length+3,channel_width/2]) circle(d=8);
  }
}


module separator_plate_2d() {
  union() {
    square([depth+3+3,channel_width]);
  }
}

module end_separator_plate_2d() {
  difference() {
    union() {
      square([depth+3+20,channel_width]);
      translate([depth+3+3,-20]) square([25,20+channel_width]);
    }
    translate([depth+3+3+10,-20+5]) circle(d=3);
    translate([depth+3+3+15,0]) circle(d=3); // Attach rubber bands here for testing
    translate([depth+3+3+15,-21]) square([3,11]); // Attach comb here
  }
}


module output_crank_2d() {
  difference() {
    union() {
      translate([-5,-5]) square([40,10]);
      translate([-5,-5]) square([10,30]);
    }
    circle(d=3);
    translate([20,0]) circle(d=3);
    translate([30,0]) circle(d=3);
 }
}

module lower_output_comb_2d() {
  clearance = 0.5;
  difference() {
    union() {
      square([200,20]);
      translate([ejector_xpos(7)+channel_width/2+t,0]) square([3,23]);
      translate([ejector_xpos(0)-channel_width/2-t-t,0]) square([3,23]);
    }
    for(c=[0:7]) {
      translate([ejector_xpos(c)-clearance/2-t/2,5]) square([t+clearance, 16]);
    }
  }
}

module drive_plate_2d() {
  difference() {
    union() {
      square([200,drive_plate_depth]);
      translate([ejector_xpos(0)-channel_width/2-t-20,0]) square([20,drive_plate_depth+40]);
      translate([ejector_xpos(7)+channel_width/2+t,0]) square([20,drive_plate_depth+40]);
    }
    for(c=[0:7]) {
      translate([ejector_xpos(c)-t/2,drive_plate_depth-11]) square([3,21]);
    }
    cd = bowden_cable_inner_diameter;
    translate([ejector_xpos(3)+pitch/2-cd/2,drive_plate_depth-15]) {
      translate([0,0]) square([cd,21]);

      translate([cd+0.5,-10]) rotate(90) cable_clamp_cutout_2d();
    }
  }
}

module bowden_cable_mount_holes() {
  translate([10,5]) circle(d=3);
  translate([10,15]) circle(d=3);
}

module bowden_cable_mount_2d() {
  cd = bowden_cable_outer_diameter;
  difference() {
    square([20,20]);
    translate([-1,5]) square([4,10]);
    translate([-1,10-cd/2]) square([100,cd]);
    bowden_cable_mount_holes();
  }
}

module bowden_cable_outer_mount_2d() {
  difference() {
    translate([3,0]) square([20-3,20]);
    bowden_cable_mount_holes();
  }
}

module 3d_regenerator_assembly() {
  color([1.0,1.0,0]) translate([0,3,0])    vertical_plate_x() back_plate_2d();
  color([1.0,1.0,0]) translate([0,-depth,0])    vertical_plate_x() front_plate_2d();
  for(c=[0:7]) {
    translate([ejector_xpos(c),0,0]) {
      translate([0+channel_width/2,-depth-3,13])    vertical_plate_y() if(c==7) { end_separator_plate_2d(); } else  {separator_plate_2d(); }
      translate([-3-channel_width/2,-depth-3,13])    vertical_plate_y() if(c==0) { end_separator_plate_2d(); } else { separator_plate_2d(); }

      translate([-t/2,-depth+hole_pos_y-channel_width/2+animated_travel,13]) vertical_plate_y() output_pushrod_2d();
      translate([-t/2,-depth+hole_pos_y-channel_width/2-input_pushrod_length-channel_width+animated_travel,13]) vertical_plate_y() input_pushrod_2d();


      translate([-t/2,10+3,-2]) vertical_plate_y() rotate(sin($t/360)*20) output_crank_2d();
    }
  }
  translate([0,-depth,10]) horizontal_plate() base_plate_2d();
  translate([0,21,-20+3]) vertical_plate_x() lower_output_comb_2d();


  translate([0,-depth-drive_plate_depth-t-travel,13+channel_width/2-1.5]) horizontal_plate() drive_plate_2d();

  translate([ejector_xpos(3)+pitch/2-t/2,0,connector_pos_y-10]) {
    translate([0,0,0]) vertical_plate_y() bowden_cable_mount_2d();
    translate([-t,0,0]) vertical_plate_y() bowden_cable_outer_mount_2d();
    translate([t,0,0]) vertical_plate_y() bowden_cable_outer_mount_2d();
  }

}


3d_regenerator_assembly();


// Example openbeam

color([0.3,0.3,0.3]) translate([0,-15,20]) cube([200,15,15]);
