;Name: Michelle Silva
;NSHE_ID: 5006988436
;Section: 1001
;Assignment: 7
;Description: Syscalls & Buffer Processing 


section .bss
BUFFER_MAX       	equ 150
C_OFFSET           	equ 6 			;How much to offset each char by in the Caesar cypher

charBuffer      	resb BUFFER_MAX ;Buffer array to hold characters 
outfileDescriptor	resq 1 	        ;Used to hold the file descriptor for the output file

section .data

;Messages and message constants
LF              equ  10 ;ASCII char const for Linux linefeed
NULL            equ  0  ;ASCII char const for NULL
welcomeMessage  db  "Reading from file...", LF, NULL
doneMessage     db  "Done! See cypher_text.txt", LF, NULL
errorMessage	db	"Could not open output file", LF, NULL
writeError      db  "Could not write to file!", LF, NULL
outfileName		db	"cypher_text.txt", NULL
lineFeed        db  LF, NULL
welcomeLength   equ 21
doneLength      equ 26
errorLength     equ 27
writeErrLength	equ	25

;------------- Constants -------------
EXIT_SUCCESS    equ     0   ;Exit code for success
EXIT_FAIL       equ     1   ;Exit code for error
TRUE            equ     1
FALSE           equ     0

;File descriptors for common files
STDIN           equ     0 ;File descriptor for standard in
STDOUT          equ     1 ;File descriptor for standard out
STDERR          equ     2

;Syscall codes
SYS_read        equ     0
SYS_write       equ     1
SYS_open        equ     2
SYS_close       equ     3
SYS_chmod       equ     15
SYS_exit        equ     60  ;Syscall code for terminating program
SYS_creat       equ     85

;Arguments for file I/O related syscalls
O_CREATE        equ     0x40
O_APPEND        equ     1024
O_RDONLY        equ     000000q
O_WRONLY        equ     000001q
O_RDWR	        equ     000002q
O_RDWREX        equ     777o

section .text
global _start
global translateBlock
global populateBuffer
global applyCaesar
global writeBuffer
global translateFile
global printDoneMessage
global printWelcomeMessage
global openOutputFile
global reverseChars
_start:

call printWelcomeMessage ;Print the welcome message
call translateFile ;Call the main function (it's void and takes no args)
call printDoneMessage ;Print the done message

;Exiting the program
last:
    mov eax, SYS_exit  ;Load the syscall code for terminating the program
    mov edi, EXIT_SUCCESS ;Load the exit value for the program into rdi
    syscall

;--------------------------- Functions go down here ---------------------------

;Main function that calls other functions. This will read and translate the entirety of the file (stdin) and write the output to another file
translateFile:
    push rbp
    mov rbp, rsp
	
	;Open the output file for writing
	mov rdi, outfileName
	call openOutputFile
	mov qword[outfileDescriptor], rax

    mainLoop:
        ;Populate the buffer using the populate buffer function
        mov rdi, STDIN
        mov rsi, charBuffer
        call populateBuffer

        bufferDebugCheck:

        ;Now that the buffer is full, check how many chars were read
        cmp rax, BUFFER_MAX
        jl lastCall

        ;Call the function to translate the next block from the file
        mov rdi, rax
        call translateBlock

        jmp mainLoop

    lastCall:
    cmp rax, 0 ;If there are no more characters to translate, jump to the end
    je doneTranslation

    ;Have the last set of characters be translated
    mov rdi, rax
    call translateBlock
    doneTranslation:

    ;Close the output file
    mov rax, SYS_close
    mov rdi, qword[outfileDescriptor]

    pop rbp
    ret

;Function that translates the entire buffer by
;first revesing all characters, then applying the caesar cypher.
;After the buffer has been translated, writes the result to the out file
;Argument 0 (rdi) = Number of characters in the buffer
translateBlock:
    push rbp
    push r12
    mov rbp, rsp

    mov r12, rdi
    
    ;Start by reversing the characters
    mov rdi, r12
    mov rsi, charBuffer
    call reverseChars

    reverseCharDebugCheck:

    ;Then apply the caesar cypher
    mov rdi, r12
    mov rsi, charBuffer
    mov rdx, C_OFFSET
    call applyCaesar

    applyCaesarDebugCheck:

    ;Write the translated buffer to the output file
    mov rdi, qword[outfileDescriptor]
    mov rsi, charBuffer
    mov rdx, r12
    call writeBuffer

    pop r12
    pop rbp
    ret

;Function to print the welcome message at the start of the program
;It is void and takes no arguments
printWelcomeMessage:
	mov rax, SYS_write
	mov rdi, STDOUT
	mov rsi, welcomeMessage
	mov rdx, welcomeLength
	syscall
	ret

;This function opens the output file for the program and returns its file descriptor via rax
;Takes one argument: The file name to open
;Returns the file descriptor via rax and exits the program if the file could not be opened	
openOutputFile:
    mov rax, SYS_creat
    mov rsi, O_RDWREX ;Set file permissions to read, write, and execute
    syscall
	
	;Check if creation was successful and if not try an open
	cmp rax, 0
	jge noErrorCreating

    mov rax, SYS_open
    mov rdi, outfileName
    mov rsi, O_CREATE
    syscall

    ;Check if there was an error opening the file and if so, print a message and terminate
    cmp rax, 0
    jge noErrorCreating
	
	mov rax, SYS_write
	mov rdi, STDOUT
	mov rsi, errorMessage
	mov rdx, errorLength
	syscall
	
	mov eax, SYS_exit  ;Load the syscall code for terminating the program
    mov edi, EXIT_FAIL ;Load the exit value for the program into rdi
    syscall
	
	noErrorCreating:
	ret

;################## YOUR CODE BELOW ##################

;Function to print the done message at the end of the program
;It is void and takes no arguments
printDoneMessage:
	;#############TODO: YOUR CODE HERE
	;-Finish the function to print the done message to standard out
	;This should load the arguments for a write syscall so that the doneMessage with doneLength is
	;printed to STDOUT. The syscall for writing is provided as a constant (SYS_write).
	;This function will be very similar to the provided printWelcomeMessage function

    ; Print the done message (SYS_write)
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, doneMessage
    mov rdx, doneLength
    syscall
	ret

;This function fills the given buffer with characters and returns how many chars were read into the buffer
;Argument 0 (rdi) = File descriptor for file to read from
;Argument 1 (rsi) = Address of buffer to store chars into
;Returns the number of characters read into the buffer (rax)
populateBuffer:
    ;#############TODO: YOUR CODE HERE
    ;Push rbp and update rsp
    ;rdi and rsi are already set up for the syscall, but rax and rdx need set. 
    ;rax needs to be the call code (here the SYS_read to indicate we want to read)
    ;rdx needs to be the max number of characters to read, which we have a constant
    ; for at the top called bufferMax
    ;Load the registers, make a syscall, and return the number of chars read 
    ;via rax (it will already be there after the syscall, which is convenient)
    ;Pop rbp

    push rbp
    mov rbp, rsp 
    mov rax, SYS_read
    mov rdx, BUFFER_MAX
    syscall
    pop rbp 
    ret
	
;Writes the given number of characters from a given buffer to the output file
;Argument 0 (rdi) = File descriptor
;Argument 1 (rsi) = Address of buffer array
;Argument 2 (rdx) = Number of characters to write
writeBuffer:
	;#############TODO: YOUR CODE HERE
    ;Finish the function to write the buffer to the given output
    ;Write to the file
    ;Check if the write was succesful, and 
    ; if not, write the error message to STDOUT instead

    push rbp
    mov rbp, rsp 

    ; Write to the file 
    mov rax, SYS_write
    syscall

    ; Check if the write was successful
    cmp rax, 0 
    jl errorOnWrite ;if the rax is less than 0, then it's invalid! 
    cmp rax, 0 
    jge endWriteBuffer 

    errorOnWrite: 
    ; Write the error message to STDOUT 
    mov rdi, STDOUT ;default file descriptor 
    mov rsi, writeError ;address of chars to output "_"
    mov rdx, writeErrLength ;number of chars to output (25)
    syscall
    
    endWriteBuffer: 
    pop rbp 
    ret

;This function translates all characters in the buffer using a Ceasar 
;cypher and then writes them to the output file
;Argument 0 (rdi) = The number of characters in the buffer to translate, 
;does not need error checked)
;Argument 1 (rsi) = Address of the buffer
;Argument 2 (rdx) = The caesar offset to apply by value
;No return value
applyCaesar:
    ;#############TODO: YOUR CODE HERE
    ;Add the offset to all of the bytes in the buffer 
    ;(i.e. loop through all of them, 
    ; add the offset, and 
    ; overwrite the chars in the buffer)

    push rbp
    mov rbp, rsp 
    push rbx
    push r12 
    push r13 
    mov rbx, rdi ;number of chars in buffer to translate
    mov r12, rsi ;buffer address
    mov r13, rdx ;caesar offset 
    mov r10, 0 ;index 

    caesarLoop:
    mov al, byte [r12] ;loads chars from buffer address into al 
    add al, r13b ;buffer address+caesar offset 
    mov byte [r12], al ;store new encrypted chars
    add r12, 1 ;next char address 
    inc r10 ;char counter 
    cmp r10, rbx ;compare index to the number of chars in buffer to translate 
    jl caesarLoop
    caesarReturn: 
    pop r13
    pop r12
    pop rbx 
    pop rbp 
    ret

;This function reverses all of the characters in the buffer
;Argument 0 (rdi) = The number of characters in the buffer
;Argument 1	(rsi) = Address of the buffer array
;No return value
reverseChars:
	;#############TODO: YOUR CODE HERE
	;Reverse all of the characters in the buffer. Any garbage characters past the end should be ignored
	;Example: Hello => olleH
	;Loop through from the start to the middle
	;For each index, swap the character at that index with the character that 
    ;is the same index to the right of the end
	;Example: "Hello World" => swap index 0 and 10, 1 and 9, 2 and 8, 3 and 7, 4 and 6, 5 and 5
   
    push rbp
    mov rbp, rsp 
    push rbx 
    push r13 
    push r14 

    mov rbx, rdi ;number of characters in the buffer
    mov r13, rsi ;address of the buffer array; begining 
    mov r14, r13 
    add r14, rbx ;adds the start of the array plus number of chars
    sub r14, 1 ;subtracts -1 to get the end 

    ;Buffer start vs buffer end 
    reverseCharsLoop:
    mov al, byte [r13] ;begining 
    mov bl, byte [r14] ;end 
    mov byte [r13], bl 
    mov byte [r14], al 
    ; move each index towards the center 
    add r13, 1 ;starts incrementing to the right 
    sub r14, 1 ;starts subtracting backwards to the left 
    cmp r13, r14 
    jl reverseCharsLoop
    pop r14 
    pop r13 
    pop rbx 
    pop rbp 
    ret 
