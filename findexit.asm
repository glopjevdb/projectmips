.data
blauw:	.word	0x000000ff
zwart: .word	0x00000000
geel:	.word	0x00ffff00
.globl findexit

.text

findexit:
#s6, s7 : player pos:
###########################################################################################"
#	CHANGE FRAMEPOINTER
	sw	$fp, 0($sp)			# save old framepointer
	move	$fp, $sp			# framepointer -> top of stack
	subu	$sp, $sp, 40			# Allocate 3 words on stack (16 bytes)
	sw	$ra, -4($fp)			# store return address on stack
	sw	$s0, -8($fp)			# store s-registers on stack
	sw	$s1, -12($fp)
	sw 	$s2, -16($fp)
	sw	$s3, -20($fp)
	sw	$s4, -24($fp)
	sw	$s5, -28($fp)
	sw	$s6, -32($fp)
	sw	$s7, -36($fp)
#############################################################################################
begin:
	move	$a0, $s6
	move	$a1, $s7
	jal 	logicaltomem
	move	$a0, $v0
	li	$a1, 3
	jal 	updatepixel
	la 	$s0, array				# $s0 contains address of array
# FOR - LOOP:
	addi 	$a0, $s6, -1
	move 	$a1, $s7				# (-1, 0)
	jal helper
	la	$s0, array
	move	$a0, $s6
	move	$a1, $s7
	jal 	logicaltomem				# show where pixel is
	move	$a0, $v0				# first: update the player pixel (every time)
	li	$a1, 3
	jal 	updatepixel
	addi	$a0, $s6, 1
	move 	$a1, $s7				# (1,0)
	jal helper
	la 	$s0, array
	move	$a0, $s6
	move	$a1, $s7
	jal 	logicaltomem
	move	$a0, $v0
	li	$a1, 3
	jal 	updatepixel				# show where pixel is
	move	$a0, $s6				
	addi	$a1, $s7, -1				# (0, -1)
	jal helper
	la	$s0, array
	move	$a0, $s6
	move	$a1, $s7
	jal 	logicaltomem
	move	$a0, $v0
	li	$a1, 3	
	jal 	updatepixel				# show where pixel is
	move	$a0, $s6
	addi	$a1, $s7, 1
	jal helper					# (0, 1)
	
exit:
####################################################################################
# set framepointer back
# set block back to black
	move	$a0, $s6
	move	$a1, $s7
	jal 	logicaltomem
	move	$a0, $v0
	li	$a1, 0
	jal 	updatepixel
	lw	$s7, -36($fp)
	lw	$s6, -32($fp)
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
				









helper:
###########################################################################################"
#	CHANGE FRAMEPOINTER
	sw	$fp, 0($sp)			# save old framepointer
	move	$fp, $sp			# framepointer -> top of stack
	subu	$sp, $sp, 40			# Allocate 3 words on stack (16 bytes)
	sw	$ra, -4($fp)			# store return address on stack
	sw	$s0, -8($fp)			# store s-registers on stack
	sw	$s1, -12($fp)
	sw 	$s2, -16($fp)
	sw	$s3, -20($fp)
	sw	$s4, -24($fp)
	sw	$s5, -28($fp)
	sw	$s6, -32($fp)
	sw 	$s7, -36($fp)
#############################################################################################
			# check if coords are in visited:
		la 	$t0, array
		li 	$t1, 0
	loop:
		add 	$t2, $t1, $t0			# address of index in t2
		lw	$t3, ($t2)			# t3 = array[t1]
		li	$t5, -1				# t2 = -1
		beq	$t5, $t3, nextif		# if t3 == -1 (no item) go inside "if1"
		beq	$a0, $t3, xequal		# if t3 == new x	goto: xequal
		addi 	$t1, $t1, 8			# go to next 2 numbers
		j loop
		
	xequal:
		addi 	$t4, $t2, 4			# increment index with 1
		lw	$t3, ($t4)			# load y position in t3
		beq	$a1, $t3, stop1			# if new y in array: stop 
		addi	$t1, $t1, 8
		j 	loop				# else: check the other items in array	
		
		
	nextif:
		move	$s0, $s6			# current player x in s0
		move	$s1, $s7			# current player y in s1
		move	$a2, $a1			# new player y in a2
		move	$a3, $a0			# new player x in a3
		move	$a0, $s7			# current player y in a0
		move 	$a1, $s6			# current player x in a1
		jal 	updateplayerpos			# update the position
		li	$v0, 32				# sleep 250 ms
		li	$a0, 50
		syscall
		bne	$s0, $s6, notequal		# if x not equal go into if
		bne	$s1, $s7, notequal		# if y not equal: go into if
		j stop1
		
	notequal:
		# add current in visited
		li	$t1, 0				# load index in t1
		la	$t0, array			# load begin address of array in t0
	loop2:
		add	$t2, $t1, $t0			# goto array[index]
		li	$t3, -1				# t3 = -1
		lw	$t4, ($t2)			# load item of array in t4
		beq	$t4, $t3, emptyfound		# if t4 == -1 goto emptyfound
		addi	$t1, $t1, 8
		j	loop2				# jump back to loop2
		
	emptyfound:
		sw	$s6, ($t2)
		sw	$s7, 4($t2)			# store x and y in array
		jal findexit

stop1:
####################################################################################
# set framepointer back
	lw	$s7, -36($fp)
	lw	$s6, -32($fp)
	lw	$s5, -28($fp)
	lw	$s4, -24($fp)
	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)				# load s-registers from stack
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)				# get right return address 
	move 	$sp, $fp				# stackpointer -> framepointer
	lw	$fp, 0($sp)				# restore old framepointer
	jr 	$ra


			
		
