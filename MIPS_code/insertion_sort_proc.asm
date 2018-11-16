.text
#-------------------------------------------
# Procedure: insertion_sort
# Argument: 
#	$a0: Base address of the array
#       $a1: Number of array element
# Return:
#       None
# Notes: Implement insertion sort, base array 
#        at $a0 will be sorted after the routine
#	 is done.
#-------------------------------------------
insertion_sort:
	# Caller RTE store (TBD)
	addi $sp, $sp, -20
	sw $fp, 20($sp)
	sw $ra, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	addi $fp, $sp, 20
	# Implement insertion sort (TBD)

	addi $t0, $zero, 0	
loop1:
	beq $t0, $a1, insertion_sort_end  # for($t0 = 0; $t0 < $a1; $t0++) 
	addi $t1, $t0, 0
loop2:	# for($t1 = $t0; $t1 >= 0; $t1--)
	beqz $t1, loop2_end #$ t0 == 0, then it is already sorted
	addi $t2 , $t1, -1 # $t2 == $t1 - 1
	mul $t3, $t1, 4 # index multiplied by 4 to get relative bytes
	mul $t4, $t2, 4
	add $t5, $t3, $a0 # relative memory address of first index
	add $t6, $t4, $a0 # relative meory address of second index
	lw $t7, 0($t5) # load number of first index
	lw $t8, 0($t6) # load number of second index
	ble $t8, $t7, loop2_end # if second number is less than first, it is in correct spot
	sw $t7, 0($t6) # otherwise, swap the numbers then decrement index to check next number
	sw $t8, 0($t5)
	addi $t1, $t1, -1
	j loop2
loop2_end:
	addi $t0, $t0, 1
	j loop1

insertion_sort_end:
	# Caller RTE restore (TBD)
	lw $fp, 20($sp)
	lw $ra, 16($sp)
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 20
	# Return to Caller
	jr	$ra
