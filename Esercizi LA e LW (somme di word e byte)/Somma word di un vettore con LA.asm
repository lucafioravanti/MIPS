# Sommare i numeri di un vettore

.data 0x10010402
	vettore:		.word 1, 1000, -100, 400, -1000		
	fine_dati:

.text 
	la $t0, vettore
	la $s0, fine_dati

	li $t2, 0            # int i
	li $t3, 0            # int sum
	
for_loop:
	# USO QUESTE SE HO ESPLICITA LA LUNGHEZZA DELL'ARRAY
	#sltiu $t7, $t2, 4			# array length
	#beq $t7, $0, loop_end		# loop-end condition
	
	# ALTRIMENTI USO QUESTO DICHIARANDO 'FINE_DATI:'
	addu $t9, $t2, $t0		# t9 = i + [data-address]
	beq $t9, $s0, loop_end	# loop-end condition: t9 == [fine-dati address]
	
	lw $t4, ($t0)				# loading item
	add $t3, $t3, $t4			# sum
	
	addiu $t0, $t0, 4			# next word
	addiu $t2, $t2, 1			# i++
	
	j for_loop
	
loop_end:
	li $v0, 10
	syscall
