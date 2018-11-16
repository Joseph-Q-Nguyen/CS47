.include "./cs47_macro.asm"
.text
main:
    li  $zero, 0x1
    li  $at, 0x2
    li  $v0, 0x3
    li  $v1, 0x4
    li  $a0, 0x5
    li  $a1, 0x6
    li  $a2, 0x7
    li  $a3, 0x8
    li  $t0, 0x9
    li  $t1, 0xA
    li  $t2, 0xB
    li  $t3, 0xC
    li  $t4, 0xD
    li  $t5, 0xE
    li  $t6, 0xF
    li  $t7, 0x10
    li  $s0, 0x11
    li  $s1, 0x12
    li  $s2, 0x13
    li  $s3, 0x14
    li  $s4, 0x15
    li  $s5, 0x16
    li  $s6, 0x17
    li  $s7, 0x18
    li  $t8, 0x19
    li  $t9, 0x1A
    li  $k0, 0x1B
    li  $k1, 0x1C
    li  $gp, 0x1D
    li  $sp, 0x1E
    li  $fp, 0x1F
    li  $ra, 0x20
  
    lui $t5, 0x50AF
    li  $t5, 0x12AB

    
    move $s2, $t5
    li	$s1, 0x50ab 
    
    mthi $s2
    mtlo $s1
    
    
    
    
    
    exit