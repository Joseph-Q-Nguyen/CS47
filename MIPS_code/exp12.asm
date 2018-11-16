.include "./cs47_macro.asm"

.data
var_a: .byte 0x10          # Type: char  (8-bit)
var_b: .half 0x3210        # Type: short (16-bit)
var_c: .byte 0x20          # Type: char  (8-bit)
var_d: .word 0x76543210    # Type: int   (32-bit)

.text
.globl main
main:
	# these are all pseudo instruction
	# MIPS natively supports only relative
	# address translation (e.g. lb $s0, 0x2345($gp))
	lb	$s0, var_a # R[s0] = M[var_a](7:0)	
	lh	$s1, var_b # R[s1] = M[var_b](15:0)
	lb      $s2, var_c # R[s2] = M[var_c](7:0)
	lw      $s3, var_d # R[s3] = M[var_d](15:0)

	
	# Push the S0...4 to stack
	sw	$s0, 0x0($sp)	# M[$sp] = R[s0]
	addi    $sp, $sp, -4	# R[sp] = R[sp] - 4
	sw	$s1, 0x0($sp)	# M[$sp] = R[s0]
	addi    $sp, $sp, -4	# R[sp] = R[sp] - 4
	sw	$s2, 0x0($sp)	# M[$sp] = R[s0]
	addi    $sp, $sp, -4	# R[sp] = R[sp] - 4
	sw	$s3, 0x0($sp)	# M[$sp] = R[s0]
	addi    $sp, $sp, -4	# R[sp] = R[sp] - 4
		
	# pop the t0...4 to stack
	addi    $sp, $sp, +4	# R[sp] = R[sp] + 4
	lw	$t0, 0x0($sp)	# R[t0] = M[sp]
	addi    $sp, $sp, +4	# R[sp] = R[sp] + 4
	lw	$t1, 0x0($sp)	# R[t1] = M[sp]
	addi    $sp, $sp, +4	# R[sp] = R[sp] + 4
	lw	$t2, 0x0($sp)	# R[t2] = M[sp]
	addi    $sp, $sp, +4	# R[sp] = R[sp] + 4
	lw	$t3, 0x0($sp)	# R[t3] = M[sp]
	
	# system Exit
	exit
