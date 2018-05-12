// Memory address sender. Ball bearings can be sent into this and a
// lever will selectively pull down on a rod which can be connected to
// the memory address decoder.

include <globs.scad>;

decoder_travel = 14;
output_slope = 10;

module hook_plate_2d()
{
  notch_y = 10;
  notch_width = 8;
  joiner_height = 25;
  difference() {
    polygon([[0,0], [20,0], [20,40], [0,40], [0,notch_y+10], [notch_width,notch_y+10], [notch_width,notch_y+notch_width*sin(output_slope)], [0,notch_y]]);

    // Hole for the joiner
    translate([3,joiner_height]) square([3,10]);
  }
}

module hook_joiner_2d() {
  union() {
    square([4,20]);
    translate([-3,5]) square([3+3+4, 10]);
  }
}

// 3D assembly

module memory_sender_3d() {
  // Two plates make up each channel
  vertical_plate_x() hook_plate_2d();
  translate([0,3+4,0]) vertical_plate_x() hook_plate_2d();

  // and the joining piece
  color([0.8,0.7,0]) translate([3,0,25-5]) vertical_plate_y() hook_joiner_2d();
}

3d_assembly = true;

if(3d_assembly) {
  memory_sender_3d();
}
