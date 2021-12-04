.data

#fin:	.asciiz		"./MIPS/projectmips/maze.txt"

.globl buildmaze

newline:	.byte	'\n'
wall:		.byte	'w'
exit:		.byte   'u'
.text

buildmaze:
###################################################################################
#	CHANGE FRAMEPOINTER
	sw	$fp, 0($sp)			# save old framepointer
	move	$fp, $sp			# framepointer -> top of stack
	subu	$sp, $sp, 24			# Allocate 3 words on stack (16 bytes)
	sw	$ra, -4($fp)			# store return address on stack
	sw	$s0, -8($fp)			# store s-registers on stack
	sw	$s1, -12($fp)
	sw 	$s2, -16($fp)
	sw	$s3, -20($fp)
	sw	$s4, -24($fp)
	sw	$s5, -28($fp)
###################################################################################

	jal fileinput
	move $s0, $v0				# pointer to text: s0
	
	li $t0, 0				# counter to count width
	move $t1, $s0				# get adress of text in $t1
	lb $t3, newline				# load newline char in t3
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
	move $s3, $s0				# pointer to text: $s3
	li $s4, 0				# x counter
	li $s5, 0				# y counter
loop2:
	lb $t4,	wall				# blue text in $t4
	lb $t5, newline				# '\n' in $t5
	lb $t6, exit						
	move $a0, $s4				#a2: maxwidth	
	move $a1, $s5
	jal logicaltomem			#$v0 -> adres
	lb $t3, ($s3)
	beq $t3, $t4, setpixelblauw
	beq $t3, $t6, setpixelyellow
loop2end:
	addi $s4, $s4, 1			# x counter + 1
	addi $s3, $s3, 1			# update pointer to char to next char
	lb $t3, ($s3)				# load char in t3
	lb $t5, newline
	beq $t3, $t5, newlinefound2		# if char == '\n' goto: newlinefound
	j loop2
setpixelblauw:
	move $a0, $v0				# load adress in a0
	li $a1, 1				# load 1 in a1 (blauw)
	jal updatepixel
	j loop2end				# updatepixel and finish loop
	
setpixelyellow:
	move $a0, $v0				# load adress in a0
	li $a1, 2				#load 2 in a1 (yellow)
	jal updatepixel				#update pixel and finish loop
	j loop2end	
newlinefound2:
	li $s4, 0
	addi $s3, $s3, 1
	addi, $s5, $s5, 1
	beq $s5, $a3, bitmapfull
	j loop2
	
bitmapfull:


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
	
	
