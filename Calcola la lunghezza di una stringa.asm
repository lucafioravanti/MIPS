# Calcolare quanto e' lunga una stringa.
# Risultato in s0

.data
	parola:	.asciiz "ciao"	

.text	
	 la $t0, parola				
	 
loop:
	lbu $t1, 0($t0)	
	
	addiu $s0 $s0 1				# conto numero di caratteri
	 
	addiu $t0, $t0, 1			# punto il prossimo carattere
	beqz $t1, end               	# branch if = 0 : se la stringa è finita => salta a end 
	j loop
	
	
	
end: 
	addi $s0 $s0 -1				# tolgo \n
	li $v0, 10					# termino l'esecuzione
    syscall
