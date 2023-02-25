#!/usr/bin/env python3

""" Cam generation script for Millihertz 5. """


from dataclasses import dataclass

@dataclass
class Event:
    time: float = None
    cam_short_name: str = None
    to_level: float = None
    transition_time: float = 0.05

@dataclass
class Cam:
    short_name: str = None
    description: str = None
    timing_points: list = None
    index: int = None

events = [
    # First inject all event, which sends ball bearings to read the PC
    Event(0.1, "INJ-ALL", to_level=1.0),
    Event(0.2, "INJ-ALL", to_level=0.0),

    # Second inject all event, which sends ball bearings to read the accumulator
    Event(0.7, "INJ-ALL", to_level=1.0),
    Event(0.8, "INJ-ALL", to_level=0.0)
    ]

svg_output_filename = "timing.svg"
openscad_output_filename = "cams.scad"
openscad_time_step = 0.01

# The first 8 cams (0-7) are instruction cams
cams = {
    0: Cam("JMP", "Jump absolute"),
    1: Cam("JRE", "Jump relative"),
    2: Cam("LDN", "Load negative"),
    3: Cam("STO", "Store accumulator"),
    4: Cam("SUB1", "Subtract 1"),
    5: Cam("SUB2", "Subtract 2"),
    6: Cam("CMP", "Compare and skip"),
    7: Cam("HLT", "Halt"),
    8: Cam("INJ-ALL", "Inject ball bearings into all columns"),
    }

def most_recent_value(timing_points, time):
    # Find the most recent value reached before time
    points = [(point_time, value) for (point_time, value) in timing_points if point_time <= time]
    sorted_points = sorted(points, key = lambda x: x[0])
    return (sorted_points[-1])

def nearest_future_value(timing_points, time):
    # Find the value of the cam at or after time
    points = [(point_time, value) for (point_time, value) in timing_points if point_time >= time]
    sorted_points = sorted(points, key = lambda x: x[0])
    return (sorted_points[0])

def process_cams(cams, events):
    cams_by_short_name = dict([(c.short_name, c) for c in cams.values()])
    for (index, cam) in cams.items():
        cam.index = index
        # All cams start at 0 (low) except instruction cams which start at 1.
        if index < 8:
            cam.timing_points = [(0.0,1.0)]
        else:
            cam.timing_points = [(0.0,0.0)]

    # Check for events at t=0 which override the first timing point.
    for e in events:
        if e.time == 0.0:
            cam = cams_by_short_name[e.cam_short_name]
            cam.timing_points = [(0.0, e.to_level)]

    # Now add all events to the respective cams
    for e in events:
        cam = cams_by_short_name[e.cam_short_name]
        (last_time, last_value) = most_recent_value(cam.timing_points, e.time)
        assert e.time - e.transition_time >= last_time
        cam.timing_points.append((e.time - e.transition_time, last_value))
        cam.timing_points.append((e.time, e.to_level))

    # Close cams - write final point
    for c in cams.values():
        c.timing_points.append((1.0, c.timing_points[0][1]))

def interpolate(cam, time):
    # Find the right value of the cam at t...

    (last_time, last_value) = most_recent_value(cam.timing_points, time)
    (next_time, next_value) = nearest_future_value(cam.timing_points, time)

    # If there's an exact match, just return that
    if last_time == time:
        return last_value
    elif next_time == time:
        return next_value
    span = next_time - last_time
    progress = (time - last_time)/span
    return last_value + (next_value - last_value)*progress

def write_svg(svg_filename, cams):
    with open(svg_filename, "w") as f:
        f.write("<svg>\n")
        for c in cams.values():
            yoffset = c.index * 15
            (x,y) = c.timing_points[0]
            path_data = f"M {x*100} {y*-10+yoffset}"
            for (x,y) in c.timing_points[1:]:
                path_data += f" L {x*100} {y*-10+yoffset}"
            f.write(f"<path d=\"{path_data}\" fill=\"none\" stroke=\"black\"/>\n")
            f.write(f"<text x=\"-50\" y=\"{yoffset}\">{c.short_name}</text>\n")
            f.write(f"<text x=\"110\" y=\"{yoffset}\">{c.short_name}</text>\n")
        f.write("</svg>\n")

def write_openscad(filename, cams):
    with open(filename, "w") as f:
        f.write("cam_levels = [\n")
        for cam in cams.values():
            no_steps = int(1/openscad_time_step)
            steps = [ str(interpolate(cam, step*openscad_time_step)) for step in range(0,no_steps) ]
            f.write("[" + ", ".join(steps) + "],\n")
        f.write("]\n")

process_cams(cams, events)
write_svg(svg_output_filename, cams)
write_openscad(openscad_output_filename, cams)
