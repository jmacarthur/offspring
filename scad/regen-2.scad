include <globs.scad>;

base_plate_tab_x = [ ejector_xpos(1)+pitch/2, ejector_xpos(5)+pitch/2 ];
$fn=20;
depth = 50;
hole_pos_y = 30;
t = 3; // Plate thickness
travel = channel_width;

animated_travel = travel*(1+sin($t*360))/2;

module vertical_plate_holes() {
  for(c=[0:7]) {
    translate([ejector_xpos(c)+channel_width/2,13]) square([3,channel_width]);
    translate([ejector_xpos(c)-t-channel_width/2,13]) square([3,channel_width]);
    translate([ejector_xpos(c)-t/2,13]) square([3,channel_width]);
  }
  // Mounting tabs
  for(x=base_plate_tab_x) {
    translate([x-2.5,10]) {
      square([5,3]);
    }
  }
}

module back_plate_2d()
{
  difference() {
    union() {
      square([200,50]);
    }
    vertical_plate_holes();
  }
}


module front_plate_2d()
{
  difference() {
    square([200,50]);
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
      square([30,channel_width]);
      translate([depth-hole_pos_y+channel_width/2+3,0]) square([3,channel_width+3]);
    }
    translate([-3,channel_width/2]) circle(d=8);
  }
}

module input_pushrod_2d() {
  difference() {
    square([20,channel_width]);
    translate([20+3,channel_width/2]) circle(d=8);
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
      translate([depth+3+3,-20]) square([20,20+channel_width]);
    }
    translate([depth+3+3+10,-20+5]) circle(d=3);
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
      translate([-t/2,-depth+hole_pos_y-channel_width/2-20-channel_width+animated_travel,13]) vertical_plate_y() input_pushrod_2d();
    }
  }
  translate([0,-50,10]) horizontal_plate() base_plate_2d();
}


3d_regenerator_assembly();
