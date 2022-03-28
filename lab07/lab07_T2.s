
.global main
    
.set noreorder
    
main:
    addi $a0, $0, 6;	# argument register for n
    addi $t0, $0, 2
    jal fibr		# jump and link
    nop
    add $s0, $0, $v0
    jal done
    
    done: j done
      add $0, $0, $0
    
fibr:
    addi $sp, $sp, -12	# allocate memory on stack for n
    sw $ra, 8($sp)
    sw $a0, 4($sp)	# store onto stack
    sw $s0, 0($sp)
    slt $t1, $a0, $t0	# $t1 set to 1 if n < 2 otherwise 0
    beq $t1, $0, take	# if $t1 = 0 the branch is taken and the functino does not return base case
    nop
	add $v0, $0, $a0   # store return value
	lw $s0, 0($sp)
	lw $a0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12	# deallocate memory on stack for n
	jr $ra
	nop
    take:
    
    
    
    addi $a0, $a0, -1	# $a0 = n - 1	
    jal fibr		# jump and link
    nop
    add $s0, $0, $v0

    addi $a0, $a0, -1	# $a0 = n - 2
    jal fibr
    nop
    add $s0, $s0, $v0
    add $v0, $0, $s0
    
    lw $s0, 0($sp)
    lw $a0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12	# deallocate memory on stack for n
    jr $ra		# return
    nop
    
    
    


