.include "./cs47_proj_macro.asm"
.text
.globl au_normal
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_normal:
	addi $sp, $sp, -12
	sw $fp, 12($sp)
	sw $ra, 8($sp)
	addi $fp, $sp, 12
	
	beq $a2, '+', add
	beq $a2, '-', sub
	beq $a2, '*', mul
	beq $a2, '/', div
add:
	add_norm($a0,$a1)
	j au_normal_end
sub:
	sub_norm($a0,$a1)
	j au_normal_end
mul:
	mul_norm($a0,$a1)
	j au_normal_end
div:
	div_norm($a0,$a1)
	j au_normal_end
	
au_normal_end:
	lw $fp, 12($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr	$ra
