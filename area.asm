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

	move 	$t4, $t3		# $t4 = $t3 = max (max |Y| coordinate of a particular corresponding X)

	mtc1	$t2,$f2		# t2 to f2    = p (floating point of p)
	cvt.s.w	$f2,$f2		#convert

	mtc1	$t3,$f3		# t3 to f3   = q  (floating point of q)
	cvt.s.w	$f3,$f3		#convert

	mtc1	$t4,$f4		# t4 to f4   = max  (floating point of max) (max is the max of all Y from coordinates whith same P)
	cvt.s.w	$f4,$f4		#convert 
	
	li	$t7,0			# $t7 = 0 = area    (floating point of area)
	mtc1	$t7,$f13		# t7 to f13   = area
	cvt.s.w	$f13,$f13		#convert
	
	li	$s0,0			# $0 = 0 = lastArea (last min Area out of same X)
	mtc1	$s0,$f14		# $0 to f14 = lastArea
	cvt.s.w	$f14,$f14	# convert
	
	move	$s1,$t2			# $s1 = 0 = lastUniqueP    (last Unique P before same X)
	mtc1	$s1,$f16		# $s1 to f16 = lastUniqueP          
	cvt.s.w	$f16,$f16	# convert
	
	move	$s2,$t3			# $s2 = 0 = lastUniqueQ    (last Unique P before same X)
	mtc1	$s2,$f17		# $s2 to f17 = lastUniqueQ
	cvt.s.w	$f17,$f17	# convert
	
	move 	$s3, $t3		# $s3 = $t3 = min                 (min |Y| coordinate of same X)
	mtc1	$t4,$f18		# s3 to f18   = min
	cvt.s.w	$f18,$f18		#convert 
	
	l.s	$f15,half						# (Storing 0.5)
		
	l.s	$f19,one						# (Storing -1)
	
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
	
	li	$v0,1			# print min
	move	$a0,$s3
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
	cvt.s.w	$f6,$f6				#convert			(a and b are the X and Y coordinates after P and Q)

	beq	$t5,$t2,equal						#if(a!=p)
		mov.s	$f18,$f6					# min = b
		move	$s3,$t6
		mov.s	$f16,$f2					# lastUniqueP = p
		move	$s1,$t2
		mov.s	$f17,$f3					# latUniqueQ =  q
		move	$s2,$t3
		blt	$t6,0,cond1	# (b<0)		
		blt	$t4,0,cond1	# $ (max<0)		#if(max>=0 and b>=0)
		add.s	$f7,$f4,$f6	# ($f7 = max+b)	
		sub.s	$f9,$f5,$f2	# ($f9 = a-p)
		mul.s	$f9,$f9,$f7	# ($f9 = $f9*$7)
		mul.s	$f9,$f9,$f15	# ($f9 = $f9*0.5)		#f9 = ((a-p)*(b+max))*0.5
		add.s	$f13,$f13,$f9	# (area  = area + $f9)
		mov.s	$f4,$f6					# max = b
		move	$t4,$t6
		mov.s	$f14,$f9					# last area calculated and stored in f14 the last area variable or register
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
			mul.s	$f9,$f9,$f19				# last area calculated and stored in f14 the last area variable or register
			mov.s	$f14,$f9
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
				mov.s	$f14,$f11				# last area calculated and stored in f14 the last area variable or register
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
					mul.s	$f11,$f11,$f19				# last area calculated and stored in f14 the last area variable or register
					mov.s	$f14,$f11
					j	next
		j	next
	equal:									# if(a = p)
		
		blt	$t4,0,cond4	# $ (max<0)					
		bgt	$t4,$t6,cond4	# $ (max>b)					if(max<=b and max >= 0)
		mov.s	$f4,$f6							# max = b
		move	$t4,$t6
		j	next
		cond4:
			bge	$t4,0,cond5	# $ (max<0)
			blt	$t4,$t6,cond5	# $ (max>=b)
			mov.s	$f4,$f6	# max = b
			move	$t4,$t6
			j	next
			cond5:
				blt	$s3,0,cond6		
				blt	$s3,$t6,cond6		# if(min>=0 and min >= b)
				move	$s3,$t6		# min = b
				mov.s	$f18,$f6
				sub.s	$f13,$f13,$f14
				blt	$t6,0,cond11	# (b<0)		
				blt	$s2,0,cond11	# $ (max<0)		#if(lastq>=0 and b>=0)
				add.s	$f7,$f17,$f6	# ($f7 = lastq+b)	
				sub.s	$f9,$f5,$f16	# ($f9 = a-lastp)
				mul.s	$f9,$f9,$f7	# ($f9 = $f9*$7)
				mul.s	$f9,$f9,$f15	# ($f9 = $f9*0.5)		#f9 = ((a-p)*(b+max))*0.5
				add.s	$f13,$f13,$f9	# (area  = area + $f9)
				mov.s	$f14,$f9					# last area calculated and stored in f14 the last area variable or register
				j	next
				cond11:
					bgt $t6,0,cond21	#(b>0)
					bgt $s2,0,cond21	#(max>0)				# if(lastq<=0 and b<=0)
					add.s	$f7,$f17,$f6	# ($f7 = b+lastq)
					sub.s	$f9,$f5,$f16	# ($f9 = a-lastp)
					mul.s	$f9,$f9,$f7	# ($f9 = $f9*$7)
					mul.s	$f9,$f9,$f15	# ($f9 = $f9*0.5)
					sub.s	$f13,$f13,$f9	# (area  = area - $f9)			#f9 = ((a-p)*(b+max))*0.5
					mul.s	$f9,$f9,$f19				# last area calculated and stored in f14 the last area variable or register
					mov.s	$f14,$f9
					j	next
					cond21:
						bgt	$t6,0,cond31	#(b>0)
						blt	$s2,0,cond31	# $ (max<0)			# if(b<=0 and lastq>=0)
						sub.s	$f7,$f17,$f6	# ($f7 = lastq-b)
						sub.s	$f9,$f5,$f16	# ($f9 = a-lastp)
						mul.s	$f10,$f6,$f6	# ($f6 = max sq)
						mul.s	$f11,$f17,$f17	# ($f4 = b*b)
						add.s	$f11,$f11,$f10
						mul.s	$f11,$f11,$f9
						div.s	$f11,$f11,$f7
						mul.s	$f11,$f11,$f15					# $f1 = (((b*b+max^2)*(a-p))/(max-b))*0.5
						add.s	$f13,$f13,$f11	# (area = area+$f11)
						mov.s	$f14,$f11				# last area calculated and stored in f14 the last area variable or register
						j	next
						cond31:							# if(b>0 and max <0)
							sub.s	$f7,$f17,$f6	# ($f7 = max-b)
							sub.s	$f9,$f5,$f16	# ($f9 = a-p)
							mul.s	$f10,$f6,$f6	# ($f6 = max sq)
							mul.s	$f11,$f17,$f17	# ($f4 = b*b)
							add.s	$f11,$f11,$f10
							mul.s	$f11,$f11,$f9
							div.s	$f11,$f11,$f7
							mul.s	$f11,$f11,$f15				# $f1 = (((b*b+max^2)*(a-p))/(max-b))*0.5
							sub.s	$f13,$f13,$f11	# (area = area-$f11)
							mul.s	$f11,$f11,$f19				# last area calculated and stored in f14 the last area variable or register
							mov.s	$f14,$f11
							j	next
				j	next
				cond6:
					bge	$s3,0,cond7		
					bgt	$s3,$t6,cond7		# if(min<=0 and min <= b)
					move	$s3,$t6
					mov.s	$f18,$f6
					sub.s	$f13,$f13,$f14
					blt	$t6,0,cond12	# (b<0)		
					blt	$s2,0,cond12	# $ (max<0)		#if(lastq>=0 and b>=0)
					add.s	$f7,$f17,$f6	# ($f7 = max+b)	
					sub.s	$f9,$f5,$f16	# ($f9 = a-lastp)
					mul.s	$f9,$f9,$f7	# ($f9 = $f9*$7)
					mul.s	$f9,$f9,$f15	# ($f9 = $f9*0.5)		#f9 = ((a-p)*(b+max))*0.5
					add.s	$f13,$f13,$f9	# (area  = area + $f9)
					mov.s	$f14,$f9					# last area calculated and stored in f14 the last area variable or register
					j	next
					cond12:
						bgt $t6,0,cond22	#(b>0)
						bgt $s2,0,cond22	#(max>0)				# if(lastq<=0 and b<=0)
						add.s	$f7,$f17,$f6	# ($f7 = b+max)
						sub.s	$f9,$f5,$f16	# ($f9 = a-lastp)
						mul.s	$f9,$f9,$f7	# ($f9 = $f9*$7)
						mul.s	$f9,$f9,$f15	# ($f9 = $f9*0.5)
						sub.s	$f13,$f13,$f9	# (area  = area - $f9)			#f9 = ((a-p)*(b+max))*0.5
						mul.s	$f9,$f9,$f19				# last area calculated and stored in f14 the last area variable or register
						mov.s	$f14,$f9
						j	next
						cond22:
							bgt	$t6,0,cond32	#(b>0)
							blt	$s2,0,cond32	# $ (max<0)			# if(b<=0 and lastq>=0)
							sub.s	$f7,$f17,$f6	# ($f7 = max-b)
							sub.s	$f9,$f5,$f16	# ($f9 = a-lastp)
							mul.s	$f10,$f6,$f6	# ($f6 = max sq)
							mul.s	$f11,$f17,$f17	# ($f4 = b*b)
							add.s	$f11,$f11,$f10
							mul.s	$f11,$f11,$f9
							div.s	$f11,$f11,$f7
							mul.s	$f11,$f11,$f15					# $f1 = (((b*b+max^2)*(a-p))/(max-b))*0.5
							add.s	$f13,$f13,$f11	# (area = area+$f11)
							mov.s	$f14,$f11				# last area calculated and stored in f14 the last area variable or register
							j	next
							cond32:							# if(b>0 and max <0)
								sub.s	$f7,$f17,$f6	# ($f7 = max-b)
								sub.s	$f9,$f5,$f16	# ($f9 = a-p)
								mul.s	$f10,$f6,$f6	# ($f6 = max sq)
								mul.s	$f11,$f17,$f17	# ($f4 = b*b)
								add.s	$f11,$f11,$f10
								mul.s	$f11,$f11,$f9
								div.s	$f11,$f11,$f7
								mul.s	$f11,$f11,$f15				# $f1 = (((b*b+max^2)*(a-p))/(max-b))*0.5
								sub.s	$f13,$f13,$f11	# (area = area-$f11)
								mul.s	$f11,$f11,$f19				# last area calculated and stored in f14 the last area variable or register
								mov.s	$f14,$f11
								j	next
					j	next
					cond7:
						j	next
	next:
		
		mov.s	$f2,$f5	#(p = a)		new coordinates become old coordinates
		mov.s	$f3,$f6	#(q = b)
		move	$t2,$t5
		move	$t3,$t6
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
one:	.float		-1.0
