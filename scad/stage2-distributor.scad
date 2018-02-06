/* Stage2 Distributor, version 2 - open frame dual slope */

include <globs.scad>;

stage1_output_pitch = 8;
stage2a_output_pitch = 16;
stage2b_output_pitch = pitch;

module stage_plate(input_pitch, output_pitch, depth, width)
{
  centre_width = output_pitch*8.5;
  difference() {
    union() {
      translate([-centre_width/2, 0]) square([centre_width, depth]);
      translate([-width/2, 0]) square([width, 10]);
      translate([-width/2, depth-10]) square([width, 10]);
    }
    for(x=[-4:4]) {
      translate([input_pitch*x, 0]) circle(d=stage1_wire_diameter);
      translate([output_pitch*x, depth]) circle(d=stage1_wire_diameter);
    }
  }
}

module stage2a_plate()
{
  stage_plate(stage1_output_pitch, stage2a_output_pitch, 70);
}


module stage2b_plate()
{
  stage_plate(stage2a_output_pitch, stage2b_output_pitch, 80);
}

module stage_with_wires(input_pitch, output_pitch, depth,width) {
  linear_extrude(height=3) stage_plate(input_pitch, output_pitch, depth, width);
  for(x=[-4:4]) {
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

  }
}


module front_plate() {
  union() {
    translate([-105,0]) square([210,10]);
    translate([-100,0]) square([200,30]);
    translate([-105,20]) square([210,10]);
  }
}

module 3d_stage2_assembly() {
  rotate([-10,0,0]) stage_with_wires(stage1_output_pitch, stage2a_output_pitch, 70,210);
  rotate([10,0,0]) translate([0,stage2b_yoffset,stage2b_zoffset]) rotate([0,0,180]) stage_with_wires(stage2a_output_pitch, stage2b_output_pitch, 80,210);

  translate([105,0,0]) rotate([0,90,0]) linear_extrude(height=3) side_plate();
  translate([0,stage2b_yoffset+9,-30]) rotate([90,0,0]) rotate([0,0,0]) linear_extrude(height=3) front_plate();
}

3d_stage2_assembly();
