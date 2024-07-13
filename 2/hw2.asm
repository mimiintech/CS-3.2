;Name: Michelle Silva
;NSHE_ID: 5006988436
;Section: 1001
;Assignment: 2
;Description: Simple Arithmetic and Operations

;section     .bss 
;############## Uninitialized data section ############## 

section     .data
;############## Initialized data section ############## 

;------------- Variables -------------
byteVar1        db      4
byteVar2        db      9
byteSum         db      0
byteDif         db      0
wordProd        dw      0
wordVar1        dw      1120
wordVar2        dw      410
wordQuot      	dw      0
wordRemainder   dw      0
wordDif         dw      0
doubleSum    	dd      0
doubleVar1      dd      29400
doubleVar2      dd      21110
doubleProd      dd      0
doubleResult	dd		0
quadVar1        dq      50678
quadVar2        dq      123
quadSum         dq      0
quadProd        dq      0
quadQuot		dq		0
quadRemainder	dq		0

;------------- Constants -------------
EXIT_SUCCESS    equ     0   ;Exit code for success
SYS_exit        equ     60  ;Syscall code for terminating program

section     .text
;############## Section with the actual code. Code here is referred to as "text" ############## 

global _start ;Define the start label
_start: ;Mark the start of the program using the start label

;Code to do byteDif = byteVar2 - byteVar1
mov al, byte[byteVar2] ;Move byteVar2 into the al 8-bit portion of the register (as a byte)
sub al, byte[byteVar1] ;Sub the contents of al (which is var2) by var1. The result is stored in rax (or some sub-register like al) when done
mov byte[byteDif], al  ;Finally, move the resulting difference from al (where it was stored) to the memory location represented by byteResult. 

;Code to do wordQuot = wordVar1 / wordVar2 (with integer dvision) and wordRemainder = wordVar1 % wordVar2
mov ax, word[wordVar1] ;Load y into rax so we can divide it. x is already in bx from the previous code
cwd ;Convert the word int ax to a dword in eax. This needs to be done since division can reduce the size of data
div word[wordVar2] ;Divide the contents of eax by wordVar2 Afterwards, ax contains the quotient and dx the remainder
mov word[wordQuot], ax ;Store quotient in wordQuot
mov word[wordRemainder], dx ;Store remainder in wordRemainder

;Code to do wordProd = byteVar1 * byteVar2
mov al, byte[byteVar1] ;Load byteVar1 into al
mul byte[byteVar2] ;Multiply the contents of al by byteVar2
mov word[wordProd], ax ;Store the result. Byte multiplication is the only one that places the result in one register

;Code to do doubleProd = wordVar1 * wordVar2
mov ax, word[wordVar1] ;Move wordVar1 into ax  
mul word[wordVar2] ;Multiply ax by wordVar2
mov word[doubleProd], ax ;Move the first half of the result into the first half of doubleProd
mov word[doubleProd + 2], dx ;Move the second half of the result to the second half of doubleProd. Two words make a dword. A word is 2 bytes and a dword is 4, hence the 2 offset

;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx YOUR CODE HERE xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;Finish the code to calculate each given expression. Two expressions are provided for you as examples already

;Do byteSum = byteVar1 + byteVar2
mov al, byte [byteVar1]
add al, byte [byteVar2]
mov byte [byteSum], al 

;Do wordDif = wordVar1 - wordVar2
mov ax, word [wordVar1]
sub ax, word [wordVar2]
mov word [wordDif], ax 

;Find doubleSum = doubleVar1 + doubleVar2
mov eax, dword [doubleVar1]
add eax, dword [doubleVar2]
mov dword [doubleSum], eax 

;Find quadQuot = quadVar1 / quadVar2 and quadRemainder = quadVar1 % quadVar2
mov rax, qword [quadVar1]
cqo 
div qword [quadVar2]
mov qword [quadQuot], rax
mov qword [quadRemainder], rdx 

;Find quadSum = quadVar1 + quadVar2
mov rax, qword [quadVar1]
add rax, qword [quadVar2]
mov qword [quadSum], rax 

;Find quadProd = doubleVar1 * doubleVar2
mov eax, dword [doubleVar1]
mul dword [doubleVar2]
mov dword [quadProd], eax
mov dword [quadProd+4], edx 

;Finally, put things together and calculate: doubleResult = wordVar1 * wordQuot + doubleVar1
mov ax, word [wordVar1]
mul word [wordQuot]
mov word [doubleResult], ax
; 32 bits 
mov word [doubleResult+2], dx
; 32 bits 
mov eax, dword [doubleResult]
add eax, dword [doubleVar1]
mov dword [doubleResult], eax

;Exiting the program
last:
    mov eax, SYS_exit  ;Load the syscall code for terminating the program
    mov edi, EXIT_SUCCESS ;Load the exit value for the program into rdi
    syscall

