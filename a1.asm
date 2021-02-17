	.text
	.globl	main
main:
	li	$v0,4
	la	$a0,msg1
	syscall
	li	$v0,5
	syscall
	move	$t1,$v0
	
	li	$v0,10
	syscall
	.data
msg1:	.asciiz	"n: "
msg2:	.asciiz	"(X,Y) co­ordinates sorted according to X co­ordinate: "
