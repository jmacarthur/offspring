/* Vertical configurable memory cell, 3D assembly; second version with
   less manual assembly less possibility of binding */

include <globs.scad>;

columns = memory_columns_per_cell;
rows = 8;
column_width = 7; // Must be bigger than bb diameter

joiner_extension = 2;
column_spacing = (column_width*3+joiner_extension); // This is no longer relevant, but necessary to calculate the mounting holes

module base_plate_2d()
{
  difference() {
    square([220,130]);

    // Mounting holes to match the v1 vertical memory
    for(x=[5, column_spacing*columns+21]) {
      translate([x,3]) circle(d=3,$fn=20);
      translate([x,cell_height*rows+10]) circle(d=3,$fn=20);
    }
  }
}

module deflector_cell_2d() {
  polygon(points=[[7,-1], [7,7], [0,14], [14+joiner_extension,14], [14+joiner_extension,-1]]);
}

module deflector_line_2d() {
  union() {
    for(y=[0:rows]) {
      translate([0,y*cell_height]) deflector_cell_2d();
    }

  }
}

module 3d_assembly() {
  linear_extrude(height=3) base_plate_2d();

  for(x=[1:columns]) {
    translate([pitch*x,14*(rows+1),3]) color([1.0,0,0]) linear_extrude(height=3) scale([1,-1]) deflector_line_2d();
  }
}


3d_assembly();
