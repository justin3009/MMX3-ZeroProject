;==================================================================================
; Mega Man X3 (Base Mod Project)
; By xJustin3009x (Shishisenkou) (Justin3009)
;==================================================================================
; This file is used to import the code changes for dialogue expansion
; and removing excess dialogue data.
;==================================================================================
; NOTE: The ROM MUST be expanded to 4MB first WITHOUT a header!
;==================================================================================
;***************************
;Blank data
;***************************
;$B9:C1BC - $B9:FFFF

;***************************
;***************************
; ROM Addresses
;***************************
;***************************
header : lorom

incsrc MMX3_NewCode_Locations.asm
incsrc MMX3_VariousAddresses.asm
;***************************
;***************************
;In-Game dialogue setup
;***************************
; Changes $7E:0068 (Pointer to text) to be at $7E:008D so the text bank and pointers can be at $7E:008D-$7E:008F
; This allows for individual banks without having to hard set a universal bank in the code.

org $80E647 ;JSL's to dialogue setup so each PC can have their own banks and pointers for dialogue
	JSL DialogueSetup
	NOP #2
	
org $80E921 ;Removes code that hard sets bank then changes original RAM value so it loads the new location for pointers. After, it increases the DialoguePointer byte.
{
	LDA [$8D] ;Load base dialogue pointer in RAM
	REP #$20
	INC $8D ;Load bank of dialogue pointer in RAM
	SEP #$20
	RTS
	LDA #$00
	STA $00
}

org $80E781 ;Changes RAM value so it loads the new location for pointers/bank
{
	ADC $8D ;ADC dialogue pointer
	STA $8D ;Store back to dialogue pointer	
}
	
;***************************
;Alteration of Key Command so when pressing 'Start' during text, it entirely skips the string.
;***************************
{
org $80E728 ;This is for when pressing start during any part of the dialogue writing
	JSR $E806
	NOP #6
	
org $80E830
	JSR Dialogue_NewPage_Start
	
org $80E806
Dialogue_IncreaseSpeed_Start:
	LDA $0A0F
	BIT #$10
	BEQ Dialogue_IncreaseSpeed_Start_NotPressed
	
	JMP $E7B4
	
	Dialogue_IncreaseSpeed_Start_NotPressed:
	RTS
	
Dialogue_NewPage_Start:
	LDA $0A0F
	BIT #$10
	BEQ Dialogue_NewPage_Start_NotPressed
	
	JMP $E7B4
	
	Dialogue_NewPage_Start_NotPressed:
	INC $1F51
	RTS
}

;***************************
;***************************
;Sub-Weapon text and icon setup in menu for all PCs
;***************************
org $80CC61 ;Loads a JSR to load Exit Icon
{
	CLC
	JSR $D451
	NOP #2 ;Removed since it's merged into the main routine now
}
org $80D1F0 ;Load Exit Icon then X-Buster Icon & Text
{
;Draw Exit Icon
	LDX #$0B ;Load single byte Exit data
	JSR DrawDarkSubWeaponTextIcon
	
	LDX #$0C ;Load single byte Exit data
	JSR DrawDarkSubWeaponTextIcon


;Draw X-Buster Icon
	LDA !CurrentPC_0A8E
	BNE LoadBusterIcon
	LDA !ZSaberObtained_1FB2
	BIT #$80
	BEQ LoadBusterIcon
	LDX #$0D ;Load single byte X-Buster/Z-Saber icon data
	BRA LoadGeneralIcon
	
	LoadBusterIcon:
	LDX #$0A ;Load single byte X-Buster icon data
	
	LoadGeneralIcon:
	LDA !CurrentPCSubWeapon_0A0B
	BNE LoadDarkXBusterIcon
	
	JSR DrawLightSubWeaponTextIcon
	BRA BeginSubWeaponDataDrawing
	
LoadDarkXBusterIcon:
	JSR DrawDarkSubWeaponTextIcon
	
	
BeginSubWeaponDataDrawing: ;Loads sub-weapon text/icons
	LDX #$00
BeginSubWeaponLoading:
	INX
	CPX #$0B ;Max sub-weapon value
	BEQ EndSubWeaponData
	LDA !CurrentPCSubWeapon_0A0B
	STA $0006 ;Store current sub-weapon value
	JSL LoadPCSplitSubWeapon ;Load routine to get proper sub-weapon life bar/text/icon with PC split
	BEQ DecreaseXThenLoop
	
	CPX $0006 ;Compare sub-weapon value to current sub-weapon value in 'X', if the same, load 'LIGHT' text.
	BNE LoadDarkSubWeaponData
	
	DEX
	JSR DrawLightSubWeaponTextIcon
	INX
	BRA DecreaseXThenLoop
	
LoadDarkSubWeaponData:
	DEX
	JSR DrawDarkSubWeaponTextIcon
	INX
DecreaseXThenLoop:
	BRA BeginSubWeaponLoading
EndSubWeaponData:
	RTS
	
	
	
DrawLightSubWeaponTextIcon:
	LDA #$30
	JSR DrawSubWeaponText
	LDA #$28
	JSR DrawSubWeaponIcon
	RTS
	
DrawDarkSubWeaponTextIcon:
	LDA #$3C
	JSR DrawSubWeaponText
	LDA #$34
	JSR DrawSubWeaponIcon
	RTS
	



DrawSubWeaponText: ;Sets and draws data for sub-weapon text/sub-weapon text X/Y coordinates
	STA $0002
	PHX
	JSL PCSubWeapTextXYCoord
	PLX
subweapontextload:
	LDA [$8D]
	BEQ endsubweapontext
	STA $2118
	LDA $0002
	STA $2119
	INC $8D
	BRA subweapontextload
endsubweapontext:
	RTS
	
	
DrawSubWeaponIcon: ;Sets and draws data for sub-weapon icon X/Y coordinates and graphics
	STA $0003
	STZ $0002
	PHX
	JSL PCSubWeapIconGraphicSetup
	PLX
	
	STA $2118
	INC
	STA $2118
	STA $00
	LDA $10
	CLC
	ADC #$0020
	STA $2116
	
	LDA $00
	CLC
	ADC #$000F
	STA $2118
	INC
	STA $2118
	SEP #$20
	RTS
}
	org $80D373 ;Sets data for DARK sub-weapon text/sub-weapon text X/Y coordinates
{
	PHX
	STA $0001
	NOP
	LDY $00A5
	STY $0002
	STZ $0003
	LDA #$80
	STA $0600,y
	REP #$20
	PHD
	LDA #$0000
	TCD
	JSL PCSubWeapTextXYCoord
	NOP #9
	SEP #$20
darksubtext:
	LDA [$8D]
	BEQ enddarksubtext
	STA $0604,y
	LDA $0001
	STA $0605,y
	INC $8D
	INY #2
	INC $0003
	BRA darksubtext
enddarksubtext:
	TYA
	CLC
	ADC #$04
	STA $00A5
	LDY $0002
	LDA $0003
	ASL A
	STA $0603,y
	PLD
	PLX
	LDA $0001
	RTS

	
org $80D3C9 ;Sets data for DARK sub-weapon icon X/Y coordinates/graphics
	STA $0003
	STZ $0002
	LDY $00A5
	LDA #$80
	STA $0600,y
	STA $0608,y
	LDA #$04
	STA $0603,y
	STA $060B,y
	PHX
	JSL PCSubWeapIconGraphicSetup
	PLX
	NOP #15
}
	
	
;***************************
;***************************
;Loads single byte data setup for moving in the menu to various sub-weapons
;***************************
org $869F65 ;Load single byte data for moving in menu?
	db $0A,$00,$01,$02,$03,$04,$05,$06,$07,$08,$08

;***************************
;***************************
;Sub-Weapon life bars in menu for all PCs
;***************************	
org $80D113
{
	LDA #$80
	STA $2115
	LDA #$28
	STA $004
	
	LDY #$1C ;Load max health of life bar
	LDX #$0A ;Load X-Buster single byte value for life bar X/Y coordinates
	
	LDA !CurrentPCSubWeapon_0A0B
	BNE LoadDarkLifeBarIfSubWeaponOn
	LDA #$30 ;Palette of light life bar
	BRA IgnoreDarkLifeBar
	
	LoadDarkLifeBarIfSubWeaponOn:
	LDA #$3C ;Palette of dark life bar
	
	IgnoreDarkLifeBar:
	JSR $D191 ;Draw sub-weapon life bar
	
	
	LDX #$00

	BeginLifeBarLoop:
	INX
	CPX #$10 ;Max amount of life bars to draw
	BEQ EndLifeBarRoutine
	
	LDA !CurrentPCSubWeapon_0A0B
	STA $0006
	
	JSL LoadPCSplitSubWeapon
	BEQ DecreaseXOfLifeBarThenLoop
	
	AND #$1F
	TAY
	CPX $0006
	BNE LoadDarkLifeBarIfSubWeaponIsNotSame
	
	LDA #$30
	BRA IgnoreDarkLifeBar2
	
	LoadDarkLifeBarIfSubWeaponIsNotSame:
	LDA #$3C
	
	IgnoreDarkLifeBar2:
	DEX
	PHX
	JSR $D191 ;Draw sub-weapon life bar
	PLX
	INX

	DecreaseXOfLifeBarThenLoop:
	BRA BeginLifeBarLoop
	
	EndLifeBarRoutine:
	RTS
}
	
org $80D191 ;Sets data for LIGHT sub-weapon life bar X/Y coordinates
{
	STA $0004
	STY $00
	PHX
	JSL PCSubWeapAmmoXYCoord
	PLX
	NOP #6
}
	
org $80D2EB ;Sets data for DARK sub-weapon life bar X/Y coordinates
{
	PHX
	JSL PCSubWeapAmmoXYCoord
	PLX
	NOP #6
}

;***************************
;***************************
; X/Y coordinates of sub-tanks/sub-tanks text in menu
;***************************
org $869FA2 ;Sub-tank X/Y coordinates
	dw $59B1
	dw $59B5
	dw $5A11
	dw $5A15
	
org $86A07D ;Sub-tank text X/Y coordinates
	dw $5A51
	
org $80D435 ;Sub-tank text
	LDA $9FB0,x

	
org $80D42A ;How many letters to load for S.Tank text
	LDA #$0C ;Goes by total letters * 2

org $869FB0
	db $82,$8B,$83,$70,$7D,$7A,$00 ;S-Tank
;***************************
;***************************
; Removes old Katakana text commands values of 84/85
; Replaces them with:
; 84 - Transition Dr. Light introduction text to proper capsule text
; 85 - Play a SFX
;***************************
org $80E74A ;Command 84
	dw $E7D6
	
org $80E74C ;Command 85
	dw $E7F6

org $80E7D6 ;Command 84: Clears Layer 3 tile map then loads new string
	LDA #$04
	STA $00A3
	STZ $00A4
	LDA !CurrentLevel_1FAE
	ASL A
	TAX
	LDA $CEED,x ;Dr. Light text
	STA $1F46
	JMP $E63E
	RTS
	
org $80E7F6 ;Command 85: Plays a SFX
	LDA [$8D]
	INC $8D
	JSL !PlaySFX
	JMP $E66F ;End routine
	
	
;***************************
;***************************
;Moving anywhere in the menu to display light or dark icons, text etc..
;***************************
{
org $80C769 ;Partial routine rewrite for moving 'down' in menu to get next sub-weapon
	JSL PC_SelectSubWeaponDown_Menu
	; NOP ;Rewritten partially so it increases X only once and the max sub-weapon is '0B' so it properly load single byte sub-weapons
	; INX
	; CPX #$0A
	
org $80C77C ;Partial routine rewrite for moving 'down' in menu to get next sub-weapon
	JSR SplitPCSubWeaponInBank ;Gets sub-weapon life
	BNE $1C
	
org $80C817 ;Partial routine rewrite for moving 'down' in menu to get next sub-weapon
	JSR SplitPCSubWeaponInBank ;Gets sub-weapon life
	
org $80C78B ;Max sub-weapon to check when pressing 'Up'
	JSL PC_SelectSubWeaponUp_Menu
	; LDX #$0A
	; CPX $0A
	
org $80C7F3  ;Partial routine rewrite for moving 'up' in menu to get next sub-weapon
	JSR SplitPCSubWeaponInBank ;Gets sub-weapon life
	
org $80C787 ;Partial routine rewrite for moving 'down' in menu to get next sub-weapon
	NOP #4 ;Removed a 'DEX' so it doesn't decrease double when it only needs single now
	
org $80C7EA ;Removes a TAY and LSR for getting proper sub-weapon to load when moving 'down' in menu.
	NOP #2
	
org $80C80E ;Removes a TAY and LSR for getting proper sub-weapon to load when moving 'down' in menu.
	NOP #2
	
org $80C798 ;Partial routine rewrite for moving 'up' in menu to get next sub-weapon
	JSR SplitPCSubWeaponInBank ;Gets sub-weapon life
	BEQ $EA
	
org $80C7F9 ;Checks for having the Z-Saber obtained and alters X's X-BUSTER icon (Turning Icon Dark)
	JSL XBusterCheckZSaber
	
org $80C81D ;Checks for having the Z-Saber obtained and alters X's X-BUSTER icon (Turning Icon Light)
	JSL XBusterCheckZSaber

org $80C987 ;Load LIGHT exit icon
	LDX #$0B ;Changed to '0B' since it's a single byte now
	
org $80C978 ;Load DARK exit icon
	LDX #$0B ;Changed to '0B' since it's a single byte now


	
org $80FF5A ;Loads PC split sub-weapon
SplitPCSubWeaponInBank:
	JSL LoadPCSplitSubWeapon
	RTS
	
}
	