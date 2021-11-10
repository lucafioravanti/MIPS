#max(n) = 12

.data 
		input:	.asciiz "Inserisci il numero n per il quale effettuare il calcolo fattoriale: "
		output:	.asciiz "! = "
		errore:	.asciiz "valore troppo elevato. Massimo valore calcolabile: 12."


.text
		# stampo stringa input
		la $a0, input				
		li $v0, 4
		syscall
		
		# lettura numero
		li $v0, 5					 
		syscall
		
		# Controllo 1 <= n <= 12
		slti $t0, $v0, 1			# n < 1 ?
		bne $t0, $zero, exit
		
		slti $t0, $v0, 13		# n > 13 ?
		beq $t0, $zero, exit
		
		
		move $a0, $v0			# sposto n
		move $t9, $v0				
		
		# riporto "n! = " con il reale valore di n
		li $v0, 1
		syscall

fatt:     
		addi $sp, $sp, -8			# aggiundo allo stack n e $ra
		sw $ra, 4($sp)
		sw $a0, 0($sp)
		
		slti $t0, $a0, 1      		# conrollo se n < 1: 			$a0 = n      
		beq $t0, $zero, subfatt		# $t0 = 0 => goto: subfatt
		
		
		addi $v0, $zero, 1			# $v0 = 1
		addi $sp, $sp, 8				# aggiorno stack
		jr $ra
			
			
			
subfatt:  
		addi $a0, $a0, -1			# aggiorno: $a0 = $a0 - 1
		jal fatt
		
		
		lw $a0, 0($sp)				# ripristino
		lw $ra, 4($sp)	
		addi	 $sp, $sp, 8
		
		mul	$v0, $a0, $v0			# eseguo conto
		addi $t8, $t8, 1
		
		slt $t1, $t8, $t9
		beq $t1, $zero, s_ris		
		
		jr $ra
		
		
s_ris:							# riport il risultato
		move $t2, $v0
		la $a0, output
		li $v0, 4
		syscall
		
		move $a0, $t2
		li $v0, 1
		syscall
		j end
		
exit:
	la $a0, errore				# stampo stringa errore
	li $v0, 4
	syscall
	
	
	
	
end:
	li	$v0, 10					# termino ed esco
	syscall
	
	
