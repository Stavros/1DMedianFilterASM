;#define FILTER_LEN 5 /* must be an odd number */

;.segment/pm pmcode;


		TTL		avg32bit
		AREA 	program, CODE, READONLY
		EXPORT 	start_median
			
		ENTRY

start_median

	;/* xfer loop - transfer delay line data in DM to median filter buffer in PM */
		r0=dm(i1,m1);
		lcntr=FILTER_LEN-1, do xfer until lce;

xfer
	r0=dm(i1,m1), pm(i8,m9)=r0; /* transfer to filter buffer */
								;/* read from input buffer */
	pm(i8,m9)=r0; /* transfer to filter buffer */
		;/*
		;median filter loop - find median value in delay line using this technique:
		;for N=0 to (FILTER_LEN+1)/2 - outer loop
			;for M=N to FILTER_LEN - inner loop
				;if (median[N] < median[M])
					;median[M]=median[N], median[M]=median[N]
				;inc M
			;inc N
		;*/
	
	b9=b8; /* i8, i9 point to median filter data */
	r15=FILTER_LEN; /* r15 is loop count for inner loop */
	
	;/* each pass through the outer loop resolves the next greatest magnitude */
	;/* in the median filter buffer - median[N] */
	
	lcntr=(FILTER_LEN+1)/2, do outer_loop until lce;
	r4=pm(i8,m9); 				/* read median[N] */
	modify(i9,1); 				/* i9 points to median[M] */
								;/* where M=N+1 first */
	r15=r15-1, r5=pm(i9,m9); 	/* decrement inner loop count */
								/* read median[M] */
	
	;/* inner loop finds minimum of the remaining values in median filter buffer */
	lcntr=r15, do inner_loop until lce;
	r2=pass r5; /* f2=median[M] */
	comp(r2,r4), r5=pm(i9,m9); /* cmp median[M], median[N] */

inner_loop
	if lt r4=pass r2, pm(-2,i9)=r4; /* if median[M] < median[N] */
											;/* median[N]=median[M] */
											;/* median[M]=median[N] */

outer_loop
	i9=i8; 	/* init i9 to median[N+1] */
	rts; 	/* return is non-delayed */
			;/* 3 cycles */
;.endseg;