##
#
# - Calcolo dell'indice di massa corporea (IMC)
# 	basato sul piu' recente algoritmo sviluppato da ricercatori della Oxford University.
#
# 	https://people.maths.ox.ac.uk/trefethen/bmi.html
# 
# - Formula per il calcolo 
#	IMC = ( 1.3 * peso[kg] / altezza[m]^(2.5) ) 
# 
# - Registri utilizzati:
# 	s0  :  peso
# 	f1  :  k
# 	f2  :  peso(float)
# 	f3  :  k * peso (numeratore)
# 	f4  :  h^5
# 	f5  :  sqrt(h^5) (denominatore)
# 	f6  :  IMC = num/den
# 	f7  :  lim. inf.
# 	f8  :  lim. sup.
#   f10 :  altezza
#
##

.data	
	k:				.float	1.3			# costante moltiplicativa
	lim_inf:			.float	18.5			# limite inferiore: IMC < 18.5 => sottopeso 
	lim_sup:			.float	25.0			# limite superiore: IMC > 25   => sovrappeso 
	
	s_ins_p:			.asciiz	"Inserisci il peso [kg]: "		
	s_ins_h:			.asciiz	"Inserisci l'altezza [m]: "		
	s_ris_num:		.asciiz	"\nSulla base del nuovo indice IMC, il tuo punteggio e': "
	s_ris_str:		.asciiz	"\novvero viene considerato come "

	s_sottopeso:		.asciiz "sottopeso.\n"
	s_sovrappeso:	.asciiz "sovrappeso.\n"
	s_pesoOk	:		.asciiz "in salute.\n"
	
.text 
.globl main

main:
	# chiedo di inserire il peso
	li	$v0, 4			# carico il codice per scrivere una stringa (cod. 4 in v0)	
	la 	$a0, s_ins_p		# carico come argomento l'indirizzo della stringa da stampare (argomento in a0)
	syscall				# eseguo l'operazione

	# leggo il peso
	li $v0, 5			# carico il codice per leggere un intero (cod. 5 in v0) 
	syscall				

	move $s0, $v0		# sposto il peso letto in s0. 

	# chiedo di inserire l'altezza
	li	$v0, 4				
	la	$a0, s_ins_h	
	syscall				

	# leggo l'altezza
	li $v0, 6			
	syscall				

	mov.s $f10, $f0	 	# sposto l'altezza in f10. (syscall restituisce in $f0)
	

	# ..... START calcolo IMC .....

	# Numeratore: k * peso
	l.s $f1, k			# carico la costante in un registro in virgola mobile

	# Devo svolgere una moltiplicazione tra k(float) e peso(int) => converto peso in float
	mtc1 $s0, $f2		# sposto il peso in un registro a virgola mobile
	cvt.s.w $f2, $f2 	# converto il valore del peso in float

	mul.s $f3,$f1,$f2	# moltiplico k * peso
	
	# Denominatore: h^(2.5) = h^(5/2) = sqrt(h^5)	
	mov.s $f4, $f10	 	# copio il valore dell'altezza: $f4 = altezza = $f10. mi serve per la moltiplicazione
	
	# eseguo h^5:
	li $t0, 0			# condizione iniziale ciclo: t0 = i = 0

	exp:		
		slti $t1, $t0, 4				# t1 = 1 se t0 < 4
		beq $t1, $0, exp_done		# condizione fine ciclo

		mul.s $f4, $f4, $f10			# eseguo la moltiplicazione 

		addi $t0, $t0, 1			 	# incremento
		j exp						# salto per successivo giro


exp_done:
	sqrt.s $f5, $f4		# $f5 = sqrt(f4)

	div.s $f6, $f3, $f5	# f6 = IMC = num/den = f3/f5

	# ..... END calcolo IMC .....
	
	
	# stampo la stringa per il risultato numerico
	li	$v0, 4		
	la 	$a0, s_ris_num
	syscall				

	# stampo l'indice IMC
	li $v0, 2			# stampa di un float (codice 2)
	mov.s $f12, $f6		# passo (tramite f12) alla syscall il numero da stampare
	syscall

	# stampo la stringa per il risultato in stringa 
	li	$v0, 4				
	la 	$a0, s_ris_str	
	syscall		
	
# ....................................................................................................................

	# classifico il peso tramite switch-case
	
	# carico le due costanti di confronto
	l.s $f7, lim_inf			
	l.s $f8, lim_sup

	c.le.s $f6, $f7
	bc1t case0
	c.le.s $f6, $f8
	bc1f case1
	b case2
	
	case0: #sottopeso
	li	$v0, 4							
	la 	$a0, s_sottopeso				
	syscall
	j exit
	
	case1: #sovrappeso
	li	$v0, 4							
	la 	$a0, s_sovrappeso			
	syscall	
	j exit
	
	case2: #pesoOk
	li	$v0, 4								
	la 	$a0, s_pesoOk					
	syscall		
	j exit
			

exit:
	li	$v0, 10			# termino il programma ed esco
	syscall
