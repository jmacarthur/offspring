/* Ball bearing injector, mk 4. This is meant for 8 ball bearings at a
   time, and may be extended to 32 if successful. It is also meant
   for production with a 3D printer rather than laser cutter. */

include <globs.scad>;

// Pitch of ball bearings after passing through each stage:
stage1_output_pitch = 8;
stage1_output_length = 8*stage1_output_pitch;

$fn=20;
channel_length = 8*ball_bearing_diameter;
channel_radius = (ball_bearing_diameter+1)/2;

ejecting = 1;
thin = 1;
//channel_rotation = (ejecting==1? -45: 45);
channel_rotation = -40;

plate_thickness = 5;
mounting_position_y1 = floor(stage1_output_length/2+5);
mounting_position_y2 = floor(channel_length/2+5);
rotator_axis_distance = 10;  // Distance between centres - swing axle to channel axis

module mounting_holes() {
  // Mounting holes
  translate([-14, mounting_position_y1, -1]) cylinder(d=3,h=plate_thickness+2);
  translate([-14, -mounting_position_y1, -1]) cylinder(d=3,h=plate_thickness+2);
  translate([-35, mounting_position_y2, -1]) cylinder(d=3,h=plate_thickness+2);
  translate([-35, -mounting_position_y2, -1]) cylinder(d=3,h=plate_thickness+2);
}

module rotating_input_channel() {
  // Pivot about a point above the device
  a = rotator_axis_distance;
  difference() {
    cylinder(r=a+channel_radius, h=channel_length+3, $fn=100);
    translate([-a,0,-thin]) cylinder(r=channel_radius, h=channel_length+thin);
    translate([-a-5,-channel_radius,-thin]) cube([5,channel_radius*2,channel_length+thin]);
    // Axle hole
    translate([0,0,-thin]) cylinder(d=3, h=channel_length+5);
  }

}

module rotator_bed() {
  difference() {
    translate([0,-channel_length-3,-5]) cube([19,channel_length+3,10]);
    // Cutout for rotating channel
    translate([13,-channel_length-3-thin,rotator_axis_distance+4]) rotate([270,0,0]) cylinder(r=rotator_axis_distance+4,h=channel_length+3+thin*2, $fn=100);

    // Mounting hole for rotator bed
    translate([13-8,-20,-2.5])  rotate([270,0,0]) cylinder(d=3, h=20+thin);
    translate([13+8,-20,-2.5])  rotate([270,0,0]) cylinder(d=3, h=20+thin);
  }
}

module input_chute() {
  difference() {
    // Big block
    union() {
      translate([0,0,-5]) cube([30,80,20]);
      translate([13,0,4.5]) rotate([10,0,0]) translate([0,3,0]) rotate([270,0,0]) cylinder(r=channel_radius+2, h=80);
    }
    // Input channel
    translate([13,4,4.5]) rotate([10,0,0]) translate([0,-5,0]) rotate([270,0,0]) cylinder(r=channel_radius, h=120);

    // Mounting hole for rotator bed
    translate([13-8,-thin,-2.5])  rotate([270,0,0]) cylinder(d=3, h=20+thin);
    translate([13+8,-thin,-2.5])  rotate([270,0,0]) cylinder(d=3, h=20+thin);
  }
}


module stage1_distributor(bonus_height) {
  difference() {
    union() {
      // Upper plate
      translate([-50-bonus_height,-channel_length/2,0]) cube([30+bonus_height, channel_length, plate_thickness]);

      // Lower plate
      translate([-38,-stage1_output_length/2,0]) cube([28,stage1_output_length, plate_thickness]);

      // Extending bars at the bottom which connect mounting holes
      translate([-18,-stage1_output_length/2-8,0]) cube([8,stage1_output_length+16, plate_thickness]);

      translate([-35, -mounting_position_y2, 0]) cylinder(d=8,h=plate_thickness);
      translate([-35, mounting_position_y2, 0]) cylinder(d=8,h=plate_thickness);

    }
    mounting_holes();
    channel_depth = plate_thickness+1;

    for(i=[0:7]) {
      input_y = ball_bearing_diameter*i-7*ball_bearing_diameter/2;
      output_y = stage1_output_pitch*i-7*stage1_output_pitch/2;
      translate([-50-bonus_height-1,input_y,channel_depth]) rotate([0,90,0]) cylinder(d=ball_bearing_diameter, h=20+bonus_height+1);
      translate([-30,input_y,channel_depth]) rotate([0,90,0]) sphere(d=ball_bearing_diameter);
      translate([-20,output_y,channel_depth]) rotate([0,90,0]) cylinder(d=ball_bearing_diameter, h=21);
      translate([-20,output_y,channel_depth]) rotate([0,90,0]) sphere(d=ball_bearing_diameter);
      pipe_dx = 10;
      pipe_dy = output_y-input_y;
      pipe_length = sqrt(pipe_dx*pipe_dx + pipe_dy*pipe_dy);
      pipe_rotate = atan2(pipe_dy, pipe_dx);
      translate([-30,ball_bearing_diameter*i-7*ball_bearing_diameter/2,channel_depth]) rotate([0,0,pipe_rotate]) rotate([0,90,0]) cylinder(d=ball_bearing_diameter, h=pipe_length);
    }
  }
}


module stage1_assembly() {
  translate([-7,0,rotator_axis_distance+4]) rotate([0,-90+channel_rotation,0]) rotate([90,0,0]) rotating_input_channel();
  translate([-20,0,0]) rotator_bed();
  translate([-20,0,0]) input_chute();
  translate([-3,-ball_bearing_diameter*4,-60]) rotate([0,90,0]) stage1_distributor(2);
  translate([8,-ball_bearing_diameter*4,-60]) rotate([0,0,180]) rotate([0,90,0]) stage1_distributor(14);
}


stage1_assembly();

