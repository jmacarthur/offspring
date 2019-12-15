// Subtractor - accumulator unit for millihertz 5

include <globs.scad>;

$fn = 20;

slope = atan2(subtractor_pitch_y, subtractor_pitch_x);

channel_width = 6.5;

axle_clearance = 0.1;

rot = -20;

// The position of mounting holes is put in modules so they can be
// edited in one place.

module input_guard_a_holes()
{
  // Mounting holes used by input guard A
  translate([-12.5,20]) circle(d=3);
  translate([-12.5,30]) circle(d=3);
}

module input_guard_b_holes()
{
  // Mounting holes used by input guard B
  translate([15,-15]) circle(d=3);
  translate([0,-12.5]) circle(d=3);
}

module intake_holes()
{
  // Holes for plastic pipe to supply data in
  translate([-3, 55]) circle(d=pipe_outer_diameter);
}

module intake_holes_slot()
{
  // Holes for plastic pipe to supply data in
  translate([-3, 55]) {
    circle(d=pipe_outer_diameter);
    translate([-pipe_outer_diameter/2, 0]) square([pipe_outer_diameter, 30]);
  }
}


module generic_support_plate()
{
    left_edge = -8*subtractor_pitch_x;
    /* Plate is a six-sided arrow shape */
    /*     C
          /|_E
         / D/
       B/  /
        |_/
       A  F
    */
    offset(r=5) hull() {
      for(i=[0:7]) {
      translate([-subtractor_pitch_x*i, -subtractor_pitch_y*i]) {

	input_guard_a_holes();
	input_guard_b_holes();
	intake_holes();
	// Hole for hex axle
	translate([0, 0]) circle(r=hex_bar_max_radius+axle_clearance);
      }
      translate([-subtractor_pitch_x*-1, -subtractor_pitch_y*-1]) {
	input_guard_a_holes();
      }

      }
    }
}

// Layer 0 - Top plate
module top_layer_2d() {
  difference() {
    generic_support_plate();

    for(i=[0:7]) {
      translate([-subtractor_pitch_x*i, -subtractor_pitch_y*i]) {

	input_guard_a_holes();
	input_guard_b_holes();

	// Hole for hex axle
	translate([0, 0]) circle(r=hex_bar_max_radius+axle_clearance);
	intake_holes_slot();

      }
    }
    translate([-subtractor_pitch_x*-1, -subtractor_pitch_y*-1]) {
      input_guard_a_holes();
    }

  }
}


// Layer 1 - the input layer

module input_toggle_2d()
{
  difference() {
      top = 2.75;
      base = -2.5;
    union() {
      polygon(points=[[-15, top], [-2.5-6,top], [-2.5, top+6], [-2.5,top+12], [2.5,top+12], [2.5,top+6], [2.5+6,top], [15,top], [10,base], [-10,base]]);
      translate([0,top+12]) circle(r=2.5);
      circle(r=5);
    }
    // Round corners
    translate([2.5+6, top+6]) circle(r=6);
    translate([-2.5-6, top+6]) circle(r=6);

    // Cutout for hexagon bar
    hex_bar_2d();
  }
}

module input_guard_a_2d(extend)
{
  difference() {
    hull() {
      translate([-subtractor_pitch_x + channel_width/2,-2.5]) square([20,40]);
      translate([-subtractor_pitch_x + channel_width/2+5,55]) circle(d=6);
      if(extend) {
        translate([-subtractor_pitch_x + channel_width/2-20,-2.5]) square([40,40]);
      }
    }
    circle(r=18, $fn=50);
    // Top input channel
    translate([-channel_width/2,0]) square([channel_width, 100]);
    // Left escape channel
    translate([0,6]) rotate(90+20) translate([-channel_width/2,0]) square([channel_width, 100]);

    // Mounting holes
    input_guard_a_holes();

    // Rail mounting holes (these only show up if extend is True)
    translate([-35,20]) circle(d=3);
    translate([-35,30]) circle(d=3);
  }
}

module input_guard_top_2d()
{
  // A special input guard for the rightmost part of the subtractor.
  difference() {
    hull() {
      translate([-subtractor_pitch_x + channel_width/2,-22]) square([25,55]);
      translate([-subtractor_pitch_x + channel_width/2+5,55]) circle(d=6);
    }
    translate([-subtractor_pitch_x, -subtractor_pitch_y]) circle(r=18, $fn=50);

    // Mounting holes
    input_guard_a_holes();

    // Mounting holes to connect to the rail
    translate([-subtractor_pitch_x + channel_width/2+20, 10]) circle(d=3);
    translate([-subtractor_pitch_x + channel_width/2+20, 30]) circle(d=3);
  }
}


module input_guard_b_2d(extend)
{
  difference() {
    width = extend ? 50: 40;
    translate([-20,-20]) square([width,20]);
    // Make a cut-out using the input toggle in two positions
    offset(0.5) {
      union() {
	rotate(20) input_toggle_2d();
	rotate(-20) input_toggle_2d();
	circle(r=5);
      }
    }

    // Cutout of the next toggle
    translate([-subtractor_pitch_x, -subtractor_pitch_y]) circle(r=18, $fn=50);
    // Top input channel
    translate([-channel_width/2,0]) square([channel_width, 100]);
    // Right escape channel
    translate([0,6]) rotate(-90-20) translate([-channel_width/2-10,0]) square([channel_width+10, 100]);
    // Escape channel of the next toggle
    translate([-subtractor_pitch_x, -subtractor_pitch_y+6]) rotate(-90-20) translate([-channel_width/2,0]) square([channel_width, 100]);
    // Top input channel of the next toggle
    translate([-channel_width/2-subtractor_pitch_x,-subtractor_pitch_y]) square([channel_width, 100]);
    // Left escape channel
    translate([0,6]) rotate(90+20) translate([-channel_width/2,0]) square([channel_width, 100]);

    // Mounting holes
    input_guard_b_holes();

    // Rail mounting hole (this only appears if 'extend' is True)
    translate([25,-15]) circle(d=3);
  }
}

// Layer 2 - Support and separation between input and output layer
module io_support_layer_2d() {
  difference() {
    generic_support_plate();

    for(i=[0:7]) {
      translate([-subtractor_pitch_x*i, -subtractor_pitch_y*i]) {

	input_guard_a_holes();
	input_guard_b_holes();

	// Hole for hex axle
	translate([0, 0]) circle(r=hex_bar_max_radius+axle_clearance);
      }
    }
    translate([-subtractor_pitch_x*-1, -subtractor_pitch_y*-1]) {
      input_guard_a_holes();
    }

  }
}


// Layer 3 - output toggles

module output_toggle_2d() {
  difference() {
    union() {
      circle(r=5);
      difference() {
	translate([-5,0]) square([10,15]);
	dx = 40;
	dy = 0;
	translate([10+dx,15+dy]) circle($fn=100, r=10-2.5+dx);
	translate([-10-dx,15+dy]) circle($fn=100, r=10-2.5+dx);
      }
      translate([0,15]) circle(r=2.5);
    }

    // Cutout for hexagon bar
    hex_bar_2d();
  }
}


module output_guard_a_2d()
{
  difference() {
    hull() {
      translate([-subtractor_pitch_x + channel_width/2,-20]) square([subtractor_pitch_x-channel_width/2+3,60]);
      translate([-15,50]) circle(r=3);
      translate([-10,-30]) circle(r=3);
    }

    translate([-channel_width/2,10]) circle(r=8.25, $fn=50);
    translate([channel_width/2,10]) circle(r=8.25, $fn=50);
    translate([0,0]) circle(r=6, $fn=50);

    // Drain channel
    translate([-channel_width-5, 0]) square([channel_width, 10]);
    translate([-channel_width/2-5, 0]) circle(d=channel_width);

    // '1'-output channel
    translate([5, -15]) square([channel_width, 25]);


    // Top input channel
    translate([-channel_width/2,0]) square([channel_width, 100]);


    // Cutout of the next toggle
    translate([-subtractor_pitch_x+channel_width/2, -subtractor_pitch_y+10]) circle(r=8.25, $fn=50);
    // '1'-output channel of the next toggle
    translate([5-subtractor_pitch_x, -15-subtractor_pitch_y]) square([channel_width, 25]);

    // Mounting holes
    input_guard_a_holes();

    // Make an extra hole to clear input guard B
    translate([0,-12.5]) circle(d=3);
  }
}

module output_guard_top_2d()
{
  // A special input guard for the rightmost part of the subtractor.
  difference() {
    hull() {
      translate([-subtractor_pitch_x + channel_width/2,-37]) square([25,70]);
      translate([-subtractor_pitch_x + channel_width/2+5,55]) circle(d=6);
    }

    translate([-subtractor_pitch_x+channel_width/2, -subtractor_pitch_y+10]) circle(r=8.25, $fn=50);

    // Mounting holes
    input_guard_a_holes();

    // '1'-output channel of the next toggle
    translate([5-subtractor_pitch_x-5, -15-subtractor_pitch_y]) square([channel_width+5, 25]);

    // Mounting holes to connect to the rail
    translate([-subtractor_pitch_x + channel_width/2+20, 10]) circle(d=3);
    translate([-subtractor_pitch_x + channel_width/2+20, 30]) circle(d=3);
  }
}



// Layer 4 - Rear support plate
module back_layer_2d() {
  difference() {
    generic_support_plate();

    for(i=[0:7]) {
      translate([-subtractor_pitch_x*i, -subtractor_pitch_y*i]) {
	input_guard_a_holes();
	input_guard_b_holes();
	intake_holes_slot();

	// Drain hole for output
	hull() {
	  translate([-channel_width/2-5, 0]) circle(d=channel_width+1);
	  translate([-channel_width/2-5, -5]) circle(d=channel_width+1);
	}

	// Hole for hex axle
	translate([0, 0]) circle(r=hex_bar_max_radius+axle_clearance);
      }
    }
    translate([-subtractor_pitch_x*-1, -subtractor_pitch_y*-1]) {
      input_guard_a_holes();
    }

  }
}


// Layer 4 - Reset toggles

reset_rot = 0;
module reset_toggle_2d() {
  difference() {
    union() {
      translate([-2.5,0]) square([5,15]);
      circle(r=5);
    }
    hex_bar_2d();
  }
}

module reset_lever_2d() {
  translate([-12.5,30]) {
    rotate(reset_rot) {
      difference() {
	union() {
	  circle(r=5);
	  translate([-5,-20]) square([10,20]);
	  translate([0,-20]) circle(r=5);
	}
	translate([0,0]) circle(d=3);
	translate([0,-20]) circle(d=3);
      }
    }
  }
}


module reset_bar_2d() {
  translate([-12.5+20*sin(reset_rot),30-20*cos(reset_rot)]) {
    rotate(270+slope) {
      difference() {
	union() {
	  translate([-7.5,-250]) square([10,260]);
	}
	dx = subtractor_pitch_x;
	dy = subtractor_pitch_y;
	dist = sqrt(dx*dx+dy*dy);
	translate([0,0]) circle(d=3);
	translate([0,-dist*4]) circle(d=3);
      }
    }
  }
}


// Example layout

module subtractor_assembly() {

  translate([0,0,5]) {
    #linear_extrude(height=3) top_layer_2d();
  }

  translate([0,0,-5]) {
    color([0.5,0.5,0.5]) linear_extrude(height=3) io_support_layer_2d();
  }

  translate([0,0,-15]) {
    color([0.5,0.5,0.5]) linear_extrude(height=3) back_layer_2d();
  }

  for(i=[0:7]) {

    if(1) {
      translate([-i*subtractor_pitch_x, -i*subtractor_pitch_y,0]) {
	color([1.0,0,0]) linear_extrude(height=3) rotate(rot) input_toggle_2d();
        linear_extrude(height=3) input_guard_a_2d(i==7);
        linear_extrude(height=3) input_guard_b_2d(i==0);
      }
    }
    translate([-i*subtractor_pitch_x, -i*subtractor_pitch_y,-10]) {
      color([0,1,0]) linear_extrude(height=3) rotate(rot) output_toggle_2d();
      linear_extrude(height=3) output_guard_a_2d();
    }
    translate([-i*subtractor_pitch_x, -i*subtractor_pitch_y,-21]) {
      color([0.5,0.5,0.8]) linear_extrude(height=3) rotate(rot) reset_toggle_2d();
      if(i % 4 == 0) translate([0,0,-3]) color([1.0,1.0,0.5]) linear_extrude(height=3) reset_lever_2d(); // Reset lever is already rotated, as it's offset
    }
  }
  translate([1*subtractor_pitch_x, 1*subtractor_pitch_y,0]) {
    linear_extrude(height=3) input_guard_top_2d();
  }
  translate([1*subtractor_pitch_x, 1*subtractor_pitch_y,-10]) {
    linear_extrude(height=3) output_guard_top_2d();
  }

  translate([0,0,-21]) color([1.0,1.0,0.5]) linear_extrude(height=3) reset_bar_2d(); // Reset lever is already rotated, as it's offset
}

subtractor_assembly();
//translate([-8*pitch,-8*subtractor_pitch_y]) subtractor_assembly();

color([1.0,0,0]) translate([0,0,0]) cylinder(d=3,h=100);
color([1.0,0,0]) translate([-23*5,-130,0]) cylinder(d=3,h=100);

// Support rails
rotate([90,0,0]) translate([-220,0,-500]) {
  cube([15,15,1000]);
  translate([support_rail_separation,0,0]) cube([15,15,1000]);
}
