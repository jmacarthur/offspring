include <globs.scad>;

$fn = 20;

// Subtractor - accumulator unit for millihertz 5

memory_pitch_x = 22;
memory_pitch_y = 27;

hex_bar_af = 5; // TODO: Not actually 5mm! It's 6BA

// Calculate the max radius of the bar
hex_bar_max_radius = (hex_bar_af / 2) / cos(30);

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
    r = hex_bar_max_radius;
    polygon(points = [ [ r * cos(0), r * sin(0) ],
		       [ r * cos(60), r * sin(60) ],
		       [ r * cos(120), r * sin(120) ],
		       [ r * cos(180), r * sin(180) ],
		       [ r * cos(240), r * sin(240) ],
		       [ r * cos(300), r * sin(300) ] ]);
  }
}





// Example layout

  linear_extrude(height=3) input_toggle_2d();
