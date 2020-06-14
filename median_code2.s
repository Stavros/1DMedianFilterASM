			AREA example,CODE,READONLY
				
			ENTRY 
			
			LDR SP,=dest; 
			LDR R4,=src; this is the beginning
			
			; R5,[R4]; Take the number from the stack; 
			LDR r6,[r4,#4];
			STR r5,[r4,#4]; Put the number inside the register into the stack;
			STR R6,[R4];
			LDR R5,[R4];
			LDR r6,[r4,#4] ; R0,R2 innitail
			MOV r2,r0

loop_1	
			CMP r1,r0; R1 is 0,r0 is n
			BGE loop_end; if R1 is larger than R0, end
			ADD r1,r1,#1; r1++
			SUB r2,r2,#1; R2 is required to compare the number of
			MOV r3,#0; R3 is the subscript for the next loop, initializing the
			LDR R4,=src; stack at the beginning
			B loop_2

loop_2
			CMP r3,r2; if R3 is larger than R2
			BGE loop_1;	end
			ADD r3,r3,#1
			LDR R5,[R4]; Take the current two numbers out of the LDR r6,[r4,#4]
			ADD r4,r4,#4
			CMP r5,r6; If the left side is larger than the large
			BLS loop_2
			SUB r4,r4,#4
			STR r5,[r4,#4]; Exchange
			STR R6,[R4] 
			ADD r4,r4,#4
			B loop_2 

loop_end 
			MOV r2,r0,lsr#1; /2
			MOV r3,#4
			MUL r1,r2,r3; offset 
			LDR R1,[SP,R1]; take the median 

			AREA 	data, DATA
src			DCD		0x0000000A, 0x00000014, 0x00000014, 0x0000000A, 0x00000014
dest		DCD		0x0000000A, 0x00000014, 0x00000014, 0x0000000A, 0x00000014
			END
