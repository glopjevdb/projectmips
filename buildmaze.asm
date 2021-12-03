.data

#fin:	.asciiz		"./MIPS/projectmips/maze.txt"

.globl buildmaze

newline:	.byte	'\n'
wall:		.byte	'w'
.text

buildmaze:
###################################################################################
#	CHANGE FRAMEPOINTER
	sw	$fp, 0($sp)			# save old framepointer
	move	$fp, $sp			# framepointer -> top of stack
	subu	$sp, $sp, 16			# Allocate 3 words on stack (16 bytes)
	sw	$ra, -4($fp)			# store return address on stack
	sw	$s0, -8($fp)			# store s-registers on stack
	sw	$s1, -12($fp)

###################################################################################

	jal fileinput
	move $s0, $v0				# pointer to text: s0
	
	li $t0, 0				# counter to count width
	move $t1, $s0				# get adress of text in $t1
	lw $t3, newline				# load newline char in t3
getwidth:
	lb $t2, 0($t1)				# load char in t2
	beq $t2, $t3, widthfound		# jump to widthfound if newline
	addi $t0, $t0, 1			# width + 1			
	add $t1, $s0, $t0			# increment adress with 1
	j getwidth
widthfound:	
	move $a2, $t0				# set width in $a2
	li $t0, 0				#reset counter to 0
	move $t1, $s0				# set $t1 to string adress
getheight:
	lb $t2, ($t1)				# load char
	beq $t2, $t3, newlinefound		# jump to newlinefound (counter +1) and jump back
loop:
	beq $t2, $zero, stringended		# if end of string: exit loop
	addi $t1, $t1, 1
	j getheight	

newlinefound:
	addi $t0, $t0, 1
	j loop
	 
stringended:
	move $a3, $t0				# load height in $a3
	
#UPDATE PIXELS IN BITMAP
	move $t0, $s0				# pointer to text: $t0
	lb $t4,	blauw				# blue text in $t4
	li $t1, 0				# x counter
	li $t2, 0				# y counter
	lb $t5, newline
loop2:						#a2: maxwidth	
	lw $a0, $t1
	lw $a1, $t2
	jal logicaltomem			#$v0 -> adres
	lb $t3, ($t0)
	beq $t3, $t4, setpixelblauw
loop2end:
	addi $t1, 1				# x counter + 1
	add $t0, $s0, $t1			# update pointer to char to next char
	lb $t3, ($t0)				# load char in t3
	beq $t3, $t5, newlinefound		# if char == '\n' goto: newlinefound
setpixelblauw:
	lw $a0, $v0				# load adress in a0
	li $a1, 1				# load 1 in a1 (blauw)
	jal updatepixel				# updatepixel
	
newlinefound:


####################################################################################
# set framepointer back
	lw	$s1, -12($fp)			# load s-registers from stack
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)			# get right return address 
	move 	$sp, $fp			# stackpointer -> framepointer
	lw	$fp, 0($sp)			# restore old framepointer
	jr	$ra
	
	