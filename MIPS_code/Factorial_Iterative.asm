tw.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a number ? "
msg2: .asciiz "Factorial of the number is "
charCR: .asciiz "\n"

.text
.globl main
main:	print_str(msg1)
	read_int($t0)
	
# Write body of the iterative
# factorial program here
# Store the factorial result into 
# register $s0
#
# DON'T IMPLEMENT RECURSIVE ROUTINE 
# WE NEED AN ITERATIVE IMPLEMENTATION 
# RIGHT AT THIS POSITION. 
# DONT USE 'jal' AS IN PROCEDURAL /
# RECURSIVE IMPLEMENTATION.
	
	
	addi $t1, $t1, 1
    L1: bge $t2, $t0, L2
	addi $t2, $t2, 1
	mul $t1, $t1, $t2
	j L1
    L2: move $s0, $t1
    	print_str(msg2)
	print_reg_int($s0)
	print_str(charCR)
	
	exit
