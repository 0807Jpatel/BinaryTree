##############################################################
# Homework #4
# name: Jaykumar Patel
# sbuid: 110255934
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

preorder:
    #Define your code here
    	move $t0, $a0
    	lw $t0, ($t0)
    	andi $t0, $t0, 0x0000ffff
    	
    	addi $sp, $sp, -16
	sw $ra, ($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	
	la $t1, writeFile
	sw $t0, ($t1)		
					
									
    	move $a0, $t1
    	move $a1, $a2
    	jal itof

    	
    	lw $a2, 12($sp)
    	lw $a1, 8($sp)
    	lw $a0, 4($sp)
      	lw $ra, ($sp)
	addi $sp, $sp, 16
	
	#get left nodeIndex
	lw $t1, ($a0)
	srl $t1, $t1, 24
	beq $t1, 255, noLeftNode
		addi $sp, $sp, -16
		sw $ra, ($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp) 
		
		li $t3, 4
		mul $t1, $t1, $t3 
		add $a0, $a1, $t1
		jal preorder
		
		lw $a2, 12($sp)
    		lw $a1, 8($sp)
    		lw $a0, 4($sp)
      		lw $ra, ($sp)
		addi $sp, $sp, 16
		
		
	noLeftNode:
	lw $t1, ($a0)
	andi $t1, $t1, 0x00ff0000
	srl $t1, $t1, 16
	beq $t1, 255, noRightNode
		addi $sp, $sp, -16
		sw $ra, ($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		
		li $t3, 4
		mul $t1, $t1, $t3 
		add $a0, $a1, $t1
		jal preorder
		
		lw $a2, 12($sp)
    		lw $a1, 8($sp)
    		lw $a0, 4($sp)
      		lw $ra, ($sp)
		addi $sp, $sp, 16
	
	noRightNode:
	
	
	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

linear_search:
    move $t0, $a0
    move $t1, $a1
    
    li $t2, 0		#counter for current bit
    
    while_loop_bytes:
    	lb $t4, ($t0)
    	
    	li $t5, 0 #inner counter for 8 bits
    	
    	for_loop_bites:
    		beq $t2, $t1, noEmptySpaceFound
    		beq $t5, 8, checkedAllBits
    		
    		andi $t6, $t4, 1
    		beqz $t6, foundEmptySpace
    		srl $t4, $t4, 1
    		    		    		
    		addi $t2, $t2, 1
    		addi $t5, $t5, 1
    		j for_loop_bites
    
    	checkedAllBits:
    
    	addi $t0, $t0, 1
    	j while_loop_bytes
    	
    foundEmptySpace:
    	move $v0, $t2
    	jr $ra
    
    noEmptySpaceFound:
    	li $v0, -1
    	jr $ra


set_flag:
    bltz $a1, InvalidInputSetFlag
    bge $a1, $a3, InvalidInputSetFlag
    
    andi $a2, $a2, 1
    li $t0, 8
    div $a1, $t0
    mflo $t0
    mfhi $t1

    add $a0, $a0, $t0
    lb $t2, ($a0)
    ror $t2, $t2, $t1
    andi $t2, $t2, 0xFFFFFFFE
    
    beq $a2, 1, addone
    beqz $a2 returnSetFlag
    
    addone:
    addi $t2, $t2, 1
    
    returnSetFlag:
    rol $t2, $t2, $t1
    sb $t2, ($a0)
    li $v0, 1
    jr $ra     
    
    InvalidInputSetFlag:
    li $v0, 0
    jr $ra

find_position:
    andi $t0, $a2, 0xFFFF
    andi $t8, $t0, 0x8000
    beq $t8, 0, noSignExtend
    	ori $t0, $t0, 0xFFFF0000
    noSignExtend:
    
    li $t6, 4
    mul $t1, $a1, $t6
    add $t1, $t1, $a0
    lw $t1, ($t1)
    andi $t2, $t1, 0x0000ffff
    andi $t8, $t2, 0x8000
    beq $t8, 0, noSignExtend2
    	ori $t2, $t1, 0xFFFF0000  
    noSignExtend2:
    
    bge $t0, $t2, else
    	andi $t2, $t1, 0xFF000000			#getleftIndex
        srl $t2, $t2, 24
        bne $t2, 255, leftRecursive
    		move $v0, $a1
    		li $v1, 0
    		jr $ra
    	leftRecursive:
    		addi $sp, $sp, -4
    		sw $ra, ($sp)
    		
    			move $a1, $t2
    			jal find_position
    			
    		lw $ra, ($sp)
    		addi $sp, $sp, 4
    		jr $ra
    	
    else:    
    	andi $t2, $t1, 0x00FF0000			#getRightIndex
        srl $t2, $t2, 16
        bne $t2, 255, RightRecursive
    		move $v0, $a1
    		li $v1, 1
    		jr $ra
    	RightRecursive:
    		addi $sp, $sp, -4
    		sw $ra, ($sp)
    		
    			move $a1, $t2
    			jal find_position
    			
    		lw $ra, ($sp)
    		addi $sp, $sp, 4
    		jr $ra
    jr $ra

add_node:
    addi $sp, $sp, -12
    sw $s0, ($sp)
    sw $s1, 4($sp)
    sw $ra, 8($sp)
    
    addi $sp, $sp, 12
    lw $s0, 4($sp)
    move $t0, $s0
    
    lw $s1, ($sp)
    move $t1, $s1
    addi $sp, $sp, -12
    
    andi $a1, $a1, 0x000000FF  #rootIndex
    andi $a3, $a3, 0x000000FF  #newIndex
    bge $a1, $t1, invalid_returnAdd_Node	
    bge $a3, $t1, invalid_returnAdd_Node
    
    andi $a2, $a2, 0x0000FFFF  #newValue
    
    li $t2, 8
    div $a1, $t2
    mflo $t2
    mfhi $t3
    
    add $t0, $t0, $t2
    lb $t2, ($t0)
    ror $t2, $t2, $t3
    andi $t2, $t2, 1
    
    beq $t2, 0, NoRootPresent
    	addi $sp, $sp, -28
    	sw $ra, ($sp)
    	sw $a0, 4($sp)
    	sw $a1, 8($sp)
    	sw $a2, 12($sp)
    	sw $a3, 16($sp)
    	sw $t0, 20($sp)
    	sw $t1, 24($sp)
    	
    	jal find_position
    	    	    	
    	lw $ra, ($sp)
    	lw $a0, 4($sp)
    	lw $a1, 8($sp)
    	lw $a2, 12($sp)
    	lw $a3, 16($sp)
    	lw $t0, 20($sp)
    	lw $t1, 24($sp)
    	addi $sp, $sp, 28
   
    move $t2, $v0 #parent
    
    beq $v1, 0, AddAsLeftChild
    	li $t8, 4
    	mul $t2, $t2, $t8
    	add $t3, $a0, $t2
    	lw $t4, ($t3)
    	sll $t8, $a3, 16
    	andi $t4, $t4, 0xff00ffff
    	or $t4, $t4, $t8
    	sw $t4, ($t3)    
    	j doneAddingChild
    
    AddAsLeftChild:
        li $t8, 4
    	mul $t2, $t2, $t8
    	add $t3, $a0, $t2
    	lw $t4, ($t3)
    	sll $t8, $a3, 24
    	andi $t4, $t4, 0x00ffffff
    	or $t4, $t4, $t8
    	sw $t4, ($t3)
    	j doneAddingChild
    
    NoRootPresent:
     	move $a3, $a1
    
    doneAddingChild:    
         li $t8, 4
         mul $t2, $a3, $t8
         add $t2, $a0, $t2
         
         lui $t3, 0xffff
         or $t3, $t3, $a2  
         sw $t3, ($t2)
         
     move $a0, $s0
     move $a1, $a3
     li $a2, 1
     move $a3, $s1
     jal set_flag
     
         
    lw $s0, ($sp)
    lw $s1, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12     
    
    jr $ra  
    
    invalid_returnAdd_Node:
    li $v0, 0
    jr $ra
    
    returnAdd_Node:
    li $v0, 1
    
    jr $ra

##############################
# PART 3 FUNCTIONS
##############################

get_parent:
    #a0, nodes[]
    #a1, currentIndex
    #a2, childValue
    #a3, childIndex
    
    andi $a3, $a3, 0x000000FF #childIndex
    andi $a2, $a2, 0x0000FFFF #childValue
    andi $t2, $a2, 0x8000
    beq $t2, 0, dontSignExtend2
    	ori $a2, $a2, 0xffff0000	#value of the currentNode
    dontSignExtend2:
    
    
    
    li $t0, 4
    mul $t0, $a1, $t0
    add $t0, $t0, $a0	#currentNode
    lw $t1, ($t0)
    andi $t3, $t1, 0x0000FFFF
    
    andi $t2, $t3, 0x8000
    beq $t2, 0, dontSignExtend
    	ori $t3, $t3, 0xffff0000	#value of the currentNode
    dontSignExtend:
    
    bge $a2, $t3, elseRightIndex
    	andi $t2, $t1, 0xff000000
    	srl $t2, $t2, 24
    	beq $t2, 255, leftEqual255
    	beq $t2, $a3, leftEqualChildIndex
    	j leftElse
    	leftEqual255:
    		move $v0, $a1
    		li $v1, -1
    		jr $ra
    	leftEqualChildIndex:
    		move $v0, $a1
    		li $v1, 0
    		jr $ra
    	leftElse:
    		addi $sp, $sp, -4
    		sw $ra, ($sp)
    			move $a1, $t2
    			jal get_parent
    		lw $ra, ($sp)
    		addi $sp, $sp, 4    
    		jr $ra		        
    elseRightIndex:
   	andi $t2, $t1, 0x00ff0000
    	srl $t2, $t2, 16
    	beq $t2, 255, rightEqual255
    	beq $t2, $a3, rightEqualChildIndex
    	j rightElse
    	rightEqual255:
    		move $v0, $a1
    		li $v1, -1
    		jr $ra
    	rightEqualChildIndex:
    		move $v0, $a1
    		li $v1, 1
    		jr $ra
    	rightElse:
    		addi $sp, $sp, -4
    		sw $ra, ($sp)
    			move $a1, $t2
    			jal get_parent
    		lw $ra, ($sp)
    		addi $sp, $sp, 4    
    		jr $ra

find_min:
    #a0 nodes
    #a1 currentIndex
    
    li $t0, 4
    mul $t0, $t0, $a1
    add $t0, $a0, $t0
    lw $t0, ($t0)
    
    andi $t1, $t0, 0xff000000
    srl $t1, $t1, 24
    
    beq $t1, 255, return_find_min
    	addi $sp, $sp, -4
    	sw $ra, ($sp)
    	
    	move $a1, $t1
    	jal find_min
    	
    	lw $ra, ($sp)
    	addi $sp, $sp, 4
    	jr $ra
    
    return_find_min:
    	move $v0, $a1
    	andi $t2, $t0, 0xffff0000
    	li $t3, 0xffff0000
    	beq $t2, $t3, isLeaf
    		li $v1, 0
    		jr $ra
    	isLeaf:
    		li $v1, 1
    		jr $ra

delete_node:
    #a0 nodes
    #a1 rootIndex
    #a2 deleteIndex
    #a3 flags
    #t0 maxSize
    
    lw $t0, ($sp)

    andi $a1, $a1, 0x000000ff
    andi $a2, $a2, 0x000000ff
    
    bge $a2, $t0, invalid_return_deletenode
    bge $a1, $t0, invalid_return_deletenode
    
    li $t2, 8
    div $a1, $t2
    mflo $t2
    mfhi $t3
    
    add $t0, $t2, $a3
    lb $t2, ($t0)
    ror $t2, $t2, $t3
    andi $t2, $t2, 1
    
    beq $t2, 0, invalid_return_deletenode
    
    li $t2, 8
    div $a2, $t2
    mflo $t2
    mfhi $t3
    
    add $t0, $t2, $a3
    lb $t2, ($t0)
    ror $t2, $t2, $t3
    andi $t2, $t2, 1
    
    beq $t2, 0, invalid_return_deletenode	
    
    li $t1, 4
    mul $t1, $t1, $a2
    add $t1, $a0, $t1
    lw $t1, ($t1)
    andi $t2, $t1, 0xffff0000
    li $t3, 0xffff0000
    
    beq $t2, $t3, deleteNodeIsLeaf
    
    andi $t2, $t1, 0xff000000
    li $t3, 0xff000000
    beq $t2, $t3, hasOneChild
    andi $t2, $t1, 0x00ff0000
    li $t3, 0x00ff0000
    beq $t2, $t3, hasOneChild
    j ElseBothChild
    
    deleteNodeIsLeaf:
    	addi $sp, $sp, -28
    	sw $a0, ($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	sw $a3, 12($sp)
    	sw $t0, 16($sp)
    	sw $t1, 20($sp)
    	sw $ra, 24($sp)
    	
    	move $a0, $a3
    	move $a1, $a2
    	li $a2, 0
    	move $a3, $t0
    	jal set_flag
    
    	lw $a0, ($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	lw $a3, 12($sp)
    	lw $t0, 16($sp)
    	lw $t1, 20($sp)
    	lw $ra, 24($sp)
    	addi $sp, $sp, 28
    	
    	beq $a1, $a2, return1
    	addi $sp, $sp, -28
    	sw $a0, ($sp)
    	sw $a1, 4($sp)
    	sw $a2, 8($sp)
    	sw $a3, 12($sp)
    	sw $t0, 16($sp)
    	sw $t1, 20($sp)
    	sw $ra, 24($sp)
    	
    	andi $t1, $t1, 0x0000ffff
    	andi $t2, $t1, 0x8000
    	beq $t2, 0, DontSignExtend3
    		ori $t1, $t1, 0xffff0000    		
    	DontSignExtend3:
    	move $a3, $a2
    	move $a2, $t1
    	
    	jal get_parent 
    
    	lw $a0, ($sp)
    	lw $a1, 4($sp)
    	lw $a2, 8($sp)
    	lw $a3, 12($sp)
    	lw $t0, 16($sp)
    	lw $t1, 20($sp)
    	lw $ra, 24($sp)
    	addi $sp, $sp, 28
    	
    	li $t2, 4
   	mul $t2, $t2, $v0
   	add $t2, $a0, $t2
   	lw $t3, ($t2)
   	
   	beq $v1, 1, DeleteRightLeafNode
    		andi $t3, $t3, 0x00ffffff
    		ori $t3, $t3, 0xff000000
    		sw $t3, ($t2)
    		j return1
    	DeleteRightLeafNode:
    		andi $t3, $t3, 0xff00ffff
    		ori $t3, $t3, 0x00ff0000
    		sw $t3, ($t2)
    		j return1
    hasOneChild:
    	#t1 has the deleteNode
    	andi $t2, $t1, 0xff000000
    	li $t3, 0xff000000
	beq $t2, $t3, hasRightChild
		srl $t2, $t2, 24
	hasRightChild:
		andi $t2, $t1, 0x00ff0000
  		srl $t2, $t2, 16   	#t2 is childIndex
    	
    	bne $a1, $a2, RootNotDeletedWithOne
    		li $t3, 4
   		mul $t3, $t3, $t2
   		add $t3, $a0, $t3
   		lw $t3, ($t3)	#childNode
   		
   		li $t4, 4
   		mul $t4, $t4, $a2
   		add $t4, $a0, $t4
   		
   		sw $t3, ($t4)	#saved nodes[deleteIndex] = childNode;
   		
   		addi $sp, $sp, -36
    		sw $a0, ($sp)
    		sw $a1, 4($sp)
    		sw $a2, 8($sp)
    		sw $a3, 12($sp)
    		sw $t0, 16($sp)
    		sw $t1, 20($sp)
    		sw $ra, 24($sp)
    		sw $t2, 28($sp)
    		sw $t3, 32($sp)
    	
    		move $a0, $a3
    		move $a1, $t2
    		li $a2, 0
    		move $a3, $t0
    		jal set_flag
    
    		lw $a0, ($sp)
    		lw $a1, 4($sp)
    		lw $a2, 8($sp)
    		lw $a3, 12($sp)
    		lw $t0, 16($sp)
    		lw $t1, 20($sp)
    		lw $ra, 24($sp)
    		lw $t2, 28($sp)
    		lw $t3, 32($sp)
    		addi $sp, $sp, 36
   		
    		j return1
    	RootNotDeletedWithOne:
    		addi $sp, $sp, -36
    		sw $a0, ($sp)
    		sw $a1, 4($sp)
    		sw $a2, 8($sp)
    		sw $a3, 12($sp)
    		sw $t0, 16($sp)
    		sw $t1, 20($sp)
    		sw $ra, 24($sp)
    		sw $t2, 28($sp)
    		sw $t3, 32($sp)
    	
    		andi $t1, $t1, 0x0000ffff
    		andi $t2, $t1, 0x8000
    		beq $t2, 0, DontSignExtend4
    			ori $t1, $t1, 0xffff0000    		
    		DontSignExtend4:
    		move $a3, $a2
    		move $a2, $t1
    	
    		jal get_parent 
    
    		lw $a0, ($sp)
    		lw $a1, 4($sp)
    		lw $a2, 8($sp)
    		lw $a3, 12($sp)
    		lw $t0, 16($sp)
    		lw $t1, 20($sp)
    		lw $ra, 24($sp)
    		lw $t2, 28($sp)
    		lw $t3, 32($sp)
    		addi $sp, $sp, 36
    	
    		beq $v1, 1, RightOneNodeDeleted
    			li $t4, 4
   			mul $t4, $t4, $v0
   			add $t4, $a0, $t4
   			lw $t5, ($t4)	#ParentNode
   			andi $t5, $t5, 0x00ffffff
   			sll $t3, $t2, 24
   			or $t5, $t3, $t5
   			sw $t5, ($t4) 			
    		
    		RightOneNodeDeleted:
    			li $t4, 4
   			mul $t4, $t4, $v0
   			add $t4, $a0, $t4
   			lw $t5, ($t4)	#ParentNode
   			andi $t5, $t5, 0xff00ffff
   			sll $t3, $t2, 16
   			or $t5, $t3, $t5
   			sw $t5, ($t4) 	
    		
    		addi $sp, $sp, -4
    		sw $ra, ($sp)
    			move $a0, $a3
    			move $a1, $a2
    			li $a2, 0
    			move $a3, $t0
    		
    			jal set_flag
    		
    		lw $ra, ($sp)
    		addi $sp, $sp, 4
    		
    		j return1
    		
    ElseBothChild:
    	addi $sp, $sp, -24
    	sw $ra, ($sp)
    	sw $a0, 4($sp)
    	sw $a1, 8($sp)
    	sw $a2, 12($sp)
    	sw $a3, 16($sp)
    	sw $t0, 20($sp)
    	
    	li $t1, 4
    	mul $t1, $a2, $t1
    	add $t1, $t1, $a0
    	lw $t1, ($t1)
    	andi $t1, $t1, 0x00ff0000
    	srl $t1, $t1, 16
    	move $a1, $t1
    	jal find_min
    	
    	lw $ra, ($sp)
    	lw $a0, 4($sp)
    	lw $a1, 8($sp)
    	lw $a2, 12($sp)
    	lw $a3, 16($sp)
    	lw $t0, 20($sp)
    	addi $sp, $sp, 24
    	move $t1, $v0	#min Index
    	move $t2, $v1	#node Leaf or not
    	
    	addi $sp, $sp, -32
    	sw $ra, ($sp)
    	sw $a0, 4($sp)
    	sw $a1, 8($sp)
    	sw $a2, 12($sp)
    	sw $a3, 16($sp)
    	sw $t0, 20($sp)
    	sw $t1, 24($sp)
    	sw $t2, 28($sp)
	
	move $a2, $a3
	li $t3, 4
	mul $t3, $t1, $t3
	add $t3, $a0, $t3
	lw $t3, ($t3)
	andi $t3, $t3, 0x0000ffff
	move $a2, $t3
	move $a3, $t1
	jal get_parent
    	
    	lw $ra, ($sp)
    	lw $a0, 4($sp)
    	lw $a1, 8($sp)
    	lw $a2, 12($sp)
    	lw $a3, 16($sp)
    	lw $t0, 20($sp)
    	lw $t1, 24($sp)
    	lw $t2, 28($sp)
    	addi $sp, $sp, 32
    	move $t3, $v0	#parent
    	move $t4, $v1	#leftOrRight
    	
    	beqz $t2, minNodeisNotLeaf
    		beq $t4, 1, minNodeRight
    			li $t2, 4
    			mul $t2, $t3, $t2
    			add $t2, $t2, $a0
    			lw $t5, ($t2)
    			ori $t5, $t5, 0xff000000
    			sw $t5, ($t2)
    			j minisLeafDone
    		minNodeRight:
    			li $t2, 4
    			mul $t2, $t3, $t2
    			add $t2, $t2, $a0
    			lw $t5, ($t2)
    			ori $t5, $t5, 0x00ff0000
    			sw $t5, ($t2)
    			j minisLeafDone
    		
    	minNodeisNotLeaf:
    		beq $t4, 1, minNodeRight2
    			li $t2, 4
    			mul $t2, $t1, $t2
    			add $t2, $t2, $a0
    			lw $t5, ($t2)	#holds nodes[minIndex]
    			
    			li $t2, 4
    			mul $t2, $t3, $t2
    			add $t2, $t2, $a0
    			lw $t6, ($t2)	#holds nodes[parentIndex]
    			
    			andi $t6, $t6, 0x00ffffff
    			andi $t5, $t5, 0x00ff0000
    			srl $t5, $t5, 8
    			or $t6, $t5, $t6
    			
    			sw $t6, ($t2)
    		j minisLeafDone
    		minNodeRight2:
    		
    			li $t2, 4
    			mul $t2, $t1, $t2
    			add $t2, $t2, $a0
    			lw $t5, ($t2)	#holds nodes[minIndex]
    			
    			li $t2, 4
    			mul $t2, $t3, $t2
    			add $t2, $t2, $a0
    			lw $t6, ($t2)	#holds nodes[parentIndex]
    			
    			andi $t6, $t6, 0xff00ffff
    			andi $t5, $t5, 0x00ff0000
    			or $t6, $t5, $t6
    			
    			sw $t6, ($t2)
    		
    	minisLeafDone:
    		li $t2, 4
    		mul $t2, $t1, $t2
    		add $t2, $t2, $a0
    		lw $t5, ($t2)	#holds nodes[minIndex]
    		
    		li $t2, 4
    		mul $t2, $a2, $t2
    		add $t2, $t2, $a0
    		lw $t6, ($t2)	#holds nodes[deleteIndex]
    		
    		andi $t6, $t6, 0xffff0000
    		andi $t5, $t5, 0x0000ffff
    		or $t6, $t5, $t6
    		sw $t6, ($t2)
    		
    		addi $sp, $sp, -4
    		sw $ra, ($sp)
    		
    		move $a0, $a3
    		move $a1, $t1
    		li $a2, 0
    		move $a3, $t0
    		
    		jal set_flag
    		
    		lw $ra, ($sp)
    		addi $sp, $sp, 4
    
    return1:
    	li $v0, 1
    	jr $ra
    
    invalid_return_deletenode:
    	li $v0, -1    
   	jr $ra

##############################
# EXTRA CREDIT FUNCTION
##############################

add_random_nodes:
    move $s0, $a0	#nodes
    move $s1, $a1	#maxsize
    move $s2, $a2	#rootIndex
    move $s3, $a3	#flags
    lw $s4, ($sp)	#seeds
    lw $s5, 4($sp)	#fd
    
    bltz $s2, EC_return_invalid
    bge $s2, $s1, EC_return_invalid
       
    
    li $a0, 0
    move $a1, $s4
    li $v0, 40
    syscall
    
    addi $sp, $sp, -4
    sw $ra, ($sp)
    move $a0, $s3
    move $a1, $s1
    jal linear_search
    lw $ra, ($sp)
    addi $sp, $sp, 4
    
    move $s6, $v0	#newIndex
    
    AddToTree:
    bltz $s6, FullTree
    	li $a1, 65535
    	li $a0, 0   		 #newValue = generator.nextInt(-32768,32767);
    	li $v0, 42
  	syscall
   	addi $t2, $a0, -32768		#new value
    	
    	addi $sp, $sp, -8			#parentIndex,leftOrRight = find_position(nodes, rootIndex, newValue);
    	sw $ra, ($sp)
    	sw $t2, 4($sp)
    	move $a2, $t2
    	move $a0, $s0
    	move $a1, $s2    	    
    	jal find_position
    	lw $t2, 4($sp)	
    	lw $ra, ($sp)
    	addi $sp, $sp, 8
    
    	move $t0, $v0	#parentIndex
    	move $t1, $v1	#leftOrRight
    	  	
        li $v0, 15
	move $a0, $s5
	la $a1, NewValue
	li $a2, 11
	syscall
	
	addi $sp, $sp, -16
	sw $ra, ($sp)
    	sw $t0, 4($sp)
    	sw $t1, 8($sp)
    	sw $t2, 12($sp)
    	sw $t2, writeFile
    	move $a1, $s5
    	la $a0, writeFile
    	jal itof
    	
    	lw $ra, ($sp)
    	lw $t0, 4($sp)
    	lw $t1, 8($sp)
    	lw $t2, 12($sp)
    	addi $sp, $sp, 16
    	
    	li $v0, 15
	move $a0, $s5
	la $a1, Parent
	li $a2, 14
	syscall
	
	addi $sp, $sp, -16
	sw $ra, ($sp)
    	sw $t0, 4($sp)
    	sw $t1, 8($sp)
    	sw $t2, 12($sp)
    	sw $t0, writeFile
    	move $a1, $s5
    	la $a0, writeFile
    	jal itof
    	
    	lw $ra, ($sp)
    	lw $t0, 4($sp)
    	lw $t1, 8($sp)
    	lw $t2, 12($sp)
    	addi $sp, $sp, 16
    	
    	li $v0, 15
	move $a0, $s5
	la $a1, LeftOrRight
	li $a2, 23
	syscall
	
	addi $sp, $sp, -16
	sw $ra, ($sp)
    	sw $t0, 4($sp)
    	sw $t1, 8($sp)
    	sw $t2, 12($sp)
    	sw $t1, writeFile
    	move $a1, $s5
    	la $a0, writeFile
    	jal itof
    	
    	lw $ra, ($sp)
    	lw $t0, 4($sp)
    	lw $t1, 8($sp)
    	lw $t2, 12($sp)
    	addi $sp, $sp, 16
    	
   	
    	
    	addi $sp, $sp, -16
    	sw $ra, ($sp)
    	sw $t0, 4($sp)
    	sw $t1, 8($sp)
    	sw $t2, 12($sp)
    
    	move $a0, $s0
    	move $a1, $s2
    	move $a2, $t2
    	move $a3, $s6
    	addi $sp, $sp, -8
    	sw $s3, 4($sp)
    	sw $s1, ($sp)
    	jal add_node
    	addi $sp, $sp, 8
    	lw $ra, ($sp)
    	lw $t0, 4($sp)
    	lw $t1, 8($sp)
    	lw $t2, 12($sp)
    	addi $sp, $sp, 16
    	
    	
    	addi $sp, $sp, -4
   	sw $ra, ($sp)
   	move $a0, $s3
   	move $a1, $s1
  	jal linear_search
  	lw $ra, ($sp)
  	addi $sp, $sp, 4
    
  	move $s6, $v0	#newIndex
  	j AddToTree
    	
    FullTree:
       li $t5, 4
       mul $s2, $t5, $s2
       add $s2, $s0, $s2
       addi $sp, $sp, -4
       sw $ra, ($sp)
       move $a0, $s2
       move $a1, $s0
       move $a2, $s5
       jal preorder
       lw $ra, ($sp)
       addi $sp, $sp, 4
    
    
    EC_return_invalid:
    
    jr $ra
    
    
##############################
#EXTRA METHOD USED
##############################
itof:	
	lw $t0, ($a0)
	move $t1, $a1
	bnez $t0, NotZero
		la $t5, writeFile
		li $t3, '0'
		sw $t3, ($t5)
		li $v0, 15
		move $a0, $t1
		move $a1, $t5
		li $a2, 1
		syscall
		
		li $v0, 15
		move $a0, $t1
		la $a1, end1
		li $a2, 1
		syscall
	
		jr $ra	
	
	NotZero:	
	
	andi $t0, $t0, 0x0000ffff
	andi $t7, $t0, 0x8000
	
	beqz $t7, notNeg
	xori $t0, $t0, 0xFFFF
	addi $t0, $t0, 1
	la $t5, writeFile
	li $t3, '-'
	sw $t3, ($t5)
		
	li $v0, 15
	move $a0, $t1
	move $a1, $t5
	li $a2, 1
	syscall
	
	notNeg:
	
	li $t8, 10
	li $t2, 0 				  		#counter++
	li $t4, 0
	while_length:
		beqz $t0, popAndPrint  	#if int is 0 then return
		divu $t0, $t8				#divide int by 10
		mflo $t0					#quotient becomes new int
		mfhi $t3
		addi $sp, $sp, -4
		sw $t3, ($sp)
		addi $t2, $t2, 1				#increment length counter by one
		j while_length				#back to the while loop
							
	popAndPrint:
		beq $t4, $t2, addSpace
		lw $t3, ($sp)
		addi $sp, $sp, 4
		la $t5, writeFile
		addi $t3, $t3, '0'
		sw $t3, ($t5)
		
		li $v0, 15
		move $a0, $t1
		move $a1, $t5
		li $a2, 1
		syscall
		
		addi $t4, $t4, 1
		j popAndPrint
	addSpace:


	li $v0, 15
	move $a0, $t1
	la $a1, end1
	li $a2, 1
	syscall
	
	jr $ra	


#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary
writeFile: .space 12
end1: .asciiz "\n"
NewValue: .asciiz "New Value: "
Parent: .asciiz "Parent index: "
LeftOrRight: .asciiz "Left (0) or right (1): "



#place any additional data declarations here

