.text
	li $t1, 0xf0001000
	li $t2, 0xf0001000
	
	addu $t0, $t1, $t2
	
	# guardo operandi se hanno segno opposto. segno opposto => no ow
	xor $t3, $t1, $t2
	srl $t3, $t3, 31		# (slt $t3, $t3, $0)
	bnez $t3, no_ow
	
	# guardo se risultato ha segno coerente con operandi
	# (2 pos => pos. 2 neg => neg)
	xor $t3, $t0, $t1
	srl $t3, $t3, 31		# (slt $t3, $t3, $0)
	bnez $t3, ow
	
	# dopo xor invece di fare confronto posso fare srl di 31 posizioni
	# e ho zero se xor aveva zero nel msb (segni =) altrim. 1
	# col primo xor ok avere 1, col secondo no.

	ow:	nop
		j ow
	
	no_ow:	nop
			j no_ow