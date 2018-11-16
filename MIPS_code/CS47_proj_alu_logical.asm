.include "./cs47_proj_macro.asm"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:
	addi $sp, $sp, -12
	sw $fp, 12($sp)
	sw $ra, 8($sp)
	addi $fp, $sp, 12
	
	beq $a2, '+', add
	beq $a2, '-', sub
	beq $a2, '*', mul
	beq $a2, '/', div
add:
	jal add_logical
	j au_logical_end
sub:
	jal sub_logical
	j au_logical_end
mul:
	jal mul_signed
	j au_logical_end
div:
	jal div_signed
	j au_logical_end
	
au_logical_end:
	lw $fp, 12($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr	$ra

# Add Logical Procedure
# Arguments:
# 	$a0 = first number
# 	$a1 = second number
# Temporary values:
# 	$s0 = counter for bit index
# 	$s1 = Carry value starts at 0
# 	$s2 = bit pattern for sum
# Return: 
# 	$v0 = $a0 + $a1
add_logical:
	addi $sp, $sp, -24
	sw $fp, 24($sp)
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	addi $fp, $sp, 24

	add $s0,$zero,$zero # counter for bit index
	add $s1,$zero,$zero # Carry value starts at 0
	add $s2,$zero,$zero # bit pattern for sum
add_loop:
	beq $s0,32,add_logical_end
	extract_nth_bit($t1, $a0, $s0)
	extract_nth_bit($t2, $a1, $s0)
	
	xor $t3,$s1,$t1 # CarryIn xor t1
	xor $t3,$t3,$t2 # (CarryIn xor t1) xor t2, t3 = sum bit
	
	xor $t4,$t1,$t2
	and $t5,$s1,$t4
	and $t6,$t1,$t2
	or $s1,$t5,$t6	# s1 = CO = CI.(t1 xor t2) + t1.t2
	
	insert_to_nth_bit($s2,$t3,$s0)
	addi $s0,$s0,1
	j add_loop
		
add_logical_end:
	add $v0,$zero,$s2 	# return sum
	add $v1,$zero,$s1 	# return carry
	
	lw $fp, 24($sp)
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	lw $s1, 12($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 24
	jr	$ra
	
# Twos Complement Procedure
# Arguments:
#	$a0 = number to be complemented
# Return:
#	$v0 = the complemented number
twos_complement:
	addi $sp, $sp, -20
	sw $fp, 20($sp)
	sw $ra, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	addi $fp, $sp, 20
	
	not $a0,$a0		#INV($a0)
	addi $a1,$zero,1	
		
	jal add_logical	
	
	lw $fp, 20($sp)
	lw $ra, 16($sp)
	lw $a0, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 20
	jr $ra

# Sub Logical Procedure
sub_logical:	
	addi $sp,$sp, -24
	sw $fp, 24($sp)
	sw $ra, 20($sp)
	sw $a1, 16($sp)
	sw $a0, 12($sp)
	sw $s1, 8($sp)
	addi $fp, $sp, 24
	
	move $s1,$a0		# Store first operand
	move $a0,$a1
	jal twos_complement	# Invert second operand
	move $a1,$v0
	move $a0,$s1
	jal add_logical		# Add them together

	lw $fp, 24($sp)
	lw $ra, 20($sp)
	lw $a1, 16($sp)
	lw $a0, 12($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 24
	jr $ra
			
# Twos Complement if Negative Procedure
# Arguments:
#	$a0 = number to be checked
# Return:
#	$v0 = if $a0 is negative return its complement
twos_complement_if_neg:
	addi $sp, $sp, -16
	sw $fp, 16($sp)
	sw $ra, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 16
	
	addi $t0,$zero,31
	add $v0,$zero,$a0		# Set $v0 to number
	extract_nth_bit($t0,$a0,$t0)    # Get the 31st bit of number
	beq $t0,0,twos_complement_if_neg_end 
	jal twos_complement
	
twos_complement_if_neg_end:	
	lw $fp, 16($sp)
	lw $ra, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 16
	jr $ra
	
# Twos Complement 64bit Procedure
# Arguments:
#	$a0 = Lo of num
#	$a1 = Hi of num
# Return:
#	$v0 = Lo part of 2's complement
#	$v1 = Hi part of 2's complement
twos_complement_64bit:
	addi $sp, $sp, -28
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	sw $s1, 20($sp)
	sw $s0, 16($sp)
	sw $a1, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp, 28
	
	not $s0,$a0		# Invert $a0
	not $s1,$a1		# Invert $a1
	
	add $a0,$zero,$s0
	addi $a1,$zero,1
	jal add_logical		# Add 1 to ~$a0
	add $a0,$zero,$s1
	add $a1 $zero,$v1 
	add $s1,$zero,$v0
	jal add_logical		# Add the Carry Out from previous calculation to ~$a1
	add $v1,$zero,$v0
	add $v0,$zero,$s1	# Return the values
	
	lw $fp, 28($sp)
	lw $ra, 24($sp)
	lw $s1, 20($sp)
	lw $s0, 16($sp)
	lw $a1, 12($sp)
	sw $a0, 8($sp)
	addi $sp, $sp, 28
	jr $ra
		
# Mul Unsigned Procedure
mul_unsigned:
	addi $sp, $sp, -36
	sw $fp, 36($sp)
	sw $ra, 32($sp)
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	addi $fp, $sp, 36
	
	addi $s0,$zero,0 	# i = 0
	add $s1,$zero,$a0 	# Multiplicand, M
	add $s2,$zero,$a1 	# Set Lo as multiplier, L
	addi $s3,$zero,0 	# Set Hi as partial sums starting at 0, H

mul_loop:		
	beq $s0,32,mul_unsigned_end
	addi $t2,$zero,0
	extract_nth_bit($t1,$s2,$t2) 	# Get right most bit of Lo, L[0]
	bit_replicator($t0,$t1)		# Replicate that bit, R = 32(L[0])
	and $t3,$t0,$s1			# X = M & R
	move $a0,$s3
	move $a1,$t3
	jal add_logical	
	move $s3,$v0			# H = H + X
	srl $s2,$s2,1			# L = L << 1
	addi $t8,$zero,0
	addi $t9,$zero,31
	extract_nth_bit($t0,$s3,$t8)
	insert_to_nth_bit($s2,$t0,$t9)	# L[31] = H[0]
	srl $s3,$s3,1			# H = H >> 1
	addi $s0,$s0,1			# i++
	j mul_loop
	
mul_unsigned_end:
	add $v0,$zero,$s2		# $v0 = LO
	add $v1,$zero,$s3		# $v1 = Hi

	lw $fp, 36($sp)
	lw $ra, 32($sp)
	lw $s0, 28($sp)
	lw $s1, 24($sp)
	lw $s2, 20($sp)
	lw $s3, 16($sp)
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 36
	jr $ra
	
# Mul Signed Procedure
mul_signed:
	addi $sp, $sp, -28
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	addi $fp, $sp, 28
	
	add $s2,$zero,$a0		# Store first number
	add $s3,$zero,$a1		# Store second number
	
	jal twos_complement_if_neg	# Absolute value of first number
	add $s0,$zero,$v0
	add $a0,$zero,$s3
	jal twos_complement_if_neg	# Absolute value of second number
	add $s1,$zero,$v0
	
	add $a0,$zero,$s0
	add $a1,$zero,$s1
	jal mul_unsigned		# Positive product
	
	addi $t0,$zero,31
	extract_nth_bit($t1,$s2,$t0)
	addi $t0,$zero,31
	extract_nth_bit($t2,$s3,$t0)
	xor $t0,$t1,$t2			# Determine sign of product 0 if postive, 1 if negative
	
	beq $t0,0,mul_signed_end	# If postive, done, else compute 64bit complement
	add $a0,$zero,$v0
	add $a1,$zero,$v1
	jal twos_complement_64bit
mul_signed_end:

	lw $fp, 28($sp)
	lw $ra, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	addi $sp, $sp, 28
	jr $ra
	
# Div Unsigned Procedure
div_unsigned:
	addi $sp, $sp, -28
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 28
	
	addi $s4,$zero,0 	# i = 0
	add $s5,$zero,$a0 	# Q = Dividend
	add $s6,$zero,$a1 	# D = Divisor
	addi $s7,$zero,0 	# R = remainder starts at zero
	
div_loop:
	beq $s4,32,div_unsigned_end	# Check i==32
	sll $s7,$s7,1			# R << 1
	addi $t0,$zero,31
	extract_nth_bit($t0,$s5,$t0)  	# Q[31]
	addi $t1,$zero,0
	insert_to_nth_bit($s7,$t0,$t1)  # R[0] = Q[31]
	sll $s5,$s5,1			# Q << 1
	move $a0,$s7
	move $a1,$s6
	jal sub_logical			# S = R - D
	blt $v0, 0, increment_i		# if (s < 0) then branch
	move $s7,$v0			# R = S
	addi $t2,$zero,0
	addi $t3,$zero,1
	insert_to_nth_bit($s5,$t3,$t2)  # Q[0] = 1
increment_i:
	addi $s4,$s4,1
	j div_loop
div_unsigned_end:
	move $v0,$s5
	move $v1,$s7

	lw $fp, 28($sp)
	lw $ra, 24($sp)
	lw $s4, 20($sp)
	lw $s5, 16($sp)
	lw $s6, 12($sp)
	lw $s7, 8($sp)
	addi $sp, $sp, 28
	jr $ra
	
# Div Signed Procedure
div_signed:
	addi $sp, $sp, -28
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	addi $fp, $sp, 28
	
	add $s2,$zero,$a0		# Store $a0
	add $s3,$zero,$a1		# Store $a1

	jal twos_complement_if_neg	# |$a0|
	add $s0,$zero,$v0
	add $a0,$zero,$s3
	jal twos_complement_if_neg	# |$a1|
	add $s1,$zero,$v0
	add $a0,$zero,$s0
	add $a1,$zero,$s1
	jal div_unsigned		# |$a0/$a1|
	move $s0,$v0			# Store quotient
	move $s1,$v1			# Store remainder
	addi $t0,$zero,31
	extract_nth_bit($t1,$s2,$t0)
	addi $t0,$zero,31
	extract_nth_bit($t2,$s3,$t0)
	xor $t0,$t1,$t2			
	beq $t0,0,sign_of_R		# If signs of $a0 and $a1 are not the same, invert the quotient
	move $a0,$s0
	jal twos_complement
	move $s0,$v0
sign_of_R:
	addi $t0,$zero,31
	extract_nth_bit($t1,$s2,$t0)
	beq $t1,0,div_signed_end	# If sign of $a0 is negative, invert it
	move $a0,$s1
	jal twos_complement
	move $s1,$v0
div_signed_end:
	move $v0,$s0
	move $v1,$s1

	lw $fp, 28($sp)
	lw $ra, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	addi $sp, $sp, 28
	jr $ra
