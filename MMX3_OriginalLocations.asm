;==================================================================================
; Mega Man X3 (Base Mod Project)
; By xJustin3009x (Shishisenkou) (Justin3009)
;==================================================================================
; This file is used to import the code changes that separate all characters from one
; another so they can have individual stats instead of group stats.
;==================================================================================
; NOTE: The ROM MUST be expanded to 4MB first WITHOUT a header!
;==================================================================================
;*********************************************************************************
;Blank data
;*********************************************************************************
;B9:C1BC - $B9:FFFF
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
; Sets game to FastROM (Have to find a way to make it load RAM as $80+
;***************************
; org $808000 ;Loads original code location that's loaded right when the game is started. (Loads a new location to foce the game as FastROM!)
;A ton of modification has to be done still. ALL RAM needs to load from $80+! There's a ton of PHA PLB commands in the ROM everywhere.
;Might be easier to do a mass replace in the ROM file with this.
; {
	; JML $80FF75
	; REP #$20
	; SEP #$10
	; PHK
	; PLB
	; LDY #$80
	; STY $4301
	
	; SEP #$30
	; NOP
; }
; org $80FF75 ;Loads original code location that sets the game to start. (Updated so it sets the game to FastROM!)
; {
	; SEI
	; CLC
	; XCE
	; REP #$30
	; LDX #$01FF
	; TXS
	; LDA #$0000
	; TCD
	
	; SEP #$20
	; LDA #$01 ;Load #$01
	; STA $420D ;Stores to $420D to initiate FastROM
	
	; LDA #$80
	; STA $2100
	
	; LDA #$00
	; STA $4200
	; STZ $420C
	; STZ $420B
	
	; LDA #$00
	; STA $7EFFFF
	
	; JML $808004
; }
	
;***************************
;***************************
; Fix pitching of Brass instrument
;***************************
org $8BCD3D
	db $30 ;Changes the value from $20 to $30 to fix the out of tune Brass instrument.

;***************************
;***************************
; Changes wording for GAME  START, PASSWORD, OPTION MODE
;***************************
{
org $868FE8 ;GAME  START
	db "New Game   "
org $868FF7 ;PASS WORD
	db "Load Game"
org $869004 ;OPTION MODE
	db "Options    "
	
org $869014 ;GAME  START
	db "New Game   "
org $869023 ;PASS WORD
	db "Load Game"
org $869030 ;OPTION MODE
	db "Options    "

org $869040 ;GAME  START
	db "New Game   "
org $86904F ;PASS WORD
	db "Load Game"
org $86905C ;OPTION MODE
	db "Options    "
}
;***************************
;***************************
; Various enemy AI changes that remove the hardcoded collision damage that gets set in the AI.
;***************************
{
org $B99CD5 ;Original code location for Blast Hornet's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $83CB21 ;Original code location for Blizzard Buffalo's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $93F2F2 ;Original code location for Gravity Beetle's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $93E53F ;Original code location for Toxic Seahorse's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $93EAFF ;Original code location for Volt Catfish's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $83D0F5 ;Original code location for Crush Crawfish's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $BFE6A7 ;Original code location for Tunnel Rhino's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $93DD4E ;Original code location for Neon Tiger's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $93C65B ;Original code location for Press Disposer Mini-Boss's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $858E9C ;Original code location for Godkarmachine O Inary's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $B2F313 ;Original code location for Godkarmachine O Inary Parts?'s storage for collision damage.
	NOP #4
org $B2F331 ;Original code location for Godkarmachine O Inary's Hand #1 storage for collision damage.
	NOP #4
org $B2F371 ;Original code location for Godkarmachine O Inary's Hand #2 storage for collision damage.
	NOP #4
org $8599C6 ;Original code location for Kaiser Sigma's Parts storage for collision damage.
	NOP #4
org $878E78 ;Original code location for Kaiser Sigma's Parts storage for collision damage.
	NOP #4
	
org $BCBF59 ;Original code location for Shurikein Mini-Boss's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $BCB391 ;Original code location for REX-2000 Mini-Boss's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
org $85A30C ;Original code location for Vile (Ride Armor) Mini-Boss's storage for collision damage.
	NOP #4 ;Removed as a table handles this already
}







;***************************
;***************************
; Loads Zero's death scene at Dr. Cain's lab. (Removed as it's no longer needed)
;***************************
org $849340
	NOP #12
org $8492AB
	NOP #4
org $8492EA
	NOP #4
org $849282
	JSR $A63C
	LDA #$7A
	JSR $B8F4
	NOP #14
	
;***************************
;***************************
; Sets PC's CURRENT health to max upon entering a level
;***************************
org $80A1CB
	LDA #$FF
	STA $09FF
	
;***************************
;***************************
; Plays SFX in menu when you decide to switch characters. (Loads same code but now sets $7E1F12 to 04 so the life bar is not on screen when menu closes)
;***************************
org $80C9FC ;Original code location that plays SFX when switching characters.
	JSL PCSwapNoBar ;Loads routine that does the same thing but then disables the life bar as well so it does not appear on screen.
	NOP #2

;***************************
;***************************
; Loads various code that prevented other PCs to use certain functions
;***************************
{
org $81D699 ;Prevents other PCs from collecting Heart Tanks and Energy Tanks.
	NOP #5
org $93C151 ;Prevents other PCs from opening Dr. Light capsules.
	NOP #5
org $93C23D ;Prevents other PCs from collectiong Dr. Light capsules.
	NOP #5
org $81DA7C ;Prevents other PCs from collecting 1-ups.
	NOP #5
org $80D632 ;Prevents other PCs from using sub-weapons.
	NOP #12
org $84AFC6 ;Prevents other PCs from scrolling through sub-weapons on screen.
	NOP #4
org $81D837 ;Prevents other PCs from filling up Energy Tanks/sub-weapons
	NOP #10
org $80C8A3 ;Prevents other PCs from using Energy Tanks in the menu.
	NOP #5
org $83D777 ;Prevents other PCs from using Ride Armor platforms.
	NOP #5
org $839639 ;Prevents other PCs from using Ride Armors.
	NOP #5
org $81EC2D ;Prevents other PCs from using Vile's factory teleporter.
	NOP #5
org $84CD82 ;Prevents Zero from using Body Armor upgrade
	NOP #5
}

	
;***************************
;***************************
; Sets new sprite assembly for small & large health capsules and changes VRAM refresh to load decompressed graphics from ROM instead.
; Small health capsule now uses a new Sprite Assembly as it's graphics have been shifted to make room for Zero's 1-up icon.
; General VRAM gets decompressed to VRAM at start of game, levels and when you leave the menu.
;***************************
;CA = FB
;CB = FC
;CC = FD
;CD = FE
;Changing Sprite Assembly of small health capsule
org $8DF1F4 ;Frame #1
{
	db $02 ;How many chunks to draw
	db $00,$F8,$FC,$FB ;Chunk #1
	db $40,$00,$FC,$FB ;Chunk #2
}
org $8DF1FD ;Frame #2
{
	db $02
	db $40,$00,$FC,$FC ;Chunk #1
	db $00,$F8,$FC,$FC ;Chunk #2
}
org $8DF206 ;Frame #3
{
	db $02
	db $40,$00,$FC,$FD ;Chunk #1
	db $00,$F8,$FC,$FD ;Chunk #2
}
org $8DF20F ;Frame #4
{
	db $02
	db $40,$00,$FC,$FE ;Chunk #1
	db $00,$F8,$FC,$FE ;Chunk #2
}
org $8DF1C1 ;Frame #1 of large health capsule
{
	db $04
	db $C0,$00,$00,$C3 ;Chunk #1
	db $80,$F8,$00,$C3 ;Chunk #2
	db $40,$00,$F8,$C3 ;Chunk #3
	db $00,$F8,$F8,$C3 ;Chunk #4
}


;Compressed data being removed
{
org $86F3C3 ;Original pointer to general VRAM (Compressed) (Removed as now unused)
	db $FF,$FF
org $86F4A5 ;Bytes to load general VRAM (Compressed) (Removed as now unused)
	db $FF,$FF,$FF,$FF,$FF,$FF
org $86F764 ;Data to decompress general VRAM (Compressed) (Removed as now unused)
	db $FF,$FF,$FF,$FF,$FF
}
	
	
	
org $80A2BA ;Loads general VRAM (Compressed) when starting game/loading levels.
	JSL GeneralVRAMStorage
	NOP

org $80CCD5 ;Loads general VRAM (Compressed) when leaving menu. (Changed to load decompressed graphics routine)
	JSL GeneralVRAMLeaveMenu
	NOP

;***************************
;***************************
; Some PC settings when entering a level
;***************************
org $8481CD ;Loads PC sprite setup upon game start or level start
	JMP NewStartArmorLocation ;Now properly loads new location
	
org $84B5BB ;Stores 00 to Sprite Assembly on introduction (Maybe others?)
	JSR $A63E ;Loads PC code that sets their Sprite Assembly and Armor settings
	
NewStartArmorLocation:
{
	REP #$10
	LDA !XArmorsByte1_7EF418
	LSR
	STA $0000
	
	LDX #$0AE8
	LDY #$0000
	
LoopSetPCArmor:
	LSR $0000
	BCC SkipSetPCArmor
	
	INC $0000,x
	STZ $000A,x
	TYA
	STA $000B,x
	LDA #$5D
	STA $0010,x
	
SkipSetPCArmor:
	REP #$21
	
	TXA
	ADC #$0020
	TAX
	SEP #$20
	INY
	CPY #$0003
	BNE LoopSetPCArmor
	
	SEP #$30
	RTS
}
	
;***************************
;***************************
; Removes excess code not needed for X or Zero
;***************************
org $93C5E9 ;Removes storage of #$80 to !CurrentHealth
	NOP #5
	
;***************************
;***************************
; Set sprite priority of Ride Armors
;***************************
org $839432 ;Checks if you're using the F Ride Armor, if so, set the sprite priority to be ABOVE sprites, othewise, behind.
	JSL SetJumpValues
	JSL RideArmor_SpritePriorities
	
org $85C5F7 ;Sprite priority of junker maverick that holds Ride Armor in Blast Hornet's level
	LDA #$00
	
org $8395EB ;Sprite priority of Ride Armor in Blast Hornet's level when you first retrieve it.
	LDA #$02
	
;***************************
;***************************
; Set ladder coordinates
;***************************
org $849F3F ;Fixes PC's being way above ladder after they get off
	ADC #$001C

;***************************
;***************************
; Ride Armor Pad alterations
;***************************
org $83D75C ;Now checks if you have ANY Ride Armor Chip instead of the first
	LDA !RideChipsOrigin_7E1FD7
	BEQ $25
	NOP
	
org $83D8E3
	NOP #5 ;Checks where you can move down on Ride Armor list. (Removed so you can move anytime)

org $83D8D0
	NOP #5 ;Checks where you can move up on Ride Armor list. (Removed so you can move anytime)

org $83D8F6 ;Original code location that determines whether you can choose a ride armor or not on the pad.
{
	JSL RideArmorSelect ;Loads routine that determines whether you can choose a ride armor or not on the pad.
	NOP #4
	BEQ SkipRideArmorEnd
	BRA ContinueRideArmor
	LDA #$0C
	STA $03
ContinueRideArmor:
	INC $02
	INC $02
	STZ $3A
	LDA #$34
	STA $35
	LDA #$FF
	STA $38
	LDA #$00
	STA $39
SkipRideArmorEnd:
	JMP $D890
	JMP $DAA4
}


;***************************
; Stores PC icon into VRAM when PC data is loaded whatsoever on screen.
;***************************
org $80A2C3
	JSL PCIconBase

;***************************
;***************************
; Removes original palette data pointers location and moves it to bank $C8
; Alters palette code so it has a larger bank usage instead of $86 as it's base.
;***************************	
org $81806B
{
	LDA #$8C ;Bank of where palettes are loaded
	STA $16
	STZ $01
	
	REP #$20
	TYX
	LDA NewPaletteTable,x ;Loads from bank $C8
	STA $10
	NOP
	SEP #$30
}
;*********************************************************************************
;Loads normal game routine but then after loads a new routine to blank out PC RAM area.
;*********************************************************************************
org $8080B0 ;Load routine to end clearing RAM routine at start of game
	JSR $FA3F

org $80FA3F ;Jump to here to allow routine to finish
	JSR $8590
	JSL ClearPCRAM ;Load routine to clear PC RAM
	RTS
	

;*********************************************************************************
;Routines to check PC's life and update it upon entering levels, swapping characters, pre-setting life before entering a level, etc...
;*********************************************************************************
org $8099B5 ;Original code here set PC's health upon selecting 'New Game'. Removed as this is already handled by the 'Heart Tank' routine.
	NOP #5

org $8480C3	;Altered the original code just slightly so it doesn't empty the PC check. It loads !CurrentPCCheck_1FFF and stores to !CurrentPC_0A8E.
{
	LDA !CurrentPCCheck_1FFF
	STA !CurrentPCShort_B6
	JSL HeartTank ;Load brand new routine that determines each PC's max health based on how many heart tanks obtained.
}
	
org $8480D6	;Sets each PC's Max Health to 'FF' upon entering a level so a non-active PC's life won't be blank when swapping out.
;This prevents the other PC's from causing a death upon switch since their max life will be determined as you swap with them.
;This code also sets the JumpDashFlag to 01 to allow the PC's air dash/jumping total be able to be set.
	JSL SetLifeAndSwapHealth
	NOP
	
;*********************************************************************************
; Sets PCs life when swapping characters in a level.
; Now does the same thing but also changes their icons and the PC as well.
;*********************************************************************************
org $848D6D ;Loads entire routine for swapping PCs in-game
{
	LDX $03
	JMP (PCSwap_EventPointers,x)
	
	PCSwap_EventPointers:
	dw PCSwap_Event00
	dw PCSwap_Event02
	dw PCSwap_Event04
	dw PCSwap_Event06
	
	
	PCSwap_Event00:
	{
	INC $03 : INC $03 ;Increases sub-event for PC's action
	JSL PC1UpIcon_CheckAndDisable
	
	INC !DisableMenuOpening_1F4F
	INC !DisableLRSubWeaponScroll_1F45
	
	LDA #$04 ;Sets PC life bar to invisible
	STA !PCHealthBar_1F22
	
	JSL $84D4BF ;Clears out all missiles from PC?
	JSL $848E81 ;Disables all PC charges, current sub-weapon and sets teleport out SFX
	JSR $B6D6 ;Loads PC's general palette in JSR location to JSL
	
	LDA #$20
	TRB $1F40 ;Removes bit for underwater physics on land for PC
	
	INC !DisablePCCharging_0A54
	INC $6E ;Disables something using RAM at 7E:0A46
	
	INC !DisableEnemyProjectiles_1F26
	INC !DisableEnemyAI_1F27
	INC !DisableObjectAnimation_1F28
	INC !DisableEnemyLoading_1F29
	INC !DisableEnemyGraphics_1F2A
	INC !DisableScreenScroll_1F2B
	STZ $0A43 ;Blanks out damage timer so PC doesn't have graphical issues swapping when damaged
	
	JSR $A63C ;Loads general sprite routine setup for PCs
	
	LDA #$7F
	JMP $B8F4
	}
	PCSwap_Event02:
	{
	JSR $B8FB
	
	LDA $0F
	BPL PCSwap_Event02_End
	
	INC $03 : INC $03 ;Increase PC Action sub-event
	STZ $0E
	
	LDA #$1E ;Sets timer for how long it takes for PC to reappear once teleported out
	STA $4E
	JSL PCIconHealth ;Sets PC's life and icon when swapping inside a level then sets the new PC value.
	
	PCSwap_Event02_End:
	JSL PC1UpIcon_CheckAndDisable
	RTS
	}
	PCSwap_Event04:
	{
	PHB
	PHD
	PHP
	
	REP #$20
	LDA #$0000
	TCD
	
	SEP #$20
	JSL PC1UpMenuVRAMSetup
	PLP
	PLD
	PLB
	
	JSL PCGeneralSprite
	JSL !AnimationOneFrame
	
	DEC $4E ;Decreases timer until PC re-appears as new PC
	BEQ PCSwap_Event04_ContinueEvent
	RTS
	
	PCSwap_Event04_ContinueEvent:
	INC $03 : INC $03 ;Increase PC Action sub-event
	INC !PCVisibility_09E6 ;Sets PC as invisible
	JSL PC1UpIcon_CheckAndEnable
	STZ !CurrentPCSubWeaponShort_33 ;Removes any sub-weapon PC has on
	
	JSR $A63C ;Loads general sprite routine setup for PCs
	JSR $B6D6 ;Loads PC's general palette in JSR location to JSL
	JSR $B645 ;Sets PC's hitbox
	
	LDA #$7E
	JSR $B8F4
	
	REP #$20
	JSL PCSwap_TeleportHeight
	SEP #$20
	
	STZ $64 ;Stores 00 to 7E:0A3C
	STZ !PCHealthBar_1F22
	
	LDA #$10
	JSL !PlaySFX
	
	JSL PCBusterPalette ;Loads routine that sets the PC's sub-weapon/buster/Z-Saber palette depending on circumstance.
	SEP #$30
	RTS
	}
	PCSwap_Event06:
	{
	JSR $B8FB ;Loads VRAMRoutineAlt with a JSR to lead to a JSL
	
	LDA $0F
	BMI PCSwap_Event06_ContinueEvent
	RTS
	
	PCSwap_Event06_ContinueEvent:
	DEC !DisablePCCharging_0A54
	STZ $6E ;Disables something using RAM at 7E:0A46
	
	STZ !DisableMenuOpening_1F4F
	STZ !DisableLRSubWeaponScroll_1F45
	STZ !DisableEnemyProjectiles_1F26
	STZ !DisableEnemyAI_1F27
	STZ !DisableObjectAnimation_1F28
	STZ !DisableEnemyLoading_1F29
	STZ !DisableEnemyGraphics_1F2A
	STZ !DisableScreenScroll_1F2B
	STZ $30 ;Stores 00 to 7E:0A08
	
	LDA $5E ;Loads 7E:0A36 to determine if PC is in air or not (00 = Air, 04 = Ground)
	BIT #$04
	BEQ PCSwap_Event06_PCInAirEndEvent
	
	JSL SetJumpValues
	JMP $A6EA
	
	PCSwap_Event06_PCInAirEndEvent:
	JMP $A75B
}
}
;*********************************************************************************
; Sets PC's max health upon level load or after a cut-scene is done when it switches characters by using the Heart Tank routine.
; The original code locations had a storage for their max health but that is removed as the new HeartTank routine covers that.
;*********************************************************************************
org $809B7C ;Sets PC's max health upon entering a level
	JSL HeartTank ;Load the main Heart Tank routine to determine PC's max health.
org $8480C8 ;Set's PC max health after a cut-scene
	JSL HeartTank ;Load the main Heart Tank routine to determine PC's max health.
	
;*********************************************************************************
; Routine to increase PC's health upon retrieving a Heart Tank.
; Does the same thing but now it increases ALL PC's max health.
; DIFFICULTY BASED:
; Normal = Increase ALL PC's max health!
; Hard or above = Increase only CURRENT PC's max health!
;*********************************************************************************	
org $81E9D1 ;Loads code location that originally increased PC's max health when obtaining a Heart Tank.
	JSL HeartTankGet ;Load routine to set PC's new max health upon obtaining a Heart Tank.
	INC !CurrentHealth_09FF
	
;*********************************************************************************
; Sets command to NOT remove the #$80+ value on PC action command when PCs get paused
; THIS IS EXTREMELY EXPERIMENTAL
;*********************************************************************************	
org $84D151 ;This removes a specific check to see if anything was above PC command #$54, if so, it'd FORCE animation reset instead of letting it resume.
	NOP #4
	
	
;*********************************************************************************
; Routine to increase the "Heart Tank" counter when one is obtained.
; Now increases the Heart Tank counter depending on who collects it.
;*********************************************************************************	
org $81E968 ;Load code location that originally increased Heart Tank counter. 
	JSL HeartTankStore ;Load routine to increase the Heart Tank counter for each PC.
	
;*********************************************************************************
; Routine to compare PC's max health to current health to determine if they use to their "low health" animation or not.
; Now checks each PC's max health separately incase of varying health.
;*********************************************************************************
org $84B104 ;Load code location that originally checked the PC's health to determine if they use their "low health" animation or not.
	JSL PCLowHealthAni ;Load routine to check PC's health to determine if they do their low health animation or not.
;*********************************************************************************
	NOP
	
;*********************************************************************************	
; Loads PC's icon when jumping out of a Ride Armor and when opening/closing menu
;*********************************************************************************
org $83A253 ;Loads code location to set PC icon when jumping out of Ride Armor.
	JSL PCIconRoutine  ;Loads routine to set which icon PC will use when jumping out of a Ride Armor.
	NOP #2

org $80D65B ;Loads original code location that set new sub-weapon when leaving menu if the sub-weapon you're changing too isn't what you had equipped.
	JSL PC_Menu_ChangedSubWeapon
	NOP
	
org $80D664
	JSL PCIconRoutine  ;Loads routine to set which icon PC will use when opening and closing menu.
	
;The whole routine checks first if you're on the introduction level and you're anyone other than X, if so, it'll reset you to be X. Otherwise, load proper PC Icon.
;THIS WILL HAVE TO BE UPDATED AS IT WILL BE POSSIBLE TO PLAY AS ZERO ON THE INTRODUCTION LEVEL. MAY NEED TO INCLUDE A NEW BYTE CHECK TO SKIP THE WHOLE PROCESS.

;*********************************************************************************
; Routine to store new sprite Ride Chip sprites into VRAM
; Routine to determine if you're able to swap to X or Zero depending on the level and Z-Saber circumstances.
; Now moved and has a separate table for each character to determine when they can switch.
; Now has a separate routine to determine the portraits of the characters you can swap too as well.
; Now can swap WITH Z-Saber if on New Game+ as long as the Z-Saber value is $E0+
;*********************************************************************************
org $80CBB2 ;Routine to send Ride Chip sprites into VRAM. Then sets routine to determine if you can swap PCs or not. Also loads their portraits.
{
	LDY #$AC ;Value to use to get where the data setup is for Ride Chip sprites
	JSR !LoadDecompressedGraphics ;Decompressed graphics routine
	LDY #$BA ;Value to use to get where the data setup is for Menu Armor sprites
	JSR !LoadDecompressedGraphics ;Decompressed graphics routine

	LDA !CurrentPCAction_09DA
	CMP #$2C ;Check if PC action is inside Ride ArmoR
	BEQ PCSwapping_PCCannotSwap
	CMP #$76 ;Check if PC is teleporting already with character swap
	BEQ PCSwapping_PCCannotSwap
	
	JSL PCMenuSwap
	BNE PCSwapping_PCCannotSwap
	BIT $1F5D
	BMI PCSwapping_PCCannotSwap
	
	PCSwapping_PCCanSwap:
	JSL PCMenuPortrait
	BEQ PCSwapping_UseDecompression
	JSR !LoadCompressedGraphics ;Compressed graphics routine
	BRA PCSwapping_IgnoreStaticAndDisabling
	
	PCSwapping_UseDecompression:
	JSR !LoadDecompressedGraphics ;Decompressed graphics routine
	BRA PCSwapping_IgnoreStaticAndDisabling
	
	PCSwapping_PCCannotSwap:
	LDA #$08 ;Sets #$08 so PCs CANNOT swap on menu
	STA $1F11
	LDY #$96 ;Loads compressed static graphics
	JSR !LoadCompressedGraphics ;Compressed graphics routine
	
	PCSwapping_IgnoreStaticAndDisabling:
}

	
org $80D035 ;Original code that checks for BIT being set for Mosquitus warning then sets Layer 1 priority.
;Changed so now it sets Layer 1 priority to what it should be and then sets the Layer 1 coordinates to #$8DFF so it appears on screen properly.
	JSL MosquitusWarningSetLayerProperties
	
;*********************************************************************************
; Routine to draw PC's max health bar on screen.
;*********************************************************************************
org $839058 ;Loads original code location that draws PC's health bar to screen.
{
	JSL HealthDraw ;Load routine to draw PC's health on screen
	LDA #$FF
	STA $10
	LDA #$09
	STA $11
	LDA !CurrentHealth_09FF
	BMI ignoreJMP9194
	JMP $9194
	
ignoreJMP9194:
	AND #$7F
	JSL HealthCompare ;Load routine to compare the PC's health to their current health on screen
	BCC $06
	JSL HealthCMPStore ;Load routine to store PC's Max health to their current health if they have full health.
	NOP #2
}
	
;*********************************************************************************
; Compares PC's current health to max health to determine if they need to heal or not when retrieving a healing object
;*********************************************************************************
org $81D830 ;Load code location to check for general PC healing (Possibly large capsule)
	NOP
	JSL PCHealthGetCMP ;Load routine to determine if PC's health gets filled or not.

org $81D8D9 ;Load code location to check for general PC healing (Possibly small capsule)
	INC
	JSL PCHealthGetCMP ;Load routine to compare PC's max health to what is in a temporary variable to determine if they can heal or not.
	BCC endhealth
	LDA #$04 ;How much health to heal
	STA $03
	LDA $0004
endhealth:
	NOP #3
	STA $09FF

;*********************************************************************************
; Compares PC's current health to max health to determine if they need to heal or not when regenerating from capsule part then continues to sub-tanks
;*********************************************************************************
org $84A9FC
	LDA $C1 ;Check if PC on ground or doing action
	BNE DecPCHealthTimer
	LDA #$00 ;Loads value of #$00 so there's nothing
	STA !PCHealCounter_7EF4EA  ;Store so PC Heal counter variable is #$00
	INC $C1
	REP #$20
	LDA #$0135 ;Timer before health can be restored original
	STA $BF
	
DecPCHealthTimer:
	REP #$20
	DEC $BF ;Timer before health can be restored original
	BNE SkipDisplayHealing
	
	LDA #$00B5 ;Timer before health can be restored
	STA $BF 
	SEP #$20
	LDA $27 ;Loads current PC health
	JSL PCHealthGetCMP ;Load routine to compare PC's max health to what is in a temporary variable to determine if they can heal or not.
	BPL ContinueToSubTanks
	JSL PCIncreaseHealthCounter ;Load routine to increase PC's current health.
	LDA !PCHealCounter_7EF4EA ;Load Heal Counter byte
	ADC $27 ;Add PC's current health
	STA $27 ;Store back to PC's current health
	BRA DisplayHealingAndSound

ContinueToSubTanks:
	JSL PCSubTankHealHealthChip ;Load routine to use the PC's Health Chip to heal current health.
	BNE DisplayHealing
	BRA SkipDisplayHealing
	
DisplayHealingAndSound:
	LDA #$16
	JSL !PlaySFX
DisplayHealing:
	JSR $B6A7
	
SkipDisplayHealing:
	SEP #$20
	RTS
	
;*********************************************************************************
; Sets new X/Y coordinate for health bar in menu then loads new RAM locations for PC's max health.
; Also sets X/Y coordinates of lives counter and PC
;*********************************************************************************
org $80CC74 ;Loads original code location to load a JSR to get PC Health Bar in menu routine
	JSL PCSHealthBar_InMenu ;Routine that loads X and Zero's Health Bars in the menu
	NOP #4

org $80D521 ;Loads original code location for entire routine to load PC's health bar in the menu
	PCHealthBar_LoopLoadHealth:
	LDA $0004
	BEQ PCHealthBar_Load11
	CMP #$04
	BCS PCHealthBar_SetSEC
	STZ $0004
	CLC
	ADC #$11
	BRA PCHealthBar_StoreMiddleGraphic
	
	PCHealthBar_Load11:
	LDA #$11
	BRA PCHealthBar_StoreMiddleGraphic
	
	
	PCHealthBar_SetSEC:
	SEC
	SBC #$04
	STA $0004
	LDA #$15 ;Filler graphic for PC health
	
	PCHealthBar_StoreMiddleGraphic:
	STA $0600,x
	LDA $0007
	STA $0601,x
	INX #2
	DEC $0002
	BNE PCHealthBar_LoopLoadHealth
	
	LDA $0000
	BNE PCHealthBar_LoadDifferentEnd
	
	LDA #$16 ;End graphic for PC Health (End Cap)
	STA $0600,x
	LDA $0007
	STA $0601,x
	BRA PCHealthBar_EndLoadINX
	
	PCHealthBar_LoadDifferentEnd:
	LDA #$17
	CLC
	ADC $0004
	STA $0600,x
	LDA $0007
	STA $0601,x
	
	PCHealthBar_EndLoadINX:
	INX #2
	STX $00A5
	RTL
	
	
org $80D451 ;Loads original code to set X/Y coordinates and counter for PC lives
	JSL PCMenu_1UpCounter
	RTS
	
org $80CE3B ;Original code location to set PC's X/Y coordinates in the menu
	JSL LoadPC_XYCoordinates_Menu
	NOP #4
	
	
	
;*********************************************************************************
; Sets sub-tank data to RAM upon collection
;*********************************************************************************
org $81DC33 ;Load original code location to load a sub-tank to determine if you have one or not.
	JSR $FF77
	
	org $81FF77
		JSL LoadSubTank ;Load routine to load a sub-tank to determine if you have one or not.
		RTS

org $81DC3A ;Load original code location to store sub-tanks upon collecting.
	JSR $FF7C
	
	org $81FF7C
		JSL StoreSubTank ;Load routine to store sub-tanks upon collecting.
		RTS
		
org $81DC3F ;Load original code location to collect the sub-tank and set new values to state which one has been collected.
	JSR $FF81
	
	org $81FF81
		JSL CollectSubTank ;Load routine to collect the sub-tank and set new values to state which one has been collected.
		RTS

;*********************************************************************************
; Load sub-tanks up properly in Main Menu for multiple PCs. This is based on difficulty!
; Normal = Display sub-tanks all PC's have collected by adding all values up!
; Hard or above = Display only the sub-tanks CURRENT PC has collected!
;*********************************************************************************
org $80D485 ;Original routine NOP out
	STZ $0002 ;Sub-Tank counter
	
	BeginSubTankDraw:
	LDX $0002
	JSL DrawSubTank ;Load routine to draw sub-tanks onto menu
	INC $0002
	LDA $0002 ;Load character byte counter from temp. variable $0002
	CMP #$04
	BNE BeginSubTankDraw
	RTS
	
org $80D520 ;Change draw sub-tank routine to RTL
	RTL

;*********************************************************************************
; Select sub-tanks in Main Menu depending on PC having sub-tanks
;*********************************************************************************
org $80C955 ;Checks sub-tanks when moving 'left' from exit icon.
	JSR IgnoreStoreTo ;Load routine that loads another routine to check which sub-tank to load when pressing 'Left'
	BPL $EC
	
org $80C7B2
	JSR $FA4F ;Load routine that loads another routine to check which sub-tank to load when pressing 'Right'
	
org $80FA4F
	STX $0002
	
	IgnoreStoreTo:
	JSL SelectSubTankMenu ;Load routine for selecting sub-tanks in the menu
	RTS
	
;*********************************************************************************
; Select sub-tank and check HP on having sub-tanks
;*********************************************************************************
org $80C8F0 ;Check sub-tank and change the highlighting when selecting
	JSL SelectCheckSubTank
	CMP #$0F
	BCC highlightsubtank
	LDY #$0E
highlightsubtank:
	LDA #$2C
	JSL $80D4AF
	RTS
	
org $80C8D8 ;Check sub-tank and change the highlighting when selecting
	JSL SelectCheckSubTank
	CMP #$0F
	BCC highlightsubtank2
	LDY #$0E
highlightsubtank2:
	LDA #$38
	JSL $80D4AF
	RTS
	
;*********************************************************************************
; Select sub-tank and check another sub-tank for highlighting
;*********************************************************************************
org $80C886 ;Check sub-tank and draw change the highlighting when selecting
	JSR $FF55
	
org $FF55
	JSL SelectNextSubTank
	RTS
	
;*********************************************************************************
; Using sub-tank to recover HP on PC
; DIFFICULTY BASED
;*********************************************************************************
org $80C8A8
	JSL CheckPCMaxHealth ;Load routine to check PC's Max Health when recovering HP using a sub-tank.
	NOP #4
	
org $80C8B4 ;Check sub-tank when USING it.
	JSL UsingSubTank ;Load routine to check what sub-tank you're using while the sub-tank is in use to restore HP.
	NOP
	
org $80C901 ;Routine to rewrite the sub-tank healing routine for PC health (Removed the routine to re-order sub-tanks after use)
	DEC $2A
	BNE SubTankFinished
	
	LDA #$02
	STA $2A
	LDA #$15 ;Play SFX for Sub-Tank being used and healing
	JSL !PlaySFX
	JSL CheckPCMaxHealth ;Checks PC's health when healing with a sub-tank to determine if they're full or not
	BEQ SubTankSetSTZ ;This jumps right to the end of the sub-tank routine if health is == max health.
	INC
	STA !CurrentHealth_09FF
	
	SubTankSkipIncreaseHealth:
	DEC $2B ;Decrease current health left in sub-tank
	LDA $2D
	BEQ GoToSubTankDecrease
	LDA $2B ;Current health inside sub-tank
	LSR
	BCC SkipSubTankDecrease
	
	GoToSubTankDecrease:
	JSL SubTankDecrease
	
	SkipSubTankDecrease:
	LDA $2B ;Current health inside sub-tank
	BNE SubTankFinished
	
	SubTankSetSTZ:
	STZ $34
	STZ $03
	
	SubTankFinished:
	LDA #$30
	JSL LoadMainPCHealthBar
	JSR $D485
	RTS
	
	

;*********************************************************************************
; Filling sub-tank when collecting HP capsules and you have full life
;*********************************************************************************
org $81D837
	NOP #5
	
org $81D84A ;Loads sub-tank to check if health can be stored into it.
	JSR $FF86
	
org $81FF86
	JSL SelectSubTank
	RTS
	
org $81D85C ;Stores health value into sub-tank
	JSR $FF8B
	
org $81FF8B
	JSL StoreToSubTank
	RTS
	
org $81D869 ;Stores health value into sub-tank again
	JSR $FF8B

;*********************************************************************************
; Setting sub-weapon projectile X/Y coordinates with PC's
;*********************************************************************************
org $818C38 ;Load original code location to get each PC's single-byte sub-weapon data to get their X/Y coordinates.
	JSL PCSingleByteSubWeapSetup ;Load routine to get each PC's single-byte sub-weapon data to get their X/Y coordinates.
	
org $818C5A ;Load original code location to get each PC's sub-weapon 'Y' coordinate.
	JSL PCSubWeapYCoordSetup ;Load routine to get each PC's sub-weapon 'Y' coordinate.
	
org $818C45 ;Load original code location to get each PC's sub-weapon 'X' coordinate.
	JSL PCSubWeapXCoordSetup ;Load routine  to get each PC's sub-weapon 'X' coordinate.
	
org $818BA9 ;Load another sub-weapon X/Y coordinate routine
	PHX
	LDA $09EF
	AND #$007F
	TAX
	JSL PCSingleByteSubWeapSetup
	AND #$00FF
	STA $16
	TAX
	BNE skipsubweaponendroutine
	SEC
	BRA endsubweaponroutine
skipsubweaponendroutine:
	JSL PCSubWeapXCoordSetup
	PLX
	PHX
	AND #$00FF
	BIT #$0080
	BEQ skipsubweaponora
	ORA #$FF00
skipsubweaponora:
	STA $02
	BIT $03
	BMI skipsubweaponadditionalxy
	CLC
	ADC $09E0
	STA $0008,x
skipsubweaponadditionalxy:
	LDA $16
	TAX
	JSL PCSubWeapYCoordSetup
	PLX
	PHX
	AND #$00FF
	BIT #$0080
	BEQ skipsubweaponora2
	ORA #$FF00
skipsubweaponora2:
	BIT $0010,x
	BVC skipsubweaponEORINC
	EOR #$FFFF
	INC A
skipsubweaponEORINC:
	CLC
	ADC $09DD
	STA $0005,x
	NOP #29
endsubweaponroutine:
	PLX
	SEP #$30
	PLD
	RTS

org $81BF76 ;Load original code location to get each PC's single-byte Tornado Fang data to get their drill X/Y coordinates.
	JSL PCSingleByteDrillSetup ;Load routine to get each PC's single-byte Tornado Fang data to get their drill X/Y coordinates.
	
org $81BF83 ;Load original code location to get each PC's Tornado Fang 'Y' coordinate.
	JSL PCDrillYCoordSetup ;Load routine to get each PC's Tornado Fang 'Y' coordinate.
	
org $81BF98 ;Load original code location to get each PC's Tornado Fang 'X' coordinate.
	JSL PCDrillXCoordSetup ;Load routine to get each PC's Tornado Fang 'X' coordinate.
	
org $81BFB6 ;Load original code location to get each PC's Tornado Fang animation setup.
	NOP #2
	JSL PCDrillAnimationSetup
	
org $81965B
	PHP
	SEP #$20
	REP #$10
	
	LDA $09CC ;Number counter that constantly goes up.
	AND #$1F ;Change this will change how often the smoke appears
	BNE AcidBurst_Smoke_End
	
	LDA #$01 ;How many smokes appear when Acid Burst hits anything.
		;Changed to 01 so there's far, far less lag.
	STA $3D
	
	REP #$20
	LDA $3A
	PHA

	LDA #$0000 ;X coordinates of acid burst smoke
	STA $0000
	LDA #$0000 ;Y coordinates of acid burst smoke
	STA $0002
	JSR $969E
	
	PLA
	
	AcidBurst_Smoke_End:
	PLP
	RTS
	

;*********************************************************************************
; Load routine that checks whether if you're X's Sprite Assembly or not to use drill
;*********************************************************************************
org $81BECA ;Routine altered so now charged drill can be used by anyone
	NOP #8
	SEP #$20
	
;*********************************************************************************
; Load routine to determine if Hyper Charge can be used
;*********************************************************************************
org $84AA46 ;Loads original code location to determine if Hyper Charge has enough life to be used by PC
	JSL CheckForHyperChargeData ;Loads new routine to specifically check for certain circumstances for Hyper Charge to not work
	NOP
	BCS IgnoreHyperChargeSTZ
	STZ $BE
	
IgnoreHyperChargeSTZ:
	LDX $BE
	JMP ($AA54,x)

	dw $AA5C
	dw $AABF
	dw $AB3D
	dw $AB4A
	
	LDA $02
	CMP #$2C
	BEQ AfterHyperChargeEnd

org $84AA5C ;Load original location to determine which PCs can use the Hyper Charge or not.
	LDA $02
	CMP #$2C
	BEQ HyperChargeEnd
	
	LDX !CurrentPCSubWeaponShort_33 ;Load sub-weapon PC has on
	CPX #$09 ;Checks if you have Hyper Charge equipped
	BNE HyperChargeEnd
	JSL PCHyperChargeUse ;Load routine to determine if PCs can use Hyper Charge or not.
	
	CMP #$40
	BEQ StopHyperChargeBubbles
	CMP #$1D
	BCS StopHyperChargeBubbles
	CMP #$04
	BCS SetHyperChargeChargeLevel ;Hard set value as the whole routine wasn't modified
	
	LDA #$20
	TSB $AC
	LDA #$80
	TRB $AC
	LDA #$04
	TRB $AC
	BEQ HyperChargeEnd
	
	StopHyperChargeBubbles:
	JSL SetHyperChargeOff
	JSR $AD76
	JMP $B6D6
	
SetHyperChargeChargeLevel: ;Sets charge level for each Hyper Charge shot.
	LDA #$02
	STA $BE
	LDA #$02
	TSB $AC
	LDA #$04
	TSB $AC
	BNE EnableHyperChargeBubblesFlash
	
	JSR $B6A2
	
EnableHyperChargeBubblesFlash:
	LDA #$80
	TSB $AC
	STZ $57 ;Blank out current charge time
	LDA #$04
	STA $5A ;Set Hyper Charge Bubbles
	STA $5B ;Set Flashing for PC
	
	LDA #$04
	STA $82
	LDA #$02 ;Which SFX to play when activating Hyper Charge (Charging SFX)
	JSL !PlaySFX
	
HyperChargeEnd:
	RTS
	
AfterHyperChargeEnd:
	
org $818851 ;Load original code location to allow which PC to load Hyper Charge bubbles
	NOP #5 ;Removed the PC check so now this allows any PC to have Hyper Charge bubbles

org $84AAFF ;Load original code location that allowed X to use the Z-Saber with Hyper Charge
	NOP #9 ;Removed now so X CANNOT use the Z-Saber with the Hyper Charge.
	
;*********************************************************************************
; Loads helmet sensor and determines who can use it
;*********************************************************************************
org $84A81C ;Loads original location of code that determined who could use the Helmet Sensor upon entering a level.
	SEP #$30
	JSL PCHelmetSensor ;Load routine to determine who could use the Helmet Sensor upon entering a level.
	NOP

;*********************************************************************************
; Loads body armor upgrade and determines who can use it (Cuts damage in half and generates a force field originally. Force field is removed!)
;*********************************************************************************
org $84CE3C ;Loads original code location to determine who can use the Armor Upgrade to cut damage in half.
	LDA $09FE
	CMP #$7F
	BEQ EndBodyArmorRoutine
	
	JSL PCBodyArmor ;Loads routine to determine who can use the Armor Upgrade to cut damage in half.
	BEQ EndBodyArmorRoutine
	LDA $0000
	STA $0002
	
	LSR $0000
	
	JSL PCBodyChip
	BEQ TestBodyChipDamage
	LDA $0002
	BIT #$08
	BNE DoProper75Percent
	BRA Subtract3Instead
	
	DoProper75Percent:
	LSR $0000
	BRA TestBodyChipDamage
	
	Subtract3Instead:
	DEC $0000
	DEC $0000
	DEC $0000
	
	TestBodyChipDamage:
	LDA $0000
	BEQ SetDamageTo01
	BPL EndBodyArmorRoutine
	
	SetDamageTo01:
	LDA #$01
	STA $0000
	
	EndBodyArmorRoutine:
	RTS
	
org $84869E ;Loads code to play a SFX when you're damaged and are on the ground as the routine finishes
	JSL PC_DamageReset_SetJumpValues
	NOP #2
	
	
;*********************************************************************************
; Loads buster upgrade and determines who can use it (Cuts sub-weapon ammo usage in half)
;*********************************************************************************	
org $84A566 ;Loads sub-weapon ammo usage then determine who can use buster upgrade for halving sub-weapon ammo usage
{
	SEP #$20
	LDX !CurrentPCSubWeapon_0A0B ;Loads PC's current sub-weapon
	BEQ EndSubWeaponHalving01 ;If !CurrentPCSubWeapon_0A0B == 00, jump to EndSubWeaponHalving01 and end routine.
	
	LDA !CurrentPCChargeTime_0A2F ;Loads the current charge time of PC
	CMP #$8C ;Check if the value is #$8C
	BCS LoadChargeSubWeaponAmmo ;If value is >= #$8C, then it loads the LoadChargedSubWeaponAmmo to get the charged ammo usage.
	
	LDA $B353,x ;Load table to get the sub-weapon ammo usage UNCHARGED
	STA $0002 ;Store sub-weapon ammo usage to temp. variable $0002
	STX $0010 ;Store current sub-weapon to temp. variable $0010
	JSL PCBusterUpgrade ;Load routine to determine who is capable of having their sub-weapon ammo usage halved.
	STA $0010 ;Store value to temp. variable $0010
	AND #$1F ;AND #$1F value
	BEQ EndSubWeaponHalving02 ;If == 00, jump to EndSubWeaponHalving02 and end routine.
	JSR CutSubWeaponInHalf ;Jump to CutSubWeaponInHalf to halve the ammo usage of all sub-weapons.
	STZ $0004
	LDA $0006
	CMP #$04
	BNE EndSubWeaponHalving01

LoadChargeSubWeaponAmmo: ;Load routine for charged sub-weapon ammo
	LDA $B368,x ;Load table to get the sub-weapon ammo usage CHARGED
	STA $0002 ;Store sub-weapon ammo usage to temp. variable $0002
	JSL PCBusterUpgrade ;Load routine to determine who is capable of having their sub-weapon ammo usage halved.
	STA $0010 ;Store value to temp. variable $0010
	AND #$1F ;AND #$1F value
	BEQ EndSubWeaponHalving02 ;If == 00, jump to EndSubWeaponHalving02 and end routine.
	JSR CutSubWeaponInHalf ;Jump to CutSubWeaponInHalf to halve the ammo usage of all sub-weapons. 
	LDA #$0B
	STA $0004
	
EndSubWeaponHalving01:
	PLP
	PLY
	CLC
	RTS
	
EndSubWeaponHalving02:
	PLP
	PLY
	SEP #$03
	RTS
	
CutSubWeaponInHalf:
	LDA $0010 ;Load current sub-weapon life
	BVS StoreEmptySubWeapon ;Branches to store empty sub-weapon ammo if underflow occurs
	
;Subtracts sub-weapon life then stores #$00C0 to if empty.	
	SEC ;Set carry flag
	SBC $0002 ;Subtract sub-weapon ammo usage from current sub-weapon ammo
	STA $0010 ;Store new sub-weapon ammo to temp. variable $0010
	CMP #$40 ;Check if it's #$40
	BEQ StoreEmptySubWeapon ;If it's == #$40, jump to StoreEmptySubWeapon so the game knows you have the sub-weapon, but it's empty.
	LDA $0010 ;Load current sub-weapon life
	BNE IgnoreSubWeaponStoreEmpty ;If > 00, jump to IgnoreSubWeaponStoreEmpty to store sub-weapon life properly back to which PC.
StoreEmptySubWeapon:
	LDA #$C0 ;Load value of #$C0 so the game knows you have a sub-weapon but it's empty.
IgnoreSubWeaponStoreEmpty:
	JSR $FFB0 ;Load jump to $84FFB0 to load routine to store the PC's sub-weapon ammo back to whichever PC used it it.
	LDA #$00
	XBA
	RTS
}
	
org $84FFB0 ;Sets storing sub-weapon location for split PCs in bank $84
	JSL StorePCSplitSubWeapon
	RTS
	
org $84FFB5 ;Sets loading sub-weapon location for split PCs in bank $84
	JSL LoadPCSplitSubWeapon
	RTS

;*********************************************************************************
; Loads helmet chip upgrade and determines who can use it (Regenerates life)
;*********************************************************************************
org $84A9E0 ;Load original code location to determine which PC was able to use Helmet Chip Enhancement  life regeneration
	JSL PCHelmetChip ;Load routine to determine which PC can use Helmet Chip Enhancement life regeneration
	NOP #5
	
;*********************************************************************************
; Loads leg upgrade and determines who can use it and the circumstance
; Loads code to determine what each character does for the Vertical Dash animation
;*********************************************************************************
org $84A95B ;Load original code location that determined which PC is able to use the Leg Upgrade
	JSL PCLegUpgrade ;Load routine to determine which PC is able to use the Leg Upgrade
	NOP #5
	
org $84A7BC ;Load original code location that set the animation of the Vertical Dash
	JSL PCVerticalDash ;Load routine to determine which PC uses what animation for the Vertical Dash
	
org $848C20 ;Load original code location that sets the height of the vertical dash
	LDA #$18 ;Height of vertical dash
	STA $52
	
org $848BCA ;Rewrites the Vertical Dash FINISHED animation routine so it does not transition in REVERSE, but rather jumps straight to the Falling Action Command #08
	REP #$20
	STZ $1A
	STZ $1C
	JSR $B645
	
	SEP #$20
	STZ $1F
	LDA #$08 ;Sets action command to go to
	STA $4E
	JSR $B900
	
	LDA #$21 ;Transitionary animation frame
	CLC
	ADC $B2
	JSR $B8F4 ;Updates animation
	JSR $B86C ;Updates VRAM
	JMP $B8FB ;Updates VRAM again
	
org $BFDDA4 ;Animation Data of Vertical Dash. (Altered so it doesn't have broken graphics anymore)
	db $04,$00,$00,$01,$00,$04,$01,$00,$02,$01,$00,$03,$01,$00,$04,$01
	db $80,$05,$EE,$FF



	
;*********************************************************************************
; Sets new jump/dash/air dash code and how many times you can do certain acts in the air
;*********************************************************************************
org $848BB3 ;Code for dashing in air. Altered so now there's no wait time to air dash.
beginairdashalter:
	STZ $4F
	LDA #04
	TSB $87
	JMP $A75B
	
	LDA $37
	BIT #$03
	BCC beginairdashalter
	
org $84A970 ;Original air dash/vertical dash code. Altered so it uses only one RAM value to determine if you can vertical dash, double jump or air dash.
SkipJumpDashDecreaseEnd:
	LDA #$01
	RTS
	
	SEP #$20
	LDA !JumpDashAmount_7EF4E6 ;Load RAM value to determine how many times you can air dash, double jump etc..
	BEQ skipjumpdashdecrease ;If == 00, then jump to skipjumpdashdecrease so it doesn't decrease the value again
	DEC ;Decrease the !JumpDashAmount_7EF4E6 value
	STA !JumpDashAmount_7EF4E6 ;Store back to !JumpDashAmount_7EF4E6
	NOP #11
	JSL $84C9E3
skipjumpdashdecrease:
	BCS SkipJumpDashDecreaseEnd ;Hard set value, never changes.

org $84A31D ;Load original code location that checks for specific PC actions and determines when they can vertical dash or double jump.
	JSL PCDoubleJump ;Load routine that checks for specific PC actions and determines when they can vertical dash or double jump.
	
org $84A79A ;Loads original code location that set the dashing animation
	JSL DashDecreaseJumpDashAmount ;Load routine that decreases JumpDashAmount_7EF4E6 when dashing then sets dash animation
	
org $8488B5 ;Loads original code location that set the wall jump animation
	JSL WallJumpSpeedDecreaseJump ;Loads routine that decreases JumpDashAmount_7EF4E6 when holding the 'A' button then wall jump
	NOP
	
org $8485C8 ;Load original code location that set the landing on ground animation
	JSL GroundLandSetJump ;Load routine that sets JumpDashAmount_7EF4E6 when landing on ground
	
	
org $84A7A8 ;Loads original code location that sets action command to 'Stop Dashing (20)' when ground dash is done
	JSL DashFinish_SetJump
org $84A78D ;Loads original code location that sets action command to 'Wall Slide (12)'
	JSL WallSlide_SetJump
org $84A89D ;Loads original code location that sets action command to 'Getting on ladder (24)'
	JSL GetOnLadder_SetJump
org $84A8AC ;Loads original code location that sets action command to 'Getting off ladder (26)'
	JSL GetOffLadder_SetJump
org $84A8B3 ;Loads original code location that sets action command to 'Begin Climb Ladder DOWN (28)'
	JSL BeginClimbDownLadder_SetJump
org $84A8BA ;Loads original code location that sets action command to 'Climbing Ladder (2A)'
	JSL ClimbingLadder_SetJump
org $84A8C1 ;Loads original code location that sets action command to 'Water Jumping (48)'
	JSL WaterJump_SetJump
org $84D25F ;Loads original code location that sets a higher value for the 'Cut scene (66)' action command.
	JSL SetCutScene_SetJump
		

org $84A9D4 ;Load original code location that checked the button combo to specify what buttons need to be pressed for the vertical dash.
	JSL VerticalDashButtonCombo ;Load routine that checks the button combo to specify what buttons need to be pressed for the vertical dash for each PC
	
org $84948C ;Load original code location to set data for when PC is firing the 2nd time with their level 4 charge shot. (On the ground!)
	JSL Buster_ResetJumpValue
	
;*********************************************************************************
; Sets max weapon select to '12' and leaves 2-bytes for value 14 blank.
;*********************************************************************************
org $80A3B0
	LDX #$12
org $80A3BE
	LDX #$12

org $80C5C7 ;Removes storage of 00 to $7E:1FCD
	NOP #3

;*********************************************************************************
; Disables forcefield from ever spawning with armor upgrades
;*********************************************************************************
org $8487F6 ;Disables routine for Forcefield generating
	NOP #3
org $848691 ;Disables routine for Forcefield generating
	NOP #3
org $8486C4 ;Disables routine for Forcefield generating
	NOP #3
org $848771 ;Disables routine for Forcefield generating
	NOP #3

	
;*********************************************************************************
; Alters X-Buster Cross-Over so it actually 'crosses' instead of full screen spam
; Alters Level 4/Level 5 Helix shot so it doesn't spread out as far so it hits enemies easier
;*********************************************************************************
org $86BBA0 ;Sets upward trajectory (low byte), speed increase over time Sets speed, speed, upward trajectory (high byte) downward trajectory, palette and various other data for Cross-Over Shot
{
	db $00,$00,$00,$F6,$00,$00,$06,$00 ;Main Middle Buster
	
	db $60,$30,$00,$FF,$00,$05,$06,$00 ;1st Top Pellet
	db $A0,$30,$00,$FF,$00,$FB,$06,$00 ;2nd Bottom Pellet
	db $70,$60,$00,$03,$00,$07,$04,$00 ;2nd Top Pellet
	db $90,$60,$00,$03,$00,$F9,$04,$00 ;2nd Bottom Pellet
	db $00,$08,$54,$01,$2D,$DD,$3A,$00 ;Plasma trail, graphics, object to spawn?
}

org $81C5AF ;Routine to have pellets spread out across the screen (Removed so now they cross one another)
	NOP #4
	
org $81C335 ;Alters Helix Shot's pellets after the first collision with enemy to stay closer to one another instead of spreading out
	LDA #$30
	
;*********************************************************************************
; Damage table routine
; Entire routine has been heavily updated to check for new values and instances.
; DIFFICULTY BASED
;*********************************************************************************
org $84CEE3 ;Load original code location to determine how the damage table is setup.
{
	LDA $000A,x
	AND #$00FF
	STA !DamageType_1F2F
	LDA $28
	AND #$00FF
	ASL
	PHX
	TAX
	JSL DamageTableSetup ;Loads routine that sets up the damage table and allows for 'Combo' hits. (IE: Level 4/Level 5 buster shots both hitting without wait)
	
	LDA #$0001
	STA $0004
	LDA $CB0000,x ;Load base bank for damage value
	AND #$00FF
	STA $0000
	PLX
	SEP #$20
	JSL CheckZSaberDamage ;Load routine to determine if the Z-Saber is able to hit multiple times or not.
	PHA
	PLA
}
		
org $84CF38 ;Subtracts damage to take from enemy life
{
	LDA $27
	AND #$7F
	SEC
	SBC $0000
}
	
org $84CF7B ;Sets ZSaberWave damage up
{
	JSL SetZSaberWaveDamage
	
	STA $33
	NOP #2
	LDA #$44
}
	
org $81A5F4 ;Load original code location to determine Gravity Well damage table is using.
	JSL DamageTableGravityWellSetup
	LDA $CB0000,x
	NOP #5
	
org $81B071 ;Load original code location to determine Charged Parasitic Bomb damage table is using.
	JSL DamageTableGravityWellSetup
	LDA $CB0000,x
	NOP #5
	
org $818725 ;Removes #$F0 from Weapon check
	TRB $0550
	
org $93EC7F ;Loads original routine that checks for Tornado Fang on Volt Catfish
	JSL CheckForTornadoFang
	NOP #10

	
;*********************************************************************************
; Loads Head Gunner's data and checks whether you defeated Blast Hornet or not. If so, weaken the Head Gunners. Various other boss checks too
;*********************************************************************************
org $87C479 ;Check Headgunners to see if Blast Hornet is defeated.
	JSL CheckForBlastHornet
	NOP
	
org $80BEB2 ;Check for Blast Hornet defeated so crates do NOT appear in Gravity Beetle stage
	JSR $FA5F
	BEQ $0A
	
org $80FA5F
	JSL CheckGravityBeetleLevel
	RTS
	
org $80BEA7 ;Check Blizzard Buffalo to see if ice is melted off ground
	JSR $FA64
	BEQ $15
	
org $80FA64
	JSL CheckBlizzardBuffaloLevel
	RTS
	
org $82FE80 ;Check Blizzard Buffalo to see if lights are active
	JSR $FF80
	BNE $12
	
org $82FF80
	JSL CheckBlizzardBuffaloLevel
	RTS
	
org $83C5C4 ;Check Blizzard Buffalo to see if HDMA light is on
	JSR $FA74
	BNE $02
	
org $83FA74
	JSL CheckBlizzardBuffaloLevel
	RTS
	
org $87B03B ;Checks Blast Hornet's mid-boss to see if Gravity Beetle is defeated, if so, do NOT spawn the mid-boss air transporter.
	JSL CheckForGravityBeetle
	NOP
	
org $84E097 ;Checks for Volt Catfish to be defeated so Elevator in Vile's Factory works.
	JSL CheckForVoltCatfish
	NOP
	
	
;*********************************************************************************
; Various chunks of code that sets the enemy table to the 'blank' damage table value so enemies can NOT be hit multiple times.
; All of them for bosses has been removed so bosses CAN be hit multiple times depending on the circumstance.
;*********************************************************************************
{
org $B99E43 ;Blast hornet damage table switch
	JSL BossCheckDisableZSaber
org $83CA8E ;Blizzard Buffalo damage table switch
	JSL BossCheckDisableZSaber
org $93EC42 ;Volt Catfish damage table switch
	JSL BossCheckDisableZSaber
	org $93F078 ;Volt Catfish damage timer until he's able to break out of his 'damage' animation from his Invincible form when Tornado Fang hits him.
		LDA #$20
	org $93F092 ;Volt Catfish damage timer until he's able to break out of his 'Idle after Damage' animation from his Invincible form when Tornado Fang hits him.
		LDA #$20
	org $93ECA3 ;Volt Catfish damage timer until he's able to break out of his 'Idle after Damage then check data' animation from his Invincible form when Tornado Fang hits him.
		LDA #$20
org $93F44D ;Gravity Beetle damage table switch
	JSL BossCheckDisableZSaber
org $BFE82E ;Tunnel Rhino damage table switch
	JSL BossCheckDisableZSaber
org $93E693 ;Toxic Seahorse damage table switch
	JSL BossCheckDisableZSaber
org $83D23A ;Crush Crawfish damage table switch
	JSL BossCheckDisableZSaber
org $83D211 ;Crush Crawfish specific damage flash timer check. This was probably used for Charged Triad Thunder but it's no longer needed since that's been altered heavily.
	;This fixes a huge issue with the Z-Saber just instantly killing Crush Crawfish.
	NOP #4
org $93DE8B ;Neon Tiger damage table switch
	JSL BossCheckDisableZSaber
org $93D78F ;Dr. Doppler damage table switch
	JSL BossCheckDisableZSaber
org $88BB87 ;Mac damage table switch
	JSL BossCheckDisableZSaber
org $82E8DA ;Maoh the Giant damage table switch
	JSL BossCheckDisableZSaber
org $82E7E0 ;Loads Maoh the Giant's AI table pointers
	JML MaohTheGiant_AI
	NOP #7
	
org $8795E0 ;Vile normal Ride Armor damage table switch
	JSL BossCheckDisableZSaber
org $85A549 ;Vile damage table switch
	JSL BossCheckDisableZSaber
org $879143 ;Bit damage table switch
	JSL BossCheckDisableZSaber
org $BCC665 ;Byte damage table switch
	JSL BossCheckDisableZSaber
org $B2F32D ;Godkarmachine O Inary damage table switch? (Not this.. not sure who this is)
	JSL BossCheckDisableZSaber
org $858FBB ;Godkarmachine O Inary damage table switch
	JSL BossCheckDisableZSaber
org $93C855 ;Press Disposer damage table switch
	JSL BossCheckDisableZSaber
org $BCCB6A ;REX2000 damage table switch
	JSL BossCheckDisableZSaber
org $88931F ;Mosquitos damage table switch
	JSL BossCheckDisableZSaber
org $BCB95D ;Volt Kureil damage table switch
	JSL BossCheckDisableZSaber
org $85AC93 ;Goliath Armor damage table switch
	JSL BossCheckDisableZSaber
org $859545 ;Sigma damage table switch
	JSL BossCheckDisableZSaber
org $859B79 ;Kaiser Sigma damage table switch
	JSL BossCheckDisableZSaber
org $B99387 ;Worm Seeker damage table switch (This enemy did NOT have a damage table switch at all originally)
	JSL WormSeeker_DamageTableSwitch

org $86E477 ;Mac's damage table value
	db $24 ;Changed to 24 so now Mac has his own separate table like other bosses
	
org $86E422 ;REX2000's damage table value
	db $10 ;Changed to $10 so it shares with Mosquitus and Mao the Giant
}
;*********************************************************************************
; Modifying Mac/Hangar in Introduction Level
;*********************************************************************************	
org $85C65D ;Loads original code to set damage able to be done to hangar enemy in intro level with Mac
	; JSL Hangar_CheckForData
	BRL Hangar_CheckIntroMac
	NOP #17
	Hangar_CheckIntroBack:
	
org $85CE4D ;Loads new routine to check specifics on Hangar
{
	Hangar_CheckIntroMac:
	LDA !CurrentLevel_1FAE
	BEQ Hangar_CheckForData_CheckForMac
	
	Hangar_CheckForData_AllowDamage:
	JSL $84CB74
	BEQ Hangar_CheckForData_IgnoreDamage
	BMI Hangar_CheckForData_EndAll
	LDA #$0E
	TRB $11
	
	Hangar_CheckForData_IgnoreDamage:
	JSL !EventLoop
	
	Hangar_CheckForData_End:
	JML !VRAMRoutineAlt
	
	Hangar_CheckForData_EndAll:
	BRL Hangar_CheckIntroBack

	Hangar_CheckForData_CheckForMac:
	LDA $0D22 ;Checks specific location
	CMP #$62
	BNE Hangar_CheckForData_AllowDamage
	LDA $0D18
	BNE Hangar_CheckForData_IgnoreDamage
	BRA Hangar_CheckForData_AllowDamage
}
	
	
org $88B7C0 ;Loads event #$0A for Mac.
;Alters it to be a new location so specific sub-weapons will actually damage him and not break him.
	dw $FFF0
	org $88FFF0
	JSL Mac_AI_0A ;Loads routine for specific sub-weapons with damage timers to properly work with Mac
	RTL	
;*********************************************************************************
; Altering data for Frog Armor so it can perform properly on ground and underwater.
;*********************************************************************************
org $83A279 ;Loads routine that checks whether you're using Frog Armor or not.
	LDA #$04 ;The entire check was removed so Frog Armor can walk now.
	STA $02
	RTS
	NOP #11
	
org $83A33A ;Loads routine to determine Frog Armors movement speed while walking.
	LDA #$0130 ;This entire check was removed so all Ride Armors have the same walk speed.
	BIT $32
	NOP #15
	
org $83A28B ;Loads routine to determine if Frog Armor can keep it's dash momentum speed.
	LDA #$08
	STA $02
	RTS
	NOP #11
	
org $839856 ;Loads data that sets timer for how long you can 'Swim Dash' underwater with Frog Armor
	LDA #$FF ;Changed to #$FF so it's always possible to swim dash as long as you're still moving
	STA $4A
	
org $839B5A ;Loads routine to determine if Frog Armor can dash or not by checking if it's underwater or not.
	JSL RideArmors_DashingCheck ;This entire check was moved so that it could check if the Frog Armor is underwater or not. If not, then it can dash properly.
	
org $839F9D ;Loads original code location that made the Frog Armor hop on the Ride Pad
	NOP #33 ;NOP'd so now Frog Armor walks like all the others
		
	
;*********************************************************************************
; Altering Tunnel Rhino boulders to check it's life instead of weapon type (Weapon table MUST be modified for it to properly deal damage)
;*********************************************************************************
org $BCAA82
{
	LDA $27 ;Load boulder's life
	AND #$7F ;Remove anything above $7F
	BNE endbouldercheck
	LDA #$40
	STA $34
	LDA #$02
	STA $02
endbouldercheck:
	NOP
	RTS
}
org $86E390 ;Set boulder's life (Changed from 05)
	db $07
	
;*********************************************************************************
; Altering Crush Crawfish's Triad Thunder platform to check it's life instead of weapon type (Weapon table MUST be modified for it to properly deal damage)
; This is actual a GENERAL code for it. The platform's code will be moved to a new location so it doesn't interfere with anything else.
;*********************************************************************************
org $81CE51 ;Loads original code location to get Triad Thunder/Specific weapon checks on Crush Crawfish's platform (Generally used by most objects)
	JSL CrushCrawfish_Platform_DamageCheck
	
org $86E3B9 ;Crush Crawfish Platform damage value
	db $23 ;Changed to 23 so now Platform has it's own separate damage table from Tunnel Rhino Boulders
	
org $86BA49 ;Loads max height of Tornado Fang multi-spread
	db $09 ;Changed to 08 so Zero's Tornado Fang can go a bit lower to match his height more. (Can't go any higher unless delay below is altered)
	
org $81AA42 ;Loads delay before Tornado Fang multi-spread moves forward
	LDA #$1F ;Change to #$1F so higher value allows the wider spread to move properly as well
	
;*********************************************************************************
; Modifying object and tiles in Volt Catfish's stage near the capsule
;*********************************************************************************
org $BCE0B8 ;Modify Gravity Well elevator to be health capsule instead
	db $00,$80,$03,$02,$00,$40,$04
	
org $BDCE00 ;Modify tiles
{
	db $45,$00,$46,$00,$47,$00,$46,$00,$47,$00,$46,$00,$47,$00,$48,$00
	db $5F,$00,$15,$00,$16,$00,$1C,$00,$1D,$00,$15,$00,$16,$00,$19,$00
	db $13,$02,$10,$00,$11,$00,$12,$00,$13,$00,$10,$00,$11,$00,$14,$00
	db $11,$03,$15,$00,$16,$00,$17,$00,$18,$00,$15,$00,$16,$00,$19,$00
	db $5F,$00,$1A,$00,$1B,$00,$1C,$00,$1D,$00,$1A,$00,$1B,$00,$14,$00
	db $13,$02,$15,$00,$16,$00,$21,$00,$22,$00,$23,$00,$24,$00,$25,$00
	db $11,$03,$15,$00,$16,$00,$29,$00,$2A,$00,$2B,$00,$2C,$00,$2D,$00
	db $5F,$00,$15,$00,$16,$00,$2F,$00,$30,$00,$31,$00,$32,$00,$33,$00
	db $34,$00,$34,$00,$34,$00,$34,$00,$35,$00,$36,$00,$34,$00,$34,$00
	db $34,$00,$34,$00,$34,$00,$34,$00,$35,$00,$36,$00,$34,$00,$34,$00
	db $37,$00,$38,$00,$37,$00,$37,$00,$39,$00,$3A,$00,$37,$00,$37,$00
	db $3B,$00,$3C,$00,$3B,$00,$3B,$00,$3D,$00,$3E,$00,$3B,$00,$3B,$00
	db $34,$00,$34,$00,$34,$00,$34,$00,$35,$00,$36,$00,$34,$00,$34,$00
	db $34,$00,$34,$00,$34,$00,$34,$00,$35,$00,$36,$00,$34,$00,$34,$00
	db $3F,$00,$3F,$00,$3F,$00,$3F,$00,$40,$00,$41,$00,$3F,$00,$3F,$00
	db $42,$00,$42,$00,$42,$00,$42,$00,$43,$00,$44,$00,$42,$00,$42,$00
	db $13,$02,$15,$00,$16,$00,$2F,$00,$45,$00,$46,$00,$47,$00,$48,$00
	db $11,$03,$15,$00,$16,$00,$49,$00,$4A,$00,$4B,$00,$4C,$00,$4D,$00
	db $5F,$00,$15,$00,$16,$00,$4E,$00,$4F,$00,$4B,$00,$4C,$00,$4D,$00
	db $5A,$00,$15,$00,$16,$00,$50,$00,$51,$00,$4B,$00,$4C,$00,$4D,$00
	db $0C,$02,$23,$00,$24,$00,$55,$00,$56,$00,$4B,$00,$4C,$00,$4D,$00
}
	
;*********************************************************************************
; Loads charging sub-weapons and checks if you have weapon upgrade or not
;*********************************************************************************
org $84AC96 ;Load original code that allows PCs to charge sub-weapons
	JSL PCChargeSubWeaponsSetup ;Loads routine that sets who can charge sub-weapons or not based on Buster Upgrade
	NOP #5
	
org $818525 ;Loads original code that sets the bubbles and palette of PC based on charge time with Buster Upgrade
	JSL PCChargeSubWeaponsSetup ;Loads routine that sets the bubbles and palette of PC based on charge time with Buster Upgrade
	NOP #6
	
org $84AB6E ;Removes PC check for charging sub-weapons
	NOP #4
	
org $84AB77 ;Load original code that allows PCs to charge sub-weapons
	JSL PCChargeSubWeaponsSetup
	NOP
	
	
;*********************************************************************************
; Determines who can charge regular buster to final level then switch to sub-weapons and use charged versions
;*********************************************************************************
org $84B0F5 ;Stores #$02 to Z-Saber charge. Removed as it's completely useless
	NOP #4

org $84B0A5 ;Original code location that set the buster charge when charging to max then switching sub-weapons
	JSL PCChargeAndSwitchSubWeaponsSetup ;Loads routine that determines who can charge regular buster to final level then switch to sub-weapons and use charged versions

;*********************************************************************************
; Fixes 'lemon shot' bug on various circumstances. 
; IE: Firing as you enter a boss door, event etc.. it'll set 7E:0A30 (Current charge) to 00 at the wrong time causing the bug.
; This is now remedied by having it store as the shot GOES OFF instead of long before.
;*********************************************************************************
org $84AD4B
	LDA #$08
	STA $A9
	BRA CheckBusterWall
	JSR $A873
	BRA CheckBusterWall
	JSR $AE1F
	BNE CheckBusterWall
	JSR $A888
CheckBusterWall:
	LDA !CurrentPCAction_09DA
	CMP #$10 ;Land on wall
	BEQ SetBusterData
	CMP #$12
	BNE BusterShotEnd
SetBusterData:
	JSL BusterShotLemonFix ;Loads routine that fixes various circumstances of the 'Lemon Shot' bug where PCs would not be able to charge.
	NOP
BusterShotEnd:
	RTS
	
org $84ACE7 ;Level 4 buster shot check
	BRA BusterBranch
	JSR $AE1F
	BNE BusterBranch
	JSR $A888
	
	NOP #3
	
	BusterBranch:
	JSR $AD5E
	RTS
	
org $849C9A ;Level 4/5 buster shot check
	JSL BusterShotLemonFix ;Loads routine that fixes various circumstances of the 'Lemon Shot' bug where PCs would not be able to charge.
	
org $84862B ;Prevents current charge from being removed when you get damaged
	NOP #2
	
org $84990B ;NOP to prevents PC from grabbing onto ladder if they're firing level 4/5 in the air.
	NOP #3
	
;*********************************************************************************
; Mosquitus warning message so Zero does not get swapped out
;*********************************************************************************
; org $81CEFE ;Loads original routine that checks whether to load the 'Mosquitus Warning' entirely
	; JSL MosquitusWarning_CheckPCS
	; NOP #3


org $80CA65 ;Loads original code for opening a boss door
	JSL MosquitusWarning ;Loads routine that checks what level you're on to trigger a warning about Mosquitus so you don't lose Zero.
	CMP #$40
	BEQ MosquitusEndRoutine
	STZ $0A
	LDA #$76 ;Switch PC Action
	STA $09DA
	STZ $09DB
	STZ $0A7B
MosquitusEndRoutine:
	LDA #$04 ;Increase PC swap event
	STA $01
	JMP $CF2E
	
org $80C6CF ;Wait time for Mosquitus warning message
	LDA #$10
	
org $8895F7 ;Loads original code that checks which PC you are for Mosquitus event so explosion triggers
	LDA !CurrentPC_0A8E
	BEQ $0C
	
; org $88FFF7
	; JSL MosquitusWarning_CheckPCS
	; RTS
	
; org $88965B ;Removes check for PC so event will always continue instead of checking for X before event ends.
	; NOP #7
	
;*********************************************************************************
; Code inside boss doors that zeros out specific values for the enemy data (IE: Current event, sub-event, life.. only a few values)
; Code is now altered to remove the damage timer value so mid-bosses work properly
;*********************************************************************************
org $84D394
	JSL BossDoors_ClearVariousEnemyData
	RTL



;*********************************************************************************
; Rewrites RAM value that determines which one disables music
; $7E:1FB2 set to 01 or 02 would disable music. That's now being moved entirely to $7E:1FB0 instead since that's ONLY used for Bit/Byte/Vile sent out and Doppler Lab Scene
; This has to be watched though since once it's set to #$E0, it could break things. (Probably just rewrite it so it adds +#$80 instead of #$E0)
;*********************************************************************************
org $8084CD ;Code to disable music once BIT flag is set.
	LDA !DopplerLabBIT_1FB0
	BIT #$01

org $808316 ;Code to disable SFX/Music for Capcom Logo when BIT flag is set.
	LDA !DopplerLabBIT_1FB0
	BIT #$01
	
org $85C910 ;Code to disable Music for Dr. Light capsule when BIT flag is set.
	LDA !DopplerLabBIT_1FB0
	BIT #$01

org $809E2C ;Original code location that sets #$E0 for Doppler Lab has been found scene
	LDA #$80 ;Sets value to +80 now
	TSB !DopplerLabBIT_1FB0



;*********************************************************************************
; Sets capsule text loading when finding a Dr. Light capsule
;*********************************************************************************
org $85C8DF ;Loads original routine for opening a Light capsule
	JSL PCCapsuleIntroductionSetup ;Loads routine that determines if a PC has an introduction dialogue when first discovering a Light capsule.
	NOP #10
	
;*********************************************************************************
; Determines who can use Z-Saber right away after buster shot
;*********************************************************************************
org $84AEE8 ;Original code that disabled the Z-Saber from being used until after the buster shots were off screen
	JSL PCZSaberWaitSetup ;Load routine that determines who can use the Z-Saber right away after a buster shot
	BEQ PCZSaberSkipWait
	BRA PCZSaberSkipEnd
PCZSaberSkipWait:
	JSR $ADEB
	BNE PCZSaberSkipBNE
	BVC PCZSaberSkipBVC
	LDA #$20
	STA $59
	STZ $A9
	RTS
PCZSaberSkipBVC:
	JMP $A881
PCZSaberSkipBNE:
	JSR $AE1F
	BNE PCZSaberSkipEnd
	JMP $A896
PCZSaberSkipEnd:
	RTS
	
;*********************************************************************************
; New code to write palette data for PCs
;*********************************************************************************
org $84B6D6 ;Code location for loading the general palette routine for PCs on various circumstances
	JSL PCGeneralPalettes ;Loads routine that determines each PC's general palette based on various circumstances
	RTS
	
org $84B6C3 ;Code location for loading the general palette routine for PCs when moving around in the menu
	PHP
	JSR $B6E3
	STA $0004
	JSL PCGeneralPalettes_SkipLoadSubWeapon ;Loads routine that determines each PC's general palette when moving in the menu. (Skips the sub-weapon loading)
	PLP
	RTL
	
org $84B6E3
	SEP #$20
	REP #$10
	RTS
	
org $84AF1F ;Original code location that loads PC's palette when charging buster.
	JSL PC_ChargingPalettes
	NOP #3

;*********************************************************************************
; New code to write palette data for PCs & rewrite of sub-weapon routine when swapping with L/R
;*********************************************************************************
org $84A41A ;Divide sub-weapon missile value to get for how many missiles on screen
	NOP ;Removed the LSR so now it should load proper quantity
	
org $84A53C ;Divide sub-weapon missile value to get what missile to launch
	NOP ;Removed the LSR so now it should load proper missile
	
org $84A42A ;Checks for Hyper Charge on missile quantity
	CMP #$09 ;Changed to the new value of Hyper Charge
	
org $809FA7  ;Checks for Hyper Charge on Doppler level boss fight teleporters
	CMP #$09 ;Changed to the new value of Hyper Charge
	
org $84AB5D ;Loads code for something to do with Hyper Charge when entering teleporters on Doppler's Level.
	JMP $AA97 ;Changed from $AA92 since some code has been bumped.
	
org $84A33E ;Checks for Hyper Charge on wall
	CMP #$09
	
org $84A355 ;Checks for Hyper Charge on wall
	CMP #$09
	
org $848622 ;Checks for Hyper Charge when you have it equipped and tries to refill when getting damaged.
	CMP #$09 ;Changed to the new value of Hyper Charge
	
org $84A536 ;Checks for Hyper Charge on missile to launch
	CMP #$09 ;Changed to the new value of Hyper Charge
	
org $84A4A7 ;Load sub-weapon and check if it's Ray Splasher
	CMP #$05 ;Changed value so now it properly loads Ray Splasher value
	
org $84B75C ;Load sub-weapon and check if it's Parasitic Bomb
	CMP #$02 ;Changed value so now it properly loads Parasitic Bomb value
	
org $84B7CD ;Load sub-weapon and check if it's Tornado Fang
	CMP #$08 ;Changed value so now it properly loads Tornado Fang value
	
org $84ABA2 ;Load sub-weapon value and check if it's Hyper Charge
	CMP #$09 ;Changed value so now it properly loads Hyper Charge value
	
org $8184EF ;Load sub-weapon value and check if it's Hyper Charge
	CMP #$09 ;Changed value so now it properly loads Hyper Charge value
	
org $84A4E2 ;Load sub-weapon value and check if it's Hyper Charge
	CMP #$09 ;Changed value so now it properly loads Hyper Charge value
	
org $8188B7 ;Load sub-weapon value and check if it's Hyper Charge for Bubbles
	CMP #$09 ;Changed value so now it properly loads Hyper Charge value
	
org $84A4D6 ;Load sub-weapon value and check if it's Parasitic Bomb
	CMP #$02 ;Changed value so now it properly loads  Parasitic Bomb value
	
org $84B781 ;Load sub-weapon value for Parasitic Bomb when it's charged to determine if it can be used or not.
	JSL ParasiticBomb_Charged
	NOP
	BEQ $2D
	;BCC $2D
	
org $84A4DA ;Load sub-weapon value and check if it's Tornado Fang
	CMP #$08 ;Changed value so now it properly loads Tornado Fang value
	
org $84A4DE ;Load sub-weapon value and check if it's Triad Thunder
	CMP #$03 ;Changed value so now it properly loads Triad Thunder value
	
org $84AE55 ;Load sub-weapon value and check if it's Hyper Charge
	CMP #$09 ;Changed value so now it properly loads Hyper Charge value
	
org $84B7F6 ;Allow Charged Tornado Fang to work (Needs to be rewritten heavily so it's a LDX value instead of a hard set location)
	LDA $1FC2 ;Load Tornado Fang sub-weapon location
	AND #$1F
	
org $81AF60 ;Allow Charged Tornado Fang to work and NOT underflow on ammo
	LDA $1FBA,x
	AND #$1F
	CMP #$02
	NOP
	BCC $15
	
org $82DE0A ;Load sub-weapon value and check if it's Tornado Fang
	CMP #$08 ;Changed value so now it properly loads Tornado Fang
	
org $82DE0E ;Load sub-weapon value and check if it's Parasitic Bomb
	CMP #$02 ;Changed value so now it properly loads Parasitic Bomb
	
org $84A248 ;Load sub-weapon value and check if it's Ray Splasher
	CMP #$05 ;Changed value so now it properly loads Ray Splasher
	
org $84A3CE ;Load sub-weapon value and check if it's Ray Splasher when walking and firing
	CMP #$05 ;Changed value so now it properly loads Ray Splasher when walking and firing
	
org $84A257 ;Load sub-weapon value and check if it's Gravity Well
	CMP #$06 ;Changed value so now it properly loads Gravity Well

org $84B84F
	JSL LoadProperSubWeaponSFX ;Loads routine to load proper sub-weapon SFX
	

	
org $84B001 ;Original code location that determines how sub-weapons get scrolled to via L/R
	BEQ SubWeaponis01_Bit10
	JSR $B0A5
LoopSubWeaponWithL:
	LDA $33 ;Load !CurrentPCSubWeapon_0A0B
	BEQ SubWeaponis00
	CMP #$01
	BEQ SubWeaponis01
	
	DEC $33 ;Decrease !CurrentPCSubWeapon_0A0B
	
CheckIfSubWeaponHave:
	JSL SubWeaponSwitchCheckIfHave ;Load routine to determine if a PC has a specific sub-weapon or not that's being scrolled to
	BNE SubWeaponNotAvailable
	BRA LoopSubWeaponWithL
	
SubWeaponis00:
	JSL PC_SplitLSubWeaponSet
	; LDA #$0A ;Final sub-weapon that can be loaded value
	; STA !CurrentPCSubWeaponShort_33 ;Store to !CurrentPCSubWeapon_0A0B
	BRA CheckIfSubWeaponHave
	
SubWeaponis01:
	JSR $B0A5
	STZ !CurrentPCSubWeaponShort_33 ;Store 00 to !CurrentPCSubWeapon_0A0B
	LDA #$04
	STA !PCSubWeaponAmmoBar_1F23
	BRA LoadOtherSubWeaponData
	
SubWeaponis01_Bit10:
	BIT #$10 ;Start of sub-weapon 'R' switch
	BEQ EndSubWeaponRoutine
	
	JSR $B0A5
LoopSubWeaponWithR:
	JSL PC_SplitRSubWeaponSet
	; LDA !CurrentPCSubWeaponShort_33 ;Load !CurrentPCSubWeapon_0A0B
	; CMP #$0A ;Check if last sub-weapon
	BEQ SubWeaponis01
	
	INC $33 ;Increase current sub-weapon
	
	JSL SubWeaponSwitchCheckIfHave ;Load routine to determine if a PC has a specific sub-weapon or not that's being scrolled to
	BEQ LoopSubWeaponWithR
	
SubWeaponNotAvailable:
	LDA #$02
	STA $11
	LDA $8E ;Load current charge of Buster
	BNE SubWeaponIcon
	
	JSR $AD76
	STZ $5A
	STZ $5B
	STZ $8F
	STZ $B7
	
SubWeaponIcon:
	STZ !PCSubWeaponAmmoBar_1F23
	LDA !CurrentPCSubWeaponShort_33 ;Load !CurrentPCSubWeapon_0A0B
	ASL
	CLC
	ADC #$3E
	TAY
	JSL !LoadSubWeaponIcon ;Loads routine that draws the sub-weapon icon on screen for the ammo bar
	
	LDA $1F38
	CLC
	ADC #$20
	STA $1F38
LoadOtherSubWeaponData:
	JSR $B0C5
	
	LDA !CurrentPCSubWeaponShort_33 ;Load !CurrentPCSubWeapon_0A0B
	TAX
	LDA $B380,x
	STA $67
	JSL PCBusterPalette ;Loads routine that sets the PC's sub-weapon/buster/Z-Saber palette depending on circumstance.
	
	JSL DisablePCSubWeaponCharging ;Loads routine that determines which PC can charge sub-weapons or not.
	REP #$31
	JSL PCGeneralPalettes
	
	SEP #$30
	STZ $00A1
	INC $00A2
	STZ $1F64
EndSubWeaponRoutine:
	RTS
	
org $80D66E ;Palette data for buster/sub-weapon when opening and closing menu
	JSL PCBusterPalette ;Loads routine that sets the PC's sub-weapon/buster/Z-Saber palette depending on circumstance.
	JSL DisablePCSubWeaponCharging ;Loads routine that determines which PC can charge sub-weapons or not.
	SEP #$30
	NOP #3
	
org $809FD2 ;Palette data for buster/sub-weapon when entering a Doppler Level teleporter to refight bosses
	JSL PCBusterPalette
	SEP #$30
	NOP #6
	
org $848199 ;Palette data for buster/sub-weapon when entering a level
	JSL PCBusterPalette ;Loads routine that sets the PC's sub-weapon/buster/Z-Saber palette depending on circumstance.
	SEP #$30
	JSL GeneralPC1UpStorage
	NOP #6
	
org $93C2CB ;Palette data for buster/sub-weapon when entering a capsule then palette for PC
	JSL PCBusterPalette ;Loads routine that sets the PC's sub-weapon/buster/Z-Saber palette depending on circumstance.
	JSL PCGeneralPalettes ;Loads routine that determines each PC's general palette based on various circumstances
	NOP #9

	
org $80A2B2 ;Palette data for buster/sub-weapon when dying and re-entering level
	JSL PCBusterPalette ;Loads routine that sets the PC's sub-weapon/buster/Z-Saber palette depending on circumstance.
	SEP #$30
	NOP #2
	

	
	
;*********************************************************************************
; New code to write palette data for PCs upon entering a capsule and it starts giving them the part.
;*********************************************************************************
org $93C548 ;Original code location for PC palette flashing in capsule
	JSL PCCapsuleFlashPalette ;Loads routine that specifies each PC's palette inside the capsule when they're flashing.
	NOP #23
	
;*********************************************************************************
; Load PC hitbox when jumping and landing, jumping out of Ride Armor, etc..
;*********************************************************************************
; org $86B40E ;Changed Zero's hitbox so it's a bit smaller. May help his gameplay. (EXPERIMENTAL)
	; db $00 ;X coordinate of Zero's hitbox
	; db $04 ;Y coordinate of Zero's hitbox (Originally 3)
	; db $06 ;Width of Zero's hitbox
	; db $11 ;Height of Zero's hitbox (Originally 12)
	
; org $86B422 ;Changed Zero's dash  so it's a bit smaller. May help his gameplay. (EXPERIMENTAL)
	; db $00 ;X coordinate of Zero's hitbox
	; db $0B ;Y coordinate of Zero's hitbox (Originally 0A)
	; db $06 ;Width of Zero's hitbox
	; db $0A ;Height of Zero's hitbox (Originally 0B)
	
org $86A9B2 ;Loads introduction Y coordinate spawn point for X/Zero if they die against introduction boss and come back
	dw $0200 ;This has been altered so Zero will no longer sink into the floor, unfortunately, it pans the screen up for a moment in doing so.

org $83A22A ;Loads original code that determined PC's hitbox when they were jumping, landing, jumping out of Ride Armor, etc...
	JSL PCGeneralhitbox ;Loads routine that specifies PC's hitbox depending on any general circumstance.
	SEP #$30
	NOP #22
	
org $84B645 ;Original code location to reset PC's hitbox
	REP #$20
	JSL PCGeneralhitbox ;Loads routine that specifies PC's hitbox depending on any general circumstance.
	NOP #10
	SEP #$20
	RTS
	
;*********************************************************************************
; Jumping out of Ride Armor
;*********************************************************************************
org $83A1F0
	JSL PC_JumpOutRideArmor
	NOP #2
	
;*********************************************************************************
; Stage Select: Allow X to change to Zero
;*********************************************************************************
org $80C27B
	JSR $FA6F
	
org $80FA6F  ;Load decompressed graphics for 'Z' icon
	JSL StageSelect_LoadDecompressedZGraphics
	RTS


org $80C4C8
	JSL PCStageSelectIcon ;Loads routine that sets which PC you are and are switching to when hitting the 'X' or 'Z' icon
	NOP #2
	
;*********************************************************************************
;Splits PC's general sprite data up
;*********************************************************************************
org $84A63C ;Loads original code routine to set general sprite setup for PCs
	JSL PCGeneralSprite ;Loads routine to set general sprite setup for all PCs
	LDX #$10
	LDA #$00
LoopClearZSaberBITTest:
	STA !ZSaberEnemyTableForBlanking_7EF4FF,x
	DEX
	BNE LoopClearZSaberBITTest
	RTS
	
org $84A68A ;Loads original code location to set PC general Z-Saber sprites
	JSL PCGeneralZSaberSprite
	RTS
	
org $83A181 ;Load original code location to set PC Ride Armor sprites
	JSL PCGeneralRideArmorSprite
	LDA !PCVRAMByte_7EF4E8
	AND #$00FF
	TAX
	LDA PCNPC_VRAMStartTable,x
	STA $0A20
	
;*********************************************************************************
;Allows PCs and PC NPC's to use their own VRAM code and table
;*********************************************************************************
org $848090
	JSL PCVRAMStart
	
org $83BB2E
	JSL NewVRAMRoutine
	RTS
		
org $84809E
	JSL PCNPC_VRAMRoutine
	
org $BFEF06 ;This loads the Z-Saber Wave Cutting effect on the Sigma Virus head. Had to specifically load a new piece of code JUST for this to appear right. (Very strange.)
	JSL SigmaVirusZSaberVRAMStart
	
org $BFED0A  ;This loads the Z-Saber Wave Cutting effect on the Sigma Virus head. Had to specifically load a new piece of code JUST for this to appear right. (Very strange.)
	JSL SigmaVirusZSaberVRAMStart
	
;*********************************************************************************
;Sets delay timer at end of game before X/Zero/Sigma Virus event completely ends.
;*********************************************************************************
org $83B960
	LDA #$30 ;Changed to #$30 instead of #$F0 so the wait time is MUCH shorter before it transitions to the cliff scene.

;*********************************************************************************
;Set PC hitbox when dashing
;*********************************************************************************
org $84B658 ;Loads original code location to determine hitbox of PC when dashing.
	JSL PCDashhitbox
	NOP #10
	RTS
	
;*********************************************************************************
;Loads PC's walking start speed/dash speed
;*********************************************************************************
org $84AF72 ;Loads original code location to set PC walking speed, dash speed and dash distance.
	JSL PCStartWalkingDashDistanceSpeed ;Loads routine to set PC walking speed, dash speed and dash distance for each PC.
	NOP
	
;*********************************************************************************
;Loads PC's jumping then moving speed
;*********************************************************************************
org $84B905 ;Loads original code that sets the PC's jumping then using directional keys to move speed
	JSL PCJumpThenMove ;Load routine that sets the PC's jumping then using directional keys to move speed for each PC
	SEP #$20
	NOP #3
	RTS

;*********************************************************************************
;Loads PC's walking speed
;*********************************************************************************
org $84AF94 ;Load original routine that determines the walking speed of a character.
	JSL PCWalkingSpeed ;Load routine that determines the walking speed of each PC.
	NOP
	
;*********************************************************************************
;Loads PC's jumping height
;*********************************************************************************
org $84C473 ;Loads original code location that set the maximum jump height of PC.
	JSL PCJumpHeight ;Loads routine that sets the maximum jump heightfor each PC.
	NOP
	
org $84C5D3 ;Remove clone routine of jump height and have it load the normal one above at $84:C473
	JSR $C469
	NOP #20
	
;*********************************************************************************
;Loads PC's dash then jump speed
;*********************************************************************************
org $848A4D	;Load original code location that sets dash then jump speed.
	JSL PCDashJump ;Load routine that sets dash then jump speed for each PC.
	STA $5C
	NOP
	
org $84A74F	;Load original code location that sets dash then jump speed.
	JSL PCDashJump ;Load routine that sets dash then jump speed for each PC.
	STA $5C
	NOP
	
org $848AD7	;Load original code location that sets dash then jump speed.
	JSL PCAirDashSettings ;Load routine that sets dash then jump speed for each PC.
	STA $5C
	NOP #5

;*********************************************************************************
; Defeat bosses and store BIT to new RAM
;*********************************************************************************
org $809C7E
	BEQ $09 ;Hard set to jump to an RTS to end routine properly.

org $809C8A
	JSL BossDefeated ;Load routine that stores new RAM for bosses being defeated
	
;*********************************************************************************
;Loads check for each bosses AI to determine whether they spawn or not after they've been defeated
;*********************************************************************************
org $83C8A7 ;Blizzard Buffalo check to see if spawns again in their own level
	JSR $FFF0
	BEQ $08
org $83D088 ;Crush Crawfish check to see if spawns again in their own level
	JSR $FFF0
	BEQ $13
	
	
org $93F27F ;Gravity Beetle check to see if spawns again in their own level
	JSR $FFF0
	BEQ $13
org $93E4D7 ;Toxic Seahorse check to see if spawns again in their own level
	JSR $FFF0
	BEQ $13
org $93EAAB ;Volt Catfish check to see if spawns again in their own level
	JSR $FFF0
	BEQ $08
org $93DCE6 ;Neon Tiger check to see if spawns again in their own level
	JSR $FFF0
	BEQ $13

	
org $B99C85 ;Blast Hornet check to see if spawns again in their own level
	JSR $FFF0
	BEQ $08

	
org $BFE629 ;Tunnel Rhino check to see if spawns again in their own level
	JSR $FFF0
	BEQ $13
	

org $83FFF0
	JSL CheckBossesSpawnPerLevel
	RTS
org $93FFF0
	JSL CheckBossesSpawnPerLevel
	RTS
org $B9FFF0
	JSL CheckBossesSpawnPerLevel
	RTS
org $BFFFF0
	JSL CheckBossesSpawnPerLevel
	RTS

	
	
	

;*********************************************************************************
; Loads check for bosses defeated on Stage Select
;*********************************************************************************
org $80A49D ;Loads original code to setup a check to see which bosses were defeated.
	JSL $838065 ;Loads original code that went through a loop to check for bosses defeated
	JSL CheckBossesDefeated
	NOP #15
	
org $838065 ;Rewrote original code location slightly so it sets up a basis for the new bosses defeated.
	STZ $00
	STZ $01
	LDX #$07 ;How many times to go through loop to check for bosses defeated
	RTL
	
	LDA !BossesDefeated1_7EF4E2 ;Loads !BossesDefeated1_7EF4E2 to check how many bosses have been defeated
	CMP #$FF ;Check if #$FF (All bosses defeated)
	RTL
	NOP #5
	
org $809A24 ;Loads original routine that blanks out Armor data upon new game ($7E:1FD1)
	NOP #3
	
org $809A62 ;Checks if it skips boss introduction upon entering a level
	LDA !BossesDefeated1_7EF4E2
	AND $892C,x
	NOP #2
	
;This is currently bugged. If more than one boss is defeated then it only grays out the first boss bit and nothing else
org $80C31A
	LDA !BossesDefeated1_7EF4E2
	LDX #$00
	BIT $892D,x
	
org $80C327
	LDA $9F67,x
 
org $80C252 ;Check if all bosses are defeated by using $7E:002C (Boss Counter). If so, load Doppler's 'D' Icon on Stage Select.
	JSL $83806C
	
org $80C2CC ;Check if all bosses are defeated by using $7E:002C (Boss Counter). If so, load new stage music.
	JSL $83806C
	
org $80C304 ;Check if all bosses are defeated by using $7E:002C (Boss Counter). If so, load Doppler's Lab on Stage Select.
	JSL $83806C
	
org $80C41D ;Check if all bosses are defeated by using $7E:002C (Boss Counter). If so, load Doppler's Lab emerging on Stage Select.
	JSL $83806C
	
org $80C456 ;Check if all bosses are defeated by using $7E:002C (Boss Counter). If so, allow Doppler's Lab to be selected on Stage Select.
	JSL $83806C
	
;*********************************************************************************
; Store sub-weapons to PC after defeating a boss
;*********************************************************************************		
org $B9A149 ;Blast Hornet sub-weapon storage
	JSL BossDefeatedStoreSubWeapon ;Load routine that stores the bosses sub-weapon to the shared routine and each split PC.
	NOP
org $83CD9A ;Blizzard Buffalo sub-weapon storage
	JSL BossDefeatedStoreSubWeapon ;Load routine that stores the bosses sub-weapon to the shared routine and each split PC.
	NOP
org $83D5B1 ;Crush Crawfish sub-weapon storage
	JSL BossDefeatedStoreSubWeapon ;Load routine that stores the bosses sub-weapon to the shared routine and each split PC.
	NOP
org $93F7BF ;Gravity Beetle sub-weapon storage
	JSL BossDefeatedStoreSubWeapon ;Load routine that stores the bosses sub-weapon to the shared routine and each split PC.
	NOP
org $93E3A8 ;Neon Tiger sub-weapon storage
	JSL BossDefeatedStoreSubWeapon ;Load routine that stores the bosses sub-weapon to the shared routine and each split PC.
	NOP
org $93E9C5 ;Toxic Seahorse sub-weapon storage
	JSL BossDefeatedStoreSubWeapon ;Load routine that stores the bosses sub-weapon to the shared routine and each split PC.
	NOP
org $BFEB10 ;Tunnel Rhino sub-weapon storage
	JSL BossDefeatedStoreSubWeapon ;Load routine that stores the bosses sub-weapon to the shared routine and each split PC.
	NOP
org $93F0BC ;Volt Catfish sub-weapon storage
	JSL BossDefeatedStoreSubWeapon ;Load routine that stores the bosses sub-weapon to the shared routine and each split PC.
	NOP
	
;*********************************************************************************
; Check whether you have sub-weapons and modifying routines so sub-weapon life is 00-1C (Set to C0 if empty)
;*********************************************************************************
org $84AD7F ;Plays a blank SFX when swapping to sub-weapons. (This is used to stop Hyper Charge SFX)
	LDA #$03
	JSL !PlaySFX

org $8391B1
	LDA !CurrentPCSubWeapon_0A0B
	TAY
	BNE SubWeaponValueThere
	LDA #$06
	STA !PCSubWeaponAmmoBar_1F23
	RTS
	
SubWeaponValueThere:
	CMP #$09 ;Check for Hyper Charge value
	BEQ HyperChargeIcon
	LDA #$36
	BRA SkipHyperChargeIcon
HyperChargeIcon:
	LDA #$34
SkipHyperChargeIcon:
	STA $0E
	NOP #8 ;ORA #80 with sub-weapon life then store it back. (Removed as it's no longer needed)
	
	LDX #$0000
BeginSubWeaponLifeBarLoop:
	LDA #$18
	STA $6024,x
	LDA #$E0
	STA $6025,x
	LDA #$80
	STA $6026,x
	LDA $0E
	STA $6027,x
	INX #4
	CPX #$001C
	BNE BeginSubWeaponLifeBarLoop
	
	LDA #$50
	STA $6025
	LDA #$AC
	STA $6026
	
	LDA !CurrentPCSubWeapon_0A0B
	TAY
	SEP #$10
	PHX
	TYX
	JSL LoadPCSplitSubWeapon
	PLX
	REP #$10
	AND #$3F
	CMP #$1C
	BCC IgnoreMaxSubWeapLifeStorage
	LDA #$1C
IgnoreMaxSubWeapLifeStorage:
	STA $00
	NOP
	
	LDA #$40
	STA $01
	LDX #$0004
LoopNewSubWeapon:
	LDA $00
	BEQ LoadNewSubWeapon
	
	SEC
	SBC #$08
	STA $00
	BMI PressingR
	
	LDA $01
	STA $6025,x
	SEC
	SBC #$10
	STA $01
	LDA #$80
	STA $6026,x
	INX #4
	BRA LoopNewSubWeapon
	
PressingR:
	ASL $00
	LDA $01
	SEC
	SBC $00
	STA $6025,x
	SEC
	SBC #$10
	STA $01
	LDA #$80
	STA $6026,x
	INX #4
	
LoadNewSubWeapon:
	SEP #$10
	PHX
	TYX
	JSL LoadPCSplitSubWeapon
	PLX
	REP #$10
	AND #$3F
	STA $02
	LDA #$1C ;Sub-weapon max life
	SEC
	SBC $02
	STA $00
	
ShowProperSubWeaponLife:	
	LDA $00
	SEC
	SBC #$08
	STA $00
	BMI EndNewSubWeapon
	
	LDA $01
	STA $6025,x
	SEC
	SBC #$10
	STA $01
	LDA #$82
	STA $6026,x
	INX #4
	BRA ShowProperSubWeaponLife
	
EndNewSubWeapon:
	ASL $00
	LDA $01
	SEC
	SBC $00
	STA $6025,x
	SEC
	SBC #$10
	STA $01
	LDA #$82
	STA $6026,x
	INX #4
	LDA $01
	STA $6025,x
	LDA #$84
	STA $6026,x
	RTS
	
;*********************************************************************************
;*********************************************************************************
; Load sub-weapon icon when leaving menu
;*********************************************************************************
org $80CD51 ;Loads original code location that loaded the current sub-weapon PC has equipped.
	JSL CurrentSubWeaponDouble ;Load routine that doubles the value of the current sub-weapon PC has equipped.
	
;*********************************************************************************
;Store's armor value when capsule animation is done
;*********************************************************************************
org $85C81D ;Loads original code location that stored a capsule part to you when the capsule animating was done.
	JSL StoreCapsuleValue ;Loads routine that stores capsule part to X in his new RAM location.
	NOP #2

;*********************************************************************************
;Loads armor value for X in various circumstances
;*********************************************************************************
org $84FFBA ;Loads original code location that checks X's armor RAM for a specific piece.
	LDA !XArmorsByte1_7EF418 ;Loads X's new armor value in various circumstances
	RTS
org $83A822 ;Loads original code location that checks X's armor RAM for a specific piece.
	LDA !XArmorsByte1_7EF418 ;Loads X's new armor value in various circumstances
	RTS
org $81FF90 ;Loads original code location that checks X's armor RAM for a specific piece.
	LDA !XArmorsByte1_7EF418 ;Loads X's new armor value in various circumstances
	RTS
org $80FF64 ;Loads original code location that checks X's armor RAM for a specific piece.
	LDA !XArmorsByte1_7EF418 ;Loads X's new armor value in various circumstances
	RTS
	
org $8384B1 ;Loads original code location that checks X's armor RAM for helmet piece and then loads what upgrades per stage there are on stage select.
	JSR $A822 ;Loads X's new armor value in various circumstances
org $838656 ;Loads original code location that checks X's armor RAM to determine which sub-tanks are obtained.
	JSR $A832 ;Loads X's new armor value in various circumstances
org $83866B ;Loads original code location that checks X's armor RAM to determine which sub-tanks are obtained.
	JSR $A832 ;Loads X's new armor value in various circumstances
org $838679 ;Loads original code location that checks X's armor RAM to determine which sub-tanks are obtained.
	JSR $A832 ;Loads X's new armor value in various circumstances
org $838680 ;Loads original code location that checks X's armor RAM to determine which sub-tanks are obtained.
	JSR $A832 ;Loads X's new armor value in various circumstances
	
org $83A832
	JSL PCAddAllSubTanks	
	RTS
	
org $8386B3 ;Loads original code location that checks X's armor RAM to determine which armor piece he has obtained.
	JSR $A822 ;Loads X's new armor value in various circumstances
org $8386C8 ;Loads original code location that checks X's armor RAM to determine which armor piece he has obtained.
	JSR $A822 ;Loads X's new armor value in various circumstances
org $8386D6 ;Loads original code location that checks X's armor RAM to determine which armor piece he has obtained.
	JSR $A822 ;Loads X's new armor value in various circumstances
org $8386DD ;Loads original code location that checks X's armor RAM to determine which armor piece he has obtained.
	JSR $A822 ;Loads X's new armor value in various circumstances
	
org $84AE3C ;Loads original code location that checks X's armor RAM for a specific piece.
	JSR $FFBA ;Loads X's new armor value in various circumstances
org $848666 ;Loads original code location that checks X's armor RAM for a specific piece.
	JSR $FFBA ;Loads X's new armor value in various circumstances
org $8486EB ;Loads original code location that checks X's armor RAM for a specific piece.
	JSR $FFBA ;Loads X's new armor value in various circumstances
org $849FAE ;Loads original code location that checks X's armor RAM for a specific piece.
	JSR $FFBA ;Loads X's new armor value in various circumstances
org $84AC6F ;Loads original code location that checks X's armor RAM for a specific piece.
	JSR $FFBA ;Loads X's new armor value in various circumstances
	
org $818D60 ;Loads original code location that checks X's armor RAM for a specific piece.
	JSR $FF90

org $80CD82 ;Loads original code location that checks X's armor RAM for a specific piece.
	JSR $FF64 ;Loads X's new armor value in various circumstances
org $80CD94 ;Loads original code location that checks X's armor RAM for a specific piece.
	JSR $FF64 ;Loads X's new armor value in various circumstances
org $80CDA6 ;Loads original code location that checks X's armor RAM for a specific piece.
	JSR $FF64 ;Loads X's new armor value in various circumstances
org $80CDB6 ;Loads original code location that checks X's armor RAM for a specific piece.
	JSR $FF64 ;Loads X's new armor value in various circumstances
org $80CDDA ;Loads original code location that checks X's armor RAM for a specific piece.
	JSR $FF64 ;Loads X's new armor value in various circumstances

;*********************************************************************************
;Loads armor value for X in Pink Capsules and disables Pink Capsules from not giving armor
;*********************************************************************************
org $93C051 ;Loads original code location that disabled PCs from re-entering Pink Capsules once they've been retrieved.
	AND !XArmorsByte1_7EF418
	BEQ CapsuleDontHaveArmor
	
	NOP #12
	BRA CapsuleCanWork
	
CapsuleDontHaveArmor:
	LDA #$01 ;Initiates capsule sequence where you do not have the right armor part
	STA $7FCFFF
	BRA CapsuleCanWork
	
	JML !CommonEventEnd

CapsuleCanWork:
	JSL $82E15C

	
org $85C830 ;Loads original code that updated the Ride Chip value once a Pink Capsule had been retrieved
	JSL UpdateRideChips
	NOP #2
	
org $85C7D9 ;Loads sprite assembly for X with helmet on when obtaining Helmet capsule. (Removed as it's unnecessary)
	NOP #5
	
org $86CD74
	db $18 ;Lengths distance of Air Dash for Leg Chip capsule so it doesn't freeze game
	db $80
	db $00
	db $30 ;Wait time before you can move again

;*********************************************************************************
;Rewrites most of Capsule routine to remove various checks for the Golden Armor
;Also rewritten to fix an issue with loading X's original location for armor parts
;*********************************************************************************
org $93C00B ;Original capsule location code
	LDA !RideChipsOrigin_7E1FD7
	CMP #$F0
	BCS EndFullCapsuleRoutine
	LDA #$00 ;This value determines the capsule can open
	STA $7FCFFF ;Location used to determine what capsule does. (IE: Not allow chip part, allow chip part)
	LDA !CurrentLevel_1FAE
	CMP #$0A
	BEQ CapsuleCheckCapsuleChips
	BRA CapsuleCheckLevel
	
	CapsuleCheckCapsuleChips:
	LDA !CurrentPCArmorOriginShort_1FD1
	CMP #$F0
	BEQ ContinueFullCapsuleRoutine
	
	LDA !CurrentLevel_1FAE
	CMP #$0A ;Check if Dr. Doppler Level #1
	BNE CapsuleCheckLevel ;Checks level instead of going through the Golden Armor Check
	JSL GoldenArmorCheck ;Load routine that checks various circumstances to see if the Golden Armor capsule will load or not.
	
	CapsuleCheckLevel:
	LDX !CurrentLevel_1FAE
	LDY $CCFA,x
	LDA $BBFD,y
	BIT #$F0
	BNE IsNotGoldenArmorValue
	AND !XArmorsByte1_7EF418
	BEQ ContinueFullCapsuleRoutine
	BRA EndFullCapsuleRoutine
	
	IsNotGoldenArmorValue:
	AND !RideChipsOrigin_7E1FD7
	BNE EndFullCapsuleRoutine
	LDA $BBFD,y
	LSR #4
	AND !XArmorsByte1_7EF418
	BEQ CapsuleCanContinue
	BRA ContinueFullCapsuleRoutine
	
	CapsuleCanContinue:
	LDA #$01
	STA $7FCFFF
	BRA ContinueFullCapsuleRoutine
	
	EndFullCapsuleRoutine:
	JML !CommonEventEnd
	
	ContinueFullCapsuleRoutine:
	JSL $82E15C
	
	LDA #$A0
	STA $18
	
	STZ $26
	
	LDA #$3F
	STA $11
	
	LDA #$02
	STA $12
	STA $30
	
	LDA #$01
	STA $27
	
	STZ $0F

	LDA #$88
	STA $10
	
	LDA #$02
	STA $02
	
	REP #$20
	LDA !CurrentLevel_1FAE
	AND #$00FF
	ASL #2
	TAX
	LDA $CCBE,x
	STA $05
	LDA $CCC0,x
	STA $08
	LDA #$CC96
	STA $20
	RTL
	
;*********************************************************************************
; Stores Hyper Charge value to proper RAM area when obtaining Arm Chip capsule/Golden Armor capsule
;*********************************************************************************
org $85C824 ;Loads original routine that stored Hyper Charge
	JSL StoreHyperCharge ;Load routine that stores Hyper Charge properly into new sub-weapon location.
	NOP
	
org $86CD87 ;Wait time before you can leave Hyper Charge capsule
	db $01 ;Changed to #$01 so it's quick

;*********************************************************************************
; Sets PC Get Weapon graphics, tile map and palette properly
;*********************************************************************************
org $80A63E ;Loads original routine that obtained the PC's GET WEAPON compressed graphics and send it into VRAM
	JSL PCGetWeaponGraphics ;Loads routine that obtains PC's GET WEAPON graphics depending on which PC you are.
	NOP
	
org $80A653 ;Loads original routine that obtained the PC's GET WEAPON tile map and send it into VRAM
	JSL PCGetWeaponTilemap ;Loads routine that obtains PC's GET WEAPON tile map depending on which PC you are.
	NOP	
	
org $80A678 ;Rewritten code for Get Weapon palette for PC Image so it only sets X/Zero's base palette.
{
	PHB
	REP #$30
	LDX #$AA20
	JSL PCGetWeaponPalette
	MVN $0C00
	PLB
	SEP #$30
}

org $80A92F ;Loads storage of screen flashing on Get Weapon screen.
	JSL PCGetWeaponGatherPalette ;Now loads new code to set PC's new palette when the screen flash occurs.
	NOP #2
	
org $80A985 ;Loads routine that sets the max Y coordinate before PC finishes teleport sequence onto Get Weapon BG
	JSL PCGetWeaponMaxYCoordinate
	NOP


org $80AAB0 ;Routine to load current sub-weapon icon/palette?
{
	LDA $9C6D,x
	STA $33 ;Store to PC current sub-weapon
	TAX
	LDA #$1C
	STA !SubWeap_1FBA,x
	LDA $33 ;Reload PC current sub-weapon
	ASL
	CLC
	ADC #$3E
	TAY
	JSL !LoadSubWeaponIcon
	
	PEA $09D8
	PLD
	LDA #$01
	STA $67
	LDX #$30
	LDA $33 ;Reload PC current sub-weapon
	ASL
	CLC
	ADC #$40
	TAY
	JSL !Palette
	
	PEA $09D8
	PLD
	REP #$31
	JSL PCGeneralPalettes ;Loads routine that determines each PC's general palette based on various circumstances
	REP #$30
	NOP #7
}

org $80F510 ;Code location for jumping from one bank to another for COMPRESSED data
{
	JSR !LoadCompressedGraphics ;Loads routine for COMPRESSED data
	RTL
}
	
org $80F514 ;Code location for jumping from one bank to another for DECOMPRESSED data
{
	JSR !LoadDecompressedGraphics ;Loads routine for DECOMPRESSED data
	RTL
}

;*********************************************************************************
; Sets 'READY' data for PC
;*********************************************************************************
org $809B24 ;Loads original routine that stored COMPRESSED 'READY' sprites into VRAM
	JSL PC_Ready_Sprites
	NOP #3
	
org $80A2AA ;Loads original code that sets 'READY' text palette into RAM.
;This code is now removed as it stores the PC's palette into RAM as it decompresses the READY text.
	NOP #8
	
org $849764 ;Loads original code location for 'READY' text graphics in intro stage only!
	JSL PC_Ready_Sprites_Intro

org $81F574 ;Loads original code location that determines the 'READY' palette
	JSL PC_Ready_Intro_Palette



;*********************************************************************************
; Bit/Byte spawning modifications
;*********************************************************************************
org $82E0FB ;Routine to check how many sub-weapons you have to allow Bit/Byte/Vile spawning
{
	LDX #$07
	LDY #$00
ForBitByteSpawn:
	LDA !BossesDefeated1_7EF4E2
	BIT !BasicBITTable,x
	BEQ ForBitByteSpawnSkipIncrease
	INY
ForBitByteSpawnSkipIncrease:
	DEX
	BPL ForBitByteSpawn
	TYA
	RTL
}
org $BCC491 ;Removed code so Byte can spawn regardless if the current level was beaten or not.
{
	LDA !BitByteVileCheck_1FD8
	BIT #$04 ;Checks bit if Byte was fought once and was not destroyed.
	BNE DisableByteSpawn ;If so, disable Byte's fight
	
	JSL $82E0FB
	CMP #$08 ;Total bosses defeated then Byte cannot spawn
	BEQ DisableByteSpawn
	CMP #$02 ;Total bosses defeated before Byte spawns
	BCC DisableByteSpawn
	CMP #$07 ;Check if 7+ bosses defeated then determines if Byte spawns 100% or not
	BCS CheckIfBitDead
	
	LDA $09CF ;RNG bit (Keeps increasing at all times)
	LSR
	BCC AllowByteSpawn
	
DisableByteSpawn:
	JML !CommonEventEnd
	
CheckIfBitDead:
	LDA !BitByteVileCheck_1FD8
	BIT #$03 ;Checks if Bit is dead
	BEQ DisableByteSpawn
	
AllowByteSpawn:
}
org $878F85 ;Removed code so Bit can spawn regardless if the current level was beaten or not.
{
	LDA !BitByteVileCheck_1FD8
	BIT #$01 ;Checks if Bit has been fought once and was not destroyed.
	BNE DisableBitSpawn ;If so, disable Bit's fight	
	
	JSL $82E0FB
	CMP #$08 ;Total bosses defeated then Bit cannot spawn
	BEQ DisableBitSpawn
	CMP #$02 ;Total bosses defeated before Bit spawns
	BCC DisableBitSpawn
	CMP #07 ;Check if 7+ bosses defeated then determines if Bit spawns 100% or not
	BCS CheckIfByteDead
	
	LDA $09CF ;RNG bit (Keeps increasing at all times)
	LSR
	BCS AllowBitSpawn

DisableBitSpawn:
	JML !CommonEventEnd
	
CheckIfByteDead:
	LDA !BitByteVileCheck_1FD8
	BIT #$0C
	BEQ DisableBitSpawn
	
AllowBitSpawn:
}
	
	
org $BCC62F ;Changes Byte's boss battle music to be Doppler's boss theme
	LDA #$22 ;Sets boss music to be Doppler's boss music
	JSL !PlayMusic
	
org $87910F ;Changes Bit's boss battle music to be Doppler's boss theme
	LDA #$22 ;Sets boss music to be Doppler's boss music
	JSL !PlayMusic
	
org $8795B0 ;Changes Vile's boss battle music to be Doppler's boss theme
	LDA #$22 ;Sets boss music to be Doppler's boss music
	JSL !PlayMusic
	
;*********************************************************************************
; Modifies the hitbox of Sigma's Battle Body (Cannon/Arm) so it's much smaller and fits the hand only!
;*********************************************************************************
org $86EA3D
;DC FC 10 16

	db $E0 ;Extra X coordinate for hit box
	db $04 ;Extra Y coordinate for hit box
	db $0D ;Width of hit box (Higher the number, small it is?)
	db $0D ;hitbox of hitbox (Higher the number, small it is?)
	
	
org $81DDBD ;Sets velocity of PC entering Sigma's boss door on final level
	LDA #$00E0 ;Changed to #$00E0 so Zero does not fall through the floor
	
;***************************
;***************************
; Set basis for all Item Objects in-game. (IE: Health refill, ammo refill, 1-ups, etc..)
;***************************
org $80DB00 ;Original code location that loads basis for all Item Objects in-game and a few other instances.
	JSL !BaseItemObjectLocation
	RTS
	NOP #2
	
;*********************************************************************************
; Sets palette for PC sub-weapons after Vile jumps out of his Ride Armor in FACTORY level
; This is altered so it no longer does so. Seems redundant to load it.
;*********************************************************************************
org $83BB84 ;Removes palette load for PC and their sub-weapons
	NOP #4
;This whole section is ridiculous. It literally loads a JSR to the code that is DIRECTLY NEXT TO IT.
;Removed the entire JSR and the RTL as the routine now loads a RTL at the end anyway.

;*********************************************************************************
; Changes a pointer of PC's action (Action #18 - Entering boss door) so it resets PC's jump values
;*********************************************************************************
org $848263 ;Loads action #18 (PC Entering mid-boss door and miscellaneous PC pauses)
	dw $B703 ;Sets new pointer location

org $84B703 ;Load new code location to reset PC's double jump values when entering a door
	JSL SetJumpValues
	RTS

;*********************************************************************************
; Original routine to store Hyper Charge life when getting damaged.
; Heavily altered so it's compressed but does the same thing now.
;*********************************************************************************	
org $84CD8E ;Original code location that checked if you had Hyper Charge equipped, if so, do not heal.
;Whole routine was altered so it heals no matter what for 'half' the damage you take equipped or not.
{
	SEP #$30
	LDA !CurrentPC_0A8E ;Loads $7E:0A8E (Current PC). If you are not X, it will automatically skip the routine to heal Hyper Charge.
	BNE EndHealHyperCharge
	
	LDX #$09
	JSL LoadPCSplitSubWeapon
	BEQ EndHealHyperCharge
	CMP #$C0
	BEQ BeginHealHyperCharge
	BRA SkipBeginHealAndContinue
	
	BeginHealHyperCharge:
	LDA #$00

	SkipBeginHealAndContinue:
	STA $0002
	LDA $0000
	CMP #$01
	BEQ SkipHyperChargeHealDivide
	LSR

	SkipHyperChargeHealDivide:
	CLC
	ADC $0002
	CMP #$1C
	BCS StoreMaxHyperCharge
	BRA	SkipStoreMaxHyperCharge
	
	StoreMaxHyperCharge:
	LDA #$1C
	
	SkipStoreMaxHyperCharge:
	JSL StorePCSplitSubWeapon
	
	EndHealHyperCharge:
	SEP #$20
	REP #$10
	
	JSR $CE3C
}

	
;*********************************************************************************
; Alters loading location for all decompressed pointer data.
; Main table is now BLANK and is moved outside of the normal ROM.
; Code now allows for any bank usage as long as it's set properly in $12
;*********************************************************************************	
org $80873B
{
	JSL NewDecompressedLocation
	NOP
	SEP #$10
	LDY #$00
	LDX $A4
	REP #$21
	LDA [$10],y
}
	
org $80879E
{
	STA $00
	INY #2
	LDA [$10],y
	STA $14
	INY #2
	LDA [$10],y
	STA $18
	INY #2
	LDA [$10],y
	STA $1A
	INY
	
	LDA $18
	ADC $00
	BCC EndDecompressLoading
	BEQ EndDecompressLoading
	STA $02
	EOR #$FFFF
	ADC $00
	STA $00
	LSR
	ADC $14
	STA $1C
	SEC
	RTS
	
EndDecompressLoading:
	CLC
	RTS
}
	
;*********************************************************************************
; Something to do with single byte sub-weapon loading
;*********************************************************************************	
org $869C6D ;Single byte to load proper sub-weapons (First one is introduction level, thus goes unused)
	db $07 ;This is used for the Stage Select Mini pop-up for Neon Tiger.
	db $02,$07,$06,$01,$03,$04,$08,$05
	
;*********************************************************************************
; Rewriting the routine that restores sub-weapon ammo upon entering a level.
; DIFFICULT BASED
; If on hard mode or higher, sub-weapon ammo will NOT refill
;*********************************************************************************	
org $80A3BC ;Loads original code location to restore sub-weapon ammo upon level entry
	SEP #$20
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE EndSubWeaponRestoreRoutine
	LDX #$14
	
LoopSubRestore:
	CPX #$09
	BEQ DecreaseSubWeaponRestore
	LDA !SubWeap_1FBA,x
	BEQ DecreaseSubWeaponRestore
	LDA #$1C
	STA !SubWeap_1FBA,x
	
DecreaseSubWeaponRestore:
	DEX
	BNE LoopSubRestore
	
EndSubWeaponRestoreRoutine:
	RTS
	
;*********************************************************************************
; Loads routine that checks how many bosses are defeated to allow Vile's Teleporter to spawn or be able to be gotten to (Various instances)
;*********************************************************************************
org $87E64E ;Loads original code location that checked how many bosses you had defeated to determine if you could use Jet Platform or not in Volt Catfish's level
	JSL $82E0FB ;Loads routine that determines how many bosses you've defeated by increasing Y then storing it to A.
	NOP #10
	
org $81F0E6 ;Loads original code location to spawn Vile's Teleporter in general if a certain number of bosses are defeated.
	JSL $82E0FB ;Loads routine that determines how many bosses you've defeated by increasing Y then storing it to A.
	NOP #10
	
org $81CDCC ;Loads original code location to allow PC to get to Vile's Teleporter in Crush Crawfish's level
	JSL $82E0FB ;Loads routine that determines how many bosses you've defeated by increasing Y then storing it to A.
	NOP #10
	
;*********************************************************************************
;Sets PC's X/Y coordinates on the Cliff Scene and the Credits Roll Scene
;*********************************************************************************
org $80AC24
	JSL PCCliffSceneCoordinates
	NOP #20
	
org $80AE15 ;Set PC and PCNPC's X coordinates
	JSL PCCreditRollCoordinates
	NOP #8
	
org $80AE5B ;Sets PC's Y coordinates
	NOP #6
	
org $80AEF6 ;Sets PCNPC's Y coordinates
	NOP #10
	
;*********************************************************************************
;Stage Select screen checking for Heart Tank values
;*********************************************************************************
org $8385D2
{
	PHA : PHX
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE CheckStageSelectHeartTankSolo
	
	
	LDA !XHeartTank_7EF41C
	ORA !ZeroHeartTank_7EF44C
	ORA !PC3HeartTank_7EF47C
	ORA !PC4HeartTank_7EF4AC
	STA $0000
	
	StageSelectHeartTankCommon:
	LDA $9C0C,x
	TAX
	LDA $0000
	DEX
	BIT !BasicBITTable,x
	BNE StageSelectHeartTankEndRoutine
	
	StageSelectHeartTankIncreaseEnd:
	PLX : PLA
	INC
	RTS
	
	StageSelectHeartTankEndRoutine:
	PLX : PLA
	RTS
	
	CheckStageSelectHeartTankSolo:
	STX $0002
	LDA !CurrentPCCheck_1FFF
	ASL #3
	STA $0000
	ASL
	CLC
	ADC $0000
	TAX
	LDA !XHeartTank_7EF41C,x
	STA $0000
	
	LDX $0002
	BRA StageSelectHeartTankCommon
}
	
;*********************************************************************************
;Allow PCs to be changed on the Title Screen by pressing the 'Select' button and other settings on Title Screen
;Only 'bug' for this is that X and Zero need to have separate character coordinates on screen so it loads them up properly
;*********************************************************************************
org $808F36
	JSL TitleScreenSwitch
	
org $808F6D
	LDA $AD
	BIT #$10

org $808F45 ;BIT mask to allow you to move down. (Changed so only the 'down' arrow key can do that)
	BIT #$04
	
org $808EED ;Loads basic info for Title Screen. Just being moved so it can load another text string.
	JSL VariousTitleScreen
	NOP #2
	
	
;General coordinates of Game Start, Password, Options
{
org $868FE6 ;X/Y coordinates of (Game Start)
	dw $0A4A
org $868FF5 ;X/Y coordinates of Password
	dw $0A8A
org $869002 ;X/Y coordinates of Options
	dw $0ACA

org $869012 ;X/Y coordinates of Game Start
	dw $0A4A
org $869021 ;X/Y coordinates of (Password)
	dw $0A8A
org $86902E ;X/Y coordinates of Options
	dw $0ACA

org $86903E ;X/Y coordinates of Game Start
	dw $0A4A
org $86904D; X/Y coordinates of Password
	dw $0A8A
org $86905A ;X/Y coordinates of (Options)
	dw $0ACA
}
		
;String setup for 'PRESS SELECT: START AS xxxxx'
{
org $868E7A ;Loads pointer to 'OPENING DEMO' text
	dw $97BF ;PRESS SELECT: START AS X
	dw $97DF ;PRESS SELECT: START AS ZERO
	dw $97FF ;PRESS SELECT: START AS
	dw $981F ;PRESS SELECT: START AS
	dw $983F ;Press any button to save.
	
org $8697BF
	db $1B ;Total amount of letters
	db $2C ;Palette of letters
	dw $0B43 ;X/Y coordinates of string
	
	db "PRESS SELECT: START AS X   ",$00 ;PRESS SELECT: START AS X
	
org $8697DF
	db $1B ;Total amount of letters
	db $2C ;Palette of letters
	dw $0B43 ;X/Y coordinates of string
	
	db "PRESS SELECT: START AS ZERO",$00 ;PRESS SELECT: START AS ZERO
	
org $8697FF
	db $1B ;Total amount of letters
	db $2C ;Palette of letters
	dw $0B43 ;X/Y coordinates of string
	
	db "PRESS SELECT: START AS     ",$00 ;PRESS SELECT: START AS
	
org $86981F
	db $1B ;Total amount of letters
	db $2C ;Palette of letters
	dw $0B43 ;X/Y coordinates of string
	
	db "PRESS SELECT: START AS     ",$00 ;PRESS SELECT: START AS
	
org $86983F
	db $19 ;Total amount of letters
	db $2C ;Palette of letters
	dw $0AE4 ;X/Y coordinates of string
	
	db "Press any button to save.",$00 ;PRESS SELECT: START AS
}

org $808F55 ;Routine that sets PCs X/Y coordinates on the menu
	JSL PCTitleScreenCoordinates
	NOP #2
	

org $8687F8 ;X's title screen coordinates
	db $96 ;Game Start
	db $A6 ;Password
	db $B6 ;Options
	
org $8697AF ;Zero's title screen coordinates
	db $91 ;Game Start
	db $A1 ;Password
	db $B1 ;Options
	
	
	
;*********************************************************************************
; Sets X/Y coordinates of the 'SHING' effect on the victory animation
;*********************************************************************************
org $84B155
	JSL PCVictoryShingXCoordinate
	NOP
	
;*********************************************************************************
; Loads X/Zero's Introduction graphic/new palette
;*********************************************************************************
org $80930A ;Original code location to load X/Zero Introduction Compressed graphics. Now loads them as decompressed graphics.
	LDY #$B8
	JSR !LoadDecompressedGraphics

	
org $80932B ;Original code location to load palette routine for Black Background for X/Zero Introduction graphics
	JSL X_Zero_IntroductionPalette
	NOP #3
	
	
;*********************************************************************************
; Alters Helmet Hologram code slightly so it's an RTL instead of an RTS. Also loads a new routine that will make the helmet hologram properly work with the original RAM values.
;*********************************************************************************
org $848FA8
	JSL PC_HelmetHologram
	NOP #3
	
org $849099
	RTL
	
	
;*********************************************************************************
; Setting up Save/Load Screen (SRAM starts at $70:0000 - $70:0100 for basis though)
;*********************************************************************************	
org $80FFD8
	db $03 ;Sets SRAM to being available and as the smallest size (8KB)
	
org $809E02 ;Loads original JSR location for Password Screen upon leaving a level.
	JSR SaveScreen
	
org $80A1BA ;Loads original JSR location for Password Screen upon running out of lives and getting a game over.
	JSR SaveScreen_ResetLives
	
org $809EF1 ;Loads original JSR location for Password Screen after cut scenes.
	JSR SaveScreen
	

	
	
org $80ED42 ;Loads entirety of password screen and it's separate events
{
	PHP
	PHD
	SEP #$30
	
	PasswordScreen_Loop:
	PEA $1E58
	PLD
	
	LDX $01
	JSR (PasswordScreenPointers,x) ;Loads all split events for Password Screen
	
	LDA $00
	BEQ PasswordScreen_Base
	JSL $8182C7 ;Draws general Cursor Sprite on Password Screen (On Numbers and on 'START')
	JSL DisplayNewMenu_AllSprites
	JSR $F3E4 ;??? (Unknown Sprites)
	
	PEA $0000
	PLD
	JSR $DD59 ;Allows sprites to animate and appear
	JSR !SendToVRAM_8162
	BRA PasswordScreen_Loop
	
	PasswordScreen_Base:
	PEA $0000
	PLD
	JSR $DD59 ;Allows sprites to animate and appear
	JSR !SendToVRAM_8162
	PLD
	PLP
	RTS

	
	
;*********************************************************************************
	PasswordScreenPointers:
		dw PasswordScreen_Event00 ;Presets all data on Password Screen. (IE: Palettes, Tile Map, Graphics, Music)
		dw PasswordScreen_Event02 ;Fades screen in
		dw PasswordScreen_Event04 ;All button presses
		dw PasswordScreen_Event06 ;Load this file? (Yes No)
		dw PasswordScreen_Event08 ;Load file success
		dw PasswordScreen_Event0A ;Screen fade out
		dw PasswordScreen_Event0C ;Backing out of password screen
		dw PasswordScreen_Event0E ;Delete this file? (Yes no)
		
PasswordScreen_Event00: ;Loads up basis for Password Screen. (IE: Palettes, Tile Map, Graphics, Music)
{
	JSR $8841 ;Clears out entirety of PC RAM
	
	INC $00
	LDA #$02 ;Sets value to load PasswordScreen_Event02
	STA $01
	LDA #$04 ;Sets PC and PC Sub-Weapon Health bar to be invisible
	STA !PCHealthBar_1F22
	STA !PCSubWeaponAmmoBar_1F23
	STZ $40
	STZ $41
	
	LDA #$1E ;Which music track to play
	JSL !PlayMusic
	
	LDA #$02 ;Load which section of sprites to load from a level. (This is set to #$02 so it loads Heart Tank from Crush Crawfish's level)
	STA $1F18
	LDA #$06 ;Load Crush Crawfish level to get Heart Tank sprites. (Can work from any level as long as $7E:1F18 is set right)
	STA !CurrentLevel_1FAE
	JSR $B1E0 ;Load routine to load object/enemy graphical data into VRAM for stages
	JSR !SendToVRAM_8162
	
	PHD
	PEA $0000 ;Sets RAM basis to $0000
	PLD
	
	LDY #$AA ;Value to use to get where the data setup is
	JSR !LoadDecompressedGraphics ;Decompression routine
	JSR !SendToVRAM_8162
	
	LDY #$AE ;Loads Password Screen Graphics (Compressed)
	JSR !LoadDecompressedGraphics
	JSR !SendToVRAM_8162
	
	LDY #$0E ;Loads dialogue Layer 3 font
	JSR !LoadDecompressedGraphics
	JSR !SendToVRAM_8162
	
	LDY #$56 ;Load Password Number Sprites/Zero Face/Doppler Face/Cursor (Compressed)
	JSR !LoadCompressedGraphics
	JSR !SendToVRAM_8162
	
	JSL LoadScreen_PresetAllData
	
	SEP #20
	STZ $0300
	STZ $0301
	PLD
	RTS	
}
	
PasswordScreen_Event02: ;Fades Password Screen in
{
	PHD
	PEA $0000
	PLD
	
	JSR $861F ;Loads routine to fade screen in
	
	PLD
	LDA #$04 ;Sets value to load PasswordScreen_Event04 for button press checks
	STA $01
	RTS
}	

PasswordScreen_Event04: ;Button presses for Password Screen
{
	JSL LoadScreen_KeyPresses
	RTS
}
	
PasswordScreen_Event06: ;Load this file? (Button press)
{
	JSL LoadScreen_LoadFileKeyPresses
	JSL LoadScreen_SelectionCursor
	RTS
}

PasswordScreen_Event08: ;Load file success
{
	DEC $41
	BNE PasswordScreen_Event08_End
	INC $41
	LDA #$0A ;Load password event to fade screen out
	STA $01
	
	PasswordScreen_Event08_End:
	RTS
}

PasswordScreen_Event0A: ;Load file success (Screen fade out)
{
	SEP #$30
	LDY #$04 ;How fast to fade music out
	JSR $8561 ;Music fade out routine
	
	PHD
	PEA $0000
	PLD
	JSR $8641 ;Screen fade out routine
	
	LDA #$07
	TSB $00A3
	JSR !SendToVRAM_8162
	
	PLD
	JSL LoadScreen_SendSRAMToRAM ;Routine to send all SRAM data into RAM
	JSR $A52B ;Routine that sets all RAM data when password is successful
	
	LDA #$00
	STA $7FCFE0
	RTS
}

PasswordScreen_Event0C: ;Backing out of screen
{
	LDY #$04 ;How fast to fade music out
	JSR $8561 ;Music fade out routine
	
	PHD
	PEA $0000
	PLD
	JSR $8641 ;Screen fade out routine
	PLD
	
	REP #$30
	PHB
	LDX #$CFE0 ;Where to transfer data from
	LDY #$FFCB ;Where to transfer data to
	LDA #$000F ;How many bytes to transfer
	MVN $7F,$7E
	PLB
	
	SEP #$30
	STZ $00
	LDA #$01
	STA $7FCFE0
	RTS
}
	
PasswordScreen_Event0E: ;Erase this file? (Button press)
{
	JSL LoadScreen_EraseFileKeyPresses
	JSL LoadScreen_SelectionCursor
	RTS
}	

}


SaveScreen:
{
	PHP
	PHD
	SEP #$30
	
	SaveScreen_Loop:
	PEA $1E58
	PLD
	
	LDX $01
	JSR (SaveScreenPointers,x) ;Loads all split events for Password Screen
	
	LDA $00
	BEQ SaveScreen_Base
	JSL $8182C7 ;Draws general Cursor Sprite on Password Screen (On Numbers and on 'START')
	JSL DisplayNewMenu_AllSprites
	JSR $F3E4 ;??? (Unknown Sprites)
	
	PEA $0000
	PLD
	JSR $DD59 ;Allows sprites to animate and appear
	JSR !SendToVRAM_8162
	BRA SaveScreen_Loop
	
	SaveScreen_Base:
	PEA $0000
	PLD
	JSR $DD59 ;Allows sprites to animate and appear
	JSR !SendToVRAM_8162
	PLD
	PLP
	RTS

	
	
;*********************************************************************************
	SaveScreenPointers:
		dw SaveScreen_Event00 ;Presets all data on Password Screen. (IE: Palettes, Tile Map, Graphics, Music)
		dw SaveScreen_Event02 ;Fades screen in
		dw SaveScreen_Event04 ;All button presses
		dw SaveScreen_Event06 ;Overwrite this file? (Yes No)
		dw SaveScreen_Event08 ;Backing out of password screen
		;dw SaveScreen_Event06 ;Password Success $EE91
		;db SaveScreen_Event08 ;Password Success (Fade out) $EE9C
		;db SaveScreen_Event0A ;Password Error $EEBC
		;db SaveScreen_Event0C ;Pressing 'B' to back out of password screen $EEC5
		
SaveScreen_Event00: ;Loads up basis for Password Screen. (IE: Palettes, Tile Map, Graphics, Music)
{
	JSR $8841 ;Clears out entirety of PC RAM
	
	INC $00
	LDA #$02 ;Sets value to load SaveScreen_Event02
	STA $01
	LDA #$04 ;Sets PC and PC Sub-Weapon Health bar to be invisible
	STA !PCHealthBar_1F22
	STA !PCSubWeaponAmmoBar_1F23
	STZ $40
	STZ $41
	
	LDA #$1E ;Which music track to play
	JSL !PlayMusic
	
	LDA #$02 ;Load which section of sprites to load from a level. (This is set to #$02 so it loads Heart Tank from Crush Crawfish's level)
	STA $1F18
	LDA #$06 ;Load Crush Crawfish level to get Heart Tank sprites. (Can work from any level as long as $7E:1F18 is set right)
	STA !CurrentLevel_1FAE
	JSR $B1E0 ;Load routine to load object/enemy graphical data into VRAM for stages
	JSR !SendToVRAM_8162
	
	PHD
	PEA $0000 ;Sets RAM basis to $0000
	PLD
	
	LDY #$AA ;Value to use to get where the data setup is
	JSR !LoadDecompressedGraphics ;Decompression routine
	JSR !SendToVRAM_8162
	
	LDY #$AE ;Loads Password Screen Graphics (Compressed)
	JSR !LoadDecompressedGraphics
	JSR !SendToVRAM_8162
	
	LDY #$0E ;Loads dialogue Layer 3 font
	JSR !LoadDecompressedGraphics
	JSR !SendToVRAM_8162
	
	LDY #$56 ;Load Password Number Sprites/Zero Face/Doppler Face/Cursor (Compressed)
	JSR !LoadCompressedGraphics
	JSR !SendToVRAM_8162

	JSL SaveScreen_PresetAllData
	
	SEP #20
	STZ $0300
	STZ $0301
	PLD
	RTS	
}
	
SaveScreen_Event02: ;Fades Password Screen in
{
	PHD
	PEA $0000
	PLD
	
	JSR $861F ;Loads routine to fade screen in
	
	PLD
	LDA #$04 ;Sets value to load SaveScreen_Event04 for button press checks
	STA $01
	RTS
}	

SaveScreen_Event04: ;Button presses for Password Screen
{
	JSL SaveScreen_KeyPresses
	RTS
}
	
SaveScreen_Event06: ;Overwrite this file? (Button press)
{
	JSL SaveScreen_SaveFileKeyPresses
	JSL LoadScreen_SelectionCursor
	RTS
}

SaveScreen_Event08: ;Backing out of screen
{
	SEP #$30
	LDY #$04 ;How fast to fade music out
	JSR $8561 ;Music fade out routine
	
	PHD
	PEA $0000
	PLD
	JSR $8641 ;Screen fade out routine
	PLD
	
	REP #$30
	PHB
	LDX #$CFE0 ;Where to transfer data from
	LDY #$FFCB ;Where to transfer data to
	LDA #$000F ;How many bytes to transfer
	MVN $7F,$7E
	PLB
	
	SEP #$30
	STZ $00
	LDA #$01
	STA $7FCFE0
	RTS
}
	
}

SaveScreen_ResetLives:
{
	LDA #$02
	STA $1FB4
	JSR SaveScreen
	RTS
}

	
org $8182C7 ;Loads password screen cursor sprite data
{
	PHD
	PEA $0D18
	PLD
	
	LDA $01
	BNE PasswordScreen_Cursor_CheckColumn
	
	INC $01 ;Sets sprite as active
	STZ $18
	LDA #$55 ;Loads animation data byte
	STA $16
	LDA #$34 ;???
	STA $11
	LDA #$FF ;???
	STA $04
	STA $07
	STZ $06
	STZ $09
	
	LDA #$0E ;Load animation to use
	STA $0B
	JSL !AnimationOneFrame
	
	LDA #$2C ;Loads palette
	STA $11
	
	PasswordScreen_Cursor_CheckColumn:
	LDA #$1F ;Load base Y coordinates of cursor
	STA $08
	LDA $1E5F ;Loads which row selected with password cursor
	STA $07 ;Store to temp.
	LDA #$0E
	CMP $0B ;Compares with value at $0B
	BEQ PasswordScreen_Cursor_SkipAnimationUpdate
	
	STA $0B
	JSL !AnimationOneFrame
	
	PasswordScreen_Cursor_SkipAnimationUpdate:
	;Sets Y coordinates of password cursor
	LDA $07 ;Check temp. storage for row selected with password cursor
	ASL #3
	STA $0A
	CLC
	ADC $08
	STA $08
	LDA $0A
	ASL
	CLC
	ADC $08
	STA $08
	
	;LDA $1E5C ;Loads row selected with password cursor
	LDA #$21 ;Set base X coordinate for password cursor
	STA $05
	JSL !VRAMRoutineAlt
	
	LDA $1E99
	BNE PasswordScreen_Cursor_SkipEventLoop
	
	PasswordScreen_Cursor_EventLoop:
	JSL !EventLoop
	
	PasswordScreen_Cursor_SkipEventLoop:
	PLD
	RTL
}
	
	
;*********************************************************************************
; 'Thank you for playing' screen being moved and rewritten
;*********************************************************************************	
org $80B0D8
{
	JSL EndingCredits_ThankYouForPlaying
	RTS
	
org $80B0DD
	SEP #$30
	LDY #$04 ;How fast to fade music out
	JSR $8561 ;Music fade out routine
	
	PHD
	PEA $0000
	PLD
	JSR $8641 ;Screen fade out routine
	PLD
	
	REP #$30
	PHB
	LDX #$CFE0 ;Where to transfer data from
	LDY #$FFCB ;Where to transfer data to
	LDA #$000F ;How many bytes to transfer
	MVN $7F,$7E
	PLB
	
	SEP #$30
	LDA #$01
	STA $7FCFE0
	LDA #$08
	STA $D5
	RTL
	
org $80B10D
	JSR SaveScreen
	RTL
}
	

;*********************************************************************************
; Splitting Spiral Buster code up between X and Zero
;*********************************************************************************
; org $81C157 ;Loads original code location to get the Missile that the Spiral Buster will use
	; JSL Zero_SpiralBuster_SetMissile
	; NOP
	
	
org $818390
	JSR $C528
	RTL
	
org $818394
	JSR $C3BE
	RTL
	
org $818398
	JSR $8C24
	RTL
	


;***************************
; Erasing/Altering old event data
;***************************
org $83BCD6 ;Loads object that holds X captive
	NOP #12 ;NOP'd out all data so it does NOT increase the event on it's death anymore.
			;Instead, it's handled inside of Zero NPC's event by checking for the object death.
			
org $83BB97 ;Sets X's weapon palette data/VRAM.
	RTL ;Changed the end to RTL since it's not used except in PC NPC events only
		
org $83B53C ;Sets wall explosion/tile map update for Sigma Wall event
	RTL ;Changed the end to RTL since it's not used except in PC NPC events only
			
org $83B76C ;Sets event for PC to check if they're done walking or not
	RTL ;Changed the end to RTL since it's not used except in the PC NPC event only
	

org $BFEF98 ;Sigma Head appearing Y coordinates
	ADC #$0A95
org $BFEFB4 ;Sigma Head appearing X coordinates
	ADC #$0691
org $BFEDBD ;Final Y coordinates of Sigma Head
	LDA #$0A95
org $BFEDC2 ;Final X coordinates of Sigma Head
	LDA #$0691

	
org $88B7D0 ;Load walking of Mac event at introduction
	JSL MacEventNoLifeBar
	
org $88B970 ;Load music for Zero's theme on introduction
	NOP #6
	
org $88965B ;Loads Doppler level music after explosion of Mosquitus on Zero but before event finishes.
;Left the code intact so when Zero is speaking to X if he gets damaged, it doesn't play music.
{
	LDA !CurrentPC_0A8E
	BEQ IgnoreBRADopplerMusicStart
	BRA EndDopplerMusicStart
	
	IgnoreBRADopplerMusicStart:
	JSL $84D1EF
	LDA #$81
	TRB $1F5F
	
	LDA #$17
	JSL !PlayMusic
	
	EndDopplerMusicStart:
	JML !CommonEventEnd	
}
	
	
;***************************
;***************************
; Dialogue box small: Changing the size so it can fit another line of text
;***************************
org !DialogueBoxSmall
{
	STA $0008
	LDA #$80 ;X coordinates of dialogue box
	STA $0000
	LDA #$38 ;Y coordinates of dialogue box
	STA $0002
	LDA #$60 ;Width of dialogue box
	STA $0004
	LDA #$28 ;Height of dialogue box
	STA $0006
	JML $82FCC8
}
	
	
;***************************
; Sets PC's buster palette restoration as a JSR for various routines throughout the game
;***************************
org $84FFCA ;Loads PC Buster Palette as a JSR
	JSL PCBusterPalette
	SEP #$30
	RTL
	
;***************************
;***************************
; Split PC NPC Zero into various PC NPCs
;***************************	
org $80DA7A
	JSL PCEventSplit
		
;***************************
;***************************
; Determines if a PC or PC NPC is firing X-Buster level 1/2/3
;***************************
org $818B71 ;Loads palette for level 2 buster missile if == 01 then sets direction of X-Buster for PC or PC NPC. (Changed so now it will load palette as long as missile is NOT 00.)
{
	LDA $0A
	CMP #$01 ;Check for missile object #1 (Level 2 Buster)
	BEQ ChangeBusterPalette
	
	CMP #$26 ;Check for missile object #2 (Level 2 Buster Clone)
	BNE DoNotChangeBusterPalette
ChangeBusterPalette:
	LDY #$06
DoNotChangeBusterPalette:
	STY $0000
	
	JSL XBusterPCNPC_Level1_2
	
	BusterLevel2JSR:
	STZ $0004
	NOP #3
	LDX $0A
	CPX #$01
	BEQ Level2MissileDec
	CPX #$26
	BNE IgnoreLevel2MissileDecrease
	
	Level2MissileDec:
	DEC $0004
	
	IgnoreLevel2MissileDecrease:
}

org $818A23 ;Loads a JSR to continue the buster routine so it doesn't lock onto a PC's coordinates
	JSR BusterLevel2JSR

org $818FC7 ;Original location of X-Buster level 3 code
	JSL XBusterPCNPC_Level3
	NOP #5
	
;***************************
;***************************
; Determines if PC X or NPC X is on screen to display armor
; Writes new code to check if NPC X is on screen, if so, swap the sprite priority of the armor and X
;***************************
org $80F6CA ;Load location to get JSL of armor setup
	JSL CheckPCArmorValue ;Routine to determine if PC or NPC X is wearing armor on screen.

org $838DDA ;Load routine that sets PC sprites and the armor data.
	JSL SwapSpritePriority ;Load routine that sets the order of PC objects for priority reasoning.
	NOP #2
	
org $838F6F ;Changes the end of the Armor Sprite routine to an RTL so it can be loaded from any bank.
	RTL
	
org $838FEC ;Changes the end of the PC Sprite routine to an RTL so it can be loaded from any bank.
	RTL
	

;***************************
;***************************
; Alters Capsule data so it doesn't last as long nor does it flash the parts on
;***************************
org $BFDD18 ;Capsule flash so it doesn't flash parts, rather just repeats the lightning
{
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


	db $01,$01,$15
	db $01,$00,$15
	db $07,$00,$15
	db $04,$80,$15
	db $FD,$FF
}
	
org $93C3AA ;Timer before it sets next event of Capsule Flash
	LDA #$01
	
org $93C408
	JSL PCCapsuleExamples
	
;***************************
; Resets PC's sub-weapon graphical data during events (Possibly gameplay as well)
;***************************
org !ReloadSubWeapGreaphics
	JSL PC_ResetSubWeapons
	NOP
