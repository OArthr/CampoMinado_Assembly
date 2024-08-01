.include "macros.asm"



.globl play
play:
	save_context
	move $s0, $a3

sll $t0, $a0, 2 # i*SIZE
mul $t0, $t0, SIZE
sll $t1, $a1, 2 # j
add $t0, $t0, $t1
add $t0, $t0, $s0
lw $t1, 0($t0)
li $t2, -1
beq $t2, $t1, return_0 # if (board[row][column] == -1)
li $t2, -2
bne $t2, $t1, return_1 # if (board[row][column] == -2)

move $a3, $s0
move $t5, $t0
jal countAdjacentBombs
sw $v0,0 ($t5) # board[row][column] = x
bne $v0, $zero, return_1 # if (!x)


move $a3, $s0
jal revealNeighboringCells


return_1:
li $v0, 1
restore_context
jr $ra

return_0:
li $v0, 0 # return 0
restore_context
jr $ra
