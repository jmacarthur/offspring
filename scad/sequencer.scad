// Cam drive and sequencer unit for mechanical SSEM.

include <globs.scad>;
use <generic_conrods.scad>;
use <decoder.scad>;
use <interconnect.scad>;

// At the moment, there are 17 cams. 4 of these are selective and only drive if certain instructions are in use. The rest are always in use.
// The instructions which need a gate are LDN, STO, JRP, JMP and CMP. LDN and CMP have the same cam pattern so share one (although they must have independent outputs). SUB is the default instruction so does not need a gate; HLT is unimplemented.


// The respective instruction bits are (using conventional representation with LSB on the right)

// 0 0 0  JMP
// 0 0 1  JRP
// 0 1 0  LDN
// 0 1 1  STO
// 1 0 0  SUB
// 1 0 1  Second store, not used
// 1 1 0  CMP

// We will need a decoder with custom enumerator rods to engage only on the first five positions (this could also enable the second store decode).


cam_diameter = 150;
cam_inner_diameter = 100;
bolt_circle_diameter = 125;

cam_width=5;
// Cam spacing: It's easier if we make this match the decoder default spacing. This can be achieved with a 5mm cam and 3x3mm washers in between.
cam_spacing = 14;

axle_diameter = 20;
bearing_outer_diameter=28; // Fairly typical needle roller bearing 
instruction_positions = 5;

num_cams = 17;

gap_position = 8; // Gap for the drive gear happens after this many cams
gap_width = 30;

follower_axle_y = -cam_diameter/2-15;
follower_axle_z = cam_diameter/2;

instruction_axle_y = follower_axle_y-42;
instruction_axle_z = follower_axle_z+25;


module cam_mounting_holes() {
  for(i=[0:7]) {
    rotate(i*360/8 + (360/16)) translate([0, bolt_circle_diameter/2]) circle(d=6);
  }
}

// Example cams
module cam_2d() {
  difference() {
    circle(d=cam_diameter);
    circle(d=cam_inner_diameter);
    cam_mounting_holes();
  }
}

module drive_gear() {
  // Modelled on Technobots MOD 2 75 tooth gear
  outer_diameter = 154;
  tooth_width=20;
  bore=20;
  lowest_diameter = 146;
  overall_width=20;
  boss_diameter=0;
  difference() {
    union() {
      cylinder(h=tooth_width, d=outer_diameter);
      cylinder(h=overall_width, d=boss_diameter);
    }
    
    for(i=[0:60]) {
      rotate(i*360/60) translate([-1.5, lowest_diameter/2, -1]) cube([3,10,tooth_width+2]);
    }
    translate([0,0,-1]) cylinder(h=overall_width+2, d=bore);
  }
}

module axle_holder_spacer_2d() {
  // This is a 3mm spacer between cams which also has a hub to centre it on the axle.
  difference() {
    circle(d=150);
    cam_mounting_holes();
    circle(d=20);
  }
}

module follower_2d() {
  union() {
    conrod(cam_diameter/2);
    // Output blob
    translate([cam_diameter/2-10,4]) square([10,6]);
    // Follower blob
    translate([cam_diameter/2,-5]) circle(d=20);
  }
}

module decoder_drop_rod_2d() {
  union() {
    conrod(cam_diameter/2-25);
    translate([cam_diameter/2-25,-10]) square([10,20]);
  }
}

module instruction_output_rod_2d() {
  union() {
    conrod(cam_diameter/2+15);
    translate([cam_diameter/2+15,-10]) square([10,20]);
  }
}


module camshaft() {
  follower_x_offset = 4;
  for(i=[0:num_cams-1]) {
    offset = (i>=gap_position?gap_width:0);
    translate([cam_spacing*i+offset, 0,0]) rotate([0,90,0]) linear_extrude(height=cam_width) cam_2d();
    translate([cam_spacing*i+offset+follower_x_offset, follower_axle_y,follower_axle_z]) rotate([0,0,180]) rotate([0,90,0]) linear_extrude(height=3) follower_2d();
    
    if(i<instruction_positions) {
      color([0,0.5,0.5]) translate([cam_spacing*(i-1)+offset+follower_x_offset, follower_axle_y-21,cam_diameter/2]) rotate([0,0,180]) rotate([0,90,0]) linear_extrude(height=3) decoder_drop_rod_2d();
      translate([cam_spacing*(i-1)+offset+follower_x_offset, instruction_axle_y,instruction_axle_z]) rotate([0,0,180]) rotate([0,90,0]) linear_extrude(height=3) instruction_output_rod_2d();
    }
  }
  // Bonus follower which is driven by the first cam, to drive CMP or LDN
  translate([cam_spacing*-1+follower_x_offset, follower_axle_y, cam_diameter/2]) rotate([0,0,180]) rotate([0,90,0]) linear_extrude(height=3) follower_2d();
  translate([cam_spacing*gap_position,0,0]) rotate([0,90,0]) drive_gear();

  // Two cam mounting brackets
  for(x=[5, cam_spacing*15+gap_width+5]) {
    color([0.3,0.3,0.3]) translate([x, 0,0]) rotate([0,90,0]) linear_extrude(height=3) axle_holder_spacer_2d();
  }
}



module outer_plate_2d() {
  // Deprecated. Was used to connect the camshaft to the decoder.
  sideplate_holes = [ [0,0,bearing_outer_diameter],
		      [follower_axle_y, follower_axle_z, 3],
  		      [instruction_axle_y, instruction_axle_z, 3],
		      [decoder_origin_y+18, decoder_origin_z, 4],
		      [decoder_origin_y+18, decoder_origin_z+40, 4]];
  instruction_holder_slots = [decoder_origin_y-5, decoder_origin_y+30];
  difference() {
    hull() {
      for(hole=sideplate_holes) {
	translate([-hole[1],hole[0]]) circle(d=hole[2]+10);
      }
      offset(5) {
	for(slot=instruction_holder_slots)
	  translate([-decoder_origin_z-30, slot]) square([20,3]);
      }
    }
    for(hole=sideplate_holes) {
      translate([-hole[1],hole[0]]) circle(d=hole[2]);
    }
    for(slot=instruction_holder_slots)
       #translate([-decoder_origin_z-30, slot]) square([20,3]);

    // Cutout for enumerator rods.
    translate([-decoder_origin_z-35,decoder_origin_y+1]) square([30,25]);
  }
  
}

module input_support_plate_2d() {
  sideplate_holes = [ [18.5, 0, 4],
		      [18.5, -40, 4]];
  instruction_holder_slots = [-5, 30];
  difference() {
    hull() {
      for(hole=sideplate_holes) {
	translate([hole[1],hole[0]]) circle(d=hole[2]+10);
      }
      offset(5) {
	for(slot=instruction_holder_slots)
	  translate([-30, slot]) square([20,3]);
      }
    }
    for(hole=sideplate_holes) {
      translate([hole[1],hole[0]]) circle(d=hole[2], $fn=20);
    }
    for(slot=instruction_holder_slots)
       #translate([-30, slot]) square([20,3]);

    // Cutout for enumerator rods.
    translate([-35,1]) square([30,25]);
  }
  
}



module reader_support_2d() {
  union() {
    translate([-10,0]) square([60,20]);
    translate([10,-3]) square([10,4]);
    translate([-13,5]) square([4,10]);
    translate([15,0]) square([20,25]);
    for(y=[0,17])
      {
	translate([15+y,0]) square([3,28]);
      }
  }
}

module reader_input_plate_2d() {
  difference() {
    w=38;
    square([20,w]);
    for(y=[-1,17])
      {
	translate([y,-1]) square([4,4]);
	translate([y,w-3]) square([4,4]);
      }
    for(i=[0:2]) {
      translate([8,5.5+3+10*i]) circle(d=pipe_outer_diameter,$fn=50);
    }
  }
}

module reader_base_2d() {
  difference() {
    w=38;
    square([26,w]);
    translate([10,-1]) square([10,4]);
    translate([10,w-3]) square([10,4]);
  }
}

module reader_pusher_2d() {
  difference() {
    translate([-10,0]) square([42,32]);
    for(c=[0:2]) {
      translate([23,5.5+c*10]) circle(d=7, $fn=20);
      translate([23,5.5+c*10-3.5]) square([10,7]);
      translate([18,7+c*10-3.5]) square([20,4]);
    }
    translate([0,15]) cable_clamp_cutout_2d();
    translate([-15,15+0.5]) square([20,bowden_cable_inner_diameter]);
  }
}

module reader_end_2d() {
  difference() {
    hull() {
      square([38,20]);
      translate([23.5,-10]) circle(d=10);
    }
    translate([-1,5]) square([4,10]);
    translate([35,5]) square([4,10]);
    translate([18+0.5+bowden_cable_inner_diameter/2,4]) circle(d=bowden_cable_outer_diameter,$fn=20);
    // Hole to attach to main decoder body
    translate([23.5,-10]) circle(d=4);
  }
}

module reader_assembly() {
  for(y=[0,35]) {
    color([0.1,0.5,0.5]) translate([0,y,0]) rotate([90,0,0]) linear_extrude(height=3) reader_support_2d();
  }
  translate([0,-3,-3]) rotate([0,0,0]) linear_extrude(height=3) reader_base_2d();
  translate([15,-3,25]) rotate([0,0,0]) linear_extrude(height=3) reader_input_plate_2d();
  travel = 0;
  color([0.5,0.1,0.1]) translate([0,0,2]) rotate([0,0,0]) linear_extrude(height=3) reader_pusher_2d();
  translate([23,5.5,3]) sphere(d=ball_bearing_diameter, $fn=20);
  translate([-13,-3,0]) rotate([0,0,90]) rotate([90,0,0]) linear_extrude(height=3) reader_end_2d();
}

module resetter_drive_plate_2d() {
  difference() {
    square([20,40]);
    translate([15,12]) scale([-1,1]) cable_clamp_cutout_with_cable_2d();
  }
}

module resetter_end_plate_2d() {
  // This bolts to the two holes usually used for the 'sender' on the decoder.
  difference() {
    union() {
      square([60,40]);
      translate([0,-20]) square([20,21]);
    }
    translate([10,20]) circle(d=4);
    translate([50,20]) circle(d=4);
    translate([33.5,13.5]) circle(d=bowden_cable_outer_diameter,$fn=20);

    // Tabs
    translate([10,0]) square([5,3]);
    translate([40,-1]) square([5,4]);

    
    // Hole for bowden cable
    translate([10,-8]) circle(d=bowden_cable_inner_diameter);
  }
}

module resetter_side_2d() {
  difference() {
    union() {
      square([44,40]);
      translate([0,30]) square([44+3,5]);
      translate([0,0]) square([44+3,5]);
    }
    translate([20,10]) square([50,3]);
  }
}

module resetter_assembly() {
  translate([47,0,0]) rotate([0,90,0]) linear_extrude(height=3) resetter_end_plate_2d();
  translate([27,0,-35]) linear_extrude(height=3) resetter_drive_plate_2d();
  color([0.1,0.1,0.9]) translate([3,3,-45]) rotate([90,0,0]) linear_extrude(height=3) resetter_side_2d();
}


decoder_origin_x = 0;
decoder_origin_y = -45;
decoder_origin_z = 120;

module instruction_decoder() {
  translate([decoder_origin_x,decoder_origin_y,decoder_origin_z]) decoder_assembly(3);
  translate([decoder_origin_x,decoder_origin_y,decoder_origin_z]) enumerator_rods(3);
  translate([decoder_origin_x-50,decoder_origin_y-2,decoder_origin_z+10]) reader_assembly();
  translate([decoder_origin_x+decoder_box_length(3),decoder_origin_y-3,decoder_origin_z+50]) resetter_assembly();
  color([0.7,0.7,0]) translate([decoder_origin_x-3,decoder_origin_y,decoder_origin_z]) rotate([0,90,0]) linear_extrude(height=3) input_support_plate_2d();
}

module sequencer_assembly() {
  //color([0.7,0.7,0]) translate([-30,0,0]) rotate([0,90,0]) linear_extrude(height=3) outer_plate_2d();
  camshaft();
  instruction_decoder();
}

sequencer_assembly();
