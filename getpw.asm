	P386
	MODEL   flat, stdcall
	JUMPS
	LOCALS

INCLUDE W32.inc

EXTRN	LoadLibraryA			: PROC

GLOBAL	getpw				: PROC

PASSWORD_CACHE_ENTRY	STRUCT
	cbEntry		WORD	?	; size of this entry, in bytes
	cbResource	WORD	?	; size of resource name, in bytes
	cbPassword	WORD	?	; size of password, in bytes
	iEntry		BYTE	?	; entry index
	nType		BYTE	?	; type of entry
	abResource	BYTE	?	; start of resource name
PASSWORD_CACHE_ENTRY	ENDS

	DATASEG

Library		DB	"MPR.DLL", NULL
Function	DB	"WNetEnumCachedPasswords", NULL

LF		EQU	0Ah
Format		DB	"%s:%s", LF, NULL

	UDATASEG

Resource	DB	100h DUP (?)
Password	DB	100h DUP (?)
DataPtr		DD	?

	CODESEG

getpw	PROC
	ARG	_DataPtr:DWORD

	call	LoadLibraryA, offset Library
	or	eax, eax
	jz	@@Failed

	call	GetProcAddress, eax, offset Function
	or	eax, eax
	jz	@@Failed

	push	[_DataPtr]
	pop	[DataPtr]
	call	eax, 0, 0, 0FFh, offset PassEntry, 0
	or	eax, eax
	jz	@@Success

	xor	eax, eax
	jmp	@@Failed

@@Success:
	mov	eax, [DataPtr]
	sub	eax, [_DataPtr]
	ret

@@Failed:
	not	eax
	ret
getpw	ENDP


PassEntry PROC
	ARG	p:DWORD, q:DWORD
	USES	ecx, edx, esi, edi

	mov	esi, [p]
        movzx   ecx, WORD PTR [esi.cbResource]
	add	esi, 8
	mov	edi, offset Resource
	rep	movsb
	mov	BYTE PTR [edi], NULL

	mov	esi, [p]
        movzx   ecx, WORD PTR [esi.cbPassword]
        movzx   edx, WORD PTR [esi.cbResource]
	add	esi, 8
        add     esi, edx
	mov	edi, offset Password
	rep	movsb
	mov	BYTE PTR [edi], NULL

	push	offset Password
	push	offset Resource
	push	offset Format
	push	[DataPtr]
	call	_wsprintfA
	add     esp, 4 * 4
	add	[DataPtr], eax

	mov	eax, TRUE
	ret
PassEntry ENDP

END
