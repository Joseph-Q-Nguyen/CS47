.macro mac1 ($arg1)
add $arg1, $arg1, $arg1
addi $arg1, $arg1, -1
.end_macro
.macro mac2 ($arg1, $arg2)
mac1($arg2)
sub $arg1, $arg1, $arg2
.end_macro

.text
L1: addi $t1, $zero, 10
 addi $t2, $zero, 5
L2: mac1($t1)
 beq $t1, $t2, L4

L3: mac1($t2)
L4: mac2($t2, $t1)

L5: bne $t2, $t1, L2

