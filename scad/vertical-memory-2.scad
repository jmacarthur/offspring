/* Vertical configurable memory cell, 3D assembly; second version with
   less manual assembly less possibility of binding */

include <globs.scad>;

columns = memory_columns_per_cell;
rows = 8;
column_width = 7; // Must be bigger than bb diameter

joiner_extension = 2;
column_spacing = (column_width*3+joiner_extension); // This is no longer relevant, but necessary to calculate the mounting holes
$fn=30;

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
  polygon(points=[[7,-1], [7,7], [0,10], [-joiner_extension,14], [14,14], [14,-1]]);
}

module deflector_line_2d() {
  union() {
    for(y=[0:rows]) {
      translate([0,y*cell_height]) deflector_cell_2d();
    }
  }
}


module row_mover_2d() {
  difference() {
    union() {
      translate([0,column_width/2]) square([200,10]);
      xpos = 0;
      for(x=[1:columns]) {
	translate([x*pitch+xpos,0]) polygon([[0,0], [0,4], [3,4]]);
	translate([x*pitch+xpos-column_width-3,0]) polygon([[3,0], [0,4], [3,4]]);
      }
    }
    translate([200,column_width/2+3]) square([10,3]);
  }
}

module row_interruptor_2d() {
  difference() {
    union() {
      translate([0,column_width/2]) square([220,10]);
      for(x=[1:columns]) {
	translate([x*pitch-column_width,0]) square([column_width,5]);
	translate([x*pitch-column_width-1.5,2]) square([column_width+3,5]);
      }
    }
    for(x=[1:columns]) {
      translate([x*pitch-column_width-1.5,2]) circle(d=3);
      translate([x*pitch-column_width+1.5+column_width,2]) circle(d=3);
    }
    translate([200,column_width/2+3]) square([10,3]);
  }
}


module row_pusher_2d() {
  polygon([[0,4], [-3,4], [0,2], [10,2], [13,4], [10,4], [10,10], [0,12]]);
}

interruptor_pos = 9;
mover_pos = 9;



module 3d_assembly() {
  linear_extrude(height=3) base_plate_2d();

  for(x=[1:columns]) {
    translate([pitch*x,14*(rows+1),3]) color([1.0,0,0]) linear_extrude(height=3) scale([1,-1]) deflector_line_2d();
  }

  for(y=[0:rows-1]) {
    color([0.5,0.5,0.5]) translate([mover_pos-2,7+3+2+y*cell_height,6]) rotate([90,0,0]) linear_extrude(height=3) row_mover_2d();
    color([0.5,0.5,1.0]) translate([interruptor_pos-2,7+y*cell_height,6]) rotate([90,0,0]) linear_extrude(height=3) row_interruptor_2d();
    color([1.0,0,1.0]) translate([210-3+interruptor_pos-9,y*cell_height,9+column_width/2]) linear_extrude(height=3) row_pusher_2d();
  }
}


3d_assembly();


// Bearing in storage
translate([26.5,7+3.5,3+ball_bearing_radius]) sphere(d=ball_bearing_diameter, $fn=30);

// Bearing passing by
translate([19.5+21,7+3.5,3+ball_bearing_radius]) sphere(d=ball_bearing_diameter, $fn=30);
