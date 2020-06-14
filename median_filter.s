; Engineer: Stavros Kalapothas
; Date: 13/04/2020
; Project: Calculate 1D Median Filter with a custom window size
;
;				    1 2 3 4 5 6 7 8 9 10
;			  x x 1 2 3 -> bsort -> 3 2 1 2 3 -> 1
;		      x 1 2 3 4 -> bsort -> 2 1 2 3 4 -> 2
;			  1 2 3 4 5 -> bsort -> 1 2 3 4 5 -> 3
;			              ...
;			  6 7 8 9 10 -> bsort -> 6 7 8 9 10 -> 8
;             7 8 9 10 x -> bsort -> 7 8 9 10 9 -> 9
;			  8 9 10 x x -> bsort -> 8 9 10 9 8 -> 10

			TTL		median_filter
			AREA 	program, CODE, READONLY
			EXPORT	main
wdw			EQU		5					; window size
siz			EQU		10					; array size
				
			ENTRY

main							; init
			LDR		R8, =src			; load the starting address of the src list
			LDR		R7, =tempd			; load the starting address of the tempd list
			LDR		R0, =temp			; load the starting address of the temp list
			LDR		R11, =dest			; load the starting address od the dest list
			MOV 	R9, #0				; init counter

loop							; loop
			CMP 	R9, #siz			; reached the end of array?
			BPL.w	stop				; if yes goto stop			
			; main iteration
			ADD		R9, R9, #1			; increment counter
			CMP		R9, #1				; is counter index=1 ?
			BEQ		edge_start1			; edge case N=1
			CMP		R9, #2				; is counter index=2 ?
			BEQ		edge_start2			; edge case N=2
			CMP		R9, #siz-1			; is counter N-1 ?
			BEQ		edge_end1			; edge case
			CMP		R9, #siz			; is counter N ?
			BEQ		edge_end2			; edge case		
			LDM		R8!, {R2-R6}		; load 5 elements
			;STM	R0, {R2-R6}			; store 5 elements
			STR		R2, [R0], #4		; store i+1 item to temp list
			STR		R3, [R0], #4		; store i+1 item to temp list
			STR		R4, [R0], #4		; store i+1 item to temp list
			STR		R5, [R0], #4		; store i+1 item to temp list	
			STR		R6, [R0], #4		; store i+1 item to temp list
			B		bsort				; go execute bsort and return median
			
edge_start1						; edge case
			LDR		R10, [R8, #8]		; load i+2 src item
			STR		R10, [R0], #4		; store i+2 item to temp list
			LDR		R10, [R8, #4]		; load i+1 src item
			STR		R10, [R0], #4		; store i+1 item to temp list
			LDM		R8!, {R2-R4}		; load 3 words from src list
			;STM	R0, {R2-R4}			; store 3 words to temp list
			STR		R2, [R0], #4		; store i+1 item to temp list
			STR		R3, [R0], #4		; store i+1 item to temp list
			STR		R4, [R0], #4		; store i+1 item to temp list
			B		bsort				; go calculate bsort and return median

edge_start2						; edge case
			LDR		R10, [R8, #4]		; load i+1 src item
			STR		R10, [R0], #4		; store i+1 item to temp list
			LDM		R8!, {R2-R5}		; load 3 words from src list
			;STM	R0, {R2-R5}			; store 3 words to temp list
			STR		R2, [R0], #4		; store i+1 item to temp list
			STR		R3, [R0], #4		; store i+1 item to temp list
			STR		R4, [R0], #4		; store i+1 item to temp list
			STR		R5, [R0], #4		; store i+1 item to temp list
			B		bsort				; go execute bsort and return median			

edge_end1						; edge case
			LDR		R10, [R8, #4]		; load i+1 src item
			STR		R10, [R0], #4		; store i+1 item to temp list
			LDM		R8!, {R2-R5}		; load 3 words from src list
			;STM	R0, {R2-R5}			; store 3 words to temp list
			STR		R2, [R0], #4		; store i+1 item to temp list
			STR		R3, [R0], #4		; store i+1 item to temp list
			STR		R4, [R0], #4		; store i+1 item to temp list
			STR		R5, [R0], #4		; store i+1 item to temp list			
			B		bsort				; go execute bsort and return median	


edge_end2						; edge case
			LDR		R10, [R8, #8]		; load i+2 src item
			STR		R10, [R0], #4		; store i+2 item to temp list
			LDR		R10, [R8, #4]		; load i+1 src item
			STR		R10, [R0], #4		; store i+1 item to temp list
			LDM		R8!, {R2-R4}		; load 3 words from src list
			;STM	R0, {R2-R4}			; store 3 words to temp list
			STR		R2, [R0], #4		; store i+1 item to temp list
			STR		R3, [R0], #4		; store i+1 item to temp list
			STR		R4, [R0], #4		; store i+1 item to temp list
			B		bsort				; go calculate bsort and return median
			
bsort
			; Bubble sort an array of 32bit integers in place
			; Arguments: R0 = Array location, R1 = Array size
			LDR		R0, =temp
			MOV 	R1, #wdw			; load window size
			;MOV		R3, #0				; init help var
			;MOV		R4, #0				; init help var
			;MOV		R5, #0				; init help var
			PUSH    {R0-R6, LR}          ; Push registers on to the stack
			
bsort_next                      ; Check for a sorted array
			MOV     R2,#0               ; R2 = Current Element Number
			MOV     R6,#0               ; R6 = Number of swaps

bsort_loop                      ; Start loop
			ADD     R3,R2,#1            ; R3 = Next Element Number
			CMP     R3,R1               ; Check for the end of the array
			BGE     bsort_check         ; When we reach the end, check for changes
			LDR     R4,[R0,R2,LSL #2]   ; R4 = Current Element Value
			LDR     R5,[R0,R3,LSL #2]   ; R5 = Next Element Value
			CMP     R4,R5               ; Compare element values
			STRGT   R5,[R0,R2,LSL #2]   ; If R4 > R5, store current value at next
			STRGT   R4,[R0,R3,LSL #2]   ; If R4 > R5, Store next value at current
			ADDGT   R6,R6,#1            ; If R4 > R5, Increment swap counter
			MOV     R2,R3               ; Advance to the next element
			B       bsort_loop          ; End loop

bsort_check                     ; Check for changes
			CMP     R6,#0               ; Were there changes this iteration?
			SUBGT   R1,R1,#1            ; Optimization: skip last value in next loop
			BGT     bsort_next          ; If there were changes, do it again

bsort_done                      ; Return
			POP     {R0-R6, PC}			; Pop the registers off of the stack
			STR		R0, [R7], #8		; Store the 3rd value on temp array
			STR		R7, [R11], #4		; Store the median value to dest array
			B		loop				; return to main loop

stop							; exit()
			SWI		#11
			
			AREA 	data, DATA, READWRITE
src			DCD		0x03, 0x01, 0x09, 0x04, 0x07, 0x02, 0x08, 0x10, 0x06, 0x05
temp		DCD		0x00
tempd		DCD		0x00
dest		DCD		0x00
			END

; sorted values
;1 1 3 9 9
;1 1 3 4 9
;1 3 4 7 9
;1 2 4 7 9
;2 4 7 8 9
;2 4 7 8 10
;2 6 7 8 10
;2 5 6 8 10
;5 6 6 8 10
;5 6 6 10 10 