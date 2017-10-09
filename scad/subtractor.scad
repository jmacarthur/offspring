include <globs.scad>;

$fn = 20;

// Subtractor - accumulator unit for millihertz 5

subtractor_pitch_x = 22;
subtractor_pitch_y = 27;

hex_bar_af = 5; // TODO: Not actually 5mm! It's 6BA

// Calculate the max radius of the bar
hex_bar_max_radius = (hex_bar_af / 2) / cos(30);

channel_width = 6.5;


module hex_bar_2d() {
    r = hex_bar_max_radius;
    polygon(points = [ [ r * cos(0), r * sin(0) ],
		       [ r * cos(60), r * sin(60) ],
		       [ r * cos(120), r * sin(120) ],
		       [ r * cos(180), r * sin(180) ],
		       [ r * cos(240), r * sin(240) ],
		       [ r * cos(300), r * sin(300) ] ]);
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
    translate([-12.5,20]) circle(d=3);
    translate([-12.5,30]) circle(d=3);
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
    // Left escape channel
    translate([0,6]) rotate(90+20) translate([-channel_width/2,0]) square([channel_width, 100]);

    // Mounting holes
    translate([15,-15]) circle(d=3);
    translate([0,-12.5]) circle(d=3);
  }
}


// Layer 2 - output toggles

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
    translate([-12.5,20]) circle(d=3);
    translate([-12.5,30]) circle(d=3);
  }
}


// Example layout

for(i=[0:7]) {
  if(0) {
    translate([-i*subtractor_pitch_x, -i*subtractor_pitch_y,0]) {
      color([1.0,0,0]) linear_extrude(height=3) rotate(20) input_toggle_2d();
      linear_extrude(height=3) input_guard_a_2d();
      linear_extrude(height=3) input_guard_b_2d();
    }
  }
  translate([-i*subtractor_pitch_x, -i*subtractor_pitch_y,6]) {
    color([0,1,0]) linear_extrude(height=3) rotate(20) output_toggle_2d();
    linear_extrude(height=3) output_guard_a_2d();
  }
}
