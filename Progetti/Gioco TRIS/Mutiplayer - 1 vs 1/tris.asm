.data
 s_spacer:		.asciiz "\n"
 gameTable:		.asciiz "   1   2   3 \n1    |   |   \n  ---+---+---\n2    |   |   \n  ---+---+---\n3    |   |   \n"
	
 X: 				.asciiz "X"
 O: 				.asciiz "O"

 s_init:			.asciiz "Select the game mode:\n1. 1 vs 1\n2. Human vs Computer\n0. Turn off\n"
 s_move:			.asciiz "Player   enter your choice [ RowColumn ]: "				
 s_invalid_move:	.asciiz "INVALID MOVE! Plese, choose a valid input.\n"
 s_won:			.asciiz "Player   Won! Congratulations!!\n"						
 s_tie:			.asciiz "It's a tie!\n"
 
 s_move_x:		.asciiz "Player X enter your choice [ RowColumn ]: "
 
 
.text
#.globl 
init:
	jal reset
	
	# stampo inizializzazione
	#li $v0, 4
	#la $a0, s_init
	#syscall
 
	# leggo scelta
	#li $v0, 5	 
	#syscall
	
	#beq $v0, 1, dual_player 
	#beq $v0, 2, single_player
	#beqz $v0, exit
	#j init
	

dual_player:
main: 
	# Loading things
	la $s1, gameTable						
	lb $s2, X								
	lb $s3, O
	la $s6, s_move
	la $s7, s_won								

	jal print_gameTable
 
move_x:
	addi $s4, $s4, 1					# $s4 universal move counter ++
 
 	jal spacer
 
 	li $s5, 1						# $s5 identify the player. 1: player X						
 	sb $s2, 7($s6)
 	
 	li $v0, 4
 	la $a0, s_move
 	syscall
 	
 	j read
 
move_o:
	addi $s4, $s4, 1					# $s4 universal move counter ++
 
 	jal spacer
 
 	li $s5, 0						# $s5 identify the player. 1: player X						
 	sb $s3, 7($s6)
 	
 	li $v0, 4
 	la $a0, s_move
 	syscall
 	
 	j read
 	
read:
	# Reading the move
	li $v0, 5	 
	syscall	
 
	move $s0, $v0					# $s0 : current selected cell
	
	jal spacer
	
	# Go to the cell to put the sign 
	beq $s0, 11, cell_11
 	beq $s0, 12, cell_12
 	beq $s0, 13, cell_13
 	beq $s0, 21, cell_21
 	beq $s0, 22, cell_22
 	beq $s0, 23, cell_23
	beq $s0, 31, cell_31
  	beq $s0, 32, cell_32
 	beq $s0, 33, cell_33
 	# else print an error for 'invalid move'
 	j err_invalid_move
 	
cell_11:
	# if not empty, re-do the move
	bnez $t1, err_invalid_move
	
   	# identifying the player 
  	beqz $s5, O11
  
 	sb $s2, 17($s1)
  	li $t1, 1							# Setting the cell 11 as 1 (occupied with x)
  
  	jal print_gameTable
  
 	j checkXvictory  
    
    
  O11:
	sb $s3, 17($s1)
	li $t1, 4							# Setting the cell 11 as 4 (occupied with O)
   
	jal print_gameTable
   
	j checkOvictory 
   
   
   
cell_12: 
	# if not empty, re-do the move
	bnez $t2, err_invalid_move
	
	# identifying the player
	beqz $s5, O12
   
	sb $s2, 21($s1)
	li $t2, 1							# Setting the cell 12 as 1 (occupied with x)
  
	jal print_gameTable
  
	j checkXvictory  
    
    
 O12:   
    sb $s3, 21($s1)
    li $t2, 4						# Setting the cell 12 as 4 (occupied with O)
   
    jal print_gameTable
   
    j checkOvictory
    
    
    
cell_13:
	# if not empty, re-do the move
	bnez $t3, err_invalid_move
	
	# identifying the player
	beqz $s5, O13
   
	sb $s2, 25($s1)
	li $t3, 1							# Setting the cell 13 as 1 (occupied with x)
  
	jal print_gameTable
  
	j checkXvictory  
    
    
 O13:
    sb $s3, 25($s1)
    li $t3, 4						# Setting the cell 13 as 4 (occupied with O)
   
    jal print_gameTable
   
    j checkOvictory

   
   
cell_21:
	# if not empty, re-do the move
	bnez $t4, err_invalid_move
	
   # identifying the player
   beqz $s5, O21
   
   sb $s2, 45($s1)
   li $t4, 1							# Setting the cell 21 as 1 (occupied with x)
  
   jal print_gameTable
  
   j checkXvictory  
    
    
 O21:   
    sb $s3, 45($s1)
    li $t4, 4						# Setting the cell 21 as 4 (occupied with O)
   
    jal print_gameTable
   
	j checkOvictory
   
   
   
cell_22:
	# if not empty, re-do the move
	bnez $t5, err_invalid_move
	
	# identifying the player
	beqz $s5, O22
   
	sb $s2, 49($s1)
	li $t5, 1							# Setting the cell 22 as 1 (occupied with x)
  
	jal print_gameTable
  
	j checkXvictory  
    
    
 O22:    
    sb $s3, 49($s1)
    li $t5, 4						# Setting the cell 22 as 4 (occupied with O)
   
    jal print_gameTable
   
    j checkOvictory



cell_23:
	# if not empty, re-do the move
	bnez $t6, err_invalid_move
	
	# identifying the player
	beqz $s5, O23
   
	sb $s2, 53($s1)
	li $t6, 1							# Setting the cell 23 as 1 (occupied with x)
  
	jal print_gameTable
   
	j checkXvictory  
    
    
 O23:   
    sb $s3, 53($s1)
    li $t6, 4						# Setting the cell 23 as 4 (occupied with O)
   
    jal print_gameTable
   
    j checkOvictory


cell_31:
	# if not empty, re-do the move
	bnez $t7, err_invalid_move
	
	# identifying the player
	beqz $s5, O31
   
	sb $s2, 73($s1)
	li $t7, 1							# Setting the cell 31 as 1 (occupied with x)
  
	jal print_gameTable
  
	j checkXvictory 
    
    
 O31:
    sb $s3, 73($s1)
    li $t7, 4						# Setting the cell 31 as 4 (occupied with O)
    
    jal print_gameTable
    
    j checkOvictory
   


cell_32:
	# if not empty, re-do the move
	bnez $t8, err_invalid_move
	
	# identifying the player
	beqz $s5, O32
   
	sb $s2, 77($s1)
	li $t8, 1							# Setting the cell 32 as 1 (occupied with x)
  
	jal print_gameTable
  
	j checkXvictory 
    
    
 O32:
    sb $s3, 77($s1)
    li $t8, 4						# Setting the cell 32 as 4 (occupied with O)
   
    jal print_gameTable
   
    j checkOvictory
   
   
   
cell_33:
	# if not empty, re-do the move
	bnez $t9, err_invalid_move

	# identifying the player
	beqz $s5, O33
   
	sb $s2, 81($s1)
	li $t9, 1							# Setting the cell 33 as 1 (occupied with x)
  
	jal print_gameTable
  
	j checkXvictory
    
    
 O33:   
    sb $s3, 81($s1)
    li $t9, 4						# Setting the cell 33 as 4 (occupied with O)
   
    jal print_gameTable
   
    j checkOvictory
    


checkXvictory:
	# :: checking rows ::
	# row: 123
	li $t0, 0					# reset the sum-counter
	addu $t0, $t1, $t2
	addu $t0, $t0, $t3
	beq $t0, 3, x_won
  
	# row: 456
	li $t0, 0					
	addu $t0, $t4, $t5
	addu $t0, $t0, $t6
	beq $t0, 3, x_won
  
	# row: 789
	li $t0, 0				
	addu $t0, $t7, $t8
	addu $t0, $t0, $t9
	beq $t0, 3, x_won
  
  
	# :: checking cols ::
	# col: 147
	li $t0, 0					
	addu $t0, $t1, $t4
	addu $t0, $t0, $t7
	beq $t0, 3, x_won
  
	# col: 258
	li $t0, 0					
	addu $t0, $t2, $t5
	addu $t0, $t0, $t8
	beq $t0, 3, x_won
  
	# col: 369
	li $t0, 0				
	addu $t0, $t3, $t6
	addu $t0, $t0, $t9
	beq $t0, 3, x_won
  
  
	# :: checking diags ::
	# diag: 159
  	li $t0, 0				
  	addu $t0, $t1, $t5
  	addu $t0, $t0, $t9
  	beq $t0, 3, x_won
  
	#diag: 357
	li $t0, 0					
	addu $t0, $t3, $t5
	addu $t0, $t0, $t7
	beq $t0, 3, x_won
  
	# :: tie check ::
	beq $s4, 9, tie
  
	j move_o
  
  
checkOvictory:
	# :: checking rows ::
	# row: 123
	li $t0, 0					# reset the sum-counter
	addu $t0, $t1, $t2
	addu $t0, $t0, $t3
	beq $t0, 12, o_won
  
	# row: 456
	li $t0, 0					
	addu $t0, $t4, $t5
	addu $t0, $t0, $t6
	beq $t0, 12, o_won
  
	# row: 789
	li $t0, 0					
	addu $t0, $t7, $t8
	addu $t0, $t0, $t9
	beq $t0, 12, o_won
  
  
	# :: checking cols ::
	# col: 147
	li $t0, 0					
	addu $t0, $t1, $t4
	addu $t0, $t0, $t7
	beq $t0, 12, o_won
  
	# col: 258
	li $t0, 0				
	addu $t0, $t2, $t5
	addu $t0, $t0, $t8
	beq $t0, 12, o_won
  
	# col: 369
	li $t0, 0					
	addu $t0, $t3, $t6
	addu $t0, $t0, $t9
	beq $t0, 12, o_won
  
  
	# :: checking diags ::
	# diag: 159
	li $t0, 0					
	addu $t0, $t1, $t5
	addu $t0, $t0, $t9
	beq $t0, 12, o_won
  
	# diag: 357
	li $t0, 0					
	addu $t0, $t3, $t5
	addu $t0, $t0, $t7
	beq $t0, 12, o_won
  
	# :: tie check ::
	beq $s4, 9, tie
  
	j move_x
 
 
x_won:
	jal spacer
  
	sb $s2, 7($s7)
	li $v0, 4
	la $a0, s_won
	syscall
	j exit
  
  
o_won:
	jal spacer
  
	sb $s3, 7($s7)
	li $v0, 4
	la $a0, s_won
	syscall
	j exit
  
  
tie:
	jal spacer
  
	li $v0, 4
	la $a0, s_tie
	syscall
	j exit
  
  

# Prints an error due an invalid move, then go back
err_invalid_move:
	li $v0, 4
	la $a0, s_invalid_move
	syscall
  
	# Checking who made this invalid move
	beqz $s5, o_invalid
	j move_x
  
	o_invalid:
		j move_o

spacer:
	li $v0, 4
	la $a0, s_spacer
	syscall
	jr $ra
	
print_gameTable:
	li $v0, 4
	la $a0, gameTable
	syscall
	jr $ra

reset:
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
  
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
  
  	jr $ra
	
	
# Terminates execution
exit:					
	li $v0, 10			
	syscall
