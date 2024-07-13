;Name: Michelle Silva
;NSHE_ID: 5006988436
;Section: 1001
;Assignment: 5
;Description: Functions and Standard Calling Convention


section .bss
LENGTH       equ 25

perimValues resd  LENGTH ;Array to store perimeters into (25 elements)
areaValues  resd  LENGTH ;Array to store areas into (25 elements)

section .data
lengthsArray dw  5, 11, 10, 4, 6, 8, 19, 10, 3, 6, 4, 5, 10,
             dw  8, 3, 4, 6, 11, 7, 15, 1, 9, 11, 14, 2

widthsArray  dw 3, 6, 4, 2, 3, 5, 5, 6, 7, 11, 3, 2, 1,
             dw 2, 8, 10, 9, 3, 3, 6, 9, 10, 2, 1, 15

avgPerim     dw 0
avgArea      dw 0

;------------- Constants -------------
EXIT_SUCCESS    equ     0   ;Exit code for success
SYS_exit        equ     60  ;Syscall code for terminating program

section .text
global _start
global findAllPerimeters
global findAllAreas
global findPerim
global findArea
global findAvgValue

_start:

; CALLER 

; FindAllPerimeters 
;Set argument registers to call the function, then call it
mov rdi, lengthsArray   ;Arg0 = &lengthsArray
mov rsi, widthsArray 	;Arg1 = &widthsArray
mov rdx, LENGTH 		;Arg2 = length
call findAllPerimeters 	;Call findAllPerimeters 

; FindAllAreas
;Set argument registers to call the function, then call it
mov rdi, lengthsArray   ;Arg0 = &lengthsArray
mov rsi, widthsArray 	;Arg1 = &widthsArray
mov rdx, LENGTH 		;Arg2 = length
call findAllAreas 		;Call findAllAreas 


;###################### YOUR CODE HERE, finish the function calls ###################### 

;After all perims and areas are found, 
; find the max from each using the max function and 
; store the results in the two corresponding vars
;Setup registers to call the findAvgValue function for
; the areaValues and perimValues. Remember rdi is for arg1, 
; rsi for arg2, and return values go in rax
;After all perims and areas are found, find the max from each 
; using the max function and store the results in the two corresponding vars

; avgPerim 
mov rdi, perimValues ;Arg1 = perimArray
mov si, LENGTH ;Arg2 = length 
call findAvgValue
mov word [avgPerim], ax ;returned via rax

; avgArea
mov rdi, areaValues ;Arg1 = areaArray
mov si, LENGTH ;Arg2 = length 
call findAvgValue
mov word [avgArea], ax ;returned via rax

;Exiting the program
last:
    mov eax, SYS_exit  ;Load the syscall code for terminating the program
    mov edi, EXIT_SUCCESS ;Load the exit value for the program into rdi
    syscall

;--------------------------- Functions go down here ---------------------------
;Function to calculate the volumes of all prisms
;Takes 3 arguments: length and width arrays by reference and the length of the arrays by value
;arg0 (rdi) = &widthArray
;arg1 (rsi) = &lengthArray
;arg2 (rdx) = length of array (by value)
;Written for you as an example
findAllPerimeters:
    ;Push the contents of registers that we plan to use in the function that should be preserved 
    ;(r1-r9 need not be, but I chose r11 and r12 for an example)
	push rbp ;Need to push ebp if a function calls another function (keep track of where old base was)
    mov rbp, rsp ;Update base to old top

    push r12 ;Preserved register, so must be pushed if used in function. Since we need the counter between function calls, saving makes sense
    push r13 ;Same as r13
    push r14
    push r15

    ;Keep a copy of the arguments since rdi and rsi will be overwritten by later function calls
    mov r14, rdi
    mov r15, rsi

    ;Initialize counters
    mov r12, 0
    mov r13w, dx ;Keep a copy of the length in a preserved register in case it would get overwritten by a later function call

    ;Loop for finding each perimeter
    allPerim:
        ;Prepare to call perim function
        mov di, word[r14 + 2*r12] ;Get width of current rectangle
        mov si, word[r15 + 2*r12] ;Get length of current rectangle
        call findPerim ;Call findPerim function

        ;Store returned value from rax into result
        mov dword[perimValues + 4*r12], eax

        ;Check whether or not to loop
        inc r12w
        cmp r12w, r13w
        jl allPerim

    ;Restore any contents of registers after the function is done so the caller does not have values changed on them
    pop r15
    pop r14
    pop r13
    pop r12
	pop rbp
    ret

;###################### YOUR CODE BELOW, finish the functions ###################### 

;Function to calculate the volumes of all prisms
;Takes 3 arguments: length and width arrays by reference and the length of the arrays by value
;arg0 (rdi) = &widthArray
;arg1 (rsi) = &lengthArray
;arg2 (rdx) = length of array (by value)
;No return value
;The areas array to store results in is a global variable (for convenience)
findAllAreas:
    ;###################### YOUR CODE HERE, finish the function ###################### 
	;This function should calculate the area of all triangles using the width and lengths array 
    ;passed in as arguments
	;The resulting areas should be stored in the global areaValues array
	;Use the findArea function (written for you) to calculate the area given a length and width
	;Remember to preserve any saved registers that you use and consider any values 
    ;that might need to be saved before a function call
	;The findAllPerims function above can be used for reference

    push rbp ;calls another function 
    mov rbp, rsp ;rbp saved to refer to old base

    ; push preserved registers 
    push r12
    push r13
    push r14
    push r15

    mov r14, rdi ;lengthArray
    mov r15, rsi ;widthArray

    mov r12, 0  ;index 
    mov r13w, dx ;rdx(length)

    allAreas: 
    ; Non-value returning
    ; Loop over all lengths and widths 
        mov di, word [r14+ 2*r12] ;lengthArray
        mov si, word [r15+ 2*r12] ;widthArray
        call findArea ;find the area

        mov dword [areaValues+ 4*r12], eax ;store result into areaValues dword(eax)
	    
        inc r12w 
        cmp r12w, r13w ;compares word index to length 
        jl allAreas

    pop r15
    pop r14
    pop r13
    pop r12 
    pop rbp 
    ret

;Function that finds the perimeter of a rectangle given a length and a width and returns it
;Argument 1 is the length passed by value as a word (stored in rdi)
;Argument 2 is the width passed by value as a word (stored in rsi)
;The perimeter value should be returned via rax (Remember it's a dword!)
findPerim:
	;############# YOUR CODE HERE ############# 
    ;- Finish the function to find the perimeter. You can do this is any way you want given the args mentioned in the description above
    ;Remember that if the result is a dword, you may need to convert in some way (either through multiplication or cwd)
        ;- Finish the function

    ; "leaf" function: does not call other functions, doesn't need to push rbp 

    mov r10w, di ;length 
    mov r11w, si ;width 

    ;rectangle perimeter = 2 * (length + width)
    add r10w, r11w ;stores into r10w

    mov ax, 2 ;ax holds 2 
    mul r10w 
    ;result stored in ax 
    mov r10w, ax ;moves quotient (ax) into r10w 

    movzx eax, r10w ;converts the result to dword(eax)
    ;rax=16
    ret

;Function that finds the area given a length and a width and returns it
;Argument 1 is the length passed by value (stored in rdi)
;Argument 2 is the width passed by value (stored in rsi)
;The area value should be returned via rax (Remember it's a dword, so it goes in eax!)
;This function is written for you as an example


findArea:
    ;Function is a "leaf", calls no other functions and does not need to push rbp
    mov ax, di ;moves rdi(lengthArr) to ax(word)
    mul si ;multiplies ax and si(rsi) widthsArr
    ; 16bits+16bits=32bits ax:dx 
    ; stored into ax, the quotient 

    ;Utilize the stack to store the product temporarily
	sub rsp, 4 ;Allocate 4 bytes on the top of the stack (i.e. make a local int) 32-bits 
    mov word [rsp], ax ;Store the first half 16 bits
    mov word [rsp + 2], dx ;Store the second half 16 bits 
    mov eax, dword [rsp] ;Move the concatenated answer back into memory

	add rsp, 4 ;Deallocate the 4 bytes that were used to store the int
    ret

;Write your own findAvgValue function label and code below
;Function that finds the avg value in a dword array
;Argument 1 is the address of the array to find the average of (stored in rdi)
;Argument 2 is the length of the array (stored in si)
;The avg value should be returned via rax as a word


findAvgValue:
	;############# YOUR CODE HERE ############# 
    ;- Finish the function to find the avg value of the given array and return it
    ; You can assume the given array is full of words

    ; Place arguments into word registers 
    mov r10, rdi ;Arg1 array 
    movsx r11, si ;Arg2 length 

    mov rax, 0 ;sum
    mov rbx, 0 ;index 

    sumLoop: 
        add ax, word [r10 + rbx*4]
        inc bx ;next item 
        cmp bx, r11w ;compare index to length 
        jl sumLoop

    ; Avg = sum/length  
    mov dx, 0 ;clear upper bits
    div r11w ;length 
    ret


