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
    
    # controllo lunghezza parola
    la $a0, parola		
    jal strlen			
    move $s0, $v0										# s0 = lunghezza parola
    
testPalindroma:
	la $t0, parola
	addu $t8, $t0, $s0		# t8 = parola + lunghezza_parola (punto alla fine)
	addiu $t8, $t8, -1		# tolgo il fine riga
	
	loop:
		lbu $t1, ($t0)		# carico primo carattere
		lbu $t9, ($t8)		# carico ultimo carattere
		
		addiu $t0, $t0, 1	# carattere iniziale ++
		addiu $t8, $t8, -1	# carattere finale --
		addi $t3, $t3, 1		# i++
		
		bne $t1, $t9, nonPalindroma
		beq $t3, $s0, palindroma
		j loop
	
palindroma:
	li $s5, 555		# s5 = 999 => non palindroma
    	li $v0, 10
    	syscall

nonPalindroma:
	li $s5, 999		# s5 = 999 => non palindroma
    li $v0, 10
    syscall
		
		 
		   
strlen:
	# resetting $t1	to remove the last end-of-string character (\n)
    li $t0, -1
    
    loop_strlen:
        lbu $t1, 0($a0)
        beqz $t1, strlen_done
        # count ++	
        addi $t0, $t0, 1
        # next char
        addiu $a0, $a0, 1
        j loop_strlen
        
    strlen_done:
        move $v0, $t0
        jr $ra