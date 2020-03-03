;==================================================================================
; Mega Man X3 (Base Mod Project)
; By xJustin3009x (Shishisenkou) (Justin3009)
;==================================================================================
; This file is used to import the code changes for miscellaneous things with no
; specific title.
;==================================================================================
; NOTE: The ROM MUST be expanded to 4MB first WITHOUT a header!
;==================================================================================
;***************************
header : lorom

incsrc MMX3_NewCode_Locations.asm
incsrc MMX3_VariousAddresses.asm
;***************************
;***************************
;***************************
; Gravity Well changes
;***************************
org $81F681 ;Loads original code for something underwater
	JSL PC_GravityWell_UnderwaterBubbles
	NOP #5
	
org $81F6C1 ;Loads original code that set bubbles to appear above water if $7E:1F40 was set
	JSL PC_GravityWell_Bubbles
	NOP #7
	CPX #$00
	BEQ $04
	JML $82D928

org $81B960 ;Wait time before Gravity Well slams enemies
	LDA #$0076
	STA $37

org $B99BCA ;Loads 7E:0550 and checks if it has a BIT set of 08.  If so, it sets the Gravity Well charge animation to slam enemies.
	LDA $0550
	
org $84A266 ;Stores 08 to 7E:0550
	JSL PC_SetGravityWell_Physics
	NOP
	; LDA #$08
	; TSB $0550
	
org $81B9D1 ;Resets the Gravity Well check back to the original PC value that's there
	JSL PC_ResetGravityWell_Physics
	NOP
	; LDA #$08
	; TRB $0550
	
org $84A2A4 ;Loads 7E:0550 and checks if it has a BIT set of 08.  If so, it sets the Gravity Well charge animation to slam enemies.
	LDA $0550
	BIT #$08
	BNE EndGravityWell
	
	DEC $03
	DEC $03
	JSR $B8FB
	
	EndGravityWell:
	RTS
	
org $81A3EC ;Removes 08 from 7E:0550 so it effects little bees for Blast Hornet
	LDA #$08
	TRB $0550

org $81B413 ;Plays SFX when Triad Thunder is charged and unleashed. (Removed as it permanently breaks a sound channel)
	NOP #6
	
org $81B2E0 ;Load data for Triad Thunder then play a new SFX
	JSL TriadThunderSFX
	
org $81B187 ;Play SFX for charged Triad Thunder. (Removed as it's not necessary here)
	NOP #6
	
org $81AA42 ;Time before Tornado Fang launches
	LDA #$17 ;Changed to 15 so it cuts time in half before it launches away
	

;***************************
;***************************
; Move missile object loading JMP to new location
;***************************
org $80DBFF ;Load routine to load missile object pointers
	JSL LoadPCMissiles
	RTS
	NOP #2

	
;***************************
;***************************
;Splits PC's Level 2 Buster into a new missile type so the damage type can be separated from Level 4 buster. This will fix the repeated damage issue.
;**************************
org $84A4F8 ;Removes base missile addition for Zero's missiles as it's exactly the same as X's.
	;Actually this is incorrect. This needs to be set back to it's original code because X/Zero have somewhat separate missiles and this causes an issue with Zero's Level 5 buster shot..how dumb.
	;LDA $59
	;LSR
	;NOP #11
	
	LDA !CurrentPCShort_B6
	ASL #2
	STA $0006
	LDA $59
	LSR
	CLC
	ADC $0006

org $86B337 ;Sets Level 2 buster missile as object #26 (Start of NEW missile objects for X)
	db $26
	
org $86B33F ;Sets Level 2 buster missile as object #26 (Start of NEW missile objects for Zero)
	db $26


;***************************
;***************************
;Moving data that dictates whether PCs fire or not for their attacks
;**************************
org $86B3DB ;Removes original data setup for whether PCs fire or not
	padbyte $FF
	pad $86B400

org $84A498 ;Changes location of where to load whether PCs fire or not data when standing still
	LDA $FF50,y
org $84A3BF ;Changes location of where to load whether PCs fire or not data when jumping
	LDA $FF50,y
org $849C89 ;Changes location of where to load what missile PC's fire for level 4/5 buster shots [First shot]
	JSL PC_BusterShot_Level4_5_FirstShot
	NOP #6
org $849CB3 ;Changes location of where to load whether PCs fire or not data when firing level 4/5 buster [Second shot]
	JSL PC_BusterShot_Level4_5_SecondShot
	NOP #8
	

org $86FF50 ;New table for whether PCs fire or not
{
	db $FF,$01,$01,$00,$01,$01,$01,$01,$01,$01,$00,$01,$01,$01,$01,$01
	db $00,$01,$01,$06,$01,$04,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01
	db $01,$01,$01,$01,$01,$01

	;New values
	db $01 ;Level 2 buster missile [Repeat]
	db $01 ;Level 4 Spiral [Zero]
}
