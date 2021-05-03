.global lab4
.syntax unified

#define X1 #-17
#define X2 #12
#define X3 #17
#define X4 #3

lab4:
	push {lr}
	bl task1
	bl task2
	pop {pc}

task1:
	// F = (X4+1)/4v2(X1+X2+X3)
	push {lr}
	mov r0, X1
	mov r1, #0xFFFFFFFF

	mov r2, X2
	mov r3, #0

	mov r4, X3
	mov r5, #0

	mov r6, X4
	mov r7, #0

	// Calculation
	//2(X1+X2+X3)
	adds r0, r2
	adc r1, r3
	//(X1+X2+X3)
	adds r0, r4
	adc r1, r5
	
	lsls r0, #1	//	2(X1+X2+X3)
	lsl r1, #1
	adc r1, #0
	
	// (X4+1)/4
	adds r6, #1	//	X4 +1
	adc r7, #0
	
	asr r6, #2    // (X4+1)/4
	lsr r7, #2

	orr r0, r6
	orr r1, r7

	
	bl result_correction
	pop {pc}
	
	bl result_correction
	pop {pc}
	


// Result correction
result_correction:
	push {lr}
	bvc step2
	lsrs r0, #1
	rrx r1, r1
step2:
	orrs r0, #0	// update Z flag
	bne step4
	
// step 3
	mov r0, #0b1111110111000
	           
	lsl r0, #18
step4:
	mov r8, #0b1111110111000
	adds r1, r8

// step 5
	and r9, r1, #0x80000000
	beq marker1
	and r9, r1, #0x40000000
	beq normalize
	b step7

marker1:
	and r1, r1, #0x40000000
	beq step7
	
normalize:
	lsrs r0, #1
	rrx r1, r1
step7:
	bvc end_correction
	lsrs r0, #1
	rrx r1, r1
	push {r0}
	push {r1}
	pop {r1}
	pop {r0}
	
end_correction:
	pop {pc}
	

task2: 
	push {lr}
	mov r0, #16
	mov r1, #4

program_a:
	// 1: r0 = r0+r1
	add r0, r1
	// 2: r0 = r1*r1
	mul r0, r0, r1
	
jump1:
	// 3: r0 = r0+r1
	add r0, r1
	
	// 4: jump2
	beq jump2
	
	// 5: r0 = r0-5
	sub r0, #5
	
	// 7: r0 = r0+20
	add r0, #20
	
	b jump3
	
jump2:
	// 6: r0=r0+r1
	add r0, r1
	b jump3
	
jump3:
	//8: jump to 2 task
	bl program_b
	bcc jump1
	
	add r0, #30
	pop {pc}

program_b:
	push {lr}

jump4:
	//10:
	add r1, #20
	//11
	bl program_c
	bmi jump5
	//12
	add r0, r1
	b jump5
	
jump5:
	bne jump4
	add r0, r1
	add r0, r1
	pop {pc}

program_c:
	push {lr}
	mov r0, #25
	add r0, #25
	pop {pc}


