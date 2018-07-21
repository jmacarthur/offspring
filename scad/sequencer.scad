// Cam drive and sequencer unit for mechanical SSEM.


use <generic_conrods.scad>;
use <decoder.scad>;
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
cam_width=5;
// Cam spacing: It's easier if we make this match the decoder default spacing. This can be achieved with a 5mm cam and 3x3mm washers in between.
cam_spacing = 14;

axle_diameter = 20;
bearing_outer_diameter=28; // Fairly typical needle roller bearing 
instruction_positions = 5;

num_cams = 17;

gap_position = 8; // Gap for the drive gear happens after this many cams
gap_width = 40;

follower_axle_y = cam_diameter/2+15;
follower_axle_z = cam_diameter/2;

instruction_axle_y = follower_axle_y+42;
instruction_axle_z = follower_axle_z+25;

// Example cams
module cam_2d() {
  difference() {
    circle(d=cam_diameter);
    circle(d=axle_diameter);
  }
}

module drive_gear() {
  // Modelled on Technobots MOD 2 60 tooth gear
  outer_diameter = 124;
  tooth_width=20;
  bore=20;
  lowest_diameter = 116;
  overall_width=35;
  boss_diameter=70;
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
  for(i=[0:num_cams-1]) {
    offset = (i>=gap_position?gap_width:0);
    translate([cam_spacing*i+offset, 0,0]) rotate([0,90,0]) linear_extrude(height=cam_width) cam_2d();
    translate([cam_spacing*i+offset, follower_axle_y,follower_axle_z]) rotate([0,90,0]) linear_extrude(height=3) follower_2d();

    if(i<instruction_positions) {
      translate([cam_spacing*(i-1)+offset, follower_axle_y+21,cam_diameter/2]) rotate([0,90,0]) linear_extrude(height=3) decoder_drop_rod_2d();
      translate([cam_spacing*(i-1)+offset, instruction_axle_y,instruction_axle_z]) rotate([0,90,0]) linear_extrude(height=3) instruction_output_rod_2d();
    }
  }
  // Bonus follower which is driven by the first cam, to drive CMP or LDN
  translate([cam_spacing*-1, follower_axle_y, cam_diameter/2]) rotate([0,90,0]) linear_extrude(height=3) follower_2d();
  translate([cam_spacing*gap_position,0,0]) rotate([0,90,0]) drive_gear();
}


module outer_plate_2d() {
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

module reader_support_2d() {
  square([50,20]);
}

module reader_assembly() {
  for(y=[0,35]) {
    translate([0,y,0]) rotate([90,0,0]) linear_extrude(height=3) reader_support_2d();
  }
}


decoder_origin_x = -27;
decoder_origin_y = 174;
decoder_origin_z = 40;

module instruction_decoder() {
 
  translate([decoder_origin_x,decoder_origin_y,decoder_origin_z]) decoder_assembly(3);

  // Example enumerator rods

  for(i=[0:2]) {
    translate([decoder_origin_x-7,decoder_origin_y+5+10*i,decoder_origin_z+10]) rotate([90,0,0]) linear_extrude(height=3) enumerator_rod(i, 3, 14, 5, 10);
  }
}

module sequencer_assembly() {
  color([0.7,0.7,0]) translate([-30,0,0]) rotate([0,90,0]) linear_extrude(height=3) outer_plate_2d();
  camshaft();
  instruction_decoder();
  translate([decoder_origin_x-50,decoder_origin_y-2,decoder_origin_z+10]) reader_assembly();
}

sequencer_assembly();
