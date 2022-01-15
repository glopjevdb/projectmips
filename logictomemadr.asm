.data	

rood:		.word		0x00ff0000
groen:		.word		0x0000ff00
blauw:		.word		0x000000ff

.text

.globl logicaltomem

	
logicaltomem:				#$a0: x  	$a1: y
	#INPUTS: a0: x		a1: y		a2: width	a3: height
	
	###################################################################################
#	CHANGE FRAMEPOINTER
	sw	$fp, 0($sp)			# save old framepointer
	move	$fp, $sp			# framepointer -> top of stack
	subu	$sp, $sp, 16			# Allocate 3 words on stack (16 bytes)
	sw	$ra, -4($fp)			# store return address on stack
	sw	$s0, -8($fp)			# store s-registers on stack
	sw	$s1, -12($fp)

###################################################################################

	sll $a0, $a0, 2			#x * 4 
	sll $a1, $a1, 2			#y * width * 4  --> 32 blokjes op 1 rij
	mul $a1, $a1, $a2
	la $t1, ($gp)			#laad eerste adres van bitmap display in
	add $a0, $a1, $a0    		# aantalbits = y*32*4 + x * 4
	add $v0, $t1, $a0		# adres = beginadres scherm + aantalbits
	la $v0, ($v0)
	
	
# set framepointer back
	lw	$s1, -12($fp)			# load s-registers from stack
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)			# get right return address 
	move 	$sp, $fp			# stackpointer -> framepointer
	lw	$fp, 0($sp)			# restore old framepointer
	jr	$ra
	
	
	
	
