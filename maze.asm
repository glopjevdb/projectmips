.data

#fin:	.asciiz		"./MIPS/MIPSMazeGame/maze.txt"
.globl buffer
buffer:		.space 262656
.globl array
.align 2
array:		.word -1:2048

.text

	jal buildmaze
	
	
loop:
	jal keyboardInput			# load input in v0
	move $a1, $s6				# load current player pos in arguments
	move $a0, $s7
	beq $v0, 0, endloop
	beq $v0, 1, stop
	beq $v0, 8, up
	beq $v0, 5, down
	beq $v0, 4, left
	beq $v0, 6, right
	
up:
	subi $a2, $s7, 1
	move $a3, $s6
	jal updateplayerpos
	j endloop	
	
down:
	addi $a2, $s7, 1
	move $a3, $s6
	jal updateplayerpos
	j endloop
	
left:
	subi $a3, $s6, 1
	move $a2, $s7
	jal updateplayerpos
	j endloop
	
right:
	addi $a3, $s6, 1
	move $a2, $s7
	jal updateplayerpos
	j endloop
	
	
	
endloop:
	li $a0, 60
	li $v0, 32
	syscall
	j loop
	
stop:
# exit to OS
	li $v0, 10
	syscall
