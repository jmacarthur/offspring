/* Stage2 Distributor, version 2 - open frame dual slope */

include <globs.scad>;

stage1_output_pitch = 8;
stage2a_output_pitch = 16;
stage2b_output_pitch = pitch;
$fn=20;
module stage_plate(input_pitch, output_pitch, depth, width)
{
  centre_width = output_pitch*7.5;
  difference() {
    union() {
      translate([-centre_width/2, 0]) square([centre_width, depth]);
      translate([-width/2, 0]) square([width, 10]);
      translate([-width/2, depth-10]) square([width, 10]);
    }
    for(x=[-4:4]) {
      translate([input_pitch*x, 0]) circle(d=stage1_wire_diameter);
      if(abs(x)==4) {
	// Outer wires don't need to go out so far, so we add a kink half way
	outer_xpos = (3*output_pitch+ball_bearing_diameter)*sign(x);
	translate([outer_xpos, depth]) circle(d=stage1_wire_diameter);
	translate([outer_xpos, depth-20]) circle(d=stage1_wire_diameter);
	translate([outer_xpos, depth-20-stage1_wire_diameter*2]) circle(d=stage1_wire_diameter);
      } else {
	translate([output_pitch*x, depth]) circle(d=stage1_wire_diameter);
      }
    }
  }
}

module stage_with_wires(input_pitch, output_pitch, depth,width) {
  linear_extrude(height=3) stage_plate(input_pitch, output_pitch, depth, width);
  for(x=[-3:3]) {
    color([1.0,0.5,0]) hull() {
      translate([input_pitch*x, 0,3]) sphere(d=stage1_wire_diameter);
      translate([output_pitch*x, depth,3]) sphere(d=stage1_wire_diameter);
    }
  }
}

stage2b_yoffset = 80;
stage2b_zoffset = -35;
module side_plate() {
  difference() {
    translate([-10,-1])
      square([45,100]);
    rotate(-10+90) {
      square([10,3]);
      translate([60,0]) square([10,3]);
    }
    rotate(10+90)
      translate([stage2b_yoffset,stage2b_zoffset])
      scale([-1,1]) // Accounts for 3D 180 rotation
      {
	square([10,3]);
	translate([70,0]) square([10,3]);
      }

    translate([0,stage2b_yoffset+9-3]) {
      square([10,3]);
      translate([20,0])
	square([10,3]);
    }
    // Tab for mounting
    translate([5,5]) square([10,3]);
  }
}

module mounting_plate() {
  mounting_hole_width = 3;
  difference() {
    square([10+mounting_hole_width*12,10]);
    translate([5,5]) circle(d=4);
    translate([5+12*mounting_hole_width,5]) circle(d=4);
  }
}


module front_plate() {
  front_plate_width = 180;
  union() {
    translate([-front_plate_width/2,0,0]) {
      translate([0,0]) square([front_plate_width,10]);
      translate([5,0]) square([front_plate_width-10,30]);
      translate([0,20]) square([front_plate_width,10]);
    }
  }
}

overall_width = 180;

module 3d_stage2_assembly() {
  rotate([-10,0,0]) stage_with_wires(stage1_output_pitch, stage2a_output_pitch, 70,overall_width);
  rotate([10,0,0]) translate([0,stage2b_yoffset,stage2b_zoffset]) rotate([0,0,180]) stage_with_wires(stage2a_output_pitch, stage2b_output_pitch, 80,overall_width);

  translate([105,0,0]) rotate([0,90,0]) linear_extrude(height=3) side_plate();
  translate([0,stage2b_yoffset+9,-30]) rotate([90,0,0]) rotate([0,0,0]) linear_extrude(height=3) front_plate();
  translate([-89,3+5,-15]) rotate([90,0,0]) rotate([0,0,0]) linear_extrude(height=3) mounting_plate();

  // Output bars

  color(bb_trace_colour) for(x=[0:3]) {
    translate([ ball_bearing_radius+pitch*x,ball_bearing_radius-1,-40]) cylinder(d=ball_bearing_diameter, h=10);
    translate([-ball_bearing_radius-pitch*x,ball_bearing_radius-1,-40]) cylinder(d=ball_bearing_diameter, h=10);
  }

}



3d_stage2_assembly();
translate([8*pitch,0,0]) 3d_stage2_assembly();
