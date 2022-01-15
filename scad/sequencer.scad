// Cam drive and sequencer unit for mechanical SSEM.

include <globs.scad>;
use <generic_conrods.scad>;
use <decoder.scad>;
use <interconnect.scad>;
include <sequencer_globs.scad>;
use <generic_conrods.scad>;
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

cam_base_diameter = 150; // Diameter of mounting plates
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

decoder_origin_x = -16;
decoder_origin_y = 65;
decoder_origin_z = 70;

module cam_mounting_holes() {
  for(i=[0:7]) {
    rotate(i*360/8 + (360/16)) translate([0, bolt_circle_diameter/2]) circle(d=8);
  }
}

// Example cams
module cam_mounting_plate_2d() {
  cam_axle_clearance = 0.2;
  difference() {
    circle(d=cam_base_diameter);
    circle(d=cam_inner_diameter+cam_axle_clearance);
    cam_mounting_holes();
  }
}

module cam_ring_2d() {
  difference() {
    circle(d=cam_base_diameter);
    circle(d=cam_base_diameter-36);
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
      color([0.4,0.4,0.4]) linear_extrude(height=cam_support_width) cam_mounting_plate_2d();
      translate([0,0,-3]) linear_extrude(height=3) cam_ring_2d();
      translate([0,0,5]) linear_extrude(height=3) cam_ring_2d();
    }
  }
  for(i=[1:5]) {
    translate([cam_spacing*3+fixed_cam_spacing*i, 0,0]) rotate([0,90,0])  {
      color([0.4,0.4,0.4]) linear_extrude(height=cam_support_width) cam_mounting_plate_2d();
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
    translate([cam_spacing*i, 0,0]) rotate([0,90,0]) linear_extrude(height=cam_width) cam_mounting_plate_2d();
  }
}

follower_x_offset = -3;
function instruction_follower_x(x) = follower_spacing*x+follower_x_offset;
function fixed_follower_x(x) = fixed_cam_spacing*x+follower_x_offset+follower_spacing*8-2;

module reader_support_2d() {
  difference() {
    union() {
      translate([-10,0]) square([60,20]);
      translate([10,-3]) square([10,4]);
      translate([-13,5]) square([4,10]);
      translate([15,0]) square([20,25]);
      for(y=[0,17])
	{
	  translate([15+y,0]) square([3,28]);
	}
      translate([0,15]) square([10,25]);
    }
    translate([5,35]) circle(d=3);
  }
}

module reader_swing_arm_2d() {
  l1 = 33;
  difference() {
    union() {
      circle(d=10);
      translate([-5,-l1]) square([10,l1]);
    }
    circle(d=3);
  }
  
}

module decoder_rods() {
  for(i=[0:2]) {
    translate([0,10*i,0])
    rotate([90,0,0]) linear_extrude(height=3) enumerator_rod(i, 3, 14, 7, 20);
  }
}

module follower_rod_2d() {
  drop_pos = 85;
  difference() {
    union() {
      translate([-5,-5]) square([200,10]);
      translate([drop_pos,0])
      hull() {
	translate([0,-5]) square([30,10]);
	translate([15,15]) circle(d=10);
      }
    }
    translate([0,0]) circle(d=3);
    translate([drop_pos+15,15]) circle(d=3);
  }
}

module decoder_hanger_2d() {
  clearance = 0.1;
  difference() {
    union() {
      square([40,80]);
      translate([-3,10]) square([46,10]);
    }
    for(i=[0:2]) {
      translate([10+10*i,10]) offset(r=clearance) square([3,30]);
    }
  }
}

module decoder_side_runner_2d() {
  difference() {
    square([170,30]);
    translate([30,10]) square([3,10]);
    translate([159,10]) square([3,10]);
    translate([10,10]) circle(d=3);
  }
}


module bearing() {
  rotate([0,90,0])
  difference() {
    cylinder(d=6, h=2.5, $fn=20);
    translate([0,0,-1]) cylinder(d=3,h=12);
  }
}

module reset_assembly() {
  for(y=[0,43]) {
    translate([0,y,0]) rotate([90,0,0]) linear_extrude(height=3) decoder_side_runner_2d();
  }
  for(y=[3,40]) {    
    translate([10,y,10]) rotate([0,-105,0]) rotate([90,0,0]) linear_extrude(height=3) conrod(25);
    translate([10,0,10]) rotate([0,-105,0]) translate([25,-3,0]) rotate([-90,0,0]) cylinder(d=3, h=50);
  }
}


module instruction_decoder() {
  translate([-23-7,-90,67]) decoder_rods();
  translate([-6, 100, 90+3+10]) {
    for(i=[0:7]) {
      color([0.5,0,0]) translate([14*i,0,0]) rotate([-90,0,0]) rotate([0,90,0]) linear_extrude(height=3) follower_rod_2d();
      translate([14*i+((i%2==0)?3:-2.5),-100,-15]) bearing();
    }
    for(x=[-10,119]) {
      color([0,1,0]) translate([x,-203,-46]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) decoder_hanger_2d();
    }
    translate([-40,-203,-46]) reset_assembly();
  }
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

