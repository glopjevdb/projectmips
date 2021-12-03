.data

#fin:	.asciiz		"./MIPS/projectmips/maze.txt"
.globl buffer
buffer:		.space 2048

.text

	jal buildmaze
	
	
	
	
	
	
	
	
	
	
	
# exit to OS
	li $v0, 10
	syscall