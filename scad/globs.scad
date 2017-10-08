/* Global definitions for millihertz 5 */

ball_bearing_diameter = 6.28;

pipe_outer_diameter = 11;

/* All dimensions are in millimetres */
memory_slope = 10; // Degrees

/** Memory cell pitch - the horizontal and vertical distances between one row and the next. Memory is arranged so one column (y) make up one word. Words are laid out vertically. */
memory_cell_pitch_x = 16;
memory_cell_pitch_y = 28 * cos(memory_slope);

/* Number of bits used in the data. This must be 32. */
bits = 32;

/** Accumulator / subtractor unit. Pitch is the horizontal spacing between both input and output. */
accumulator_input_pitch = 22;

/** Frame */

frame_internal_width = 900;
frame_internal_height = 2200;

/** Frame will probably be 50mm angle iron */
frame_width = 50;
