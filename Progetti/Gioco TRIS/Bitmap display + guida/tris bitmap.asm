.data 	
	s_move_x:			.asciiz "Player X, enter your move: "
	s_move_o:			.asciiz "Player O, enter your move: "
	
	s_won_x:				.asciiz "Player X Won! Congratulations!!\n"	
	s_won_o:				.asciiz "Player O Won! Congratulations!!\n"	
	s_tie:				.asciiz "It's a tie!\n"
	
	s_invalid_move:		.asciiz "INVALID MOVE! Please, choose a valid input.\n"
		
.text
main:
	# initial settings
	li $s1, 0x7DBEFF				# s1: color
	
	jal print_gameTable
	
	# getting t-registers ready
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
	
move_x:
	addi $s4, $s4, 1					# $s4 universal move counter ++
 	li $s5, 1						# $s5 identify the player. 1: player X						
	# printing string
 	li $v0, 4
 	la $a0, s_move_x
 	syscall
 	
 	j read
 	
move_o:
	addi $s4, $s4, 1					# $s4 universal move counter ++
 	li $s5, 0						# $s5 identify the player. 0: player O						
 	# printing string
 	li $v0, 4
 	la $a0, s_move_o
 	syscall
 	
 	j read
 
read:
	# Reading the move
	li $v0, 5	 
	syscall	
	move $s0, $v0					# $s0 : current selected cell
	
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
  	
 	j print_x_11
 	
 	O11:
	j print_o_11  
	
	print_x_11:
		jal push
		
		# getting position	
		li $t0, 0x10010000
	
		# maring-left
		addi $t0, $t0, 120		# game table is 112
	
		# margin-top
		li $t3, 20				# game table is 10
		li $t4, 1024
		mult $t3, $t4
		mflo $t5
		add $t0, $t0, $t5
		
		li $a0, 120				# passing the the starting position
		jal draw_x
		jal pop
		li $t1, 1							# Setting the cell 11 as 1 (occupied with x)
  		j checkXvictory 
		
	print_o_11:
		# due the complexity to shape a circle, I'm going to draw a square
		jal push 
		
		# getting position
		li $t0, 0x10010000
	
		# maring-left
		addi $t0, $t0, 120		# game table is 112
	
		# margin-top
		li $t3, 20				# game table is 10
		li $t4, 1024
		mult $t3, $t4
		mflo $t5
		add $t0, $t0, $t5
		
		jal draw_o		
		jal pop
		li $t1, 4				# Setting the cell 11 as 1 (occupied with o)
		j checkOvictory 
		
			
cell_12:
	# if not empty, re-do the move
	bnez $t2, err_invalid_move
   	# identifying the player 
  	beqz $s5, O12
 	j print_x_12 
 	
 	O12:
	j print_o_12 
	
	print_x_12:
		jal push
		
		# getting position	
		li $t0, 0x10010000
	
		# maring-left
		addi $t0, $t0, 428		# cell 12 position: 120 + 308 <- initial pos. + offset
	
		# margin-top
		li $t3, 20				# game table is 10
		li $t4, 1024
		mult $t3, $t4
		mflo $t5
		add $t0, $t0, $t5
		
		li $a0, 428				# passing the offset from the starting position
		jal draw_x
		jal pop
		li $t2, 1				# Setting the cell 11 as 1 (occupied with x)
  		j checkXvictory
		
	print_o_12:
		# due the complexity to shape a circle, I'm going to draw a square
		jal push 
		
		# getting position
		li $t0, 0x10010000
	
		# maring-left
		addi $t0, $t0, 428		# cell 12 position
	
		# margin-top
		li $t3, 20				# game table is 10
		li $t4, 1024
		mult $t3, $t4
		mflo $t5
		add $t0, $t0, $t5
		
		jal draw_o		
		jal pop
		li $t2, 4							# Setting the cell 11 as 4 (occupied with o)
		j checkOvictory 


cell_13:

cell_21:
cell_22:
cell_23:

cell_31:
cell_32:
cell_33:

push:
	addi $sp, $sp, -24
	sw $t0, 20($sp) 
	sw $t1, 16($sp)
	sw $t2, 12($sp)  
	sw $t3, 8($sp) 
	sw $t4, 4($sp)
	sw $t5, 0($sp) 
	jr $ra

pop:
	lw $t0, 20($sp) 
	lw $t1, 16($sp)
	lw $t2, 12($sp)  
	lw $t3, 8($sp) 
	lw $t4, 4($sp)
	lw $t5, 0($sp) 
	addi $sp, $sp, 24
	jr $ra
	
draw_x:
	# resetting counter
	li $t1, 0
		
	xbs1:
	addi $t0, $t0, 1024		# whole display line
	addi $t0, $t0, 4			# increment 1 word
	sw $s1, 0($t0)			# color
		
	# length counter
	addi $t1, $t1, 1
	bne $t1, 40, xbs1
		
	# preparing for the next line
	li $t0, 0x10010000
	# resetting counter
	li $t1, 0
	
	# maring-left
	add $t0, $t0, $a0		# game table is 112  
		
	# margin-top
	li $t3, 60				# previuos value + line length
	li $t4, 1024
	mult $t3, $t4
	mflo $t5
	add $t0, $t0, $t5
		
	xbs2:
	sub $t0, $t0, 1024		# whole display line, sub to go up
	addi $t0, $t0, 4			# increment 1 word
	sw $s1, 0($t0)			# color
		
	# length counter
	addi $t1, $t1, 1
	bne $t1, 40, xbs2

	jr $ra
	
draw_o:	
	l1:
	sw $s1, 0($t0)
	addi $t0, $t0, 4 			# add a word (as next pixel in display)
	addi $t1, $t1, 1				# counter
	bne $t1, 40, l1
	li $t1, 0					# counter reset for the next loop
		
	l2:
	sw $s1, 0($t0)
	addi $t0, $t0, 1024  		# 1024 to draw vertical
	addi $t1, $t1, 1
	bne $t1, 40, l2			
	li $t1, 0					# counter reset for the next loop
		
	l3:
	sw $s1, 0($t0)	
	subi $t0, $t0, 4 			# add a word (as next pixel in display)	
	addi $t1, $t1, 1				# counter
	bne $t1, 40, l3
	li $t1, 0					# counter reset for the next loop

	l4:		
	sw $s1, 0($t0)
	subi $t0, $t0, 1024  		# 1024 to draw vertical	
	addi $t1, $t1, 1
	bne $t1, 40, l4				# vertical line length
	jr $ra
	
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


err_invalid_move:
	li $v0, 4
	la $a0, s_invalid_move
	syscall
  
	# Checking who made this invalid move
	beqz $s5, o_invalid
	j move_x
  
	o_invalid:
		j move_o
	
	
print_gameTable:

	# bitmap base address
	li $t0, 0x10010000
	
	# setting the margin-left space
	addi $t0, $t0, 112
	
	# setting margin-top space
	# length of a display line
	li $t5, 1024
	# margin-top to have the space for the first three cells 
	li $t6, 84
	
	# getting the desired position on the display as 1024 * 84
	# here I have to repeat to print the color for 200 times
	mult $t5, $t6
	mflo $t6
	add $t0, $t0, $t6

	# length counter (for the next line-loop)
	li $t1, 0
	
gt_hor:
	# essentially it's a "print command"
	sw $s1, 0($t0)
	
	# incrementing register with one word (next pixel in display)
	addi $t0, $t0, 4 
	
	# incrementing and checking length counter
	addi $t1, $t1, 1
	bne $t1, 200, gt_hor
	# if it's the second line, fly to vertical_lines
	beq $t3, 2, vertical_lines
	
	
	# preparing for the next line
	li $t0, 0x10010000
	addi $t0, $t0, 112	
	li $t5, 1024
	li $t6, 168			# doubled the value than before
	mult $t5, $t6
	mflo $t6
	add $t0, $t0, $t6
	
	# length counter (for the nex line-loop)
	li $t1, 0
	# warning that it is the second line
	li $t3, 2
	j gt_hor
	
vertical_lines:

	# resetting the line counter (first vertical line) 
	li $t3, 0	

	li $t0, 0x10010000
	
	# setting margin-top space
	li $t6, 10
	mult $t5, $t6		# t5 is still 1024
	mflo $t6	
	add $t0, $t0, $t6	# vertical - 10

	# margin-left
	addi $t0, $t0, 336	# 84 * 4

	li $t1, 0
	
gt_ver:
	sw $s1, 0($t0)
	
	addi $t0, $t0, 1024  	# 1024 to draw vertical
	
	addi $t1, $t1, 1
	bne $t1, 220, gt_ver		# vertical line length
	# if it's the second line, fly to gt_end
	beq $t3, 2, gt_end
	
	
	# preparing for the next line
	li $t0, 0x10010000
	
	# horizontal shift is doubled: (84 * 4) * 2
	addi $t0, $t0, 672
	# counter reset
	li $t1, 0
	# margin-top
	li $t6, 10
	mult $t5, $t6
	mflo $t6
	add $t0, $t0, $t6
	
	# warning that it is the second line
	li $t3, 2
	j gt_ver

gt_end:
	jr $ra
	
x_won:  
	li $v0, 4
	la $a0, s_won_x
	syscall
	j exit
  
  
o_won:
	li $v0, 4
	la $a0, s_won_o
	syscall
	j exit
  
  
tie:
	li $v0, 4
	la $a0, s_tie
	syscall
	j exit
	
exit:					
	li $v0, 10			
	syscall
