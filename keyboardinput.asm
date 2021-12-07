.data
.align 2
z:	.asciiz		"z"
.align 2
s:	.asciiz		"s"
.align 2
q:	.asciiz		"q"
.align 2
d:	.asciiz		"d"
.align 2
x:	.asciiz		"x"

.globl keyboardInput

.text
keyboardInput:
	###################################################################################
#	CHANGE FRAMEPOINTER
	sw	$fp, 0($sp)			# save old framepointer
	move	$fp, $sp			# framepointer -> top of stack
	subu	$sp, $sp, 20			# Allocate 3 words on stack (16 bytes)
	sw	$ra, -4($fp)			# store return address on stack
	sw	$s0, -8($fp)			# store s-registers on stack
	sw	$s1, -12($fp)
	sw	$s2, -16($fp)

###################################################################################


	li $s1, 0xffff0000			# load input addresses
	li $s2, 0xffff0004
	
	li $t0, 0
	lw $s0, ($s1)
	beq $s0, $t0, noInput		#als 0xffff0000 == 0 -> no input found
	
leesin:
	lw $t1, ($s2)		#$t1 = input
	lw $t2, z		#t2 = z
	lw $t3, s		#$t3 =s
	lw $t4, q		#$t4 = q
	lw $t5, d		#$t5 = d
	lw $t6, x		#$t6 = x
	beq $t1, $t6, retstop
	beq $t1, $t2, retup			# if input is " a direction ": return 8:up, 4:left, 5:down, 6:right
	beq $t1, $t3, retdown
	beq $t1, $t4, retleft
	beq $t1, $t5, retright
	j return
	
retup:
	li $v0, 8
	j return
	
retdown:
	li $v0, 5
	j return
	
retleft:
	li $v0, 4
	j return
	
retright:
	li $v0, 6
	j return
	
retstop:
	li $v0, 1
	j return

noInput:
	li $v0, 0
	j return


return:
	# set framepointer back
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)			# load s-registers from stack
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)			# get right return address 
	move 	$sp, $fp			# stackpointer -> framepointer
	lw	$fp, 0($sp)			# restore old framepointer
	jr	$ra
