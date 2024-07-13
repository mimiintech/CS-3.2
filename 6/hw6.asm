;Name: Michelle Silva
;NSHE_ID: 5006988436
;Section: 1001
;Assignment: 6
;Description: Recursion & Objects 


section .bss
;------------------- Macro to get Node members ------------------- 

;Macro which gets the members of a node using the given reference
;Stores the value of the node in r12w and pointers to the left and right children in r13 and r14, respectively
;WARNING: If you use this macro in a function, remember to preserve r12, r13, and r14
%macro getNodeMembers 1
mov r12w, word[%1] ;Get the data (the int the Node holds)
mov r13, qword[%1 + 2] ;Get the reference to the left child
mov r14, qword[%1 + 10] ;Get the reference to the right child
%endmacro

section .data
;Constant definitions
NULL    equ 0
FALSE   equ 0
TRUE    equ 1

;Constants for syscalls
EXIT_SUCCESS    equ 0
SYS_exit        equ 60

;------------------- Node definitions -------------------
;Each definition has the value contained by the node followed by
;references to the left and right child of the node 
A   dw  2,
    dq  B, C

B	dw  6,
	dq  D, E
	
C	dw  10,
	dq  NULL, F

D	dw  8,
	dq  NULL, NULL

E	dw  9,
	dq  G, H

F	dw  12,
	dq  NULL, NULL

G	dw  11,
	dq  NULL, NULL

H	dw  15,
	dq  NULL, NULL

sumA    dw  0   ;Sum of all values in the nodes
sumB    dw  0   ;Sum of all values in the nodes
found10 db  -1  ;Was 10 found within the tree?
found11 db  -1  ;Was 11 found within the tree?
found13 db  -1  ;Was 13 found within the tree?

section .text

global checkValue
global findSum
global _start
_start:

;Calling the find sum function
mov rax, 0 ;Zeroing out rax for potential optimization
mov rdi, A ;Load A as the root of the tree
call findSum ;Call the function
mov word[sumA], ax ;Store the sum into memory

mov rax, 0 ;Zeroing out rax for potential optimization
mov rdi, B ;Load B as the root of the tree
call findSum ;Call the function
mov word[sumB], ax ;Store the sum into memory

debugSum: ;Label for CodeGrade's test (or your debugging)

;Calling the checkValue function
mov rdi, A ;Load A as the root of the tree
mov rsi, 10 ;Load 10 as the value to check for
call checkValue ;Call checkValue with the args
mov byte[found10], al ;Move the resulting bool to found11

mov rdi, A ;Load A as the root of the tree
mov rsi, 11 ;Load 11 as the value to check for
call checkValue ;Call checkValue with the args
mov byte[found11], al ;Move the resulting bool to found11

mov rdi, A ;Load A as the root of the tree
mov rsi, 13 ;Load 13 as the value to check for
call checkValue ;Call checkValue with the args
mov byte[found13], al ;Move the resulting bool to found13

;Exiting the program
last:
    mov eax, SYS_exit  ;Load the syscall code for terminating the program
    mov edi, EXIT_SUCCESS ;Load the exit value for the program into rdi
    syscall

;Recursive function to find the sum of all nodes in a tree
;arg0 (rdi) = Reference to root of the tree 
;Return value (rax) = Sum of the values in the tree
findSum:
    ;############# TODO: YOUR CODE HERE
    ;Finish the function so that it finds the sum of the tree
    ;with the given root. Use the provided C code from the pdf for reference

    ;You can assume rax is zeroed out before the initial call (if you
    ;would like to optimize)


        ; int findSum(Node* root){
            ; if(root == nullptr) //Tree with null root contains no elements
            ;     return 0; //Empty tree has a sum of 0
            ; return findSum(root->left) + findSum(root->right);
        ; }

    ;A   dw  2, ;Each Node as data
    ;    dq  B, C ;Left & Right Pointer 

    ;C	dw  10,
	;   dq  NULL, F

    push rbp
    mov rbp, rsp
    ; Adding preserved registers to the stack 
    push r12
    push r13
    push r14
    
    ; if root A and B equals null, return zero 
    cmp rdi, NULL ;//Tree with null root contains no elements
    je returnZero  ;//Empty tree has a sum of 0
    
    getNodeMembers rdi ;Macro usage 
    ; r12w: the value of the node 
    ; r13: pointer to the left child 
    ; r14: pointer to the right child 

    ;unsigned widening 
    movzx rax, r12w ;move node into sum 

    cmp r13, NULL ;compare left pointer to null 
    je skipLeft 
    push rax ;save the current sum 
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Make call to findSum 
    mov rdi, r13 ;move left pointer to rdi 
    call findSum
    pop rbx ;retrieve sum 
;;;;;;;;;;;;;;;;;;;;;;;;;;
    add rax, rbx ;add left pointer sum to current sum
    ;findSum(root->left) + findSum(root->right)

    skipLeft:
    cmp r14, NULL ;compare right pointer to null 
    je skipRight 
    push rax ;save the current sum
    mov rdi, r14 ;move right pointer into rdi 
    call findSum
    pop rbx ;retrieve sum
    add rax, rbx ;add right pointer sum to current sum
    ;findSum(root->left) + findSum(root->right)

    skipRight: 
    jmp return

returnZero:
    mov rax, 0   ;return 0; //Empty tree has a sum of 0

return:
    pop r14
    pop r13
    pop r12
    pop rbp
    ret


;Recursive function which checks if a value is in a tree
;arg0 (rdi) = Reference to root of the tree 
;arg1 (rsi) = Value to search for
;Return value (rax) = boolean on whether the value was found in the tree
checkValue:
    ;############# TODO: YOUR CODE HERE
    ;Finish the function so that it checks if the given value is in the tree
    ;with the given root. TRUE and FALSE constants are provided above.

    ;This should check the current node for the value. If it matches,
    ;the value has been found and we can return. 
    
    ;Else try the left child first (if it exists). If the value is not found in the tree
    ;whose root is the let child, try the right child. If the value is not
    ;found in either child's subtree, then the value is not in this tree.

    ;It is recommended to work out the problem in a high level language
    ;and translate to assembly. This function is not given for you, but 
    ;can follow a similar structure to the findSum function. You can use
    ;the provided macro to access Node members.

    push rbp
    mov rbp, rsp 
    push r12 
    push r13
    push r14

    ; if root is null, return false
    cmp rdi, NULL
    je returnFalse

    getNodeMembers rdi

    ;signed widening 
    movsx r12, r12w 
    movsx rsi, si 

    ; Check the current node for the value 
CheckCurrentNode:
    cmp r12, rsi  
    ; compare the value of the node to the value to check for 
    je matchCase

    ; Check left child
CheckLeftChild:
    mov rdi, r13
    call checkValue
    cmp rax, TRUE 
    je end 
    ; If true, the value(rax) was found in the tree

    ; Check right child
CheckRightChild: 
    mov rdi, r14 
    call checkValue
    cmp rax, TRUE 
    je end 
    ; If true, the value(rax) was found in the tree
    cmp rax, FALSE
    jmp end 
    ; If false, the value(rax) was not found in the tree

matchCase:
    mov rax, TRUE
    jmp end

returnFalse:
    mov rax, FALSE 

end:
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

; FIRST ATTEMPT
   ; push rbp
    ; mov rbp, rsp 
    ; ; Adding preserved registers to the stack 
    ; push r12
    ; push r13
    ; push r14

    ; getNodeMembers rdi 
    ; movzx rax, r12w 

    ; ; Checks the current node for the value 
    ; cmp rdi, rsi ;compares rdi (root A & B) to the values rsi (10,11,13)
    ; je matchCase

    ; ; Check the left child 
    ; mov rdi, r13
    ; call checkValue
    ; cmp rdi, r13 ;compares rdi root to the left child 
    ; jne invalidCase 

    ; matchCase: 
    ; mov rax, TRUE ;return TRUE

    ; invalidCase: 
    ; cmp rdi, r14 ;compares rdi root to the right child 
    ; jne lastCase

    ; lastCase: 
    ; mov rax, FALSE ;return FALSE 

    ; return:
    ; pop r14
    ; pop r13
    ; pop r12
    ; pop rbp 
    ; ret ;Return with whatever value the right returned
