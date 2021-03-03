# Sommare i numeri di un vettore
# (anche sommare solo posizioni pari/dispari)

.data 0x10010402
	vettore:		.word 1,1000, -100, 400, -1000
	fine_dati:

.text 	
	lw $t0, vettore 		# first word loaded
	
	la $s0, fine_dati	
	la $t1, vettore		# used for the loop-end condition
	
	li $t2, 0			# int i
	li $t3, 0			# int sum
	li $t4, 0			# array index (to point next word: 0-4-8...)
	
	for_loop:
	# USO QUESTE SE HO ESPLICITA LA LUNGHEZZA DELL'ARRAY
	#sltiu $t7, $t2, 5			# array length
	#beq $t7, $0, loop_end		# loop-end condition
	
	# ALTRIMENTI USO QUESTO DICHIARANDO 'FINE_DATI:'
	addu $t5, $t2, $t1		# t5 = i + [data-address]
	beq $t5, $s0, loop_end	# loop-end condition: t5 == [fine-dati address]
	
	add $t3, $t3, $t0			# sum
	
	addiu $t4, $t4, 8			# +4 (next word ready)
								# PUT 8 TO SUM ONLY EVENS
								
	lw $t0, vettore($t4) 		# next word loaded
	addiu $t2, $t2, 1			#i++
	
	j for_loop
	
loop_end:
	li $v0, 10
	syscall
