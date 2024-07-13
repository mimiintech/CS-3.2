#Name: Michelle Silva
#NSHE_ID: 5006988436
#Section: 1001
#Assignment: 9
#Description: <short_description_of_program>

#------------------ Data section for variables -----------------
.data
welcomeMsg:			.asciiz "Beginning the program...\n" #Welcome message
doneMsg:			.asciiz "Done! Program exiting...\n" #Done message
commaSpace:			.asciiz	", "
medianMsg:			.asciiz "Median = "
maxMsg:				.asciiz "Max = "
lineFeed:			.asciiz "\n"

array1: 			.word	9, 12, 10, 9, 4, 6, 8, 20, 14, 7, 8, 19, 13, 2, 3, 15, 6
LENGTH1 = 17
median1:			.space	4 #Reserve a word for the median
max1:				.space	4 #Reserve a word for the max

array2: 			.word	9, 200, 20, 35, 68, 12, 35, 19, 120, 44, 55, 64, 8, 12, 34, 54, 12, 10, 9, 10
LENGTH2 = 20
median2:			.space	4 #Reserve a word for the median
max2:				.space	4 #Reserve a word for the max

SYS_PRINT_STRING = 4 #Constant for print string syscall
SYS_PRINT_INT = 1    #Constant for print int syscall
SYS_EXIT = 10

#------------------ Text section for code -----------------
.text
.globl main
.globl printArray
.globl findAllValues
.globl bubbleSort
.globl findMedian
.globl findMax
.globl printValueAndMsg
.globl findStats
.globl printWelcomeMsg
.globl printDoneMsg
main:
	#Call 3 major functions
	jal printWelcomeMsg #jal = jump and link, basically call the function
	jal findAllValues
	jal printDoneMsg

exit:
    li $v0, SYS_EXIT              # terminate program run and
    syscall                      # Exit 
	jr $ra #Finish main
	
#Prints an array given it's length
#First argument ($a0) is address of the array to print
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
printValueAndMsg:
	#Print the Msg
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
	
#Prints the welcome Msg to the screen using a syscall
printWelcomeMsg:
	la $a0, welcomeMsg #Load null-terminated string's address for print syscall
	li $v0, SYS_PRINT_STRING
	syscall
	
	jr $ra
	
#Main function that finds all the values for the major arrays. 
#This calls other functions after setting up arguments
findAllValues:
	#Push the return address onto the stack 
	#(since we're going to call other functions)
	addi $sp, $sp, -4 #Subtract 4 from stack pointer to make room for ra
	sw $ra, ($sp)
	
	#------ Array1 ------ 
	la $a0, array1
	li $a1, LENGTH1
	jal findStats
	sw $v0, median1
	sw $v1, max1
	
	#Print median
	la $a0, medianMsg
	move $a1, $v0 
	jal printValueAndMsg
	
	#Print the max
	la $a0, maxMsg
	lw $a1, max1 
	jal printValueAndMsg
	
	#Print a linefeed
	la $a0, lineFeed
	li $v0, SYS_PRINT_STRING
	syscall
	
	#------ Array2 ------
	la $a0, array2
	li $a1, LENGTH2
	jal findStats
	sw $v0, median2
	sw $v1, max2
	
	#Print median
	la $a0, medianMsg
	move $a1, $v0 
	jal printValueAndMsg
	
	#Print the max
	la $a0, maxMsg
	lw $a1, max2 
	jal printValueAndMsg
	
	#Print a linefeed
	la $a0, lineFeed
	li $v0, SYS_PRINT_STRING
	syscall
	
	#Move stack pointer back and get the return address back
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra #Return
	
#**************************************** Functions you need to implement below ****************************************
	
#Prints the done Msg to the screen using a syscall
printDoneMsg:
########################## YOUR CODE HERE ########################## 
	la $a0, doneMsg
	li $v0, SYS_PRINT_STRING
	syscall
	jr $ra	

#Finds all stats for a given array
#Argument 1 ($a0) is the address of the array
#Argument 0 ($a1) is the length of the array by value
#Return the median and max via $v0 and $v1 respectively
findStats:
	#Push the return address onto the stack 
	#(since we're going to call other functions)

	#Subtract 20 from stack pointer 
	#to make room for ra and registers

	addi $sp, $sp, -20 
	sw $ra, ($sp) # return address 
	sw $s0, 4($sp) # arg0: array length by value
	sw $s1, 8($sp) # arg1: array address 
	sw $s2, 12($sp) # saves max 
    sw $s3, 16($sp) # saves median 

	move $s0, $a0 # array length 
	move $s1, $a1 # array address
	
	#-Finish the function
	#Recommended to use the saved ($s) registers to save variables for calls
	#I've already included code to save the resigsters for use in this function call

	#Start by calling the bubbleSort function
	jal bubbleSort

	#After the array is sorted, 
	#print it using the printArray function
# # # # # # # # # # # # # # # # # # 
	#Call the PrintArray function
	jal printArray # jmp & link to function

	#Then find the max and then print it 
	#using the printValueAndMsg along with the maxMsg
	
	# Call the findMax function
	move $a0, $s0
	move $a1, $s1 
	jal findMax
	move $s2, $v0  # return value in $s2 max 

	# Print maxMsg
	la $a0, maxMsg
    move $a1, $s2 # moves saved max into array address 

# # # # # # # # # # # # # # # # # # #
	#Do the same with the median, 
	#finding it for the array and printing it 
	#using printValueAndMsg and medianMsg

	# Call the findMedian function 
	move $a0, $s0
	move $a1, $s1 
	jal findMedian
	move $s3, $v0 # return value in $s3 median 

    # Print medianMsg 
    la $a0, medianMsg
    move $a1, $s3 # moves saved median into array address

	move $v0, $s3
	move $v1, $s2 
   
    lw $s3, 16($sp)
    lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	addi $sp, $sp, 20 
	jr $ra
	
#Performs Bubble Sort to sort an array1
#Argument 0 ($a0) is the address of the array 
#Argument 1 ($a1) is the length of the array by value
#No return value

bubbleSort:
#C++ equivalent (simple version, you can optimize if you want)

#int i, j, temp;

# OUTER LOOP 
# for(i = 0; i < length; i++)

# INNER LOOP 
#	for(j = 0; j < length-1; j++){

#		if(arr[j] > arr[j + 1]){ //If out of order
#			temp = arr[j];
#			arr[j] = arr[j + 1];
#			arr[j + 1] = temp;
#		}
# }
########################## YOUR CODE HERE ########################## 
	addi $sp, $sp, -16
	sw $s0, ($sp) # arg 0: array address
	sw $s1, 4($sp) # arg 1: array length by value
	sw $ra, 8($sp) # return address 

	move $s0, $a0 # saved arg0 into $s0 
	move $s1, $a1 # saved arg1 into $a1 
	li $t0, 0 # int i outerLoop index 

	outerLoop:
	bge $t0, $s1, endBubbleSort # when i > length, end 
	li $t1, 0 # int j innerLoop index
	sub $t2, $s1, 1 # length-1

	innerLoop: 
	bge $t1, $t2, endInnerLoop # when j > length-1, endInnerLoop
	mul $t3, $t1, 4 # offset 4 bytes (word)  
	add $t4, $s0, $t3 # add address of array 
	lw $t5, ($t4) # now I have arr[j]
	lw $t6, 4($t4) # arr[j + 1]
	ble $t5, $t6, continue # when arr[j] < arr[j + 1], continue 
	# if it is greater than falls through and needs to swap 
	swap: 
	sw $t6, ($t4) # store $t6 (arr[j+1]) to arr[j]
	sw $t5, 4($t4) # store $t5 (arr[j]) to arr[j+1]

	continue:
	addu $t1, $t1, 1 # increment j
	j innerLoop

	endInnerLoop:
	addu $t0, $t0, 1 # increment i
	j outerLoop

	endBubbleSort:
	lw $s0, ($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 16
	jr $ra


#Finds the median of an array. 
#Argument 0 ($a0) is the address of the array
#Argument 1 ($a1) is the length of the array
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
	#You can assume the array is sorted, so the last element is the max
	
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
	
	
