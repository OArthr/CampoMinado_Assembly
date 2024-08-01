.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
	save_context
	move $s0, $a3
	move $s3, $a0
	move $s4, $a1

  addi $t0, $s3, -1
  move $s1, $t0 	# i = row-1
  begin_for_i_it:			# for (int i = row-1; i <= row+1; ++i) {
  addi $t1, $s3, 1
  bgt $s1,$t1,end_for_i_it 
  
  addi $t2, $s4, -1 
  move $s2, $t2		# j = col-1
  begin_for_j_it:			# for (int j = col-1; j <= col+1; ++j) {
  addi $t3, $s4, 1 
  bgt $s2,$t3,end_for_j_it
  blt $s1, $zero, continue		#if (i >= 0 && i < SIZE && j >= 0 && j < SIZE && board[i][j] == -2) {
  bge $s1, SIZE, continue		
  blt $s2, $zero, continue
  bge $s2, SIZE, continue
  sll $t0, $s1, 2 # i*SIZE
  mul $t0, $t0, SIZE
  sll $t1, $s2, 2 # j
  add $t0, $t0, $t1
  add $t0, $t0, $s0
  lw $t1,0($t0)
  li $t4, -2
  bne $t4, $t1 , continue
  
  
  move $a3, $s0
  move $a0, $s1
  move $a1, $s2
  jal countAdjacentBombs
  sll $t0, $s1, 2 # i*SIZE
  mul $t0, $t0, SIZE
  sll $t1, $s2, 2 # j
  add $t0, $t0, $t1
  add $t0, $t0, $s0
  sw $v0, 0($t0) # board[i][j] = x;
  bne $v0, $zero, continue # if (!x)
  
  move $a3, $s0
  move $a0, $s1
  move $a1, $s2
  jal revealNeighboringCells
  
  continue:
  addi $s2,$s2,1
  j begin_for_j_it
  end_for_j_it:
  addi $s1, $s1, 1
  j begin_for_i_it
  end_for_i_it:
  restore_context
  jr $ra 
