
set OCTAVE_PATH=c:\Octave\Octave-4.0.1
%OCTAVE_PATH%\bin\mkoctfile.exe --mex -I%OCTAVE_PATH%\include\octave-4.0.1\octave -L%OCTAVE_PATH%\lib\octave\4.0.1 weighted0_tar_cost.c
%OCTAVE_PATH%\bin\mkoctfile.exe --mex -I%OCTAVE_PATH%\include\octave-4.0.1\octave -L%OCTAVE_PATH%\lib\octave\4.0.1 tar_cost.c
%OCTAVE_PATH%\bin\mkoctfile.exe --mex -I%OCTAVE_PATH%\include\octave-4.0.1\octave -L%OCTAVE_PATH%\lib\octave\4.0.1 mixDPMatching_c.cpp