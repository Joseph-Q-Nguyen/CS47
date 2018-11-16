.include "./cs47_macro.asm"

.data
msg1: 	.asciiz "The factorial of "
msg2: 	.asciiz " is "
charCR: .asciiz "\n"
msg3: 	.asciiz "Enter a +ve number : "

.text
.globl main
main: 
	print_str(msg3)
	read_int($s0)
	move $a0, $s0 # Pass the argument to function
	jal fact # Change the control to function
main_L1:
	move $s1, $v0
	print_str(msg1)
	print_reg_int($s0)
	print_str(msg2)
	print_reg_int($s1)
	print_str(charCR)
	
	exit
#------------------------------------------------------------------------------
# Function: fact
# Argument:
#	$a0 : +ve integer number n
# Returns
#	$v0 : factorial(n)
#
# Purpose: Implementing factorial function using recursive call.
# 
#------------------------------------------------------------------------------
fact:
	# Need to save $fp (4byte), $sp(8byte) (double word boundary), 
	#              $ra(4byte), $a0(4byte), $s0(4byte)
	addi	$sp, $sp, -20
	sw   	$fp, 20($sp)
	sw   	$ra, 16($sp)
	sw   	$a0, 12($sp)
	sw   	$s0,  8($sp)
	addi 	$fp, $sp, 20
	
	# Body of the procedure
	addiu $t0, $zero, 1
	blt   $a0, $t0, fact_end # if (n<1) goto fact_end
	move  $s0, $a0 # $s0 = n;
	addi  $a0, $a0, -1 # n = n - 1;
	jal   fact # $v0 = fact(n-1)
fact_L1:
	mult  $s0, $v0 # n * fact(n-1)
	mflo  $v0
	j     fact_ret # Procedure return step
fact_end:
	addiu $v0, $zero, 1 # $v0 = 1 ---> return 1
fact_ret:
        # restore all the saved registers
	lw   	$fp, 20($sp)
	lw   	$ra, 16($sp)
	lw   	$a0, 12($sp)
	lw   	$s0,  8($sp)
	addi	$sp, $sp, 20
	jr 	$ra	# jump to caller 	
