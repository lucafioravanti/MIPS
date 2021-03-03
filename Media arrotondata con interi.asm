# Dati quattro numeri calcolare la media arrotondata all'intero piu vicino
# es 1: 30, 30, 29, 30 risultato: 30
# es 2: 29, 29, 29, 30 risultato: 29

.data
	dati: .byte 30, 30, 29, 30 			# risultato: 30
	#dati: .byte 29, 29, 29, 30 			# risultato: 29
fine_dati:

.text
	la	$s0, dati
	la	$s1, fine_dati
	
	li	$s2, 0			# int avg
	li	$t0, 0			# int i

ciclo:	
	addu $t1, $t0, $s0	# t1 = t0 + s0 = i + [dati address]
	beq $t1, $s1, end	# loop-end condition : t1 == [dati address]
	
	lb $t2, ($t1)		# loading item
	addu $s2, $s2, $t2	# sum 

	addiu $t0, $t0, 1	# i++
	j ciclo

end:
	# --- Andando in virgola mobile: 
	# mtc1 $s2, $f0			# sum in f0
	# mtc1 $t0, $f1			# i in f1
	#
	# cvt.s.w $f0, $f0		# sum in floating point
	# cvt.s.w $f1, $f1		# i in floating point
	#
	# div.s $f0, $f0, $f1	
	#
	# round.w.s $f5, $f0		# rounding...
	# cvt.s.w $f5, $f5
	
	# --- sfrutto la matematica:
	#	resto/divisore > 0.5
	#	2*resto > divisore
	#
	# moltiplico per 2 il resto -> tramite sll
	# e lo paragono alla "i" che e'¨il divisore -> tramite slt e bnq
	#
	# se e'¨ maggiore, arrotondo per eccesso
	# altrimenti lascio cosi
	
	divu $s2, $s2, $t0
	mfhi $s6
	sll $s6, $s6, 1
	slt $s5, $s6, $t0
	bne $s5, $0, esci 
	addiu $s2, $s2, 1
	
esci:
	li $v0, 10
	syscall
