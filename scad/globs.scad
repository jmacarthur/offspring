/* Global definitions for millihertz 5 */

// Ball bearings are sold as 3. They're actually closer to 1/4" (6.35 mm).
// 32 in a row measure at 203mm, giving 6.34mm each.
// Vernier says 6.35 each or 6.35/16.

ball_bearing_diameter = 6.35;

pipe_outer_diameter = 11;

/* All dimensions are in millimetres */
memory_slope = 10; // Degrees

/** Memory cell pitch - the horizontal and vertical distances between one row and the next. Memory is arranged so one column (y) make up one word. Words are laid out vertically. */
memory_cell_pitch_x = 16;
memory_cell_pitch_y = 28 * cos(memory_slope);

/* Number of bits used in the data. This must be 32. */
bits = 32;

/* Global pitch - the horizontal spacing between each bit */
pitch = 23;

/** Frame */

frame_internal_width = 900;
frame_internal_height = 2200;

/** Frame will probably be 50mm angle iron */
frame_width = 50;

/* Bowden cable specs based on lightweight 'snake' cable */

bowden_cable_inner_diameter = 2;
bowden_cable_outer_diameter = 3.5;



