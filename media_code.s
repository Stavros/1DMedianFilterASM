			AREA 	program,CODE,READONLY
			EXPORT	_medianfilter
				
			ENTRY 

_medianfilter
        SUB     SP, SP, #80
        STR     R0, [SP, 24]
        STR     R1, [SP, 16]
        STR     R12, [SP, 12]
        MOV     R10, 2
        STR     R10, [SP, 76]
        B       L2
L10
        STR     wzr, [SP, 72]
        B       L3
L4
        LDR     R10, [SP, 76]
        SUB     R11, R10, #2
        LDR     R10, [SP, 72]
        ADD     R10, R11, R10
        sRtw    R0, R10
        LSL     R0, R0, 2
        LDR     R1, [SP, 24]
        ADD     R0, R1, R0
        LDR     R12, [R0]
        LDRsw   R0, [SP, 72]
        LSL     R0, R0, 2
        ADD     R1, SP, 32
        STR     R12, [R1, R0]
        LDR     R10, [SP, 72]
        ADD     R10, R10, 1
        STR     R10, [SP, 72]
L3
        LDR     R10, [SP, 72]
        CMP     R10, 4
        BLE     L4
        STR     wzr, [SP, 68]
        B       L5
L9
        LDR     R10, [SP, 68]
        STR     R10, [SP, 64]
        LDR     R10, [SP, 68]
        ADD     R10, R10, 1
        STR     R10, [SP, 60]
        B       L6
L8
        LDRsw   R0, [SP, 60]
        LSL     R0, R0, 2
        ADD     R1, SP, 32
        LDR     R11, [R1, R0]
        LDRsw   R0, [SP, 64]
        LSL     R0, R0, 2
        ADD     R2, SP, 32
        LDR     R10, [R2, R0]
        CMP     R11, R10
        bge     L7
        LDR     R10, [SP, 60]
        STR     R10, [SP, 64]
L7
        LDR     R10, [SP, 60]
        ADD     R10, R10, 1
        STR     R10, [SP, 60]
L6
        LDR     R10, [SP, 60]
        CMP     R10, 4
        BLE     L8
        LDRsw   R0, [SP, 68]
        LSL     R0, R0, 2
        ADD     R1, SP, 32
        LDR     R10, [R1, R0]
        STR     R10, [SP, 56]
        LDRsw   R0, [SP, 64]
        LSL     R0, R0, 2
        ADD     R1, SP, 32
        LDR     R12, [R1, R0]
        LDRsw   R0, [SP, 68]
        LSL     R0, R0, 2
        ADD     R1, SP, 32
        STR     R12, [R1, R0]
        LDRsw   R0, [SP, 64]
        LSL     R0, R0, 2
        ADD     R1, SP, 32
        LDR     R12, [SP, 56]
        STR     R12, [R1, R0]
        LDR     R10, [SP, 68]
        ADD     R10, R10, 1
        STR     R10, [SP, 68]
L5
        LDR     R10, [SP, 68]
        CMP     R10, 2
        BLE     L9
        LDRsw   R0, [SP, 76]
        LSL     R0, R0, 2
        SUB     R0, R0, #8
        LDR     R1, [SP, 16]
        ADD     R0, R1, R0
        LDR     R11, [SP, 40]
        STR     R11, [R0]
        LDR     R10, [SP, 76]
        ADD     R10, R10, 1
        STR     R10, [SP, 76]
L2
        LDR     R10, [SP, 12]
        SUB     R11, R10, #2
        LDR     R10, [SP, 76]
        CMP     R11, R10
        BGT     L10
        NOP
        ADD     SP, SP, 80
        RET