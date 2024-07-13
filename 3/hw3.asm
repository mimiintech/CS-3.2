;Name: Michelle Silva
;NSHE_ID: 5006988436
;Section: 1001
;Assignment: 3
;Description: Simple Arithmetic and Operations

;section .bss

;################ TODO: 
;Write a macrofile:///home/michelle/Downloads/handout/makefile
;to find the average given the sum and length by reference as dwords.
;Store the result in eax.
;The params in order are: &sum (%1), &length (%2)

%macro findAvg 2
mov eax, dword [%1] ;sum
mov ebx, dword [%2] ;length 

mov edx, 0
div ebx 

; Quotient stored in eax 

; First Attempt: This is incorrect of me to do because it was unnecessary 
; to find the sum or iterate over the array becuase they were already
; passed as parameters/calculated. 
;mov eax, 0
;mov ecx, dword [%2] ;length 
;mov r12, 0      ;index 
;mov rbx, [] ;arrays
;%%sumLoop:
;add eax, dword [rbx+r12*4]
;inc r12 
;loop %%sumLoop

;mov edx, 0 
;div dword [%2] ;length 
;mov dword [%3] ;eax 
%endmacro

;################## TODO: 
;Write a macro to update the max
;The params in order are: value (%1), max(%2)
;Note that both params are registers and not in memory
;Name it updateMax. Remember how labels are implemented in macros

;C++ Equivalent: 
;   if(value > max)
;       max = value;

; calls three arguments 
; updateMax <value> <max> 

%macro updateMax 2 
cmp %1, %2  
jle %%notMax
mov %2, %1 
%%notMax: 


; First Attempt: This is incorrect because these parameters 
; are being placed into memory.
;mov eax, dword [%1] ;value 
;mov ebx, dword [%2] ;max 
;cmp eax, ebx 
;jle notMax
;mov dword [%2], eax  
;notMax: 
%endmacro

;Macro to find the sum and maximum of an array
;The params in order are: 
; array(%1), length(%2), &sum(%3), &max(%4)

;C++ equivalent of below:
;int sum = 0, max = arr[0], avg;
;for(int i = 0; i < length; i++) {
;   sum += arr[i];
;   //UPATE_MAX_MACRO
;}

%macro findSumAndMax 5 
; Passed by value 
mov r11, %1 ;array
mov rbx, qword [%2] ;length 

; Passed by reference 
mov eax, dword [%3] ;&sum
mov r10d, dword [%4] ;&max 
mov r9d, dword [%5] ;&min 

mov rsi, 0  ;index 
mov r10d, dword [%1] ;max = arr[0]
mov r9d, dword [%1] ;min = arr[0]

%%sumLoop:
add eax, dword [%1+rsi*4]
cmp dword [%1+rsi*4], r9d ;compares current element with min 
jge %%notMin ;if greater, go to label 
mov r9d, dword [%1+rsi*4] ;if less, falls through 
%%notMin:
cmp dword [%1+rsi*4], r10d ;compare current element with max 
jle %%notMax ; if less, go to notMax label 
mov r10d, dword [%1+rsi*4] ;if greater, falls through
%%notMax:
inc rsi ;next item
cmp rsi, rbx ;compares index to length
jl %%sumLoop

mov dword [%3], eax ;&sum
mov dword [%4], r10d ;&max
mov dword [%5], r9d ;&min 

;sum1 = 806
;min1 = 2
;max1 = 83


; First Attempt: 
;mov eax, dword [%3] ;sum
;mov rbx, dword [%1] ;array
;mov r14d, dword [%2] ;length 
;mov dword [%4], r15d ;max 
;mov r12, 0 ;index 
;sumLoop:
;add eax, dword [rbx+r12*4]
;inc r12 
;cmp r12,[%2]
;jl sumLoop
;mov dword [%3], eax

;cmp eax, dword [%4] 
;jbe notNewMax ;if less, go to notNewMax 
;mov dword [%4], eax ;if greater, falls through 
;notNewMax: 
%endmacro



section .data

;Array 1
numArray1   dd  37, 39, 5, 14, 20, 63, 29, 12, 10, 10
            dd  60, 40, 36, 54, 27, 30, 11, 19, 30, 12 
            dd  13, 16, 4, 2, 5, 19, 34, 60, 83, 12
length1     dd  30
sum1        dd  0
avg1        dd  0
max1        dd  0
min1        dd  0

;Array 2
numArray2   dd  34, 15, 21, 19, 20, 15, 10, 90, 80, 10
            dd  13, 7, 12, 11, 1, 2, 13, 17, 30, 8
length2     dd  20
sum2        dd  0
avg2        dd  0
max2        dd  0
min2        dd  0
med2        dd  0

;Array 3
numArray3   dd  110, 13, 5, 1, 80, 10, 10, 2, 4, 70, 2
length3     dd  11
sum3        dd  0
avg3        dd  0
max3        dd  0 
min3        dd  0
med3        dd  0

;------------- Constants -------------
EXIT_SUCCESS    equ     0   ;Exit code for success
SYS_exit        equ     60  ;Syscall code for terminating program

section .text
global _start
_start:
	;Implement the code first using the numArray1, length1, sum1, avg1, max1 variables
	;before translating to a macro. You can temporarily place that code here
    ;mov eax, 0                  ;sum
    ;mov rsi, 0                  ;i = 0
    ;mov rbx, qword [length1]    ;length
    ;mov r11, numArray1          ;array1
    ;mov r9d, dword [r11]        ;min = arr[0]
    ;mov r10d, dword [r11]       ;max = arr[0]  

    ;sumLoop:
    ;add eax, dword [r11+rsi*4]
    ;cmp dword [r11+rsi*4], r9d 
    ;jge notMin ;if greater, go to label
    ;mov r9d, dword [r11+rsi*4] ;if less, falls through
    ;notMin: 
    ;cmp dword [r11+rsi*4], r10d 
    ;jle notMax ;if less, go to label
    ;mov r10d, dword [r11+rsi*4] ;if greater, falls through
    ;notMax: 
    ;inc rsi ;next item 
    ;cmp rsi, rbx ;compares index to length 
    ;jl sumLoop

    ;mov dword [sum1], eax
    ;mov dword [min1], r9d 
    ;mov dword [max1], r10d 

    ;sum1 = 806
    ;min1 = 2 
    ;max1 = 83

    ;mov edx, 0 ;clears the upper bits 
    ;div rbx ;divide by the length stored in rbx 
    ;mov dword [avg1], eax ;stores into quotient eax 

    ;avg1 = 26


    ;Find the sum and max of all arrays using the macro we wrote
    findSumAndMax numArray1, length1, sum1, max1, min1 
    findSumAndMax numArray2, length2, sum2, max2, min2 
    findSumAndMax numArray3, length3, sum3, max3, min3 

	;Find the averages
    findAvg sum1, length1
    mov dword[avg1], eax
    findAvg sum2, length2
    mov dword[avg2], eax
    findAvg sum3, length3
    mov dword[avg3], eax

;Exiting the program
last:
    mov eax, SYS_exit  ;Load the syscall code for terminating the program
    mov edi, EXIT_SUCCESS ;Load the exit value for the program into rdi
    syscall
