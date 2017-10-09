include <globs.scad>;

$fn = 20;

// Subtractor - accumulator unit for millihertz 5

subtractor_pitch_x = 22;
subtractor_pitch_y = 27;

slope = atan2(subtractor_pitch_y, subtractor_pitch_x);

hex_bar_af = 4.75; // 6BA hex bar from Noggin End Metals measured as 4.75mm AF.

// Calculate the max radius of the bar
hex_bar_max_radius = (hex_bar_af / 2) / cos(30);

channel_width = 6.5;

axle_clearance = 0.1;

rot = -20;

module hex_bar_2d() {
    r = hex_bar_max_radius;
    polygon(points = [ [ r * cos(0), r * sin(0) ],
		       [ r * cos(60), r * sin(60) ],
		       [ r * cos(120), r * sin(120) ],
		       [ r * cos(180), r * sin(180) ],
		       [ r * cos(240), r * sin(240) ],
		       [ r * cos(300), r * sin(300) ] ]);
}

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

module generic_support_plate()
{
  polygon(points = [[-180,-220], [-180,-165], [-180+215/tan(slope),50], [10,15], [40,0], [40-220/tan(slope),-220]]);
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
      }
    }
  }
}


// Layer 1 - the input layer

module input_toggle_2d()
{
  difference() {
    top = 2.5;
    union() {
      polygon(points=[[-15, top], [-2.5-6,top], [-2.5, top+6], [-2.5,top+12], [2.5,top+12], [2.5,top+6], [2.5+6,top], [15,top], [10,-top], [-10,-top]]);
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

module input_guard_a_2d()
{
  difference() {
    translate([-subtractor_pitch_x + channel_width/2,-2.5]) square([20,40]);
    circle(r=18, $fn=50);
    // Top input channel
    translate([-channel_width/2,0]) square([channel_width, 100]);
    // Left escape channel
    translate([0,6]) rotate(90+20) translate([-channel_width/2,0]) square([channel_width, 100]);

    // Mounting holes
    input_guard_a_holes();

  }
}

module input_guard_b_2d()
{
  difference() {
    translate([-20,-20]) square([40,20]);
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
    translate([0,6]) rotate(-90-20) translate([-channel_width/2,0]) square([channel_width, 100]);
    // Escape channel of the next toggle
    translate([-subtractor_pitch_x, -subtractor_pitch_y+6]) rotate(-90-20) translate([-channel_width/2,0]) square([channel_width, 100]);
    // Top input channel of the next toggle
    translate([-channel_width/2-subtractor_pitch_x,-subtractor_pitch_y]) square([channel_width, 100]);
    // Left escape channel
    translate([0,6]) rotate(90+20) translate([-channel_width/2,0]) square([channel_width, 100]);

    // Mounting holes
    input_guard_b_holes();
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
    translate([-subtractor_pitch_x + channel_width/2,-20]) square([subtractor_pitch_x-channel_width/2,60]);
    translate([-channel_width/2,10]) circle(r=8.25, $fn=50);
    translate([channel_width/2,10]) circle(r=8.25, $fn=50);
    translate([0,0]) circle(r=6, $fn=50);

    // Drain channel
    translate([-channel_width-5, 0]) square([channel_width, 10]);
    translate([-channel_width/2-5, 0]) circle(d=channel_width);

    // '1'-output channel
    translate([5, -5]) square([channel_width, 15]);
    translate([channel_width/2+5, -5]) circle(d=channel_width);

    // Top input channel
    translate([-channel_width/2,0]) square([channel_width, 100]);


    // Cutout of the next toggle
    translate([-subtractor_pitch_x+channel_width/2, -subtractor_pitch_y+10]) circle(r=8.25, $fn=50);
    // '1'-output channel of the next toggle
    translate([5-subtractor_pitch_x, -5-subtractor_pitch_y]) square([channel_width, 15]);

    // Mounting holes
    input_guard_a_holes();

    // Make an extra hole to clear input guard B
    translate([0,-12.5]) circle(d=3);
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

	// Drain hole for output
	translate([-channel_width/2-5, 0]) circle(d=channel_width+1);

	// Hole for hex axle
	translate([0, 0]) circle(r=hex_bar_max_radius+axle_clearance);
      }
    }
  }
}


// Layer 4 - Reset toggles

reset_rot = 30;
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
	  translate([-7.5,-200]) square([10,210]);
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

for(i=[0:7]) {
  translate([0,0,3]) {
    color([0.5,0.5,0.5]) linear_extrude(height=3) top_layer_2d();
  }

  if(1) {
    translate([-i*subtractor_pitch_x, -i*subtractor_pitch_y,0]) {
      color([1.0,0,0]) linear_extrude(height=3) rotate(rot) input_toggle_2d();
      linear_extrude(height=3) input_guard_a_2d();
      linear_extrude(height=3) input_guard_b_2d();
    }
  }
  translate([-i*subtractor_pitch_x, -i*subtractor_pitch_y,-6]) {
    color([0,1,0]) linear_extrude(height=3) rotate(rot) output_toggle_2d();
    linear_extrude(height=3) output_guard_a_2d();
  }
  translate([0,0,-3]) {
    color([0.5,0.5,0.5]) linear_extrude(height=3) io_support_layer_2d();
  }
  translate([0,0,-9]) {
    color([0.5,0.5,0.5]) linear_extrude(height=3) back_layer_2d();
  }
  translate([-i*subtractor_pitch_x, -i*subtractor_pitch_y,-12]) {
    color([0.5,0.5,0.5]) linear_extrude(height=3) rotate(rot) reset_toggle_2d();
    if(i % 4 == 0) translate([0,0,-3]) color([1.0,1.0,0.5]) linear_extrude(height=3) reset_lever_2d(); // Reset lever is already rotated, as it's offset
  }
  translate([0,0,-12]) color([1.0,1.0,0.5]) linear_extrude(height=3) reset_bar_2d(); // Reset lever is already rotated, as it's offset
}