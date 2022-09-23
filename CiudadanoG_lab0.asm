; CiudadanoG_lab0.asm
;
; Author: Gio Carlo Ciudadano
; Date: 2022-09-16
;
; Description:
;	This program takes in two integers represented as variables 'Jack' and 'Jill' and prints them on
;	console. The variables are then swapped with each other and printed again to show the change in value.
;
; Instructions:
;	nasm -f elf CiudadanoG_lab0.asm -o CiudadanoG_lab0.o
;	ld -m elf_i386 -o lab0 CiudadanoG_lab0.o

; This segment stores uninitialized or dynamic data. Reserves 16 bytes of memory to store integer information
; for the variables 'Jack' and 'Jill' based on user input.
segment .bss
	input_jack: resd 16
	input_jill: resd 16

; This segment stores initialized or static data. Stores information on text strings related to orienting the user about the
; laboratory, as well as the strings' length as indicated by the _len extension.
segment .data:
	onlaunchmsg: db 0x0a, "Welcome to Laboratory 0!", 0x0a, 0x0a, "This program takes in two integers represented as variables 'Jack' and 'Jill' and prints them on", 0x0a, "console. The variables are then swapped with each other and printed again to show the change in value.", 0x0a, 0x0a
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

; Acts as the main function of the assembly code. Calls respective functions in a specified order.
; The '_show_values' label is called twice, one before the values are swapped and one after.
_start:
	call _header
	call _read_input
	call _show_values
	call _swap_values
	call _show_values
	call _exit

; Prints information on the use of this program and the laboratory of the course for documentation.
_header:
	mov eax, 4					; Writes (eax, 4) to standard output (ebx, 1) the on launch
	mov ebx, 1					; message (ecx, onlaunchmsg) specified in the .data segment with
	mov ecx, onlaunchmsg		; specified length (edx, onlaunchmessage).
	mov edx, onlaunchmsg_len
	int 0x80
	ret

; Prompts the user to insert two values and stores them in memory. After the two values have been inserted,
; a 'before the fall' message is displayed specified in the 'beforefallmsg' string.
_read_input:
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt_jack
	mov edx, prompt_jack_len
	int 0x80

	mov eax, 3					; Reads (eax, 3) from standard input (ebx, 0) the input specified
	mov ebx, 0					; by the user and stores it in the 'input_jack' variable (ecx, input_jack)
	mov ecx, input_jack			; specified in the dynamic .bss segment with a specified length of up to
	mov edx, 16					; 16 characters (edx, 16).
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

; Prints the values of 'Jack' and 'Jill'. This function is called twice by the main function, one before the values are swapped and one after.
; To determine the length of 'Jack' and 'Jill', the '_strlen' function is called which returns the length of the string in [eax, ebx] to [edx].
_show_values:
	mov eax, 4
	mov ebx, 1
	mov ecx, output_jack
	mov edx, output_jack_len
	int 0x80

	mov eax, input_jack			; When '_strlen' is called, the length of the string in [eax, ebx] is
	mov ebx, input_jack			; returned to [edx]. This component is called twice, where [eax, ebx] is
	call _strlen				; assigned the values of 'input_jack' and 'input_jill'.

	mov eax, 4
	mov ebx, 1
	mov ecx, input_jack
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, output_jill
	mov edx, output_jill_len
	int 0x80

	mov eax, input_jill
	mov ebx, input_jill
	call _strlen

	mov eax, 4
	mov ebx, 1
	mov ecx, input_jill
	int 0x80
	ret

; This function iterates through the string [eax] and increments until a null character is found indicating that the program
; has no more characters. If a null character is found, the program terminates by jumping to the '_strlen_end' subfunction. 
_strlen:
	cmp byte[eax], 0			; Checks if the current byte is null (cmp byte[eax], 0) and terminates the loop (jz _strlen_end) if true.
	jz _strlen_end				; For each iteration of the function, we increment the current byte position of [eax] (inc eax) and
	inc eax						; repeat the loop (jmp _strlen) until terminated or [eax] is exhausted.
	jmp _strlen

	_strlen_end:				; On loop termination, we count the number of changes in position (sub eax, ebx) equal to the number of
		sub eax, ebx			; iterations and place the number in [eax]. We then move [eax] to [edx] to be used as the determined
		mov edx, eax			; dynamic string length of the string inserted in [eax, edx]. We return to '_show_values'.
		ret

; Prints the 'after the fall' message to indicate that the values have been swapped.
; Swaps the two values stored in 'input_jack' and 'input_jill' from the function '_read_input'.
_swap_values:
	mov eax, 4
	mov ebx, 1
	mov ecx, afterfallmsg
	mov edx, afterfallmsg_len
	int 0x80

	mov eax, [input_jack]		; Moves the two values from memory 'input_jack' and 'input_jill' to the register [eax] and [ebx].
	mov ebx, [input_jill]		; We then swap the two values from the register by assigning [eax] to 'input_jill' and
	mov [input_jill], eax		; [ebx] to 'input_jack', respectively.
	mov [input_jack], ebx
	int 0x80
	ret

; Exits the program.
_exit:
	mov eax, 1 					; Terminates (eax, 1) the program with a '0' return code (mov ebx, 0).
	mov ebx, 0
	int 0x80