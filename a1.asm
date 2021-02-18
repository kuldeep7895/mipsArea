	.text
	.globl	main
main:
	li	$v0,4	# print n:""
	la	$a0,msg1
	syscall
	
	li	$v0,5	# scan(n)
	syscall
	move	$t1,$v0		# $t1 = v0 = n;


	li	$v0,4	# print X coordinate
	la	$a0,msg2
	syscall
	
	li	$v0,5	# scan(p)
	syscall
	move	$t2,$v0		# $t2 = v0 = p;

	li	$v0,4	# print Y coordinate
	la	$a0,msg3
	syscall
	
	li	$v0,5	# scan(q)
	syscall
	move	$t3,$v0		# $t3 = v0 = q;

	move 	$t4, $t3		# $t4 = $t3 = max
 	
#	mtc1	$t1,$f1		# t1 to f1   =  n
#	cvt.s.w	$f1,$f1		#convert

	mtc1	$t2,$f2		# t2 to f2    = p
	cvt.s.w	$f2,$f2		#convert

	mtc1	$t3,$f3		# t3 to f3   = q
	cvt.s.w	$f3,$f3		#convert

	mtc1	$t4,$f4		# t4 to f4   = max
	cvt.s.w	$f4,$f4		#convert 
	
	li	$t7,0			# $t7 = 0 = area
	mtc1	$t7,$f12		# t7 to f12   = area
	cvt.s.w	$f12,$f12		#convert
	
loop:	
	bne	$t1,1,done	# $t1!=1
	
	li	$v0,4	# print X coordinate
	la	$a0,msg2
	syscall
	
	li	$v0,5	# scan(a)
	syscall
	move	$t5,$v0		# $t5 = v0 = a;

	li	$v0,4	# print Y coordinate
	la	$a0,msg3
	syscall
	
	li	$v0,5	# scan(b)
	syscall
	move	$t6,$v0		# $t6 = v0 = b;
	
	mtc1	$t5,$f5		# t5 to f5    = a
	cvt.s.w	$f5,$f5		#convert

	mtc1	$t6,$f6		# t6 to f6   = b
	cvt.s.w	$f6,$f6		#convert

	bne	$f5,$f2,unequal
		blt	$f6,0.0,cond1	# (b<0)
		blt	$f4,0.0,cond1	# $ (max<0)
		add.s	$f7,$f4,$f6	# ($f7 = b+max)
		sub.s	$f9,$f5,$f2	# ($f9 = a-p)
		mul.s	$f9,$f9,$f7	# ($f9 = $f9*$7)
		muls.	$f9,$f9,0.5	# ($f9 = $f9*0.5)
		add.s	$f12,$f12,$f9	# (area  = area + $f9)
		move	$f4,$f6	# max = b
		j	next
		cond1:
			bgt $f6,0.0,cond2	#(b>0)
			bgt $f4,0.0,cond2	#(max>0)
			add.s	$f7,$f4,$f6	# ($f7 = b+max)
			sub.s	$f9,$f5,$f2	# ($f9 = a-p)
			mul.s	$f9,$f9,$f7	# ($f9 = $f9*$7)
			muls.	$f9,$f9,0.5	# ($f9 = $f9*0.5)
			sub.s	$f12,$f12,$f9	# (area  = area - $f9)
			move	$f4,$f6	# max = b
			j	next
			cond2:
				bgt $f6,0.0,cond3	#(b>0)
				blt	$f4,0.0,cond3	# $ (max<0)
				sub.s	$f7,$f4,$f6	# ($f7 = max-b)
				sub.s	$f9,$f5,$f2	# ($f9 = a-p)
				mul.s	$f10,$f6,$f6	# ($f6 = max sq)
				mul.s	$f11,$f4,$f4	# ($f4 = b*b)
				add.s	$f12,$12,$f11	# (area = area+$f11)
				move	$f4,$f6	# max = b
				j	next
				cond3:
					sub.s	$f7,$f4,$f6	# ($f7 = max-b)
					sub.s	$f9,$f5,$f2	# ($f9 = a-p)
					mul.s	$f10,$f6,$f6	# ($f6 = max sq)
					mul.s	$f11,$f4,$f4	# ($f4 = b*b)
					sub.s	$f12,$12,$f11	# (area = area-$f11)
					move	$f4,$f6	# max = b
					j	next
		j	next
	unequal:
		blt	$f4,0.0,cond4	# $ (max<0)
		bgt	$f4,$f6,cond4	# $ (max>b)
		move	$f4,$f6	# max = b
		j	next
		cond4:
			bgt	$f4,0.0,cond4	# $ (max<0)
			blt	$f4,$f6,cond4	# $ (max>b)
			move	$f4,$f6	# max = b
			j	next
	next:
		
		move	$f2,$f5	#(p = a)
		move	$f3,$f6	#(q = b)
		subi	$t1,$t1,1	# $t1 = $t1-1
		j	loop
	done:
	
	li	$v0,10
	syscall
	.data
msg1:	.asciiz	"n: "
msg2:	.asciiz	"X coordinate"
msg3:	.asciiz	"Y coordinates"
