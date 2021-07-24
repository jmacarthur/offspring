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

returner_support_y = [ 20,100 ];
module memory_base_plate_2d()
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

    // Mounting holes for the returner thing
    for(y=returner_support_y) {
      translate([12,y]) square([10,3]);
    }
  }
}

module memory_top_plate_2d()
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
    // Mounting holes for the returner thing (these exist on both plates)
    for(y=returner_support_y) {
      translate([12,y]) square([10,3]);
    }
    // Cutout for bowden cable support
    translate([50,60]) square([20,3]);

    // Holes for the stators
    for(i=[1:8]) {
      for(x=[30,160]) {
	translate([x-2,i*cell_height])
	  square([20,3]);
      }
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

// Row stator fits inbetween moving horizontal bars to stop bearings falling into the middle gap.
module row_stator_2d() {
  difference() {
    union() {
      translate([13,0]) square([187,17]);
      // tabs
      for(x=[30,160]) {
	translate([x,0]) square([20,20]);
      }

    }
    hull() {
      translate([85,column_width/2+3]) square([25,3]);
      translate([95,column_width/2+2]) square([5,5]);
    }
    for(x=[1:columns]) {
      translate([x*pitch-column_width/2,0]) circle(d=8);
    }
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
      for(y=y_tab_positions) translate([y,-3]) square([10,20+6]);
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
    union() {
      square([210,17]);
      translate([10,0]) square([190,20]);
    }
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

module returner_support_2d() {
  difference() {
    union() {
      translate([0,-3]) square([10,4]);
      translate([0,0]) square([25,10]);
      translate([25,5]) circle(d=10);
    }
    translate([25,5]) circle(d=3);
  }
}

module returner_swing_arm_2d() {
  difference() {
    union() {
      hull() {
	circle(d=10);
	translate([-4-1.5,0]) circle(d=5);
      }
      translate([-8,0]) square([5,15]);
      translate([-8,8]) square([8,5]);
      translate([-5,-20]) square([10,20]);
    }
    circle(d=3);
    translate([0,-10]) circle(d=3);
    translate([0,5]) square([10,20]);
  }
}

module returner_plate_2d() {
  difference() {
    square([120,10]);
    for(y=returner_support_y) {
      translate([y+3,2.5]) square([3,5]);
    }
  }
}


module bowden_cable_holes() {
  translate([10,8]) circle(d=3);
  translate([10,22]) circle(d=3);
}

module bowden_cable_support_2d() {
  difference() {
    square([20,28]);
    bowden_cable_holes();
    translate([-1,15-bowden_cable_inner_diameter/2]) square([30,bowden_cable_inner_diameter]);
    translate([10,15-bowden_cable_outer_diameter/2]) square([30,bowden_cable_outer_diameter]);
  }
}

module bowden_cable_outer_support_2d() {
  difference() {
    translate([0,3]) square([20,25]);
    bowden_cable_holes();
  }
}


interruptor_pos = 0;
mover_pos = 9;



module memory_assembly() {
  linear_extrude(height=3) memory_base_plate_2d();
  translate([0,0,23]) linear_extrude(height=3) memory_top_plate_2d();

  for(x=[1:columns]) {
    translate([pitch*x,14*(rows+1),3]) color([1.0,0,0]) linear_extrude(height=3) scale([1,-1]) deflector_line_2d();
  }

  for(y=[0:rows-1]) {
    color([0.5,0.5,0.5]) translate([mover_pos-2,7+3+2+y*cell_height,6]) rotate([90,0,0]) linear_extrude(height=3) row_mover_2d();
    color([0.5,0.5,1.0]) translate([interruptor_pos-2,7+y*cell_height,6]) rotate([90,0,0]) linear_extrude(height=3) row_interruptor_2d();
    color([0.5,0.5,0.5]) translate([interruptor_pos-2,7+10+y*cell_height,6]) rotate([90,0,0]) linear_extrude(height=3) row_stator_2d();
    color([1.0,0,1.0]) translate([100-3+interruptor_pos-9,y*cell_height,9+column_width/2]) linear_extrude(height=3) row_pusher_2d();
  }

  for(x=x_comb_positions) translate([x,0,3]) color([0.4,0.8,0.8]) rotate([90,0,90]) linear_extrude(height=3) row_comb_2d();

  color([1.0,0.5,0.5]) translate([0,8*cell_height+13,3]) rotate([90,0,0]) linear_extrude(height=3) input_gate_2d();

  for(y=returner_support_y) {
    color([1.0,1.0,0.5]) translate([22,y,26]) rotate([-90,0,0]) linear_extrude(height=3) rotate(180) returner_support_2d();
  }

  translate([-3,0,31]) rotate([0,38,0]) {

    for(y=returner_support_y) {
      translate([0,y+3,0])
	rotate([180,0,0]) vertical_plate_x() returner_swing_arm_2d();
    }
    color([0.5,0.5,0.5]) translate([-3,0,-22.5+7]) vertical_plate_y() returner_plate_2d();
  }

  translate([50,60,23]) vertical_plate_x() bowden_cable_outer_support_2d();
  translate([50,60+3,23]) vertical_plate_x() bowden_cable_support_2d();
  translate([50,60+6,23]) vertical_plate_x() bowden_cable_outer_support_2d();
}


memory_assembly();


// Bearing in storage
translate([26.5,7+3.5,3+ball_bearing_radius]) sphere(d=ball_bearing_diameter, $fn=30);

// Bearing passing by
translate([19.5+21,7+3.5,3+ball_bearing_radius]) sphere(d=ball_bearing_diameter, $fn=30);
