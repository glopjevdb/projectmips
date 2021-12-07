.data

blauw:	.word		0x000000ff
groen:	.word		0x0000ff00

.globl updateplayerpos

.text


updateplayerpos:
	###################################################################################
#	CHANGE FRAMEPOINTER
	sw	$fp, 0($sp)			# save old framepointer
	move	$fp, $sp			# framepointer -> top of stack
	subu	$sp, $sp, 32			# Allocate 6 words on stack (28 bytes)
	sw	$ra, -4($fp)			# store return address on stack
	sw	$s0, -8($fp)			# store s-registers on stack
	sw	$s1, -12($fp)
	sw	$s2, -16($fp)
	sw	$s3, -20($fp)
	sw 	$s4, -24($fp)
	sw	$s5, -28($fp)

###################################################################################
# ARGUMENTS:
# a0: CURRENT PLAYER Y
# a1: CURRENT PLAYER X
# a2: NEW PLAYER Y
# a3: NEW PLAYER X
# RETURN: $v0, $v1 NEW PLAYER LOCATION IF MOVING IS POSSIBLE

move 	$s1, $a0			# player y in s1
move 	$s0, $a1			# player x in s0
move 	$s2, $a3			# new player X in s2
move 	$s3, $a2			# new player y in s3

move 	$a0, $s2			# move new player x in arg pos 0		(x)
move 	$a1, $s3			# move new player y in arg pos 1		(y)

move $a2, $s4				# load dimensions of grid
move $a3, $s5

jal logicaltomem			# v0: memaddress of new position

lw	$t0, ($v0)			# load color of pixel of mem addr in $t0
lw	$t1, blauw			# load blue color in $t1
lw	$t2, groen			# load green color in $t2





	
beq $t0, $t2, exitfound			# if player goes to exit: jump to exitfound

bne	$t0, $t1, moveplayer		# if not a wall: move player to new pos
j exit					# else: stop

moveplayer:
	# EERST: tweede pixel geel maken
	move 	$a0, $v0			# load address in $a0
	li 	$a1, 3				# load 3 in a1	(yellow)
	jal updatepixel
		
	# TWEEDE PIXEL ZWART MAKEN
	move 	$a0, $s0
	move 	$a1, $s1			# position of initial location in arguments
	jal 	logicaltomem			# v0: address of pixel
	
	move 	$a0, $v0			# load address of pixel in a0
	li 	$a1, 0				# load 0 in a1 (black)
	jal 	updatepixel
	
	move 	$s7, $s3			# move new player pos to s6 and s7 to return
	move 	$s6, $s2	
	
	
	
	j exit					# exit loop


exitfound:
	li $v0, 10
	syscall					# cleanly exit to OS

exit:
####################################################################################
# set framepointer back
	lw	$s5, -28($fp)
	lw	$s4, -24($fp)
	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)			# load s-registers from stack
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)			# get right return address 
	move 	$sp, $fp			# stackpointer -> framepointer
	lw	$fp, 0($sp)			# restore old framepointer
	jr	$ra
