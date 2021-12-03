.data

fin:	.asciiz		"./MIPS/projectmips/maze.txt"

.globl fileinput
.text

fileinput:
###################################################################################
#	CHANGE FRAMEPOINTER
	sw	$fp, 0($sp)			# save old framepointer
	move	$fp, $sp			# framepointer -> top of stack
	subu	$sp, $sp, 12			# Allocate 2 words on stack (12 bytes)
	sw	$ra, -4($fp)			# store return address on stack
	sw	$s0, -8($fp)			# store s-registers on stack

###################################################################################
	li $v0, 13	# system call for open file
	la $a0, fin	# output file name
	
	li $a1, 0	# open for read
	li $a2, 0	# mode is ignored
	syscall
	
	move $s0, $v0	# safe descriptor
	
	############################################
	
	li $v0, 14	# syscall for read from file
	move $a0, $s0	# file descriptor
	la $a1, buffer	# adress waar contents geladen moeten worden
	li $a2, 2048	# max number of chars
	syscall
	
	##############################################
	li $v0, 16
	move $a0, $s0
	syscall
	move $v0, $a1	# put adress of contents in return register
	
####################################################################################
# set framepointer back	                  # load s-registers from stack
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)			# get right return address 
	move 	$sp, $fp			# stackpointer -> framepointer
	lw	$fp, 0($sp)			# restore old framepointer
	jr	$ra
	
##############################################
	
	#la $a0, buffer
	#li $v0, 4
	#syscall
	
