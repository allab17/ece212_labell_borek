# $s0 = i , $s1 = f_1 , $s2 = f_2 , $s3 = n_f , $a0 = n , $v0

    
.global main
    
.set noreorder
    
main: addi $a0, $0, 20
      jal fib 
      addi $0, $0, 0
      
done: j done
      add $0, $0, $0
    
    
fib:
    addi $s0, $0, 2  # i = 2
    addi $s1, $0, 0  # f_1 = 0
    addi $s2, $0, 1  # f_2 = 1

    beq $a0, $0, ret_0   # n = 0 branch and return 0
    add $0, $0, $0
    slt $t2, $a0, $0    # if n is less than 0, t2 will store 1
    addi $t3, $0, 1	    # t3 holds 1
    beq $t2, $t3, ret_1  # if t2 is equal to 1 branch and return 1
    add $0, $0, $0
    beq $a0, $t3, ret_1  # if n is equal to 1 branch and return 1
    add $0, $0, $0 


    addi $t0, $a0, 1  # t0 is set to n + 1


    for: slt $t1, $s0, $t0   # if i is less than n + 1, t1 will be 1
	beq $t1, $0, done
	add $0, $0, $0
	add $v0, $s1, $s2   # n_f = n_1 + n_2 
	add $s1, $0, $s2   # f_1 = f_2
	add $s2, $0, $v0  # f_2 = n_f
	addi $s0, $s0, 1   # i++
	j for
	add $0, $0, $0 

    ret_0: 
    add $v0, $0, $0 
    j done

    ret_1:
    add $v0, $0, $t3
    j done
