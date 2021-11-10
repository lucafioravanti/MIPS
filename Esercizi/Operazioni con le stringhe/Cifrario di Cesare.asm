.data 0x10010000
	word:		.space 20 
	enc_word:	.space 20

.data 0x10010040
	s_ins:		.asciiz "Inserisci parola: "

.text
	# stampo stringa che chiede inserimento testo
	la $a0, s_ins
	li $v0, 4
	syscall
	
	# recuero l'input e lo salvo
	li $v0, 8		
	la $a0, word		# carico indirizzo
	li $a1, 20		# max lung
	move $t0, $a0	# salvo in t0	
	syscall
	
	la $s0, word		
	la $s1, enc_word
	
loop:	
	lbu $t1, 0($s0)				# recupero il singolo carattere
	beqz $t1, end               	# branch if = 0 : se la stringa è finita => salta a end
	addiu $t1, $t1, 3			# codifico + 3
	
	#andi $t1, $t1, 0xffffffdf	# forzo a maiuscolo
	sb $t1, ($s1)				# salvo
	
	addiu $s0, $s0, 1			# punto il prossimo carattere
	addiu $s1, $s1, 1			# punto la prossima posizione dove scrive il carattere MAIUS
	  
	j loop


end:

		