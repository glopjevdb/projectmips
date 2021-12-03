.data

fin:	.asciiz		"./MIPS/projectmips/input.txt"
buffer:	.space	2048


.text
	li $v0, 13	#system call for open file
	la $a0, fin	#output file name
	
	li $a1, 0	#open for read
	li $a2, 0	#mode is ignored
	syscall
	
	move $s6, $v0	#safe descriptor
	
	############################################
	
	li $v0, 14	#syscall for read from file
	move $a0, $s6	#file descriptor
	la $a1, buffer	#adress waar contents geladen moeten worden
	li $a2, 2048	#max number of chars
	syscall
	
	##############################################
	li $v0, 16
	move $a0, $s6
	syscall
	
	
	
	##############################################
	
	la $a0, buffer
	li $v0, 4
	syscall
	
	
	li $v0, 10
	syscall
	
