#!/usr/bin/env python

# Binary subtractor simulator

# State from 0 to 31, state[0] is bit 0, value 1. state[2] is bit 1, value 4. Etc.
state = [0]*32

# Attempt to subtract one


def dump_state():
    v = 0
    for b in range(0,31):
        if state[b] == 1: v += 1<<b
    print " ".join(map(str,reversed(state))) + " = %d"%v

def set_state(v):
    global state
    bit = 0
    while v > 0:
        state[bit] = 1 if (v & 1) == 1 else 0
        v >>= 1
        bit += 1

def subtract_bit(bit_number):
    global state
    b = bit_number
    while b<32:
        if state[b] == 1:
            state[b] = 0
            return
        else:
            state[b] = 1
        b += 1
    # Overflow - attempt to subtract one from zero! The result is still valid under a two's complement system.
    print("Underflow")
    state[31] = 1

def subtract_one():
    subtract_bit(0)

def subtract_value(v):
    bit = 0
    while v > 0:
        if (v & 1) == 1:
            subtract_bit(bit)
        v >>= 1
        bit += 1

set_state(300)

dump_state()

subtract_one()

dump_state()

subtract_bit(4)

dump_state()

print("Value reset to 300")
set_state(300)

dump_state()

subtract_value(150)

dump_state()
