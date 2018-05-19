include <globs.scad>;

base_plate_tab_x = [ 50,100 ];
$fn=20;
depth = 50;

module back_plate_2d()
{
  difference() {
    square([200,50]);
    for(c=[0:7]) {
      translate([ejector_xpos(c)+channel_width/2,13]) square([3,channel_width]);
      translate([ejector_xpos(c)-3-channel_width/2,13]) square([3,channel_width]);
      translate([ejector_xpos(c)-1.5,13]) square([3,channel_width]);
    }
  }
}


module base_plate_2d()
{
  difference() {
    square([200,depth]);
    for(c=[0:7]) {
      translate([ejector_xpos(c),25]) circle(d=channel_width);
    }
  }
}


module separator_plate_2d() {
  square([depth+3+3,channel_width]);
}

module 3d_regenerator_assembly() {
  translate([0,3,0])    vertical_plate_x() back_plate_2d();
  for(c=[0:7]) {
    translate([ejector_xpos(c),0,0]) {
      translate([0+channel_width/2,-depth-3,13])    vertical_plate_y() separator_plate_2d();
      translate([-3-channel_width/2,-depth-3,13])    vertical_plate_y() separator_plate_2d();
    }
  }
  translate([0,-50,10]) horizontal_plate() base_plate_2d();
}


3d_regenerator_assembly();
