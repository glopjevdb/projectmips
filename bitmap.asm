.data

rood: 	.word		0x00ff0000
geel:	.word		0x00ffff00

.text

.globl main

main:
	lw $s3, rood		#laad rood in
	lw $s4, geel
	li $t5, 31
	li $s0, 0		# x = 0
	li $s1, 0		# y = -1
	addi $s1, $s1, -1	# hierboven
	li $s2, 32		# waarde om vergelijkingen mee te doen
	j loop2
loop1:
	move $a0, $s0
	move $a1, $s1		#zet argumenten juist voor functie
	jal logicaltomem
	sw $s3, ($v0)		#rood in adress storen
	beq $s1, $0, kleurgeel
	beq $s1, $t5, kleurgeel
	beq $s0, $0, kleurgeel
	beq $s0, $t5, kleurgeel
retbranch:
	addi $s0, $s0, 1	#x-waarde met 1 verhogen
	beq $s0, $s2, loop2	#check of einde behaald is
	j loop1
	
loop2:
	li $s0, 0	# x = 0
	addi $s1, $s1,  1	# y = y + 1
	beq $s1, 32, end	#check of einde behaald is
	j loop1
	
kleurgeel:
	sw $s4, ($v0)
	j retbranch		#zet adres van $v0 op geel
	
end:

	li $v0, 10
	syscall
	