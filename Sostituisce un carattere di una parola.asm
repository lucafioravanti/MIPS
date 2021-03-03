# Data una parola, carico un carattere da cercare in s0
# e lo sostituisco con un altro carattere caricato in s1
.data
	parola:	.space 100
	
.data 0x10010100
	ins:		.asciiz "Inserisci parola: "

.text
	# input e salvataggio stringa
	li $v0, 4
    la $a0, ins
    syscall
    li $v0, 8
    la $a0, parola
    li $a1, 101
    syscall
    
    # carattere da cercare:
    li $s0, 0x63	# c
    # lo voglio sostituire con:
  	li $s1, 0x61	# a
    
    # esempio: ciao -> aiao 
      
    la $t0, parola
  
    loop:
		lbu $t1, ($t0)		# carico in t1 il carattere di parola
		
		beq $t1, $s0, cambiaCar
		
		addiu $t0, $t0, 1	# punto al prossimo	
		beqz $t1, end		# se finita la parola, termina
		j loop
		
	cambiaCar:
		# devo cambiarlo alla posizione indirizzo + var_iterazione
		sb $s1, ($t0)
		
		addiu $t0, $t0, 1	# punto al prossimo
		j loop
		
	end:
		li $v0, 10
		syscall
		
