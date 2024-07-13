;Name: Michelle Silva
;NSHE_ID: 5006988436
;Section: 1001
;Assignment: 1
;Description: Assignment 1 - Learning Tool Chain and Linux

;section     .bss 
;############## Uninitialized data section ############## 

section     .data
;############## Initialized data section ############## 

;------------- Variables -------------
byteVar1        db      5
byteVar2        db      7
byteResult      db      0
wordPad         dw      0
wordVar1        dw      1300
wordVar2        dw      250
wordResult      dw      0
wordRemainder   dw      0
doubleVar1      dd      30940
doubleVar2      dd      1000
doubleResult    dd      0
quadVar1        dq      405959
quadVar2        dq      3708
quadResult      dq      0

;------------- Constants -------------
EXIT_SUCCESS    equ     0   ;Exit code for success
SYS_exit        equ     60  ;Syscall code for terminating program

section     .text
;############## Section with the actual code. Code here is referred to as "text" ############## 

global _start ;Define the start label
_start: ;Mark the start of the program using the start label

;Code to do byteResult = byteVar1 + byteVar2
mov al, byte[byteVar1] ;Move byteVar1 into the al 8-bit portion of the register (as a byte)
add al, byte[byteVar2] ;Add the contents of al (which is var1) to var2. The result is stored in rax (or some sub-register like al) when done
mov byte[byteResult], al  ;Finally, move the resulting sum from al (where it was stored) to the memory location represented by byteResult. 

;Code to do wordResult = wordVar1 / wordVar2 (with integer dvision) and wordRemainder = wordVar1 % wordVar2
mov ax, word[wordVar1] ;Load y into rax so we can divide it. x is already in bx from the previous code
cwd ;Convert the word int ax to a dword in eax. This needs to be done since division can reduce the size of data
div word[wordVar2] ;Divide the contents of eax by wordVar2 Afterwards, ax contains the quotient and dx the remainder
mov word[wordResult], ax ;Store quotient in wordResult
mov word[wordRemainder], dx ;Store remainder in wordRemainder

;Exiting the program
last:
    mov eax, SYS_exit  ;Load the syscall code for terminating the program
    mov edi, EXIT_SUCCESS ;Load the exit value for the program into rdi
    syscall

