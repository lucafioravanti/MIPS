# Dato un numero capire se e' divisibile per 4 senza fare la divisione
# restituire in t1 0 se divisibile, 1 se non lo e'

.text
	li	$t0, 18 			# se metto 32 e' divisibile => t1 = 0
	andi	$t0, $t0, 3
	sltu	$t1, $0, $t0

end: 	
	li	$v0, 10
	syscall	

