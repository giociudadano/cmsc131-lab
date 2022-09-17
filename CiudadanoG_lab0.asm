; CiudadanoG_lab0.asm
;
; Author: Gio Carlo Ciudadano
; Date: 2022-09-16
;
; Description:
;	This program takes in two integers represented as va riables 'Jack' and 'Jill' and prints them on
;	console. The variables are then swapped with each other and printed again to show the change in value.
;
; Instructions:
;	nasm -f elf CiudadanoG_lab0.asm -o CiudadanoG_lab0.o
;	ld -m elf_i386 -o lab0 CiudadanoG_lab0.o

segment .bss
	input_jack: resd 16
	input_jill: resd 16

segment .data:
	onlaunchmsg: db 0x0a, "Welcome to Laboratory 1!", 0x0a, 0x0a, "This program takes in two integers represented as variables 'Jack' and 'Jill' and prints them on", 0x0a, "console. The variables are then swapped with each other and printed again to show the change in value.", 0x0a, 0x0a
	onlaunchmsg_len: equ $-onlaunchmsg

	prompt_jack: db "Enter the value of 'Jack': "
	prompt_jack_len: equ $-prompt_jack
	prompt_jill: db "Enter the value of 'Jill': "
	prompt_jill_len: equ $-prompt_jill

	beforefallmsg: db 0x0a, "============ Before the fall ============", 0x0a
	beforefallmsg_len: equ $-beforefallmsg
	afterfallmsg: db 0x0a, "============ After the fall  ============", 0x0a
	afterfallmsg_len: equ $-afterfallmsg

	output_jack: db "The value of 'Jack' is "
	output_jack_len: equ $-output_jack
	output_jill: db "The value of 'Jill' is "
	output_jill_len: equ $-output_jill

segment .text:
	global _start

_start:
	call _header
	call _read_input
	call _show_values
	call _swap_values
	call _show_values
	call _exit

_header:
	mov eax, 4
	mov ebx, 1
	mov ecx, onlaunchmsg
	mov edx, onlaunchmsg_len
	int 0x80
	ret

_read_input:
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt_jack
	mov edx, prompt_jack_len
	int 0x80

	mov eax, 3
	mov ebx, 0
	mov ecx, input_jack
	mov edx, 16
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, prompt_jill
	mov edx, prompt_jill_len
	int 0x80

	mov eax, 3
	mov ebx, 0
	mov ecx, input_jill
	mov edx, 16
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, beforefallmsg
	mov edx, beforefallmsg_len
	int 0x80
	ret

_show_values:
	mov eax, 4
	mov ebx, 1
	mov ecx, output_jack
	mov edx, output_jack_len
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, input_jack
	mov edx, 16
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, output_jill
	mov edx, output_jill_len
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, input_jill
	mov edx, 16
	int 0x80
	ret

_swap_values:
	mov eax, 4
	mov ebx, 1
	mov ecx, afterfallmsg
	mov edx, afterfallmsg_len
	int 0x80

	mov eax, [input_jack]
	mov ebx, [input_jill]
	mov [input_jill], eax
	mov [input_jack], ebx
	int 0x80
	ret

_exit:
	mov eax, 1
	mov ebx, 0
	int 0x80