.data
	s_nr:		.asciiz	"Numero di righe da calcolare: "	
	spaces:		.asciiz	"   "
	spacess:		.asciiz	"     "
	newline: 	.ascii	"\n"
	k:			.float 1.0

.text
main:
	# Initializing the counter
	l.s $f5, k							

	# Asking and getting the input
	li	$v0, 4							
	la 	$a0, s_nr						
	syscall
	li $v0, 5			 
	syscall				
	move $s1, $v0						

	# Rows loop: for(i = 0; i < n; ++i) { ... }
	li $t0, 0							
rowsloop:								
	slt $t3, $t0, $s1					
	beqz $t3, rowsloop_done				

	jal spaceloop_init
	jal coeffloop_init

	# Print new line
	li $v0, 4       
	la $a0, newline
	syscall

	addiu $t0, $t0, 1						
	j rowsloop							

rowsloop_done:
	j esci
	
spaceloop_init:
	# Space loop: for(space = i; space < n; space++) { ... }
	move $t2, $t0						
	
spaceloop: 
	slt $t4, $t2, $s1					
	beqz $t4, spaceloop_done				
										
	li	$v0, 4			
	la 	$a0, spaces
	syscall

	addiu $t2, $t2, 1						
	j spaceloop							

spaceloop_done:
	jr $ra


coeffloop_init:
	# coeff loop: for(j = 0; j <= i; j++)
	li $t1, 0							 
	
coeffloop:								
	sle $t5, $t1, $t0					 																
	beqz $t5, coeffloop_done			

	#if ( $t1 == 0 || $t0 == t1 )
	beqz $t1, one
	beq $t0, $t1, one
	# otherwise
	# $s2 = $s2 * (i-j+1)/j
	
	l.s $f1, k
	
	# t0->f2
	mtc1 $t0, $f2
	cvt.s.w $f2, $f2
	
	#t1->f3
	mtc1 $t1, $f3
	cvt.s.w $f3, $f3
	
	# f4 as staging
	sub.s $f4, $f2, $f3
	add.s $f4, $f4, $f1
	div.s $f4, $f4, $f3
	
	#coeff in f5
	mul.s $f5, $f5, $f4
	
	j print_num

one:
	l.s $f5, k
	j print_num

print_num:
	# printing a space
	li	$v0, 4			
	la 	$a0, spacess
	syscall
	# printing the coeff.
	li $v0, 2			
	mov.s $f12, $f5		
	syscall
								
	addiu $t1, $t1, 1					
	j coeffloop							

coeffloop_done:
	jr $ra
	
esci:

