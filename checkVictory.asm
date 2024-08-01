.include "macros.asm"

.globl checkVictory

checkVictory:
	save_context
	move $s0, $a0

  li $v0, 0
  li $s1,0 # i = 0
  begin_for_i_it:					# for (int i = 0; i < SIZE; ++i) {
  li $t0,SIZE
  bge $s1,$t0,end_for_i_it 
  
  li $s2,0 # j = 0
  begin_for_j_it:					# for (int j = 0; j < SIZE; ++j) {
  li $t0,SIZE
  bge $s2,$t0,end_for_j_it
  sll $t0, $s1, 2 # i*SIZE
  mul $t0, $t0, SIZE
  sll $t1, $s2, 2 # j
  add $t0, $t0, $t1
  add $t0, $t0, $s0
  lw $t1, 0($t0)
  bge $t1, $zero, continue				# if (board[i][j] < 0)
  addi $v0, $v0, 1
  continue:
  addi $s2,$s2,1
  j begin_for_j_it
  end_for_j_it:
  addi $s1, $s1, 1
  j begin_for_i_it
  end_for_i_it:
  
  bne $v0, BOMB_COUNT, return_0				# if (count == BOMB_COUNT)
  li $v0, 1
  restore_context
  jr $ra
  
  return_0:
  li $v0, 0
  restore_context
  jr $ra 
