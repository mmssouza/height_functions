#!/bin/bash

OCTAVE_INCLUDE=/usr/include/octave-3.8.1/octave/
OCTAVE_LIB=/usr/lib/x86_64-linux-gnu/
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB mixDPMatching_C.cpp
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB uniform_interp_C.cpp
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB tar_cost.c
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB weighted0_tar_cost.c

