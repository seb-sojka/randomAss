TITLE Program random     (random.asm)

; Author Sebastian Sojka
; Class: CS271-400
; Program Number: 4
; Program Name: Random Numbers
; Date: 7/31/2017
; Description: Display a random set of numbers between 100 and 999. 
; User inputs how many numbers to generate ranging 10 to 200

DISPLAYMIN = 10 ;Lower limit to the number of random numbers terms to display 
DISPLAYMAX = 200 ;Upper limit to the number of random numbers to display
LINELIMIT = 10;Number of numbers per a line
RANDLO = 100;Lower limit of a random number
RANDHI = 999;Upper liomit of random number
TAB = 9;ASCII number for tab

INCLUDE Irvine32.inc



.data

promTitle	BYTE	"RANDOM NUMBERS", 0
promPrgmr	BYTE	"By Sebastian Sojka", 0
promFunc1	BYTE	"I will display the number of random number you would like to see.", 0
promFunc2	BYTE	"The random numbers can range fromm 100 to 999", 0
promError	BYTE	"Error - User input outside of set boundary.", 0
promSize	BYTE	"How many random numbers do you want displayed? [10...200] ", 0	
promEnd		BYTE	"Results verfied by Sebastian and Benji, my dog.", 0
promMed		BYTE	"Median: ", 0
promBye		BYTE	"Good bye and have a great day", 0

ranNums		DWORD	200 DUP(?);Array for random numbers, 0 is the end term
num			DWORD	?;Number of numbers to display




.code
main PROC
	;Array of random numbers

	;Seed for random number generation
	call	Randomize

	;Calls intro
	call	intro

	;Gets user input from user
	push	OFFSET num
	call	getInput

	;Display random numbers unsort
	push	OFFSET ranNums
	push	num
	call	getNums

	;Display random numbers unsort
	push	OFFSET ranNums
	push	num
	call	disNums

	;Sorts array of numbers
	push	OFFSET ranNums
	push	num
	call	sort

	;Get and display the median of array of random numbers 
	push	OFFSET ranNums
	push	num
	call	median

	;Display sorted random numbers
	push	OFFSET ranNums
	push	num
	call	disNums

	exit	; exit to operating system
main ENDP

median PROC
	;set up stack frame
	push	ebp
	mov		ebp, esp

	mov		eax, [ebp+8]
	cdq
	mov		ecx, 2
	div		ecx
	dec		eax

	cmp		edx, 0
	je		Nums2
	
	mov		ebx, [ebp+12]
	mov		edx, TYPE ebx
	mul		edx
	add		ebx, eax

	mov		eax, [ebx]	

	jmp		endMed
Nums2:
	mov		ebx, [ebp+12]
	mov		edx, TYPE ebx
	mul		edx
	add		ebx, eax

	mov		ecx, ebx
	add		ecx, TYPE ecx
	
	mov		edx, [ebx]
	mov		eax, [ecx]

	add		eax, edx

	mov		ebx, 2
	cdq		
	div		ebx

	add		eax, edx

endMed:

	mov		edx, OFFSET promMed
	call	WriteString

	call	WriteDec
	call	CrLf
	call	CrLf

	;restore stack
	pop		ebp
	ret		8
median ENDP


;Description: Display name of program, the programmer, and function of the program
;Recives: None
;Returns: None
;register changes: none
intro PROC
	pushad
	;Displays title and author of the program
	;Display title name
	mov		edx, OFFSET promTitle
	call	WriteString

	;Tabs over
	mov		al, TAB
	call	WriteChar

	;Display programmer name (me)
	mov		edx, OFFSET promPrgmr
	call	WriteString
	call	CrLf

	;Display Function of the pogram
	mov		edx, OFFSET promFunc1
	call	WriteString
	call	CrLf

	;Display Function of the pogram
	mov		edx, OFFSET promFunc2
	call	WriteString
	call	CrLf

	popad
	ret
intro ENDP

;Description: Ask user for how many composite numbers to display
;Recives: addresses of parameters on the system stack
;Returns: user input of number of composite numbers to display
;Changed registers: edx, eax, ebx, ecx
getInput PROC
;set up stack frame
	push	ebp
	mov		ebp, esp

userInput:
	;Displays ask user for number of composite numbers to display
	;Prompt user for input
	mov		edx, OFFSET promSize
	call	WriteString

	;Get how many numbers to to display from user
	call	ReadInt
	
	;Checks to see if user input is with range
	push	eax
	call	checkInput	
	jna		endData

	;If error, prompt user of error and loop again to get user input
	mov		edx, OFFSET promError
	call	WriteString
	call	CrLf
	jmp		userInput

endData:

	;Set amound of random numbers to display
	mov		ebx, [ebp+8]
	mov		[ebx], eax

	;restore stack
	pop		ebp
	ret		4

getInput ENDP

;Description: Checks to see if user input is between the limits
;Recives: addresses of parameters on the system stack
;Returns: Returns the results 
checkInput PROC

	;set up stack frame
	push	ebp
	mov		ebp, esp

	;Checks to userinput is within limits
	mov		ebx, [ebp+8]

	;Checks upper limits
	cmp		ebx, DISPLAYMAX
	ja		endCheck

	mov		edx, DISPLAYMIN

	;Checks lower limits
	cmp		edx, ebx
	
endCheck:

	;restore stack
	pop		ebp
	ret		4

checkInput ENDP

;Description: Checks to see if user input is between the limits
;Recives: addresses of parameters on the system stack
;Returns: Returns the results 
getNums PROC
	;set up stack frame
	push	ebp
	mov		ebp, esp

	;Set counter
	mov		ecx, [ebp+8]

	;Sets first element of random number array
	mov		ebx, [ebp+12]

;Loop to get and set random numbers in array
setRand:
		;Sets the range for random number
		mov		eax, RANDHI
		sub		eax, RANDLO
		inc		eax

		;Call random number
		call	RandomRange
		add		eax, RANDLO

		;Moves random number genereated to array
		mov		[ebx], eax

		;Moves to next number in array
		add		ebx, TYPE ebx
		loop	setRand

	;restore stack
	pop		ebp
	ret		8

getNums ENDP

;Description: Checks to see if user input is between the limits
;Recives: addresses of parameters on the system stack
;Returns: Returns the results 
disNums PROC
	;set up stack frame
	push	ebp
	mov		ebp, esp

	;Set first element of number array
	mov		ebx, [ebp+12]
	mov		eax, [ebx]

	;Set counter and line count 
	mov		ecx, [ebp+8]
	mov		edx, LINELIMIT

;Loop to print array of numbers
print:
	;print random number
	call	WriteDec

	;Tabs over
	mov		al, TAB
	call	WriteChar

	;Moves to next element
	add		ebx, TYPE ebx
	mov		eax, [ebx]

	;Decrease line loop by 1
	dec		edx

	;When linelimit is 0, go to next line and set linelimit back to the limit (currently 10)
	cmp		edx, 0
	jne		sameLine
	call	CrLf
	mov		edx, LINELIMIT

sameLine:
	loop		print

	

endPrint:

	call	CrLf
	;restore stack
	pop		ebp
	ret		8

disNums ENDP

;Description: sort array of numbers, quicksort is used
;Recives: addresses of parameters on the system stack
;Returns: Returns the results 
sort PROC
	;set up stack frame
	push	ebp
	mov		ebp, esp

	mov		ecx, [ebp+8]
	dec		ecx
outLoop:
	mov		esi, ecx
	push	ecx
	dec		ecx
innerLoop:
	mov		edi, [ebp+12]
	mov		eax, TYPE ebx
	mul		ecx
	add		edi, eax
	
	mov		ebx, [ebp+12]
	mov		eax, TYPE ebx
	mul		esi
	add		ebx, eax

	mov		eax, [ebx]
	mov		edx, [edi]
	cmp		edx, eax
	jg		notLs
	mov		esi, ecx

notLs:
	cmp		ecx, 0
	jle		endIn
	dec		ecx
	jmp		innerLoop
endIn:
	pop		ecx
	push	ecx
	push	esi
	push	[ebp+12]
	call	swap
	loop	outLoop

	pop		ebp
	ret		8
sort ENDP


swap PROC

	;set up stack frame
	push	ebp
	mov		ebp, esp
	pushad


	mov		ecx, [ebp+8]
	mov		edi, TYPE edx
	mov		eax, [ebp+12]
	mul		edi
	add		ecx, eax

	mov		ebx, [ebp+8]
	mov		eax, [ebp+16]
	mul		edi
	add		ebx, eax

	mov		eax, [ebx]
	mov		edx, [ecx]
	mov		[ebx], edx
	mov		[ecx], eax

	popad
	;restore stack
	pop		ebp
	ret		12

swap ENDP


END main
