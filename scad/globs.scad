/* Global definitions for millihertz 5 */

// Ball bearings are sold as 6mm. We have seen two
// versions, one at 6.35mm (1/4") and one at 6.15mm.

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

bowden_cable_travel = 10;

/* Specific names for the subtractor */
subtractor_pitch_x = pitch;
subtractor_pitch_y = 27;

memory_columns_per_cell = 16;

// centre_gap is a split in the middle of the two lanes
// to join cells together (since we will likely have two
// 16-bit memory cells, and 2 16-bit adders, there will
// be a gap needed to join them.
centre_gap = 50;
