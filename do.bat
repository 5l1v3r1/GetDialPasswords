@echo off
REM make -fMakefile -DDEBUG %1 %2 %3 %4 %5 %6 %7 %8 %9
make -fMakefile %1 %2 %3 %4 %5 %6 %7 %8 %9
del *.obj
del *.res
