#VERSION3##################################################################### 
# 
# CSCB58 Winter 2021 Assembly Final Project # University of Toronto, Scarborough
 # 
# Student: PRITISH PANDA, 1005970914, pandapri

 # Bitmap Display Configuration: 
 # - Unit width in pixels: 8 
 # - Unit height in pixels: 8 
 # - Display width in pixels: 256 
 # - Display height in pixels: 256
 # - Base Address for Display: 0x10008000 ($gp) 
 #
 # Which milestones have been reached in this submission? 
 # (See the assignment handout for descriptions of the milestones) 
 # - Milestone 4
 # 
 # Which approved features have been implemented for milestone 4? 
 # (See the assignment handout for the list of additional features) 
 # 1. Pickups: Ship repair and make everything slower
 # 2. Smooth graphics: erasing and/or redrawing only the parts of spaceship and obstacles to the frame buffer that have changed.
 # 3. Increase in difficulty as game progresses: Increase game speed and then no.of obstacles after some time.
 #
 # 
 # Link to video demonstration for final submission: 
 # - https://play.library.utoronto.ca/0850861a57349ecd56b18465428ed0f8 
 # 
 # Are you OK with us sharing the video with people outside course staff?
  # - no! 
  # 
  # Any additional information that the TA needs to know: 
  # - (write here, if any) 
  #
  
   #####################################################################
 .eqv BASE_ADDRESS 0x10008000 
 .eqv WIDTH 32
 .eqv HEIGHT 32
 .eqv ROW_SHIFT 128
 .eqv RED 0xff0000
 .eqv BLUE 0x0000ff
 .eqv ORANGE 0x00ff9900 
 .eqv WHITE 0x00FFFFFF
 .eqv GREY 0x00CCCCCC
 .eqv BLACK 0x000000
 .eqv YELLOW 0x00FFFF00
 .eqv PINK 0x00FF00CC
 .eqv SLOW_OBST_RATE 14
 .eqv SLOW_TIME 5
 
 .data
 loc_ship: .word BASE_ADDRESS
 ship_post: .word 1,2
 .align 2
 loc_obstacles: .space 40
 obst_type: .word 0:10
 no_of_obst: .word 0  # stores the address diviation no_of_obst*4
 obst_post: .word 0:20
 no_of_iteration: .word 0
 no_of_collision: .word 0
time_passed: .word 0
sleep_rate: .word 60  # 40 --100   (60)
difficulty_level: .word 0 # 0-3(increase speed)-6(increase no_of obstacles on screen)
current_sleep_rate: .word 60
OBST_RATE: .word 30 # 30  (20, blink =4)
BLINK_RATE: .word 6  #3,   -6- ,10
 .globl main
 .text 
 
 HEALTH_BAR:
 	li $t0, BASE_ADDRESS
 	addi $t0,$t0,80
 	li $t1, GREY
 	li $t3, PINK
 	
 	la $t4, no_of_collision
 	lw $t4,($t4)
 	
 	li $t5,12# 10
 	sub $t5,$t5,$t4
 	li $t4,1
 	
 HEALTH_LOOP:	beq $t5,$t4, REMOVE_HEALTH
 	sw $t3, ($t0)
 	addi $t0,$t0,4
 	addi $t4,$t4,1
 	j HEALTH_LOOP
 REMOVE_HEALTH:
 	li $t5,12
 REMOVE_HEALTH_LOOP:beq $t5,$t4,END_HEALTH
          sw $t1, ($t0)
 	addi $t0,$t0,4
 	addi $t4,$t4,1	
 	j REMOVE_HEALTH_LOOP
 END_HEALTH:	jr $ra
 	
 GAME_OVER:
 
 	li $t0, BASE_ADDRESS # $t0 stores the base address for display 
 	li $t1, WHITE # $t1 STORES HWITE
 	addi $t0,$t0,1552
 	# print G
 	sw $t1, ($t0)
 	sw $t1, -256($t0)
 	sw $t1, -128($t0)
 	sw $t1, 128($t0)
 	sw $t1, 256($t0)
 	
 	sw $t1, -252($t0)
 	sw $t1, -248($t0)
 	sw $t1, -244($t0)
 	sw $t1, -240($t0)
 	
 	sw $t1, 260($t0)
 	sw $t1, 264($t0)
 	sw $t1, 268($t0)
 	sw $t1, 272($t0)
 	
 	sw $t1, 144($t0)
 	sw $t1, 16($t0)
 	 sw $t1, 12($t0)
 	 sw $t1, 8($t0)
 	 
 	 #print a
        addi $t0,$t0,280
 	 sw $t1, ($t0)
 	 sw $t1, -128($t0)
 	 sw $t1, -256($t0)
 	 sw $t1, -384($t0)
 	 sw $t1, -512($t0)
 	 sw $t1, -508($t0)
 	 sw $t1, -504($t0)
 	 sw $t1, -500($t0)
 	 sw $t1, -496($t0)
 	 
 	 sw $t1, -368($t0)
 	 sw $t1, -240($t0)
 	 
 	 sw $t1, -244($t0)
 	 sw $t1, -248($t0)
 	 sw $t1, -252($t0)
 	 sw $t1, -256($t0)
 	 sw $t1, -112($t0)
 	 sw $t1, 16($t0)
 	 
 	 #print m
 	 addi $t0,$t0,24
 	 sw $t1,($t0)
 	  sw $t1, -128($t0)
 	 sw $t1, -256($t0)
 	 sw $t1, -384($t0)
 	 sw $t1, -512($t0)
 	 sw $t1, -508($t0)
 	 sw $t1, -504($t0)
 	  sw $t1, -376($t0)
 	  sw $t1, -248($t0)
 	  sw $t1, -120($t0)
 	  sw $t1, 8($t0)
 	 sw $t1, -500($t0)
 	 sw $t1, -496($t0)
 	 
 	  sw $t1, -368($t0)
 	 sw $t1, -240($t0)
 	  sw $t1, -112($t0)
 	 sw $t1, 16($t0)
 	
 	#print e
 	addi $t0,$t0,24
 	sw $t1,($t0)
 	  sw $t1, -128($t0)
 	 sw $t1, -256($t0)
 	    sw $t1, -252($t0)
 	    sw $t1, -248($t0)
 	    sw $t1, -244($t0)
 	    sw $t1, -240($t0)
 	 sw $t1, -384($t0)
 	 sw $t1, -512($t0)
 	 
 	 sw $t1, -508($t0)
 	 sw $t1, -504($t0)
 	 sw $t1, -500($t0)
 	 sw $t1, -496($t0)
 	 
 	  sw $t1, 4($t0)
 	  sw $t1, 8($t0)
 	  sw $t1, 12($t0)
 	  sw $t1, 16($t0)
 	
 	# print o
 	li $t0, BASE_ADDRESS
 	addi $t0,$t0,2704
 	 sw $t1,($t0)
 	  sw $t1, -128($t0)
 	 sw $t1, -256($t0)
 	 sw $t1, -384($t0)
 	 sw $t1, -512($t0)
 	  sw $t1, -508($t0)
 	 sw $t1, -504($t0)
 	 sw $t1, -500($t0)
 	 sw $t1, -496($t0)
 	  sw $t1, -368($t0)
 	 sw $t1, -240($t0)
 	 sw $t1, -112($t0)
 	 sw $t1, 16($t0)
 	 sw $t1, 12($t0)
 	 sw $t1, 8($t0)
 	 sw $t1, 4($t0)
 	 
 	 #print v
 	 addi $t0,$t0,24
 	 sw $t1,8($t0)
 	 sw $t1, -124($t0)
 	 sw $t1, -256($t0)
 	  sw $t1, -384($t0)
 	 sw $t1, -512($t0)
 	 
 	 sw $t1, -496($t0)
 	 sw $t1, -368($t0)
 	 sw $t1, -240($t0)
 	  sw $t1, -116($t0)
 	  
 	 #print e
 	addi $t0,$t0,24
 	sw $t1,($t0)
 	  sw $t1, -128($t0)
 	 sw $t1, -256($t0)
 	    sw $t1, -252($t0)
 	    sw $t1, -248($t0)
 	    sw $t1, -244($t0)
 	    sw $t1, -240($t0)
 	 sw $t1, -384($t0)
 	 sw $t1, -512($t0)
 	 
 	 sw $t1, -508($t0)
 	 sw $t1, -504($t0)
 	 sw $t1, -500($t0)
 	 sw $t1, -496($t0)
 	 
 	  sw $t1, 4($t0)
 	  sw $t1, 8($t0)
 	  sw $t1, 12($t0)
 	  sw $t1, 16($t0)
 	  
 	  #print R
 	  addi $t0,$t0,24
 	  sw $t1,($t0)
 	  sw $t1, -128($t0)
 	 sw $t1, -256($t0)
 	 sw $t1, -384($t0)
 	 sw $t1, -512($t0)
 	  sw $t1, -508($t0)
 	 sw $t1, -504($t0)
 	 sw $t1, -500($t0)
 	 sw $t1, -496($t0)
 	  sw $t1, -368($t0)
 	 
 	  sw $t1, -252($t0)
 	  sw $t1, -124($t0)
 	  sw $t1, -248($t0)
 	  sw $t1, 8($t0)
 	   sw $t1, -244($t0)
 	   sw $t1, -240($t0)
 	 
 	 
 	la $t8,no_of_collision
	sw $zero,($t8)
 	jr $ra
 	
 clear_screen:
 	li $t0, BASE_ADDRESS # $t0 stores the base address for display 
 	li $t1, BLACK # $t1 stores the black colour code 
 	li $t2, 0
 	li $t3, 4224
 LOOP: beq $t2,$t3,END_CLEAR
 	add $t4,$t0,$t2
	sw $t1, 0 ($t4)
	addi $t2, $t2, 4
 	j LOOP
 	
END_CLEAR: jr $ra

draw_obst:
# if a2 1 then draw heal_obst
# if stack has 2 draw time_obst
# loop 3 times
	add $t5,$zero,$a1
	la $t8, obst_type # the address of obst_type
	la $t7, no_of_obst # get the address of no_of_obst
	lw $t4, ($t7)
	la $t6, loc_obstacles # get the address of loc_obstcales array
	
	  # update no_of_obst
       lw $t0,($t7)
       addi $t0,$t0, 12
       sw $t0,($t7)
       
	#add $t9,$t9, $t4
	add $t6,$t6,$t4 ########################
	add $t8,$t8,$t4 ########################
LOOP_draw_obst: beq $t4,$t5, END_draw_obst
 
 	# get random number for y axis and store it in $a0
	li $v0, 42 
	li $a0, 1
	li $a1, 30
	syscall
	
	# store the arguments,y-axis value in $t0
	move $t0,$a0
	# get the address of new_obst
	li $t1, 32
	mult $t0,$t1
	mflo $t2
	addi $t2,$t2,30
	li $t1, 4
	mult $t2,$t1
	mflo $t2 
	
	# update the obst_post array
	la $t0, obst_post
        move $t1 ,$t4
        sll $t1,$t1,1
	add $t0, $t0,$t1
	li $t7,30
	sw $t7, ($t0)
	sw $a0,4($t0)
	 
	 
	
	
	li $t0, BASE_ADDRESS # $t0 stores the base address for display 
	add $t2,$t0,$t2 # $t2 stores the adress of obst
       
       # update loc_obstcales array
       sw $t2, ($t6)
       addi $t6, $t6,4
       
       
  
	# get random number for type of obst and store it in $a0
	li $v0, 42 
	li $a0, 0
	li $a1, 4
	syscall
	
 	li $t1, WHITE # $t1 stores the white colour code 
 	li $t3, GREY # $t3 stores the grey colour code 
 SLOW_OBST:
 	lw $t9,($sp)
 	bne $t9,2,HEAL_OBST
	addi $t3,$t5,-4
	bne  $t3,$t4,HEAL_OBST
	addi $sp,$sp,4
	li $t3, YELLOW
 	sw $t3, -4($t2) 
 	sw $t3, -132($t2) 
 	sw $t3, 124($t2) 
 	sw $t3, 128($t2) 
 	sw $t3, 132($t2) 
 	sw $t3, -124($t2)
 	 
 	 li $t1, RED# $t1 stores the RED colour code 
 	 sw $t1, 0($t2) 
 	 sw $t1, -128($t2) 
 	 sw $t1, 4($t2) 
 	li $t1, WHITE # $t1 stores the white colour code 
 	li $t3, GREY
 	li $t9, 3  # type 3
        sw $t9, ($t8) 
        addi $t8,$t8,4 
         addi $t4,$t4,4
         j LOOP_draw_obst
HEAL_OBST:bne $a2,1,IF_draw_obst
	addi $t3,$t5,-8
        bne  $t3,$t4,IF_draw_obst
        
	li $t1,PINK
	sw $t1, 0($t2) 
           sw $t1, -4($t2) 
           sw $t1, 4($t2) 
           sw $t1, -128($t2) 
           sw $t1, 128($t2) 
          # update obst_type array
          
        li $t9, 2 #type 2
        sw $t9, ($t8) 
        addi $t8,$t8,4 
         addi $t4,$t4,4
       	   j LOOP_draw_obst
IF_draw_obst: beqz  $a0 , ELSE_draw_obst
           sw $t1, 0($t2) 
           sw $t1, -4($t2)
           sw $t3, -8($t2)
           sw $t3, 4($t2) 
           sw $t3, -128($t2) 
           sw $t3, -132($t2) 
           sw $t1, 128($t2) 
           sw $t1, 124($t2) 
           sw $t3, 120($t2)
           sw $t3, 132($t2)
           sw $t3, 256($t2)
           sw $t3, 252($t2)
         # update obst_type array
         
       	li $t9, 1
        sw $t9, ($t8) 
        addi $t8,$t8,4     
        	
         addi $t4,$t4,4
         j LOOP_draw_obst
ELSE_draw_obst:
	   sw $t1, 0($t2) 
           sw $t3, -4($t2) 
           sw $t3, 4($t2) 
           sw $t3, -128($t2) 
           sw $t3, 128($t2) 
        # update obst_type array
        sw $zero, ($t8)
        addi $t8,$t8,4 
               
           addi $t4,$t4,4
       	   j LOOP_draw_obst

END_draw_obst: 
	jr $ra

init_spaceship:

	move $t6, $a0 # t6 stores the argument 0 is init , 1 is red 
	la $t0,loc_ship # load address in t5
 	lw $t0, ($t0)
 	addi $t0,$t0,-260
	beq $t6,0,Draw_start_ship
Draw_red:
	li $t1, RED # $t1 stores the BLUE colour code 
 	li $t3, RED# $t3 stores the YELLOW colour code 
 	li $t4, RED # $t1 stores the orange colour code 
 	j  Draw_ship
	
Draw_start_ship:
	
 	li $t1, BLUE # $t1 stores the BLUE colour code 
 	li $t3, YELLOW # $t3 stores the YELLOW colour code 
 	li $t4, ORANGE # $t1 stores the orange colour code 
 	
 Draw_ship:
 	sw $t1, 4($t0) #
 	sw $t4, 128($t0) 
 	sw $t1, 132($t0)
 	sw $t1, 136($t0)
 	sw $t1, 260($t0) # (32*2 +1)
 	sw $t3, 264($t0)
 	sw $t1, 268($t0)
 	sw $t4, 384($t0) # (32*3 +0)*4
 	sw $t1, 388($t0)
 	sw $t1, 392($t0)
 	sw $t1, 516($t0) # (32*4 +1 )*4
        jr $ra
        
up:
	la $t0,loc_ship # load address in t5
	lw $t1,($t0) # t1 stores the adreess of the spaceship
	
	li $t7, BASE_ADDRESS
 	addi $t7,$t7,384
 VALID_UP: blt $t1,$t7, END_UP # makes sure that the space_ship doesnt leave the screen
	
	li $t3, BLUE # $t3 stores the BLUE colour code 
 	li $t4, YELLOW # $t4 stores the YELLOW colour code 
 	li $t5, ORANGE # $t5 stores the orange colour code 
 	li $t6, BLACK # $t6 stores the BLACK colour code 
 	
 	sw $t6, 256($t1)
 	sw $t6, 124($t1)
 	sw $t6, 132($t1)
 	sw $t3, 4($t1)
 	sw $t5, -4($t1)
 	sw $t4, -124($t1)
 	sw $t6, -132($t1)
 	sw $t5, -260($t1)
 	sw $t3, -252($t1)
 	sw $t3, -384($t1)
 	sw $t6, -248($t1)
 	sw $t3, -120($t1)
 	sw $t6, 8($t1)
 	addi $t1,$t1,-128
 	sw $t1, ($t0)
 	
 	la $t0,ship_post # load address in t0
	lw $t1,4($t0) # t1 stores the y position of ship
	addi $t1,$t1,-1
	sw $t1,4($t0)
	
 END_UP: jr $ra
 
down:
	la $t0,loc_ship # load address in t5
	lw $t1,($t0) # t1 stores the adreess of the spaceship
	
	li $t7, BASE_ADDRESS
 	addi $t7,$t7,3712
 VALID_down: bgt $t1,$t7, END_down # makes sure that the space_ship doesnt leave the screen
	
	li $t3, BLUE # $t3 stores the BLUE colour code 
 	li $t4, YELLOW # $t4 stores the YELLOW colour code 
 	li $t5, ORANGE # $t5 stores the orange colour code 
 	li $t6, BLACK # $t6 stores the BLACK colour code 
 	
 	sw $t6, -256($t1)
 	sw $t6, -124($t1)
 	sw $t6, -132($t1)
 	sw $t5, -4($t1)
 	sw $t3, 4($t1)
 	sw $t6, 8($t1)
 	sw $t6, 124($t1)
 	sw $t4, 132($t1)
 	sw $t3, 136($t1)
 	sw $t3, 260($t1)
 	sw $t5, 252($t1)
 	sw $t3, 384($t1)
 	addi $t1,$t1,128
 	sw $t1, ($t0)
 	
 	la $t0,ship_post # load address in t0
	lw $t1,4($t0) # t1 stores the y position of ship
	addi $t1,$t1,1
	sw $t1,4($t0)
	
 END_down:	jr $ra
 
left: 
	la $t0,ship_post # load address in t0
	lw $t1,($t0) # t1 stores the x position of ship
	li $t3, 1

VALID_left: ble $t1, $t3, END_left
	addi $t1,$t1,-1
 	sw $t1, ($t0)
 	
	li $t3, BLUE # $t3 stores the BLUE colour code 
 	li $t4, YELLOW # $t4 stores the YELLOW colour code 
 	li $t5, ORANGE # $t5 stores the orange colour code 
 	li $t6, BLACK # $t6 stores the BLACK colour code 
 	
	la $t0,loc_ship # load address in t0
	lw $t1,($t0) # t1 stores the adreess of the spaceship
	
	sw $t4, ($t1)
	sw $t6, 8($t1)
	sw $t6, 256($t1)
	sw $t6, -256($t1)
	sw $t3, 4($t1)
      	sw $t6, 132($t1)
      	sw $t6, -124($t1)
      	sw $t3, -4($t1)
      	sw $t3, 124($t1)
      	sw $t3, 252($t1)
      	sw $t3, -132($t1)
      	sw $t3, -260($t1)
      	sw $t5, 120($t1)
      	sw $t5, -136($t1)
      	
      	addi $t1,$t1,-4
 	sw $t1, ($t0)
 	
END_left: jr $ra

right:
	la $t0,ship_post # load address in t0
	lw $t1,($t0) # t1 stores the x position of ship
	li $t3, 29
VALID_right: bge $t1, $t3, END_right
	addi $t1,$t1,1
 	sw $t1, ($t0)	
	
	li $t3, BLUE # $t3 stores the BLUE colour code 
 	li $t4, YELLOW # $t4 stores the YELLOW colour code 
 	li $t5, ORANGE # $t5 stores the orange colour code 
 	li $t6, BLACK # $t6 stores the BLACK colour code 
 	
	la $t0,loc_ship # load address in t5
	lw $t1,($t0) # t1 stores the adreess of the spaceship
	
	sw $t6, ($t1)
	sw $t6, -132($t1)
	sw $t6, 124($t1)
	sw $t5, -128($t1)
	sw $t6, -256($t1)
	sw $t5, 128($t1)
	sw $t6, 256($t1)
	sw $t3, 4($t1)
	sw $t3, 260($t1)
	sw $t3, -252($t1)
	sw $t4, 8($t1)
	sw $t3, 136($t1)
	sw $t3, -120($t1)
	sw $t3, 12($t1)
	 
	addi $t1,$t1,4
 	sw $t1, ($t0)
END_right:jr $ra

Remove_obst_address:
					# a0 contians the index to updat ############ send arguemnt
	la $s0, loc_obstacles # t9 has the address of loc_obstacle array
	la $s7, no_of_obst
	lw $s1, ($s7) # s1 stores no.of obstacles
	addi $s1,$s1,-4 
	sw $s1,($s7)
	
	la $s2, obst_post
	la $s3, obst_type

	beq $a0,$s1,END_OBST_DELETE_Addr
	#update obst adress
	add $s5,$s0,$s1
	lw $s6,($s5) # stores the obst_address of the last obst
	add $s5,$s0,$a0
	sw $s6,($s5) # updated te deleting index
	
	# update obst_type 
	add $s5,$s3,$s1
	lw $s6,($s5)
	add $s5,$s3,$a0
	sw $s6,($s5)
	
	#update obst_post
	move $s7, $s1
	sll $s7,$s7,1
	add $s5,$s2,$s7
	lw $s6, 0($s5)
	lw $s7, 4($s5)
	
	sll $s4, $a0,1
	add $s5,$s2,$s4
	sw $s6, 0($s5)
	sw $s7, 4($s5)
	
END_OBST_DELETE_Addr: jr $ra	
	

	
	
Delete_obst: 
	li $t6, BLACK # $t6 stores the BLACK colour code 
	# a0 stores the address of the object were supoosed to delete
	move $t8,$a1 # stores tyepe of object
	
	beqz $t8, delete_type2 # small obst
	beq $t8,3,delete_type3
delete_type1: 
	
	sw $t6, 0($a0) 
           sw $t6, -4($a0)
           sw $t6, -8($a0)
           sw $t6, 4($a0) 
           sw $t6, -128($a0) 
           sw $t6, -132($a0) 
           sw $t6, 128($a0) 
           sw $t6, 124($a0) 
           sw $t6, 120($a0)
           sw $t6, 132($a0)
           sw $t6, 256($a0)
           sw $t6, 252($a0)
	  j END_delete_obst
delete_type2: 

	sw $t6, 0($a0) 
        sw $t6, -4($a0) 
        sw $t6, 4($a0) 
        sw $t6, -128($a0) 
        sw $t6, 128($a0) 
        j END_delete_obst
delete_type3:
	sw $t6, -4($a0) 
 	sw $t6, -132($a0) 
 	sw $t6, 124($a0) 
 	sw $t6, 128($a0) 
 	sw $t6, 132($a0) 
 	sw $t6, -124($a0)
 	sw $t6, 0($a0) 
 	sw $t6, -128($a0) 
 	sw $t6, 4($a0) 
END_delete_obst: jr $ra

obst_out_screen:
	la $t0, loc_obstacles # t0 has the address of loc_obstacle array
	la $t1, no_of_obst
	lw $t1, ($t1) # t1 stores the number of obstacles in the screen
	la $t3, obst_post
	la $t4, obst_type
	
	li $t5, 0
	sw $ra,($sp)
	addi $sp,$sp,-4
obst_screen_loop:beq $t5,$t1,END_obst_out_screen
	move $t6,$t5
	sll $t6,$t6,1
	add $t7,$t3,$t6
	lw $t6,($t7) #t6 stores the x_post of obst
	lw $t8, 4($t7)#t8 stores the y_post of obst
	
	
	sw $t6, ($sp)
	lw $t7, ($t4) # t7 stores obst type
	
	beqz $t7, obst_screen_type2 # small obst
	beq $t7,2,obst_screen_type2
	beq $t7,3,obst_screen_type2
obst_screen_type1:
	la $t7, ship_post
	lw $t9,($t7)  #t9 stores the x_post of ship
	lw $t7,4($t7) #t7 stores the y_post of ship

	addi $t9,$t9,3
	addi $t6,$t6,-2
	bne $t9,$t6,cont_obst_screen1
	sub  $t6,$t8,$t7
	blt $t6,-4, cont_obst_screen1
	bgt $t6,4, cont_obst_screen1
	
	la $t9, no_of_collision
	lw $t6, ($t9)
	addi $t6,$t6,1
	sw $t6, ($t9)
	
	li $v1,1 # return value to indicate space_ship has collided
	j delete_call
	
cont_obst_screen1:
	lw $t6,($sp)
	bne $t6,2,Update_obst_screen
	j delete_call
	
obst_screen_type2:
	la $t7, ship_post
	lw $t9,($t7)  #t9 stores the x_post of ship
	lw $t7,4($t7) #t7 stores the y_post of ship

	addi $t9,$t9,3
	addi $t6,$t6,-1
	bne $t9,$t6,cont_obst_screen2
	sub  $t6,$t8,$t7
	blt $t6,-3, cont_obst_screen2
	bgt $t6,3, cont_obst_screen2
	li $v1,1 # return value to indicate space_ship has collided

HEAL:
	lw $t7, ($t4) # t7 stores obst type
	bne $t7,2,SLOW  #NOT_HEAL_OBST
	la $t9, no_of_collision
	sw $zero, ($t9)
	li $a2,0
	j delete_call
SLOW:  #################################################################
	bne $t7,3,NOT_HEAL_OBST
	la $t7,sleep_rate
	li $t6,100
	sw $t6,($t7)
	
NOT_HEAL_OBST:
	la $t9, no_of_collision
	lw $t6, ($t9)
	addi $t6,$t6,1
	sw $t6, ($t9)
	
	j delete_call
	
cont_obst_screen2:	
	lw $t6,($sp)
 	bne $t6,1 ,Update_obst_screen
	
delete_call:
	lw $t7, ($t4) #stores stype
	beq $t7,1,delete_call_type1
	beq $t7,2,delete_call_type2
	beq $t7,3,delete_call_type3
	li $a1,0
	j Cont_delete_call
delete_call_type1:
	li $a1,1
	j Cont_delete_call
delete_call_type2:
	li $a1,0
	j Cont_delete_call
delete_call_type3:
	li $a1,3
	j Cont_delete_call
Cont_delete_call:
	add $t7,$t0,$t5
	lw $t7, ($t7) # t7 now contains the adrees of obst
	move $a0,$t7
	jal Delete_obst
	move $a0,$t5
	jal Remove_obst_address
	addi $t1,$t1,-4
	
	j obst_screen_loop



	
Update_obst_screen:
	addi $t4,$t4,4 # increments the obst_type array
	addi $t5,$t5,4
	j obst_screen_loop
END_obst_out_screen: 
	addi $sp,$sp,4
	lw $t0,($sp)
	jr $t0
	
Update_obst_loc:
	la $t9, loc_obstacles # t9 has the address of loc_obstacle array
	la $t1, no_of_obst
	lw $t1, ($t1) # t1 stores the number of obstacles in the screen
	la $t3, obst_type
	li $t4, WHITE # $t1 stores the white colour code 
 	li $t5, GREY # $t5 stores the grey colour code 
 	li $t6, BLACK # $t6 stores the BLACK colour code 
	li $t7, 0 #shoulk increment by 4
	
UPDATE_obst_loop: beq $t7, $t1 ,END_update_obst
	
	
	
	la $t0, obst_post # update the obst_post array
	move $t8,$t7
	sll $t8,$t8,1
	add $t0,$t0,$t8
        lw $t8, ($t0)
        addi $t8,$t8,-1
        sw $t8, ($t0)
	
	
	lw $t0, ($t9)
	lw $t8, ($t3)
	beqz $t8, update_type2 # small obst
	beq $t8,2,update_type3
	beq $t8,3,update_type4
update_type1: 
	sw $t6,4($t0)
	sw $t6,132($t0)
	sw $t5,128($t0)
	sw $t6,256($t0)
	sw $t6,-128($t0)
	sw $t5,($t0)
	sw $t5,128($t0)
	sw $t4,-8($t0)
	sw $t5,-136($t0)
	sw $t5,248($t0)
	sw $t4,120($t0)
	sw $t5,-12($t0)
	sw $t5,116($t0)
	
	addi $t0,$t0,-4  # update location
	sw $t0,($t9)
	
	addi $t7,$t7,4
	addi $t3,$t3,4
	addi $t9,$t9,4
	j UPDATE_obst_loop
update_type2: # small obst
	sw $t5,($t0)
	sw $t6,4($t0)
	sw $t6,128($t0)
	sw $t6,-128($t0)
	sw $t4,-4($t0)
	sw $t5,-132($t0)
	sw $t5,124($t0)
	sw $t5,-8($t0)
	
	
	addi $t0,$t0,-4 # update location
	sw $t0,($t9)
	
	addi $t7,$t7,4
	addi $t3,$t3,4
	addi $t9,$t9,4
	j UPDATE_obst_loop
update_type3: # heal_obst
	li $t5,PINK
	sw $t5,($t0)
	sw $t6,4($t0)
	sw $t6,128($t0)
	sw $t6,-128($t0)
	sw $t5,-4($t0)
	sw $t5,-132($t0)
	sw $t5,124($t0)
	sw $t5,-8($t0)
	
	addi $t0,$t0,-4 # update location
	sw $t0,($t9)
	
	addi $t7,$t7,4
	addi $t3,$t3,4
	addi $t9,$t9,4
	li $t5,GREY
	j UPDATE_obst_loop
update_type4:  # slow_speed obst # GREY t5, red t4
      	li $t4,RED
     	li $t5, YELLOW
      	sw $t6,4($t0)
      	sw $t6,-124($t0)
      	sw $t6,132($t0)
      	sw $t5,-128($t0)
      	sw $t4,-4($t0)
      	sw $t4,-132($t0)
      	sw $t5,-8($t0)
      	sw $t5,120($t0)
      	sw $t5,-136($t0)
      	
	addi $t0,$t0,-4 # update location
	sw $t0,($t9)
	
	addi $t7,$t7,4
	addi $t3,$t3,4
	addi $t9,$t9,4
	li $t4,WHITE
	li $t5,GREY
	j UPDATE_obst_loop
END_update_obst: jr $ra


main:
 	jal clear_screen
 	la $t0, no_of_collision # reset no_Of collison
 	sw $zero,($t0)
 	
 	la $t0, difficulty_level # reset difficulty level
 	sw $zero,($t0)
 	
 	la $t0, current_sleep_rate # reset current_sleep_rate
 	li $t1,60
 	sw $t1,($t0)
 	
 	la $t0, OBST_RATE # reset OBST_RATE
 	li $t1,30
 	sw $t1,($t0)
 	
 	la $t0, BLINK_RATE # reset BLINK_RATE
 	li $t1,6
 	sw $t1,($t0)
 	
 	jal HEALTH_BAR
 	li $t0, BASE_ADDRESS # $t0 stores the base address for display 
 	addi $t0,$t0,260
 	la $t2,loc_ship
 	sw $t0,($t2)
 	move $a0,$zero
 	jal init_spaceship  # initialize spacehisp
 	
 	li $a1,12
 	la $t0, no_of_obst # get the address of no_of_obst
	sw $zero, ($t0)
	la $t0, no_of_iteration # reset no_of iteration
	sw $zero, ($t0)  
	la $t0,ship_post
	li $t1,1
	li $t3,2
	sw $t1, ($t0)
	sw $t3, 4($t0)
	li $a2,0  # no heal 
 	jal draw_obst
 	
 	la $t7,sleep_rate  # reset sleep rate
	li $t6,60
	sw $t6,($t7)

main_loop: beq $t2, 0x71, quit_main_loop
 	li $t9, 0xffff0000 
 	lw $t8, 0($t9) 
 	beq $t8, 1, keypress_happened
 	j Cont_main_loop
keypress_happened:
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before 
IF_UP: beq $t2, 0x61, respond_to_a
   	beq $t2, 0x64, respond_to_d
   	beq $t2, 0x77, respond_to_w
   	beq $t2, 0x73, respond_to_s
   	beq $t2, 0x70, respond_to_p
respond_to_a: 
	jal left 
	j Cont_main_loop
respond_to_d: 
	jal right 
	j Cont_main_loop
respond_to_w: 
	jal up
	j Cont_main_loop
respond_to_s: 
	jal down
	j Cont_main_loop	
respond_to_p: 
	j main
Cont_main_loop:
	
	la $t8,no_of_collision
	lw $t9,($t8)
	
	bne $t9,10, Cont_main_loop2
	jal clear_screen
	jal GAME_OVER
	li $v0, 32 
	li $a0,5000  # Wait one second (1000 milliseconds) 
	syscall
	j main
Cont_main_loop2:
	#bne $t9,7, Cont_not_heal
	ble $t9,6,Cont_not_heal
	li $a2,1
	
Cont_not_heal:
	jal obst_out_screen
	jal Update_obst_loc
	jal HEALTH_BAR
	la $t8, no_of_iteration
	lw $t9, ($t8)
	addi $t9,$t9,1
	sw $t9, ($t8)
	la $t8,OBST_RATE
	lw $t8, ($t8)
	la $t7,BLINK_RATE
	lw $t7,($t7)
	
	# check to blink red or not , when v1 is 1 cont to blink
	beqz  $v1,Dont_blink
	li $a0,1
 	jal init_spaceship
	
	div $t9,$t7
	mfhi $t7
	bnez $t7,Dont_blink
	move $a0,$zero
 	jal init_spaceship
Dont_blink:
	bne  $t9,$t8, Cont_main_loop3
draw_more_obst:
	# if a2 1 then draw heal_obst
        la $t7, no_of_obst # get the address of no_of_obst
	lw $t4, ($t7)
	addi $t4,$t4,12
	add $a1, $zero,$t4
	
	la $t7,time_passed
	lw $t8, ($t7)
	addi $t8,$t8,1
	sw $t8, ($t7)
	
	bne  $t8,SLOW_TIME,DRAW_SLOWER # stop slowing the speed
	la $t0,sleep_rate   
	la $t4,current_sleep_rate
	lw $t3, ($t4) 	
	sw $t3, ($t0)
	
DRAW_SLOWER:
	bne  $t8,SLOW_OBST_RATE,NOT_SLOWER
	sw $zero, ($t7)
	addi $sp,$sp,-4
	# increase iteration after every 14 iteration
	la $t0, difficulty_level
	lw $t7,($t0)
	addi $t7,$t7,1
	sw $t7,($t0)
	
LEVEL_3:bne $t7,3,LEVEL_6
	la $t0, sleep_rate
	li $t6,40
	sw $t6,($t0)
	la $t0, current_sleep_rate
	sw $t6,($t0)
LEVEL_6:bne $t7,6,level_not_changed
	la $t0, OBST_RATE  # update obst_rate to increase obst
	li $t6,20
	sw $t6,($t0)
	la $t0, BLINK_RATE  # update BLINK_RATE
	li $t6,4
	sw $t6,($t0)
	# 
level_not_changed:
	li $t7,2
	sw $t7,($sp)
	

NOT_SLOWER:
	jal draw_obst
	la $t0, no_of_iteration
	sw $zero, ($t0)
	li $v1,0
	
Cont_main_loop3:	
	li $v0, 32 
	la $a0,sleep_rate
	lw $a0,($a0)
	syscall

	j main_loop
quit_main_loop:
        
 	li $v0, 10 # terminate the program gracefully
 	syscall 
