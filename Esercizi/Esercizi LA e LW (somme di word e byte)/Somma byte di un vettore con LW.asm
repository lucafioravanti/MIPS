.data 0x10010402
	vettore: 
		.byte 5, 4, 100, 3	
	fine_dati:
	
.text 	
	la $t8, vettore		# USATA PER LA CONDIZIONE DI FINE AREA DATI (FINE VETTORE, SENZA LUNGHEZZA ESPLICITA)
	
	lb $t0, vettore 		# first word loaded
	la $s0, fine_dati
	
	li $t3, 0			# int sum
	li $t4, 0			# array index
	
	for_loop:
	# USO QUESTE SE HO ESPLICITA LA LUNGHEZZA DELL'ARRAY
	#sltiu $t7, $t2, 4			# array length
	#beq $t7, $0, loop_end		# loop-end condition
	
	# ALTRIMENTI USO QUESTO DICHIARANDO 'FINE_DATI:'
	addu $t9, $t4, $t8		# t9 = index + [data-address]
	beq $t9, $s0, loop_end	# loop-end condition: t9 == [fine-dati address]
	
	add $t3, $t3, $t0			# sum
	
	addiu $t4, $t4, 1			# next byte
	lb $t0, vettore($t4) 		# next byte loaded
	
	j for_loop
	
loop_end:
	li $v0, 10
	syscall
