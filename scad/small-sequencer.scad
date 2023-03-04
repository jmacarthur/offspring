// The small scale sequencer

use <decoder.scad>;
include <cams.scad>;
cam_max_diameter = 100;
cam_min_diameter = 80;
cam_range = (cam_max_diameter-cam_min_diameter)/2;
cam_boss_diameter = 50;

cam_spacing = 10;

cam_bore = 12;

// Cam ties are the rods which lock against rotation
cam_tie_bore = 6;
cam_tie_radius = 18;

// Internal space in frame is 230mm (inside openbeam)
// 265mm (inside angle iron)
angle_iron_internal_space = 265;
// We require 18 cams.
ncams = 18;
follower_length = 150;


// Where is the follower axis, in relation to the camshaft?
follower_axle_y = follower_length/2-5;
follower_axle_z = cam_max_diameter/2+18;

enumerator_y_spacing = 4;

// Location of the front X bar, which supports the decoder
front_support_y = -61;
front_support_z = 33;

back_support_y = follower_axle_y;
back_support_z = 30;

// This is about half the length! It's the max length from the fulcrum to one arm end.
instruction_lever_len = 100;

// Space from the left inside edge of the frame to the first cam edge
left_xoffset = 35;

// Places where rear axle supports are placed; these are in units of cam spacing
follower_axle_supports = [0,4,8,12,16];

module example_cam_2d() {
  union() {
    difference() {
      circle(d=cam_max_diameter);
      square([cam_max_diameter+1, cam_max_diameter+1]);
      rotate(180) square([cam_max_diameter+1, cam_max_diameter+1]);
    }
    circle(d=cam_min_diameter);
  }
}

module real_cam_2d(cam_index) {
  point_count = len(cam_levels[cam_index]);
  cam_points = [ for(i=[0:point_count-1]) [(cam_levels[cam_index][i]*cam_range+cam_min_diameter/2)*cos(i/point_count*360),
					   (cam_levels[cam_index][i]*cam_range+cam_min_diameter/2)*sin(i/point_count*360)]
		 ];
  polygon(points=cam_points);
}

module cam_holes() {
  bore_clearance = 0.1;
  translate([0,0]) circle(d=cam_bore+bore_clearance);
  translate([cam_tie_radius,0]) circle(d=cam_tie_bore);
  translate([-cam_tie_radius,0]) circle(d=cam_tie_bore);
}

module cam_separator() {
  linear_extrude(height=cam_spacing-3) {
    difference() {
      offset(r=3) hull() cam_holes();
      cam_holes();
    }
  }
}

module example_cam() {
  difference() {
    union() {
      linear_extrude(height=3) real_cam_2d(0);
    }
    translate([0,0,-1]) cylinder(d=cam_bore, h=cam_spacing+2);
    translate([cam_tie_radius,0,-1]) cylinder(d=cam_tie_bore, h=cam_spacing+2);
    translate([-cam_tie_radius,0,-1]) cylinder(d=cam_tie_bore, h=cam_spacing+2);
  }
  color([0,1,1]) translate([0,0,3]) cam_separator();
}

module follower_2d() {
  difference() {
    square([follower_length,10]);
    translate([5,5]) circle(d=3);
    translate([follower_length-5,5]) circle(d=3);
    // Indents for the cam bearing
    translate([follower_length/2-10,-1]) square([5,2]);
    translate([follower_length/2+5,-1]) square([5,2]);
  }
}

module cam_bearing() {
  color([1,1,0])
  difference() {
    translate([0,0,-10]) cube([9,20,30]);
    translate([-1,10,2.5]) rotate([0,90,0]) cylinder(d=3,h=12, $fn=10);
    translate([3-0.5,-1,-11]) cube([4,32,23]);
    translate([3,-1,16]) cube([3,25,20]);
    translate([3,5,15]) cube([3,10,10]);

    // Entry ramps
    translate([4.5,0,-11]) rotate([0,0,45]) translate([-2.5,-2.5,0]) cube([5,5,23]);
  }
}

module follower() {
  translate([0,-follower_length,0])  rotate([90,0,0]) rotate([0,90,0]) linear_extrude(height=3) follower_2d();
  translate([-3,-follower_length/2 - 10,-15]) cam_bearing();
}

module drive_gear() {
  color([1,0,0]) cylinder(d=cam_max_diameter, h=cam_spacing);
}

module cam_and_follower_assembly() {
  for(i=[0:ncams-1]) {
    translate([i*cam_spacing,0,0]) rotate([0,90,0]) rotate([0,0,90])example_cam();
    translate([i*cam_spacing,follower_axle_y+5,follower_axle_z-5]) follower();
  }
  translate([ncams*cam_spacing,0,0]) rotate([0,90,0]) drive_gear();
  translate([0,follower_axle_y, follower_axle_z]) rotate([0,90,0]) cylinder(d=3,h=200);
}


module trimmed_enumerator_rod_2d(i)
{
  difference() {
    union() {
      square([8*10+50,20]);
      translate([16,-5]) square([10,10]);
      translate([36,-5]) square([10,10]);
    }
    translate([50,0]) enumerator_cutouts(i, 8, 10, 5, 10);
  }
}

module enumerator_base() {
  difference() {
    cube([30,enumerator_y_spacing*2+10,15]);
    for(i=[0:2]) {
      translate([-1,3+enumerator_y_spacing*i-0.25,5]) cube([32,3.5,20]);
    }
    // Shorten the separator bars
    translate([-1, 3-0.25, 7]) cube([32, 3*2+3.5,20]);
  }
}

module instruction_lever_2d(reduce) {
  difference() {
    union() {
      translate([reduce,0]) square([instruction_lever_len-reduce,10]);
      translate([instruction_lever_len,0]) square([instruction_lever_len/2,20]);
      translate([instruction_lever_len-5,-20]) square([10,20]);
      translate([instruction_lever_len-15,-10]) square([30,20]);
    }
    translate([instruction_lever_len-15,-10]) circle(r=10);
    translate([instruction_lever_len+15,-10]) circle(r=10);
    translate([instruction_lever_len,5]) circle(d=3);
  }
}

module enumerator_rods() {
  for(i=[0:2]) {
    seq = $t*10;
    offset = floor(seq/(pow(2,i))) % 2;
    translate([-56+offset*5,-50+i*enumerator_y_spacing,front_support_z+10]) rotate([90,0,0]) linear_extrude(height=3) trimmed_enumerator_rod_2d(i);
    color([0,1,1]) translate([-161,-50+i*enumerator_y_spacing,front_support_z+40]) rotate([90,0,0]) linear_extrude(height=3) instruction_lever_2d(i*10);
  }
}

module side_panel_cutouts_2d() {
  hook_y = 10+17.5;
  perf_angle_spacing = 50;

  // Cam axle hole
  circle(d=cam_bore);

  // Follower axle hole
  translate([follower_axle_y, follower_axle_z]) circle(d=3);

  // Hooks to mount to frame
  translate([hook_y,-10]) circle(d=6);
  translate([hook_y, -10 + perf_angle_spacing]) circle(d=6);

  // Space for the front support rod and instruction support
  translate([front_support_y, front_support_z]) square([5,20]);
  translate([front_support_y+20, front_support_z+10]) square([5,20]);

  // Space for teh back support rod
  translate([back_support_y, back_support_z]) square([5,20]);

}

module side_panel_outside_cutouts_2d() {
  hook_y = 10+17.5;
  // Cutouts which don't need to be wholly within the side panel (they can extend outside it)
  translate([hook_y-3,-30]) square([6,20]);

  // Space for the enumerator rods
  translate([front_support_y+5,front_support_z+8]) square([4+enumerator_y_spacing*3,30]);

  // Notches to add a squaring plate to the top
  for(y=[-10,50]) {
    translate([y,77]) square([10,5]);
  }
}

module side_plate_generic_2d() {
  difference() {
    offset(r=10) hull() {
      side_panel_cutouts_2d();
      // This ensures a flat top (so we can add the squaring plate)
      translate([-50,65]) square([100,5]);
    }
    translate([-100,49]) square([80,50]);
    side_panel_cutouts_2d();
    side_panel_outside_cutouts_2d();
  }
}


module squaring_plate_2d() {
  difference() {
    union() {
      translate([5,-20]) square([angle_iron_internal_space-10, 90]);
      translate([0,0]) square([angle_iron_internal_space, 10]);
      translate([0,60]) square([angle_iron_internal_space, 10]);
    }
    for(y=[-15,70-5-3]) {
      translate([left_xoffset-cam_spacing-10,y]) square([cam_spacing*ncams+10, 3]);
    }
  }
}

module follower_comb_2d() {
  clearance = 0.2;
  difference() {
    union() {
      translate([0,-20]) square([cam_spacing*ncams+10,30]);
      translate([-5,0]) square([cam_spacing*ncams+20,10]);
    }
    for(x=[1:ncams]) {
      translate([x*cam_spacing-clearance,-25]) square([3+clearance*2,25]);
      translate([x*cam_spacing-clearance+1.5,-23]) rotate(45) square([10,10], center=true);
    }
  }
}

module enumerator_mount_plate_2d() {
  difference() {
    union() {
      translate([0,-5]) square([angle_iron_internal_space + 15, 25]);

      // Extended start so we can mount the instruction levers
      offset(r=4) {
	hull() {
	  translate([-26,45]) circle(d=3);
	  translate([0,0]) circle(d=3);
	  translate([0,15]) circle(d=3);
	}
      }
    }

    // Instruction lever axle
    translate([-26,45]) circle(d=3);

    // Hole for a pulley which can be used to bias the instruction reset lever
    translate([angle_iron_internal_space - 30, 10]) circle(d=3);

    // Hole for instruction reset pulley
    translate([120, 16]) circle(d=3);

    // Holes to align with side plates
    translate([10,-10]) square([5,10]);
    translate([angle_iron_internal_space+5,-10]) square([5,10]);
  }
}

module back_support_plate_2d() {
  difference() {
    union() {
      translate([10,0]) square([angle_iron_internal_space, 20]);
      translate([15,-5]) square([10, 20]);
      translate([angle_iron_internal_space-5,-5]) square([10, 20]);
    }
    for(i=follower_axle_supports) {
      translate([left_xoffset + cam_spacing/2 + cam_spacing*i,10]) square([3,15]);
    }
  }
}

module follower_axle_support_2d() {
  z = follower_axle_z - back_support_z;
  difference() {
    translate([-10,0]) square([15, z+5]);
    translate([0,z]) circle(d=3);
    translate([-5,-10]) square([5,20]);
  }
}


module instruction_lever_support_2d() {
  difference() {
    union() {
      translate([-30,0]) square([50,50]);
    }
    // Instruction lever axle
    translate([-26,45]) circle(d=3);

    // Cutout for the side plate
    translate([10,-1]) square([5,12]);
  }
}

module frame() {
  frame_x = [-25,-25+angle_iron_internal_space-5];
  for(x=frame_x) {
    color([0,1,0]) translate([x,0,0]) rotate([0,90,0]) linear_extrude(height=5) rotate(90) side_plate_generic_2d();
  }
  color([0.5,0.5,0.5])
  translate([-left_xoffset,0,front_support_z]) {
    translate([0,front_support_y+5,0]) rotate([90,0,0]) linear_extrude(height=5) enumerator_mount_plate_2d();
    translate([0,front_support_y+25,0]) rotate([90,0,0]) linear_extrude(height=5) instruction_lever_support_2d();
  }

  translate([-25-10,0,back_support_z]) {
    translate([0,back_support_y+5,0]) rotate([90,0,0]) linear_extrude(height=5) back_support_plate_2d();
  }

  for(i=follower_axle_supports) {
    translate([3+cam_spacing*(i+0.5),back_support_y,back_support_z]) rotate([0,0,-90]) rotate([90,0,0]) linear_extrude(height=3) follower_axle_support_2d();
  }
  translate([-left_xoffset+10,-10,77]) linear_extrude(height=3) squaring_plate_2d();
  for(y=[-22,55]) translate([-left_xoffset+25,y,77]) rotate([90,0,0]) color([0,1,1]) linear_extrude(height=3) follower_comb_2d();

}

module instruction_reset_tube() {
  difference() {
    cube([50,10,10]);
    translate([-1,1,1]) cube([52,8,8]);
  }
  color([0,0,1]) union() {
    color([0,0,1]) translate([-20,1.5,1.5]) cube([80,7,7]);
    color([0,0,1]) translate([-20,1.5,1.5]) cube([7,20,7]);
    translate([-1.5,5,0]) cylinder(d=3,h=15);
  }
}

module sequencer() {
  cam_and_follower_assembly();
  enumerator_rods();
  for(x=[0,40]) translate([x,-50-3-3,front_support_z+5]) enumerator_base();
  frame();

  translate([100,front_support_y+5,front_support_z+5]) instruction_reset_tube();

  // Emulate perf angle
  translate([-50,10,-200]) {
    cube([25,25,400]);
    translate([angle_iron_internal_space+25,0,0]) cube([25,25,400]);
  }
}

sequencer();

translate([0,-200,0]) example_cam();
