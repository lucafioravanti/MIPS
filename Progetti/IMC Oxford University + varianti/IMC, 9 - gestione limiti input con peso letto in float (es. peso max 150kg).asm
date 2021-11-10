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
# 	f1  :  k
# 	f2  :  peso
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
	
	limPeso:			.float	150.0
	s_errp:			.asciiz "Errore: superato massimo valore inseribile."
	
.text 
.globl main

main:
	# chiedo di inserire il peso
	li	$v0, 4			# carico il codice per scrivere una stringa (cod. 4 in v0)	
	la 	$a0, s_ins_p		# carico come argomento l'indirizzo della stringa da stampare (argomento in a0)
	syscall				# eseguo l'operazione

	# leggo il peso
	li $v0, 6			# carico il codice per leggere un float (cod. 6 in v0)
	syscall				

	mov.s $f2, $f0		# sposto il peso letto in f2.
	
	 ### Controllo che il peso non superi il massimo inseribile di 150
	 
	 l.s $f20, limPeso
	 c.le.s $f2, $f20
	 bc1t continue
	 j ERRP
	 
	 continue:
	 ### Fine controllo 

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

	# carico le due costanti di confronto
	l.s $f7, lim_inf			
	l.s $f8, lim_sup			

	# primo confronto. Se positivo salto a sottopeso
	c.le.s $f6, $f7 		# confronto
	bc1t sottopeso 		# salta se f6 <= f7 cioe' se IMC <= 18.5

	# secondo confronto. Se positivo salto a sovrappeso
	c.le.s $f6, $f8 		# confronto
	bc1f sovrappeso 		# salta se f6 <= f8 e' falso cioe' se IMC >= 25.0

	# altrimenti, stampo pesoOK
	li	$v0, 4								
	la 	$a0, s_pesoOk					
	syscall		
	
	j exit

	sottopeso:
		li	$v0, 4							
		la 	$a0, s_sottopeso				
		syscall
		j exit

	sovrappeso:
		li	$v0, 4							
		la 	$a0, s_sovrappeso			
		syscall	
		j exit
		
ERRP:
	li	$v0, 4			# carico il codice per scrivere una stringa (cod. 4 in v0)	
	la 	$a0, s_errp		# carico come argomento l'indirizzo della stringa da stampare (argomento in a0)
	syscall				# eseguo l'operazione

exit:
	li	$v0, 10			# termino il programma ed esco
	syscall
