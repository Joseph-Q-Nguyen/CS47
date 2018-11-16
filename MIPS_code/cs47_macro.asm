#<------------------ MACRO DEFINITIONS ---------------------->#
        # Macro : print_str
        # Usage: print_str(<address of the string>)
        .macro print_str($arg)
	li	$v0, 4     # System call code for print_str  
	la	$a0, $arg   # Address of the string to print
	syscall            # Print the string        
	.end_macro
	
	# Macro : print_int
        # Usage: print_int(<val>)
        .macro print_int($arg)
	li 	$v0, 1     # System call code for print_int
	li	$a0, $arg  # Integer to print
	syscall            # Print the integer
	.end_macro
	
	# Macro : exit
        # Usage: exit
        .macro exit
	li 	$v0, 10 
	syscall
	.end_macro
	
	# Macro : read_int
	# Usage : read_int($reg)
	.macro read_int($reg)
	li	 $v0, 5		# System call code for read_int
	syscall			# Reads int and stores in $v0
	move	$reg, $v0	# Move int in $v0 to $reg
	.end_macro
	
	# Macro : print_reg_int
	# Usage : print_reg_int($reg)
	.macro print_reg_int($reg) 
	li 	$v0, 1		# System call for print_int
	move	$a0, $reg	# Move int int $reg to $a0
	syscall 		# Prints the int
	.end_macro
	
	.macro swap_hi_lo ($temp1, $temp2)
	mfhi $temp1
	mflo $temp2
	mthi $temp2
	mtlo $temp1
	.end_macro
	
	.macro print_hi_lo($strHi, $strEqual, $strComma, $strLo)
	print_str($strHi)
	print_str($strEqual)
	mfhi $t0
	print_reg_int($t0)
	print_str($strComma)
	print_str($strLo)
	print_str($strEqual)
	mflo $t0
	print_reg_int($t0)
	.end_macro
	
	.macro lwi($reg, $ui, $li)
	lui $reg, $ui
	ori $reg, $reg, $li
	.end_macro
	
	.macro push($reg)
	sw $reg, 0x0($sp)
	addi $sp, $sp, -4
	.end_macro
	
	.macro pop($reg)
	addi $sp, $sp, 4
	lw $reg, 0x0($sp)
	.end_macro
	
	
	

	
