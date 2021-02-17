	.text
	.globl	main
main:
	li	$v0,4    # print msg1
	la	$a0,msg1
	syscall
	
	li	$v0,5	#  input n
	syscall
	move	$t1,$v0 # t1 = n

	li	$v0,4    # print msg2
	la	$a0,msg2
	syscall

	li	$v0,5
	syscall
	move	$t2,$v0		# $t2 = p

	li	$v0,4    # print msg3
	la	$a0,msg3
	syscall

	li	$v0,5
	syscall
	move	$t3,$v0		# t3 = q

	move	$t4,$t3		# t4 = t3 = q

	li		$t7,0 		# $t7 =0 
	

loop:
	beq	$t1,1,exit


	li	$v0,4    # print msg2
	la	$a0,msg2
	syscall

	li	$v0,5
	syscall
	move	$t5,$v0		# $t5 = a

	li	$v0,4    # print msg3
	la	$a0,msg3
	syscall

	li	$v0,5
	syscall
	move	$t6,$v0		# t6 = b

	beq		$t6, $t4, equal	# if $t6 == $t4 then equal	
	bne		$t6, $t4, notEqual	# if $t6 != $t4 then notEqual

	move 	$t2, $t5		# $t2 = $t5
	move 	$t3, $t6		# $t3 = $t6

	subi	$t1, $t1, 1			# $t1 = $t1 - 1


equal:
	blt		$t4, $t6, target	# if $t4 < $t6 then target
target:
	move 	$t4, $t6		# $t4 = $t6
notEqual:
	# calc area with $t4
	
	move 	$t4, $t6		# $t7 = $t6



	

exit:
	li	$v0,10
	syscall
	.data
msg1:	.asciiz	"n: "
# msg2:	.asciiz	"(X,Y) co­ordinates sorted according to X co­ordinate: "
msg2:	.asciiz "Enter x coordinate"
msg3:	.asciiz "Enter y coordinates"