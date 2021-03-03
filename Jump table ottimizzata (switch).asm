.data
	# definisco un'area dati con 'n' word con i nomi dei casi.
	tab_ind:	.word c0, c1
	
.text	
	la $t0, tab_ind
	li $t1, 1			# rappresenta il k di prova su cui saltare "switch (k)"
	
	sll $t1, $t1, 2		# k * 4
	addu $t0, $t0, $t1	# trovo l'indirizzo di salto, dato il k
	lw $t2, ($t0)		# legge a che indirizzo andare 
	jr $t2				# raggiungo tale indirizzo
 
c0:	nop
	j c0
	
c1:	nop
	j c1
