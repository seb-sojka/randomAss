TITLE Program random     (random.asm)

; Author Sebastian Sojka
; Class: CS271-400
; Program Number: 4
; Program Name: Random Numbers
; Date: 7/31/2017
; Description: Display a random set of numbers between 100 and 999. 
; User inputs how many numbers to generate ranging 10 to 200

DISPLAYMIN = 10 ;Lower limit to the number of random numbers terms to display 
DISPLAYMAX = 200 ;Upper limit to the number of Fibonacci terms to display
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
promEnd		BYTE	"Results verfied by Sebastian and Benji, my dog." ,0
promBye		BYTE	"Good bye and have a great day", 0

randNums	DWORD	DISPLAYMAX DUP(0);Random numbers to display
numDis		DWORD	?;Numberof composite numbers to display



.code
main PROC
	;Seed for random number generation
	call	Randomize

	;Calls intro
	call	intro

	;User input of number of composite numbers to display
	push	OFFSET numDis
	call	getInput


	exit	; exit to operating system
main ENDP

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
	;Move user input to variable 
	mov		ebx, [ebp+8]
	mov		[ebx], eax

	;restore stack
	pop		ebp
	ret		4

getInput ENDP

;Description: Checks to see if user input is between the limits
;Recives: addresses of parameters on the system stack
;Returns: 1 if user input is not within limits or 0 if no error
;change registers: ebx, edx
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

END main
