.data
zwart: 	.word		0x00000000
rood: 	.word		0x00ff0000
geel:	.word		0x00ffff00
blauw:	.word		0x000000ff

.text

.globl main

updatepixel:
	###################################################################################
#	CHANGE FRAMEPOINTER
	sw	$fp, 0($sp)			# save old framepointer
	move	$fp, $sp			# framepointer -> top of stack
	subu	$sp, $sp, 28			# Allocate 6 words on stack (28 bytes)
	sw	$ra, -4($fp)			# store return address on stack
	sw	$s0, -8($fp)			# store s-registers on stack
	sw	$s1, -12($fp)
	sw	$s2, -16($fp)
	sw	$s3, -20($fp)
	sw 	$s4, -24($fp)

###################################################################################

	lw $s3, rood		#laad rood in
	lw $s0, blauw
	lw $s1, zwart
	li $t5, 31
#	li $s0, 0		# x = 0
#	li $s1, 0		# y = -1
	addi $s1, $s1, -1	# hierboven
	li $s2, 32		# waarde om vergelijkingen mee te doen
	beq $a1, 0, zwart
	beq $a1, 1, blauw
	
blauw:
	sw $s0, ($a0)		# zet waarde van bitmap op positie op blauw
	j exit
zwart:
	sw $s1, ($a0)
	j exit
exit:
# set framepointer back
	lw	$s4, -24($fp)
	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)			# load s-registers from stack
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)			# get right return address 
	move 	$sp, $fp			# stackpointer -> framepointer
	lw	$fp, 0($sp)			# restore old framepointer
	jr	$ra
	
	
	
	
	
	
#loop1:
#	move $a0, $s0
#	move $a1, $s1		#zet argumenten juist voor functie
#	jal logicaltomem
#	sw $s3, ($v0)		#rood in adress storen
#	beq $s1, $0, kleurgeel
#	beq $s1, $t5, kleurgeel
#	beq $s0, $0, kleurgeel
#	beq $s0, $t5, kleurgeel
#retbranch:
#	addi $s0, $s0, 1	#x-waarde met 1 verhogen
#	beq $s0, $s2, loop2	#check of einde behaald is
#	j loop1
#	
#loop2:
#	li $s0, 0	# x = 0
#	addi $s1, $s1,  1	# y = y + 1
#	beq $s1, 32, end	#check of einde behaald is
#	j loop1
#	
#kleurgeel:
#	sw $s4, ($v0)
#	j retbranch		#zet adres van $v0 op geel
#	
#end:
#
#	li $v0, 10
#	syscall
#	
#