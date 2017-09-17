include <globs.scad>

$fn = 20;

/* Memory injector. Sits on top of the machine attached to the data bus bars, and
   sends data into the memory when one is pulled low. */

/* Memory injector pitch is a multiple of ball bearing size, which makes it easier
   to eject from a row of ball bearings. */

injector_pitch = 3*ball_bearing_diameter;

support_positions = [-10,10.5*injector_pitch, 20.5*injector_pitch, 31.5*injector_pitch];

module ejector_plate()
{
  difference() {
    union() {
      translate([-60,-5]) square([155,10]);
      translate([-5,-45]) square([10,40]);
    }
    circle(d=3);
    translate([90,0]) circle(d=3);
    translate([70,0]) circle(d=3);
    translate([-55,0]) circle(d=3);
  }
}


// No longer in use. This is a horizontal connector for use if the data bus is
// solid rods - as we're using string, this isn't necessary any more.
module bus_connector()
{
  linear_extrude(height=3) {
    difference() {
      square([50,10]);
      translate([40,5]) circle(d=3);
      translate([40,5-1.5]) square([20,3]);
      translate([0,5-1.5]) square([10,3]);
    }
  }
}

tab_width = 15;

module support() {
  linear_extrude(height=3) {
    difference() {
      polygon(points=[[-10,0], [20,0], [15,55], [25,55], [80,-10], [80,-20],
		      // Tab to plug into the base plate
		      [50+tab_width, -20], [50+tab_width, -23],
		      [50, -23], [50, -20],

		      // Second tab
		      [20+tab_width, -20], [20+tab_width, -23],
		      [20, -23], [20, -20],

		      [15,-20], [15,-10], [-8,-10]]);
      translate([20,50]) circle(d=3);
      translate([14,-6]) square([3,10]);
      translate([45,15]) square([50,3]);
    }
  }
}

module base_plate() {
  linear_extrude(height=3) {
    difference() {
      translate([-5,-20]) square([80,32 * injector_pitch + 50]);
      for(support_y = support_positions) {
	translate([0,support_y-3]) square([tab_width, 3]);
	translate([30,support_y-3]) square([tab_width, 3]);
      }
      // Mounting holes
      for(y = [0:5]) {
	translate([30,y * 100 + 20]) circle(d=6);
      }
    }
  }
}

module comb() {
  linear_extrude(height=3) {
    difference() {
      clearance = 0.5;
      translate([-30,-20]) square([50,500]);
      for(slot = [0:31]) {
	translate([-31,slot * injector_pitch-3-clearance/2]) {
	  square([20,3+clearance]);
	}
      }
      for(slot = support_positions) {
	translate([-1,slot-3]) {
	  square([10,3]);
	}
      }
    }
  }
}


// Pipe connectors
clearance = 0.5;
connector_separation = ball_bearing_diameter + clearance;
s = connector_separation;
p = pipe_outer_diameter;
// Reduce the connector gap a little so the tube is a tight fit
connector_gap = sqrt(p*p - s*s)-0.5;

module pipe_holder_bar()
{
  difference() {
    translate([0,-20,0])
      cube([3,34*injector_pitch,20]);
    for(bit = [0:31]) {
      translate([-1,bit*injector_pitch-connector_gap/2-1.5,-1]) cube([5,connector_gap,10]);
    }
    // Cut some holes for the supports
    for(y=support_positions) {
      translate([-1,y-3,6]) cube([5,3,10]);
    }
  }
}

module pipe_connector()
{
  translate([0,0,0]) pipe_holder_bar();
  translate([3+connector_separation,0,0]) pipe_holder_bar();
}



/* -------------------- Test section ------------------------ */

for(bit=[0:31]) {
  translate([0,injector_pitch*bit,0])
    rotate([90,0,0])
    linear_extrude(height=3) ejector_plate();
}

for(support_y = support_positions) {
  translate([-20,support_y,-50])  rotate([90,0,0]) support();
}

translate([20,0,-35]) comb();

/* data */
for(y=[0:32*3]) translate([-5-3,-1.5+6*y,-45+1]) sphere(d=6);

translate([-22.5,0,-66]) pipe_connector();

// Bearing support bar

translate([-6,-20,-56]) cube([3,34*injector_pitch,10]);


// Base plate

translate([0,0,-80]) base_plate();
