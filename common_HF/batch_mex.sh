#!/bin/bash

OCTAVE_INCLUDE=/usr/include/octave-4.0.0/octave/
OCTAVE_LIB=/usr/lib/i386-linux-gnu/
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB -Wa,-march=i686 mixDPMatching_C.cpp
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB uniform_interp_C.cpp
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB tar_cost.c
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB weighted0_tar_cost.c

