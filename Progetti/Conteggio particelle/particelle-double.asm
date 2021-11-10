
#	f2-3: amt of substance [g]
#	f4-5: molar mass [g/mol]
#	f6-7: number of moles
#	f8-9: k
#	f10-11: number of particles found
.data
	k:			.double 602214076000000000000000.0
	s_isamt:		.asciiz "Enter the amount of substance [g]: "
	s_imm:		.asciiz "Enter the molar mass [g/mol]: "
	s_par:		.asciiz "Number of particles found: "
	
.text
	# Instert the amount of substance
	li	$v0, 4				
	la 	$a0, s_isamt		
	syscall		
	# Read and store the value into $f2-3
	li $v0, 7			
	syscall	
	mov.d $f2, $f0
	# Insert the molar mass
	li	$v0, 4				
	la 	$a0, s_imm		
	syscall
	# Read and store the value into $f4-5
	li $v0, 7			
	syscall	
	mov.d $f4, $f0
	
	l.d $f8, k	
	
	# Number of moles
	div.d $f6, $f2, $f4
	
	# Number of particles contained in that quantity of substance
	mul.d $f10, $f6, $f8
	
	# Print the number of particles found
	li	$v0, 4								
	la 	$a0, s_par					
	syscall	
	li $v0, 3
	mov.d $f12, $f10
	syscall
	