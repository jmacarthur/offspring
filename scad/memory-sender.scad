// Memory address sender. Ball bearings can be sent into this and a
// lever will selectively pull down on a rod which can be connected to
// the memory address decoder.

include <globs.scad>;

output_slope = 10;
joiner_height = 35;
joiner_width = 3.5;
enumerator_rod_spacing = 10;
$fn=20;

active = false;

pusher_pos = active? -enumerator_rod_travel : 0;
drive_lever_rotate=active ? -10 : 0;
module hook_plate_2d()
{
  notch_y = 10;
  notch_width = 8;
  plate_height = 60;
  difference() {
    polygon([[0,0], [20,0], [20,plate_height], [0,plate_height], [0,notch_y+10], [notch_width,notch_y+10], [notch_width,notch_y+notch_width*sin(output_slope)], [0,notch_y]]);

    // Hole for the joiner
    translate([3,joiner_height]) square([3,10]);
  }
}

module hook_joiner_2d() {
  union() {
    square([joiner_width,200]);
    translate([-3,5]) square([3+3+joiner_width, 10]);
  }
}

module sender_drive_lever_2d() {
  drive_lever_length=100;
  difference() {
    translate([-drive_lever_length/2,-5]) square([drive_lever_length,10]);
    circle(d=3); // Main axle
  }
}

module intake_slope_2d() {
  triangle_height=7;
  slope_height = 20;
  difference() {
    union() {
      polygon([[0,0], [10,0], [10,triangle_height], [20,triangle_height+5], [0,slope_height]]);
    }
    translate([2,17]) rotate(-20) square([3,20]);
  }
}

module outer_intake_plate_2d() {
  stagger = 10;
  difference() {
    square([55,30]);
    for(bit=[0:4]) {
      raise_input = (bit % 2 == 1) ? stagger : 0;
      translate([enumerator_rod_spacing*bit+5+joiner_width/2,10+raise_input]) circle(d=11);
      translate([enumerator_rod_spacing*bit+5+joiner_width/2,20-raise_input]) circle(d=3);
    }
  }
}

module inner_intake_plate_2d() {
  stagger = 10;

  union() {
    outer_intake_plate_2d();
    for(bit=[0:4]) {
      translate([enumerator_rod_spacing*bit+5,-15]) square([joiner_width,16]);
    }
  }
}

module sender_base_plate_2d()
{
  square([100,100]);
}

// 3D assembly

module memory_sender_3d() {
  for(bit=[0:4]) {
    translate([0,enumerator_rod_spacing*bit,0]) {
      // Two plates make up each channel
      translate([0,0,pusher_pos]) {
	vertical_plate_x() hook_plate_2d();
	translate([0,3+joiner_width,0]) vertical_plate_x() hook_plate_2d();
	// and the joining piece
	color([0.8,0.7,0]) translate([3,0,joiner_height-5]) vertical_plate_y() hook_joiner_2d();
      }

      translate([-20,0,0]) vertical_plate_x() intake_slope_2d();
      translate([-20,3+joiner_width,0]) vertical_plate_x() intake_slope_2d();
    }
  }
  translate([50,3 + (joiner_width-3)/2,25]) rotate([0,drive_lever_rotate,0]) vertical_plate_x() sender_drive_lever_2d();

  translate([-18,-5,18]) rotate([0,20,0]) vertical_plate_y() inner_intake_plate_2d();
  translate([-18,-5,18]) rotate([0,20,0]) translate([-10,0,0]) vertical_plate_y() outer_intake_plate_2d();
  horizontal_plate() sender_base_plate_2d();
}

module bearing_path(pos1, pos2)
{
  color([1.0,0,0]) hull() {
    translate(pos1) sphere(d=ball_bearing_diameter);
    translate(pos2) sphere(d=ball_bearing_diameter);
  }
}

// intake visualisation
intake_pos_1 = [-5,2,50];
intake_pos_2 = [-5,2,18];
intake_pos_3 = [4,2,15];
intake_pos_4 = [4,2,8];
intake_pos_5 = [-5,2,5];

bearing_path(intake_pos_1, intake_pos_2);
bearing_path(intake_pos_2, intake_pos_3);
bearing_path(intake_pos_4, intake_pos_5);

3d_assembly = true;

if(3d_assembly) {
  memory_sender_3d();
}
