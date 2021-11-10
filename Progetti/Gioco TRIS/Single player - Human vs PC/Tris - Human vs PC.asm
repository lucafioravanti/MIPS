#.data
 spacer:			.asciiz "\n"
 gameTable:		.asciiz "   1   2   3 \n1    |   |   \n  ---+---+---\n2    |   |   \n  ---+---+---\n3    |   |   \n"
	
 X: 				.asciiz "X"
 O: 				.asciiz "O"

 s_move_x:		.asciiz "Player X, enter your choice [ RowColumn ]: "
	
 s_invalid_move:	.asciiz " INVALID MOVE! Plese, choose a valid input.\n"
	
 s_x_won:		.asciiz "You WIN! Congratulations!!\n"
 s_o_won:		.asciiz "Computer Won\n"
 s_tie:			.asciiz "It's a tie!\n"

 
.text
.globl main

main: 
 # O = computer
 # X = human
 # Human first move.
  
  # Loading things
  la $s1, gameTable						
  lb $s2, X								
  lb $s3, O								

  # Print gametable
  li $v0, 4
  la $a0, gameTable
  syscall
  
  # Human's first move (as player x)
  
  play_X:
   addi $s4, $s4, 1					# $s4 universal move counter ++
 
   # Spacer
   li $v0, 4
   la $a0, spacer
   syscall
  
   li $v0, 4
   la $a0, s_move_x
   syscall
   j read
	
		
  play_O:
   addi $s4, $s4, 1					# $s4 universal move counter ++
    
   # METTE IL SEGNO NELLA PRIMA CELLA LIBERA CHE TROVA
   bnez $t1, c12
   # (altrimenti) metto il segno in t1
   sb $s3, 17($s1)
   li $t1, 4
   
   # Print gametable
   li $v0, 4
   la $a0, gameTable
   syscall
   
   j play_X
   
   c12:
    bnez $t2, c13
    # metto il segno
    sb $s3, 21($s1)
    li $t2, 4
    
    # Print gametable
    li $v0, 4
    la $a0, gameTable
    syscall
    
    j play_X
   
   c13:
   	bnez $t3, c21
   	# metto il segno
    sb $s3, 25($s1)
    li $t3, 4
    
    # Print gametable
    li $v0, 4
    la $a0, gameTable
    syscall
    
    j play_X
   
   c21:
   	bnez $t4, c22
   	# metto il segno
    sb $s3, 45($s1)
    li $t4, 4
    
    # Print gametable
    li $v0, 4
    la $a0, gameTable
    syscall
    
    j play_X
   
   c22:
   	bnez $t5, c23
   	# metto il segno
    sb $s3, 49($s1)
    li $t5, 4
    
    # Print gametable
    li $v0, 4
    la $a0, gameTable
    syscall
    
    j play_X
   
   c23:
    bnez $t6, c31
    # metto il segno
    sb $s3, 53($s1)
    li $t6, 4
    
    # Print gametable
    li $v0, 4
    la $a0, gameTable
    syscall
    
    j play_X
   
   c31:
    bnez $t7, c32
    # metto il segno
    sb $s3, 73($s1)
    li $t7, 4
    
    # Print gametable
    li $v0, 4
    la $a0, gameTable
    syscall
    
    j play_X
   
   c32:
    bnez $t8, c33
    # metto il segno
    sb $s3, 77($s1)
    li $t8, 4
    
    # Print gametable
    li $v0, 4
    la $a0, gameTable
    syscall
    
    j play_X
   
   c33:
    bnez $t9, tie
    # metto il segno
    sb $s3, 81($s1)
    li $t9, 4
    
    # Print gametable
    li $v0, 4
    la $a0, gameTable
    syscall
    
    j play_X
   
   
  read:
  # Reading the move
  li $v0, 5	 
  syscall	
 
  move $s0, $v0						# $s0 : current selected cell
 
  # Spacer
  li $v0, 4
  la $a0, spacer
  syscall
 
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
  bnez $t1, play_X
  
  sb $s2, 17($s1)
  li $t1, 1							# Setting the cell 11 as 1 (occupied with x)
  
  # Print gametable
  li $v0, 4
  la $a0, gameTable
  syscall
  
  # Spacer
  li $v0, 4
  la $a0, spacer
  syscall
  
  j checkXvictory  
    
     
  cell_12: 
   # if not empty, re-do the move
   bnez $t2, play_X
   
   sb $s2, 21($s1)
   li $t2, 1							# Setting the cell 12 as 1 (occupied with x)
  
   # Print gametable
   li $v0, 4
   la $a0, gameTable
   syscall
   
   # Spacer
   li $v0, 4
   la $a0, spacer
   syscall
   
   j checkXvictory  
    
    
  cell_13:
   # if not empty, re-do the move
   bnez $t3, play_X
   
   sb $s2, 25($s1)
   li $t3, 1							# Setting the cell 13 as 1 (occupied with x)
  
   # Print gametable
   li $v0, 4
   la $a0, gameTable
   syscall
   
   # Spacer
   li $v0, 4
   la $a0, spacer
   syscall
  
   j checkXvictory  
   

  cell_21:
   # if not empty, re-do the move
   bnez $t4, play_X
   
   sb $s2, 45($s1)
   li $t4, 1							# Setting the cell 21 as 1 (occupied with x)
  
   # Print gametable
   li $v0, 4
   la $a0, gameTable
   syscall
   
   # Spacer
   li $v0, 4
   la $a0, spacer
   syscall
  
   j checkXvictory  
   
   
  cell_22:
   # if not empty, re-do the move
   bnez $t5, play_X
   
   sb $s2, 49($s1)
   li $t5, 1							# Setting the cell 22 as 1 (occupied with x)
  
   # Print gametable
   li $v0, 4
   la $a0, gameTable
   syscall
   
   # Spacer
   li $v0, 4
   la $a0, spacer
   syscall
  
   j checkXvictory  
    
    
  cell_23:
   # if not empty, re-do the move
   bnez $t6, play_X
   
   sb $s2, 53($s1)
   li $t6, 1							# Setting the cell 23 as 1 (occupied with x)
  
   # Print gametable
   li $v0, 4
   la $a0, gameTable
   syscall
   
   # Spacer
   li $v0, 4
   la $a0, spacer
   syscall
   
   j checkXvictory  
    
    
  cell_31:
   # if not empty, re-do the move
   bnez $t7, play_X
   
   sb $s2, 73($s1)
   li $t7, 1							# Setting the cell 31 as 1 (occupied with x)
  
   # Print gametable
   li $v0, 4
   la $a0, gameTable
   syscall
   
   # Spacer
   li $v0, 4
   la $a0, spacer
   syscall
  
   j checkXvictory 
    
    
  cell_32:
   # if not empty, re-do the move
   bnez $t8, play_X
   
   sb $s2, 77($s1)
   li $t8, 1							# Setting the cell 32 as 1 (occupied with x)
  
   # Print gametable
   li $v0, 4
   la $a0, gameTable
   syscall
   
   # Spacer
   li $v0, 4
   la $a0, spacer
   syscall
  
   j checkXvictory 
    
    
  cell_33:
   # if not empty, re-do the move
   bnez $t9, play_X
   
   sb $s2, 81($s1)
   li $t9, 1							# Setting the cell 33 as 1 (occupied with x)
  
   # Print gametable
   li $v0, 4
   la $a0, gameTable
   syscall
   
   # Spacer
   li $v0, 4
   la $a0, spacer
   syscall
  
   j checkXvictory




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
  
  j play_O
  
  
 checkOvictory:
  # :: checking rows ::
  # row: 123
  li $t0, 0					# resetting the sum-counter
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
  
  j play_X
 
 
 x_won:
  # Spacer
  li $v0, 4
  la $a0, spacer
  syscall
  
  li $v0, 4
  la $a0, s_x_won
  syscall
  j exit
  
  
 o_won:
  # Spacer
  li $v0, 4
  la $a0, spacer
  syscall
  
  li $v0, 4
  la $a0, s_o_won
  syscall
  j exit
  
  
  tie:
  # Spacer
  li $v0, 4
  la $a0, spacer
  syscall
  
  li $v0, 4
  la $a0, s_tie
  syscall
  j exit
  
 
 
 ##
 # Reset the registers
 ##
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
  
 ##
 # Prints an error due an invalid move, then exit
 ##
 err_invalid_move:
  li $v0, 4
  la $a0, s_invalid_move
  syscall
  
  # Checking who made this invalid move
  beqz $s5, o_invalid
  j play_X
  
  o_invalid:
   j play_O

 ##
 # Terminates execution
 ##
 exit:					
  li	$v0, 10			
  syscall
