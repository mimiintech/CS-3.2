#Name: Michelle Silva
#NSHE_ID: 5006988436
#Section: 1001
#Assignment: 9
#Description: <short_description_of_program>

#------------------ Data section for variables -----------------
.data
welcomeMessage:		.asciiz "Starting program...\n" #Welcome message
doneMessage:		.asciiz "Done!\n" #Done message
commaSpace:			.asciiz	", "
medianMessage:		.asciiz "Median = "
maxMessage:			.asciiz "Max = "
lineFeed:			.asciiz "\n"

array1: 			.word	3, 4, 5, 5, 7, 8, 14, 17, 18, 20, 27, 31
LENGTH1 = 12
median1:			.space	4 #Reserve a word for the median
max1:				.space	4 #Reserve a word for the max

array2: 			.word	3, 4, 5, 6, 8, 9, 10, 12, 14, 16, 17, 20, 24
LENGTH2 = 13
median2:			.space	4 #Reserve a word for the median
max2:				.space	4 #Reserve a word for the max

SYS_PRINT_STRING = 4 #Constant for print string syscall
SYS_PRINT_INT = 1    #Constant for print int syscall
SYS_EXIT = 10

#------------------ Text section for code -----------------
.text
.globl main
.globl printArray
.globl findMedian
.globl findMax
.globl printValueAndMessage
main:
	#Call 3 major functions
	jal printWelcomeMessage #jal = jump and link, basically call the function

	#-------- Array 1 --------
	#Print the array
	la $a0, array1
	li $a1, LENGTH1
	jal printArray
		
	la $a0, array1
	li $a1, LENGTH1
	jal findMedian
	sw $v0, median1
	
	la $a0, medianMessage
	move $a1, $v0 
	jal printValueAndMessage
	
	la $a0, array1
	li $a1, LENGTH1
	jal findMax
	sw $v0, max1
	
	la $a0, maxMessage
	move $a1, $v0 
	jal printValueAndMessage
	
	#-------- Array 2 --------
	#Print the array
	la $a0, array2
	li $a1, LENGTH2
	jal printArray
	
	la $a0, array2
	li $a1, LENGTH2
	jal findMedian
	sw $v0, median2
	
	la $a0, medianMessage
	move $a1, $v0 
	jal printValueAndMessage
	
	la $a0, array2
	li $a1, LENGTH2
	jal findMax
	sw $v0, max2
	
	la $a0, maxMessage
	move $a1, $v0 
	jal printValueAndMessage

exit:
    li $v0, SYS_EXIT             # terminate program run and
    syscall                      # Exit 
	jr $ra #Finish main
	
#Prints an array given it's length
#First argument ($a0) is address of the arrayto print
#Second argument ($a1) is length of array 
printArray:
	#Push the return address onto the stack and saved registers
	addi $sp, $sp, -16 #Subtract 16 from stack pointer to make room for 4 words
	sw $ra, ($sp)
	sw $s0, 4($sp) #Store s0 for later
	sw $s1, 8($sp)	#Store s1 for later
	sw $s2, 12($sp)	#Store s1 for later
	move $s0, $a0 #Keep a copy of the address since a0 is needed for syscalls 
	move $s1, $a1 #Keep a copy of the length address to be safe
	li $s2, 0 #Use $s2 as a counter
	
	printLoop:
		#Print the current element of the array
		lw $a0, 0($s0) #Grab an array value 
		li $v0, SYS_PRINT_INT
		syscall
		
		addi $s0, $s0, 4 #Increment s0 by a word
		addi $s2, $s2, 1 #Increment s2
		bge	$s2, $s1, donePrinting #Jump past comma printing if this is the last iteration
	
		#Print a comma and space
		la $a0, commaSpace
		li $v0, SYS_PRINT_STRING
		syscall
		b printLoop #Branch back up to the loop start
	donePrinting:
	
	#Print a linefeed
	la $a0, lineFeed
	li $v0, SYS_PRINT_STRING
	syscall

	#Restore registers from stack
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
#Prints a value after a message, and then a linefeed
#Arg0 = Address of message
#Arg1 = Value by reference
printValueAndMessage:
	#Print the message
	li $v0, SYS_PRINT_STRING
	syscall
	
	move $a0, $a1 #Copy the value out of the arg register
	li $v0, SYS_PRINT_INT
	syscall
	
	#Print a linefeed
	la $a0, lineFeed
	li $v0, SYS_PRINT_STRING
	syscall
	jr $ra
	
#Prints the welcome message to the screen using a syscall
printWelcomeMessage:
	la $a0, welcomeMessage #Load null-terminated string's address for print syscall
	li $v0, SYS_PRINT_STRING
	syscall
	
	jr $ra
	
#**************************************** Functions you need to implement below ****************************************
#Finds the median of an array. 
#Argument 1 ($a0) is the address of the array
#Argument 0 ($a1) is the length of the array
#The return value is the median ($v0)
findMedian:
########################## YOUR CODE HERE ########################## 
#You can assume the array is already sorted
#If the array contains an odd number of elements, 
#the median is the middle element (at index length/2)
#If the array contains an even number of elements,
#the median is the average of the two middle elements
#(index length/2 - 1 and length/2)
	
# Used page 58 Addressing Modes as a reference 

	findMedianLoop:
	addi $sp, $sp, -16
	sw $s0, ($sp) # arg 0: array address 
	sw $s1, 4($sp) # arg 1: array length 
	sw $s2, 8($sp) # index 
	sw $ra, 12($sp) # return address

	move $s0, $a0 # arg 0 saved into $s0
	move $s1, $a1 # arg 1 saved into $s1 
	li $s2, 0 # index 

	div $t1, $s1, 2 # $t1(quotient) = array length / 2 
	rem $t2, $s1, 2 # $t2(remainder) holds the remainder of the division 
	# odd remainder = 1 even remainder = 0
	bne $t2, $zero, oddLength
	beq $t2, $zero, evenLength

	evenLength: 
	mul $t3, $t1, 4 # offset 4 bytes (word)
	add $t4, $s0, $t3 # add address of array 
	lw $t5, ($t4) # array[len/2]

	sub $t4, $t4, 4 # address of previous value 
	lw $t6, ($t4) # get array[len/2-1]

	add $t7, $t6, $t5 # array[len/2] + array[len/2-1]
	div $t8, $t7, 2  # / 2 
	move $v0, $t8
	j endMedian 

	oddLength:
	mul $t3, $t1, 4 # offset 4 bytes (word)
	add $t4, $s0, $t3 # add address of array 
	lw $v0, ($t4) # stores return value odd length median by value

	endMedian: 
	lw $s0, ($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	jr $ra

#Argument 0 ($a0) is the address of the array
#Argument 1 ($a1) is the length of the array
#The return value is the max ($v0)
findMax:
########################## YOUR CODE HERE ########################## 
	#Finds the max value of the array. 
	#You can assume the array is sorted, 
	#so the last element is the max
	#Calculate the offset

	addi $sp, $sp, -12 
	sw $s0, ($sp) # arg 0: array address
	sw $s1, 4($sp) # arg 1: array length 
	sw $ra, 8($sp) # return address

	move $s0, $a0 # arg 0 saved into $s0
	move $s1, $a1 # arg 1 saved into $s1 

	findMaxLoop:
	sub $t2, $s1, 1 # array length-1
	mul $t3, $t2, 4 # offset 4 bytes (word)
	add $t4, $s0, $t3 # add address of array
	lw $v0, ($t4) # stores return value max 

	endMax:
	lw $s0, ($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12 
	jr $ra

	
