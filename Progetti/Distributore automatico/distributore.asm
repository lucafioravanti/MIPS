.data
	s_init:			.asciiz "*** Inizializzazione distributore ***\n"
	s_spacer:		.asciiz "\n"
	
	#iterazione utente
	s_ins_mon:		.asciiz "Inserisci moneta: \n"
	s_rit_prod:		.asciiz "\nRitira prodotto: "
	s_rit_rest:		.asciiz "\nRitira resto: " 
	s_prod_fin:		.asciiz "Prodotto terminato.\n"
	s_costo:			.asciiz "Costo prodotto: "
	
	#iterazione operatore
	s_insNumProd:	.asciiz "Quanti prodotti inserire? [max 5]"
	s_ins_prod:		.asciiz "Inserisci nuovo prodotto: "
	s_ins_qta:		.asciiz "Inserisci quantità prodotto: [max 10 cassetti] "
	s_ins_prezzo:	.asciiz "Inserisci prezzo: "
	s_opz_op:		.asciiz "0. Menu operatore\n"
	s_menu_op:		.asciiz "0. Indietro\n1. Riempi distributore\n2. Cambia prodotti\n3. Spegni distibutore"
	
	jump_table:		.word L0, L1, L2, L3

	# Costanti di arrotondamento
	zero:			.float 0.0
	costPos:			.float 0.5
	vm100:			.float 100.0

	.align 2
	array:			.space  20
	size:			.word   100
	string:			.space  20
	

.text
init:
	# inizializzazione macchina
	li $v0,4
    la $a0, s_init
    syscall
    jal spacer

	# chiedo quanti prodotti inserire
    li $v0,4
    la $a0, s_insNumProd
    syscall

	# salvo in t9
    li $v0, 5
    syscall
    bgt $v0, 5, init
    move $t9,$v0			# t9: lunghezza array
    
    # impostazioni preliminari
    li $t0, 0			# t0: indice array prodotto
    li $t1, 1        	# t1: contatore 
    la $s6, string		# s6: indirizzo della stringa dove salvare

leggi_prod:
    bgt $t1, $t9, stampa_menu         # inizializzazione completata -> stampa menu

    jal spacer

    # chiedo inserimento prodotto
    li $v0, 4
    la $a0, s_ins_prod
    syscall

    # salvo la stringa
    move $a0, $s6             # dove salvo
    li $a1, 20
    li $v0, 8
    syscall
    sw $a0, array($t0)
    
    # inserimento di quantita' e prezzo del prodotto inserito
    beq $t1, 1, ins_p1
 	beq $t1, 2, ins_p2
 	beq $t1, 3, ins_p3
 	beq $t1, 4, ins_p4
 	beq $t1, 5, ins_p5
 	j aggiorna_contatori

ins_p1:
	jal chiedo_qta
	move $s1, $v0			# sposto la quantita nel registro s corrispondente		
	
	jal chiedo_prezzo
	mov.s $f1, $f0			# sposto il prezzo nel registro f corrispondente	
	j aggiorna_contatori

ins_p2:
	jal chiedo_qta
	move $s2, $v0					
	
	jal chiedo_prezzo
	mov.s $f2, $f0				
	j aggiorna_contatori

ins_p3:
	jal chiedo_qta
	move $s3, $v0					
	
	jal chiedo_prezzo
	mov.s $f3, $f0				
	j aggiorna_contatori

ins_p4:
	jal chiedo_qta
	move $s4, $v0					
	
	jal chiedo_prezzo
	mov.s $f4, $f0				
	j aggiorna_contatori

ins_p5:
	jal chiedo_qta
	move $s5, $v0					
	
	jal chiedo_prezzo
	mov.s $f5, $f0				
	j aggiorna_contatori

chiedo_qta:
	li $v0,4
   	la $a0, s_ins_qta
   	syscall  		
    	
    # leggo
    li $v0, 5			 
	syscall
	bgt $v0, 10, chiedo_qta
	jr $ra

chiedo_prezzo:
	li $v0,4
	la $a0, s_ins_prezzo
   	syscall
    	
    # leggo 
    li $v0, 6			 
	syscall
	jr $ra

aggiorna_contatori:
    addi $t0, $t0, 4           # offset + 4
    addi $t1, $t1, 1           # i++ (contatore array)
    addi $s6, $s6, 20          # preparo lo spazio per la prossima stringa 

    j leggi_prod

stampa_menu:
	li $t0, 0     			# resetto indice array
    li $t1, 1 				# reimposto contatore i++ addi $t1, $zero, 1   

while:
    bgt $t1, $t9, leggi_selezionato 	# $t1 > t9 => menu stampato -> go to  leggi_selezionato
    lw $t2, array($t0)	# recupero la stringa 

    # stampo la stringa
    li $v0, 4
    move $a0, $t2
    syscall

	# aggiorno i contatori
    addi $t0, $t0, 4           # offset + 4
    addi $t1, $t1, 1           # i++
    
    j while

leggi_selezionato:
	# riporto il menu operatore
	li $v0, 4
 	la $a0, s_opz_op
 	syscall
 	 
 	# leggo scelta
	li $v0, 5	 
	syscall
	
	move $s7, $v0

	beqz $s7, menu_operatore 
	
	# salvo in $f10 il costo del prodotto scelto e aggiorno quantità
	beq $v0, 1, scp1
	beq $v0, 2, scp2
	beq $v0, 3, scp3
	beq $v0, 4, scp4
	beq $v0, 5, scp5
	j stampa_menu
 
scp1:
 	# recupero prezzo salvo in f10, diminuisco qta di 1
	beqz $s1, prod_fin 
	addi $s1, $s1, -1
	mov.s $f10, $f1 
	# recupero scelta per erogazione prodotto
	li $t1, 0
	lw $t2, array($t1)
	
	j pagamento
	
scp2:
	beqz $s2, prod_fin 
	addi $s2, $s2, -1
	mov.s $f10, $f2 
	li $t1, 4
	lw $t2, array($t1)
	j pagamento
	
scp3:
	beqz $s3, prod_fin 
	addi $s3, $s3, -1
	mov.s $f10, $f3
	li $t1, 8
	lw $t2, array($t1) 
	j pagamento
	
scp4:
	beqz $s4, prod_fin 
	addi $s4, $s4, -1
	mov.s $f10, $f4
	li $t1, 12
	lw $t2, array($t1) 
	j pagamento
	
scp5:
	beqz $s5, prod_fin 
	addi $s5, $s5, -1
	mov.s $f10, $f5 
	li $t1, 16
	lw $t2, array($t1)
	j pagamento 
	
menu_operatore:
	li $v0, 4
	la $a0, s_menu_op
	syscall
	
	li $v0, 5			
	syscall	

	move $s1, $v0
	
	# 0. indietro
	# 1. riempi macchina
	# 2. cambia prodotti
	# 3. spegni
	
    la $t4, jump_table
    sll $t1, $s1, 2   	   # switch su s1 
    add $t1, $t1, $t4 
    lw $t0, 0($t1)
    jr $t0

    L0: 
		j stampa_menu
		
    L1: 
        li $s1, 10
		li $s2, 10
		li $s3, 10
		li $s4, 10
		li $s5, 10
		j stampa_menu
		
    L2: 
        j init
        
    L3: 
        j turn_off
	
prod_fin:
	li $v0, 4
	la $a0, s_prod_fin
	syscall
	j stampa_menu

pagamento: 
	# azzero contatore monete
	l.s $f11, zero	
	
	# Stampo importo da pagare
	li $v0, 4
	la $a0, s_costo
	syscall
	
	# stampo prezzo prodotto selezionato
	li $v0, 2			
	mov.s $f12, $f10	
	syscall
    
    jal spacer
 
loop:
	li $v0, 4
	la $a0, s_ins_mon
	syscall
 
	# leggo import inserito
	li $v0, 6	 
 	syscall
 
	# sommo al contatore
	add.s $f11, $f0, $f11
 
	# se sono uguali ritira il prodotto e salta a inizio menu
	c.eq.s $f11, $f10
	bc1t ritira_prod
 
	# confronto
	c.le.s $f11, $f10
	bc1t loop
 
	# altrimenti devo dare la differenza di resto
	sub.s $f12, $f11, $f10
 
	# arrotondo per resto corretto
	l.s $f31, costPos	# carico la costante 
	l.s $f30, vm100	    # carico la costante 

	mul.s $f12,$f30,$f12		# moltiplico per 100.
	add.s $f12,$f12,$f31		# aggiungo 0.5 
	cvt.w.s $f12, $f12 	 	# converto da float a int
	cvt.s.w $f12, $f12 		# converto da int a float
	div.s $f12,$f12,$f30		# divido per 100
 
	# resto
	li $v0, 4
	la $a0, s_rit_rest
	syscall
 
	li $v0, 2
	syscall

ritira_prod:
	li $v0, 4
	la $a0, s_rit_prod
	syscall

	li $v0, 4
    move $a0, $t2
    syscall
    
    jal spacer
			
	j stampa_menu

spacer:
	li $v0,4
	la $a0, s_spacer
	syscall
	jr $ra
	
turn_off:
	li	$v0, 10			
	syscall
