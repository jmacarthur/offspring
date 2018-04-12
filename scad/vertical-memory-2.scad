/* Vertical configurable memory cell, 3D assembly; second version with
   less manual assembly less possibility of binding */

include <globs.scad>;

columns = memory_columns_per_cell;
rows = 8;
column_width = 7; // Must be bigger than bb diameter

joiner_extension = 2;
column_spacing = (column_width*3+joiner_extension); // This is no longer relevant, but necessary to calculate the mounting holes
$fn=30;

y_tab_positions = [20,100];

x_comb_positions = [8,198];


module base_plate_2d()
{
  difference() {
    square([210,130]);

    // Mounting holes to match the v1 vertical memory
    for(x=[5, column_spacing*columns+21]) {
      translate([x,3]) circle(d=3,$fn=20);
      translate([x,cell_height*rows+10]) circle(d=3,$fn=20);
    }
    for(y=y_tab_positions) {
      for(x=x_comb_positions) {
	translate([x,y]) square([3,10]);
      }
    }

    // Mounting holes for deflector lines
    for(col=[1:8]) {
      translate([10.5+col*pitch,4]) circle(d=3);
      translate([10.5+col*pitch,4+8*cell_height]) circle(d=3);
      translate([10.5+col*pitch,4+4*cell_height]) circle(d=3);
    }
  }
}

module deflector_cell_2d() {
  polygon(points=[[7,-1], [7,7], [0,10], [-joiner_extension,14], [14,14], [14,-1]]);
}

module deflector_line_2d() {
  difference() {
    union() {
      for(y=[0:rows]) {
	translate([0,y*cell_height]) deflector_cell_2d();
      }
    }
    translate([7+3.5,10]) circle(d=3);
    translate([7+3.5,10+8*cell_height]) circle(d=3);
    translate([7+3.5,10+4*cell_height]) circle(d=3);
  }
}


module row_mover_2d() {
  difference() {
    union() {
      translate([-10,column_width/2]) square([215,10]);
      xpos = 0;
      for(x=[1:columns]) {
	translate([x*pitch+xpos,0]) polygon([[0,0], [5,0], [7,4], [0,4]]);
	translate([x*pitch+xpos-column_width-3,0]) polygon([[3,0], [0,4], [3,4]]);
      }
      // End stops
      translate([13,column_width/2-1]) square([3,4]);
      translate([200-3-9,column_width/2-1]) square([3,4]);

    }
    // Slot for the pusher
    translate([90,column_width/2+2.5]) square([15,4]);

    translate([-11,column_width/2+2.5]) square([11,5]);
    translate([200,column_width/2+2.5]) square([11,5]);
  }
}

module row_interruptor_2d() {
  difference() {
    union() {
      translate([-10,column_width/2]) square([220,10]);
      for(x=[1:columns]) {
	translate([x*pitch-column_width,0]) square([column_width,5]);
	translate([x*pitch-column_width-1.5,2]) square([column_width+3,5]);
      }

      // End stops
      translate([13,column_width/2-1]) square([3,4]);
      translate([200-3-9,column_width/2-1]) square([3,4]);
    }
    for(x=[1:columns]) {
      translate([x*pitch-column_width-1.5,2]) circle(d=3);
      translate([x*pitch-column_width+1.5+column_width,2]) circle(d=3);
    }
    translate([90,column_width/2+3]) square([5,3]);
    translate([205,column_width/2+5]) circle(d=3);
    translate([-5,column_width/2+5]) circle(d=3);

  }
}


module row_pusher_2d() {
  polygon([[0,4], [-3,4], [0,2], [5,2], [8,4], [5,4], [5,10], [0,12]]);
}


module row_comb_2d() {
  rod_height=column_width/2+3;
  clearance = 0.2;
  difference() {
    union() {
      square([130,20]);
      for(y=y_tab_positions) translate([y,-3]) square([10,4]);
    }
    for(r=[0:7]) {
      translate([r*cell_height+4,rod_height]) square([3+clearance,10+clearance]);
      translate([r*cell_height+4,rod_height+2]) square([8,6]);
      translate([r*cell_height+9-clearance,rod_height]) square([3+clearance,10+clearance]);
    }
    // Tabs for input gate
    translate([8*cell_height+10,10]) square([3+clearance,20]);
  }
}


module input_gate_2d() {
  difference() {
    square([230,20]);
    for(c=[0:7]) {
      translate([c*pitch+29,-1]) square([10,4]);
      translate([c*pitch+18,column_width/2]) circle(d=column_width);
      translate([c*pitch+18-column_width/2,-1]) square([column_width,column_width/2+1]);
    }
    for(x=x_comb_positions) {
      translate([x,-1]) square([3,11]);
    }
  }
}

interruptor_pos = 9;
mover_pos = 0;



module 3d_assembly() {
  linear_extrude(height=3) base_plate_2d();

  for(x=[1:columns]) {
    translate([pitch*x,14*(rows+1),3]) color([1.0,0,0]) linear_extrude(height=3) scale([1,-1]) deflector_line_2d();
  }

  for(y=[0:rows-1]) {
    color([0.5,0.5,0.5]) translate([mover_pos-2,7+3+2+y*cell_height,6]) rotate([90,0,0]) linear_extrude(height=3) row_mover_2d();
    //color([0.5,0.5,1.0]) translate([interruptor_pos-2,7+y*cell_height,6]) rotate([90,0,0]) linear_extrude(height=3) row_interruptor_2d();
    color([1.0,0,1.0]) translate([100-3+interruptor_pos-9,y*cell_height,9+column_width/2]) linear_extrude(height=3) row_pusher_2d();
  }

  for(x=x_comb_positions) translate([x,0,3]) rotate([90,0,90]) linear_extrude(height=3) row_comb_2d();

  color([1.0,0.5,0.5]) translate([0,8*cell_height+13,3]) rotate([90,0,0]) linear_extrude(height=3) input_gate_2d();

}


3d_assembly();


// Bearing in storage
translate([26.5,7+3.5,3+ball_bearing_radius]) sphere(d=ball_bearing_diameter, $fn=30);

// Bearing passing by
translate([19.5+21,7+3.5,3+ball_bearing_radius]) sphere(d=ball_bearing_diameter, $fn=30);
