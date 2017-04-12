###################################################################
#
# This is a snek game made to be played by people playing the game. 
#
# Please be aware that this is not a real snek, just a few pixels behaving in no way similar to a snek... they don't even eat fruit...

.data

screenLen:   .word 256			#number of pixels in the screen in x or y direction


#Colors
snekColor: 	.word	0x3cb371	# ugly snek green
backgroundColor:.word	0x654321	# broon
borderColor:    .word   0xff0000	# angry red lava scary borderness
fruitColor: 	.word	0xe51be2	#fruits? seriously what kind of snake eats fruits? there are no omnivorous snakes...

startAddress:   .word 0x10010004 	# the first pixel to be changed
endAddress:     .word 0x10080000 	# until this pixel
colorWhite:     .word 0x0000ff00 	# change to green

fruitPositionX: .word
fruitPositionY: .word


.text
main:
	#  COLORS
	lw $a0, screenLen
	lw $s4, borderColor	# Temporary
	lw $s5, fruitColor	# Fruit color always s5
	lw $s6, snekColor 	# ***Snek color always in s6***
	lw $s7, backgroundColor	# Background color always in s7
	
	mul $a2, $a0, $a0 #total number of pixels on screen
	div $a2, $a2, 16
	add $a2, $a2, $gp #add base of gp
	add $a0, $gp, $zero #loop counter
	
FillBackground:
	beq $a0, $a2, DrawBorder
	sw $s7, 0($a0) #previously a1
	addiu $a0, $a0, 4 
	j FillBackground
	
DrawBorder:
	add $a0, $gp, $zero	# loop counter (aka that^^^)
	sw $t3, ($a0)		# sets t3 to beginning of display
	li $t1, 0
	li $t2, 256
	subiu $t4, $a2, 128 #this is where the vertical borders stop (1 line above bottom in order to draw bottom border)
	TopBorderLoop:
		beq $t1, $t2, VerticalBorderLoop
		sw $s4, ($a0)
		addiu $t1, $t1, 8 #this adds 8 because each dot is 8 pixel
		addiu $a0, $a0, 4 #this adds 4 for memory incrimentation because its bytes
		j TopBorderLoop
		
	VerticalBorderLoop: #picks up after top border is drawn
		li $t1, 0
		li $t2, 256
		innerloop:
			beq $a0, $t4, BottomBorderLoop
			sw $s4, ($a0)
			addiu $a0, $a0, 124 #this adds 4 for memory incrimentation because its bytes
			sw $s4, ($a0) 
			addiu $a0, $a0, 4
			j innerloop

		
	BottomBorderLoop: #picks up after vertical borders are drawn
		beq $t1, $t2, fruitIGuess
		sw $s4, ($a0)
		addiu $t1, $t1, 8 #this adds 8 because each dot is 8 pixel
		addiu $a0, $a0, 4 #this adds 4 for memory incrimentation because its bytes
		j BottomBorderLoop

		
fruitIGuess:
	li $v0, 42         	# Service 41, random int
	li $a1, 1020		# upper bounds, will be multiplied by 4 to make sure its divisible by 4 for storage purposes 
	xor $a0, $a0, $a0  	# Select random generator 0
	syscall            	# Generate random int (returns in $a0)
	
	add $s2, $a0, 128	# adds 128 so it wont spawn on top row
	mul $a0, $a0, 4		# multiplies by 4 to make sure the address is valid
	add $a0, $a0, $gp	# adds random number to gp for fruit
	
	lw $t5, 0($a0) 			# Should set t5 to be equal to the info at a0 (should either be brown or red based upon placement)
	beq $t5, $s4, fruitIGuess
	
	sw $s5, 0($a0)		# plots the plot to the plot
	j Snek
	
Snek:

	add $a0, $gp, 1600 		
	sw $s6, ($a0)
	add $a0, $a0, 128		
	sw $s6, ($a0)
	add $a0, $a0, 128		
	sw $s6, ($a0)
	j Init
	
Input:
	addi $s0, $zero, 113
	lui $t0, 0xFFFF
	waitloop:
		lw $t1, 0($t0)
		andi $t1, $t1, 0x0001
		beq $t1, $zero, waitloop 
		
		lw $a0, 4($t0)
		beq $a0, $s0, Init 
		li $v0,1
		syscall
		j waitloop
	
	
Init:
	
	li $v0, 10
	syscall		# exit






	
	
	
	
	
	
	
	
	
