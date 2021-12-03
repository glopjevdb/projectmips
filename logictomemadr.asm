.eqv LOG2_COLS 		 7
.eqv LOG2_WIDTH 	 2

.data	

rood:		.word		0x00ff0000
groen:		.word		0x0000ff00
blauw:		.word		0x000000ff

.text

.globl logicaltomem

	li $a0, 12
	li $a1, 15
	jal logicaltomem
	lw $t0, rood
	sw $t0, ($v0)
	
	li $v0, 10
	syscall
	
logicaltomem:				#$a0: x  	$a1: y
	sll $a0, $a0, LOG2_WIDTH	#x * 4 
	sll $a1, $a1, LOG2_COLS 	#y * 32 * 4  --> 32 blokjes op 1 rij
	la $t1, ($gp)			#laad eerste adres van bitmap display in
	add $a0, $a1, $a0    		# aantalbits = y*32*4 + x * 4
	add $v0, $t1, $a0		# adres = beginadres scherm + aantalbits
	la $v0, ($v0)
	jr $ra
	
	
	
	