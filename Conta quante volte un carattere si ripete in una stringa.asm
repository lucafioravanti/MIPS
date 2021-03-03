# Conta quante volte un carattere si ripete nella stringa

.data
	parola:	.asciiz "ciaoaa"
	char:	.ascii "a"	

.text	
	 la $t0, parola	
	 lbu $t9, char # Oppure: li $t9, 'a'		oppure: li $t9, 0x
	 61
loop:
	lbu $t1, 0($t0)	
	
	beq $t1, $t9, conta
	
	addiu $t0, $t0, 1			# punto il prossimo carattere
	beqz $t1, end               	# branch if = 0 : se la stringa è finita => salta a end 
	j loop
	
conta:
	addi $s0 $s0 1
	addiu $t0, $t0, 1			# punto il prossimo carattere
	j loop
	
end: 
	li $v0, 10
    syscall
