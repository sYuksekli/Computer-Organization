# SILA BENGÝSU YÜKSEKLÝ
# 1801042877
# You can enter elements of the union set from keyboard, but you have enter 6 elements.
# You can enter size of the subset, number of the total subset you want to work and
# elements of the subset from keyboard, but I allocate 900 byte on the data section according to the moodle page
# max 10 subset and 20 elements for each.

.data 
       IndexArray:             .space 24
       UnionSet:               .space  24
       SubSets:       		.space 900
       newLine:       		.asciiz "\n"
       numOfSubset:   		.asciiz "Please enter the number of the subsets that you want to work."
       sizeSubsetQuestion:  	.asciiz "Please enter the size of the subset."
       unionSet:        	.asciiz "Please enter the elements of the union set."
       subSet:        		.asciiz "Please enter the elements of the sub-set."
       Output:        		.asciiz "Indexs of the subsets that cover the most are:"
       comma:                  .ascii  ","
.text
   main:   
      li   $v0, 4			#print on the screen a question which asks the elements of the union set.
      la   $a0, unionSet
      syscall
      jal printNewLine
      
      li   $t1, 0
      li   $t3, 0
takeElements:				# UnionSet must have 6 elements.
      beq  $t1, 6, endOfTaking		# if counter == size (6), finish loop.
      li   $v0, 5		        # Otherwise, read the element of union set from the user
      syscall
      move $t2, $v0
      sw   $t2, UnionSet($t3)		# Store it in the array.
      add  $t3, $t3, 4
      add  $t1, $t1, 1
      j    takeElements		# return loop.
endOfTaking:
      
      li   $v0, 4			#print on the screen a question which asks the number of the subsets to work with.
      la   $a0, numOfSubset
      syscall
      jal printNewLine
      
      li   $v0, 5		        # read the number of subsets from the user
      syscall
      move $t0, $v0		        # move number variable into $t0 register
      
      li   $t5, 0		        # to indicate subset array index
      li   $t1, 0			# to indicate loop counter
biggerLoop:   
      beq  $t1, $t0, biggerLoopEnd	# if  counter($t1) == number($t0), leave the loop.     
      li   $v0, 4			#Otherwise, print on the screen a question which asks the size of the subset
      la   $a0, sizeSubsetQuestion
      syscall
      jal printNewLine
      li   $v0, 5		        # read the size from the user
      syscall
      move $t3,$v0		        # move size variable into $t3 register   
      
      sw    $t3, SubSets($t5)		# add an element that indicates size variable in Subset array.
      addi  $t5, $t5, 4		# every integer has 4 bytes, so add four to $t5 register for the next element to be stored.
      sw    $t1, SubSets($t5)		# add an element that indicates index of the Subset(S1,S2... it begins at 0) 
      addi  $t5, $t5, 4		# every integer has 4 bytes, so add four to $t5 register for the next element to be stored.
      
      li    $v0, 4		        #print on the screen a question which asks elements of the subset.
      la    $a0, subSet
      syscall
      jal printNewLine
      
      li    $t4, 0      	        # to indicate variable i of the for loop.
nestedLoop:
      beq   $t4, $t3, end		# if counter($t4) == size($t3), leave the loop.
      li    $v0, 5			# otherwise, read the element from the user.
      syscall
      move  $t6, $v0			# move element into $t6 register.
      sw    $t6, SubSets($t5)		# add new element in Subset array.
      addi  $t5, $t5, 4		# every integer has 4 bytes, so add four to $t5 register for the next element to be stored.
      addi  $t4, $t4, 1		# increase counter.
      j     nestedLoop			# return the starting of the loop
end:
      addi  $t1, $t1, 1		# increase biggerLoop counter.
      j     biggerLoop  
      
biggerLoopEnd:  
      
      la    $t1, UnionSet
      lw    $s1  0($t1)
      lw    $s2  4($t1)
      lw    $s3  8($t1)
      lw    $s4  12($t1)
      lw    $s5  16($t1)
      lw    $s6  20($t1)
      
      # $t0 register has number of the subset
      li    $t1, 6			# Union set has 6 elements. If $t1 register reaches zero, solution will be found.
      li    $t2, 0			# to indicate index of the IndexArray
whileLoop:
      ble   $t1, 0, solution		# if $t1 is zero, then solution is found.
      li    $t3, 0			# nested loop counter.
      li    $t4, 0                    # nested loop counter and it represents index of the SubSets array.
      li    $t5, 0			# I store this register as the max number that most matches the union set.( max=0)
      whileSubset:
         beq   $t3, $t0, endWhileSubset	# if $t3(=loop counter) == $t0 (=number of the subset), continue with the label
         lw    $t6, SubSets($t4)		# Otherwise, find the size of the subset, initial value of $t4 is 0. First element in the array represents size value.
         add   $t6, $t6, 2			# To find the first element in the next subset, I do this math.
         mul   $t6, $t6, 4			# $t6 is size. Size = size + 2. Because first element is size value and second elements is subset index. So actually, there are size + 2 elements in the subset.
         add   $t6, $t6  $t4			# Every int has 4 bytes, so multiply with four. Result is the index of the first element in the next subset.
         add   $t4, $t4, 8			# To reach actual value in the subset, jump two elemets.
         addi  $s0, $t4, 0			# To store the beginnin value. It will be used later.
         li    $t7, 0                    	# To represent most number that covers the union set. (mostNum = 0)
         whileSize:				
            beq   $t4, $t6, endWhileSize	# if $t4(=loop counter) == $t6(=index of the first element of next subset), continuw eith label
            lw    $t8, SubSets($t4)		# Otherwise, $t8 = SubsetArray[$t4].
            beq   $t8, $s1, increaseMostNum	# Search for the element in UnionSet that matches with the current value.
            beq   $t8, $s2, increaseMostNum	# if value is found, continue with label
            beq   $t8, $s3, increaseMostNum
            beq   $t8, $s4, increaseMostNum
            beq   $t8, $s5, increaseMostNum
            beq   $t8, $s6, increaseMostNum
            add   $t4, $t4, 4
            addi  $s7, $t4, 0
            j     whileSize	
            increaseMostNum:
               add   $t7, $t7, 1		# increase the value of mostNum variable. 
               add   $t4, $t4, 4		# increase array index of Subsets
               addi  $s7, $t4, 0		# This value will be used later. It stores last index.
               j     whileSize			# do this until counter reaches next array index.
          endWhileSize:
             blt   $t5, $t7, changeMax		# when whileSize loop is finished, check the max value.
             add   $t3, $t3, 1			# increase loop counter.
             j      whileSubset		# return whileSubset loop.
             changeMax:
                 move   $t5, $t7		# if max < mostNum, change max value with mostNum value.
                 move   $a1, $s0		# Store beginning and ending bytes of the current subset which has the max matching.
                 move   $a2, $s7		# store ending byte
                 add    $t3, $t3, 1		# increase loop counter.
                 j      whileSubset		# return whileSubset loop.
	endWhileSubset:
	   
	   move   $t9, $a1			# copy beginning byte into $t9 register
	   sub    $t9, $t9, 4			# previous element in Subsets array represents subset index. So subtract four.
	   lw     $a3, SubSets($t9)		# Take the value located in this index.
	   sw     $a3, IndexArray($t2)		# and store it in IndexArray.
	   add    $t2, $t2, 4
	   li     $a3, -1			# to change values that is found, with -1.
	   move   $t9, $a1                    # create temp_beginningByte
	   whileEliminateNumbers:
	       beq   $t9, $a2, endWhileEliminateNumbers	# if temp beginning byte == ending byte, continue with label.
	       sw    $a3, SubSets($t9)				# Otherwise, change values that is found, with -1.
	       add   $t9, $t9, 4				# incease subset array index
	       j     whileEliminateNumbers			# return loop
	    endWhileEliminateNumbers:	       
	       				
	       move   $t9, $a1 				# create temp beginning byte.
	       whileEliminateUnionSet:
	       	   beq   $t9, $a2, endWhileEliminateUnionSet
	           lw    $a3, SubSets($t9)			# take the value located at current index
	           beq   $a3, $s1, change_a			# if  value is equal to element of the Union set
	           beq   $a3, $s2, change_b			# remove this element and put zero instead of.
	           beq   $a3, $s3, change_c
	           beq   $a3, $s4, change_d
	           beq   $a3, $s5, change_e
	           beq   $a3, $s6, change_f						
		
	           change_a: 
	              li    $s1, 0
	              add   $t9, $t9, 4
	              sub   $t1, $t1, 1			# loop counter at outermost.
	              j     whileEliminateUnionSet
	              
	           change_b: 
	              li    $s2, 0
	              add   $t9, $t9, 4
	              sub   $t1, $t1, 1			# loop counter at outermost.
	              j     whileEliminateUnionSet
	              
	           change_c: 
	              li    $s3, 0
	              add   $t9, $t9, 4
	              sub   $t1, $t1, 1			# loop counter at outermost.
	              j     whileEliminateUnionSet
	              
	            change_d: 
	              li    $s4, 0
	              add   $t9, $t9, 4
	              sub   $t1, $t1, 1			# loop counter at outermost.
	              j     whileEliminateUnionSet
	              
	            change_e: 
	              li    $s5, 0
	              add   $t9, $t9, 4
	              sub   $t1, $t1, 1			# loop counter at outermost.
	              j     whileEliminateUnionSet
	              
	            change_f: 
	              li    $6, 0
	              add   $t9, $t9, 4
	              sub   $t1, $t1, 1			# loop counter at outermost.
	              j     whileEliminateUnionSet
	        endWhileEliminateUnionSet:   
	            j   whileLoop				# return while loop
solution:

	li   $v0,4
	la   $a0, Output
	syscall

	li   $t0,0
   loop:				# This loop is for printing the result on the screen.
	beq  $t0, $t2, result
	lw   $t1, IndexArray($t0)
	add  $t1, $t1, 1		# The aim of adding, I filled second element as a subset index, but it begins at zero.
	li   $v0, 1			# but real indexes of subsets begin at one. So I added one.
	move $a0, $t1
	syscall
	li   $v0,4
	la   $a0, comma
	syscall
	add  $t0, $t0, 4 
	j    loop
	
   result:
	li    $v0, 10
	syscall
      
      
# function for printing new line     
printNewLine:   
      li   $v0, 4		       
      la   $a0, newLine
      syscall
      jr   $ra     
