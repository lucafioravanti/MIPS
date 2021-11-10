# Implementation of the strstr() function that finds the first occurrence of the substring needle in the string haystack.
#
# haystack: string
# needle: substring to find
#

.data
	haystack:	.space 100
	needle:		.space 100
	output:		.space 100


.data 0x10010300
	ins_haystack:	.asciiz "Enter haystack: "	# main string
	ins_needle:		.asciiz "Enter needle: "		# string to find

.text
	# asking and retrieving the input
    li $v0, 4
    la $a0, ins_haystack
    syscall
    li $v0, 8
    la $a0, haystack
    li $a1, 100
    syscall
    li $v0, 4
    la $a0, ins_needle
    syscall
    li $v0, 8
    la $a0, needle
    li $a1, 100
    syscall
    
	# finding haystack length
    la $a0, haystack		
    jal strlen			
    move $s0, $v0										# s0 = haystack length	
	# finding needle length
    la $a0, needle
    jal strlen
    move $s1, $v0										# s1 = needle length 
    # evaluating the length difference
    sub $s3, $s0, $s1									# s3 = hay_len - need_len.	s0, s1 now resettable
    # finding substring match position
    la $a0, haystack
    la $a1, needle 
    move $a2, $s3	# $a2: length difference
    move $a3, $s1	# $a3: needle length					# s3 resettable
    jal subStringMatchPosition
    move $s0, $v0										# match position in s0
	# printing match position
    #li $v0, 1
    #move $a0, $s0
    #syscall
savingOutpuString:
	la $s1, haystack
	addu $s1, $s1, $s0
	la $s2, output
	savingLoop:
		lbu $t0, ($s1)
		# saving string
		sb $t0,($s2)
		# next position/char
		addiu $s1, $s1, 1
		addiu $s2, $s2, 1
		beqz $t0, exit
		j savingLoop
exit:
	# printing output
	li $v0, 4
    la $a0, output
    syscall
	# terminate
    li $v0, 10
    syscall
    
##
# finds the length of a string
# arguments:		
#	$a0: string address
# return value:	$t0 -> $v0
##
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
                   
##
# finds the matching position. Returning -1 if no match.
# arguments:	
#	$a0: haystack addr	
#	$a1: needle addr	 
#	$a2: length difference
#	$a3: needle length
# return value:	$t0 -> $v0
##
subStringMatchPosition:
    li $t0, 0									# outerLoop:	int i = 0
    outerLoop:
        bgt $t0, $a2, outerLoopDone				# if (i > length_difference) exit outerLoop => no match found
        
        li $t1, 0 								# innterLoop: int j = 0
        innerLoop:
            bge $t1, $a3, innerLoopDone			# if (j >= needle_length) exit innerLoop => outer++ || if j(inner) == needle_len => exit all -> found
            add $t3, $t0, $t1	# t3 = i + j
            addu $t4, $a0, $t3	# t4 = haystack addr + (i+j)
            lbu $t3, ($t4) 		# => t3 = haystack[i+j] 

            addu $t4, $a1, $t1	# t4 = needle addr + j
            lbu $t4, ($t4)		# => t4 = needle[j]
            
            bne $t3, $t4, continueOuterLoop		# if (haystack[i+j] != needle[j]) => continueOuterLoop	
            addi $t1, $t1, 1		# j(inner)++
            j innerLoop
        innerLoopDone:
        		beq $t1, $a3, endAll_found			# if( j(inner) == needle_len) => end all 
            j continueOuterLoop					# otherwise continue outer loop
        endAll_found:
        		# returning match position
            move $v0, $t0
            jr $ra
    continueOuterLoop:
        addi $t0, $t0, 1			# i(outer)++
        j outerLoop
    
    outerLoopDone:
    		# drop: no match found
        li $v0, -1
        jr $ra
