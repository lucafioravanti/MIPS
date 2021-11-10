
#	f1: amt of substance [g]
#	f2: molar mass [g/mol]
#	f3: number of moles
#	f5: k
#	f4: number of particles found
.data
	k:			.float 602214076000000000000000.0
	s_isamt:		.asciiz "Enter the amount of substance [g]: "
	s_imm:		.asciiz "Enter the molar mass [g/mol]: "
	s_par:		.asciiz "Number of particles found: "
	
.text
	# Instert the amount of substance
	li	$v0, 4				
	la 	$a0, s_isamt		
	syscall		
	# Read and store the value into $f1
	li $v0, 6			
	syscall	
	mov.s $f1, $f0
	# Insert the molar mass
	li	$v0, 4				
	la 	$a0, s_imm		
	syscall
	# Read and store the value into $f2
	li $v0, 6			
	syscall	
	mov.s $f2, $f0
	l.s $f5, k	
	
	# Number of moles
	div.s $f3, $f1, $f2
	
	# Number of particles contained in that quantity of substance
	mul.s $f4, $f3, $f5
	
	# Print the number of particles found
	li	$v0, 4								
	la 	$a0, s_par					
	syscall	
	li $v0, 2
	mov.s $f12, $f4		
	syscall
	