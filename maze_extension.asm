.data

#fin:	.asciiz		"./MIPS/MIPSMazeGame/maze.txt"

.text

	jal buildmaze	
	jal findexit
	j stop
	
	
	
stop:
# exit to OS
	li $v0, 10
	syscall
