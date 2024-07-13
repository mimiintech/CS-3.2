#Name: Michelle Silva
#NSHE_ID: 5006988436
#Section: 1001
#Assignment: 10
#Description: <short_description_of_program>

#------------------ Data section for variables -----------------
.data
resultStr:	.asciiz	"Result = "
LF:			.asciiz "\n"

#Strings to convert to integers
str0:		.asciiz "45"
str1:	 	.asciiz "103"
str2:		.asciiz "3045"
str3:		.asciiz "102139"

#Ints to store results to
int0:		.word	0					
int1:		.word	0					
int2:		.word	0					
int3:		.word	0	

NEGATIVE_ASCII_ZERO	= -48	#Constant for 9 in ASCII negated (to help with conversion)		

#Syscall codes
SYS_PRINT_INT = 1    #Constant for print int syscall
SYS_PRINT_STRING = 4 #Constant for print string syscall
SYS_PRINT_CHAR = 11	 #Constant for print char syscall (For debugging purposes)
SYS_EXIT = 10
NULL_CHAR = 0

#------------------ Text section for code -----------------
.text
.globl main
.globl string2Int
.globl convertAndPrint
main:
	#Call the functions to convert each int and store the result
	la $a0, str0		#Load string
	jal convertAndPrint
	sw $v0, int0		#Store integer
	
	la $a0, str1		#Load string
	jal convertAndPrint
	sw $v0, int1		#Store integer
	
	la $a0, str2		#Load string
	jal convertAndPrint
	sw $v0, int2		#Store integer
	
	la $a0, str3		#Load string
	jal convertAndPrint
	sw $v0, int3		#Store integer

#Exit the program
exit:
    li $v0, SYS_EXIT             
    syscall                     
	jr $ra 
	
#Converts a string to an int using the string2Int function and prints the result
#Argument 0 = String to convert and print
#Returns converted string as an int
convertAndPrint:
	addi $sp, $sp, -8
	sw $ra, ($sp) 	#Put return address on the stack
	sw $s0,	4($sp)	#Preserve $s0
	
	jal string2Int	#Call conversion function
	move $s0, $v0	#Store return value
	
	#Print result
	la $a0, resultStr
	li $v0, SYS_PRINT_STRING
	syscall
	
	move $a0, $s0
	li $v0, SYS_PRINT_INT
	syscall
	
	la $a0, LF
	li $v0, SYS_PRINT_STRING
	syscall	
	
	move $v0, $s0	#Restore return value
	
	#Restore registers
	lw $ra, ($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
#Converts a string into an integer equivalent. 
The string will be a decimal number.
#You do not have to do any error checking
#Argument 0 = String to convert
#Return value = Converted integer
string2Int:
	#################### YOUR CODE HERE
	#Convert the string to an integer and return it

	#Algorithm 
	#Require: base ≤ 10
	#result = 0
	#for all char c in str do
	#result := result * base digit := c - ’0’
	#result := result + digit
	#end for=0

	addi $sp, $sp, -8
	sw $s0,  ($sp) # Arg. 0 string to convert
	sw $ra, 4($sp) # Return address
	
	move $s0, $a0 # Address of string to convert 
	li $t1, 10 # Base 10  
	li $t2, 0 # Current Index 
	li $t3, 0 # Result = 0

	#"45\NULL"
	#  01
	conversionLoop: 
# 	Iteration 0: char = ’4’
# – result=0*10=0 
# – digit=’4’-’0’=4 
# – result=0+4=4
	lb $t0, ($s0) # This is for accessing the strings "_" in bytes 
	beq $t0, NULL_CHAR, endConversion # when the string hits null, exit 
	# if not, falls through & processes 
	mul $t3, $t3, $t1 # result 0 = 0 * 10 
	add $t0, $t0, NEGATIVE_ASCII_ZERO # 4 = char - '0'
	add $t3, $t3, $t0 # result = 0 + 4 
	addu $s0, $s0, 1 # next byte  
	j conversionLoop # jumps back if not null 

	endConversion: 
	move $v0, $t3 # return value 
	# Restore registers
	lw $s0, ($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra 
	
