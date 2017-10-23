/* A test lasercutting cell which is meant to determine what the correct gap width is for a brass strip.
   Brass strip is sold as 0.4mm thick. */

difference() {
  square([100,100]);
  for(x=[1:4]) {
    for(y=[0:2]) {
      translate([16*x,36+26*y]) {
	index = x+y*4; // Index from 1 to 12
	offset(r=(index-6)*0.02) // Each step is 0.02mm, thus up to 0.12mm each direction
	import(file="../f-shape.dxf", layer="Memory outline", convexity=3);
      }
    }
  }
}
