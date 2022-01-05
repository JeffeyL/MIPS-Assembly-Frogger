#####################################################################
#
# Frogger
# Created by Jeffrey Luo
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
#####################################################################
.data
displayAddress: .word 0x10008000
frogX: 	.word 64
frogY: 	.word 3584
lives: 	.word 3
wins:	.word 0
car1:	.space 128 # car1 represents the first row of cars (from the bottom)
car2:	.space 128 # car2 represents the second row of cars (from the bottom)
car3:	.space 128
log1:	.space 128 # log1 represents the first row of logs (from the bottom)
log2:	.space 128 # log2 represents the second row of logs (from the bottom)
log3:	.space 128
color0: .word 0
color1: .word 1
.text
li $s0, 0xff0000 # $s0 stores the red colour code
li $s1, 0x00ff00 # $s1 stores the green colour code
li $s2, 0x0000ff # $s2 stores the blue colour code
li $s3, 0x800080 # $s3 stores the purple colour code
li $s4, 0x964B00 # $s4 stores the brown colour code
li $s5, 0x000000 # $s5 stores the black colour code
li $s6, 0xFFFF00 # $s6 stores the yellow colour code
li $s7, 0xFF00FF # $s7 stores the magenta colour code

# INITIALIZE BOTTOM CAR
addi	$a3, $s0, 0
addi	$a2, $s5, 0
la	$a0, car1
jal	INIT_ARRAY
lw	$a1, displayAddress
addi	$a1, $a1, 3072
jal	DRAW_ARRAY
# INITIALIZE TOP CAR
addi	$a3, $s0, 0
addi	$a2, $s5, 0
la	$a0, car2
jal	INIT_ARRAY
lw	$a1, displayAddress
addi	$a1, $a1, 2560
jal	DRAW_ARRAY
# INITIALIZE BOTTOM LOG
addi	$a3, $s4, 0
addi	$a2, $s2, 0
la	$a0, log1
jal	INIT_ARRAY
lw	$a1, displayAddress
addi	$a1, $a1, 1536
jal	DRAW_ARRAY
# INITIALIZE TOP LOG
addi	$a3, $s4, 0
addi	$a2, $s2, 0
la	$a0, log2
jal	INIT_ARRAY
lw	$a1, displayAddress
addi	$a1, $a1, 1024
jal	DRAW_ARRAY


jal	DRAW_SAFE
jal	DRAW_FROG
jal 	DRAW_LIVES


addi	$v1, $zero, 3
addi	$t7, $zero, 0
LEVEL_ONE:	beq	$v1, 0, DEATH
# Shift obstacles
# car1
la	$a0, car1
jal	SHIFT_ARRAY_LEFT
la	$a0, car1
addi	$a3, $s0, 0
addi	$a2, $s5, 0
lw	$a1, displayAddress
addi	$a1, $a1, 3072
jal	DRAW_ARRAY
# car2
la	$a0, car2
jal	SHIFT_ARRAY_RIGHT
la	$a0, car2
addi	$a3, $s0, 0
addi	$a2, $s5, 0
lw	$a1, displayAddress
addi	$a1, $a1, 2560
jal	DRAW_ARRAY
# log1
la	$a0, log1
jal	SHIFT_ARRAY_LEFT
la	$a0, log1
addi	$a3, $s4, 0
addi	$a2, $s2, 0
lw	$a1, displayAddress
addi	$a1, $a1, 1536
jal	DRAW_ARRAY
# log2
la	$a0, log2
jal	SHIFT_ARRAY_RIGHT
la	$a0, log2
addi	$a3, $s4, 0
addi	$a2, $s2, 0
lw	$a1, displayAddress
addi	$a1, $a1, 1024
jal	DRAW_ARRAY

# MOVE FROG
			lw 	$t0, 0xffff0000		
			beq 	$t0, 1, MOVE_DETECTED
			j	NO_MOVE
MOVE_DETECTED:		jal	MOVE_FROG
			jal	DRAW_SAFE2
			jal	DRAW_FROG
NO_MOVE:		jal	DRAW_FROG

#jal	CHECK_COLL_RED
#jal	CHECK_COLL_BLUE
jal	CHECK_WIN
jal	DRAW_LIVES

beq	$t7, 3, LEVEL_RESET

beq	$v1, 3, FULL_LIFE
beq	$v1, 2, TWO_LIFE
beq	$v1, 1, ONE_LIFE
FULL_LIFE:
# WAIT 1 SECOND
li $v0, 32
li $a0, 1000
syscall
j 	LEVEL_ONE

TWO_LIFE:
# WAIT .8 SECOND
li $v0, 32
li $a0, 800
syscall
j 	LEVEL_ONE

ONE_LIFE:
# WAIT .6 SECOND
li $v0, 32
li $a0, 600
syscall
j 	LEVEL_ONE

# Reset between levels
LEVEL_RESET:	jal	RESTART
		addi	$a3, $s6, 0
		lw	$a1, displayAddress
		addi	$a1, $a1, 512
		jal	DRAW_ROW

LEVEL_TWO:	beq	$v1, 0, DEATH
# Shift obstacles
# car1
la	$a0, car1
jal	SHIFT_ARRAY_LEFT
la	$a0, car1
addi	$a3, $s0, 0
addi	$a2, $s5, 0
lw	$a1, displayAddress
addi	$a1, $a1, 3072
jal	DRAW_ARRAY
# car2
la	$a0, car2
jal	SHIFT_ARRAY_RIGHT
la	$a0, car2
addi	$a3, $s0, 0
addi	$a2, $s5, 0
lw	$a1, displayAddress
addi	$a1, $a1, 2560
jal	DRAW_ARRAY
# log1
la	$a0, log1
jal	SHIFT_ARRAY_LEFT
la	$a0, log1
addi	$a3, $s4, 0
addi	$a2, $s2, 0
lw	$a1, displayAddress
addi	$a1, $a1, 1536
jal	DRAW_ARRAY
# log2
la	$a0, log2
jal	SHIFT_ARRAY_RIGHT
la	$a0, log2
addi	$a3, $s4, 0
addi	$a2, $s2, 0
lw	$a1, displayAddress
addi	$a1, $a1, 1024
jal	DRAW_ARRAY

# MOVE FROG
			lw 	$t0, 0xffff0000		
			beq 	$t0, 1, MOVE_DETECTED2
			j	NO_MOVE2
MOVE_DETECTED2:		jal	MOVE_FROG
			jal	DRAW_SAFE2
			jal	DRAW_FROG
NO_MOVE2:		jal	DRAW_FROG

jal	CHECK_COLL_RED
jal	CHECK_COLL_BLUE
jal	CHECK_WIN
jal	DRAW_LIVES

beq	$t7, 3, LEVEL_TWO

FULL_LIFE2:
# WAIT .7 SECOND
li $v0, 32
li $a0, 700
syscall
j 	LEVEL_TWO

TWO_LIFE2:
# WAIT .5 SECOND
li $v0, 32
li $a0, 500
syscall
j 	LEVEL_TWO

ONE_LIFE2:
# WAIT .3 SECOND
li $v0, 32
li $a0, 300
j 	LEVEL_TWO

DEATH:			jal	DRAW_DEATH_SCREEN

PLAY_END:		
			lw 	$t1, 0xffff0000		
			beq 	$t1, 1, EVAL
			j	PLAY_END
EVAL:			lw 	$t0, 0xffff0004
C_PLAY_AGAIN:		beq 	$t0, 0x77, PLAY_AGAIN
			beq 	$t0, 0x73, Exit
PLAY_AGAIN:		

jal	RESTART

jal	DRAW_SAFE
jal	DRAW_FROG
jal 	DRAW_LIVES

addi	$v1, $zero, 3
addi	$t7, $zero, 0
j	LEVEL_ONE
			
			# WAIT .4 SECOND
			li $v0, 32
			li $a0, 400
			syscall
			j	PLAY_END

Exit:
li $v0, 10 # terminate the program gracefully
syscall

##################################################################################
# DRAWING
##################################################################################

# Draws a column of 4 pixels at the specified location
# $a1 = start of column, $a3 = color

DRAW_COL:		addi 	$sp, $sp, -4       	# move stack pointer by a word
			sw 	$ra, 0($sp) 		# save the return address for this procedure on the stack
			
			addi	$t1, $zero, 4		# $t1 = number of pixels, n
			
DRAW_COL_LOOP:		beq	$t1, $zero, COL_EXIT 	# finish loop when n = 0
			sw	$a3, ($a1)
			addi	$a1, $a1, 128
			addi	$t1, $t1, -1
			j	DRAW_COL_LOOP
			
COL_EXIT:		lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra			

# $a1 = location, $a3 = color			
DRAW_SQUARE:		addi 	$sp, $sp, -4       	# move stack pointer by a word
			sw 	$ra, 0($sp) 		# save the return address for this procedure on the stack
			
			addi	$t9, $a1, 0		# save $a1
			
			addi	$t2, $a1, 0		# first column
			addi	$t3, $a1, 4		# second column
			addi	$t4, $t3, 4		# third column
			addi	$t5, $t4, 4		# fourth column
			
			addi	$a1, $t2, 0		# draw first column
			jal	DRAW_COL
			addi	$a1, $t3, 0		# draw second column
			jal	DRAW_COL
			addi	$a1, $t4, 0		# draw third column
			jal	DRAW_COL
			addi	$a1, $t5, 0		# draw fourth column
			jal	DRAW_COL
			
			addi	$a1, $t9, 0
			
			lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra

DRAW_SAFE:		addi 	$sp, $sp, -4       	# move stack pointer by a word
			sw 	$ra, 0($sp) 		# save the return address for this procedure on the stack
						
			la 	$a3, ($s6)			# set color to yellow
			lw 	$a1, displayAddress
			addi 	$a1, $a1, 512
			jal 	DRAW_ROW
			la 	$a3, ($s1)			# set color to green
			lw 	$a1, displayAddress
			addi 	$a1, $a1, 2048
			jal 	DRAW_ROW
			lw 	$a1, displayAddress
			addi 	$a1, $a1, 3584
			jal 	DRAW_ROW
			
			lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra
			
DRAW_LIVES:		addi 	$sp, $sp, -4       	# move stack pointer by a word
			sw 	$ra, 0($sp) 		# save the return address for this procedure on the stack
			
			lw	$a1, displayAddress
			la 	$a3, ($s5)		# set color to black
			jal	DRAW_ROW
			la 	$a3, ($s7)		# set color to magenta
			lw	$a1, displayAddress
			lw	$t1, lives
			
D_LIVES_LOOP:		beq	$t1, 0, D_LIVES_EXIT   # draw for number of lives
			sw	$a3, ($a1)
			addi	$a1, $a1, 8
			addi	$t1, $t1, -1
			j	D_LIVES_LOOP
			
D_LIVES_EXIT:		lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra

# Only draw bottom 2 safe rows		
DRAW_SAFE2:		addi 	$sp, $sp, -4       	# move stack pointer by a word
			sw 	$ra, 0($sp) 		# save the return address for this procedure on the stack
						
			la 	$a3, ($s1)		# set color to green
			lw 	$a1, displayAddress
			addi 	$a1, $a1, 2048
			jal 	DRAW_ROW
			lw 	$a1, displayAddress
			addi 	$a1, $a1, 3584
			jal 	DRAW_ROW
			
			lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra
# Draw a single row
# $a1 = drawing row location
DRAW_ROW:	addi 	$sp, $sp, -4 		# move stack pointer by a word
		sw 	$ra, 0($sp) 		# save the return address for this procedure on the stack
		addi 	$t6, $zero, 8 		# initialize number of squares n = 8
ROW_WHILE:	beq	$t6, $zero, ROW_EXIT	# finish loop when n = 0
		jal	DRAW_SQUARE		# draw square at current $a0 position
		addi	$a1, $a1, 16		# increment $a2 by one square or 16
		addi	$t6, $t6, -1		# decrement n by 1
		j ROW_WHILE
ROW_EXIT:	lw 	$ra, 0($sp)    		# load the return address
		addi 	$sp, $sp, 4  		# move stack pointer back
		jr	$ra
		
DRAW_DEATH_SCREEN:	addi 	$sp, $sp, -4 		# move stack pointer by a word
			sw 	$ra, 0($sp) 		# save the return address for this procedure on the stack
		
			lw	$a1, displayAddress
			addi	$a3, $s0, 0
			jal	DRAW_ROW
			# WAIT .4 SECOND
			li $v0, 32
			li $a0, 400
			syscall
			addi	$a1, $a1, 512
			jal	DRAW_ROW
			# WAIT .4 SECOND
			li $v0, 32
			li $a0, 400
			syscall
			addi	$a1, $a1, 512
			jal	DRAW_ROW
			# WAIT .4 SECOND
			li $v0, 32
			li $a0, 400
			syscall
			addi	$a1, $a1, 512
			jal	DRAW_ROW
			# WAIT .4 SECOND
			li $v0, 32
			li $a0, 400
			syscall
			addi	$a1, $a1, 512
			jal	DRAW_ROW
			# WAIT .4 SECOND
			li $v0, 32
			li $a0, 400
			syscall
			addi	$a1, $a1, 512
			jal	DRAW_ROW
			# WAIT .4 SECOND
			li $v0, 32
			li $a0, 400
			syscall
			addi	$a1, $a1, 512
			jal	DRAW_ROW
			# WAIT .4 SECOND
			li $v0, 32
			li $a0, 400
			syscall
			addi	$a1, $a1, 512
			jal	DRAW_ROW
			# WAIT .4 SECOND
			li $v0, 32
			li $a0, 400
			syscall
			
			lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra
			

##################################################################################
# ARRAYS
##################################################################################

ARRAY_TEST:		addi 	$sp, $sp, -4       		# move stack pointer by a word
			sw 	$ra, 0($sp) 			# save the return address for this procedure on the stack
			
			la	$t1, car1
			lw	$t2, color1
			add	$t3, $t1, $zero
			sw	$t2, 0($t3)
			
			lw 	$ra, 0($sp)    			# load the return address
			addi 	$sp, $sp, 4  			# move stack pointer back
			jr	$ra

# Initializes an obstacle array
# $a0 = array address
INIT_ARRAY:		addi 	$sp, $sp, -4       		# move stack pointer by a word
			sw 	$ra, 0($sp) 			# save the return address for this procedure on the stack
			
			addi	$t1, $a0, 0			# $t1 holds address of array
			addi 	$t1, $t1, 16			# $t1 holds address + 16 (first obst start)
			addi	$t2, $zero, 0			# counter holds 0
			addi	$t3, $zero, 1			# $t3 holds 1
			
ARRINIT_LOOP1:		beq	$t2, 32, ARRINIT_LOOP_TRANS	# loop to draw first obst
			sw	$t3, 0($t1)			# store $t3 in address $t1
			addi	$t1, $t1, 4
			addi	$t2, $t2, 4
			j	ARRINIT_LOOP1

ARRINIT_LOOP_TRANS:	addi	$t1, $a0, 0			# $t1 holds address of array 
			addi 	$t1, $t1, 80			# $t1 holds address + 80 (second obst start)
			addi	$t2, $zero, 0			# counter holds 0

ARRINIT_LOOP2:		beq	$t2, 32, ARRINIT_EXIT		# loop to draw second obst
			sw	$t3, 0($t1)
			addi	$t1, $t1, 4
			addi	$t2, $t2, 4
			j	ARRINIT_LOOP2
			
ARRINIT_EXIT:		lw 	$ra, 0($sp)    			# load the return address
			addi 	$sp, $sp, 4  			# move stack pointer back
			jr	$ra

# Shifts an array left
# $a0 = array address
SHIFT_ARRAY_LEFT:	addi 	$sp, $sp, -4       		# move stack pointer by a word
			sw 	$ra, 0($sp) 			# save the return address for this procedure on the stack
			
			addi	$t1, $a0, 0			# $t1 holds address of array
			addi	$t2, $zero, 0			# counter holds 0
			lw	$t9, 0($t1)			# hold onto first element of array to loop around
SHIFT_LEFT_LOOP:	beq	$t2, 124, SHIFT_LEFT_END	# loop until second last element
			addi	$t3, $t1, 4			# $t3 holds the address of the next element
			lw	$t4, 0($t3)			# $t4 holds the next element
			sw	$t4, 0($t1)
			
			addi	$t1, $t1, 4
			addi	$t2, $t2, 4
			j	SHIFT_LEFT_LOOP

SHIFT_LEFT_END:		addi	$t1, $t1, 4
			sw	$t9, 0($t1)
			lw 	$ra, 0($sp)    			# load the return address
			addi 	$sp, $sp, 4  			# move stack pointer back
			jr	$ra

# Shifts an array right
# $a0 - array address
SHIFT_ARRAY_RIGHT:	addi 	$sp, $sp, -4       		# move stack pointer by a word
			sw 	$ra, 0($sp) 			# save the return address for this procedure on the stack
			
			addi	$t1, $a0, 124			# $t1 holds address of array
			addi	$t2, $zero, 0			# counter holds 0
			lw	$t9, 0($t1)			# hold onto first element of array to loop around
SHIFT_RIGHT_LOOP:	beq	$t2, 124, SHIFT_RIGHT_END	# loop until second last element
			addi	$t3, $t1, -4			# $t3 holds the address of the next element
			lw	$t4, 0($t3)			# $t4 holds the next element
			sw	$t4, 0($t1)
			
			addi	$t1, $t1, -4
			addi	$t2, $t2, 4
			j	SHIFT_RIGHT_LOOP

SHIFT_RIGHT_END:	addi	$t1, $t1, -4
			sw	$t9, 0($t1)
			lw 	$ra, 0($sp)    			# load the return address
			addi 	$sp, $sp, 4  			# move stack pointer back
			jr	$ra

# Draws an array
# $a0 = array address, $a1 = row reference, $a2 = bg color, $a3 = obst color
DRAW_ARRAY:		addi 	$sp, $sp, -4       		# move stack pointer by a word
			sw 	$ra, 0($sp) 			# save the return address for this procedure on the stack
			
			addi	$t2, $a1, 0			# $t2 holds drawing position
			addi	$t3, $a0, 0			# $t3 holds array address
			addi	$t4, $zero, 0			# $t4 holds loop var i
			
ARRDRAW_LOOP:		beq	$t4, 128, ARRDRAW_EXIT		# exit when $t4 = 128
			lw	$t5, 0($t3)
ARRDRAW_OBST:		beq	$t5, 0, ARRDRAW_BG		# if branch: if $t5 != 0
			addi	$a1, $t2, 0
			jal	DRAW_COL
			j	ARRDRAW_UPDATE			# skip else branch
			
ARRDRAW_BG:		addi	$a1, $t2, 0			# else branch: if $t5 == 0
			addi	$t6, $a3, 0			# temporarily store $a3
			addi	$a3, $a2, 0			# change color to bg color
			jal	DRAW_COL
			addi	$a3, $t6, 0			# change $a3 back to obst color

ARRDRAW_UPDATE:		addi	$t2, $t2, 4
			addi	$t3, $t3, 4
			addi	$t4, $t4, 4
			j	ARRDRAW_LOOP

ARRDRAW_EXIT:		lw 	$ra, 0($sp)    			# load the return address
			addi 	$sp, $sp, 4  			# move stack pointer back
			jr	$ra
			
##################################################################################
# FROG
##################################################################################

# Draw the frog at the current X and Y location
DRAW_FROG:	addi 	$sp, $sp, -4		# move stack pointer by a word
		sw	$ra, 0($sp)		# save the return address for this procedure on the stack
		lw	$t5, displayAddress
		lw	$t1, frogX
		lw	$t2, frogY
		add	$t6, $t5, $t1
		add	$t5, $t6, $t2
		sw	$s3, 0($t5)		# start drawing top
		addi	$t5, $t5, 12
		sw	$s3, 0($t5)		# draw a single pixel
		addi	$t5, $t5, 116		# go to midsection 1
		sw	$s3, 0($t5)		# start drawing midsection 1
		addi	$t5, $t5, 4
		sw	$s3, 0($t5)		# draw a single pixel
		addi	$t5, $t5, 4
		sw	$s3, 0($t5)		# draw a single pixel
		addi	$t5, $t5, 4
		sw	$s3, 0($t5)		# draw a single pixel
		addi	$t5, $t5, 120		# go to midsection 2
		sw	$s3, 0($t5)		# draw a single pixel
		addi	$t5, $t5, 4
		sw	$s3, 0($t5)		# draw a single pixel
		addi	$t5, $t5, 120		# go to bottom
		sw	$s3, 0($t5)		# draw a single pixel
		addi	$t5, $t5, 4
		sw	$s3, 0($t5)		# draw a single pixel
		addi	$t5, $t5, 4
		sw	$s3, 0($t5)		# draw a single pixel
		addi	$t5, $t5, 4
		sw	$s3, 0($t5)		# draw a single pixel
		lw 	$ra, 0($sp)    		# load the return address
		addi 	$sp, $sp, 4  		# move stack pointer back
		jr	$ra
	
# Move right (a)
MOVE_FROG:		addi 	$sp, $sp, -4		# move stack pointer by a word
			sw	$ra, 0($sp)		# save the return address for this procedure on the stack
			
INPUT:			lw 	$t0, 0xffff0004
			beq 	$t0, 0x64, MOVE_RIGHT
			beq 	$t0, 0x61, MOVE_LEFT
			beq 	$t0, 0x77, MOVE_UP
			beq 	$t0, 0x73, MOVE_DOWN
			j	MOVE_FROG_EXIT
			
MOVE_RIGHT:		la 	$t1, frogX 
			lw 	$t2, frogX
			addi 	$t2, $t2, 16
			sw 	$t2, 0($t1)
			j	MOVE_FROG_EXIT

MOVE_LEFT:		la 	$t1, frogX 
			lw 	$t2, frogX
			addi 	$t2, $t2, -16
			sw 	$t2, 0($t1)
			j	MOVE_FROG_EXIT
			
MOVE_UP:		la $t1, frogY 
			lw $t2, frogY
			addi $t2, $t2, -512
			sw $t2, 0($t1)
			j	MOVE_FROG_EXIT

MOVE_DOWN:		la $t1, frogY 
			lw $t2, frogY
			addi $t2, $t2, 512
			sw $t2, 0($t1)
			j	MOVE_FROG_EXIT
			
MOVE_FROG_EXIT:		lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra


##################################################################################
# COLLISION DETECTION AND WINNING
##################################################################################

RESTART:		addi 	$sp, $sp, -4		# move stack pointer by a word
			sw	$ra, 0($sp)		# save the return address for this procedure on the stack
			
			# reset frogX and frogY
			la 	$t1, frogX		
			la 	$t2, frogY
			addi	$t3, $zero, 64
			sw	$t3, 0($t1)
			addi	$t3, $zero, 3584
			sw	$t3, 0($t2)
			# set wins to 0
			la	$t1, wins
			addi	$t2, $zero, 0
			sw	$t2, 0($t1)
			addi	$t7, $zero, 0		# win counter = 0
			# set lives to 3
			la	$t1, lives
			addi	$t2, $zero, 3
			sw	$t2, 0($t1)
			addi	$v1, $v1, 3
			
			lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra

RESTART_WIN:		addi 	$sp, $sp, -4		# move stack pointer by a word
			sw	$ra, 0($sp)		# save the return address for this procedure on the stack
			
			# reset frogX and frogY
			la 	$t1, frogX		
			la 	$t2, frogY
			addi	$t3, $zero, 64
			sw	$t3, 0($t1)
			addi	$t3, $zero, 3584
			sw	$t3, 0($t2)
			# increment wins by 1
			la	$t1, wins
			lw	$t2, wins
			addi	$t2, $t2, 1
			sw	$t2, 0($t1)
			addi	$t7, $t7, 1		# increment win counter
			
			lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra

RESTART_DEATH:		addi 	$sp, $sp, -4		# move stack pointer by a word
			sw	$ra, 0($sp)		# save the return address for this procedure on the stack
			
			lw	$a1, displayAddress
			lw	$t1, frogX
			lw	$t2, frogY
			add	$t6, $a1, $t1
			add	$a1, $t6, $t2				
			addi	$a3, $s7, 0
			add	$a1, $zero, $a1
			addi	$t8, $a1, 0
			jal	DRAW_SQUARE
			# WAIT .1 SECOND
			li $v0, 32
			li $a0, 100
			syscall
			addi	$a3, $s3, 0
			add	$a1, $zero, $t9
			jal	DRAW_SQUARE
			# WAIT .1 SECOND
			li $v0, 32
			li $a0, 100
			syscall
			addi	$a3, $s7, 0
			add	$a1, $zero, $t9
			jal	DRAW_SQUARE
			# WAIT .1 SECOND
			li $v0, 32
			li $a0, 100
			syscall
			addi	$a3, $s3, 0
			add	$a1, $zero, $t9
			jal	DRAW_SQUARE
			# WAIT .1 SECOND
			li $v0, 32
			li $a0, 100
			syscall
			# reset frogX and frogY
			la 	$t1, frogX		
			la 	$t2, frogY
			addi	$t3, $zero, 64
			sw	$t3, 0($t1)
			addi	$t3, $zero, 3584
			sw	$t3, 0($t2)
			# decrement lives by 1
			la	$t1, lives
			lw	$t2, lives
			addi	$t2, $t2, -1
			sw	$t2, 0($t1)
			
			lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra

# Check for collision with red (vehicles)
CHECK_COLL_RED:		addi 	$sp, $sp, -4		# move stack pointer by a word
			sw	$ra, 0($sp)		# save the return address for this procedure on the stack
			
			lw	$t0, displayAddress	# load displayAddress
			lw	$t1, frogX		# get frogX
			lw	$t2, frogY		# get frogY
			addi	$t1, $t1, 16		# increment $t1 by 1 pixel
			add	$t0, $t0, $t1
			add	$t0, $t0, $t2
			lw	$t3, ($t0)
			beq	$t3, $s0, COLL_RED_T	# if the pixel is red, then there is a collision
			j	COLL_RED_EXIT
COLL_RED_T:		addi	$v1, $v1, -1
			jal	RESTART_DEATH
			
COLL_RED_EXIT:		lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra

# Check for collision with blue (water)		
CHECK_COLL_BLUE:	addi 	$sp, $sp, -4		# move stack pointer by a word
			sw	$ra, 0($sp)		# save the return address for this procedure on the stack
			
			lw	$t0, displayAddress	# load displayAddress
			lw	$t1, frogX		# get frogX
			lw	$t2, frogY		# get frogY
			addi	$t1, $t1, 16		# increment $t1 by 1 pixel
			add	$t0, $t0, $t1
			add	$t0, $t0, $t2
			lw	$t3, ($t0)
			beq	$t3, $s2, COLL_BLUE_T	# if the pixel is red, then there is a collision
			j	COLL_RED_EXIT
COLL_BLUE_T:		addi	$v1, $v1, -1
			jal	RESTART_DEATH
			
COLL_BLUE_EXIT:		lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra

CHECK_WIN:		addi 	$sp, $sp, -4		# move stack pointer by a word
			sw	$ra, 0($sp)		# save the return address for this procedure on the stack		
			
			lw	$t2, frogY		# get frogY
			bne	$t2, 512, C_WIN_EXIT	# branch if not win
			jal	RESTART_WIN 
			
C_WIN_EXIT:		lw 	$ra, 0($sp)    		# load the return address
			addi 	$sp, $sp, 4  		# move stack pointer back
			jr	$ra
			

