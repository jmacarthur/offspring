// Memory address sender. Ball bearings can be sent into this and a
// lever will selectively pull down on a rod which can be connected to
// the memory address decoder.

include <globs.scad>;

output_slope = 10;
joiner_height = 35;
joiner_width = 3.5;
enumerator_rod_spacing = 10;
hook_clearance = 1;
space_between_triangles = enumerator_rod_spacing*4+joiner_width+6+hook_clearance*2;
$fn=20;

active = true;

pusher_pos = active? -enumerator_rod_travel : 0;
drive_lever_rotate=active ? -10*$t : 0;

function lever_position_y(n) = 3+(joiner_width-3)/2+enumerator_rod_spacing*n;

module hook_plate_2d()
{
  notch_y = 10;
  notch_width = 8;
  plate_height = 50;
  difference() {
    polygon([[0,0], [20,0], [20,plate_height], [0,plate_height], [0,notch_y+10], [notch_width,notch_y+10], [notch_width,notch_y+notch_width*sin(output_slope)], [0,notch_y]]);

    // Hole for the joiner
    translate([3,joiner_height]) square([3,10]);
  }
}

module hook_joiner_2d() {
  difference () {
    union() {
      square([joiner_width,20]);
      translate([-3,5]) square([3+3+joiner_width, 10]);
      translate([-3,20]) square([3+3+joiner_width, 20]);
    }
    // T-slot to connect to the decoder
    translate([0,20]) {
      nut_width = 5.5;
      nut_height = 2.5;
      translate([joiner_width/2-nut_width/2,10]) square([nut_width,nut_height]);
      translate([joiner_width/2-1.5,7]) square([3, 20]);
    }
  }
}

module short_sender_drive_lever_2d() {
  difference() {
    union() {
      translate([-50,-5]) square([50,10]);
      translate([0,0]) circle(d=10);
    }
    circle(d=3); // Main axle
  }
}

module long_sender_drive_lever_2d() {
  difference() {
    union() {
      translate([-50,-5]) square([50,10]);
      translate([0,0]) circle(d=10);
      translate([-40,-40]) square([10,45]);
      translate([-35,-40]) circle(d=10);
    }
    circle(d=3); // Main axle
    translate([-35,-40]) circle(d=3); // Driver pin hole
  }
}

module drive_lever_support_2d() {
  difference() {
    square([10,30]);
    translate([5,20]) square([10,3]);
    translate([5,5]) circle(d=3);
  }
}

module drive_lever_2d() {
  slot_position = 40;
  slot_length = 20;
  difference() {
    union() {
      circle(d=10);
      translate([0,-5]) square([100,10]);
      translate([100,0]) circle(d=10);
      translate([slot_position,0]) circle(d=15);
      translate([slot_position,-7.5]) square([slot_length, 15]);
      translate([slot_position+slot_length,0]) circle(d=15);

    }
    circle(d=3);
    translate([slot_position,0]) circle(d=3);
    translate([slot_position,-1.5]) square([slot_length, 3]);
    translate([slot_position+slot_length,0]) circle(d=3);

    translate([100,0]) circle(d=3);
  }
}

module support_holes() {
  translate([5,10]) circle(d=3);
  translate([20,10]) circle(d=3);
}

module bowden_cable_support_2d() {
  difference() {
    union() {
      translate([0,3]) square([25,20]);
      for(i=[0:2]) translate([i*10,0]) square([5,20]);
    }
    translate([25/2-bowden_cable_inner_diameter/2,-1]) square([bowden_cable_inner_diameter, 10+1]);
    translate([25/2-bowden_cable_outer_diameter/2,10]) square([bowden_cable_outer_diameter, 20]);
    support_holes();
  }
}

module bowden_cable_outer_2d() {
  difference() {
    union() {
      translate([0,3]) square([25,20]);
    }
    support_holes();
  }
}

module intake_slope_2d() {
  triangle_height=7;
  slope_height = 20;
  difference() {
    union() {
      polygon([[0,0], [10,0], [10,triangle_height], [20,triangle_height+5], [0,slope_height]]);
    }
    translate([-5,17]) rotate(-20) square([10,20]);
  }
}

module outer_intake_plate_2d() {
  stagger = 10;
  difference() {
    square([space_between_triangles+6,30]);
    for(bit=[0:4]) {
      raise_input = (bit % 2 == 1) ? stagger : 0;
      translate([enumerator_rod_spacing*bit+7+joiner_width/2,10+raise_input]) circle(d=11);
      translate([enumerator_rod_spacing*bit+7+joiner_width/2,20-raise_input]) circle(d=3);
    }
  }
}

module inner_intake_plate_2d() {
  stagger = 10;

  union() {
    outer_intake_plate_2d();
    for(bit=[0:4]) {
      translate([enumerator_rod_spacing*bit+7,-14]) square([joiner_width,15]);
    }
  }
}

module sender_base_plate_2d()
{
  difference() {
    hull() {
      square([70,space_between_triangles+12]);
      translate([120,lever_position_y(2)+7+1.5]) circle(d=10);
    }
    // Cutouts for input slopes
    for(bit=[0:4]) {
      translate([0,enumerator_rod_spacing*bit]) {
	translate([10,10-3]) square([10,3]);
	translate([10,10-3+joiner_width+3]) square([10,3]);
      }
    }
    // Large cutout for all hook plates
    translate([30-hook_clearance-7,10-3-hook_clearance]) square([20+hook_clearance*2+7,enumerator_rod_spacing*4+joiner_width+6+hook_clearance*2]);

    // Tabs for large triangular plates
    for(x=[-1,60]) {
      #translate([x,3]) square([6,3]);
      #translate([x,6+space_between_triangles]) square([6,3]);
    }
    translate([-1,lever_position_y(2)+7]) square([2,3]);
    translate([50,lever_position_y(2)+7-1]) square([5,5]);

    // Hole and slots for drive cable
    translate([90,lever_position_y(2)+7]) square([5,3]);
    translate([100,lever_position_y(2)+7]) square([5,3]);
    translate([110,lever_position_y(2)+7]) square([5,3]);
  }
}

module sender_triangle_bracket_2d()
{
  axle_position = [50,25];
  difference() {
    union() {
      hull() {
	translate(axle_position) circle(d=10);
	translate([-30,3]) square([5,6]);
	translate([30,3]) square([6,6]);
	translate([-20,60]) circle(d=10);
	translate([30,60]) circle(d=10);
	translate([-30,20]) circle(d=10);
      }
      translate([-30,0]) square([5,6]);
      translate([30,0]) square([6,6]);
    }
    translate(axle_position) circle(d=3);
    // Tabs for intake plates

    translate([-18,18]) rotate(-20) square([3,30]);
    translate([-18,18]) rotate(-20) translate([-10,0]) square([3,30]);

    // Tabs for hanger 'U-channel'
    for(x=[0,1]) {
      translate([-20+x*42,50-10*x]) square([15,3]);
      translate([-20+x*42,50-10*x]) square([3,10]);
      translate([-5+x*42, 50-10*x]) square([3,10]);
    }
  }
}


module hanger_plate_2d() {
  width = space_between_triangles+6;
  difference() {
    square([width,18]);
    translate([7+joiner_width/2+1.5*enumerator_rod_spacing,9]) circle(d=4);
  }
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

  translate([50,0,25]) {
    for(bit=[0:4]) {
      translate([0,lever_position_y(bit),0]) rotate([0,drive_lever_rotate,0]) {
	vertical_plate_x() {
	  if(bit==2) {long_sender_drive_lever_2d();} else { short_sender_drive_lever_2d();}
	}
      }
    }
  }

  translate([-18,-7,18]) rotate([0,20,0]) vertical_plate_y() inner_intake_plate_2d();
  translate([-18,-7,18]) rotate([0,20,0]) translate([-10,0,0]) vertical_plate_y() outer_intake_plate_2d();

  color([0.5,0.5,0]) translate([-30,-10,0]) horizontal_plate() sender_base_plate_2d();

  //color([0.9,0.5,0.8]) translate([0,-4,0]) vertical_plate_x() sender_triangle_bracket_2d();
  color([0.9,0.5,0.8]) translate([0,-1+space_between_triangles,0]) vertical_plate_x() sender_triangle_bracket_2d();

  translate([40,-7,40]) rotate([0,0,90]) horizontal_plate() hanger_plate_2d();
  translate([-2,-7,50]) rotate([0,0,90]) horizontal_plate() hanger_plate_2d();

  translate([-40+6,lever_position_y(2),-20]) vertical_plate_x() drive_lever_support_2d();
  translate([-40+6+5,lever_position_y(2)-3,-15]) vertical_plate_x() rotate(drive_lever_rotate*0.6) drive_lever_2d();

  translate([60,lever_position_y(2),10]) vertical_plate_x() bowden_cable_support_2d();
  translate([60,lever_position_y(2)-3,10]) vertical_plate_x() bowden_cable_outer_2d();
  translate([60,lever_position_y(2)+3,10]) vertical_plate_x() bowden_cable_outer_2d();
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
