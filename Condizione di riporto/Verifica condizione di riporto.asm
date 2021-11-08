.text:
	li $t1, 0x00000000
	li $t2, 0xf0000100
	
	# per capire quanto manca faccio il complementare con nor e zero:
	# t3 = 2^(32) - 1 -t1
	
	nor $t3, $t1, $0
	
	sltu $t3, $t3, $t2	# if (t3 < t2) {t3 = 1} ->	2^(32) - 1 - t1 <? t2
						#							2^(32) - 1 <? t2 + t1
						#							si => t3 = 1 => OK, no carry
	bne $t3, $0, carry
	addu $t0, $t1, $t2
	j esci
	
	carry:	nop
			j carry

	esci: nop
		j esci