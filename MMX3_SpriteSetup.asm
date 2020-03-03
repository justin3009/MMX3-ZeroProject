;==================================================================================
; Mega Man X3 (Base Mod Project)
; By xJustin3009x (Shishisenkou) (Justin3009)
;==================================================================================
; This file is used to import the code changes that modify Sprite Assembly and/or
; Animation Data directly.
;==================================================================================
; NOTE: The ROM MUST be expanded to 4MB first WITHOUT a header!
;==================================================================================
;***************************
header : lorom

incsrc MMX3_NewCode_Locations.asm
incsrc MMX3_VariousAddresses.asm
;***************************
;***************************
;Setup PC & PC NPC VRAM data that allows missiles in events.
;***************************
org !VRAMRoutineAllowMissiles
	JSL PCNPC_VRAMStart
	JSL PCNPC_VRAMAllowMissilesStart
	NOP #4
	RTL

	
;***************************
;1-up Icon In-Game Sprite Assembly
;***************************
org $8DF147 ;Sprite assembly of PC's 1-up icon in VRAM
	db $04 ;How many sprite assembly chunks
	db $00,$F8,$00,$CB ;Direction/size, X coordinate, Y coordinate, VRAM chunk to use
	db $40,$00,$F8,$CA ;Direction/size, X coordinate, Y coordinate, VRAM chunk to use
	db $00,$F8,$F8,$CA ;Direction/size, X coordinate, Y coordinate, VRAM chunk to use
	db $40,$00,$00,$CB ;Direction/size, X coordinate, Y coordinate, VRAM chunk to use
	
	db $04 ;How many sprite assembly chunks
	db $00,$F8,$00,$CD ;Direction/size, X coordinate, Y coordinate, VRAM chunk to use
	db $40,$00,$F8,$CC ;Direction/size, X coordinate, Y coordinate, VRAM chunk to use
	db $00,$F8,$F8,$CC ;Direction/size, X coordinate, Y coordinate, VRAM chunk to use
	db $40,$00,$00,$CD ;Direction/size, X coordinate, Y coordinate, VRAM chunk to use	
	
;***************************
;***************************
;Charging Level 1/2 Sprite Assembly (All 22 pointers)
;***************************
org $90D74D
	db $02,$00,$FA,$11,$F9,$00,$FA,$E3,$F9,$02,$00,$FA,$10,$F9,$00,$FA
	db $E4,$F9,$04,$00,$10,$FA,$F9,$00,$E4,$FA,$F9,$00,$FA,$0F,$F9,$00
	db $FA,$E5,$F9,$04,$00,$0F,$FA,$F9,$00,$E5,$FA,$F9,$00,$FA,$0E,$F9
	db $00,$FA,$E6,$F9,$06,$00,$FA,$0D,$FA,$C0,$FA,$E7,$FA,$00,$0A,$0A
	db $F9,$00,$0E,$FA,$F9,$00,$E6,$FA,$F9,$00,$EA,$EA,$F9,$06,$00,$0D
	db $FA,$F9,$00,$E7,$FA,$F9,$00,$FA,$0C,$FA,$C0,$FA,$E8,$FA,$00,$09
	db $09,$F9,$00,$EB,$EB,$F9,$08,$C0,$0C,$FA,$FA,$00,$E8,$FA,$FA,$00
	db $FA,$0B,$FA,$C0,$FA,$E9,$FA,$00,$EA,$0A,$F9,$00,$08,$08,$F9,$00
	db $0A,$EA,$F9,$00,$EC,$EC,$F9,$08,$C0,$0B,$FA,$FA,$00,$E9,$FA,$FA
	db $00,$FA,$0A,$FA,$C0,$FA,$EA,$FA,$00,$EB,$09,$F9,$00,$07,$07,$F9
	db $00,$09,$EB,$F9,$00,$ED,$ED,$F9,$08,$40,$06,$06,$FA,$80,$EE,$EE
	db $FA,$C0,$0A,$FA,$FA,$00,$EA,$FA,$FA,$00,$02,$0E,$F9,$00,$F2,$E6
	db $F9,$00,$EC,$08,$F9,$00,$08,$EC,$F9,$08,$40,$05,$05,$FA,$80,$EF
	db $EF,$FA,$C0,$09,$FA,$FA,$00,$EB,$FA,$FA,$00,$02,$0D,$F9,$00,$F2
	db $E7,$F9,$00,$ED,$07,$F9,$00,$07,$ED,$F9,$08,$C0,$06,$EE,$FA,$00
	db $EE,$06,$FA,$40,$04,$04,$FA,$80,$F0,$F0,$FA,$00,$01,$0C,$F9,$00
	db $0E,$F2,$F9,$00,$F3,$E8,$F9,$00,$E6,$02,$F9,$08,$00,$EF,$05,$FA
	db $C0,$05,$EF,$FA,$40,$03,$03,$FA,$80,$F1,$F1,$FA,$00,$01,$0B,$F9
	db $00,$0D,$F2,$F9,$00,$F3,$E9,$F9,$00,$E7,$02,$F9,$08,$40,$00,$0A
	db $FA,$80,$F4,$EA,$FA,$C0,$04,$F0,$FA,$00,$F0,$04,$FA,$00,$F2,$0E
	db $F9,$00,$0C,$F2,$F9,$00,$02,$E6,$F9,$00,$E8,$01,$F9,$08,$40,$00
	db $09,$FA,$80,$F4,$EB,$FA,$00,$F1,$03,$FA,$C0,$03,$F1,$FA,$00,$F2
	db $0D,$F9,$00,$0B,$F3,$F9,$00,$02,$E7,$F9,$00,$E9,$00,$F9,$08,$C0
	db $0A,$F3,$FA,$00,$EA,$00,$FA,$40,$FF,$08,$FA,$80,$F5,$EC,$FA,$00
	db $0E,$02,$F9,$00,$F3,$0C,$F9,$00,$01,$E8,$F9,$00,$E6,$F2,$F9,$08
	db $C0,$09,$F4,$FA,$00,$EB,$FF,$FA,$40,$FF,$07,$FA,$80,$F5,$ED,$FA
	db $00,$0D,$02,$F9,$00,$F2,$0B,$F9,$00,$02,$E9,$F9,$00,$E7,$F2,$F9
	db $06,$00,$F4,$0A,$FA,$C0,$00,$EA,$FA,$C0,$08,$F4,$FA,$00,$EC,$FF
	db $FA,$00,$0C,$01,$F9,$00,$E8,$F3,$F9,$06,$00,$F4,$09,$FA,$C0,$00
	db $EB,$FA,$C0,$07,$F5,$FA,$00,$ED,$FE,$FA,$00,$0B,$01,$F9,$00,$E9
	db $F3,$F9,$04,$00,$F5,$08,$FA,$C0,$FF,$EC,$FA,$40,$0A,$00,$FA,$80
	db $EA,$F4,$FA,$04,$00,$F5,$07,$FA,$C0,$FF,$ED,$FA,$40,$09,$00,$FA
	db $80,$EB,$F4,$FA,$02,$40,$08,$FF,$FA,$80,$EC,$F5,$FA,$02,$40,$07
	db $FF,$FA,$80,$ED,$F5,$FA
	
;***************************
;***************************
;Charging Level 3/4 Sprite Assembly (All 22 pointers)
;***************************
org $90DB9A
	db $02,$C0,$FA,$11,$7C,$00,$FA,$E3,$7C,$02,$C0,$FA,$10,$7C,$00,$FA
	db $E4,$7C,$04,$C0,$FA,$0F,$7D,$00,$FA,$E5,$7D,$C0,$10,$FA,$7C,$00
	db $E4,$FA,$7C,$04,$C0,$FA,$0E,$7D,$00,$FA,$E6,$7D,$C0,$0F,$FA,$7C
	db $00,$E5,$FA,$7C,$06,$00,$0E,$FA,$7D,$00,$E6,$FA,$7D,$00,$FA,$0D
	db $7E,$00,$FA,$E7,$7E,$C0,$0A,$0A,$7C,$00,$EA,$EA,$7C,$06,$00,$0D
	db $FA,$7D,$00,$E7,$FA,$7D,$00,$FA,$0C,$7E,$00,$FA,$E8,$7E,$C0,$09
	db $09,$7C,$00,$EB,$EB,$7C,$08,$00,$08,$08,$7D,$00,$EC,$EC,$7D,$00
	db $0C,$FA,$7E,$00,$E8,$FA,$7E,$00,$FA,$0B,$7F,$00,$FA,$E9,$7F,$80
	db $EA,$0A,$7C,$40,$0A,$EA,$7C,$08,$00,$07,$07,$7D,$00,$ED,$ED,$7D
	db $00,$0B,$FA,$7E,$00,$E9,$FA,$7E,$00,$FA,$EA,$7F,$00,$FA,$0A,$7F
	db $80,$EB,$09,$7C,$40,$09,$EB,$7C,$08,$00,$08,$EC,$7D,$00,$EC,$08
	db $7D,$C0,$06,$06,$7E,$00,$EE,$EE,$7E,$00,$0A,$FA,$7F,$00,$EA,$FA
	db $7F,$C0,$02,$0E,$7C,$00,$F2,$E6,$7C,$08,$00,$07,$ED,$7D,$00,$ED
	db $07,$7D,$C0,$05,$05,$7E,$00,$EF,$EF,$7E,$00,$09,$FA,$7F,$00,$EB
	db $FA,$7F,$C0,$02,$0D,$7C,$00,$F2,$E7,$7C,$08,$00,$01,$0C,$7D,$00
	db $F3,$E8,$7D,$40,$06,$EE,$7E,$80,$EE,$06,$7E,$00,$04,$04,$7F,$00
	db $F0,$F0,$7F,$00,$0E,$F2,$7C,$C0,$E6,$02,$7C,$08,$00,$01,$0B,$7D
	db $00,$F3,$E9,$7D,$40,$05,$EF,$7E,$80,$EF,$05,$7E,$00,$03,$03,$7F
	db $00,$F1,$F1,$7F,$00,$0D,$F2,$7C,$C0,$E7,$02,$7C,$08,$00,$0C,$F2
	db $7D,$00,$E8,$01,$7D,$C0,$00,$0A,$7E,$00,$F4,$EA,$7E,$00,$04,$F0
	db $7F,$00,$F0,$04,$7F,$80,$F2,$0E,$7C,$40,$02,$E6,$7C,$08,$00,$0B
	db $F3,$7D,$00,$E9,$00,$7D,$C0,$00,$09,$7E,$00,$F4,$EB,$7E,$00,$03
	db $F1,$7F,$00,$F1,$03,$7F,$80,$F2,$0D,$7C,$40,$02,$E7,$7C,$08,$00
	db $F3,$0C,$7D,$00,$01,$E8,$7D,$00,$0A,$F3,$7E,$00,$EA,$00,$7E,$00
	db $FF,$08,$7F,$00,$F5,$EC,$7F,$C0,$0E,$02,$7C,$00,$E6,$F2,$7C,$08
	db $00,$F2,$0B,$7D,$00,$02,$E9,$7D,$00,$09,$F4,$7E,$00,$EB,$FF,$7E
	db $00,$FF,$07,$7F,$00,$F5,$ED,$7F,$C0,$0D,$02,$7C,$00,$E7,$F2,$7C
	db $06,$00,$0C,$01,$7D,$00,$E8,$F3,$7D,$80,$F4,$0A,$7E,$40,$00,$EA
	db $7E,$00,$08,$F4,$7F,$00,$EC,$FF,$7F,$06,$00,$0B,$01,$7D,$00,$E9
	db $F3,$7D,$40,$00,$EB,$7E,$80,$F4,$09,$7E,$00,$07,$F5,$7F,$00,$ED
	db $FE,$7F,$04,$C0,$0A,$00,$7E,$00,$EA,$F4,$7E,$40,$FF,$EC,$7E,$80
	db $F5,$08,$7E,$04,$C0,$09,$00,$7E,$00,$EB,$F4,$7E,$40,$FF,$ED,$7E
	db $80,$F5,$07,$7E,$02,$00,$08,$FF,$7F,$00,$EC,$F5,$7F,$02,$00,$07
	db $FF,$7F,$00,$ED,$F5,$7F
	
;***************************
;***************************
;Hyper Charge Charging Sprite Assembly (All 26 pointers)
;***************************
org $90AD35
	db $02,$00,$FA,$15,$7F,$00,$FA,$DF,$7F,$02,$00,$FA,$14,$7F,$00,$FA
	db $E0,$7F,$04,$00,$FA,$13,$7E,$00,$FA,$E1,$7E,$00,$14,$FA,$7F,$00
	db $E0,$FA,$7F,$04,$00,$FA,$12,$7E,$00,$FA,$E2,$7E,$00,$13,$FA,$7F
	db $00,$E1,$FA,$7F,$06,$00,$12,$FA,$7E,$00,$E2,$FA,$7E,$00,$0E,$0E
	db $7F,$00,$E6,$E6,$7F,$00,$FA,$11,$7D,$00,$FA,$E3,$7D,$06,$00,$11
	db $FA,$7E,$00,$E3,$FA,$7E,$00,$0D,$0D,$7F,$00,$E7,$E7,$7F,$00,$FA
	db $10,$7D,$00,$FA,$E4,$7D,$08,$00,$0C,$0C,$7E,$00,$E8,$E8,$7E,$00
	db $0E,$E6,$7F,$00,$E6,$0E,$7F,$80,$FA,$0F,$7C,$00,$FA,$E5,$7C,$00
	db $10,$FA,$7D,$00,$E4,$FA,$7D,$08,$00,$0B,$0B,$7E,$00,$E9,$E9,$7E
	db $00,$0D,$E7,$7F,$00,$E7,$0D,$7F,$00,$0F,$FA,$7D,$00,$E5,$FA,$7D
	db $80,$FA,$0E,$7C,$00,$FA,$E6,$7C,$0A,$00,$0C,$E8,$7E,$00,$E8,$0C
	db $7E,$00,$04,$12,$7F,$00,$F0,$E2,$7F,$00,$0E,$FA,$7C,$00,$E6,$FA
	db $7C,$00,$FA,$0D,$FF,$00,$FA,$E7,$FF,$00,$0A,$0A,$7D,$00,$EA,$EA
	db $7D,$0A,$00,$0B,$E9,$7E,$00,$E9,$0B,$7E,$00,$04,$11,$7F,$00,$F0
	db $E3,$7F,$00,$0D,$FA,$7C,$00,$E7,$FA,$7C,$00,$FA,$0C,$FF,$00,$FA
	db $E8,$FF,$00,$09,$09,$7D,$00,$EB,$EB,$7D,$0C,$00,$03,$10,$7E,$00
	db $F1,$E4,$7E,$00,$12,$EF,$7E,$00,$E2,$05,$7E,$C0,$08,$08,$7C,$00
	db $EC,$EC,$7C,$00,$0C,$FA,$FF,$00,$E8,$FA,$FF,$C0,$FA,$0B,$D0,$00
	db $FA,$E9,$D0,$00,$0A,$EA,$7D,$00,$EA,$0A,$7D,$0C,$00,$03,$0F,$7E
	db $00,$F1,$E5,$7E,$00,$11,$F0,$7E,$00,$E3,$04,$7E,$80,$07,$07,$7C
	db $00,$ED,$ED,$7C,$00,$0B,$FA,$FF,$00,$E9,$FA,$FF,$C0,$FA,$0A,$D0
	db $00,$FA,$EA,$D0,$00,$09,$EB,$7D,$00,$EB,$09,$7D,$0C,$00,$10,$F0
	db $7E,$00,$E4,$04,$7E,$00,$F0,$12,$7F,$00,$04,$E2,$7F,$C0,$08,$EC
	db $7C,$00,$EC,$08,$7C,$00,$06,$06,$FF,$00,$EE,$EE,$FF,$40,$0A,$FA
	db $D0,$00,$EA,$FA,$D0,$00,$02,$0E,$7D,$00,$F2,$E6,$7D,$0C,$00,$0F
	db $F1,$7E,$00,$E5,$03,$7E,$00,$F0,$11,$7F,$00,$04,$E3,$7F,$C0,$07
	db $ED,$7C,$00,$ED,$07,$7C,$00,$05,$05,$FF,$00,$EF,$EF,$FF,$C0,$09
	db $FA,$D0,$00,$EB,$FA,$D0,$00,$02,$0D,$7D,$00,$F2,$E7,$7D,$0C,$00
	db $F1,$10,$7E,$00,$03,$E4,$7E,$00,$E2,$F0,$7F,$00,$12,$04,$7F,$00
	db $01,$0C,$7C,$00,$F3,$E8,$7C,$00,$06,$EE,$FF,$00,$EE,$06,$FF,$C0
	db $04,$04,$D0,$00,$F0,$F0,$D0,$00,$0E,$F1,$7D,$00,$E6,$03,$7D,$0C
	db $00,$F1,$0F,$7E,$00,$03,$E5,$7E,$00,$E3,$F0,$7F,$00,$11,$04,$7F
	db $C0,$01,$0B,$7C,$00,$F3,$E9,$7C,$00,$05,$EF,$FF,$00,$EF,$05,$FF
	db $C0,$03,$03,$D0,$00,$F1,$F1,$D0,$00,$0D,$F2,$7D,$00,$E7,$02,$7D
	db $0A,$00,$E4,$F1,$7E,$00,$10,$03,$7E,$00,$00,$0A,$FF,$00,$F4,$EA
	db $FF,$00,$04,$F0,$D0,$C0,$F0,$04,$D0,$00,$F2,$0E,$7D,$00,$E8,$01
	db $7D,$00,$0C,$F2,$7D,$00,$02,$E6,$7D,$0A,$00,$E5,$F1,$7E,$00,$0F
	db $03,$7E,$00,$00,$09,$FF,$00,$F4,$EB,$FF,$00,$03,$F1,$D0,$C0,$F1
	db $03,$D0,$00,$F2,$0D,$7D,$00,$E9,$00,$7D,$00,$0B,$F3,$7D,$00,$02
	db $E7,$7D,$08,$00,$F3,$0C,$7C,$00,$01,$E8,$7C,$C0,$FF,$08,$D0,$00
	db $F5,$EC,$D0,$00,$0A,$F3,$7C,$00,$EA,$00,$7C,$00,$E6,$F2,$7D,$00
	db $0E,$02,$7D,$08,$00,$F2,$0B,$7C,$00,$02,$E9,$7C,$C0,$FF,$07,$D0
	db $00,$F5,$ED,$D0,$00,$09,$F4,$7C,$00,$EB,$FF,$7C,$00,$0D,$02,$7D
	db $00,$E7,$F2,$7D,$06,$00,$00,$EA,$FF,$00,$F4,$0A,$FF,$00,$0C,$01
	db $7C,$00,$E8,$F3,$7C,$00,$08,$F4,$7C,$00,$EC,$FF,$7C,$06,$00,$00
	db $EB,$FF,$00,$F4,$09,$FF,$00,$0B,$01,$7C,$00,$E9,$F3,$7C,$00,$ED
	db $FE,$7C,$00,$07,$F5,$7C,$04,$00,$FF,$EC,$D0,$C0,$F5,$08,$D0,$00
	db $0A,$00,$FF,$00,$EA,$F4,$FF,$04,$00,$FF,$ED,$D0,$C0,$F5,$07,$D0
	db $00,$09,$00,$FF,$00,$EB,$F4,$FF,$02,$C0,$08,$FF,$D0,$00,$EC,$F5
	db $D0,$02,$C0,$07,$FF,$D0,$00,$ED,$F5,$D0

	
;***************************
;***************************
;Animation Bank & Sprite Assembly split & Dynamic Bank
;***************************	
org $84B952
	JSL DynamicAnimationBank
	NOP #9
	
org $84B96E
	JSL SplitSAAD
	STA $000C
	ASL
	CLC
	ADC $000C
	TAX
	LDA $BF8000,x
	STA $14
	SEP #$20
	LDA $BF8002,x
	PHA
	PLB
	REP #$20
	LDA $7E000E

;***************************
;***************************
;Sets animation data for capsule lightning flash and for when piece is forming on X.
;***************************		
org $BFDD18 ;Sets animation data for capsule lightning flash and for when piece is forming on X.
	db $01,$00,$11
	db $01,$00,$10
	db $01,$00,$0F
	db $01,$00,$0E
	db $01,$00,$0D
	db $01,$00,$0C
	db $01,$00,$0B
	db $02,$00,$1A
	db $02,$00,$1B
	db $02,$00,$1C
	db $02,$00,$1D
	db $02,$00,$1A
	db $02,$00,$1B
	db $02,$00,$1C
	db $01,$01,$1D
	db $02,$00,$1A
	db $02,$00,$1B
	db $02,$00,$1C
	db $02,$00,$1D
	db $02,$00,$1A
	db $02,$00,$1B
	db $02,$00,$1C
	db $01,$01,$1D
	db $02,$40,$1A
	db $02,$00,$1B
	db $02,$80,$1C
	db $FD,$FF
	
org $BFFD68 ;Sets animation data for capsule lightning flash and when X does his victory pose?
	db $01,$00,$14
	db $01,$00,$14
	db $07,$00,$14
	db $04,$80,$14
	db $FD,$FF
	
org $93C3AE ;Removes the entirety of the lightning flash appearing again when PC's do their victory stance when obtaining capsule.
	NOP #15
;***************************
;***************************
;Alters a single byte in X's Vertical Dash sprite assembly as there's a bug in one frame of it being misaligned
;***************************
org $8F9B28
	db $FC ;Changes the X coordinate of the foot armor graphic so it lines up properly on X
	
	
	
;***************************
;***************************
;Password Screen Cursor
;***************************	
org $8FF1D9 ;Base Sprite Assembly for Password Screen Cursor
db $04		;How many pieces for Cursor Frame #1
db $80		;Direction of sprite
db $F1,$07	;X/Y coordinates
db $57		;Graphic to use

db $C0		;Direction of sprite
db $25,$07	;X/Y coordinates
db $57		;Graphic to use

db $40		;Direction of sprite
db $25,$F2	;X/Y coordinates
db $57		;Graphic to use

db $00		;Direction of sprite
db $F1,$F2	;X/Y coordinates
db $57		;Graphic to use



db $04		;How many pieces for Cursor Frame #2
db $C0		;Direction of sprite
db $25,$07	;X/Y coordinates
db $58		;Graphic to use

db $80		;Direction of sprite
db $F1,$07	;X/Y coordinates
db $58		;Graphic to use

db $40		;Direction of sprite
db $25,$F2	;X/Y coordinates
db $58		;Graphic to use

db $00		;Direction of sprite
db $F1,$F2	;X/Y coordinates
db $58		;Graphic to use



db $04		;How many pieces for Cursor Frame #3
db $80		;Direction of sprite
db $F1,$07	;X/Y coordinates
db $59		;Graphic to use

db $C0		;Direction of sprite
db $25,$07	;X/Y coordinates
db $59		;Graphic to use

db $40		;Direction of sprite
db $25,$F2	;X/Y coordinates
db $59		;Graphic to use

db $00		;Direction of sprite
db $F1,$F2	;X/Y coordinates
db $59		;Graphic to use



db $04		;How many pieces for Cursor Frame #4
db $C0		;Direction of sprite
db $25,$07	;X/Y coordinates
db $5A		;Graphic to use

db $80		;Direction of sprite
db $F1,$07	;X/Y coordinates
db $5A		;Graphic to use

db $40		;Direction of sprite
db $25,$F2	;X/Y coordinates
db $5A		;Graphic to use

db $00		;Direction of sprite
db $F1,$F2	;X/Y coordinates
db $5A		;Graphic to use
;***************************
;***************************
;Alters Frog Armor Walking Sprite Assembly pointers so it has proper walking sprite assembly (Starts at 93:8000)
;***************************
org $8D96F2 ;This blanks out all walking frames for Frog Armor
	padbyte $FF
	pad $8D970D
	
	dl FrogArmor_Walk1 ;Long word to load proper sprite assembly for Frog Armor walking frame #1
	dl FrogArmor_Walk2 ;Long word to load proper sprite assembly for Frog Armor walking frame #2
	dl FrogArmor_Walk3 ;Long word to load proper sprite assembly for Frog Armor walking frame #3
	dl FrogArmor_Walk4 ;Long word to load proper sprite assembly for Frog Armor walking frame #4
	dl FrogArmor_Walk5 ;Long word to load proper sprite assembly for Frog Armor walking frame #5
	dl FrogArmor_Walk6 ;Long word to load proper sprite assembly for Frog Armor walking frame #6
	dl FrogArmor_Walk7 ;Long word to load proper sprite assembly for Frog Armor walking frame #7
	dl FrogArmor_Walk8 ;Long word to load proper sprite assembly for Frog Armor walking frame #8
	dl FrogArmor_Walk9 ;Long word to load proper sprite assembly for Frog Armor walking frame #9

	
org $138000
FrogArmor_Walk1:
db $22 ;How many total chunks
db $01,$FC,$E7,$53
db $01,$F4,$E7,$52
db $81,$10,$05,$4D
db $01,$08,$05,$43
db $01,$10,$ED,$4D
db $01,$08,$ED,$4C
db $21,$11,$F5,$46
db $21,$01,$F5,$44
db $01,$1A,$F1,$59
db $01,$1A,$01,$58
db $01,$1A,$F9,$48
db $00,$F8,$17,$18
db $00,$F8,$0F,$08
db $20,$00,$0F,$09
db $20,$FE,$02,$06
db $00,$03,$FF,$2B
db $00,$00,$F4,$2E
db $20,$F7,$00,$04
db $00,$F8,$F4,$2D
db $00,$EB,$18,$18
db $00,$EB,$10,$08
db $20,$F3,$10,$09
db $00,$F0,$F4,$2C
db $20,$F2,$04,$06
db $00,$FB,$FF,$2A
db $00,$F3,$FF,$29
db $20,$00,$EF,$02
db $20,$F0,$EF,$00
db $81,$EC,$ED,$43
db $81,$F4,$05,$4D
db $01,$EC,$05,$43
db $01,$E5,$FD,$54
db $01,$E5,$F5,$42
db $21,$ED,$F5,$40

FrogArmor_Walk2:
db $22 ;How many total chunks
db $01,$FC,$E6,$53
db $01,$F4,$E6,$52
db $81,$10,$04,$4D
db $01,$08,$04,$43
db $01,$10,$EC,$4D
db $01,$08,$EC,$4C
db $21,$11,$F4,$46
db $21,$01,$F4,$44
db $01,$1A,$F0,$59
db $01,$1A,$00,$58
db $01,$1A,$F8,$48
db $00,$F7,$16,$18
db $00,$F7,$0E,$08
db $20,$FF,$0E,$09
db $20,$FD,$01,$06
db $00,$03,$FE,$2B
db $00,$00,$F3,$2E
db $20,$F7,$FF,$04
db $00,$F8,$F3,$2D
db $00,$EB,$18,$18
db $00,$EB,$10,$08
db $20,$F3,$10,$09
db $00,$F0,$F3,$2C
db $20,$F2,$04,$06
db $00,$FB,$FE,$2A
db $00,$F3,$FE,$29
db $20,$00,$EE,$02
db $20,$F0,$EE,$00
db $81,$EC,$EC,$43
db $81,$F4,$04,$4D
db $01,$EC,$04,$43
db $01,$E5,$FC,$54
db $01,$E5,$F4,$42
db $21,$ED,$F4,$40

FrogArmor_Walk3:
db $22 ;How many total chunks
db $01,$FC,$E6,$53
db $01,$F4,$E6,$52
db $81,$10,$04,$4D
db $01,$08,$04,$43
db $01,$10,$EC,$4D
db $01,$08,$EC,$4C
db $21,$11,$F4,$46
db $21,$01,$F4,$44
db $01,$1A,$F0,$59
db $01,$1A,$00,$58
db $01,$1A,$F8,$48
db $00,$F4,$16,$18
db $00,$F4,$0E,$08
db $20,$FC,$0E,$09
db $20,$FB,$01,$06
db $00,$03,$FE,$2B
db $00,$00,$F3,$2E
db $20,$F7,$FF,$04
db $00,$F8,$F3,$2D
db $00,$EF,$18,$18
db $00,$EF,$10,$08
db $20,$F7,$10,$09
db $00,$F0,$F3,$2C
db $20,$F5,$04,$06
db $00,$FB,$FE,$2A
db $00,$F3,$FE,$29
db $20,$00,$EE,$02
db $20,$F0,$EE,$00
db $81,$EC,$EC,$43
db $81,$F4,$04,$4D
db $01,$EC,$04,$43
db $01,$E5,$FC,$54
db $01,$E5,$F4,$42
db $21,$ED,$F4,$40

FrogArmor_Walk4:
db $22 ;How many total chunks
db $01,$FC,$E7,$53
db $01,$F4,$E7,$52
db $81,$10,$05,$4D
db $01,$08,$05,$43
db $01,$10,$ED,$4D
db $01,$08,$ED,$4C
db $21,$11,$F5,$46
db $21,$01,$F5,$44
db $01,$1A,$F1,$59
db $01,$1A,$01,$58
db $01,$1A,$F9,$48
db $00,$F2,$18,$18
db $00,$F2,$10,$08
db $20,$FA,$10,$09
db $20,$F9,$03,$06
db $00,$03,$FF,$2B
db $00,$00,$F4,$2E
db $20,$F7,$00,$04
db $00,$F8,$F4,$2D
db $00,$F0,$18,$18
db $00,$F0,$10,$08
db $20,$F8,$10,$09
db $00,$F0,$F4,$2C
db $20,$F6,$04,$06
db $00,$FB,$FF,$2A
db $00,$F3,$FF,$29
db $20,$00,$EF,$02
db $20,$F0,$EF,$00
db $81,$EC,$ED,$43
db $81,$F4,$05,$4D
db $01,$EC,$05,$43
db $01,$E5,$FD,$54
db $01,$E5,$F5,$42
db $21,$ED,$F5,$40

FrogArmor_Walk5:
db $22 ;How many total chunks
db $01,$FC,$E8,$53
db $01,$F4,$E8,$52
db $81,$10,$06,$4D
db $01,$08,$06,$43
db $01,$10,$EE,$4D
db $01,$08,$EE,$4C
db $21,$11,$F6,$46
db $21,$01,$F6,$44
db $01,$1A,$F2,$59
db $01,$1A,$02,$58
db $01,$1A,$FA,$48
db $00,$F2,$18,$18
db $00,$F2,$10,$08
db $20,$FA,$10,$09
db $20,$F9,$04,$06
db $00,$03,$00,$2B
db $00,$00,$F5,$2E
db $20,$F7,$01,$04
db $00,$F8,$F5,$2D
db $00,$F0,$18,$18
db $00,$F0,$10,$08
db $20,$F8,$10,$09
db $00,$F0,$F5,$2C
db $20,$F6,$04,$06
db $00,$FB,$00,$2A
db $00,$F3,$00,$29
db $20,$00,$F0,$02
db $20,$F0,$F0,$00
db $81,$EC,$EE,$43
db $81,$F4,$06,$4D
db $01,$EC,$06,$43
db $01,$E5,$FE,$54
db $01,$E5,$F6,$42
db $21,$ED,$F6,$40

FrogArmor_Walk6:
db $22 ;How many total chunks
db $01,$FC,$E7,$53
db $01,$F4,$E7,$52
db $81,$10,$05,$4D
db $01,$08,$05,$43
db $01,$10,$ED,$4D
db $01,$08,$ED,$4C
db $21,$11,$F5,$46
db $21,$01,$F5,$44
db $01,$1A,$F1,$59
db $01,$1A,$01,$58
db $01,$1A,$F9,$48
db $00,$F3,$18,$18
db $00,$F3,$10,$08
db $20,$FB,$10,$09
db $20,$FA,$04,$06
db $00,$03,$FF,$2B
db $00,$00,$F4,$2E
db $20,$F7,$00,$04
db $00,$F8,$F4,$2D
db $00,$EF,$17,$18
db $00,$EF,$0F,$08
db $20,$F7,$0F,$09
db $00,$F0,$F4,$2C
db $20,$F4,$02,$06
db $00,$FB,$FF,$2A
db $00,$F3,$FF,$29
db $20,$00,$EF,$02
db $20,$F0,$EF,$00
db $81,$EC,$ED,$43
db $81,$F4,$05,$4D
db $01,$EC,$05,$43
db $01,$E5,$FD,$54
db $01,$E5,$F5,$42
db $21,$ED,$F5,$40

FrogArmor_Walk7:
db $22 ;How many total chunks
db $01,$FC,$E6,$53
db $01,$F4,$E6,$52
db $81,$10,$04,$4D
db $01,$08,$04,$43
db $01,$10,$EC,$4D
db $01,$08,$EC,$4C
db $21,$11,$F4,$46
db $21,$01,$F4,$44
db $01,$1A,$F0,$59
db $01,$1A,$00,$58
db $01,$1A,$F8,$48
db $00,$F3,$18,$18
db $00,$F3,$10,$08
db $20,$FB,$10,$09
db $20,$FA,$04,$06
db $00,$03,$FE,$2B
db $00,$00,$F3,$2E
db $20,$F7,$FF,$04
db $00,$F8,$F3,$2D
db $00,$EE,$16,$18
db $00,$EE,$0E,$08
db $20,$F6,$0E,$09
db $00,$F0,$F3,$2C
db $20,$F3,$01,$06
db $00,$FB,$FE,$2A
db $00,$F3,$FE,$29
db $20,$00,$EE,$02
db $20,$F0,$EE,$00
db $81,$EC,$EC,$43
db $81,$F4,$04,$4D
db $01,$EC,$04,$43
db $01,$E5,$FC,$54
db $01,$E5,$F4,$42
db $21,$ED,$F4,$40

FrogArmor_Walk8:
db $22 ;How many total chunks
db $01,$FC,$E6,$53
db $01,$F4,$E6,$52
db $81,$10,$04,$4D
db $01,$08,$04,$43
db $01,$10,$EC,$4D
db $01,$08,$EC,$4C
db $21,$11,$F4,$46
db $21,$01,$F4,$44
db $01,$1A,$F0,$59
db $01,$1A,$00,$58
db $01,$1A,$F8,$48
db $00,$F5,$18,$18
db $00,$F5,$10,$08
db $20,$FD,$10,$09
db $20,$FC,$04,$06
db $00,$03,$FE,$2B
db $00,$00,$F3,$2E
db $20,$F7,$FF,$04
db $00,$F8,$F3,$2D
db $00,$EC,$16,$18
db $00,$EC,$0E,$08
db $20,$F4,$0E,$09
db $00,$F0,$F3,$2C
db $20,$F2,$01,$06
db $00,$FB,$FE,$2A
db $00,$F3,$FE,$29
db $20,$00,$EE,$02
db $20,$F0,$EE,$00
db $81,$EC,$EC,$43
db $81,$F4,$04,$4D
db $01,$EC,$04,$43
db $01,$E5,$FC,$54
db $01,$E5,$F4,$42
db $21,$ED,$F4,$40

FrogArmor_Walk9:
db $22 ;How many total chunks
db $01,$FC,$E7,$53
db $01,$F4,$E7,$52
db $81,$10,$05,$4D
db $01,$08,$05,$43
db $01,$10,$ED,$4D
db $01,$08,$ED,$4C
db $21,$11,$F5,$46
db $21,$01,$F5,$44
db $01,$1A,$F1,$59
db $01,$1A,$01,$58
db $01,$1A,$F9,$48
db $00,$F7,$18,$18
db $00,$F7,$10,$08
db $20,$FF,$10,$09
db $20,$FE,$04,$06
db $00,$03,$FF,$2B
db $00,$00,$F4,$2E
db $20,$F7,$00,$04
db $00,$F8,$F4,$2D
db $00,$EA,$17,$18
db $00,$EA,$0F,$08
db $20,$F2,$0F,$09
db $00,$F0,$F4,$2C
db $20,$F0,$02,$06
db $00,$FB,$FF,$2A
db $00,$F3,$FF,$29
db $20,$00,$EF,$02
db $20,$F0,$EF,$00
db $81,$EC,$ED,$43
db $81,$F4,$05,$4D
db $01,$EC,$05,$43
db $01,$E5,$FD,$54
db $01,$E5,$F5,$42
db $21,$ED,$F5,$40

