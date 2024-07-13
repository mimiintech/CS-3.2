;Name: Michelle Silva
;NSHE_ID: 5006988436
;Section: 1001
;Assignment: 8
;Description: Parallelism & Linking Across  

section .data
;------------- Constants -------------
EXIT_SUCCESS    equ     0   ;Exit code for success
TRUE            equ     1
FALSE           equ     0

;External function to print an integer for debugging purpose
;Single arg (rdi) is integer to print by value
extern printInt

section .text
global findMax

;############## YOUR CODE HERE ############# 
;Finish the one findMax function. Since main is in the C program, no _start here. The C program will call your function

;The findMax function should find the max of a subarray 
;given its start_index and end_index. 

; It should start at the start index but end before the end_index 
;(i.e. first is inclusive, second is exclusive).
;For example, if we had the array
;{4, 5, 3, 2, 6, 9, 8, 7, 1, 0, 4}, start_index = 3, and end_index = 7
;The max of {2, 6, 9, 8} = 9

;This function takes four arguments
;rdi = address of the array
;esi = start index
;edx = end index
;rcx = address of the variable to store the dword result max to
;No return value, max will be pass by reference (How threads usually operate)
;Takes a reference to the array, 
; the start_index by value, 
; its end_index by value, 
; and the address of where to store the max (check function comments)
findMax:
;-- Finish the function
;Preserve any registers you need
;Then, find the max of the sub array and 
;store the result using the reference to the max variable
;Use the above argument descriptions
push rbp
mov rbp, rsp 
push rbx
push r12 
push r13 
push r14 

mov rbx, rdi ; array address
mov r12d, esi ; start index
mov r13d, edx ; end index 
mov r14, rcx ; add of var to store max 
mov r10, 0 ;index 
mov r10d, r12d ;set the counter to the start index 
mov r11d, dword [rbx+r12*4] ;max = subarray[first element]

; Find the max value of an array of ints(dwords)
findMaxLoop:
mov eax, dword [rbx+r10*4] ;current index (eax)
cmp eax, r11d ;compare current index to the max in subarray
jle notMax
mov r11d, eax ;falls through if greater, stores in r11d 
notMax: 
inc r10d ;next index 
cmp r10d, r13d ;compare index to end index
jl findMaxLoop ;if start index is less than end index, continue looping 
endMax: 
mov dword [r14], r11d ;stores max into r14 
pop r14
pop r13
pop r12
pop rbx 
pop rbp 
ret