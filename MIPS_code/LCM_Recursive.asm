.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a +ve number : "
msg2: .asciiz "Enter another +ve number : "
msg3: .asciiz "LCM of "
s_is: .asciiz "is"
s_and: .asciiz "and"
s_space: .asciiz " "
s_cr: .asciiz "\n"

.text
.globl main
main:
	print_str(msg1)
	read_int($s0)
	print_str(msg2)
	read_int($s1)
	
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	move $a2, $s0
	move $a3, $s1
	jal  lcm_recursive
	move $s3, $v0
	
	print_str(msg3)
	print_reg_int($s0)
	print_str(s_space)
	print_str(s_and)
	print_str(s_space)
	print_reg_int($s1)
	print_str(s_space)
	print_str(s_is)
	print_str(s_space)
	print_reg_int($s3)
	print_str(s_cr)
	exit

#------------------------------------------------------------------------------
# Function: lcm_recursive 
# Argument:
#	$a0 : +ve integer number m
#       $a1 : +ve integer number n
#       $a2 : temporary LCM by increamenting m, initial is m
#       $a3 : temporary LCM by increamenting n, initial is n
# Returns
#	$v0 : lcm of m,n 
#
# Purpose: Implementing LCM function using recursive call.
# 
#------------------------------------------------------------------------------
lcm_recursive:
	# Store frame - 2 stored aruments + fp + ra => (4 variables * 4 bytes) = frame size: 16 bytes, sp move size = 16 + 8 - 4 = 20
	addi $sp,$sp, -20
	sw $fp, 20($sp)
	sw $ra, 16($sp)
	sw $a2, 12($sp)
	sw $a3, 8($sp)
	add $fp, $sp, 20
	
	# Body
	beq $a2,$a3, base_case # if $a2 = $a3 return $a2
	blt $a2,$a3, increment_a2 # if $a2 < $a3 increment $a2
	add $a3,$a3,$a1 # else increment $a3
	jal lcm_recursive
	j lcm_return
	
increment_a2: 
	add $a2,$a2,$a0
	jal lcm_recursive
	j lcm_return
	
base_case: 
	addu $v0,$zero,$a2
	
lcm_return: # Restore frame	
	lw $fp, 20($sp)
	lw $ra, 16($sp)
	lw $a2, 12($sp)
	lw $a3, 8($sp)
	addi $sp, $sp, 20

	jr $ra
	
