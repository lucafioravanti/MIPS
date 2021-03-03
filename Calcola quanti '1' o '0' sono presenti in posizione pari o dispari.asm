# Caricato con LI un valore in un registro,
# calcolare quanti bit di peso '1' sono presenti nelle posizioni pari
# 
# esempio: 0x55555555 = 0101 0101 0101 0101 0101 0101 0101 0101 => n = 0
# esempio: 0xaaaaaaaa = 1010 1010 1010 1010 1010 1010 1010 1010 => n = 16

.text
	li $t0, 0x55555555		
	li $t1, 0x00000002		## se voglio contare nelle pos. dispari metto 1
							## se voglio contare nelle pos. pari metto 2
							
loop:
	and $t2, $t0, $t1		# AND = mascheratura, nasconde i bit. Esce 1 solo con 1-1 in ingresso.		
	bne $t2, $zero, uno		# controllo se and ha dato risultato positivo e salto
	j zero

uno:
	addi $s0, $s0, 1

zero:
	sll $t1, $t1, 2			# scorro di due posizioni per controllare il prossimo bit
	slti $s1, $s2, 15		# s1 = 1 se ho finito
	addi $s2, $s2, 1			# incremento ciclo
	bne $s1, $zero, loop		# se non ho finito, faccio nuovo ciclo
	
	li $v0, 10
	syscall

# in s0 ho il risultato.





## se voglio contare gli zeri,
##
## loop:
## 	and $t2, $t0, $t1	
## 	beq $t2, $zero, zero
##	j uno
##
##	e invero i nomi delle etichette sotto
