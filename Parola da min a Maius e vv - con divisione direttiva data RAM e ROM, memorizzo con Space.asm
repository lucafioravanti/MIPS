# andi: m -> M e resta maiuscola se lo e' gia
# ori $t1, $t1, 0x20		 M -> m

.data 0x10010000
	nome:	.space 20		# 20 bytes

.data 0x10010020
	s_nome:	.asciiz "Inserisci nome: "

.text
	# stampo la stringa che chiede di inserire il nome
	la $a0, s_nome
	li $v0, 4
	syscall

	# recupero l'input e lo salvo
	li $v0, 8 
	la $a0, nome 		# carico lo spazio in byte nell'indirizzo
	li $a1, 20			# max lung string
	move $t5,$a0 		# salvo in t5
	syscall

	# rimuovo il "newline" dall'input
	li $t5 -1
	ciclo:	
		addi $t5 $t5 1
		lbu $t6 nome($t5)
		bne $t6 0xA ciclo
		sb $zero nome($t5)

	la $t0, nome			# punto alla parola de rendere maiuscola
	 
loop:
	lbu $t1, 0($t0)				# recupero il singolo carattere
	 
	andi $t1, $t1, 0xffffffdf	# forzo a maiuscolo
	sb $t1, ($t0)				# salvo
	
	addiu $t0, $t0, 1			# punto il prossimo carattere
	beqz $t1, end               	# branch if = 0 : se la stringa è finita => salta a end 
	j loop


end:
