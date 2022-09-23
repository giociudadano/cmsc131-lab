; CiudadanoG_lab1.asm
;
; Author: Gio Carlo Ciudadano
; Date: 2022-09-23
;
; Description:
;	This program takes in two integers represented as variables 'Jack' and 'Jill' and prints them on
;	console. The variables are then swapped with each other and printed again to show the change in value.
;
; Instructions:
;	nasm -f elf CiudadanoG_lab1.asm -o CiudadanoG_lab1.o
;	ld -m elf_i386 -o lab1 CiudadanoG_lab1.o

segment .bss
	password: resb 5
	print_counter: resb 1

segment .data:
	onlaunchmsg: db 0x0a, "Welcome to Laboratory 1!", 0x0a, 0x0a, "PROBLEM: The code uses each digit from 1-5 only once. The first two digits add up to 8. The difference of the second and fifth digits is equal to the fourth digit. The middle digit is the quotient when the product of the first and last digit is divided by 6. Get the code and you get the treasure.", 0x0a, 0x0a
	onlaunchmsg_len: equ $-onlaunchmsg

	printpasscodemsg: db "The code is "
	printpasscodemsg_len: equ $-printpasscodemsg

	newline: db 0x0a, 0x0a

segment .text:
	global _start

_start:
	call _header
	call _print_passcode
	call _exit

_header:
	mov eax, 4					; Writes (eax, 4) to standard output (ebx, 1) the on launch
	mov ebx, 1					; message (ecx, onlaunchmsg) specified in the .data segment with
	mov ecx, onlaunchmsg		; specified length (edx, onlaunchmessage).
	mov edx, onlaunchmsg_len
	int 0x80
	ret

_print_passcode:
	mov eax, 4
	mov ebx, 1
	mov ecx, printpasscodemsg 
	mov edx, printpasscodemsg_len
	int 0x80

	mov esi, password
	mov edi, 4

	_print_passcode_loop:
		mov eax, 4
		mov ebx, 1
		mov ecx, [esi]
		add ecx, 48
		push ecx
		mov ecx, esp
		mov edx, 2
		int 0x80

		pop ecx
		add esi, 1
		dec edi
		jns _print_passcode_loop

		mov eax, 4
		mov ebx, 1
		mov ecx, newline
		mov edx, 1
		int 0x80

_exit:
	mov eax, 1 					; Terminates (eax, 1) the program with a '0' return code (mov ebx, 0).
	mov ebx, 0
	int 0x80