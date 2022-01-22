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

hanger_x = [-16,113];
follower_support_x = [-16, 97, 215];
follower_support_x2 = [97+22, 215-26];
case_depth=280;

gear_separation = 100;

input_shaft_angle = 30;

side_x = [-50,290];
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
    circle(d=cam_base_diameter+20);
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
    rotate([input_shaft_angle,0,0]) translate([0,gear_separation,0]) {
      translate([20,0,0]) rotate([0,-90,0]) input_gear();
      // Input shaft
      translate([-300,0,0]) rotate([0,90,0]) cylinder(d=12,h=400);
    }
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

module instruction_follower_rod_2d() {
  drop_pos = 85;
  len = 250;
  difference() {
    union() {
      translate([-5,-5]) square([len,10]);
      translate([drop_pos,0])
      hull() {
	translate([0,-5]) square([30,10]);
	translate([15,15]) circle(d=10);
      }
    }
    translate([0,0]) circle(d=3);
    translate([drop_pos+15,15]) circle(d=3);

    // Hook on the end to add weights
    translate([len-10,-3]) circle(d=3);
    translate([len-10-1.5,-13]) square([3,10]);
  }
}

module universal_follower_rod_2d() {
  drop_pos = 65;
  len = 200;
  difference() {
    union() {
      translate([-5,-5]) square([len,10]);
      translate([drop_pos,0])
      hull() {
	translate([0,-5]) square([30,10]);
	translate([15,15]) circle(d=10);
      }
    }
    translate([0,0]) circle(d=3);
    translate([drop_pos+15,15]) circle(d=3);

    // Hook on the end to add weights
    translate([len-10,-3]) circle(d=3);
    translate([len-10-1.5,-13]) square([3,10]);
  }
}

module decoder_hanger_2d() {
  clearance = 0.1;
  difference() {
    union() {
      square([40,90]);
      translate([-3,10]) square([46,10]);
      translate([-10,80]) square([60,10]);
    }
    for(i=[0:2]) {
      translate([10+10*i,5]) offset(r=clearance) square([3,30]);
      translate([10+10*i,50]) offset(r=clearance) square([3,20]);
    }
  }
}

module follower_hanger_2d() {
  difference() {
    union() {
      square([20,50]);
      translate([-10,44]) square([40,10]);
    }
    translate([10,5]) circle(d=3);
    translate([-1,15]) square([4,10]);
  }
}


module follower_comb_2d() {
  clearance = 0.1;
  difference() {
    union() {
      translate([3,-5]) square([follower_support_x[1]-follower_support_x[0]-3,49+5]);
      translate([follower_support_x[1]-follower_support_x[0]+3,-5]) square([follower_support_x[2]-follower_support_x[1]-3,49+5]);
      translate([follower_support_x[1]-follower_support_x[0]-2,-25]) square([follower_support_x[2]-follower_support_x[1]+2,25]);
      translate([0,10]) square([follower_support_x[2]-follower_support_x[0]+3,10]);
    }
    for(i=[0:7]) {
      translate([10+14*i,-6]) offset(r=clearance) square([3,15]);
    }

    for(i=[0:5]) {
      xoffset = 10+14*8-5;
      translate([xoffset+23*i+14,-26]) offset(r=clearance) square([3,32]);
      translate([xoffset+23*i,-26]) offset(r=clearance) square([3,32]);
    }
  }
}

module universal_follower_comb_2d() {
  clearance  =0.1;
  difference() {
    union() {
      translate([-20,-10]) square([follower_support_x2[1]-follower_support_x2[0]+3+40, 30]);
    }
    translate([0,-5]) square([3,15]);
    translate([follower_support_x2[1]-follower_support_x2[0],-5]) square([3,15]);
    for(i=[0:5]) {
      xoffset = -18;
      translate([xoffset+23*i+14,-26]) offset(r=clearance) square([3,32]);
      translate([xoffset+23*i,-26]) offset(r=clearance) square([3,32]);
    }
  }
}

module decoder_side_runner_2d() {
  clearance = 0.1;
  difference() {
    union() {
      square([190,30]);
      translate([30,0]) square([165,60]);
    }

    translate([30,10]) square([3,10]);
    translate([159,10]) square([3,10]);
    translate([10,10]) circle(d=3);
    translate([190,55]) circle(d=3);
    for(i=[0:7]) translate([14*i+40,20]) offset(clearance) square([3,50]);
  }
}

module instruction_lever_2d() {
  l1 = 100;
  l2 = 30;
  hole_pos = [[-l1,0],[l1,0], [0,-l2], [0,0]];
  difference() {
    union() {
      translate([-l1,-5]) square([l1*2,10]);
      translate([-5,-l2]) square([10,l2]);
      for(p=hole_pos) translate(p) circle(d=10);
    }
    for(p=hole_pos) translate(p) circle(d=3);
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
    translate([0,y-30,0]) rotate([90,0,0]) linear_extrude(height=3) decoder_side_runner_2d();
  }
  for(y=[3,40]) {    
    translate([10,y,10]) rotate([0,-105,0]) rotate([90,0,0]) linear_extrude(height=3) conrod(25);
  }
  translate([10,0,10]) rotate([0,-105,0]) translate([25,-3,0]) rotate([-90,0,0]) cylinder(d=3, h=50);

  for(y=[13,23,33]) {    
    translate([190,y-30,55]) rotate([0,0,0]) rotate([90,0,0]) linear_extrude(height=3) instruction_lever_2d();
  }

}


module instruction_decoder() {
  translate([-23,-90-30,67]) decoder_rods();
  translate([0, 100, 90+3+10]) {
    for(i=[0:7]) {
      color([0.5,0,0]) translate([14*i-6,0,0]) rotate([-90,0,0]) rotate([0,90,0]) linear_extrude(height=3) instruction_follower_rod_2d();
      translate([14*i+((i%2==0)?3:-2.5)-6,-100,-15]) bearing();
    }
    for(i=[0:9]) {
      xoffset = 8*14;
      translate([xoffset+11.5*i,0,0]) {
	color([0.5,0,0]) translate([((i%2==0)?-2:0.5)-6,-180,0]) rotate([0,0,180]) rotate([-90,0,0]) rotate([0,90,0]) linear_extrude(height=3) universal_follower_rod_2d();
	translate([((i%2==0)?-2:-5)-6,-100,-15]) bearing();
      }
    }


    for(x=hanger_x) {
      color([0,1,0]) translate([x,-233,-41]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) decoder_hanger_2d();
    }
    for(x=follower_support_x) {
      color([0,1,0]) translate([x,-10,-5]) rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) follower_hanger_2d();
    }

    for(x=follower_support_x2) {
      color([0,1,0]) translate([x+3,-170,-5]) rotate([90,0,0]) rotate([0,-90,0]) linear_extrude(height=3) follower_hanger_2d();
    }

    translate([-46,-203,-41]) reset_assembly();
    translate([follower_support_x[0],-7,0]) rotate([90,0,0]) linear_extrude(height=3) follower_comb_2d();
    translate([follower_support_x2[0],-170,0]) rotate([90,0,0]) linear_extrude(height=3) universal_follower_comb_2d();
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

module top_plate_2d() {
  y1 = 17;
  difference() {
    translate([-56,-150]) square([340+6,case_depth]);
    translate([hanger_x[0],-150+y1]) square([hanger_x[1]-hanger_x[0]+3,40]);
    translate([follower_support_x[0],90]) square([follower_support_x[2]-follower_support_x[0]+3,20]);
    translate([follower_support_x2[0],-90]) square([follower_support_x2[1]-follower_support_x2[0]+3,20]);
    for(i=[0:2]) translate([hanger_x[1]+120, -120+y1+11.5+10*i]) circle(d=10.5);
  }
}

module side_plate_2d() {
  difference() {
    square([236,case_depth-30]);  
    translate([100,120]) {
      circle(d=20);
      rotate(-input_shaft_angle) translate([0,gear_separation]) circle(d=15);
    }    
  }
}

module casing() {
  //translate([0,0,136]) color([0.5,0.5,0.5]) linear_extrude(height=6) top_plate_2d();
  for(x=side_x)
    translate([x,-120,-100]) rotate([0,-90,0]) color([0.4,0.4,0.4]) linear_extrude(height=6) side_plate_2d();
}

casing();

translate([-47,0,0]) rotate([0,90,0]) cylinder(d=15,h=333);

translate([-50,0,0]) rotate([0,90,0]) camshaft_bearing();
translate([250,0,0]) rotate([0,90,0]) camshaft_bearing();
