GETPW = getpw.obj

!if $d(DEBUG)
TASMDEBUG=/zi
LINKDEBUG=/v
!else
TASMDEBUG=
LINKDEBUG=
!endif

!if $d(MAKEDIR)
IMPORT=$(MAKEDIR)\..\lib\import32
!else
IMPORT=import32
!endif


all: $(GETPW) local.exe remote.exe
local: $(GETPW) local.exe
remote: $(GETPW) remote.exe

.OBJ.EXE:
  brc32 -r $&
  tlink32 /V4.0 /x /Tpe /aa /c $(LINKDEBUG) $&.obj $(GETPW),$&.exe,, $(IMPORT),, $&

.ASM.OBJ:
  tasm32 $(TASMDEBUG) /ml /m2 $&.asm
