	.text
	.globl	main
main:
	li	$v0,4	# print n:""
	la	$a0,msg1
	syscall
	
	li	$v0,5	# take input scan(n)
	syscall
	move	$t1,$v0		# $t1 = v0 = n;

	li	$v0,4	# print : X coordinate
	la	$a0,msg2
	syscall

	li	$v0,5	# take input scan(p)
	syscall
	move	$t2,$v0		# $t2 = v0 = p;

	li	$v0,4	# print Y coordinate
	la	$a0,msg3
	syscall
	
	li	$v0,5	# take input scan(q)
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
	mtc1	$t7,$f13		# t7 to f13   = area
	cvt.s.w	$f13,$f13		#convert
	
	l.s	$f15,half
	
loop:	
	li	$v0,2			# print area
	mov.s	$f12,$f13
	syscall
	
	li	$v0,4			# print break
	la	$a0,msg4
	syscall
	
	li	$v0,1			# print max
	move	$a0,$t4
	syscall
	
	li	$v0,4			# print break
	la	$a0,msg4
	syscall
	
	beq	$t1,1,done	# $t1!=1			# while n!=1
	
	li	$v0,4						# print X coordinate	
	la	$a0,msg2
	syscall
	
	li	$v0,5						#Take input  scan(a)
	syscall
	move	$t5,$v0					# $t5 = v0 = a;

	li	$v0,4						# print Y coordinate
	la	$a0,msg3
	syscall
	
	li	$v0,5						#Take input  scan(b)
	syscall
	move	$t6,$v0					# $t6 = v0 = b;
	
	mtc1	$t5,$f5					# t5 to f5    = a
	cvt.s.w	$f5,$f5				#convert

	mtc1	$t6,$f6					# t6 to f6   = b
	cvt.s.w	$f6,$f6				#convert

	beq	$t5,$t2,unequal				#if(a!=p)
		blt	$t6,0,cond1	# (b<0)		
		blt	$t4,0,cond1	# $ (max<0)		#if(max>=0 and b>=0)
		add.s	$f7,$f4,$f6	# ($f7 = max+b)	
		sub.s	$f9,$f5,$f2	# ($f9 = a-p)
		mul.s	$f9,$f9,$f7	# ($f9 = $f9*$7)
		mul.s	$f9,$f9,$f15	# ($f9 = $f9*0.5)		#f9 = ((a-p)*(b+max))*0.5
		add.s	$f13,$f13,$f9	# (area  = area + $f9)
		mov.s	$f4,$f6					# max = b
		move	$t4,$t6
		j	next
		cond1:
			bgt $t6,0,cond2	#(b>0)
			bgt $t4,0,cond2	#(max>0)				# if(max<=0 and b<=0)
			add.s	$f7,$f4,$f6	# ($f7 = b+max)
			sub.s	$f9,$f5,$f2	# ($f9 = a-p)
			mul.s	$f9,$f9,$f7	# ($f9 = $f9*$7)
			mul.s	$f9,$f9,$f15	# ($f9 = $f9*0.5)
			sub.s	$f13,$f13,$f9	# (area  = area - $f9)			#f9 = ((a-p)*(b+max))*0.5
			mov.s	$f4,$f6	# max = b
			move	$t4,$t6
			j	next
			cond2:
				bgt	$t6,0,cond3	#(b>0)
				blt	$t4,0,cond3	# $ (max<0)			# if(b<=0 and max>=0)
				sub.s	$f7,$f4,$f6	# ($f7 = max-b)
				sub.s	$f9,$f5,$f2	# ($f9 = a-p)
				mul.s	$f10,$f6,$f6	# ($f6 = max sq)
				mul.s	$f11,$f4,$f4	# ($f4 = b*b)
				add.s	$f11,$f11,$f10
				mul.s	$f11,$f11,$f9
				div.s	$f11,$f11,$f7
				mul.s	$f11,$f11,$f15					# $f1 = (((b*b+max^2)*(a-p))/(max-b))*0.5
				add.s	$f13,$f13,$f11	# (area = area+$f11)
				mov.s	$f4,$f6	# max = b
				move	$t4,$t6
				j	next
				cond3:							# if(b>0 and max <0)
					sub.s	$f7,$f4,$f6	# ($f7 = max-b)
					sub.s	$f9,$f5,$f2	# ($f9 = a-p)
					mul.s	$f10,$f6,$f6	# ($f6 = max sq)
					mul.s	$f11,$f4,$f4	# ($f4 = b*b)
					add.s	$f11,$f11,$f10
					mul.s	$f11,$f11,$f9
					div.s	$f11,$f11,$f7
					mul.s	$f11,$f11,$f15				# $f1 = (((b*b+max^2)*(a-p))/(max-b))*0.5
					sub.s	$f13,$f13,$f11	# (area = area-$f11)	
					mov.s	$f4,$f6	# max = b
					move	$t4,$t6
					j	next
		j	next
	unequal:									# if(a = p)
		blt	$t4,0,cond4	# $ (max<0)					
		bgt	$t4,$t6,cond4	# $ (max>b)					if(max<=b and max >= 0)
		mov.s	$f4,$f6							# max = b
		move	$t4,$t6
		j	next
		cond4:
			bgt	$t4,0,cond5	# $ (max<0)
			blt	$t4,$t6,cond5	# $ (max>b)
			mov.s	$f4,$f6	# max = b
			move	$t4,$t6
			j	next
		cond5:
			j	next
	next:
		
		mov.s	$f2,$f5	#(p = a)
		mov.s	$f3,$f6	#(q = b)
		addi	$t1,$t1,-1
		j	loop
	done:
	
	li	$v0,10
	syscall
	.data
msg1:	.asciiz	"n: "
msg2:	.asciiz	"X coordinate "
msg3:	.asciiz	"Y coordinates"
msg4:	.asciiz	"\n"
half:	.float		0.5
