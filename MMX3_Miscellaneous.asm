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
;***************************
; ROM Addresses
;***************************

;***************************
header : lorom

incsrc MMX3_NewCode_Locations.asm
incsrc MMX3_VariousAddresses.asm
;***************************
;***************************
; Loads new routine to send decompressed tile maps straight into VRAM
;***************************
org $80CBAA
	LDY #$B6 ;What decompressed menu tile map to load (Main Menu)
	JSR !LoadDecompressedGraphics
	JSR !SendToVRAM_8162
	
org $21F88C ;Location of 'X-Buster' icon being hard set on Layer 1 in menu. (Removed since all icons can be moved)
	db $0F,$11,$30,$0F,$30,$F0,$40,$0F,$30,$0F,$F4,$40,$D9,$FC,$C0,$F5


	
;***************************
;***************************
; Loads decompressed Menu tiles into VRAM upon loading menu and password screen
;***************************
org $80CB9A ;Tiles for menu screen loading
	LDY #$AE
	JSR !LoadDecompressedGraphics


org $86F43F ;Pointer to compressed menu tile setup(BLANK OUT)
	db $FF,$FF
org $86F60B ;Compressed menu tile setup (BLANK OUT)
	db $FF,$FF,$FF,$FF,$FF,$FF
;***************************
;***************************
; Set text for switching X and Zero. Also, increases the speed of Layer 1 sliding.
;***************************
org $80CA07
	NOP #5
	LDA #$2D ;Sets text to use for switching
	
org $80C9A5
	SBC #$0007 ;Sets speed of Layer 1 moving
org $80C9D4
	ADC #$0007 ;Sets speed of Layer 1 moving
;***************************
;***************************
; Set VRAM location and storage of PC in Main Menu & PC 1-up icon
;***************************
org $80CE50
	JSL PCVRAMGraphicsMenu ;Loads routine to setup PC's VRAM data upon menu load
	
	
 ;Direction/size, X coordinate, Y coordinate, VRAM chunk to use
;***************************
;***************************
; PC's 1-up icon setup/Ride Chip X coordinate, Y coordinate, VRAM, Sprite assembly, Animation Data and palette setup, Armor Pieces X/Y coordinates as well
;***************************	
org $80CE04 ;Original code location that loads Ride Chip menu setup
	padbyte $EA ;Gets NOP'd out as most of the code is moved now.
	pad $80CE30

org $80CE04 ;Original code location that loads Ride Chip menu setup
	JSL PC1UpMenuIconSetup ;Routine that sets each PC's 1-up Graphics, Sprite Assembly, Animation data, VRAM, X/Y coordinates and palette.
	JSL RideChipMenuSetup ;Routine that sets Ride Chip Graphics, Sprite Assembly, Animation Data, VRAM, X/Y coordinates and palette.
	JSL XArmorPiecesAndChips ;Routine that sets X's Armor pieces collected and which ones are Golden as the one active
	
	
	
org $869F7C ;Original code location for HDMA settings in Main Menu
	db $FF,$00,$3F,$24,$63,$10,$FF,$00,$68,$10,$7B,$20,$FF

org $869F9A ;Ride Chip X/Y coordinates
	dw $BF97 ;Ride Chip #1 X/Y coordinates
	dw $BFAC ;Ride Chip #2 X/Y coordinates
	dw $BFC1 ;Ride Chip #3 X/Y coordinates
	dw $BFD6 ;Ride Chip #4 X/Y coordinates
	
org $869FDA ;Ride Chip X/Y coordinates in save menu
	dw $6767 ;Ride Chip #1 X/Y coordinates
	dw $6777 ;Ride Chip #2 X/Y coordinates
	dw $6787 ;Ride Chip #3 X/Y coordinates
	dw $6797 ;Ride Chip #4 X/Y coordinates
	
org $869FBA ;Armor Pieces X/Y coordinates
	dw $B097 ;Helmet X/Y coordinates
	dw $B0AC ;Armor X/Y coordinates
	dw $B0C1 ;Buster X/Y coordinates
	dw $B0D6 ;Leg X/Y coordinates

org $80CC2C
	JSL RideChipPalette
	NOP #2
	
;*********************************************************************************
; Sets VRAM of 1-up icon for PC's in main menu
;*********************************************************************************
org $80CC45
	JSL PC1UpMenuVRAMSetup
	NOP #3
	
;***************************
;***************************
; Setting PC icon when leaving menu
;***************************
org $84DCC5
	JSL CurrentSubWeaponDouble
	BEQ LoadPCIconRoutine
	ADC #$7E
	TAY
	JSL !LoadSubWeaponIcon ;Debatable on what this is? Maybe just sub-weapon icon.
	BRA LoadPCIconRoutine

	LDA !CurrentPCSubWeapon_0A0B
	ASL
	BEQ LoadPCIconRoutine
	CLC
	ADC #$3E
	TAY
	JSL $80872F ;Load sub-weapon icon routine

LoadPCIconRoutine:
	LDA !CurrentPCAction_09DA
	CMP #$2C
	BEQ LoadRideArmorIcon
	JSL PCIconRoutine
	BRA IgnoreRideArmorIcon
	
LoadRideArmorIcon:
	LDY #$5E
	JSL !LoadSubWeaponIcon ;Debatable on what this is? Maybe just sub-weapon icon.
	
IgnoreRideArmorIcon:
	padbyte $EA
	pad $84DCFB

;***************************
;***************************
; Sets PC portrait palettes in menu
;***************************
org $869F91 ;Portrait sprite assembly/palettes
	padbyte $FF
	pad $869F9A
	
;Insert here?
org $80CDD6 ;Check value for 'Static Portrait'
	CMP #$08
org $80C9F8 ;Check value for 'Static Portrait'
	CMP #$08
	

org $80CE65
	JSL PCPortraitPaletteSetup ;Loads routine that loads PC's portrait palettes in the menu.
	LDA $1F11
	AND #$00FF
	CMP #$0008
	BNE SetPaletteInRAM
	LDA #$007D ;Static portrait sprite assembly
	STA $16
	LDY #$012E ;Static portrait palette
SetPaletteInRAM:
	
;***************************
;***************************
; Determines whether a PC can exit or level or not
;***************************
org $80CEF4 ;Loads original code location that determines whether you can exit levels or not.
	JSL PC_ExitLevels
	RTS
	
;***************************
;***************************
; Allows screen to slide to the right/left so PC's can swap in menu
;***************************
org $80CAA9 ;When pressing 'R'
	JSL Double1EE2 ;Load routine that doubles current menu action you're doing to prevent game from crashing with new values.
	NOP
	
org $80CA81 ;When pressing 'L'
	JSL Double1EE2 ;Load routine that doubles current menu action you're doing to prevent game from crashing with new values.
	NOP
	
	
	
	
	
	
	
	
	
;Various palette changes
;***************************
;***************************
; Palette setup for portraits in the menu
;***************************
;Menu Palette for PC portraits
org $868180 ;Zero's Black Armor Portrait palette setup
	db $10 ;How many bytes
	dw $F408 ;Palette location (0C:F408)
	dw $0080 ;RAM location and END
	
org $868185 ;X's Golden Armor Portrait palette setup
	db $10 ;How many bytes
	dw $F428 ;Palette location (0C:F428)
	dw $0080 ;RAM location and END


org $8CF408 ;Zero's Black Armor Portrait palette
	db $88,$31,$08,$01,$8C,$72,$00,$51,$9C,$63,$94,$52,$8C,$31,$6B,$2D
	db $E7,$1C,$A5,$10,$9C,$42,$94,$21,$52,$1D,$18,$4F,$35,$36,$00,$00

org $8CF428 ;X's Golden Armor Portrait palette
	db $90,$42,$FF,$73,$9C,$23,$1C,$01,$BF,$4F,$DE,$0A,$9C,$73,$1D,$12
	db $1E,$09,$10,$11,$9C,$42,$94,$21,$10,$11,$9C,$73,$1E,$09,$00,$00
	
org $8CECA8 ;X's Menu Portrait Palette
	db $90,$42,$9C,$73,$9C,$23,$1C,$01,$0C,$73,$88,$72,$0C,$73,$00,$72
	db $00,$71,$84,$40,$9C,$42,$94,$21,$10,$11,$9C,$73,$10,$42,$00,$00



;For Zero sub-weapon color patch, just have both palettes be blue instead
org $8CF460 ;Zero's Get Weapon palette (Blue)
	db $00,$00,$63,$0C,$E8,$1C,$CE,$39,$B5,$56,$BD,$77,$69,$04,$AC,$0C
	db $52,$15,$DA,$29,$5F,$16,$5F,$4B,$15,$08,$1E,$0C,$60,$35,$A0,$76

org $8CF480 ;Zero's Get Weapon palette (Green)
	db $00,$00,$63,$0C,$E8,$1C,$CE,$39,$B5,$56,$BD,$77,$69,$04,$AC,$0C
	db $52,$15,$DA,$29,$5F,$16,$5F,$4B,$15,$08,$1E,$0C,$80,$01,$00,$03
	
org $8CB104 ;Alters the 'white palette' charge level 1 glitch that I had and alters it back to the original palette
	dw $7FF1



	
	
	
;***************************
;***************************
; Zero's In-Game palette
;***************************
org $86818A ;Zero's Black Armor Portrait palette setup
	db $10 ;How many bytes
	dw $A840 ;Palette location (0C:A840)
	dw $0090 ;RAM location and END

org $8CA840 ;Zero's Black Armor palette
	db $88,$21,$84,$12,$8C,$72,$00,$51,$9C,$63,$94,$52,$8C,$31,$6B,$2D
	db $E7,$1C,$A5,$0C,$94,$21,$9C,$42,$88,$23,$F9,$4E,$D1,$2D,$63,$0C


	
;***************************
;***************************
; Zero's Z-Buster/Sub-Weapon palettes
;***************************
org $86818F ;Zero's Buster/Z-Saber palette (Purple) setup
	db $10 ;How many bytes
	dw $ACC0 ;Palette location (0C:ACC0)
	dw $0080 ;RAM location and END
	
org $8CACC0 ;Zero's Buster/Z-Saber palette (Purple) 
	db $08,$41,$9C,$73,$8C,$73,$08,$73,$84,$72,$00,$72,$6B,$2F,$E7,$1E
	db $67,$1E,$9C,$43,$9C,$03,$9C,$02,$D9,$6E,$37,$6E,$B4,$6D,$32,$61
	
org $8CB5A0 ;Zero's Buster/Z-Saber palette (Regular)
	db $08,$41,$9C,$73,$8C,$73,$08,$73,$84,$72,$00,$72,$8C,$33,$08,$23
	db $88,$22,$9C,$43,$9C,$03,$9C,$02,$94,$53,$8C,$33,$08,$23,$88,$22
	
;Remove comment so this applies Zero's new base palette setup with sub-weapon color patch on.
; org $8CB580 ;Zero's 'base' palette
	; db $88,$21,$8C,$00,$8C,$72,$00,$51,$9C,$63,$94,$52,$8C,$31,$9C,$00
	; db $94,$00,$8C,$00,$94,$21,$9C,$42,$88,$23,$1C,$03,$94,$01,$84,$10
	
; org $8CA840 ;Zero's 'Black Armor' palette
	; db $88,$21,$A5,$0C,$8C,$72,$00,$51,$9C,$63,$94,$52,$8C,$31,$6B,$2D
	; db $E7,$1C,$A5,$0C,$94,$21,$9C,$42,$88,$23,$F9,$4E,$D1,$2D,$63,$0C

	
org $8CFDA0 ;Zero's 'Level 1' charge palette
	db $88,$21,$36,$7E,$B6,$7E,$36,$7E,$D4,$7B,$74,$7B,$03,$72,$E0,$7E
	db $40,$7A,$A4,$79,$94,$21,$9C,$42,$B6,$7E,$6A,$7B,$03,$72,$43,$71
	
org $8CFDC0 ;Zero's 'Level 2' charge palette
	db $88,$21,$03,$72,$E0,$7E,$03,$72,$9C,$7F,$D9,$7E,$33,$7A,$B6,$7E
	db $36,$7E,$D1,$75,$94,$21,$9C,$42,$E0,$7E,$D9,$7E,$33,$7A,$12,$6C
	
org $8CFDE0 ;Zero's 'Level 3' charge palette
	db $88,$21,$3C,$11,$3C,$16,$3C,$11,$FA,$7B,$89,$53,$24,$43,$F1,$43
	db $24,$43,$A4,$22,$94,$21,$9C,$42,$3C,$16,$89,$53,$24,$43,$80,$01
	
	
org $8CFE00 ;Zero 'Acid Burst' palette
	db $88,$21,$8C,$00,$1E,$1F,$F8,$11,$9C,$63,$94,$52,$8C,$31,$F7,$43
	db $AC,$1B,$89,$16,$94,$21,$9C,$42,$88,$23,$1C,$03,$94,$01,$84,$10

org $8CFE20 ;Zero 'Parasitic Bomb' palette
	db $88,$21,$8C,$00,$76,$67,$4E,$42,$9C,$63,$94,$52,$8C,$31,$FF,$03
	db $D7,$02,$8D,$01,$94,$21,$9C,$42,$88,$23,$1C,$03,$94,$01,$84,$10

org $8CFE40 ;Zero 'Triad Thunder' palette
	db $88,$21,$8C,$00,$4F,$27,$2C,$22,$9C,$63,$94,$52,$8C,$31,$14,$7E
	db $0E,$5D,$8C,$3C,$94,$21,$9C,$42,$88,$23,$1C,$03,$94,$01,$84,$10

org $8CFE60 ;Zero 'Spinning Blade' palette
	db $88,$21,$8C,$00,$14,$32,$74,$71,$9C,$63,$94,$52,$8C,$31,$FE,$7D
	db $18,$65,$93,$50,$94,$21,$9C,$42,$88,$23,$1C,$03,$94,$01,$84,$10

org $8CFE80 ;Zero 'Ray Splasher' palette
	db $88,$21,$8C,$00,$D7,$02,$8D,$01,$9C,$63,$94,$52,$8C,$31,$DE,$1E
	db $B8,$11,$F2,$00,$94,$21,$9C,$42,$88,$23,$1C,$03,$94,$01,$84,$10

org $8CFEA0 ;Zero 'Gravity Well' palette
	db $88,$21,$8C,$00,$1C,$53,$14,$32,$9C,$63,$94,$52,$8C,$31,$FE,$7D
	db $18,$65,$93,$50,$94,$21,$9C,$42,$88,$23,$1C,$03,$94,$01,$84,$10

org $8CFEC0 ;Zero 'Frost Shield' palette
	db $88,$21,$8C,$00,$3A,$7E,$74,$71,$9C,$63,$94,$52,$8C,$31,$AF,$7B
	db $29,$6B,$64,$52,$94,$21,$9C,$42,$88,$23,$1C,$03,$94,$01,$84,$10

org $8CFEE0 ;Zero 'Tornado Fang' palette
	db $88,$21,$8C,$00,$DE,$1E,$76,$09,$9C,$63,$94,$52,$8C,$31,$D0,$73
	db $08,$5B,$00,$3A,$94,$21,$9C,$42,$88,$23,$1C,$03,$94,$01,$84,$10
	
org $8681E5 ;Zero's 'Acid Burst' palette setup ;021C
	db $10 ;How many bytes
	dw $FE00 ;Palette location (0C:FE00)
	dw $0090 ;RAM location and END
	
org $8681EA ;Zero's 'Parasitic Bomb' palette setup ;021E
	db $10 ;How many bytes
	dw $FE20 ;Palette location (0C:FE20)
	dw $0090 ;RAM location and END

org $8681EF ;Zero's 'Triad Thunder' palette palette setup ;0220
	db $10 ;How many bytes
	dw $FE40 ;Palette location (0C:FE40)
	dw $0090 ;RAM location and END
	
org $8681F4 ;Zero's 'Spinning Blade' palette setup ;0222
	db $10 ;How many bytes
	dw $FE60 ;Palette location (0C:FE60)
	dw $0090 ;RAM location and END
	
org $8681F9 ;Zero's 'Ray Splasher' palette setup ;0224
	db $10 ;How many bytes
	dw $FE80 ;Palette location (0C:FE80)
	dw $0090 ;RAM location and END
	
org $8681FE ;Zero's 'Gravity Well' palette setup ;0226
	db $10 ;How many bytes
	dw $FEA0 ;Palette location (0C:FEA0)
	dw $0090 ;RAM location and END
	
org $868203 ;Zero's 'Frost Shield' palette setup ;0228
	db $10 ;How many bytes
	dw $FEC0 ;Palette location (0C:FEC0)
	dw $0090 ;RAM location and END
		
org $868208 ;Zero's 'Tornado Fang' palette setup ;022A
	db $10 ;How many bytes
	dw $FEE0 ;Palette location (0C:FEE0)
	dw $0090 ;RAM location and END
	
org $86820D ;Zero's 'Hyper Charge' palette setup ;022C
	db $10 ;How many bytes
	dw $A400 ;Palette location (0C:A400)
	dw $0090 ;RAM location and END
	
;Start any new palettes at $86:825D so weapon palettes have extra room
org $86825D ;Zero's 'Level 1' charge palette ;024C
	db $10 ;How many bytes
	dw $FDA0 ;Palette location (0C:FDA0)
	dw $0080 ;RAM location and END
	
org $868262 ;Zero's 'Level 2' charge palette ;024E
	db $10 ;How many bytes
	dw $FDC0 ;Palette location (0C:FDC0)
	dw $0080 ;RAM location and END
	
org $868267 ;Zero's 'Level 3' charge palette ;0250
	db $10 ;How many bytes
	dw $FDE0 ;Palette location (0C:FDE0)
	dw $0080 ;RAM location and END

;***************************
;***************************
; Capsule palettes for Zero
;***************************
org $868194
BlueFlash1: 
	db $10 ;How many bytes for capsule
	dw $AB80 ;Capsule flash palette location
	db $F0 ;RAM location
	
	db $10 ;How many bytes for Zero
	dw $B580 ;Palette location Zero
	dw $0090 ;RAM location for Zero
		
BlueFlash2:
	db $10 ;How many bytes for capsule
	dw $ABA0 ;Capsule flash palette location
	db $F0 ;RAM location
	
	db $10 ;How many bytes for Zero
	dw $B880 ;Palette location Zero
	dw $0090 ;RAM location for Zero

BlueFlash3:
	db $10 ;How many bytes for capsule
	dw $ABC0 ;Capsule flash palette location
	db $F0 ;RAM location
	
	db $10 ;How many bytes for Zero
	dw $A5E0 ;Palette location Zero
	dw $0090 ;RAM location for Zero
	
	
	
	
org $8681AF
PinkFlash1:
	db $10 ;How many bytes for capsule
	dw $ABE0 ;Capsule flash palette location
	db $F0 ;RAM location
	
	db $10 ;How many bytes for Zero
	dw $B580 ;Palette location Zero
	dw $0090 ;RAM location for Zero
		
PinkFlash2:
	db $10 ;How many bytes for capsule
	dw $AC00 ;Capsule flash palette location
	db $F0 ;RAM location
	
	db $10 ;How many bytes for Zero
	dw $B880 ;Palette location Zero
	dw $0090 ;RAM location for Zero
	
PinkFlash3:
	db $10 ;How many bytes for capsule
	dw $AC20 ;Capsule flash palette location
	db $F0 ;RAM location
	
	db $10 ;How many bytes for Zero
	dw $A5E0 ;Palette location Zero
	dw $0090 ;RAM location for Zero

	
org $8CB880 ;Extra palette for Zero when capsule flashing
	db $88,$21,$84,$12,$8C,$72,$00,$51,$9C,$63,$94,$52,$8C,$31,$9C,$00
	db $94,$00,$8C,$00,$94,$21,$9C,$42,$88,$23,$1C,$03,$94,$01,$88,$21

;***************************
;***************************
; Ride Chip palette setup in menu so it displays colors properly
;***************************
org $8681D0
	db $10 ;How many bytes to write
	dw $AD60 ;Pointer to palette ($8C:AD60)
	dw $00B0 ;Where to write palette in RAM (Doubles to be :0160 so it writes to $7E:0460)
	
;***************************
;***************************
; Zero introduction palette with green chest lights
;***************************
org $8681D5
	db $10 ;How many bytes to write
	dw $F4A0 ;Pointer to palette ($8C:AD60)
	dw $0050 ;Where to write palette in RAM (Doubles to be :0160 so it writes to $7E:0460)
	
org $8CF4A0
	db $E0,$18,$9C,$73,$3F,$4B,$D9,$29,$72,$15,$AC,$0C,$13,$08,$1D,$0C
	db $00,$03,$80,$01,$3F,$16,$69,$04,$B5,$56,$31,$46,$6B,$2D,$63,$0C
	
org $A98C35 ;Tile Map for Zero Introduction chest lights (Top)
	dw $144A
	dw $004B
	db $14
	
org $A98C7A ;Tile Map for Zero Introduction chest lights (Bottom)
	dw $1458
	dw $1459
	
;***************************
;***************************
; Darker Menu Icon Colors (For Save Screen) Sets them as grayscale
;***************************
org $8681E0
	db $10 ;How many bytes to write
	dw $B120
	dw $0050
	
org $8CB120
	db $7F,$13,$94,$52,$AD,$35,$E7,$1C,$CE,$39,$E7,$1C,$8C,$31,$08,$21
	db $AD,$35,$29,$25,$C6,$18,$EF,$3D,$C6,$18,$CE,$39,$29,$25,$00,$00

	
	
;***************************
;***************************
; X's Armored Get Weapon Palettes
;***************************
org $8CFC00 ;X's Armored Get Weapon Palette (Base) (This is HARD set currently! in PCGetWeaponPalette)
	db $D0,$B5,$00,$9C,$01,$B0,$00,$CC,$06,$FC,$08,$80,$17,$88,$1F,$88
	db $AF,$88,$58,$99,$7F,$96,$40,$88,$A5,$94,$8C,$B1,$B5,$D6,$BD,$F7
