// Cam drive and sequencer unit for mechanical SSEM.

include <globs.scad>;
use <generic_conrods.scad>;
use <decoder.scad>;
use <interconnect.scad>;
include <sequencer_globs.scad>;

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
// 1 1 1  HLT

// All the instructions trigger one unique action within the machine,
// except that both JRP and JMP need to trigger the diverter to the
// instruction counter. Hence, the diverter connection is connected to
// JRP, and JMP has a bar attached to the arm which will trigger both
// JRP and JMP when it is engaged. JRP will still function on its own
// without JMP.

cam_diameter = 170; // This includes the cam ridge modules
cam_inner_diameter = 15;
bolt_circle_diameter = 125;

cam_support_width = 5;
cam_width = 3;

axle_diameter = 20;
bearing_outer_diameter=28; // Fairly typical needle roller bearing
instruction_positions = 5;

num_cams = 17;

gap_width = 30;

follower_axle_y = -cam_diameter/2-5;
follower_axle_z = cam_diameter/2;

instruction_axle_y = follower_axle_y-42;
instruction_axle_z = follower_axle_z;


module cam_mounting_holes() {
  for(i=[0:7]) {
    rotate(i*360/8 + (360/16)) translate([0, bolt_circle_diameter/2]) circle(d=8);
  }
}

// Example cams
module cam_2d() {
  cam_axle_clearance = 0.2;
  difference() {
    circle(d=cam_diameter-30);
    circle(d=cam_inner_diameter+cam_axle_clearance);
    cam_mounting_holes();
  }
}

module cam_ring_2d() {
  difference() {
    circle(d=cam_diameter-20);
    circle(d=cam_diameter-45);
    cam_mounting_holes();
  }
}

module gear(tooth_width, bore, n_teeth, boss_diameter, overall_width) {
  // Illustrative gear - teeth are not the right shape.
  modulus = 2.0;
  pitch_diameter = n_teeth*modulus;
  outer_diameter = pitch_diameter+4;
  lowest_diameter = pitch_diameter-4;
  difference() {
    union() {
      cylinder(h=tooth_width, d=outer_diameter);
      translate([0,0,tooth_width-overall_width]) cylinder(h=overall_width, d=boss_diameter);
    }

    for(i=[0:n_teeth]) {
      rotate(i*360/n_teeth) translate([-1.5, lowest_diameter/2, -1]) cube([4,10,tooth_width+2]);
    }
    translate([0,0,tooth_width-overall_width-1]) cylinder(h=overall_width+2, d=bore);
  }
}

module drive_gear() {
  // Modelled on Technobots MOD 2 75 tooth gear
  gear(20, 20, 75, 80, 42);
}

module input_gear() {
  // Modelled on Technobots MOD 2 25 tooth gear
  gear(20, 12, 25, 35, 35);
}

module camshaft() {
  // The first four cam holders hold eight cams which are selectable
  // by instruction.  The next five run ten fixed functions. These can
  // be closer together, as we're not bound by the follower spacing
  // set by the sequencer.
  for(i=[0:3]) {
    translate([cam_spacing*i, 0,0]) rotate([0,90,0]) {
      color([0.4,0.4,0.4]) linear_extrude(height=cam_support_width) cam_2d();
      translate([0,0,-3]) linear_extrude(height=3) cam_ring_2d();
      translate([0,0,5]) linear_extrude(height=3) cam_ring_2d();
    }
  }
  for(i=[1:5]) {
    translate([cam_spacing*3+fixed_cam_spacing*i, 0,0]) rotate([0,90,0])  {
      color([0.4,0.4,0.4]) linear_extrude(height=cam_support_width) cam_2d();
      translate([0,0,-3]) linear_extrude(height=3) cam_ring_2d();
      translate([0,0,5]) linear_extrude(height=3) cam_ring_2d();
    }
  }
  translate([cam_spacing*4+fixed_cam_spacing*5,0,0]) {
    translate([0,0,0]) rotate([0,90,0]) drive_gear();
    rotate([30,0,0]) translate([0,25+75,0]) rotate([0,90,0]) input_gear();
  }
}

module cam_clipons() {
  for(i=[0:3]) {
    translate([cam_spacing*i, 0,0]) rotate([0,90,0]) linear_extrude(height=cam_width) cam_2d();
  }
}

follower_x_offset = -3;
function instruction_follower_x(x) = follower_spacing*x+follower_x_offset;
function fixed_follower_x(x) = fixed_cam_spacing*x+follower_x_offset+follower_spacing*8-2;

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
      translate([-30, slot]) square([20,3]);

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

decoder_origin_x = -13;
decoder_origin_y = -45;
decoder_origin_z = 110;

module instruction_decoder() {
  translate([decoder_origin_x,decoder_origin_y,decoder_origin_z]) decoder_assembly(3, false);
  translate([decoder_origin_x,decoder_origin_y,decoder_origin_z]) enumerator_rods(3);
  translate([decoder_origin_x-50,decoder_origin_y-2,decoder_origin_z+10]) reader_assembly();
  translate([decoder_origin_x+decoder_box_length(3),decoder_origin_y-3,decoder_origin_z+50]) resetter_assembly();
  color([0.7,0.7,0]) translate([decoder_origin_x-3,decoder_origin_y,decoder_origin_z]) rotate([0,90,0]) linear_extrude(height=3) input_support_plate_2d();
}

module sequencer_assembly() {
  camshaft();
  instruction_decoder();
}

sequencer_assembly();

module camshaft_bearing() {
  difference() {
    translate([-43,-43,0]) cube([86,86,33.3]);
    translate([0,0,-1]) cylinder(d=15,h=40);
    for(x=[-32,32]) {
      for(y=[-32,32]) {
	translate([x,y,-1]) cylinder(d=10,h=40);
      }
    }
  }
}

translate([-47,0,0]) rotate([0,90,0]) cylinder(d=15,h=333);

translate([-50,0,0]) rotate([0,90,0]) camshaft_bearing();
translate([270,0,0]) rotate([0,90,0]) camshaft_bearing();

