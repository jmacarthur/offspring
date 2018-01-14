/* Vertical 16x16 memory cell, 3D assembly */

include <globs.scad>;

columns = memory_columns_per_cell;
rows = 8;
column_width = 7; // Must be bigger than bb diameter
cell_height = 14;
cell_drop = 1; // Amount of slope holding data in place

deflector_angle = 10;

memory_translate_x = -7;

joiner_extension = 2; // If nonzero, this allows a strip to connect all memory cells vertically.
column_spacing = (column_width*3+joiner_extension);

copper = [1.0,0.5,0.0];

module memory_cell(hole)
{
  difference() {
    polygon(points = [[0,0], [column_width,cell_drop], [column_width,0], [column_width*2 + joiner_extension,0],
		      [column_width*2+joiner_extension, cell_height], // Bottom right corner
		      [column_width*2, cell_height], [column_width*2, cell_height-1],
		      [column_width, cell_height - column_width*sin(deflector_angle)-1],
		      [column_width, cell_height - ball_bearing_diameter],
		      [0, cell_height/2-0.5]]); // 0.5 adjustment following testing
    // Cutout for the ball to rise into while retracting row
    translate([column_width-ball_bearing_diameter/2,8.5]) circle(d=ball_bearing_diameter, $fn=20);
    // Alignment hole
    if(hole) {
      translate([column_width*1.5,5]) circle(d=3, $fn=20);
    }
  }
}

/* Deflector is made from Albion alloys brass strip, 6mm x 0.8mm as sold.
   it's actually 6.3mm wide and 0.8mm thick. */
strip_height = 6.3 - 0.25 + 0.2; // Values adjusted by laser-cut grading plate.
strip_width = 0.8 - 0.16 + 0.1;
module deflector_section()
{
  translate([strip_width*sin(deflector_angle),-strip_height*sin(deflector_angle)-strip_width])  rotate(deflector_angle) square([strip_height, strip_width]);
}

module comb_section()
{
  square([strip_height, strip_width]);
}

module deflector()
{
 linear_extrude(height=10) deflector_section();
}

module row_selector(selector_end) {
  selector_length = (selector_end==1 ? columns*pitch+50+9 : columns*pitch+50-9);
  selector_offset = (selector_end==1 ? -24: -18);
  difference() {
    union() {
      translate([selector_offset,0]) square([selector_length, cell_height - 1]);
      h = (cell_height)/2;
      translate([selector_length+selector_offset,0]) polygon(points=[[-1,0], [-1,h-1.5], [0,h-1.5], [3,h+1.5], [3,0], [0,0]]);
      if(selector_end==1) translate([selector_offset,0]) polygon(points=[[-3,cell_height-1], [-3,h-1.5], [0,h+1.5], [1,h+1.5], [1,cell_height-1]]);
      if(selector_end==0) {
	translate([selector_offset-20,0]) square([30,cell_height-1]);
      }
    }
    for(col=[0:columns-1]) {
      translate([7+column_spacing*col,7]) deflector_section();
    }
    if(selector_end==0) translate([-30,cell_height/2]) circle(d=3, $fn=20);
    if(selector_end) translate([column_spacing*columns+25,cell_height/2]) circle(d=3, $fn=20);
  }
}

module row_comb() {
  difference() {
    square([10, cell_height * (rows+1)]);
    for(r=[0:rows]) {
      translate([2,cell_height*r+6]) comb_section();
    }
    translate([5,3]) circle(d=3,$fn=20);
    translate([5,cell_height*rows+10]) circle(d=3,$fn=20);
  }
}

module side_wall() {
  union() {
    square([7,cell_height*rows]);
    translate([0,cell_height*2]) square([10,10]);
    translate([0,cell_height*(rows-2)]) square([10,10]);
  }
}

module base_plate()
{
  difference() {
    translate([-20,0]) square([column_spacing*columns+30, cell_height*(rows+1)]);
    for(x=[-column_width-3,column_spacing*columns-column_width]) {
      translate([x,cell_height*2]) square([3,10]);
      translate([x,cell_height*(rows-2)]) square([3,10]);
    }
    for(x=[-15, column_spacing*columns+1]) {
      translate([x,3]) circle(d=3,$fn=20);
      translate([x,cell_height*rows+10]) circle(d=3,$fn=20);
    }

    for(col=[0:columns-1]) {
      translate([column_width*1.5+column_spacing*col,0]) {
	translate([0,5])circle(d=3, $fn=20);
	translate([0,5+rows*cell_height])circle(d=3, $fn=20);
      }
    }
  }
}

/* -------------------- 3D assembly -------------------- */

module cell_assembly() {
  for(col=[0:columns-1]) {
    translate([column_spacing*col, 0, 0]) {
      union() {
	for(row=[0:rows]) {
	  translate([0,cell_height*row,-3]) linear_extrude(height=6) memory_cell((row % 4==0) || row==rows);
	}
      }
    }
  }
}

module deflector_assembly() {
  translate([column_spacing,0,0])
    for(col=[0:columns-1])
      {
	translate([memory_translate_x,0,3]) translate([column_spacing*(col-1), cell_height, 0]) color(copper) translate([0,0,-10]) deflector();
      }
}

module comb_assembly() {
  for(tb=[0:1]) {
    translate([-10-column_width,0,-10*tb]) linear_extrude(height=3) row_comb();
  }

  // Row combs
  for(r=[0:rows]) {
    translate([-10-column_width+2,cell_height*r+6,-10]) color(copper) linear_extrude(height=13) comb_section();
  }
}

module memory_cell_assembly(selector_end) {
  cell_assembly();
  deflector_assembly();
  translate([memory_translate_x-7,cell_height-7,-7]) linear_extrude(height=3) row_selector(selector_end);

  translate([-3,0,0]) comb_assembly();
  translate([column_width+joiner_extension+4+column_spacing*columns,0,0]) comb_assembly();

  translate([-column_width,0,-4]) rotate([0,-90,0]) linear_extrude(height=3) side_wall();
  translate([column_spacing*columns-4,0,-4]) rotate([0,-90,0]) linear_extrude(height=3) side_wall();

  translate([0,0,3]) linear_extrude(height=3) base_plate();
}

memory_cell_assembly(1);

// There is a gap of 50mm between paths in the centre of the machine in addition to the
// usual 23mm pitch.
color([0,0.7,0.7]) translate([-columns*pitch-50,0]) memory_cell_assembly(0);


/* ---------- Example memory bearings ---------- */
// Entering memory
translate([0, 10.5]) circle(d=ball_bearing_diameter, $fn=20);

// In memory during row return
translate([7 - ball_bearing_diameter/2, 8.7+cell_height]) color([1.0,0,0]) circle(d=ball_bearing_diameter, $fn=20);

// In memory, idle
translate([7 - ball_bearing_diameter/2, 11.8+cell_height*2]) color([1.0,0,0]) circle(d=ball_bearing_diameter, $fn=20);



