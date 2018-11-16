# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#

.macro add_norm($r1,$r2)
add $v0,$r1,$r2 
.end_macro

.macro sub_norm($r1,$r2)
sub $v0,$r1,$r2
.end_macro

.macro mul_norm($r1,$r2)
mult $r1,$r2     
mflo $v0
mfhi $v1
.end_macro

.macro div_norm($r1,$r2)
div $r1,$r2  
mflo $v0
mfhi $v1
.end_macro

.macro extract_nth_bit($return, $pattern, $index)
srlv $t0,$pattern,$index
andi $t0,$t0,1 
add $return,$zero,$t0 
.end_macro

.macro insert_to_nth_bit($pattern,$num,$index)
add $t0,$zero,$num
sllv $t0,$t0,$index
or $pattern,$pattern,$t0
.end_macro 

.macro bit_replicator($return,$num)
beq $num,0,return_zero 
addi $return,$zero,0xFFFFFFFF
j end
return_zero:
addi $return,$zero,0x0
end:
.end_macro


