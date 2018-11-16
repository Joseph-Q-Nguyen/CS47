.data 
str:	.asciiz "the answer is = "

.text
	li 	$v0, 4
	la	$a0, str
	syscall
	
	li	$v0, 1
	li	$a0, 5
	syscall
	
	li	$v0, 10
	syscall