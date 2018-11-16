# To print a string at given address
.macro print_str($uaddr, $laddr)
addi $v0, $zero, 4
load_address($a0, $uaddr, $laddr)
syscall
.end_macro
# To print an integer at given register
.macro print_reg_int ($arg)
addi $v0, $zero, 1
move $a0, $arg
syscall
.end_macro
.macro exit
addi $v0, $zero, 10
syscall
.end_macro
.macro load_address($reg, $uaddr, $laddr)
lui $reg, $uaddr
ori $reg, $reg, $laddr
.end_macro
.data 0x10010000
arr1: .word 0x1 0x4 0x4 0x6
 .word 0x8 0x9 0xA 0xB 0xC 0xD
space: .asciiz " "
arr2: .word 0x2 0x3 0x4 0x5
 .word 0x7 0x7 0xE 0xE 0xF 0xF
cr: .asciiz "\n"
gidx: .word 0x0
arr3: .word 0x0


.text
.globl main
main:
my_proc:
beq $a0,$a1,main
blt $a0,$a1,main
blt $a0,$a1,main
blt $a0,$a1,main
j store_a2
load_a2:
lw $t5, 0($a2)
store_a2:
add $t6, $t5, $zero
addi $a3, $a3, -1
add $a2, $a2, 0x4
j store
load_a0:
lw $t4, 0($a0)
store_a0:
add $t6, $t4, $zero
addi $a1, $a1, -1
add $a0, $a0, 0x4
store:
load_address($t1, 0x1001, 0x0058)
lw $t2, 0($t1)
load_address($t3, 0x1001, 0x005c)
add $t3, $t3, $t2
addi $t2, $t2, 0x4
sw $t2, 0($t1)
sw $t6, 0($t3)
jal my_proc
my_proc_done:
lw $fp, 28($sp)
lw $ra, 24($sp)
lw $a0, 20($sp)
lw $a1, 16($sp)
lw $a2, 12($sp)
lw $a3, 8($sp)
addi $sp, $sp, 28
jr $ra
