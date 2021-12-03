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

.align 2
up:	.asciiz		"up\n"
.align 2
down:	.asciiz		"down\n"
.align 2
left:	.asciiz		"left\n"
.align 2
right:	.asciiz		"right\n"
.align 2
geefkarakter: .asciiz	"Geef een karakter in\n"

.text
	li $s5, 0xffff0000
	li $s6, 0xffff0004
main:
	li $t0, 1
	lw $s0, ($s5)
	beq $s0, $t0, leesin		#als 0xffff0000 == 1
	li $v0, 4
	la $a0, geefkarakter
	syscall
return:
	
	li $a0, 2000
	li $v0, 32
	syscall
	j main
	
leesin:
	lw $t1, ($s6)		#$t1 = input
	lw $t2, z		#t2 = z
	lw $t3, s		#$t3 =s
	lw $t4, q		#$t4 = q
	lw $t5, d		#$t5 = d
	lw $t6, x		#$t6 = x
	beq $t1, $t6, exit
	beq $t1, $t2, printup
	beq $t1, $t3, printdown
	beq $t1, $t4, printleft
	beq $t1, $t5, printright
	j return
	
printup:
	la $a0, up
	li $v0, 4
	syscall
	j return
	
printdown:
	la $a0, down
	li $v0, 4
	syscall
	j return
	
printleft:
	la $a0, left
	li $v0, 4
	syscall
	j return
	
printright:
	la $a0, right
	li $v0, 4
	syscall
	j return

exit:
	li $v0, 10
	syscall