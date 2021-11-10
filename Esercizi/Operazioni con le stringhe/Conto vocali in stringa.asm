.data 
	ins_inp:	.asciiz "Inserisci parola: "
	vowels:	.asciiz "aeiou"

.data 0x10010100
	parola:	.space 100
		
.text 
    li	$v0, 4
    la	$a0, ins_inp
    syscall
    li	$v0, 8
    la	$a0, parola
    li	$a1, 100
    syscall
    
    la	$s0, parola
    
    # $s2: contatore vocali

word_loop:	
    lbu     $t0, 0($s0)				# recupero il singolo carattere
    addiu   $s0, $s0, 1				# aggiorno il puntatore al prossimo carattere
    beqz    $t0, end 				# ultimo carattere => esci
    #ori		$t0, $t0, 0x20			# porto tutto in minuscolo
	
	la		$s1, vowels				# punto al vettore vocali
vowel_loop:
	lbu     $t1, 0($s1)				# recupero la vocale con la quale testo
    beqz    $t1, word_loop			# se non ho piu vocali => proseguo con altro carattere in word_loop
    addiu   $s1, $s1, 1				# punto alla prossima vocale
    beq     $t0, $t1, c_v			# carattere = vocale => contatore_vocale ++
    j 		vowel_loop

c_v:	
	addiu   $s2, $s2, 1
	j		word_loop
	

end:
	li 		$v0, 10
	syscall
	
