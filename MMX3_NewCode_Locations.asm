;==================================================================================
; Mega Man X3 (Base Mod Project)
; By xJustin3009x (Shishisenkou) (Justin3009)
;==================================================================================
; This file is used to import the code changes that separate all characters from one
; another so they can have individual stats instead of group stats.
;==================================================================================
; NOTE: The ROM MUST be expanded to 4MB first WITHOUT a header!
;==================================================================================
;Bugs
;-------------------
;1. There's a bug when restoring weapon health. If all weapons are already full, it'll actually try to heal ABOVE them and cause the health to loop [UNSURE IF FIXED]
	;Someone stated when Acid Burst had 1 life left, they were able to charge and release it and it underflowed.
		;Seems to be fixed now. Added a BVS check so it'd check if underflow flag was set. If so, it'd skip right to the end and store the empty sub-weapon ammo. [SHOULD BE FIXED NOW]
;2. There's a bug for sure with the stats at $7E:F300. This HAS just been confirmed. It seems to possibly only occur when you're playing as Zero in Doppler Stage 1.
	;It writes RAM data to $7E:F200 but sometimes it can actually overlap into the $7E:F300 area. I'm not sure why quite yet.
	;Might possibly have to do with $82/C66A or $82/C66C or $82/C6E5 or something later in the code. It's very well possible that it's all due to the falling ceiling.
	;$82/C57F 20 43 C6    JSR $C643  [$82:C643]   A:50DF X:0C74 Y:0008 P:envmxdIzC - Start of the routine
	;It's very possible that the PC stats will HAVE to be moved to $7E:F400 just to avoid any possibility of this happening anymore. [DONE. MOVED ALL DATA TO $7E:F400 INSTEAD]
	
;3. NEW BUG.
	;It looks like once you get off a ladder and try firing twice, it for some reason doubles the action command value and breaks the game.
		;This whole bug is due to it using the mass origin code for changing animations instead of setting specific animation instances to reset the jump values.
		;For some reason, it breaks the game doing it this way.



;Add new feature where X can move once he launches the charged Gravity Well and it increases his jump height like he's in water until it's finished. [DONE]
	;Changed $51A8B5 to #$00 instead of #$20 in X's animation data so it allows him to exit the Gravity Well animation instantly.
		;Offered by DRN-01

;Possibly add a new feature where Zero can life steal with his Z-Saber. Maybe 3 health at max ONLY if the Z-saber DESTROYS an enemy!
	;Might have to add in a specific check to see what enemy is being destroyed by the Z-Saber. Small enemies = 2, big enemies = 4 health restored.
		;MUST know exactly what value enemy is what.
		;Offered by DRN-01, Zero Dozer/Incinerate and Thanatos-Zero
		
;For Zero with sub-weapons patch, modify ALL of Zero's 'green chest orbs' will be blue like in the X3 art work. [MOSTLY DONE]
	;Need to redo this as Metalwario64 setup a new way to handle Zero's colors so his chest orbs and his helmet gem have to be redone. (Maybe make hair separate still?)
	;Zero's Get Weapon portrait needs to be reimported as well since that's been updated again too.
	
	;Then, modify ALL hair so it uses that palette slot so it can be separate! [DONE]
	;Also modify the darkest face color (Which shares with the darkest hair color) on each of his sprites so it won't be interfered with either on palette changes. [DONE]
	;Also modify the darkest Z-Saber color (The one closest to him, NOT the handle top, but the sheath itself) to use the darkest separate hair color so it doesn't get messed up. [DONE]
	;Need to modify GET WEAPON screen so it uses blue chest orbs.
	;Need to modify introduction sequence so it uses blue chest orbs.


;To do in the far future:
;--------------------------
;1. At address $84B9A7, have it JSL to empty space (Just these 4 bytes cause it's the sprite number storage). Here, have it draw the PC sprite (Based on what number their sprite is) into RAM.
	;Each sprite will be using 16x16 and maybe a couple 8x8 at most.
		;The code will HAVE to check for the PC's sprite assembly so it can properly split first. (IE X is 00, Zero is DE)
		;If it checks and hits that, then do the new code that draws the PC sprite data into RAM at $7F8600 (Seems to go unused for decompression most of the time)
		;Code will have to be added in to draw each individual body part instead of just a giant section of ROM.
			;Essentially, the full sprite for X will ALWAYS be setup in priority like it is in X X3 Sprites.png. So it's just a matter of drawing them piece by piece instead of the whole line.
	;VRAM can be modified as well to basically drop all the new VRAM code and instead it just stores what's in RAM straight to VRAM.
		;This would cut out a HUGE amount of data for X and Zero and allow full customization of their body parts.
		
		
		
;x309B3 ;Last changed this so it was all #$B0/#$90. In case it doesn't work!

;*********************************************************************************
;Blank data
;*********************************************************************************
;B9:C1BC - $B9:FFFF
;***************************
;***************************
; ROM Addresses
;***************************
		!BasicBITTable	= $9C76
			
		!DamageTablePointersNormal	= $00,$80
		!DamageTablePointersHard	= $80,$80
		!DamageTablePointersXtreme	= $00,$81
		!ComboDamageTablePointersNormal	= $80,$81
		!ComboDamageTablePointersHard	= $00,$82
		!ComboDamageTablePointersXtreme	= $80,$82
			
		!BaseTableStart = $C88900			
		!BaseCodeStart	= $CA8000
		
		!X_DialoguePointers		= $C08000
		!X_DialogueBank			= #$C0
		!Zero_DialoguePointers	= $C28000
		!Zero_DialogueBank		= #$C2
		!PC3_DialoguePointers	= $C48000
		!PC3_DialogueBank		= #$C4
		!PC4_DialoguePointers	= $C68000
		!PC4_DialogueBank		= #$C6
		
		!X_SubStringPointer	= $AB8600
		!Zero_SubStringPointer	= $AB8900
		!PC3_SubStringPointer	= $AB8C00
		!PC4_SubStringPointer	= $AB8F00
		
		!ZeroMainEvents	= $E08080
		!XMainEvents	= $E0C000
		!BaseItemObjectLocation		= $E48000
		!InteractiveObjectBase		= $D78000
;***************************
header : lorom

incsrc MMX3_Tables.asm
incsrc MMX3_VariousAddresses.asm
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Beginning of .ASM file. Writes ALL tables into a couple banks with excess room for more tables
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
org $80FA2F ;Routine now used for across bank send data into VRAM
AllowBankSendToVRAM:
	JSR !SendToVRAM_8162 ;Slightly used now for Allowing Decompressed Graphics
	RTL

;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Main portion of the .ASM file. This writes all the new JSL/JSR routines into a smaller format for free space optimization.
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
org !BaseCodeStart

;*********************************************************************************
;Loads normal game routine but then after loads a new routine to blank out PC RAM area.
;*********************************************************************************
ClearPCRAM: ;Routine to clear out the entire new PC RAM area starting at: $7E:F300 - $7E:F400
{
	PHB
	PHD
	LDA #$7E
	PHA
	PLB
	REP #$30
	LDX #$00FE
	
	loopSTZ:
	STZ $F400,x
	DEX #2
	BPL loopSTZ
	SEP #$30
	PLD
	PLB
	RTL
}

;*********************************************************************************
;Routines to check PC's life and update it upon entering levels, swapping characters, pre-setting life before entering a level, etc...
;*********************************************************************************
HeartTank: ;Routine to determine max PC health by counting how many Heart Tanks are obtained when entering levels, obtaining more heart tanks, etc...
{
	PHP
	SEP #$30
	LDY #$08
	STZ $0000
	STZ $0002
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE independenthealth ;Jumps to code for independent PC health instead of a group check.
	LDA #$04
	STA $0004
	LDX #$00
loop:
	LDA !XHeartTank_7EF41C,x
	TSB $0002
	TXA
	CLC
	ADC #$30
	TAX
	DEC $0004
	BNE loop
	LDA $0002
loop2:
	ROL A
	BCC $03
	INC $0000
	DEY
	BNE loop2
loopbackPChealth:
	JSL PCHeartTankBase ;Routine to set PC's max health. Separate for each PC.
	PLP
	RTL
independenthealth: ;Code for independent PC health check instead of group check.
	JSL IndependentHealthPC
	BRA loopbackPChealth
	
	IndependentHealthPC:
		LDA !CurrentPCCheck_1FFF
		ASL #3
		STA $0002
		ASL A
		CLC
		ADC $0002
		TAX
		LDA !XHeartTank_7EF41C,x
	loop3:
		ROL A
		BCC $03
		INC $0000
		DEY
		BNE loop3
		RTL
}
		
PCHeartTankBase: ;Routine to SET each PC's Max Health upon entering a level, swapping characters, etc..
{
	SEP #$20
	STX $0010
	LDX !CurrentPCCheck_1FFF
	JSR (PCHeartTankPointers,x)
	LDX $0010
	RTL

	PCHeartTankPointers:
		dw X_MaxHealthHeartTank
		dw Zero_MaxHealthHeartTank
		dw PC3_MaxHealthHeartTank
		dw PC4_MaxHealthHeartTank
		db $FF,$FF
		db $FF,$FF

	X_MaxHealthHeartTank: ;X's max health setup
		LDA $0000
		ASL A
		CLC
		ADC #$10
		STA !XMaxHealth_7EF41B
		RTS
			
	Zero_MaxHealthHeartTank: ;Zero's max health setup
		LDA $0000
		ASL A
		CLC
		ADC #$14
		STA !ZeroMaxHealth_7EF44B
		RTS
			
	PC3_MaxHealthHeartTank: ;PC #3's max health setup
		LDA $0000
		ASL A
		CLC
		ADC #$10
		STA !PC3MaxHealth_7EF47B
		RTS
			
	PC4_MaxHealthHeartTank: ;PC #4's max health setup
		LDA $0000
		ASL A
		CLC
		ADC #$10
		STA !PC4MaxHealth_7EF4AB
		RTS
}

StoreMaxSwapHealth: ;Loads 'FF' and stores it to all PC's SWAP STORAGE life to set their swap life as FF so they do not die upon swapping in.
{
	LDA !XMaxHealth_7EF41B
	STA !XSwapHealth_7EF41A
	LDA !ZeroMaxHealth_7EF44B
	STA !ZeroSwapHealth_7EF44A
	LDA !PC3MaxHealth_7EF47B
	STA !PC3SwapHealth_7EF47A
	LDA !PC4MaxHealth_7EF4AB
	STA !PC4SwapHealth_7EF4AA
	JSL SetJumpValues
	RTL
}

PCIconHealth: ;Loads routine to get !CurrentHealth_09FF then it stores it to their !XSwapHealth_7EF41A,x value based on who you are when swapping PCs.
{
	LDA !CurrentPC_0A8E ;Load Current PC
	ASL #3 ;Multiply 3 times
	STA $0000 ;Store to temp. variable of $0000
	ASL A ;Double the value
	CLC ;Clear carry flag
	ADC $0000 ;Add the original temp. variable of $0000
	TAX ;Transfer to 'X' to set which RAM location to properly use for new PC's swap health.
	LDA !CurrentHealth_09FF ;Loads PC's current health
	STA !XSwapHealth_7EF41A,x ;Stores it to their 'swap health' RAM location
	LDA !CurrentPCCheck_1FFF ;Loads Current PC Checker variable
	STA !CurrentPC_0A8E ;Stores to the current PC
	JSL PCIconRoutine ;Load routine to set which icon to use on health bar
	JSL PCSwapHealth ;Sets new PC's current health upon swapping out.
	RTL
}
	
PCSwapHealth: ;Loads routine to get PC's !XSwapHealth_7EF41A,x value then stores it to !CurrentHealth_09FF upon swapping characters.
{
	LDA !CurrentPC_0A8E ;Load Current PC
	ASL #3 ;Multiply 3 times
	STA $0000 ;Store to temp. variable of $0000
	ASL A ;Double the value
	CLC ;Clear carry flag
	ADC $0000 ;Add the original temp. variable of $0000
	TAX ;Transfer to 'X' to set which RAM location to properly use for new PC's swap health.
	LDA !XSwapHealth_7EF41A,x ;Loads PC's current 'swap health'
	STA !CurrentHealth_09FF ;Stores the 'swap health' value into PC's current health
	JSL HeartTank ;Loads routine to get PC's total max health based on how many heart tanks you have obtained.
	RTL
}

;These two routines MUST be grouped together at all times!
HeartTankGet: ;Loads routine to increases all PC's max health by going through a loop.
{
	LDA !Difficulty_7EF4E0 ;Check difficulty and if it's > 00 (Normal) then it'll separate the PC's Heart Tank obtaining.
	BIT #$01
	BNE incHTseparate
	LDX #$00 ;Set 'X' to 00
	LDY #$04 ;Set 'Y' to 04 (Total amount of times to loop)
	
	loop4:
	LDA !XMaxHealth_7EF41B,x ;Load PC's max health
	INC ;Increase it by one
	STA !XMaxHealth_7EF41B,x ;Store PC's max health
	LDA !XSwapHealth_7EF41A,x
	CMP #$FF
	BEQ IgnoreSwapHealthIncrease
	INC
	STA !XSwapHealth_7EF41A,x
	
	IgnoreSwapHealthIncrease:
	TXA ;Transfer X value to A
	CLC ;Clear carry flag
	ADC #$30 ;Add #$30 to jump to the next PC's RAM location
	TAX ;Transfer A to X
	DEY ;Decrease the Y counter
	CPY #$00 ;Check if 'Y' is #$00
	BNE loop4 ;If it's not #$00, then loop back and do the next PC's Max Health
	
	RTL
	
}
HeartTankGetSolo: ;Loads routine to increase only the CURRENT PC's max health when obtaining a Heart Tank.
{
	incHTseparate:
		LDA !CurrentPC_0A8E ;Load current PC you are playing as
		ASL #3 ;Triple value
		STA $0000 ;Store to temp. variable $0000
		ASL A ;Double value
		CLC ;Clear carry flag
		ADC $0000 ;Add original value stored in temp. variable $0000
		TAX ;Transfer value to X to determine which PC's RAM to load
		
		LDA !XMaxHealth_7EF41B,x ;Load PC's max health
		INC ;Increase it by one
		STA !XMaxHealth_7EF41B,x ;Store PC's max health
		RTL
}
	
HeartTankStore: ;Routine that increases the new Heart Tank Collection value for each PC
{
	LDA !CurrentPC_0A8E ;Load current PC you are playing as
	ASL #3 ;Triple value
	STA $0000 ;Store to temp. variable $0000
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0000 ;Add original value stored in temp. variable $0000
	TAX ;Transfer value to X to determine which PC's RAM to load
	
	LDA $0B ;Load total amount of Heart Tanks routine before hand caught when checking.
	CLC ;Clear carry flag
	ADC !XHeartTank_7EF41C,x ;Add current PC's Heart Tank collection
	STA !XHeartTank_7EF41C,x ;Store back to current PC's Heart Tank collection.
	RTL
}

;*********************************************************************************
; Routine to compare PC's max health to current health to determine if they use to their "low health" animation or not.
; Now checks each PC's max health separately incase of varying health.
;*********************************************************************************
PCLowHealthAni: ;Routine to obtain PC's max health for checking if they are low health or not.
{
	LDA !CurrentPC_0A8E ;Load current PC you are playing as
	ASL #3 ;Triple value
	STA $0002 ;Store to temp. variable $0000
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0002 ;Add original value stored in temp. variable $0000
	TAX ;Transfer value to X to determine which PC's RAM to load

	LDA !XMaxHealth_7EF41B,x ;Load current PC's max health
	LSR A ;Divide
	LSR A ;Divide
	RTL
}


;*********************************************************************************
; Loads PC's icon when jumping out of a Ride Armor.
;*********************************************************************************
;The whole routine checks first if you're on the introduction level and you're anyone other than X, if so, it'll reset you to be X. Otherwise, load proper PC Icon.
PCIconBase: ;Base start of the PC Icon routine.
{
	JSL !Palette

	PCIconAndIntroductionCheck:
	{
		LDA !CurrentLevel_1FAE ;Load current level
		BNE PCIconRoutine
		
		LDA !IntroductionLevelBIT_1FD3 ;Load bit to determine if introduction level is complete or not
		BIT #$01
		BNE PCIconRoutine
		
		LDA !CapsuleIntro_7EF4E4
		BIT #$80 ;Checks if you're using Zero on introduction or not
		BEQ LoadXInstead
		
		LDA #$02
		STA !CurrentPCCheck_1FFF
		BRA PCIconRoutine
		
		LoadXInstead:
		STZ !CurrentPCCheck_1FFF ;Store #$00 to Current PCCheck so you are 'X'
	}
	PCIconRoutine:
	{
	;First half of this routine is to determine if you're on the introduction level playing as anyone but X. If you are, then it'll revert everything back to X.
		SEP #$20
		LDA #$00
		XBA
		LDA !CurrentPCCheck_1FFF ;Load current PC in the PC Check
		LSR A ;Divide
		TAX ;Transfer A to X
		LDA PCIconBytes,x ;Load which value to use for PC's icon
		TAY ;Transfer A to Y
		JSL !LoadSubWeaponIcon ;Load routine that sets the icon data properly on screen.
		RTL
	}
}


;*********************************************************************************
; Routine to load Zero (Green) introduction palette
;*********************************************************************************
X_Zero_IntroductionPalette: ;Routine to load introduction palettes during story cut scene
{
	LDY #$011C
	JSL !PaletteAlternate
	
	LDY #$021A ;Load palette # for Zero Introduction (Green)
	JSL !PaletteAlternate
	RTL
}
	
;*********************************************************************************
; Routine to determine if you're able to swap to X or Zero depending on the level and Z-Saber circumstances.
; Now moved and has a separate table for each character to determine when they can switch.
; Now has a separate routine to determine the portraits of the characters you can swap too as well.
; Now can swap WITH Z-Saber if on New Game+ as long as the Z-Saber value is $E0+
;*********************************************************************************
PCMenuSwap: ;Routines to determine whether you're able to swap to a specific PC or not during levels.
;Houses routine to which levels PC can swap on.
;Houses routine that determines which portrait appears for each PC when they're swapping (IE: X loads Zero's portrait, vice versa)
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCMenuSwapPointers,x)
	RTL
		
		PCMenuSwapPointers:
			dw X_MenuSwap
			dw Zero_MenuSwap
			dw PC3_MenuSwap
			dw PC4_MenuSwap
			db $FF,$FF
			db $FF,$FF

		
		X_MenuSwap:
				LDA !ZSaberObtained_1FB2
				BIT #$40
				BEQ X_MenuSwap_EnableZeroSwap
				LDA #$01
				RTS
				
				X_MenuSwap_EnableZeroSwap:
				LDX !CurrentLevel_1FAE
				LDA XMenuSwapLevelTable,x
				RTS
				
		Zero_MenuSwap:
				LDA !ZSaberObtained_1FB2 ;Checks Z-Saber value for value of #$01, if so, you cannot swap to X anymore.
				BIT #$01 ;$7E:1FB2 has been updated so values 01/02 are moved for disabling music and 01 will disable X, 02 will give Zero the X-Buster upgrade.
				BEQ Zero_MenuSwap_EnableXSwap
				LDA #$01
				RTS
				
				Zero_MenuSwap_EnableXSwap:
				LDX !CurrentLevel_1FAE
				LDA ZeroMenuSwapLevelTable,x
				RTS
				
		PC3_MenuSwap:
				LDX !CurrentLevel_1FAE
				LDA PC3MenuSwapLevelTable,x
				RTS
				
		PC4_MenuSwap:
				LDX !CurrentLevel_1FAE
				LDA PC4MenuSwapLevelTable,x
				RTS
}

PCMenuPortrait: ;Routine to load portrait of character you can swap too.
{
	SEP #$20
	STX $0000
	LDX !CurrentPC_0A8E
	JSR (PCMenuPortraitPointers,x)
	RTL
		
	PCMenuPortraitPointers:
		dw X_WhomToSwapPortrait
		dw Zero_WhomToSwapPortrait
		dw PC3_WhomToSwapPortrait
		dw PC4_WhomToSwapPortrait
		db $FF,$FF
		db $FF,$FF

		X_WhomToSwapPortrait:
			LDX $0000
			LDA #$00
			STA $1F11
			LDY #$94
			LDA #$01 ;Used as a check to determine if uses decompressed graphics routine (00 = Yes, > 00 = No)
			RTS
			
		Zero_WhomToSwapPortrait:
			LDX $0000
			LDA #$02
			STA $1F11
			LDY #$BE
			LDA #$00 ;Used as a check to determine if uses decompressed graphics routine (00 = Yes, > 00 = No)
			RTS
			
		PC3_WhomToSwapPortrait:
			LDX $0000
			RTS
			
		PC4_WhomToSwapPortrait:
			LDX $0000
			RTS
}

;*********************************************************************************
; Routine to draw PC's max health bar on screen.
;*********************************************************************************
HealthDraw: ;Load routine to draw PC's health on screen
{
	LDA !CurrentPCCheck_1FFF ;Load current PC you are playing as
	ASL #3 ;Triple value
	STA $0000 ;Store to temp. variable $0000
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0000 ;Add original value stored in temp. variable $0000
	TAX ;Transfer value to X to determine which PC's RAM to load
	
	LDA !XMaxHealth_7EF41B,x
	STA $0E
	RTL

HealthCompare: ;Load routine to compare PC's current health with their max health on screen
	STA $0002
	LDA !CurrentPCCheck_1FFF ;Load current PC you are playing as
	ASL #3 ;Triple value
	STA $0000 ;Store to temp. variable $0000
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0000 ;Add original value stored in temp. variable $0000
	TAX ;Transfer value to X to determine which PC's RAM to load
	
	LDA $0002
	CMP !XMaxHealth_7EF41B,x
	RTL

HealthCMPStore: ;Load routine to set PC's max health to their current health if they have full health on screen
	LDA !CurrentPCCheck_1FFF ;Load current PC you are playing as
	ASL #3 ;Triple value
	STA $0000 ;Store to temp. variable $0000
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0000 ;Add original value stored in temp. variable $0000
	TAX ;Transfer value to X to determine which PC's RAM to load
	
	LDA !XMaxHealth_7EF41B,x
	STA !CurrentHealth_09FF
	RTL
}
	
;*********************************************************************************
; Compares PC's current health to max health to determine if they need to heal or not when retrieving a healing object
;*********************************************************************************
PCHealthGetCMP: ;Routine to compare PC's max health to what is in a temporary variable to determine if they can heal or not.
{
	STA $0002
	LDA !CurrentPC_0A8E ;Load current PC you are playing as
	ASL #3 ;Triple value
	STA $0000 ;Store to temp. variable $0000
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0000 ;Add original value stored in temp. variable $0000
	TAX ;Transfer value to X to determine which PC's RAM to load
	
	LDA !XMaxHealth_7EF41B,x ;Load PC's max health
	STA $0004 ;Store to temp. variable.$0004
	LDA $0002 ;Load temp. variable $0002
	CMP $0004 ;Compare with temp. variable at $0004
	RTL
}

;*********************************************************************************
; Compares PC's current health to max health to determine if they need to heal or not when regenerating from capsule part then continues to sub-tanks
;*********************************************************************************
PCSubTankHealHealthChip: ;Routine that determines how much health gets healed each time you heal successful with Helmet Chip for Sub-Tanks.
{
	LDX #$00
SubTankHealHealthChipSTART:
	JSL SelectSubTank
	
	BPL SubTankHealHealthChipINCX
	CMP #$8E
	BCS SubTankHealHealthChipINCX
	
	PHA ;Push PC's health
	LDA #$16 ;Which SFX to play when successfully healing
	JSL !PlaySFX
	
	LDA !PCHealCounter_7EF4EA ;Load PC's Heal Counter
	STA $0010 ;Store to temp. variable $0010
	PLA ;Pull PC's health
	CLC ;Clear carry flag
	ADC $0010 ;Add the Heal Counter variable
	JSL PCIncreaseHealthCounter ;Load routine to recover PC's current health
	
	JSL StoreToSubTank ;Load routine to store health data back to sub-tank
	CMP #$8E
	BCS SubTankHealHealthChipFULL
	
	LDA #$01
	RTL
	
SubTankHealHealthChipINCX:
	INX
	CPX #$04
	BNE SubTankHealHealthChipSTART
	LDA #$00
	RTL
	
SubTankHealHealthChipFULL:
	LDA #$8E
	JSL StoreToSubTank
	
	LDA #$17 ;Which SFX to play when sub-tank is fully healed.
	JSL !PlaySFX
	LDA #$01
	RTL
}

PCIncreaseHealthCounter: ;Routine that determines how much health gets healed each time you heal successful with Helmet Chip.
;This was altered so now it only doubles the value when you have the Golden Armor.
{
	PHA ;Push PC's current health
	LDA !PCHealCounter_7EF4EA ;Load PC health counter
	BEQ PCIncreaseHealthCounter01 ;Branch if it's #$00 to PCIncreaseHealthCounter01 so it increases the base value to #$01
	
		LDA !RideChipsOrigin_7E1FD7
		CMP #$F0 ;Checks for all chip upgrades
		BCC PCHealCounterIGNOREDOUBLE
	
			LDA !PCHealCounter_7EF4EA ;Load PC health counter
			CMP #$08 ;Check if the value is #$08
			BEQ PCHealCounterIGNOREDOUBLE ;If value is #$08, then jump to PCHealCounterIGNOREDOUBLE so it doesn't double healing anymore.
				
				ASL ;Double Heal Counter value once base value is > 00
				BRA PCIncreaseHealthCounterStorage
	
	PCIncreaseHealthCounter01:
	INC ;Increase 'A' so the Heal Counter value goes up
	
	PCIncreaseHealthCounterStorage:
	STA !PCHealCounter_7EF4EA ;Store new value back to Heal Counter
	
	PCHealCounterIGNOREDOUBLE:
	PLA ;Pull PC's current health
	RTL
}

PCAddAllSubTanks: ;Routine that adds all current PC sub-tank collection together.
{
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE CheckOnlyCurrentPC
	
	JSL PCCombineSubTanks
	RTL
	
	CheckOnlyCurrentPC:
	LDA !CurrentPCCheck_1FFF
	ASL #3
	STA $0000
	ASL
	CLC
	ADC $0000
	TAX
	LDA !XSubTankCollect_7EF41D,x
	RTL
}


;*********************************************************************************
; Loads new RAM locations for PC's max health, which letters to load and sets new X/Y coordinates for PCs in menu.
;*********************************************************************************
PCSetHealthMenu: ;Routine to determine how large PC's health bar is in the menu.
{
	PHX ;Push X
	LDA !CurrentPC_0A8E ;Load current PC you are playing as
	ASL #3 ;Triple value
	STA $0000 ;Store to temp. variable $0000
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0000 ;Add original value stored in temp. variable $0000
	TAX ;Transfer value to X to determine which PC's RAM to load
	
	LDA !XMaxHealth_7EF41B,x ;Load PC's max health
	AND #$02 ;AND #$02
	STA $0000 ;Store to temp. variable $0002
	LDA !XMaxHealth_7EF41B,x ;Load PC's max health
	PLX ;Pull X
	RTL
}

PCSwapHealth_InMenu:
{
	PHX ;Push X
	LDA $0012 ;Temp. Variable storage for secondary PC Health
	ASL #3 ;Triple value
	STA $0000 ;Store to temp. variable $0000
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0000 ;Add original value stored in temp. variable $0000
	TAX ;Transfer value to X to determine which PC's RAM to load
	
	LDA !XSwapHealth_7EF41A,x ;Load PC's max health
	AND #$02 ;AND #$02
	STA $0000 ;Store to temp. variable $0002
	LDA !XSwapHealth_7EF41A,x ;Load PC's max health
	PLX ;Pull X
	RTL
}



PCSHealthBar_InMenu: ;Routine that loads both X and Zero's health bars in the menu. Their order depends on which PC you are playing as
{
	LDA !IntroductionLevelBIT_1FD3
	BIT #$01
	BEQ PCSHealthBar_InMenu_LoadMainHealthBar
	LDA !ZSaberObtained_1FB2
	BIT #$01
	BNE PCSHealthBar_InMenu_LoadMainHealthBar
	BIT #$40
	BNE PCSHealthBar_InMenu_LoadMainHealthBar
	
	PCSHealthBar_InMenu_DisplayLetters:
	LDA #$30
	JSL LoadPCFirstLetter
	JSL AllowBankSendToVRAM
	
	LDA #$3C
	JSL LoadPCSecondLetter
	JSL AllowBankSendToVRAM
	
	PCSHealthBar_InMenu_LoadMainHealthBar:
	LDA #$30
	JSL LoadMainPCHealthBar
	JSL AllowBankSendToVRAM
	
	LDA !IntroductionLevelBIT_1FD3
	BIT #$01
	BEQ PCSHealthBar_InMenu_End
	LDA !ZSaberObtained_1FB2
	BIT #$01
	BNE PCSHealthBar_InMenu_End
	BIT #$40
	BNE PCSHealthBar_InMenu_End
	
	PCSHealthBar_InMenu_DisplaySecondHealthBar:
	LDA #$3C
	JSL LoadSecondaryPCHealthBar
	JSL AllowBankSendToVRAM
	
	PCSHealthBar_InMenu_End:
	RTL
	
		LoadPCFirstLetter: ;Load routine that sets which health bar is what by drawing a letter on screen
		{
			STA $0001
			LDY $00A5
			LDA #$80
			STA $0600,y
			
			REP #$20
			LDA !ZSaberObtained_1FB2
			AND #$00FF
			BIT #$0001
			BNE LoadPCFirstLetter_DisplayHigherCoordinates
			BIT #$0040
			BNE LoadPCFirstLetter_DisplayHigherCoordinates
			BRA LoadPCFirstLetter_DisplayLowerCoordinates
			
			LoadPCFirstLetter_DisplayHigherCoordinates:
			LDA #$5932 ;Load X/Y coordinates to be lower
			BRA LoadPCFirstLetter_SetCoordinates
			
			LoadPCFirstLetter_DisplayLowerCoordinates:
			LDA #$5912 ;Load X/Y coordinates of letter
			
			LoadPCFirstLetter_SetCoordinates:
			STA $0601,y
			
			SEP #$20
			LDA #$02
			STA $0603,y
			INY #4
			
			LDA !CurrentPC_0A8E
			BNE LoadPCFirstLetter_LoadZ
			
			LoadPCFirstLetter_LoadX:
			LDA #$87 ;Load 'X'
			BRA LoadPCFirstLetter_SkipOtherLetter
			
			LoadPCFirstLetter_LoadZ:
			LDA #$89 ;Load 'Z'
			
			LoadPCFirstLetter_SkipOtherLetter:
			STA $0600,y
			LDA $0001
			STA $0601,y
			INY #2
			STY $00A5
			RTL
		}
	
		LoadPCSecondLetter: ;Load routine that sets which health bar is what by drawing a letter on screen
		{
			STA $0001
			LDY $00A5
			LDA #$80
			STA $0600,y
			
			REP #$20
			LDA #$5932 ;Load X/Y coordinates of letter
			STA $0601,y
			
			SEP #$20
			LDA #$02
			STA $0603,y
			INY #4
			
			LDA !CurrentPC_0A8E
			BEQ LoadPCSecondLetter_LoadZ
			
			LoadPCSecondLetter_LoadX:
			LDA #$87 ;Load 'X'
			BRA LoadPCSecondLetter_SkipOtherLetter
			
			LoadPCSecondLetter_LoadZ:
			LDA #$89 ;Load 'Z'
			
			LoadPCSecondLetter_SkipOtherLetter:
			STA $0600,y
			LDA $0001
			STA $0601,y
			INY #2
			STY $00A5
			RTL
		}	
	
		LoadMainPCHealthBar: ;Load routine to load PC's health bar
		{
			STA $0007
			STZ $0006 ;Sets palette of life bar
			LDX $00A5
			
			LDA #$80
			STA $0600,x
			
			REP #$20
			LDA !IntroductionLevelBIT_1FD3
			AND #$00FF
			BIT #$0001
			BEQ LoadMainPCHealthBar_DisplayHigherCoordinates
			LDA !ZSaberObtained_1FB2
			AND #$00FF
			BIT #$0001
			BNE LoadMainPCHealthBar_DisplayHigherCoordinates
			BIT #$0040
			BNE LoadMainPCHealthBar_DisplayHigherCoordinates
			BRA LoadMainPCHealthBar_DisplayLowerCoordinates
			
			LoadMainPCHealthBar_DisplayHigherCoordinates:
			LDA #$5932 ;Load X/Y coordinates to be lower
			BRA LoadMainPCHealthBar_SetCoordinates
			
			LoadMainPCHealthBar_DisplayLowerCoordinates:
			LDA #$5913 ;Load X/Y coordinates of letter
			
			LoadMainPCHealthBar_SetCoordinates:
			STA $0601,x
			LDA #$0010 ;End graphic for PC Health (Start Cap)
			ORA $0006
			STA $0604,x
			
			SEP #$20
			JSL PCSetHealthMenu ;Load routine to determine PC's health bar size in menu
			LSR #2
			STA $0002
			ASL
			CLC
			ADC #04
			STA $0603,x
			INX #6
			
			LDA !CurrentHealth_09FF
			STA $0004
			JSL $80D521
			RTL
		}
	
		LoadSecondaryPCHealthBar: ;Load routine to load secondary PC's health bar
		{
			STA $0007
			STZ $0006 ;Sets palette of life bar
			LDX $00A5
			
			LDA #$80
			STA $0600,x
			
			REP #$20
			LDA #$5933 ;Set's X/Y coordinates of health bar for PC in menu
			STA $0601,x
			LDA #$0010 ;End graphic for PC Health (Start Cap)
			ORA $0006
			STA $0604,x
			
			SEP #$20
			LDA !CurrentPC_0A8E
			STA $0010
			BNE LoadSecondaryPCHealthBar_LoadX
			LDA #$02
			BRA LoadSecondaryPCHealthBar_LoadHealth
			
			LoadSecondaryPCHealthBar_LoadX:
			LDA #$00

			LoadSecondaryPCHealthBar_LoadHealth:
			STA !CurrentPC_0A8E
			STA !CurrentPCCheck_1FFF
			STA $0012
			JSL PCSetHealthMenu ;Load routine to determine PC's health bar size in menu
			LSR #2
			STA $0002
			ASL
			CLC
			ADC #04
			STA $0603,x
			LDA $0000
			STA $0008
			LDA $0010
			STA !CurrentPC_0A8E
			STA !CurrentPCCheck_1FFF
			INX #6
			
			JSL PCSwapHealth_InMenu
			STA $0004
			LDA $0008
			STA $0000
			JSL $80D521
			RTL
		}
}

LoadPC_XYCoordinates_Menu: ;Loads coordinates for PCs in the menu based on if both health bars display or not
{
	SEP #$20
	STX $0000
	LDX !CurrentPC_0A8E
	JSR (LoadPC_XYCoordinates_MenuPointers,x)
	RTL
		
	LoadPC_XYCoordinates_MenuPointers:
		dw X_XYCoordinates_Menu
		dw Zero_XYCoordinates_Menu
		dw PC3_XYCoordinates_Menu
		dw PC4_XYCoordinates_Menu
		db $FF,$FF
		db $FF,$FF

		X_XYCoordinates_Menu:
			LDA !IntroductionLevelBIT_1FD3
			BIT #$01
			BEQ X_XYCoordinates_Menu_DisplayHigherCoordinates
			LDA !ZSaberObtained_1FB2
			BIT #$40
			BEQ X_XYCoordinates_Menu_DisplayLowerCoordinates
			BRA X_XYCoordinates_Menu_DisplayHigherCoordinates
			
			X_XYCoordinates_Menu_DisplayLowerCoordinates:
			LDA #$27 ;Y coordinates
			STA $08
			BRA X_XYCoordinates_Menu_XCoordinate
			
			X_XYCoordinates_Menu_DisplayHigherCoordinates:
			LDA #$2F ;Y coordinates
			STA $08
			
			X_XYCoordinates_Menu_XCoordinate:
			LDA #$D0 ;X coordinates
			STA $05
			RTS
		
		Zero_XYCoordinates_Menu:
			LDA !IntroductionLevelBIT_1FD3
			BIT #$01
			BEQ Zero_XYCoordinates_Menu_DisplayHigherCoordinates
			LDA !ZSaberObtained_1FB2
			BIT #$01
			BEQ Zero_XYCoordinates_Menu_DisplayLowerCoordinates
			BRA Zero_XYCoordinates_Menu_DisplayHigherCoordinates
			
			Zero_XYCoordinates_Menu_DisplayLowerCoordinates:
			LDA #$26 ;Y coordinates
			STA $08
			BRA X_XYCoordinates_Menu_XCoordinate
			
			Zero_XYCoordinates_Menu_DisplayHigherCoordinates:
			LDA #$2E ;Y coordinates
			STA $08
			
			Zero_XYCoordinates_Menu_XCoordinate:
			LDA #$D0 ;X coordinates
			STA $05
			RTS
		
		PC3_XYCoordinates_Menu:
			LDA #$D0 ;X coordinates
			STA $05
			LDA #$27 ;Y coordinates
			STA $08
			RTS
		
		PC4_XYCoordinates_Menu:
			LDA #$D0 ;X coordinates
			STA $05
			LDA #$27 ;Y coordinates
			STA $08
			RTS
}



;*********************************************************************************
; Sets sub-tank data to RAM upon collection
;*********************************************************************************
LoadSubTank: ;Routine that loads the PC and their sub-tanks from RAM to check if they have it or not.
{
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE LoadSubTank_PCSolo
	LDA !SubTanksOrigin_1FB7,x
	RTL
	
	LoadSubTank_PCSolo:
	STX $0000 ;Store which sub-tank RAM value to temp. variable $0000
	LDA !CurrentPC_0A8E ;Load current PC you are playing as
	ASL #3 ;Triple value
	STA $0002 ;Store to temp. variable $0000
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0002 ;Add original value stored in temp. variable $0000
	CLC ;Clear carry flag
	ADC $0000 ;Load which sub-tank RAM value from temp. variable $0000
	TAX ;Transfer to X
	
	LDA !XSubTank_7EF400,x ;Load current sub-tank
	LDX $0000 ;Load which sub-tank RAM value from temp. variable $0000 to X
	PHA ;Push A
	PLA ;Pull A
	RTL
}
	
StoreSubTank: ;Routine that stores the sub-tank PC has collected into RAM.
{
	PHA
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE StoreSubTanks_PCSolo
	PLA
	STA !SubTanksOrigin_1FB7,x
	RTL
	
	StoreSubTanks_PCSolo:
	LDA !CurrentPC_0A8E ;Load current PC you are playing as
	ASL #3 ;Triple value
	STA $0002 ;Store to temp. variable $0000
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0002 ;Add original value stored in temp. variable $0000
	
	CLC ;Clear carry flag
	ADC $0000 ;Load temp. variable $0000
	TAX ;Transfer A to X
	PLA ;Pull A
	STA !XSubTank_7EF400,x
	RTL
}
	
CollectSubTank: ;Routine that sets the collection value of sub-tanks for PC.
{
	PHX
	STA $0000 ;Store total sub-tank collection value currently to temp. variable $0000
	LDA !CurrentPC_0A8E ;Load current PC you are playing as
	ASL #3 ;Triple value
	STA $0002 ;Store to temp. variable $0000
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0002 ;Add original value stored in temp. variable $0000
	
	TAX ;Transfer current PC RAM value to use to X
	LDA !XSubTankCollect_7EF41D,x ;Load sub-tank collection for PC
	STA $0002 ;Store total PC sub-tank collection value to temp. variable $0002
	LDA $0000 ;Load total sub-tank collection value currently from temp. variable $0000
	CLC
	ADC $0002 ;Combine with total PC sub-tank collection value from temp. variable $0002
	STA !XSubTankCollect_7EF41D,x ;Store to sub-tank collection for PC
	PLX
	RTL
}	
	
;*********************************************************************************
; Load sub-tanks up properly in Main Menu for multiple PCs. This is based on difficulty!
; Normal = Display sub-tanks all PC's have collected by adding all values up!
; Hard or above = Display only the sub-tanks CURRENT PC has collected!
;*********************************************************************************
DrawSubTank: ;Routine to draw sub-tanks onto menu
{
subtankstart:
	LDA !Difficulty_7EF4E0 ;Load current difficulty
	BIT #$01
	BNE Solosubtank ;If difficulty > 00 (Normal), then load routine to only load CURRENT PC's sub-tanks.
	LDA !SubTanksOrigin_1FB7,x
	BPL DrawSubTankEnd
	
	DrawSubTankCommon:
	AND #$0F
	TAY
	CMP #$0F
	BCC SkipSetSubTankAs0E
	LDY #$0E
	
	SkipSetSubTankAs0E:
	LDX $0002
	TXA
	ASL
	CLC
	ADC #$16
	CMP $0A
	BNE SkipSetSubTankLight
	LDA #$2C
	BRA DrawSubTankOnScreen
	
	SkipSetSubTankLight:
	LDA #$38
	
	DrawSubTankOnScreen:
	JSL $80D4AF
	
	DrawSubTankEnd:
	RTL
	
	Solosubtank:
	LDA !CurrentPC_0A8E ;Load current PC you are playing as
	ASL #3 ;Triple value
	STA $0004 ;Store to temp. variable $0010
	ASL A ;Double value
	CLC ;Clear carry flag
	ADC $0004 ;Add current PC RAM location from temp. variable $0010
	CLC
	ADC $0002
	TAX
	LDA !XSubTank_7EF400,x ;Load PC's sub-tank
	BPL DrawSubTankEnd
	BRA DrawSubTankCommon
}

SelectSubTankMenu: ;Routine to check which sub-tank PC is moving to.
{
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE soloPCsubtank
	LDA !SubTanksOrigin_1FB7
	RTL
	
	soloPCsubtank:
	LDA !CurrentPC_0A8E
	ASL #3
	STA $0000
	ASL A
	CLC
	ADC $0000
	TAX
	LDA !XSubTank_7EF400,x
	PHA
	LDX $0002
	PLA
	RTL
}

SelectCheckSubTank: ;Checking what sub-tank you're on when it's highlighted.
{
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE SoloSelectSubTank
	LDA !SubTanksOrigin_1FB7,x
	AND #$0F
	TAY
	RTL
	
	SoloSelectSubTank:
	STX $0002
	LDA !CurrentPC_0A8E
	ASL #3
	STA $0000
	ASL A
	CLC
	ADC $0000
	CLC
	ADC $0002
	TAX
	LDA !XSubTank_7EF400,x
	LDX $0002
	PHA
	PLA
	AND #$0F
	TAY
	RTL
}

SelectNextSubTank: ;Routine to check which sub-tank when pressing a directional key to determine if where you're moving has the sub-tank or not.
{
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE SoloSelectNextSubTank
	LDA !SubTanksOrigin_1FB7,x
	RTL
	
	SoloSelectNextSubTank:
	STX $0002
	LDA !CurrentPC_0A8E
	ASL #3
	STA $0000
	ASL A
	CLC
	ADC $0000
	CLC
	ADC $0002
	TAX
	LDA !XSubTank_7EF400,x
	LDX $0002
	PHA
	PLA
	RTL
}

CheckPCMaxHealth: ;Routine to check PC's Max Health when recovering HP using a sub-tank.
{
	PHX
	LDA !CurrentPC_0A8E
	ASL #3
	STA $0002
	ASL A
	CLC
	ADC $0002
	TAX
	LDA !XMaxHealth_7EF41B,x
	STA $0002
	PLX
	LDA !CurrentHealth_09FF
	CMP $0002
	RTL
}

UsingSubTank: ;Routine to check what sub-tank you're using while the sub-tank is in use to restore HP.
{
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE LoadSoloSubTank
	LDA !SubTanksOrigin_1FB7,x
	AND #$1F
	RTL
	
	LoadSoloSubTank:
	STX $0004
	LDA !CurrentPC_0A8E
	ASL #3
	STA $0002
	ASL A
	CLC
	ADC $0002
	CLC
	ADC $0004
	STA $0002
	TAX
	LDA !XSubTank_7EF400,x
	LDX $0004
	PHA
	PLA
	AND #$1F
	RTL
}
	
SubTankDecrease: ;Routine to decrease sub-tank health upon use
{
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE SoloDecreaseSubTank
	LDX $2C
	DEC !SubTanksOrigin_1FB7,x
	RTL
	
	SoloDecreaseSubTank:
	LDA !CurrentPC_0A8E
	ASL #3
	STA $0002
	ASL A
	CLC
	ADC $0002
	CLC
	ADC $2C
	TAX
	LDA !XSubTank_7EF400,x
	DEC
	STA !XSubTank_7EF400,x
	RTL
	
}


;*********************************************************************************
; Filling sub-tank when collecting HP capsules and you have full life
;*********************************************************************************
SelectSubTank: ;Routine that determines which sub-tank to fill up based on PC.
{
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE SoloSelectSubTank2
	LDA !SubTanksOrigin_1FB7,x
	RTL
	
	SoloSelectSubTank2:
	STX $0005
	LDA !CurrentPC_0A8E
	ASL #3
	STA $0003
	ASL A
	CLC
	ADC $0003
	CLC
	ADC $0005
	TAX
	LDA !XSubTank_7EF400,x
	LDX $0005
	PHA
	PLA
	RTL
}

StoreToSubTank: ;Routine that stores health to sub-tank upon health capsule collect.
{
	PHA
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE SoloSelectSubTank3
	PLA
	STA !SubTanksOrigin_1FB7,x
	RTL
	
	SoloSelectSubTank3:
	STX $0005
	LDA !CurrentPC_0A8E
	ASL #3
	STA $0003
	ASL A
	CLC
	ADC $0003
	CLC
	ADC $0005
	TAX
	PLA
	STA !XSubTank_7EF400,x
	LDX $0005
	PHA
	PLA
	RTL
}

SetLifeAndSwapHealth:
{
	JSL HeartTank
	JSL StoreMaxSwapHealth
	RTL
}

;*********************************************************************************
; Setting sub-weapon projectile X/Y coordinates with PC's
;*********************************************************************************
PCSingleByteSubWeapSetup: ;Routine to get each PC's single-byte sub-weapon data to get their X/Y coordinates.
{
	STX $0010
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCSingleByteSubWeaponPointers,x)
	RTL

	PCSingleByteSubWeaponPointers:
		dw X_SingleByteSubWeapon
		dw Zero_SingleByteSubWeapon
		dw PC3_SingleByteSubWeapon
		dw PC4_SingleByteSubWeapon
		db $FF,$FF
		db $FF,$FF


	X_SingleByteSubWeapon:
		REP #$30
		LDX $0010
		LDA XSubWeapSingleByte,x
		RTS
	
	Zero_SingleByteSubWeapon:
		REP #$30
		LDX $0010
		LDA ZeroSubWeapSingleByte,x
		RTS
	
	PC3_SingleByteSubWeapon:
		REP #$30
		LDX $0010
		LDA PC3SubWeapSingleByte,x
		RTS
	
	PC4_SingleByteSubWeapon:
		REP #$30
		LDX $0010
		LDA PC4SubWeapSingleByte,x
		RTS
}
	
PCSubWeapXCoordSetup: ;Routine to get each PC's sub-weapon 'X' coordinate.
{
	STX $0010
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCSubWeapXCoordSetupPointers,x)
	RTL

	PCSubWeapXCoordSetupPointers:
		dw X_SubWeapXCoordSetup
		dw Zero_SubWeapXCoordSetup
		dw PC3_SubWeapXCoordSetup
		dw PC4_SubWeapXCoordSetup
		db $FF,$FF
		db $FF,$FF


	X_SubWeapXCoordSetup:
		REP #$30
		LDX $0010
		LDA XSubWeapXCoord,x
		RTS
	
	Zero_SubWeapXCoordSetup:
		REP #$30
		LDX $0010
		LDA ZeroSubWeapXCoord,x
		RTS
	
	PC3_SubWeapXCoordSetup:
		REP #$30
		LDX $0010
		LDA PC3SubWeapXCoord,x
		RTS
	
	PC4_SubWeapXCoordSetup:
		REP #$30
		LDX $0010
		LDA PC4SubWeapXCoord,x
		RTS
}

PCSubWeapYCoordSetup: ;Routine to get each PC's sub-weapon 'Y' coordinate. It uses the original 'X' coordinate data then +1 on 'X' to get the proper location.
{
	STX $0010
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCSubWeapYCoordSetupPointers,x)
	RTL

	PCSubWeapYCoordSetupPointers:
		dw X_SubWeapYCoordSetup
		dw Zero_SubWeapYCoordSetup
		dw PC3_SubWeapYCoordSetup
		dw PC4_SubWeapYCoordSetup
		db $FF,$FF
		db $FF,$FF


	X_SubWeapYCoordSetup:
		REP #$30
		LDX $0010
		INX
		LDA XSubWeapXCoord,x
		RTS
	
	Zero_SubWeapYCoordSetup:
		REP #$30
		LDX $0010
		INX
		LDA ZeroSubWeapXCoord,x
		RTS
	
	PC3_SubWeapYCoordSetup:
		REP #$30
		LDX $0010
		INX
		LDA PC3SubWeapXCoord,x
		RTS
	
	PC4_SubWeapYCoordSetup:
		REP #$30
		LDX $0010
		INX
		LDA PC4SubWeapXCoord,x
		RTS
}

PCSingleByteDrillSetup: ;Routine to get each PC's single-byte Tornado Fang data to get their drill X/Y coordinates.
{
	STX $0010
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCDrillSingleBytePointers,x)
	RTL

	PCDrillSingleBytePointers:
		dw X_DrillSingleByteSetup
		dw Zero_DrillSingleByteSetup
		dw PC3_DrillSingleByteSetup
		dw PC4_DrillSingleByteSetup
		db $FF,$FF
		db $FF,$FF


	X_DrillSingleByteSetup:
		REP #$30
		LDX $0010
		LDA XDrillSingleBye,x
		RTS
	
	Zero_DrillSingleByteSetup:
		REP #$30
		LDX $0010
		LDA ZeroDrillSingleByte,x
		RTS
	
	PC3_DrillSingleByteSetup:
		REP #$30
		LDX $0010
		LDA PC3DrillSingleByte,x
		RTS
	
	PC4_DrillSingleByteSetup:
		REP #$30
		LDX $0010
		LDA PC4DrillSingleByte,x
		RTS
}
	
PCDrillYCoordSetup: ;Routine to get each PC's Tornado Fang 'Y' coordinate.
{
	STX $0010
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCDrillYCoordSetupPointers,x)
	RTL

	PCDrillYCoordSetupPointers:
		dw X_DrillYCoordSetup
		dw Zero_DrillYCoordSetup
		dw PC3_DrillYCoordSetup
		dw PC4_DrillYCoordSetup
		db $FF,$FF
		db $FF,$FF
	
	X_DrillYCoordSetup:
		REP #$30
		LDX $0010
		LDA XDrillYCoord,x
		RTS
	
	Zero_DrillYCoordSetup:
		REP #$30
		LDX $0010
		LDA ZeroDrillYCoord,x
		RTS
	
	PC3_DrillYCoordSetup:
		REP #$30
		LDX $0010
		LDA PC3DrillYCoord,x
		RTS
	
	PC4_DrillYCoordSetup:
		REP #$30
		LDX $0010
		LDA PC4DrillYCoord,x
		RTS
}
	
PCDrillXCoordSetup: ;Routine to get each PC's Tornado Fang 'X' coordinate data then +1 on 'X' to get the proper location.
{
	STX $0010
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCDrillXCoordSetupPointers,x)
	RTL

	PCDrillXCoordSetupPointers:
		dw X_DrillXCoordSetup
		dw Zero_DrillXCoordSetup
		dw PC3_DrillXCoordSetup
		dw PC4_DrillXCoordSetup
		db $FF,$FF
		db $FF,$FF
	
	
	X_DrillXCoordSetup:
		REP #$30
		LDX $0010
		INX
		LDA XDrillYCoord,x
		RTS
	
	Zero_DrillXCoordSetup:
		REP #$30
		LDX $0010
		INX
		LDA ZeroDrillYCoord,x
		RTS
	
	PC3_DrillXCoordSetup:
		REP #$30
		LDX $0010
		INX
		LDA PC3DrillYCoord,x
		RTS
	
	PC4_DrillXCoordSetup:
		REP #$30
		LDX $0010
		INX
		LDA PC4DrillYCoord,x
		RTS
}

PCDrillAnimationSetup: ;Routine to get each PC's Tornado Fang 'Animation' byte then +2 on 'X' to get the proper location so it displays properly.
{
	SEP #$30
	STX $0010
	LDX !CurrentPC_0A8E
	JSR (PCDrillAnimationPointers,x)
	RTL

	PCDrillAnimationPointers:
		dw X_DrillAnimationSetup
		dw Zero_DrillYCoordSetup
		dw PC3_DrillYCoordSetup
		dw PC4_DrillYCoordSetup
		db $FF,$FF
		db $FF,$FF
	
	
	X_DrillAnimationSetup:
		LDX $0010
		INX
		LDA XDrillYCoord,x
		RTS
		
	Zero_DrillAnimationSetup:
		LDX $0010
		INX
		LDA ZeroDrillYCoord,x
		RTS
	
	PC3_DrillAnimationSetup:
		LDX $0010
		INX
		LDA PC3DrillYCoord,x
		RTS
	
	PC4_DrillAnimationSetup:
		LDX $0010
		INX
		LDA PC4DrillYCoord,x
		RTS
}

PC_ResetSubWeapons: ;Routine to reset PC's sub-weapon graphical data during cutscene events (Maybe other in-game things too)
{
	SEP #$30
	LDA !CurrentPCSubWeapon_0A0B
	ASL
	RTL
}

;*********************************************************************************
; Load routine to determine if Hyper Charge can be used
;*********************************************************************************
PCHyperChargeUse: ;Routine to determine if PCs can use Hyper Charge or not.
{
	SEP #$20
	STX $0010
	LDX !CurrentPC_0A8E
	JSR (PCHyperChargeUsePointers,x)
	RTL

	PCHyperChargeUsePointers:
		dw X_HyperChargeUse
		dw Zero_HyperChargeUse
		dw PC3_HyperChargeUse
		dw PC4_HyperChargeUse
		db $FF,$FF
		db $FF,$FF
		
		
	X_HyperChargeUse: ;Makes it so X CAN use Hyper Charge
		LDX $0010
		JSL LoadPCSplitSubWeapon
		AND #$7F
		RTS
		
	Zero_HyperChargeUse: ;Makes it so Zero CANNOT use Hyper Charge
		LDX $0010
		STZ $0A
		LDA $0A
		RTS
	
	PC3_HyperChargeUse: ;Makes it so PC3 CANNOT use Hyper Charge
		LDX $0010
		STZ $0A
		LDA $0A
		RTS
	
	PC4_HyperChargeUse: ;Makes it so PC4 CANNOT use Hyper Charge
		LDX $0010
		STZ $0A
		LDA $0A
		RTS
}

CheckForHyperChargeData: ;Routine that specific checks for Hyper Charge in PC sub-weapons list.
{
	LDA !CurrentPCSubWeapon_0A0B
	CMP #$09
	BEQ CheckHyperCharge
	RTL
	
	CheckHyperCharge:
	TAX
	JSL LoadPCSplitSubWeapon
	CMP #$1D
	BCS OtherHyperChargeChecks
	CMP #$04
	BCC OtherHyperChargeChecks
	RTL
	
	OtherHyperChargeChecks:
	LDA !CurrentPCAction_09DA
	CMP #$4C ;Check if PC is doing 2nd buster fire shot on ground
	BEQ Store02ToPreventFiring
	CMP #$50 ;Check if PC is doing 2nd buster fire shot in air
	BEQ Store02ToPreventFiring
	RTL
	
	Store02ToPreventFiring:
	LDA #$FE
	STA $0A68
	LDA #$00
	STA $0A5F
	RTL
	
	SetHyperChargeOff:
	STZ $8E ;Blank out level 4 charge set
	STZ $8F ;Blank out level 5 charge set
	STZ $B7 ;Blank out Z-Saber charge
	STZ $57 ;Blank out Charge Time
	STZ $58 ;Blank out current buster charge
	STZ $5A ;Disable Hyper Charge Bubbles
	STZ $5B ;Disable Flashing for PC
	STZ $82
	STZ $AC ;Disable Hyper Charge Bubbles
	RTL
}

PC_SplitLSubWeaponSet: ;Routine that specifies what sub-weapon to go to when you're pressing 'L', on sub-weapon #$00.
{
	LDX !CurrentPC_0A8E
	JSR (PC_SplitLSubWeaponSetPointers,x)
	RTL

	PC_SplitLSubWeaponSetPointers:
		dw X_SplitLSubWeaponSet
		dw Zero_SplitLSubWeaponSet
		dw PC3_SplitLSubWeaponSet
		dw PC4_SplitLSubWeaponSet
		db $FF,$FF
		db $FF,$FF
		
		
	X_SplitLSubWeaponSet:
		LDA #$09 ;Final sub-weapon that can be loaded value
		STA !CurrentPCSubWeaponShort_33 ;Store to !CurrentPCSubWeapon_0A0B
		RTS
		
	Zero_SplitLSubWeaponSet:
		LDA #$08 ;Final sub-weapon that can be loaded value
		STA !CurrentPCSubWeaponShort_33 ;Store to !CurrentPCSubWeapon_0A0B
		RTS
		
	PC3_SplitLSubWeaponSet:
		LDA #$08 ;Final sub-weapon that can be loaded value
		STA !CurrentPCSubWeaponShort_33 ;Store to !CurrentPCSubWeapon_0A0B
		RTS
		
	PC4_SplitLSubWeaponSet:
		LDA #$08 ;Final sub-weapon that can be loaded value
		STA !CurrentPCSubWeaponShort_33 ;Store to !CurrentPCSubWeapon_0A0B
		RTS
}

PC_SplitRSubWeaponSet: ;Routine that specifies what sub-weapon to go to when you're pressing 'R'
{
	LDX !CurrentPC_0A8E
	JSR (PC_SplitRSubWeaponSetPointers,x)
	RTL

	PC_SplitRSubWeaponSetPointers:
		dw X_SplitRSubWeaponSet
		dw Zero_SplitRSubWeaponSet
		dw PC3_SplitRSubWeaponSet
		dw PC4_SplitRSubWeaponSet
		db $FF,$FF
		db $FF,$FF
		
		
	X_SplitRSubWeaponSet:
		LDA !CurrentPCSubWeaponShort_33 ;Load !CurrentPCSubWeapon_0A0B
		CMP #$09 ;Check if last sub-weapon
		RTS
		
	Zero_SplitRSubWeaponSet:
		LDA !CurrentPCSubWeaponShort_33 ;Load !CurrentPCSubWeapon_0A0B
		CMP #$08 ;Check if last sub-weapon
		RTS
		
	PC3_SplitRSubWeaponSet:
		LDA !CurrentPCSubWeaponShort_33 ;Load !CurrentPCSubWeapon_0A0B
		CMP #$08 ;Check if last sub-weapon
		RTS
		
	PC4_SplitRSubWeaponSet:
		LDA !CurrentPCSubWeaponShort_33 ;Load !CurrentPCSubWeapon_0A0B
		CMP #$08 ;Check if last sub-weapon
		RTS
}

PC_SelectSubWeaponDown_Menu: ;Routine that specifies what sub-weapon to go to when you're moving 'Down' in main menu
{
	INX
	STX $0010
	LDX !CurrentPC_0A8E
	JSR (PC_SelectSubWeaponDown_MenuPointers,x)
	RTL

	PC_SelectSubWeaponDown_MenuPointers:
		dw X_SelectSubWeaponDown_Menu
		dw Zero_SelectSubWeaponDown_Menu
		dw PC3_SelectSubWeaponDown_Menu
		dw PC4_SelectSubWeaponDown_Menu
		db $FF,$FF
		db $FF,$FF
		
		
	X_SelectSubWeaponDown_Menu:
		LDX $0010
		CPX #$0A ;Check if last sub-weapon
		RTS
		
	Zero_SelectSubWeaponDown_Menu:
		LDX $0010
		CPX #$09 ;Check if last sub-weapon
		RTS
		
	PC3_SelectSubWeaponDown_Menu:
		LDX $0010
		CPX #$09 ;Check if last sub-weapon
		RTS
		
	PC4_SelectSubWeaponDown_Menu:
		LDX $0010
		CPX #$09 ;Check if last sub-weapon
		RTS
}

PC_SelectSubWeaponUp_Menu: ;Routine that specifies what sub-weapon to go to when you're moving 'Up' in main menu
{
	STX $0010
	LDX !CurrentPC_0A8E
	JSR (PC_SelectSubWeaponUp_MenuPointers,x)
	RTL

	PC_SelectSubWeaponUp_MenuPointers:
		dw X_SelectSubWeaponUp_Menu
		dw Zero_SelectSubWeaponUp_Menu
		dw PC3_SelectSubWeaponUp_Menu
		dw PC4_SelectSubWeaponUp_Menu
		db $FF,$FF
		db $FF,$FF
		
		
	X_SelectSubWeaponUp_Menu:
		LDX $0010
		DEX
		BPL X_SelectSubWeaponUp_Menu_NotLastSubWeapon
		LDX #$09 ;Check if last sub-weapon
		
		X_SelectSubWeaponUp_Menu_NotLastSubWeapon:
		CPX $0A
		RTS
		
	Zero_SelectSubWeaponUp_Menu:
		LDX $0010
		DEX
		BPL Zero_SelectSubWeaponUp_Menu_NotLastSubWeapon
		LDX #$08 ;Check if last sub-weapon
		
		Zero_SelectSubWeaponUp_Menu_NotLastSubWeapon:
		CPX $0A
		RTS
		
	PC3_SelectSubWeaponUp_Menu:
		LDX $0010
		DEX
		BPL Zero_SelectSubWeaponUp_Menu_NotLastSubWeapon
		LDX #$08 ;Check if last sub-weapon
		
		PC3_SelectSubWeaponUp_Menu_NotLastSubWeapon:
		CPX $0A
		RTS
		
	PC4_SelectSubWeaponUp_Menu:
		LDX $0010
		DEX
		BPL Zero_SelectSubWeaponUp_Menu_NotLastSubWeapon
		LDX #$08 ;Check if last sub-weapon
		
		PC4_SelectSubWeaponUp_Menu_NotLastSubWeapon:
		CPX $0A
		RTS
}


;*********************************************************************************
; Various sub-weapon changes
;*********************************************************************************
ParasiticBomb_Charged: ;This has to be here due to it being a JSL into a new code location
{
	LDA $1FBC ;Load hard set Parasitic Bomb life
	AND #$1F
	;CMP #$02 ;Check if value is #$02
	RTL
}

;*********************************************************************************
; Loads helmet sensor and determines who can use it
;*********************************************************************************
PCHelmetSensor: ;Routine to determine who could use the Helmet Sensor upon entering a level.
{
	LDX !CurrentPC_0A8E
	JSR (PCHelmetSensorPointers,x)
	RTL

	PCHelmetSensorPointers:
		dw X_HelmetSensor
		dw Zero_HelmetSensor
		dw PC3_HelmetSensor
		dw PC4_HelmetSensor
		db $FF,$FF
		db $FF,$FF
	
	
	X_HelmetSensor: ;Need to recode this since you don't need all upgrades to obtain the Golden Armor
		; LDA !RideChipsOrigin_7E1FD7
		; CMP #$F0
		; BCS DisableHelmetSensor
		LDA !XArmorsByte1_7EF418
		BIT #$01 ;Checks for "Helmet" upgrade
		BEQ DisableHelmetSensor
		
			AND #$0F
			CMP #$0F ;Checks if ALL armor upgrades are set.
			BCC X_HelmetSensor_End
				
				LDA !XHeartTank_7EF41C
				ORA !ZeroHeartTank_7EF44C
				ORA !PC3HeartTank_7EF47C
				ORA !PC4HeartTank_7EF4AC
				CMP #$FF ;Checks for ALL heart tanks collected.
				BNE X_HelmetSensor_End
				
					LDA !XSubTankCollect_7EF41D
					ORA !ZeroSubTankCollect_7EF44D
					ORA !PC3SubTankCollect_7EF47D
					ORA !PC4SubTankCollect_7EF4AD
					CMP #$F0
					BCC X_HelmetSensor_End
					
						LDA !RideChipsOrigin_7E1FD7
						CMP #$0F
						BCC X_HelmetSensor_End
							BRA DisableHelmetSensor
		
		X_HelmetSensor_End:
		LDA #$01 ;Enable
		RTS
		
		DisableHelmetSensor:
		LDA #$00 ;Disable
		RTS
		
	Zero_HelmetSensor:
		LDA #$00 ;Load blank value so helmet sensor never goes off.
		RTS
		
	PC3_HelmetSensor:
		LDA #$00 ;Load blank value so helmet sensor never goes off.
		RTS
		
	PC4_HelmetSensor:
		LDA #$00 ;Load blank value so helmet sensor never goes off.
		RTS
}

;*********************************************************************************
; Loads helmet chip upgrade and determines who can use it (Regenerates life)
;*********************************************************************************
PCHelmetChip: ;Routine to determine which PC can use Helmet Chip Enhancement life regeneration
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCHelmetChipEnhancementPointers,x)
	RTL

	PCHelmetChipEnhancementPointers:
		dw X_HelmetChipEnhancement
		dw Zero_HelmetChipEnhancement
		dw PC3_HelmetChipEnhancement
		dw PC4_HelmetChipEnhancement
		db $FF,$FF
		db $FF,$FF
	
	
	X_HelmetChipEnhancement:
		LDA !RideChipsOrigin_7E1FD7 ;Load !RideChipsOrigin_7E1FD7
		BIT #$10 ;Bit with #$10 which determines if you have the Helmet Chip or not
		RTS
		
	Zero_HelmetChipEnhancement: ;Zero CANNOT use Helmet Chip Enhancement
		LDA #$00 ;Loads blank value so PC CANNOT use helmet chip
		RTS
		
	PC3_HelmetChipEnhancement: ;PC #3 CANNOT use Helmet Chip Enhancement
		LDA #$00 ;Loads blank value so PC CANNOT use helmet chip
		RTS
		
	PC4_HelmetChipEnhancement: ;PC #4 CANNOT use Helmet Chip Enhancement
		LDA #$00 ;Loads blank value so PC CANNOT use helmet chip
		RTS
}

;*********************************************************************************
; Loads body armor upgrade and determines who can use it (Cuts damage in half and generates a force field originally. Force field is removed!)
;*********************************************************************************
PCBodyArmor: ;Routine to determine who can use the Armor Upgrade to cut damage in half.
{
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCBodyArmorPointers,x)
	RTL

	PCBodyArmorPointers:
		dw X_BodyArmor
		dw Zero_BodyArmor
		dw PC3_BodyArmor
		dw PC4_BodyArmor
		db $FF,$FF
		db $FF,$FF
	
	
	X_BodyArmor:
		LDA !XArmorsByte1_7EF418
		BIT #$04
		RTS
		
	Zero_BodyArmor:
		LDA !RideChipsOrigin_7E1FD7 ;Check's if Zero has the Black Armor to use the 50% damage reduction.
		AND #$F0
		CMP #$F0
		BEQ load01
		LDA #$00 ;Loads blank value so Zero cannot use the 50% damage reduction
		BRA endbodyarmor
load01:
		LDA #$01 ;Loads #$01 so Zero can use the 50% damage reduction
endbodyarmor:
		RTS
		
	PC3_BodyArmor:
		LDA #$00 ;Loads blank value so PC cannot use the 50% damage reduction
		RTS
		
	PC4_BodyArmor:
		LDA #$00 ;Loads blank value so PC cannot use the 50% damage reduction
		RTS
}

PCBodyChip: ;Routine that determines who can use the Armor Chip upgrade to cut damage to 75%.
{
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCBodyChipPointers,x)
	RTL

	PCBodyChipPointers:
		dw X_BodyChip
		dw Zero_BodyChip
		dw PC3_BodyChip
		dw PC4_BodyChip
		db $FF,$FF
		db $FF,$FF
	
	
	X_BodyChip:
		LDA !RideChipsOrigin_7E1FD7
		BIT #$40
		RTS
		
	Zero_BodyChip:
		LDA #$00 ;Loads #$01 so Zero cannot use the 75% damage reduction
		RTS
		
	PC3_BodyChip:
		LDA #$00 ;Loads blank value so PC cannot use the 75% damage reduction
		RTS
		
	PC4_BodyChip:
		LDA #$00 ;Loads blank value so PC cannot use the 75% damage reduction
		RTS
}

PC_DamageReset_SetJumpValues: ;This routine only initiates when you're on the ground
{
	LDA #$09
	JSL !PlaySFX
	JSL SetJumpValues
	RTL
}

;*********************************************************************************
; Loads buster upgrade and determines who can use it (Cuts sub-weapon ammo usage in half)
;*********************************************************************************
PCBusterUpgrade: ;Routine to determine which PC can use halved sub-weapon ammo or not.
{
	SEP #$20
	STX $0010
	LDX !CurrentPC_0A8E
	JSR (PCBusterUpgradePointers,x)
	RTL

	PCBusterUpgradePointers:
		dw X_BusterUpgrade
		dw Zero_BusterUpgrade
		dw PC3_BusterUpgrade
		dw PC4_BusterUpgrade
		db $FF,$FF
		db $FF,$FF
	
	
	X_BusterUpgrade:
		LDX $0010 ;Load temp. variable of $0010 to get current sub-weapon
		JSL LoadPCSplitSubWeapon ;Load routine that determines which PC RAM location to draw current sub-weapon ammo from
		STA $0010 ;Store current sub-weapon ammo to temp. variable $0010
		;CPX #$09 ;Check if sub-weapon is #$09 (Hyper Charge) [CODE MAY BE COMPLETELY POINTLESS]
		;BEQ LSROnly ;If so, jump to LSROnly and cut in half since it's a even number [CODE MAY BE COMPLETELY POINTLESS]
		LDA !XArmorsByte1_7EF418 ;Load X's Armor Value from new RAM
		AND #$01 ;AND #$01
		CMP #$01 ;Check if value is #$01 (Helmet Upgrade)
		BNE ignorecutinhalf ;If not, jump to ignorecutinhalf so sub-weapon ammo usage is not halved.
		LDA $0002 ;Load sub-weapon ammo usage from temp. variable $0002
		AND #$01 ;AND #$01
		BEQ LSROnly ;If == 00, jump to LSROnly to cut sub-weapon ammo usage in half if it's an even number.
		LSR $0002 ;Cut sub-weapon ammo usage in half
		LDA $0010 ;Load current PC sub-weapon ammo
		BIT #$40 ;Check if it's #$40
		BNE subweaponcutinhalf ;If it's not #$40, jump to subweaponcutinhalf and cut the sub-weapon life
		INC $0002 ;Increaes sub-weapon ammo usage
		ORA #$40 ;ORA with #$40 so it adds #$40 to original ammo usage
storesubweaponlife:
		STA $0010 ;Store new sub-weapon life back to temp. variable $0010
		BRA ignorecutinhalf ;Always jump to ignorecutinhalf
subweaponcutinhalf:
		AND #$1F ;AND #$1F current sub-weapon ammo
		BRA storesubweaponlife ;Always jump to storesubweaponlife
ignorecutinhalf:
		LDA $0010 ;Load current sub-weapon ammo as here it does not get halved.
		RTS
LSROnly:
		LSR $0002 ;Load sub-weapon ammo usage and halve the value
		BRA ignorecutinhalf ;Always jump to ignorecutinhalf
		
	Zero_BusterUpgrade: ;Zero's sub-weapon ammo usage is DOUBLED unless he has the Black Armor, then it loads the normal values.
		LDX $0010
		LDA !RideChipsOrigin_7E1FD7 ;Load !RideChipsOrigin_7E1FD7
		AND #$F0 ;AND #$F0
		CMP #$F0 ;Check if value is #$F0
		BEQ Zero_BusterUpgrade_NoDouble ;If value = #$F0 then jump to Zero_BusterUpgrade_NoDouble so sub-weapon ammo consumption is not doubled.
		
		ASL $0002 ;Double sub-weapon ammo usage for Zero
		
		Zero_BusterUpgrade_NoDouble:
		JSL LoadPCSplitSubWeapon
		RTS
		
	PC3_BusterUpgrade:
		LDX $0010
		JSL LoadPCSplitSubWeapon
		RTS
		
	PC4_BusterUpgrade:
		LDX $0010
		JSL LoadPCSplitSubWeapon
		RTS
}


;*********************************************************************************
; Loads leg upgrade and determines who can use it and the circumstance
; Loads code to determine what each character does for the Vertical Dash animation
;*********************************************************************************
PCLegUpgrade: ;Routine to determine which PC is able to use the Leg Upgrade
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCLegUpgradePointers,x)
	RTL

	PCLegUpgradePointers:
		dw X_LegUpgrade
		dw Zero_LegUpgrade
		dw PC3_LegUpgrade
		dw PC4_LegUpgrade
		db $FF,$FF
		db $FF,$FF
	
	
	X_LegUpgrade:
		LDA !XArmorsByte1_7EF418 ;Load X's new RAM armor value
		BIT #$08 ;BIT #08 so it checks if he has the Leg Upgrade value
		RTS
	
	Zero_LegUpgrade: ;Zero can air dash and double jump at ANY time without the upgrade!
		LDA #$01 ;Loads 01 so Zero can use air dash and double jump at any time.
		RTS
	
	PC3_LegUpgrade: ;PC #3 CANNOT use the upgrade no matter what.
		LDA #$00 ;Loads blank value so PC CANNOT use leg upgrade to air dash, double jump or vertical dash
		RTS
	
	PC4_LegUpgrade: ;PC #3 CANNOT use the upgrade no matter what.
		LDA #$00 ;Loads blank value so PC CANNOT use leg upgrade to air dash, double jump or vertical dash
		RTS
}

PCVerticalDash: ;Routine to determine which PC uses what animation for the Vertical Dash
{
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCVerticalDashAnimationPointers,x)
	RTL

	PCVerticalDashAnimationPointers:
		dw X_VerticalDashAnimation
		dw Zero_VerticalDashAnimation
		dw PC3_VerticalDashAnimation
		dw PC4_VerticalDashAnimation
		db $FF,$FF
		db $FF,$FF
	
	
	X_VerticalDashAnimation:
		SEP #$30
		LDA #$68 ;Load X's vertical dash animation
		RTS
		
	Zero_VerticalDashAnimation:
		SEP #$30
		LDA #$48 ;Load jump animation for Zero
		RTS
		
	PC3_VerticalDashAnimation:
		SEP #$30
		RTS
		
	PC4_VerticalDashAnimation:
		SEP #$30
		RTS
}

;*********************************************************************************
; Sets new jump/dash/air dash code and how many times you can do certain acts in the air
;*********************************************************************************	
PCDoubleJump: ;Routine that checks for specific PC actions and determines when they can vertical dash or double jump.
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCDoubleJumpPointers,x)
	RTL

	PCDoubleJumpPointers:
		dw X_DoubleJump
		dw Zero_DoubleJump
		dw PC3_DoubleJump
		dw PC4_DoubleJump
		db $FF,$FF
		db $FF,$FF
	
	
	X_DoubleJump:
		LDA !CurrentPCAction_09DA ;Load current PC's action
		CMP #$4E ;Check if PC is doing action: 'Left Arm Dual Buster Shot'
		BEQ enddoublejumpX ;If so, jump to enddoublejumpX to end routine
		CMP #$50 ;Check if PC is doing action: 'Right Arm Dual Buster Shot'
		BEQ enddoublejumpX ;If so, jump to enddoublejumpX to end routine
		STZ $29
		LDA #$00
	enddoublejumpX:
		RTS
		
	Zero_DoubleJump:
		LDA !CurrentPCAction_09DA
		CMP #$4E ;Check if PC is doing action: 'Left Arm Dual Buster Shot'
		BEQ enddoublejumpZero ;If so, jump to enddoublejumpZero to end routine
		CMP #$50 ;Check if PC is doing action: 'Right Arm Dual Buster Shot'
		BEQ enddoublejumpZero ;If so, jump to enddoublejumpZero to end routine
		
		LDA $37 ;Load button(s) being pressed from RAM
		BIT #$80 ;What button(s) to press to perform a double jump
		BEQ beforeenddoublejumpZero
		
		LDA !JumpDashAmount_7EF4E6
		BNE skipjumptoendZero
		BRA beforeenddoublejumpZero
		
		skipjumptoendZero:
			LDA #$48 ;Perform a double jump
			STA $02
			STZ $03
			LDA !JumpDashAmount_7EF4E6
			DEC
			STA !JumpDashAmount_7EF4E6
		beforeenddoublejumpZero:
			STZ $29
			LDA #$00
		enddoublejumpZero:
			RTS
		
	PC3_DoubleJump:
		LDA !CurrentPCAction_09DA
		CMP #$4E ;Check if PC is doing action: 'Left Arm Dual Buster Shot'
		BEQ enddoublejumpPC3 ;If so, jump to enddoublejumpPC3 to end routine
		CMP #$50 ;Check if PC is doing action: 'Right Arm Dual Buster Shot'
		BEQ enddoublejumpPC3 ;If so, jump to enddoublejumpPC3 to end routine
		STZ $29
		LDA #$00
enddoublejumpPC3:
		RTS
	
	PC4_DoubleJump:
		LDA !CurrentPCAction_09DA
		CMP #$4E ;Check if PC is doing action: 'Left Arm Dual Buster Shot'
		BEQ enddoublejumpPC4 ;If so, jump to enddoublejumpPC4 to end routine
		CMP #$50 ;Check if PC is doing action: 'Right Arm Dual Buster Shot'
		BEQ enddoublejumpPC4 ;If so, jump to enddoublejumpPC4 to end routine
		STZ $29
		LDA #$00
enddoublejumpPC4:
		RTS
}

DashDecreaseJumpDashAmount: ;Routine that decreases JumpDashAmount_7EF4E6 when dashing then sets dash animation
{
	SEP #$30
	LDA !JumpDashAmount_7EF4E6
	DEC
	BPL DashDecreaseJumpDashAmount_IgnoreStorage
	LDA #$00
	
	DashDecreaseJumpDashAmount_IgnoreStorage:
	STA !JumpDashAmount_7EF4E6
	LDA #$14
	RTL
}
	
WallJumpSpeedDecreaseJump: ;Routine that decreases JumpDashAmount_7EF4E6 when holding the 'A' button then wall jump
{
	SEP #$20
	LDA !JumpDashAmount_7EF4E6
	DEC
	BPL ignoresetjumpto00
	LDA #$00
ignoresetjumpto00:
	STA !JumpDashAmount_7EF4E6
	REP #$20
	LDA #$0375
	STA $5C
	RTL
}

GroundLandSetJump: ;Routine that sets JumpDashAmount_7EF4E6 when landing on ground
{
	LDA #02
	STA $03
	JSL SetJumpValues
	RTL
}

DashFinish_SetJump: ;Routine that sets JumpDashAmount_7EF4E6 when ground dashing is finished.
{
	JSL SetJumpValues
	
	SEP #$30
	LDA #$20
	RTL
}

WallSlide_SetJump: ;Routine that sets JumpDashAmount_7EF4E6 when wall sliding.
{
	JSL SetJumpValues
	
	SEP #$30
	STZ $55
	RTL
}

GetOnLadder_SetJump: ;Routine that sets JumpDashAmount_7EF4E6 when getting on ladder.
{
	JSL SetJumpValues
	
	SEP #$30
	STZ $A7
	RTL
}

GetOffLadder_SetJump: ;Routine that sets JumpDashAmount_7EF4E6 when getting on getting off ladder.
{
	JSL SetJumpValues
	
	SEP #$30
	LDA #$26
	RTL
}

BeginClimbDownLadder_SetJump: ;Routine that sets JumpDashAmount_7EF4E6 when getting on ladder by climbing DOWN.
{
	JSL SetJumpValues
	
	SEP #$30
	LDA #$28
	RTL
}

ClimbingLadder_SetJump: ;Routine that sets JumpDashAmount_7EF4E6 when getting climbing ladder.
{
	JSL SetJumpValues
	
	SEP #$30
	LDA #$2A
	RTL
}

WaterJump_SetJump: ;Routine that sets JumpDashAmount_7EF4E6 when getting jumping on the surface of water.
{
	JSL SetJumpValues
	
	SEP #$30
	LDA #$48
	RTL
}


SetCutScene_SetJump: ;Routine that sets the 'cut scene' value then sets JumpDashAmount_7EF4E6 when any kind of forced movement occurs.
{
	LDA #$E6
	STA $0A7B
	
	JSL SetJumpValues
	RTL
}


SetJumpValues: ;Routine that gets called to set JumpDashAmount_7EF4E6 on various circumstances.
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCSetJumpValuePointers,x)
	RTL

	PCSetJumpValuePointers:
		dw X_SetJumpValue
		dw Zero_SetJumpValue
		dw PC3_SetJumpValue
		dw PC4_SetJumpValue
		db $FF,$FF
		db $FF,$FF
	
	
	X_SetJumpValue:
		LDA !RideChipsOrigin_7E1FD7 ;Load !RideChipsOrigin_7E1FD7
		AND #$80 ;AND #$80 to check if you have the Leg Chip Enhancement
		BNE Store02forJumpX ;If so, jump to Store02forJumpX so X has the ability to maneuver in the air twice
		LDA !XArmorsByte1_7EF418 ;Load X's Armor value from new RAM
		AND #$08 ;Check if X has the leg upgrade
		BNE Store01forJumpX ;If so, jump skipstore00x so X can't maneuver in the air at all.
		LDA #$00 ;Load #$00
		STA !JumpDashAmount_7EF4E6 ;Store to !JumpDashAmount_7EF4E6 so X CANNOT maneuver in the air at all.
		BRA EndSetJumpDashAmountX ;Branch to end of routine checking
		
		Store01forJumpX:
		LDA #$01
		STA !JumpDashAmount_7EF4E6
		BRA EndSetJumpDashAmountX
		
		Store02forJumpX:
		LDA #$02
		STA !JumpDashAmount_7EF4E6
	
		EndSetJumpDashAmountX:
		RTS
	
	Zero_SetJumpValue:
		LDA #$01
		STA !JumpDashAmount_7EF4E6
		RTS
	
	PC3_SetJumpValue:
		LDA #$00
		STA !JumpDashAmount_7EF4E6
		RTS

	PC4_SetJumpValue:
		LDA #$00
		STA !JumpDashAmount_7EF4E6
		RTS
}

VerticalDashButtonCombo: ;Routine that checks the button combo to specify what buttons need to be pressed for the vertical dash for each PC.
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCVerticalDashButtonComboPointers,x)
	RTL

	PCVerticalDashButtonComboPointers:
		dw X_VerticalDashButtonCombo
		dw Zero_VerticalDashButtonCombo
		dw PC3_VerticalDashButtonCombo
		dw PC4_VerticalDashButtonCombo
		db $FF,$FF
		db $FF,$FF
	
	
	X_VerticalDashButtonCombo:
		SEP #$20
		LDA $37
		BIT #$08
		RTS
	
	Zero_VerticalDashButtonCombo:
		SEP #$20
		LDA #$00 ;Loads blank value so PC air dashes with vertical dash button combo.
		RTS
	
	PC3_VerticalDashButtonCombo:
		SEP #$20
		LDA #$00 ;Loads blank value so PC air dashes with vertical dash button combo.
		RTS
	
	PC4_VerticalDashButtonCombo:
		SEP #$20
		LDA #$00 ;Loads blank value so PC air dashes with vertical dash button combo.
		RTS
}

Buster_ResetJumpValue: ;Routine to reset the jump value after a combo buster shot.
{
	LDA #$02
	STA $03
	
	JSL SetJumpValues
	RTL
}
;*********************************************************************************
; Damage table routine
; Entire routine has been heavily updated to check for new values and instances.
; DIFFICULTY BASED
;*********************************************************************************
SimilarDamageRoutine: ;Code shared between Gravity Well and regular damage table setup
{	
	LDA !Difficulty_7EF4E0 ;Check for game difficulty
	AND #$000F ;AND #$00FF to remove the high byte
	ASL A ;Double difficulty value
	TAX ;Transfer value of A to X
	LDA $37 ;Check enemy flashing
	AND #$00FF ;AND #$00FF to remove high byte
	BNE ComboDamageTable ;If > 00, jump to ComboDamageTable to check if weapons can hit sequentially or not.
	LDA DifficultyDamagePointers,x ;Load pointer bases for difficulty damage tables. (Normal, Hard, Xtreme)
	BRA EndDamageTableRoutine
ComboDamageTable:
	LDA DifficultyComboDamagePointers,x ;Load pointer bases for difficulty combo damage tables. (Normal, Hard, Xtreme)
EndDamageTableRoutine:
	CLC
	RTS
}
	
DamageTableSetup: ;Routine that sets up the damage table and allows for 'Combo' hits. (IE: Level 4/Level 5 buster shots both hitting without wait)
{
	REP #$20
	STX $0000
	JSR SimilarDamageRoutine
	
	ADC $0000
	TAX
	LDA $CB0000,x ;Load base bank for damage value
	CLC
	ADC !DamageType_1F2F
	TAX
	RTL
}

DamageTableGravityWellSetup: ;Routine that sets up the damage for Gravity Well so it hits properly.
{
	REP #$20
	STX $0004
	
	LDA !Difficulty_7EF4E0 ;Check for game difficulty
	AND #$000F ;AND #$00FF to remove the high byte
	ASL A ;Double difficulty value
	TAX ;Transfer value of A to X
	LDA DifficultyDamagePointers,x ;Load pointer bases for difficulty damage tables. (Normal, Hard, Xtreme)
	CLC
	ADC $0004
	TAX
	LDA $CB0000,x ;Load base bank for damage value
	CLC
	ADC $0000
	TAX
	RTL
}
	
GeneralDamage_CheckEnemyState: ;New routine that checks for the enemy state specifically.
;The original checked for anything above #$04 then stopped palette increasing. This has been altered to check SPECIFICALLY for #$0A then also check for anything above #$04.
{
	LDA $1F54 ;Loads $7E:1F54 (Enemy state)
	CMP #$0A ;Checks for #$0A (Z-Saber wave hit)
	BEQ GeneralDamage_CheckEnemyState_DoPalette
		CMP #$04 ;Checks for #$04 (Death)
		BPL GeneralDamage_CheckEnemyState_End
	
			GeneralDamage_CheckEnemyState_DoPalette:
			INC $11
			INC $11
			
	GeneralDamage_CheckEnemyState_End:
	RTL
}
CheckZSaberDamage: ;Routine that determines whether the Z-Saber can damage an enemy or not.
;There's a #$00 storage for ZSaberDamageTest in the General Sprites section so it prevents Z-Saber from hitting multiple times)\
{
	PHX
	LDA !DamageType_1F2F ;Load damage type
	CMP #$02 ;Check if damage type is 02 (Z-Saber)
	BEQ CheckZSaberCanUse ;If so, jump to 'CheckZSaberCanUse' to see if Z-Saber is being used on enemies
	BRA EndZSaberNoDamageIncrease
	
CheckZSaberCanUse:
	LDA !ZSaberCheckEnemy_1FCF ;Load current enemy being hit by Z-Saber
	TAX ;Transfer A to X
	LDA !ZSaberEnemyTable_7EF500,x ;Load Z-Saber BIT flag from new enemy table to determine if enemy is being hit by Z-Saber or not
	BNE ZSaberCannotDamage ;If > 00, jump to ZSaberCannotDamage so the enemy cannot be damaged by the Z-Saber
	LDA $0000 ;Load current damage amount from temp. variable $0000
	BEQ ZSaberCannotDamage ;If == 00, then jump to ZSaberCannotDamage to end routine
	
	STA $0002 ;Store new damage amount to temp. variable $0002
	LDA !RideChipsOrigin_7E1FD7 ;Load !RideChipsOrigin_7E1FD7
	AND #$F0 ;AND #$F0
	CMP #$F0 ;Check if value is #$F0
	BNE EndZSaberNoDamageIncrease ;If value =/= #$F0 then jump to EndZSaberNoDamageIncrease so the Z-Saber does NOT get a damage increase
	LDA $0002 ;Load current damage amount from temp. variable $0002
	CMP #$80
	BEQ EndZSaberNoDamageIncrease
	CLC ;Clear carry flag
	ADC #$02 ;Add #$02 to current damage amount
	STA $0000 ;Store to temp variable. $0002
EndZSaberNoDamageIncrease:
	LDA $0000 ;Load original damage amount from temp. variable $0000
	PLX
	RTL
	
ZSaberCannotDamage:
	STZ $0000 ;Store #$00 to current damage amount to temp. variable at $0000
	BRA EndZSaberNoDamageIncrease
}
	
SetZSaberWaveDamage: ;Routine to determine what damage value the Z-Saber Wave uses from the new damage code
{
	STX $0002 ;Store X to temp. variable $0002
	LDA $1F57 ;Boss damage table #
	ASL ;Double value
	TAX ;Transfer A to X
	JSL DamageTableSetup ;Load routine to get new damage table routine
	INX
	LDA $CB0000,x ;Load base bank for damage value
	LDX $0002 ;Load original X value from temp. variable $0002
	SEP #$20
	RTL
}

CheckForTornadoFang: ;Routine to check for Tornado Fang on Volt Catfish to allow damage even when it's not allowed.
{
	LDA !DamageType_1F2F
	CMP #$0E ;Check for Tornado Fang
	BEQ CheckForTornadoFang_IsTornadoFang
	CMP #$17 ;Check for Charged Tornado Fang
	BEQ CheckForTornadoFang_IsTornadoFang
	
	CheckForTornadoFang_NoDamageAllowed:
	CLC
	RTL
	
	CheckForTornadoFang_IsTornadoFang: ;Allows Tornado Fang to do damage
	LDA $37
	CMP #$3D
	BCS CheckForTornadoFang_NoDamageAllowed
	SEC
	RTL
}

;*********************************************************************************
; Various chunks of code that sets the enemy table to the 'blank' damage table value so enemies can NOT be hit multiple times.
; All of them for bosses has been removed so bosses CAN be hit multiple times depending on the circumstance.
;*********************************************************************************
BossCheckDisableZSaber: ;Routine that determines whether the Z-Saber is capable of damaging a boss or not
{
	LDA !DamageType_1F2F ;Load damage type
	CMP #$02 ;Check if it's #$02 (Z-Saber)
	BNE ZSaberDamageBossEnd ;If not, jump to ZSaberDamageBossEnd and end routine
	
	LDX #$0F
	REP #$20
	TDC
	STA $0000
	LDA #$10D8
	STA $0002
BeginZSaberCheckLoop:
	DEX
	SEC
	SBC #$0040
	CMP $0000
	STX !ZSaberCheckEnemy_1FCF
	BNE BeginZSaberCheckLoop
	SEP #$20
	LDA #$01 ;Load value #$01
	STA !ZSaberEnemyTable_7EF500,x ;Store to !ZSaberEnemyTable_7EF500 so it sets a flag that boss CANNOT be hit by Z-Saber multiple times.
ZSaberDamageBossEnd:
	RTL
}
	
;*********************************************************************************
; Loads charging sub-weapons and checks if you have weapon upgrade or not
;*********************************************************************************
PCChargeSubWeaponsSetup:
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCChargedSubWeaponsPointers,x)
	RTL

	PCChargedSubWeaponsPointers:
		dw X_ChargeSubWeapons
		dw Zero_ChargeSubWeapons
		dw PC3_ChargeSubWeapons
		dw PC4_ChargeSubWeapons
		db $FF,$FF
		db $FF,$FF
	
	
	X_ChargeSubWeapons:
		LDA !XArmorsByte1_7EF418
		BIT #$02
		RTS
		
	Zero_ChargeSubWeapons:
		LDA !CurrentPCSubWeapon_0A0B
		BNE ZeroNoChargeSubWeapon
		LDA #$01 ;Zero CANNOT charge sub-weapons
		BRA ZeroEndSubWeaponCharge
ZeroNoChargeSubWeapon:
		LDA #$00
ZeroEndSubWeaponCharge:
		RTS
		
	PC3_ChargeSubWeapons:
		LDA #$00 ;PC3 CANNOT charge sub-weapons
		RTS
		
	PC4_ChargeSubWeapons:
		LDA #$00 ;PC4 CANNOT charge sub-weapons
		RTS
}
		
;*********************************************************************************
; Determines who can charge regular buster to final level then switch to sub-weapons and use charged versions
;*********************************************************************************
PCChargeAndSwitchSubWeaponsSetup: ;Routine that determines who can charge regular buster to final level then switch to sub-weapons and use charged versions
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCChargeAndSwitchSubWeaponsPointers,x)
	RTL

	PCChargeAndSwitchSubWeaponsPointers:
		dw X_ChargeAndSwitchSubWeapons
		dw Zero_ChargeAndSwitchSubWeapons
		dw PC3_ChargeAndSwitchSubWeapons
		dw PC4_ChargeAndSwitchSubWeapons
		db $FF,$FF
		db $FF,$FF
	
	
	X_ChargeAndSwitchSubWeapons:
		SEP #$20
		LDA !CurrentPCSubWeaponShort_33 ;Load current sub-weapon short
		CMP #$09 ;Check if it's #$09 (Hyper Charge)
		RTS
		
	Zero_ChargeAndSwitchSubWeapons:
		LDA !CurrentPCSubWeapon_0A0B
		
		STZ !CurrentPCChargeLevel4_0A66 ;Split Shot #1/2
		STZ !CurrentPCCharge_0A30 ;PC Charge level
		STZ !SetFlashForPC_0A32 ;Set PC to flash
		SEP #$20
		STZ $0B58 ;Palette of bubbles
		STZ $0B5E ;Current level of bubble
		STZ $0B66 ;Charge timer extra storage
		STZ $0A8F ;Removes Z-Saber
		RTS
		
	PC3_ChargeAndSwitchSubWeapons:
		STZ !CurrentPCChargeLevel4_0A66 ;Split Shot #1/2
		STZ !CurrentPCCharge_0A30 ;PC Charge level
		STZ !SetFlashForPC_0A32 ;Set PC to flash
		SEP #$20
		STZ $0B58 ;Palette of bubbles
		STZ $0B5E ;Current level of bubble
		STZ $0B66 ;Charge timer extra storage
		STZ $0A8F ;Removes Z-Saber
		RTS
		
	PC4_ChargeAndSwitchSubWeapons:
		STZ !CurrentPCChargeLevel4_0A66 ;Split Shot #1/2
		STZ !CurrentPCCharge_0A30 ;PC Charge level
		STZ !SetFlashForPC_0A32 ;Set PC to flash
		SEP #$20
		STZ $0B58 ;Palette of bubbles
		STZ $0B5E ;Current level of bubble
		STZ $0B66 ;Charge timer extra storage
		STZ $0A8F ;Removes Z-Saber
		RTS
}

;*********************************************************************************
; Fixes 'lemon shot' bug on various circumstances. 
; IE: Firing as you enter a boss door, event etc.. it'll set 7E:0A30 (Current charge) to 00 at the wrong time causing the bug.
; This is now remedied by having it store as the shot GOES OFF instead of long before.
;*********************************************************************************
BusterShotLemonFix: ;Routine that fixes various circumstances of the 'Lemon Shot' bug where PCs would not be able to charge.
{
	LDA !ZSaberCharge_0A8F
	BNE BusterShotLemonFixStoreZSaber
	STZ !CurrentPCCharge_0A30
	BRA BusterShotLemonFixEnd
BusterShotLemonFixStoreZSaber:
	LDA #$0C
	STA !CurrentPCCharge_0A30
BusterShotLemonFixEnd:
	STZ $8E
	LDA #$08
	RTL
}

;*********************************************************************************
; Sets capsule text loading when finding a Dr. Light capsule
;*********************************************************************************
PCCapsuleIntroductionSetup:
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCCapsuleIntroductionPointers,x)
	RTL

	PCCapsuleIntroductionPointers:
		dw X_CapsuleIntroduction
		dw Zero_CapsuleIntroduction
		dw PC3_CapsuleIntroduction
		dw PC4_CapsuleIntroduction
		db $FF,$FF
		db $FF,$FF
	
	
	X_CapsuleIntroduction:
		LDA !CurrentLevel_1FAE
		ASL A
		TAX
		LDA $CEED,x
		STA $0008
		LDA $CEEE,x
		RTS
		
	Zero_CapsuleIntroduction:
		LDA !CapsuleIntro_7EF4E4
		BIT #$01
		BNE ZeroCapsuleIntroductionSkip
		LDA #$53 ;Zero capsule introduction text single-byte pointer
		STA $0008
		LDA #$01
		STA !CapsuleIntro_7EF4E4
		LDA #$00
		BRA ZeroCapsuleIntroductionEnd
		
		ZeroCapsuleIntroductionSkip:
		LDA !CurrentLevel_1FAE
		ASL A
		TAX
		LDA $CEED,x
		STA $0008
		LDA $CEEE,x
		
		ZeroCapsuleIntroductionEnd:
		RTS
		
	PC3_CapsuleIntroduction:
		LDA !CurrentLevel_1FAE
		ASL A
		TAX
		LDA $CEED,x
		STA $0008
		LDA $CEEE,x
		RTS
		
	PC4_CapsuleIntroduction:
		LDA !CurrentLevel_1FAE
		ASL A
		TAX
		LDA $CEED,x
		STA $0008
		LDA $CEEE,x
		RTS
}

;*********************************************************************************
; Determines who can use Z-Saber right away after buster shot
;*********************************************************************************
PCZSaberWaitSetup: ;Routine that determines who can use the Z-Saber right away after a buster shot
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCZSaberWaitPointers,x)
	RTL

	PCZSaberWaitPointers:
		dw X_ZSaberWait
		dw Zero_ZSaberWait
		dw PC3_ZSaberWait
		dw PC4_ZSaberWait
		db $FF,$FF
		db $FF,$FF
	
	
	X_ZSaberWait:
		LDA $7D ;Sets X having to wait for buster shot
		ORA $AA
		BEQ XZSaberWaitEnd
		LDA #$20
		TSB $AC
		LDA #$01
		
		XZSaberWaitEnd:
		RTS
		
	Zero_ZSaberWait:
		LDA #$00 ;Zero DOES NOT wait for buster shot
		RTS
	
	PC3_ZSaberWait: 
		LDA $7D ;Sets PC3 having to wait for buster shot
		ORA $AA
		BEQ PC3ZSaberWaitEnd
		LDA #$20
		TSB $AC
		LDA #$01
		
		PC3ZSaberWaitEnd:
		RTS
	
	PC4_ZSaberWait:
		LDA $7D ;Sets PC4 having to wait for buster shot
		ORA $AA
		BEQ PC4ZSaberWaitEnd
		LDA #$20
		TSB $AC
		LDA #$01
		
		PC4ZSaberWaitEnd:
		RTS
}

;*********************************************************************************
; New code that stores the general VRAM upon entering levels, switching PCs, etc..
; Also includes new code to store the PC's 1-up icon VRAM data
;*********************************************************************************
GeneralVRAMStorage:
{
	LDY #$AA ;Value to use to get where the data setup is
	JSL !LoadDecompressedGraphics_Long ;Decompression routine
	JSL PC1UpMenuVRAMSetup
	RTL
}

GeneralVRAMLeaveMenu:
{
	LDY #$AA ;Value to use to get where the data setup is
	JSL !LoadDecompressedGraphics_Long ;Decompression routine
	JSL PC1UpMenuVRAMSetup
	
	; PHB
	; PHD
	; PHP
	; REP #$20
	; LDA #$09D8
	; TCD
	; SEP #$20
	
	; LDA #$80
	; TSB $17
	; ;TSB $00 ;This is for when the PC sprite data is changed to allow more than #$7F sprites. This'll allow
	; JSL PCNPC_VRAMRoutine
	; PLP
	; PLD
	; PLB
	
	RTL
}

GeneralPC1UpStorage:
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
	
	RTL
}


;*********************************************************************************
; New code to write palette data for PCs
;*********************************************************************************
PCGeneralPalettes: ;Routine that determines each PC's general palette based on various circumstances
{
	SEP #$20
	REP #$10
	LDA !CurrentPCSubWeapon_0A0B ;Load current sub-weapon
	
	PCGeneralPalettes_SkipLoadSubWeapon:
	ASL ;Double value
	STA $0004 ;Store to temp. variable $0004
	
	STX $0010
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCGeneralPalettePointers,x)
	LDX $0010
	RTL

	PCGeneralPalettePointers:
		dw X_GeneralPalette
		dw Zero_GeneralPalette
		dw PC3_GeneralPalette
		dw PC4_GeneralPalette
		db $FF,$FF
		db $FF,$FF
	
	
	X_GeneralPalette:
		REP #$30
		LDA $0004
		AND #$00FF
		CLC
		ADC #$0100
		TAY
		JSL !PaletteAlternate
		
		LDA $0004
		AND #$00FF
		BEQ XGoldArmorPalette
		CMP #$0012
		BNE GeneralEndPalette
		
		XGoldArmorPalette:
		LDA !RideChipsOrigin_7E1FD7
		AND #$00F0
		CMP #$00F0
		BNE GeneralEndPalette
		
		LDY #$01B8 ;X Golden Armor Palette
		JSL !PaletteAlternate
		
		GeneralEndPalette:
		SEP #$30
		STZ $00A1
		INC $00A2
		RTS
	
	Zero_GeneralPalette:
		REP #$30
		; LDA $0004 ;Remove comment here so Zero is able to use sub-weapon colors
		; AND #$00FF
		; BEQ Zero_GeneralPalette_NoColors
		; CMP #$0012
		; BEQ Zero_GeneralPalette_NoColors
		; CLC
		; ADC #$021C
		; TAY
		; BRA ZeroPaletteEnd
		
		Zero_GeneralPalette_NoColors:
		LDA !RideChipsOrigin_7E1FD7
		AND #$00F0
		CMP #$00F0
		BEQ ZeroBlackArmor
		LDY #$00D0 ;Load Zero palette
		BRA ZeroPaletteEnd
		
		ZeroBlackArmor:
		LDA !CurrentPCSubWeapon_0A0B
		AND #$00FF
		BNE IgnorePurpleSaber
		LDA $7E1F37 ;Check if menu open
		BNE IgnorePurpleSaber
		LDX #$0030
		LDY #$0206 ;Load Zero Purple Saber
		JSL !Palette
		
		IgnorePurpleSaber:
		LDX #$0040
		LDY #$0204 ;Load Zero Black Armor palette
		
		ZeroPaletteEnd:
		JSL !PaletteAlternate
		JSR GeneralEndPalette
		RTS
		
	PC3_GeneralPalette:
		REP #$30
		LDY #$00D0
		JSL !PaletteAlternate
		JSR GeneralEndPalette
		RTS
	
	PC4_GeneralPalette:
		REP #$30
		LDY #$00D0
		JSL !PaletteAlternate
		JSR GeneralEndPalette
		RTS
}

PC_ChargingPalettes: ;Routine to load each PC's individual palettes when charging their buster
{
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PC_ChargingPalettesPointers,x)
	RTL

	PC_ChargingPalettesPointers:
		dw X_ChargingPalettes
		dw Zero_ChargingPalettes
		dw PC3_ChargingPalettes
		dw PC4_ChargingPalettes
		db $FF,$FF
		db $FF,$FF
		
		X_ChargingPalettes:
		LDX $82
		REP #$30
		LDA X_ChargingPalettesSetup,x
		TAY
		RTS
		
		Zero_ChargingPalettes:
		LDX $82
		REP #$30
		LDA Zero_ChargingPalettesSetup,x
		TAY
		RTS
		
		PC3_ChargingPalettes:
		LDX $82
		REP #$30
		LDA X_ChargingPalettesSetup,x
		TAY
		RTS
		
		PC4_ChargingPalettes:
		LDX $82
		REP #$30
		LDA X_ChargingPalettesSetup,x
		TAY
		RTS
		
		
}


;*********************************************************************************
; New code to write palette data for PCs & rewrite of sub-weapon routine when swapping with L/R
;*********************************************************************************
LoadProperSubWeaponSFX: ;Routine to load proper sub-weapon SFX
{
	STA $0010
	LDA $33
	ASL
	CLC
	ADC $0010
	TAX
	RTL
}

PCBusterPalette: ;Routine that sets the PC's sub-weapon/buster/Z-Saber palette depending on circumstance.
{
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCBusterPalettePointers,x)
	STZ $0A68
	RTL

	PCBusterPalettePointers:
		dw X_BusterPalette
		dw Zero_BusterPalette
		dw PC3_BusterPalette
		dw PC4_BusterPalette
		db $FF,$FF
		db $FF,$FF
	
	
	X_BusterPalette:
		LDX #$30 ;Loads RAM location for Buster Palette
		LDA !CurrentPCSubWeapon_0A0B
		ASL
		CLC
		ADC #$40
		TAY
		JSL !Palette
		RTS
	
	Zero_BusterPalette:
		REP #$30
		LDX #$0030
		LDA !CurrentPCSubWeapon_0A0B
		ASL
		AND #$00FF
		CLC
		BEQ ZeroBaseBuster
		ADC #$0040
		BRA ZeroBusterPaletteEnd
		
		ZeroBaseBuster:
		LDA !RideChipsOrigin_7E1FD7
		AND #$00F0
		CMP #$00F0
		BEQ ZeroPurpleSaber
		LDA #$00D2
		BRA ZeroBusterPaletteEnd
		
		ZeroPurpleSaber:
		LDA #$0206 ;Load palette pointer for Z-Saber being purple
		
		ZeroBusterPaletteEnd:
		TAY
		JSL !Palette
		RTS
	
	PC3_BusterPalette:
		LDX #$30
		LDA !CurrentPCSubWeapon_0A0B
		ASL
		CLC
		ADC #$40
		TAY
		JSL !Palette
		RTS
	
	PC4_BusterPalette:
		LDX #$30
		LDA !CurrentPCSubWeapon_0A0B
		ASL
		CLC
		ADC #$40
		TAY
		JSL !Palette
		RTS
}
				
DisablePCSubWeaponCharging: ;Routine that determines which PC can charge sub-weapons or not.
{
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCSubWeaponChargingPointers,x)
	RTL

	PCSubWeaponChargingPointers:
		dw X_SubWeaponCharging
		dw Zero_SubWeaponCharging
		dw PC3_SubWeaponCharging
		dw PC4_SubWeaponCharging
		db $FF,$FF
		db $FF,$FF
	
	
	X_SubWeaponCharging:
		RTS
		
	Zero_SubWeaponCharging:
		LDA !CurrentPCAction_09DA
		CMP #$2C
		BEQ ZeroSubWeaponChargeEnd
		LDA !CurrentPCSubWeapon_0A0B ;Loads current sub-weapon from !CurrentPCSubWeapon_0A0B
		BNE ZeroSubWeaponChargingDisable ;If value is > 00, then jump to ZeroSubWeaponChargingDisable to disable Zero from charging sub-weapons.
		STZ $0A54
		BRA ZeroSubWeaponChargeEnd
		
		ZeroSubWeaponChargingDisable:
		LDA #$80
		STA $0A54
		ZeroSubWeaponChargeEnd:
		RTS
	
	PC3_SubWeaponCharging:
		LDA !CurrentPCSubWeapon_0A0B
		BNE PC3SubWeaponChargingDisable
		STZ $0A54
		BRA PC3SubWeaponChargeEnd
		
		PC3SubWeaponChargingDisable:
		LDA #$01
		STA $0A54
		PC3SubWeaponChargeEnd:
		RTS
	
	PC4_SubWeaponCharging:
		LDA !CurrentPCSubWeapon_0A0B
		BNE PC4SubWeaponChargingDisable
		STZ $0A54
		BRA PC4SubWeaponChargeEnd
		
		PC4SubWeaponChargingDisable:
		LDA #$01
		STA $0A54
		PC4SubWeaponChargeEnd:
		RTS
}


;*********************************************************************************
; New code to write separate data for PC's jumping out of Ride Armor
;*********************************************************************************
PC_JumpOutRideArmor: ;Routine that determines which PC can charge sub-weapons or not.
{
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PC_JumpOutRideArmorPointers,x)
	RTL

	PC_JumpOutRideArmorPointers:
		dw X_JumpOutRideArmor
		dw Zero_JumpOutRideArmor
		dw PC3_JumpOutRideArmor
		dw PC4_JumpOutRideArmor
		db $FF,$FF
		db $FF,$FF
	
	
	X_JumpOutRideArmor:
		STZ $0A54
		STZ $0A3C
		RTS
		
	Zero_JumpOutRideArmor:
		LDA !CurrentPCSubWeapon_0A0B ;Loads current sub-weapon from !CurrentPCSubWeapon_0A0B
		BNE Zero_JumpOutRideArmor_ChargingDisable ;If value is > 00, then jump to ZeroSubWeaponChargingDisable to disable Zero from charging sub-weapons.
		STZ $0A54
		BRA Zero_JumpOutRideArmor_End
		
		Zero_JumpOutRideArmor_ChargingDisable:
		LDA #$80
		STA $0A54
		Zero_JumpOutRideArmor_End:
		STZ $0A3C
		RTS
	
	PC3_JumpOutRideArmor:
		STZ $0A54
		STZ $0A3C
		RTS
	
	PC4_JumpOutRideArmor:
		STZ $0A54
		STZ $0A3C
		RTS
}

;*********************************************************************************
; New code to write palette data for PCs upon entering a capsule and it starts giving them the part.
;*********************************************************************************
PCCapsuleFlashPalette: ;Routine that specifies each PC's palette inside the capsule when they're flashing.
{
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCCapsuleFlashPalettePointers,x)
	RTL

	PCCapsuleFlashPalettePointers:
		dw X_CapsuleFlashPalette
		dw Zero_CapsuleFlashPalette
		dw PC3_CapsuleFlashPalette
		dw PC4_CapsuleFlashPalette
		db $FF,$FF
		db $FF,$FF
	
	
	X_CapsuleFlashPalette:
		REP #$30
		LDA !CurrentLevel_1FAE
		AND #$00FF
		TAX
		LDA $CCFA,x
		AND #$00FF
		CMP #$0004
		BMI XBlueCapsule
		LDA #$00D6
		BRA XStoreCapsuleFlash
XBlueCapsule:
		LDA #$0162
XStoreCapsuleFlash:
		STA $0002
		RTS
	
	Zero_CapsuleFlashPalette:
		REP #$30
		LDA !CurrentLevel_1FAE
		AND #$00FF
		TAX
		LDA $CCFA,x
		AND #$00FF
		CMP #$0004
		BMI ZeroBlueCapsule
		LDA #$0210
		BRA ZeroStoreCapsuleFlash
ZeroBlueCapsule:
		LDA #$0208
ZeroStoreCapsuleFlash:
		STA $0002
		RTS
	
	PC3_CapsuleFlashPalette:
		REP #$30
		LDA !CurrentLevel_1FAE
		AND #$00FF
		TAX
		LDA $CCFA,x
		AND #$00FF
		CMP #$0004
		BMI PC3BlueCapsule
		LDA #$00D6
		BRA PC3StoreCapsuleFlash
PC3BlueCapsule:
		LDA #$0162
PC3StoreCapsuleFlash:
		STA $0002
		RTS
	
	PC4_CapsuleFlashPalette:
		REP #$30
		LDA !CurrentLevel_1FAE
		AND #$00FF
		TAX
		LDA $CCFA,x
		AND #$00FF
		CMP #$0004
		BMI PC4BlueCapsule
		LDA #$00D6
		BRA PC4StoreCapsuleFlash
PC4BlueCapsule:
		LDA #$0162
PC4StoreCapsuleFlash:
		STA $0002
		RTS
}

;*********************************************************************************
; Load PC hitbox when jumping and landing, jumping out of Ride Armor, etc..
;*********************************************************************************	
PCGeneralhitbox: ;Routine that specifies PC's hitbox depending on any general circumstance.
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCGeneralhitboxPointers,x)
	RTL

	PCGeneralhitboxPointers:
		dw X_Generalhitbox
		dw Zero_Generalhitbox
		dw PC3_Generalhitbox
		dw PC4_Generalhitbox
		db $FF,$FF
		db $FF,$FF
	
	
	X_Generalhitbox:
		REP #$20
		LDA #$B404
		STA !CurrentPCHitbox_09F8
		RTS
		
	Zero_Generalhitbox:
		REP #$20
		LDA #$B40E
		STA !CurrentPCHitbox_09F8
		RTS
		
	PC3_Generalhitbox:
		REP #$20
		LDA #$B404
		STA !CurrentPCHitbox_09F8
		RTS
		
	PC4_Generalhitbox:
		REP #$20
		LDA #$B404
		STA !CurrentPCHitbox_09F8
		RTS
}

PCDashhitbox: ;Routine that specifies PC's hitbox depending on any general circumstance.
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCDashhitboxPointers,x)
	RTL

	PCDashhitboxPointers:
		dw X_Dashhitbox
		dw Zero_Dashhitbox
		dw PC3_Dashhitbox
		dw PC4_Dashhitbox
		db $FF,$FF
		db $FF,$FF
	
	
	X_Dashhitbox:
		REP #$20
		LDA #$B418
		STA !CurrentPCHitbox_09F8
		RTS
		
	Zero_Dashhitbox:
		REP #$20
		LDA #$B422
		STA !CurrentPCHitbox_09F8
		RTS
		
	PC3_Dashhitbox:
		REP #$20
		LDA #$B418
		STA !CurrentPCHitbox_09F8
		RTS
		
	PC4_Dashhitbox:
		REP #$20
		LDA #$B418
		STA !CurrentPCHitbox_09F8
		RTS
}
		
;*********************************************************************************
; Stage Select: Allow X to change to Zero
;*********************************************************************************
PCStageSelectIcon: ;Routine that sets which PC you are and are switching to when hitting the 'X' or 'Z' icon
{
	SEP #$20
	LDX !CurrentPCCheck_1FFF
	JSR (PCStageSelectIconPointers,x)
	RTL

	PCStageSelectIconPointers:
		dw X_StageSelectIcon
		dw Zero_StageSelectIcon
		dw PC3_StageSelectIcon
		dw PC4_StageSelectIcon
		db $FF,$FF
		db $FF,$FF
	
	
	X_StageSelectIcon:
		SEP #$20
		LDA !ZSaberObtained_1FB2
		BIT #$40
		BEQ AllowXSwap
		BRA XStageSelectCannotSwap
		
		AllowXSwap:
		LDA #$02
		STA !CurrentPCCheck_1FFF
		LDA #$41
		JSL !PlaySFX
		JSL PCStageSelectIconUpdate ;Loads routine that sets which PC you are and are switching to when hitting the 'X' or 'Z' icon
		RTS
		
		XStageSelectCannotSwap:
		LDA #$1F
		JSL !PlaySFX
		RTS
	
	Zero_StageSelectIcon:
		SEP #$20
		LDA !ZSaberObtained_1FB2
		BIT #$01
		BEQ AllowZeroSwap
		BRA ZeroStageSelectCannotSwap
		
		AllowZeroSwap:
		LDA #$00
		STA !CurrentPCCheck_1FFF
		LDA #$41
		JSL !PlaySFX
		JSL PCStageSelectIconUpdate ;Loads routine that sets which PC you are and are switching to when hitting the 'X' or 'Z' icon
		RTS
		
		ZeroStageSelectCannotSwap:
		LDA #$1F
		JSL !PlaySFX
		RTS
	
	PC3_StageSelectIcon:
		SEP #$20
		LDA #$1F
		JSL !PlaySFX
		RTS
	
	PC4_StageSelectIcon:
		SEP #$20
		LDA #$1F
		JSL !PlaySFX
		RTS
}
		
PCStageSelectIconUpdate: ;Routine that updates VRAM to change the Stage Select 'X' icon to a 'Z' and vice versa
{
StageSelectVRAMUpdate1:
	LDA $4212
	BMI StageSelectVRAMUpdate1
StageSelectVRAMUpdate2:
	LDA $4212
	BPL StageSelectVRAMUpdate2
	
	LDY #$03 ;Loop counter
	LDA #$18
	STA $4301
	LDA #$01
	STA $4300
	LDA #$80
	STA $2115
	
	REP #$21
	LDA #$584E ;VRAM Tile Map location
	STA $0020
	
	LDA !CurrentPCCheck_1FFF
	AND #$00FF
	TAX
	LDA PCStageSelectPCIconPointers,x
	STA $0022
StageSelectVRAMLoop:
	LDA $0020
	CLC
	ADC #$0020
	STA $0020
	STA $2116
	
	LDA $0022
	CLC
	ADC #$0008
	STA $0022
	STA $4302
	
	LDA #$0008
	STA $4305
	
	SEP #$20
	LDA #$C8 ;Load bank of pointers
	STA $4304
	LDA #$01
	STA $420B
	DEY
	CPY #$00
	REP #$21
	BNE StageSelectVRAMLoop
	SEP #$20
	RTL
}
	
	
StageSelect_LoadDecompressedZGraphics:
{
	JSL AllowBankSendToVRAM
	
	LDY #$B0 ;Single byte value of 'Z' icon pointer
	JSL !LoadDecompressedGraphics_Long  ;Load routine to get decompressed graphics
	JSL AllowBankSendToVRAM
	
	JSL PCStageSelectIconUpdate ;Loads routine that updates VRAM to change the Stage Select 'X' icon to a 'Z' and vice versa
	
	LDY #$AA ;Reloads general VRAM for stage select screen
	JSL !LoadDecompressedGraphics_Long  ;Load routine to get decompressed graphics
	JSL AllowBankSendToVRAM
	RTL
}

;*********************************************************************************
;Splits PC's general sprite data up
;*********************************************************************************
PCGeneralSprite: ;Routine to set general sprite setup for all PCs
{
	SEP #$20
	STZ !ZSaberCheckEnemy_1FCF
	LDX !CurrentPC_0A8E
	JSR (PCGeneralSpritePointers,x)
	RTL

	PCGeneralSpritePointers:
		dw X_GeneralSprite
		dw Zero_GeneralSprite
		dw PC3_GeneralSprite
		dw PC4_GeneralSprite
		db $FF,$FF
		db $FF,$FF
	
	
	X_GeneralSprite:
;		LDA #$CE45 ;VRAM Pointer
;		STA $31
		SEP #$20
		LDX #$00 ;No Helmet Sprite Assembly
		LDA !XArmorsByte1_7EF418
		BIT #$01
		BEQ XGeneralSpriteNoHelmet
		LDX #$18 ;Helmet Sprite Assembly
		
		XGeneralSpriteNoHelmet:
		STX $16
		LDA #$5D ;Base Armor pieces Sprite Assembly/Animation Data
		STA $0AF8
		STA $0B18
		STA $0B38
		STZ $0AE9
		STZ $0B09
		STZ $0B29
		
		LDA #$00
		STA !PCVRAMByte_7EF4E8
		RTS
	
	Zero_GeneralSprite:
;		LDA #$D6A8 ;VRAM pointer
;		STA $31
		SEP #$30
		LDA #$4A ;Zero Sprite Assembly
		STA $16
		LDA #$FF
		STA $0AE9
		STA $0B09
		STA $0B29
		
		LDA #$02
		STA !PCVRAMByte_7EF4E8
		RTS
	
	PC3_GeneralSprite:
;		LDA #$D6A8 ;VRAM pointer
;		STA $31
		SEP #$30
		LDA #$4A ;Zero Sprite Assembly
		STA $16
		LDA #$FF
		STA $0AE9
		STA $0B09
		STA $0B29
		
		LDA #$04
		STA !PCVRAMByte_7EF4E8
		RTS
	
	PC4_GeneralSprite:
;		LDA #$D6A8 ;VRAM pointer
;		STA $31
		SEP #$30
		LDA #$4A ;Zero Sprite Assembly
		STA $16
		LDA #$FF
		STA $0AE9
		STA $0B09
		STA $0B29
		
		LDA #$06
		STA !PCVRAMByte_7EF4E8
		RTS
}
		
PCGeneralZSaberSprite: ;Routine to set PC general Z-Saber sprites
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCGeneralZSaberSpritePointers,x)
	RTL

	PCGeneralZSaberSpritePointers:
		dw X_GeneralZSaberSprite
		dw Zero_GeneralZSaberSprite
		dw PC3_GeneralZSaberSprite
		dw PC4_GeneralZSaberSprite
		db $FF,$FF
		db $FF,$FF
	
	
	X_GeneralZSaberSprite:
;		LDA #$D334 ;VRAM Pointer (Not needed once VRAM routine is in)
;		STA $31
		LDX #$33
		LDA !XArmorsByte1_7EF418
		BIT #$01
		BEQ XGeneralSpriteZSaberNoHelmet
		LDX #$34
		
		XGeneralSpriteZSaberNoHelmet:
		STX $16
		LDA #$35
		STA $0AF8
		STA $0B18
		STA $0B38
		STZ $0AE9
		STZ $0B09
		STZ $0B29
		
		LDA #$08
		STA !PCVRAMByte_7EF4E8
		
		LDA !PCAirGroundDetection_0A03
		BIT #$04
		BEQ X_GeneralZSaberSprite_SkipSetJumpValues
		JSL SetJumpValues
		
		X_GeneralZSaberSprite_SkipSetJumpValues:
		RTS
	
	Zero_GeneralZSaberSprite:
;		LDA #$DB47 ;VRAM Pointer (Not needed once VRAM routine is in)
;		STA $31
		LDA #$4B
		STA $16
		LDA #$FF
		STA $0AE9
		STA $0B09
		STA $0B29
		
		LDA #$0A
		STA !PCVRAMByte_7EF4E8
		
		LDA !PCAirGroundDetection_0A03
		BIT #$04
		BEQ Zero_GeneralZSaberSprite_SkipSetJumpValues
		JSL SetJumpValues
		
		Zero_GeneralZSaberSprite_SkipSetJumpValues:
		RTS
		
	PC3_GeneralZSaberSprite:
;		LDA #$DB47 ;VRAM Pointer (Not needed once VRAM routine is in)
;		STA $31
		LDA #$4B
		STA $16
		LDA #$FF
		STA $0AE9
		STA $0B09
		STA $0B29
		
		LDA #$0C
		STA !PCVRAMByte_7EF4E8
		
		LDA !PCAirGroundDetection_0A03
		BIT #$04
		BEQ PC3_GeneralZSaberSprite_SkipSetJumpValues
		JSL SetJumpValues
		
		PC3_GeneralZSaberSprite_SkipSetJumpValues:
		RTS
	
	PC4_GeneralZSaberSprite:
;		LDA #$DB47 ;VRAM Pointer (Not needed once VRAM routine is in)
;		STA $31
		LDA #$4B
		STA $16
		LDA #$FF
		STA $0AE9
		STA $0B09
		STA $0B29
		
		LDA #$0E
		STA !PCVRAMByte_7EF4E8
		
		LDA !PCAirGroundDetection_0A03
		BIT #$04
		BEQ PC4_GeneralZSaberSprite_SkipSetJumpValues
		JSL SetJumpValues
		
		PC4_GeneralZSaberSprite_SkipSetJumpValues:
		RTS
}

PCGeneralRideArmorSprite: ;Routine to set PC Ride Armor sprites
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCGeneralRideArmorPointers,x)
	RTL

	PCGeneralRideArmorPointers:
		dw X_GeneralRideArmorSprite
		dw Zero_GeneralRideArmorSprite
		dw PC3_GeneralRideArmorSprite
		dw PC4_GeneralRideArmorSprite
		db $FF,$FF
		db $FF,$FF
	
	
	X_GeneralRideArmorSprite:
		REP #$20
		LDA #$D000 ;VRAM Graphics Pointer
		STA $0A09
		
		SEP #$20
		LDX #$6A
		LDA !XArmorsByte1_7EF418
		BIT #$01
		BEQ XGeneralSpriteRideArmorNoHelmet
		LDX #$6B
		
		XGeneralSpriteRideArmorNoHelmet:
		STX $09EE
		
		LDA #$6C ;Sprite Assembly
		STA $0AF8
		STA $0B18
		STA $0B38
		STZ $0AE9
		STZ $0B09
		STZ $0B29
		
		LDA #$10
		STA !PCVRAMByte_7EF4E8

		REP #$31
		LDA #$B51B
		STA !CurrentPCHitbox_09F8
		JSL $84B6D0
		RTS
		
	Zero_GeneralRideArmorSprite:
		REP #$20
		LDA #$DA00 ;VRAM Graphics Pointer
		STA $0A09
		
		SEP #$20
		LDX #$BB ;Sprite Assembly
		STX $09EE
		
		LDA #$FF
		STA $0AE9
		STA $0B09
		STA $0B29
		
		LDA #$12
		STA !PCVRAMByte_7EF4E8

		REP #$31
		LDA #$B51B
		STA !CurrentPCHitbox_09F8
		JSL $84B6D0
		RTS
		
	PC3_GeneralRideArmorSprite:
		REP #$20
		LDA #$E400 ;VRAM Graphics Pointer
		STA $0A09
		
		SEP #$20
		LDX #$6A ;Sprite Assembly
		STX $09EE
		
		LDA #$FF
		STA $0AE9
		STA $0B09
		STA $0B29
		
		LDA #$14
		STA !PCVRAMByte_7EF4E8

		REP #$31
		LDA #$B51B
		STA !CurrentPCHitbox_09F8
		JSL $84B6D0
		RTS
		
	PC4_GeneralRideArmorSprite:
		REP #$20
		LDA #$EE00 ;VRAM Graphics Pointer
		STA $0A09
		
		SEP #$20
		LDX #$6A ;Sprite Assembly
		STX $09EE
		
		LDA #$FF
		STA $0AE9
		STA $0B09
		STA $0B29
		
		LDA #$16
		STA !PCVRAMByte_7EF4E8

		REP #$31
		LDA #$B51B
		STA !CurrentPCHitbox_09F8
		JSL $84B6D0
		RTS
}
		
SplitSAAD: ;Routine that allows loading of the Split Sprite Assembly/Animation Data table so there are no repeat values for the same thing.
{
	LDA $16
	AND #$00FF
	
	SEP #$20
	TAX
	LDA SplitSAADTable,x
	TAX
	REP #$20
	RTL
}

DynamicAnimationBank: ;Routine that allows PCs to have their own data from the rest of the objects
{
	REP #$30
	STA $000E
	LDA $16
	AND #$00FF
	SEP #$20
	TAX
	LDA SplitSAADTable,x
	REP #$30
	AND #$00FF
	STA $000C
	ASL
	CLC
	ADC $000C
	TAX
	
	SEP #$20
	LDA $BF8002,x
	
	SEP #$30
	PHA
	PLB
	
	REP #$21
	LDA $14
	ADC #$0003
	LDY $0F
	RTL
}

;*********************************************************************************
;Allows PCs and PC NPC's to use their own VRAM code and table
;*********************************************************************************
NewVRAMRoutine: ;New basis routine for PCs that sets their VRAM data up to be split from other objects in game.
{
	JSL PCNPC_VRAMStart ;Load routine that sets PC's VRAM
	JSL PCNPC_VRAMRoutine ;Load routine that sets PC NPC's VRAM
	RTL
}
		
PCVRAMStart: ;Routine that determines which VRAM pointer to use for what PC.
{
	REP #$20
	LDA !PCVRAMByte_7EF4E8
	
	PC_VRAMStart:
	AND #$00FF
	TAX
	LDA PCNPC_VRAMStartTable,x
	STA $31
	
	SEP #$20
	LDA $31
	CMP $B3
	RTL
}
		
PCNPC_VRAMStart: ;Routine that determines which VRAM pointer to use for what PC NPC.
{
		REP #$20
		LDA !PCNPC_VRAMByte_1FCB
		BRA PC_VRAMStart
}



PCNPC_VRAMAllowMissilesStart:
{
	PHP
	SEP #$30
	STZ $0006
	LDA #$10
	STA $0007
	BRA PCNPC_VRAMMissileJump ;Hard set branch at the moment
	
PCNPC_VRAMRoutine: ;Routine that determines which VRAM pointer to use for what PC NPC.
	PHP
	SEP #$30
	STZ $0006
	STZ $0007
PCNPC_VRAMMissileJump:
	LDA $17
	;LDA $00 ;For when allowing more than #$7F sprites for PC
	BMI PCNPC_VRAMRoutineContinue
	PLP
	RTL
	
PCNPC_VRAMRoutineContinue:
	AND #$7F
	STA $17
	;STA $00 ;For when allowing more than #$7F sprites for PC
	PEA $8685
	PLB
	
	REP #$30
	LDA $10
	AND #$00FF
	ASL
	TAX
	LDA $7F8000,x
	STA $7E0000
	LDA $17
	AND #$00FF
	ASL A
	CLC
	ADC $31
	TAX
	TAY
	LDA $500000,x
	CLC
	ADC $31
	TAX
	LDA $00A4
	AND #$00FF
	TAY
	
	SEP #$20
	LDA $500000,x
	BEQ PCNPC_VRAMRoutineEndRoutine
	
PCNPC_VRAMRoutineWriteGraphics:
	SEP #$20
	LDA #$80
	STA $0500,y
	LDA $500000,x
	LSR
	CLC
	ADC $1F38
	STA $1F38
	LDA $500003,x
	STA $0507,y
	LDA $500000,x
	
	REP #$21
	AND #$00FF
	ASL #4
	STA $0503,y
	LDA $500001,x
	CLC
	ADC $0000
	STA $0505,y
	LDA $17
	AND #$FF00
	LSR #4
	ORA $0006
	STA $0002
	LDA $500004,x
	BMI PCNPC_VRAMRoutineMoreStorage
	
	CLC
	ADC $0002
	STA $0501,y
	TYA
	ADC #$0008
	TAY
	TXA
	ADC #$0006
	TAX
	BRA PCNPC_VRAMRoutineWriteGraphics
	
PCNPC_VRAMRoutineMoreStorage:
	AND #$7FFF
	CLC
	ADC $0002
	STA $0501,y
	SEP #$20
	TYA
	ADC #$08
	STA $00A4
PCNPC_VRAMRoutineEndRoutine:
	PLB
	PLP
	RTL
}
					
SigmaVirusZSaberVRAMStart: ;This instance is ONLY used for the Z-Saber Cut Wave to appear on Sigma Virus head at the end of the game
{
	PHP
	SEP #$30
	STZ $0006
	LDA #$10
	STA $0007
	JML $84BCAB
}

;*********************************************************************************
;Loads PC's walking start speed/dash speed/dash distance
;*********************************************************************************
PCStartWalkingDashDistanceSpeed: ;Routine to set PC walking speed, dash speed and dash distance for each PC.
{
	SEP #$30
	STX $0010
	LDX !CurrentPC_0A8E
	JSR (PCStartWalkingDashDistanceSpeedPointers,x)
	RTL

	PCStartWalkingDashDistanceSpeedPointers:
		dw X_StartWalkingDashDistanceSpeed
		dw Zero_StartWalkingDashDistanceSpeed
		dw PC3_StartWalkingDashDistanceSpeed
		dw PC4_StartWalkingDashDistanceSpeed
		db $FF,$FF
		db $FF,$FF
	
	
	X_StartWalkingDashDistanceSpeed:
		LDX $0010
		LDA #$20
		STA $52
		REP #$20
		LDA $B272,x
		RTS
	
	Zero_StartWalkingDashDistanceSpeed:
		LDA #$20
		STA $52
		LDX $0010
		REP #$20
		LDA $B272,x
		STA $0010
		BEQ ZeroStartWalkEnd
		LDA !RideChipsOrigin_7E1FD7
		AND #$00F0
		CMP #$00F0
		BEQ ZeroFasterStartWalk
		LDA $0010
		BRA ZeroStartWalkEnd
		
		ZeroFasterStartWalk:
		SEP #$20
		CPX #$00
		BEQ ZeroStopWalk
		REP #$20
		LDA $0010
		CLC
		ADC #$0060
		
		ZeroStartWalkEnd:
		RTS
		
		ZeroStopWalk:
		REP #$20
		LDA #$0000
		RTS
		
	PC3_StartWalkingDashDistanceSpeed:
		LDX $0010
		LDA #$20
		STA $52
		REP #$20
		LDA $B272,x
		RTS
	
	PC4_StartWalkingDashDistanceSpeed:
		LDX $0010
		LDA #$20
		STA $52
		REP #$20
		LDA $B272,x
		RTS
}
		
PCAirDashSettings: ;Routine to set PC's data for Air Dash (IE: Speed, distance)
{
	SEP #$30
	STX $0010
	LDX !CurrentPC_0A8E
	JSR (PCAirDashSettingsPointers,x)
	RTL

	PCAirDashSettingsPointers:
		dw X_AirDashSettings
		dw Zero_AirDashSettings
		dw PC3_AirDashSettings
		dw PC4_AirDashSettings
		db $FF,$FF
		db $FF,$FF
	
	
	X_AirDashSettings:
		LDX $0010
		LDA #$10
		STA $52
		REP #$20
		LDA #$0375
		RTS
	
	Zero_AirDashSettings:
		LDX $0010
		LDA !RideChipsOrigin_7E1FD7
		AND #$F0
		CMP #$F0
		BEQ ZeroFasterAirDash
		LDA #$10
		STA $52
		
		REP #$20
		LDA #$0375
		RTS
		
		ZeroFasterAirDash:
		LDA #$18
		STA $52
		
		REP #$20
		LDA #$03D5
		RTS
		
	PC3_AirDashSettings:
		LDX $0010
		LDA #$10
		STA $52
		REP #$20
		LDA #$0375
		RTS
	
	PC4_AirDashSettings:
		LDX $0010
		LDA #$10
		STA $52
		REP #$20
		LDA #$0375
		RTS
}
	
;*********************************************************************************
;Loads PC's jumping then moving speed
;*********************************************************************************
PCJumpThenMove: ;Routine that sets the PC's jumping then using directional keys to move speed for each PC
{
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCJumpThenMovePointers,x)
	RTL

	PCJumpThenMovePointers:
		dw X_JumpThenMove
		dw Zero_JumpThenMove
		dw PC3_JumpThenMove
		dw PC4_JumpThenMove
		db $FF,$FF
		db $FF,$FF
	
	
	X_JumpThenMove:
		LDX #$0A
		JSL PCWalkingSpeed ;Load routine that determines each PC's walking speed.
		STA $5C
		RTS
	
	Zero_JumpThenMove:
		LDX #$0A
		JSL PCWalkingSpeed ;Load routine that determines each PC's walking speed.
		STA $5C
		RTS
	
	PC3_JumpThenMove:
		LDX #$0A
		JSL PCWalkingSpeed ;Load routine that determines each PC's walking speed.
		STA $5C
		RTS
	
	PC4_JumpThenMove:
		LDX #$0A
		JSL PCWalkingSpeed ;Load routine that determines each PC's walking speed.
		STA $5C
		RTS
}

;*********************************************************************************
;Loads PC's walking speed
;*********************************************************************************
PCWalkingSpeed: ;Routine that determines the walking speed of each PC.
{
	STX $0010
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCWalkingSpeedPointers,x)
	RTL

	PCWalkingSpeedPointers:
		dw X_WalkingSpeed
		dw Zero_WalkingSpeed
		dw PC3_WalkingSpeed
		dw PC4_WalkingSpeed
		db $FF,$FF
		db $FF,$FF
	
	
	X_WalkingSpeed:
		REP #$20
		LDX $0010
		LDA $B326,x ;Load location to get base speed of walk/dashing/jumping etc..
		STA $5C ;Base speed when jump then move
		RTS
	
	Zero_WalkingSpeed:
		REP #$20
		LDX $0010
		LDA $B326,x ;Load location to get base speed of walk/dashing/jumping etc..
		STA $0010
		LDA !RideChipsOrigin_7E1FD7
		AND #$00F0
		CMP #$00F0
		BEQ ZeroFasterWalk
		LDA $0010
		BRA ZeroWalkEnd
		
		ZeroFasterWalk:
		LDA $0010
		CLC
		ADC #$0060
		
		ZeroWalkEnd:
		STA $5C ;Base speed when jump then move
		RTS
		
	PC3_WalkingSpeed:
		REP #$20
		LDX $0010
		LDA $B326,x ;Load location to get base speed of walk/dashing/jumping etc..
		STA $5C ;Base speed when jump then move
		RTS	
	
	PC4_WalkingSpeed:
		REP #$20
		LDX $0010
		LDA $B326,x ;Load location to get base speed of walk/dashing/jumping etc..
		STA $5C ;Base speed when jump then move
		RTS
}
		
;*********************************************************************************
;Loads PC's jumping hitbox
;*********************************************************************************
PCJumpHeight: ;Routine that sets the maximum jump hitbox for each PC.
{
	SEP #$30
	STX $0010
	LDX !CurrentPC_0A8E
	JSR (PCJumpHeightPointers,x)
	RTL

	PCJumpHeightPointers:
		dw X_JumpHeight
		dw Zero_JumpHeight
		dw PC3_JumpHeight
		dw PC4_JumpHeight
		db $FF,$FF
		db $FF,$FF
	
	
	X_JumpHeight:
		LDX $0010
		REP #$10
		LDA #$40
		STA $09F6
		RTS
	
	Zero_JumpHeight:
		LDX $0010
		REP #$10
		LDA !RideChipsOrigin_7E1FD7
		AND #$F0
		CMP #$F0
		BEQ ZeroHigherJump
		LDA #$40
		BRA ZeroJumpEnd
		
		ZeroHigherJump:
		LDA #$38
		
		ZeroJumpEnd:
		STA $09F6
		RTS
	
	PC3_JumpHeight:
		LDX $0010
		REP #$10
		LDA #$40
		STA $09F6
		RTS
	
	PC4_JumpHeight:
		LDX $0010
		REP #$10
		LDA #$40
		STA $09F6
		RTS
}
		
;*********************************************************************************
;Loads PC's dash then jump speed
;*********************************************************************************
PCDashJump:	;Routine that sets dash then jump speed for each PC.
{
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PCDashJumpPointers,x)
	RTL

	PCDashJumpPointers:
		dw X_DashJump
		dw Zero_DashJump
		dw PC3_DashJump
		dw PC4_DashJump
		db $FF,$FF
		db $FF,$FF
	
	
	X_DashJump:
		LDX #$3C
		JSL PCStartWalkingDashDistanceSpeed
		RTS
	
	Zero_DashJump:
		JSR X_DashJump
		RTS
	
	PC3_DashJump:
		JSR X_DashJump
		RTS
	
	PC4_DashJump:
		JSR X_DashJump
		RTS
}
	
;*********************************************************************************
; Loads check for bosses defeated on Stage Select
;*********************************************************************************
CheckBossesDefeated:
{
	ASL $00
	LDA !BossesDefeated1_7EF4E2 ;Loads !BossesDefeated1_7EF4E2 to check how many bosses have been defeated
	BIT !BasicBITTable,x ;Loads a generic bit table to check which bosses have been defeated
	BEQ BossesDefeatedSkipIncrease
	LDA #$01
	TSB $00
	INC $01
BossesDefeatedSkipIncrease:
	DEX
	BPL CheckBossesDefeated
	
	LDA $00
	CMP #$FF
	RTL
}


;*********************************************************************************
; Routine to check if Frog Armor is underwater or not. If not, allow it to perform a proper dash.
;*********************************************************************************
RideArmors_DashingCheck:
{
	LDA $4B ;Loads current Ride Armor type
	CMP #$03 ;Checks if Frog Armor
	BNE RideArmors_DashingCheck_IsNotUnderWater ;If not, completely ignore underwater swim check.

	LDA $1F53 ;BIT to determine if Armor is underwater or not
	BIT #$01
	BEQ RideArmors_DashingCheck_IsNotUnderWater
	LDA #$00 ;This will allow it to swim underwater if it's underwater.
	RTL
	
	RideArmors_DashingCheck_IsNotUnderWater: ;This allows Armors to dash when not in water.
	LDA #$01
	RTL
}



;*********************************************************************************
; Store sub-weapons to PC after defeating a boss
;*********************************************************************************
BossDefeated: ;Loads RAM to store bosses being defeated.
{
	LDX !CurrentLevel_1FAE
	LDA BossDefeatedTable,x
	ORA !BossesDefeated1_7EF4E2
	STA !BossesDefeated1_7EF4E2
	LDA #$08
	STA $D2
	RTL
}

BossDefeatedStoreSubWeapon: ;Load routine that stores the bosses sub-weapon to the shared routine and each split PC.
{
		LDA !CurrentPCCheck_1FFF
		ASL #3
		STA $0002
		ASL A
		CLC
		ADC $0002
		STA $0002

		LDX !CurrentLevel_1FAE
		LDA BossSingleByteTable,x
		TAX
		CLC
		ADC $0002
		TAY
		LDA #$1C
		JSL StorePCSplitSubWeapon ;Load routine that stores sub-weapon to whichever PC is being played
		TYX
		STA !PCSubWeaponsBase_7EF403,x
		RTL
}
			

;*********************************************************************************
; Check whether you have sub-weapons and modifying routines so sub-weapon life is 00-1C (Set to C0 if empty)
;*********************************************************************************
SubWeaponSwitchCheckIfHave: ;Load routine to check if PC has the current sub-weapon being switched to.
{
	LDX !CurrentPCSubWeapon_0A0B
	JSL LoadPCSplitSubWeapon
	BNE LoadSubWeaponIfHave
	RTL
LoadSubWeaponIfHave:
	LDA #$01
	RTL
}
	
;*********************************************************************************
; Load sub-weapon icon when leaving menu
;*********************************************************************************
CurrentSubWeaponDouble: ;Routine that doubles the value of the current sub-weapon PC has equipped.
{
	LDA !CurrentPCSubWeapon_0A0B
	ASL
	CLC
	RTL
}
	
;*********************************************************************************
;*********************************************************************************
; Load proper sub-weapon life location for PC splitting
;*********************************************************************************
LoadPCSplitSubWeapon: ;Routine that loads PC's sub-weapon depending on who defeated what boss.
{
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE SplitLoadPCSubWeapon
	LDA !SubWeap_1FBA,x
	RTL
	
SplitLoadPCSubWeapon:
	STX $0010
	LDA !CurrentPC_0A8E
	ASL #3
	STA $0012
	ASL A
	CLC
	ADC $0012
	CLC
	ADC $0010
	TAX
	LDA !PCSubWeaponsBase_7EF403,x
	PHA
	LDX $0010
	PLA
	RTL
}
	
StorePCSplitSubWeapon: ;Routine that stores PC's sub-weapon depending on who defeated what boss.
{
	PHA
	LDA !Difficulty_7EF4E0
	BIT #$01
	BNE SplitStorePCSubWeapon
	PLA
	STA !SubWeap_1FBA,x
	RTL
	
SplitStorePCSubWeapon:
	STX $0010
	LDA !CurrentPC_0A8E
	ASL #3
	STA $0012
	ASL A
	CLC
	ADC $0012
	CLC
	ADC $0010
	TAX
	PLA
	STA !PCSubWeaponsBase_7EF403,x
	LDX $0010
	RTL
}
;*********************************************************************************
;*********************************************************************************
; Routine to play Triad Thunder SFX at proper time since events were altered heavily.
;*********************************************************************************
TriadThunderSFX: ;Routine to play Triad Thunder SFX since the coding was heavily altered.
{
	JSL $84C0F7
	LDA #$28
	JSL !PlaySFX
	RTL	
}
	
;*********************************************************************************
;Store's armor value when capsule animation is done
;*********************************************************************************
StoreCapsuleValue: ;Routine that stores capsule part to X in his new RAM location.
{
	LDA !XArmorsByte1_7EF418
	STA $0010
	LDA $86BBFD,x
	TSB $0010
	LDA $0010
	STA !XArmorsByte1_7EF418
	STZ !DisablePCCharging_0A54
	RTL
}

;*********************************************************************************
;Loads armor value for X in various circumstances
;*********************************************************************************
LoadXNewArmorValue: ;Routine that loads X's new armor value
{
	LDA !XArmorsByte1_7EF418
	RTL
}
	
AndXNewArmorValue: ;Routine that ANDS X's new armor value
{
	AND !XArmorsByte1_7EF418
	RTL
}
	
;*********************************************************************************
;Loads armor value for X in Pink Capsules and disables Pink Capsules from not giving armor
;*********************************************************************************
UpdateRideChips: ;Routine that updates Ride Chips for any Pink Capsule you obtain. (Checks if you get the Buster Ride Chip, if so, do NOT blank out Hyper Charge value)
{
	LDA $BBFD,x
	STA $0000
	ORA !CurrentPCArmorOriginFull_7E1FD1
	STA !CurrentPCArmorOriginFull_7E1FD1
	LDA !RideChipsOrigin_7E1FD7
	AND #$0F
	ORA $0000
	STA !RideChipsOrigin_7E1FD7
	AND #$F0
	CMP #$20
	BEQ UpdateRideChipEnd
	CMP #$F0
	BCS UpdateRideChipEnd
	LDX #$09 ;Load Hyper Charge's RAM location
	
	LDA #$00 ;Load full sub-weapon health
	STA !SubWeap_1FBA,x ;Store to shared sub-weapon location
	STA !PCSubWeaponsBase_7EF403,x ;Store to X's sub-weapon location
UpdateRideChipEnd:
	RTL
}
	
;*********************************************************************************
;Rewrites most of Capsule routine to remove various checks for the Golden Armor
;Also rewritten to fix an issue with loading X's original location for armor parts
;*********************************************************************************
GoldenArmorCheck: ;Routine that checks various circumstances to see if the Golden Armor capsule will load or not.
{
	REP #$20
	JSL PCCombineHeartTanks
	AND #$00FF
	CMP #$00FF
	BCS CheckForSubTanks
	BRA GoldenArmorCheckFail
	
	CheckForSubTanks:
	JSL PCCombineSubTanks
	AND #$00FF
	CMP #$00F0
	BCS CheckForArmor
	BRA GoldenArmorCheckFail
	
	CheckForArmor:
	SEP #$20
	LDA !XArmorsByte1_7EF418
	CMP #$0F
	BCC GoldenArmorCheckFail
	
	LDA !RideChipsOrigin_7E1FD7
	CMP #$0F
	BNE GoldenArmorCheckFail
	
	LDA !CurrentHealth_09FF
	AND #$7F
	JSL HealthCompare
	BNE GoldenArmorCheckFail

GoldenArmorCheckEnd:
	SEP #$20
	RTL
	
GoldenArmorCheckFail:
	SEP #$20
	JML !CommonEventEnd
}
	
;*********************************************************************************
; Stores Hyper Charge value to proper RAM area when obtaining Arm Chip capsule/Golden Armor capsule
;*********************************************************************************
StoreHyperCharge: ;Routine that stores Hyper Charge properly into new sub-weapon location based on whether you get the Arm Chip or the Golden Armor Capsule.
;If you obtain any other Chip capsule, it will remove the Hyper Charge.
{
	LDX #$09 ;Load Hyper Charge's RAM location
	
	LDA #$1C ;Load full sub-weapon health
	STA !SubWeap_1FBA,x ;Store to shared sub-weapon location
	STA !PCSubWeaponsBase_7EF403,x ;Store to X's sub-weapon location
	RTL
}
	
;*********************************************************************************
; Sets data for in-game dialogue and miscellaneous menu data including sub-weapon icons, ammo bars, text, and coordinates. Also PC Menu VRAM graphics and other things.
;*********************************************************************************
DialogueSetup: ;Routine that sets dialogue location for each PC so they can have individual code. (32 bytes each)
{
	STX $0014
	SEP #$20
	LDX !CurrentPCCheck_1FFF
	JSR (PCDialogueSetupPointers,x)
	RTL
		
		PCDialogueSetupPointers:
			dw X_DialogueSetup
			dw Zero_DialogueSetup
			dw PC3_DialogueSetup
			dw PC4_DialogueSetup
			db $FF,$FF
			db $FF,$FF

	
		X_DialogueSetup: ;X's dialogue setup
			LDX $0014
			LDA !X_DialogueBank
			STA $8F
			REP #$20
			LDA !X_DialoguePointers,x
			STA $8D
			RTS
			
		Zero_DialogueSetup: ;Zero's dialogue setup
			LDX $0014
			LDA !Zero_DialogueBank
			STA $8F
			REP #$20
			LDA !Zero_DialoguePointers,x
			STA $8D
			RTS
			
		PC3_DialogueSetup: ;PC #3's dialogue setup
			LDX $0014
			LDA !PC3_DialogueBank
			STA $8F
			REP #$20
			LDA !PC3_DialoguePointers,x
			STA $8D
			RTS
			
		PC4_DialogueSetup: ;PC #4's dialogue setup
			LDX $0014
			LDA !PC4_DialogueBank
			STA $8F
			REP #$20
			LDA !PC4_DialoguePointers,x
			STA $8D
			RTS
}
			
PCSubWeapTextXYCoord: ;Routine that loads each PC's sub-weapon name X/Y coordinates
{
	STX $0004
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCSubWeapTextXYCoordPointers,x)
	RTL

	PCSubWeapTextXYCoordPointers:
		dw X_SubWeapTextXYCoord
		dw Zero_SubWeapTextXYCoord
		dw PC3_SubWeapTextXYCoord
		dw PC4_SubWeapTextXYCoord
		db $FF,$FF
		db $FF,$FF
		
	
		X_SubWeapTextXYCoord: ;X's sub-weapon text coordinates/text pointers
			REP #$20
			LDX $0004
			TXA
			ASL
			TAX
			LDA XSubTextCoord,x ;Load coordinates of sub-weapon text
			STA $2116
			STA $0601,y
			LDA !X_SubStringPointer,x ;Load pointer to sub-weapon text
			STA $8D
			SEP #$20
			LDA #$AB ;Bank of sub-weapon text
			STA $8F
			RTS
			
		Zero_SubWeapTextXYCoord: ;Zero's sub-weapon text coordinates/text pointers
			REP #$20
			LDX $0004
			TXA
			ASL
			TAX
			LDA ZeroSubTextCoord,x ;Load coordinates of text
			STA $2116
			STA $0601,y
			LDA !Zero_SubStringPointer,x ;Load pointers to sub-weapon text
			STA $8D
			SEP #$20
			LDA #$AB ;Bank of sub-weapon text
			STA $8F
			RTS
			
		PC3_SubWeapTextXYCoord: ;PC3's sub-weapon text coordinates/text pointers
			REP #$20
			LDX $0004
			TXA
			ASL
			TAX
			LDA PC3SubTextCoord,x ;Load coordinates of text
			STA $2116
			STA $0601,y
			LDA !PC3_SubStringPointer,x ;Load pointers to sub-weapon text
			STA $8D
			SEP #$20
			LDA #$AB ;Bank of sub-weapon text
			STA $8F
			RTS
			
		PC4_SubWeapTextXYCoord: ;PC4's sub-weapon text coordinates/text pointers
			REP #$20
			LDX $0004
			TXA
			ASL
			TAX
			LDA PC4SubTextCoord,x ;Load coordinates of text
			STA $2116
			STA $0601,y
			LDA !PC4_SubStringPointer,x ;Load pointers to sub-weapon text
			STA $8D
			SEP #$20
			LDA #$AB ;Bank of sub-weapon text
			STA $8F
			RTS
}
	
PCSubWeapIconGraphicSetup: ;Routine that sets sub-weapon icon graphic and X/Y coordinates for each PC
{
	STX $0004
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCSubWeapIconGraphicSetupPointers,x)
	RTL

	PCSubWeapIconGraphicSetupPointers:
		dw X_SubWeapIconGraphicSetup
		dw Zero_SubWeapIconGraphicSetup
		dw PC3_SubWeapIconGraphicSetup
		dw PC4_SubWeapIconGraphicSetup
		db $FF,$FF
		db $FF,$FF
		
	
		X_SubWeapIconGraphicSetup:
			REP #$20
			LDX $0004
			TXA
			ASL
			TAX
			LDA XSubIconCoord,x
			STA $2116
			STA $10
			STA $0601,y
			CLC
			ADC #$0020
			STA $0609,y
			LDA XSubIconGraph,x
			ORA $0002
			RTS
			
		Zero_SubWeapIconGraphicSetup:
			REP #$20
			LDX $0004
			TXA
			ASL
			TAX
			LDA ZeroSubIconCoord,x
			STA $2116
			STA $10
			STA $0601,y
			CLC
			ADC #$0020
			STA $0609,y
			LDA ZeroSubIconGraph,x
			ORA $0002
			RTS
			
		PC3_SubWeapIconGraphicSetup:
			REP #$20
			LDX $0004
			TXA
			ASL
			TAX
			LDA PC3SubIconCoord,x
			STA $2116
			STA $10
			STA $0601,y
			CLC
			ADC #$0020
			STA $0609,y
			LDA PC3SubIconGraph,x
			ORA $0002
			RTS
			
		PC4_SubWeapIconGraphicSetup:
			REP #$20
			LDX $0004
			TXA
			ASL
			TAX
			LDA PC4SubIconCoord,x
			STA $2116
			STA $10
			STA $0601,y
			CLC
			ADC #$0020
			STA $0609,y
			LDA PC4SubIconGraph,x
			ORA $0002
			RTS
}	
	
PCSubWeapAmmoXYCoord: ;Routine that loads each PC's sub-weapon ammo bar X/Y coordinates.
{
	STX $0006
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCSubWeapBarAmmoXYCoordPointers,x)
	RTL

	PCSubWeapBarAmmoXYCoordPointers:
		dw X_SubWeapBarAmmoXYCoord
		dw Zero_SubWeapBarAmmoXYCoord
		dw PC3_SubWeapBarAmmoXYCoord
		dw PC4_SubWeapBarAmmoXYCoord
		db $FF,$FF
		db $FF,$FF
		
		
		X_SubWeapBarAmmoXYCoord:
			REP #$20
			LDX $0006
			TXA
			ASL
			TAX
			LDA XLifeBarCoord,x
			STA $2116
			STA $0601,y
			SEP #$20
			RTS
			
		Zero_SubWeapBarAmmoXYCoord:
			REP #$20
			LDX $0006
			TXA
			ASL
			TAX
			LDA ZeroLifeBarCoord,x
			STA $2116
			STA $0601,y
			SEP #$20
			RTS
			
		PC3_SubWeapBarAmmoXYCoord:
			REP #$20
			LDX $0006
			TXA
			ASL
			TAX
			LDA PC3LifeBarCoord,x
			STA $2116
			STA $0601,y
			SEP #$20
			RTS
			
		PC4_SubWeapBarAmmoXYCoord:
			REP #$20
			LDX $0006
			TXA
			ASL
			TAX
			LDA PC4LifeBarCoord,x
			STA $2116
			STA $0601,y
			SEP #$20
			RTS
}
	
PCVRAMGraphicsMenu: ;Routine to setup PC's VRAM data upon menu load
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCGraphics_VRAMMenuPointers,x)
	RTL

	PCGraphics_VRAMMenuPointers:
		dw X_Graphics_VRAMMenu
		dw Zero_Graphics_VRAMMenu
		dw PC3_Graphics_VRAMMenu
		dw PC4_Graphics_VRAMMenu
		db $FF,$FF
		db $FF,$FF
		

		X_Graphics_VRAMMenu:
			LDA #$AA
			STA $18
			RTS
			
		Zero_Graphics_VRAMMenu:
			LDA #$AE
			STA $18
			RTS

		PC3_Graphics_VRAMMenu:
			LDA #$B0
			STA $18
			RTS
			
		PC4_Graphics_VRAMMenu:
			LDA #$B0
			STA $18
			RTS
}
	
PC1UpMenuIconSetup: ;Routine that sets each PC's 1-up Graphics, Sprite Assembly, Animation data, VRAM slot, X/Y coordinates and palette.
{
	SEP #$20
	STX $0010
	LDX !CurrentPC_0A8E
	JSR (PC1UpMenuIconPointers,x)
	RTL

	PC1UpMenuIconPointers:
		dw X_1UpMenuIcon
		dw Zero_1UpMenuIcon
		dw PC3_1UpMenuIcon
		dw PC4_1UpMenuIcon
		db $FF,$FF
		db $FF,$FF
		

	X_1UpMenuIcon:
		LDX $0010
		PEA $18B8
		PLD
		LDA $01
		BNE X1UpMenuIconEnd
		LDA #$20 ;Palette
		STA $11
		STZ $12
		STZ $18
		LDA #$11 ;Sprite Assembly
		STA $16
		
		LivesMenuCommonCode:
		LDA #$00 ;Which animation
		JSL $84B967
		
		REP #$20
		LDA !ZSaberObtained_1FB2
		BIT #$0001
		BNE X_1UpMenuIcon_DisplayHigherCoordinate
		BIT #$0040
		BNE X_1UpMenuIcon_DisplayHigherCoordinate
		
		X_1UpMenuIcon_DisplayLowerCoordinate:
		LDA #$0027 ;X coordinates
		STA $08
		BRA X_1UpMenuIcon_SetCoordinates
		
		X_1UpMenuIcon_DisplayHigherCoordinate:
		LDA #$002F ;Y Coordinates
		STA $08
		
		X_1UpMenuIcon_SetCoordinates:
		LDA #$009C ;X coordinates
		STA $05
		SEP #$20
		
		X1UpMenuIconEnd:
		JSL $82D636
		RTS
	
	Zero_1UpMenuIcon:
		LDX $0010
		PEA $18B8
		PLD
		LDA $01
		BNE Zero1UpMenuIconEnd
		LDA #$22 ;Palette
		STA $11
		STZ $12
		STZ $18
		LDA #$D8 ;Sprite Assembly
		STA $16
		JSR LivesMenuCommonCode
		BRA Zero1UpMenuTotalEnd
		
		Zero1UpMenuIconEnd:
		JSL $82D636
		
		Zero1UpMenuTotalEnd:
		RTS
		
	PC3_1UpMenuIcon:
		LDX $0010
		PEA $18B8
		PLD
		LDA $01
		BNE PC31UpMenuIconEnd
		LDA #$20
		STA $11
		STZ $12
		STZ $18
		LDA #$11
		STA $16
		JSR LivesMenuCommonCode
		BRA PC31UpMenuTotalEnd
		
		PC31UpMenuIconEnd:
		JSL $82D636
		
		PC31UpMenuTotalEnd:
		RTS
	
	PC4_1UpMenuIcon:
		LDX $0010
		PEA $18B8
		PLD
		LDA $01
		BNE PC41UpMenuIconEnd
		LDA #$20
		STA $11
		STZ $12
		STZ $18
		LDA #$11
		STA $16
		JSR LivesMenuCommonCode
		BRA PC41UpMenuTotalEnd
		
		PC41UpMenuIconEnd:
		JSL $82D636
		
		PC41UpMenuTotalEnd:
		RTS
}	
	
PC1UpMenuVRAMSetup: ;Sets Decompressed PC 1-up Icon VRAM in the menu
{
	SEP #$30
	LDX !CurrentPC_0A8E
	JSR (PC1UpMenuVRAMSetupPointers,x)
	RTL

	PC1UpMenuVRAMSetupPointers:
		dw X_1UpMenuVRAMSetup
		dw Zero_1UpMenuVRAMSetup
		dw PC3_1UpMenuVRAMSetup
		dw PC4_1UpMenuVRAMSetup
		db $FF,$FF
		db $FF,$FF
	
	
		X_1UpMenuVRAMSetup:
			LDY #$92
			JSL !LoadDecompressedGraphics_Long
			RTS
		
		Zero_1UpMenuVRAMSetup:
			LDY #$BC
			JSL !LoadDecompressedGraphics_Long
			RTS
		
		PC3_1UpMenuVRAMSetup:
			LDY #$92
			JSL !LoadDecompressedGraphics_Long
			RTS
		
		PC4_1UpMenuVRAMSetup:
			LDY #$92
			JSL !LoadDecompressedGraphics_Long
			RTS	
}
	
	
PC_ExitLevels:
{
	LDA !Difficulty_7EF4E0
	BIT #$10
	BEQ PC_ExitLevels_RegularGame
	LDA !CurrentLevel_1FAE
	BEQ PC_ExitLevels_CannotExit
	CMP #$09
	BEQ PC_ExitLevels_CannotExit
	CMP #$0D
	BEQ PC_ExitLevels_CannotExit
	RTL
	
	PC_ExitLevels_RegularGame:
	LDA !CurrentDopplerLevel_1FAF
	CMP #$04
	BEQ PC_ExitLevels_CannotExit ;Cannot exit level
	LDA !CurrentLevel_1FAE
	BEQ PC_ExitLevels_CannotExit ;Cannot exit level
	CMP #$09
	BCS PC_ExitLevels_CannotExit ;Cannot exit level
	
	LDX !CurrentLevel_1FAE
	LDA !BossesDefeated1_7EF4E2
	STA $0000
	LDA BossDefeatedTable,x
	BIT $0000
	BEQ PC_ExitLevels_CannotExit ;Cannot exit level
	RTL
	
	PC_ExitLevels_CannotExit:
	LDA #$5A
	JSL !PlaySFX
	LDA #$00
	RTL
}
	
RideChipMenuSetup: ;Routine that bit checks and loads Ride Chip X/Y coordinates
{
	REP #$30
	LDA #$0001 ;Bit test start
	STA $0000
	LDA #$16D8 ;RAM location start
	STA $0002
	STZ $0004 ;Counter for Chip X coordinates
	STZ $0006 ;Total counter for Ride Chips
	LDA #$00B0
	STA $0008 ;Base VRAM slot for Ride Chips
	
RideChipStartRoutine:
	LDA !RideChipsOrigin_7E1FD7
	AND #$00FF
	BIT $0000
	BEQ RideChipMenuSetupEnd
	LDA $0002
	TCD
	LDA $0008
	STA $18
	JSL $82D636
	
	LDX $0004
	LDA $9F9A,x ;Load X coordinates of Ride Chip
	STA $05
	STZ $06
	STZ $09
	LDA $9F9B,x ;Load Y coordinates
	STA $08
	LDA #$26
	STA $11
	STZ $12
	LDA #$10
	STA $16
	LDA #$00
	JSL $84B967


RideChipMenuSetupEnd:
	ASL $0000
	INC $0004
	INC $0004
	INC $0008
	INC $0008
	REP #$30
	LDA $0002
	CLC
	ADC #$0020
	STA $0002
	INC $0006
	LDA $0006
	CMP #$0004
	BNE RideChipStartRoutine
	SEP #$30
	RTL
}	
	
XArmorPiecesAndChips: ;Routine that bit checks and loads Armor Pieces X/Y coordinates
{
;10 - Helmet
;20 - Buster
;40 - Armor
;80 - Legs
		
	REP #$30
	LDA #$0010 ;Bit test start
	STA $0000
	LDA #$1778 ;RAM location start
	STA $0002
	STZ $0004 ;Counter for Chip X coordinates
	STZ $0006 ;Total counter for Armor Pieces
	LDA #$00B8
	STA $0008 ;Base VRAM slot for Armor Pieces
	
	XArmorPiecesAndChipsRoutine:
	SEP #$30
	LDA !RideChipsOrigin_7E1FD7
	CMP #$F0
	BCS XArmorPiecesAndChips_SkipCheckingChipTotal
	LDA !CurrentPCArmorOriginShort_1FD1
	BIT $0000
	BEQ XArmorPiecesAndChipsEnd
	
	XArmorPiecesAndChips_SkipCheckingChipTotal:
	REP #$30
	LDA $0002
	TCD
	LDA $0008
	STA $18
	JSL $82D636
	
	LDX $0004 ;Counter for coordinates
	LDA $9FBA,x ;Load X coordinates of Armor pieces
	STA $05
	STZ $06
	STZ $09
	LDA $9FBB,x ;Load Y coordinates of Armor pieces
	STA $08
	
	LDA !RideChipsOrigin_7E1FD7
	BIT $0000
	BEQ XArmorPiecesAndChips_DoNOTMakeGold
	LDA #$28 ;Palette of Armor pieces (Golden)
	BRA XArmorPiecesAndChips_StorePalette
	
	XArmorPiecesAndChips_DoNOTMakeGold:
	LDA #$20 ;Palette of Armor pieces (Regular)
	
	XArmorPiecesAndChips_StorePalette:
	STA $11
	STZ $12
	LDA #$10 ;Sprite Assembly of armor pieces
	STA $16
	LDA #$00
	JSL $84B967


	XArmorPiecesAndChipsEnd:
	ASL $0000
	INC $0004
	INC $0004
	INC $0008
	INC $0008
	REP #$30
	LDA $0002
	CLC
	ADC #$0020
	STA $0002
	INC $0006
	LDA $0006
	CMP #$0004
	BNE XArmorPiecesAndChipsRoutine
	SEP #$30
	RTL
}		
	
RideChipPalette: ;Routine that sets Ride Chips palette
{
	LDY #$F8 ;Load palette for Menu?
	JSL !PaletteAlternate
	
	REP #$10
	LDY #$0218 ;Load palette # for Ride Chips
	JSL !PaletteAlternate
	
	LDX #$0030
	LDY #$01B8 ;Load X's Golden Armor palette
	JSL !Palette
	RTL
}	
	
PCPortraitPaletteSetup: ;Routine that loads PC's portrait palettes in the menu.
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCPortraitPalettePointers,x)
	RTL

	PCPortraitPalettePointers:
		dw X_PortraitPalette
		dw Zero_PortraitPalette
		dw PC3_PortraitPalette
		dw PC4_PortraitPalette
		db $FF,$FF
		db $FF,$FF
	
	
	X_PortraitPalette:
		REP #$30
		LDA !RideChipsOrigin_7E1FD7
		AND #$00F0
		CMP #$00F0
		BNE SkipGoldArmor
		LDX #$0002 ;X's Golden Armor palette
		BRA EndZeroPortraitPalette
		
		SkipGoldArmor:
		LDX #$0000 ;X's normal palette
		
		EndZeroPortraitPalette:
		LDA #$007C ;X portrait sprite assembly
		STA $16
		LDA ZeroPortraitPalettePointers,x
		TAY
		RTS
		
	Zero_PortraitPalette:
		REP #$30
		LDA !RideChipsOrigin_7E1FD7
		AND #$00F0
		CMP #$00F0
		BNE SkipBlackArmor
		LDX #$0002 ;Zero's Black Armor palette
		BRA EndXPortraitPalette
		
		SkipBlackArmor:
		LDX #$0000 ;Zero's normal palette
		
		EndXPortraitPalette:
		LDA #$007B ;Zero portrait sprite assembly
		STA $16 
		LDA XPortraitPalettePointers,x
		TAY
		RTS
		
	PC3_PortraitPalette:
		REP #$30
		LDX #$0000 ;Load palette (NO CURRENT VALUE)
		LDA #$FFFF ;Sprite assembly (NO CURRENT VALUE)
		STA $16
		RTS
		
	PC4_PortraitPalette:
		REP #$30
		LDX #$0000 ;Load palette (NO CURRENT VALUE)
		LDA #$FFFF ;Sprite assembly (NO CURRENT VALUE)
		STA $16
		RTS
}		
	
Double1EE2: ;Routine that doubles current menu action you're doing to prevent game from crashing with new values.
{
	SEP #$30
	LDA $0A
	PHA
	CMP #$0A
	BCS IgnoreDoubleValue
	ASL
IgnoreDoubleValue:
	TAX
	PLA
	RTL
}	
	
PCSwapNoBar: ;Routine that does original code of playing SFX when switching characters but then disables the life bar as well so it does not appear on screen.
{
	LDA #$04
	STA $1F12
	LDA #$1D
	JSL !PlaySFX
	RTL	
}

PCMenu_1UpCounter: ;Routine that draws how many Heart Tanks you have in total
{
	LDA #$80
	STA $2115
	
	REP #$20
	LDA !ZSaberObtained_1FB2
	AND #$00FF
	BIT #$0001
	BNE PCMenu_1UpCounter_DisplayHigherCoordinatesTop
	BIT #$0040
	BNE PCMenu_1UpCounter_DisplayHigherCoordinatesTop
	
	PCMenu_1UpCounter_DisplayLowerCoordinatesTop:
	LDA #$5895 ;X/Y coordinates of 1-up Counter numbers (Top)
	STA $2116
	BRA PCMenu_1UpCounter_NextCoordinate
	
	PCMenu_1UpCounter_DisplayHigherCoordinatesTop:
	LDA #$58B5 ;X/Y coordinates of 1-up Counter numbers (Top)
	STA $2116
	
	PCMenu_1UpCounter_NextCoordinate:
	SEP #$20
	LDA $1FB4 ;Load 1-up total lives
	CLC
	ADC #$56
	STA $2118
	
	PHA
	LDA #$30
	STA $2119
	
	REP #$20
	LDA !ZSaberObtained_1FB2
	AND #$00FF
	BIT #$0001
	BNE PCMenu_1UpCounter_DisplayHigherCoordinatesBottom
	BIT #$0040
	BNE PCMenu_1UpCounter_DisplayHigherCoordinatesBottom
	
	PCMenu_1UpCounter_DisplayLowerCoordinatesBottom:
	LDA #$58B5 ;X/Y coordinates of 1-up Counter numbers (Top)
	STA $2116
	BRA PCMenu_1UpCounter_Finish
	
	PCMenu_1UpCounter_DisplayHigherCoordinatesBottom:
	LDA #$58D5 ;X/Y coordinates of 1-up Counter numbers (Top)
	STA $2116
	
	PCMenu_1UpCounter_Finish:
	SEP #$20
	PLA
	CLC
	ADC #$10
	STA $2118
	LDA #$30
	STA $2119
	RTL
}

;*********************************************************************************
; Various alterations for the Ride Armor pad in levels and some Ride Armor data
;*********************************************************************************		
RideArmorSelect: ;Routine that determines whether you can choose a ride armor or not on the pad.
{
	LDX $34
	LDA $9C76,x
	BIT !RideChipsOrigin_7E1FD7_Short
	BEQ InvalidRideArmor
	LDA #$10
	STA $03
	LDA #$11
	JSL !PlaySFX
	LDA #$01 ;Sets to go to the BRA to continue event
	RTL
InvalidRideArmor:
	LDA #$1F
	JSL !PlaySFX
	LDA #$00 ;Sets to jump to the end of routine
	RTL
}
		
RideArmor_SpritePriorities: ;Blanked out the other routine because Zero's sprites 'need' to be behind all armors due to his hair.
{
	LDA #$02
	STA $12
	RTL
	; LDA $4B
	; CMP #$02 ;Check for Hawk Armor
	; BNE RideArmor_SpritePriorities_SetBehind
	; LDA #$04
	; BRA RideArmor_SpritePriorities_StorePriority
	
	; RideArmor_SpritePriorities_SetBehind:
	; LDA #$02
	
	; RideArmor_SpritePriorities_StorePriority:
	; STA $12
	; RTL
}
;*********************************************************************************
; Triggers the new Mosquitus warning code to check current PC.
; Also sets layer properties in the menu now so it displays the weapons like it should.
; Also has new code that checks for X's Z-Saber in the menu so it properly displays the correct 'Dark' icon
;*********************************************************************************
MosquitusWarning_CheckPCS: ;Routine that checks PCs to determine who gets what warning and when
;Need to rewrite X's code later so when the BITS are properly setup for him, it'll give a warning to Zero to warn X to be careful
;This is for when Zero is able to get X's buster from Mosquitus damage and allows him to use his buster ALA X's X2 buster
{
	STX $0010
	SEP #$20
	LDA $0B
	BNE MosquitusWarning_CheckPC_NoWarning
	LDX !CurrentPC_0A8E
	JSR (MosquitusWarning_CheckPCSPointers,x)
	RTL
	
	MosquitusWarning_CheckPC_NoWarning:
	LDX $0010
	LDA #$00
	RTL

	MosquitusWarning_CheckPCSPointers:
		dw X_MosquitusWarning_CheckPCS
		dw Zero_MosquitusWarning_CheckPCS
		dw PC3_MosquitusWarning_CheckPCS
		dw PC4_MosquitusWarning_CheckPCS
		db $FF,$FF
		db $FF,$FF
		
	
		X_MosquitusWarning_CheckPCS:
		LDX $0010
		LDA !Difficulty_7EF4E0
		BIT #$10
		BEQ X_MosquitusWarning_CheckPCS_NoWarning
		LDA !ZSaberObtained_1FB2
		BIT #$80
		BEQ X_MosquitusWarning_CheckPCS_NoWarning
		LDA #$00 ;Set to #$02 and X will have a warning ONLY ON NG+
		BRA X_MosquitusWarning_CheckPCS_End
		
		X_MosquitusWarning_CheckPCS_NoWarning:
		LDA #$00
		
		X_MosquitusWarning_CheckPCS_End:
		RTS
		
		Zero_MosquitusWarning_CheckPCS:
		LDX $0010
		LDA !Difficulty_7EF4E0
		BIT #$10
		BEQ Zero_MosquitusWarning_CheckPCS_Warning
		LDA !ZSaberObtained_1FB2
		BIT #$80
		BEQ Zero_MosquitusWarning_CheckPCS_Warning
		LDA #$00
		BRA Zero_MosquitusWarning_CheckPCS_End
		
		Zero_MosquitusWarning_CheckPCS_Warning:
		LDA #$02
		
		Zero_MosquitusWarning_CheckPCS_End:
		RTS
		
		PC3_MosquitusWarning_CheckPCS:
		LDX $0010
		LDA #$00
		RTS
		
		PC4_MosquitusWarning_CheckPCS:
		LDX $0010
		LDA #$00
		RTS
}



MosquitusWarning: ;Loads routine that triggers the Mosquitus warning when about to enter the boss door
{
	LDA $1F5D
	CMP #$40
	BEQ MosquitusWarningEndRoutine
	LDA !CurrentPCCheck_1FFF
	EOR #$02
	STA !CurrentPCCheck_1FFF
MosquitusWarningEndRoutine:
	RTL
}

MosquitusWarningSetLayerProperties: ;Loads routine that sets Mosquitus warning Menu Layer properties and coordinates.
{
	BVC MosquitusWarningSetLayerProperties_IgnoreSettings
	LDA #$8D
	STA $00B5
	LDA #$FF
	STA $00B6
	
	MosquitusWarningSetLayerProperties_IgnoreSettings:
	RTL
}
	
	
XBusterCheckZSaber:
{
	LDA !CurrentPC_0A8E
	BNE XBusterCheckZSaber_SetIcons
	LDA !ZSaberObtained_1FB2
	BIT #$80
	BEQ XBusterCheckZSaber_SetIcons
	LDA $9F65,x
	CMP #$0A
	BNE XBusterCheckZSaber_SetIconSet
	LDA #$0D
	BRA XBusterCheckZSaber_SetIconSet
	
	XBusterCheckZSaber_SetIcons:
	LDA $9F65,x
	
	XBusterCheckZSaber_SetIconSet:
	TAX
	RTL
}

;***************************
; Load Zero/Zero Z-Saber sprite setup [Sprite assembly, VRAM data, hitbox and palette]
;***************************
ZeroSetup: ;Load Zero Sprite setup for PC NPC (Sprite Assembly, VRAM, hitbox and palette)
{
	SEP #$30
	LDA #$4A ;Zero sprite assembly
	STA !PCNPC_SpriteAssembly_16
	LDA #$02
	STA !PCNPC_VRAMByte_1FCB
	REP #$30
	BRA ZeroSpritehitbox
	
	ZeroZSaberSetup:
	SEP #$30
	LDA #$0A
	STA !PCNPC_VRAMByte_1FCB
	LDA #$4B ;Zero Z-Saber sprite assembly
	STA !PCNPC_SpriteAssembly_16
	REP #$30
	
	ZeroSpritehitbox:
	SEP #$30
	STZ !PCSpritePriority_09EA
	LDA #$FF ;Bit testing to determine direction of projectiles/objects from PC
	STA !PCNPC_UNKNOWN_10
	REP #$30
	LDA #$B40E ;hitbox of Zero
	STA !PCNPC_Hitbox_20
	JSL PCNPC_DirectionPaletteVRAM
	
	REP #$30
	LDA !RideChipsOrigin_7E1FD7
	AND #$00F0
	CMP #$00F0
	BEQ PCNPC_ZeroBlackArmor
	LDY #$00D0 ;Load Zero regular palette
	BRA PCNPC_ZeroLoadPalette
	
	PCNPC_ZeroBlackArmor:
	LDY #$0204 ;Load Zero Black Armor palette
	
	PCNPC_ZeroLoadPalette:
	JSL !Palette
	SEP #$30
	LDA #$FF ;???
	STA !PCNPC_UNKNOWN_45
	RTL
}
	
;***************************
; Load X/X Z-Saber sprite setup [Sprite assembly, VRAM data, hitbox and palette]
;***************************
XSetup: ;Load X Sprite setup for PC NPC (Sprite Assembly, VRAM, hitbox and palette)
{
	SEP #$30
	LDA #$00
	STA !PCNPC_VRAMByte_1FCB
	LDA !XArmorsByte1_7EF418
	BIT #$01
	BNE PCNPC_XHelmetRegular
	LDA #$00
	BRA StorePCNPC_XSpriteAssemblyRegular
	
	PCNPC_XHelmetRegular:
	LDA #$18 ;X sprite assembly with helmet piece obtained
	
	StorePCNPC_XSpriteAssemblyRegular:
	STA !PCNPC_SpriteAssembly_16
	REP #$30
	BRA XSpritehitbox
	
	XZSaberSetup:
	SEP #$30
	LDA #$08
	STA !PCNPC_VRAMByte_1FCB
	LDA !XArmorsByte1_7EF418
	BIT #$01
	BNE PCNPC_XHelmetZSaber
	LDA #$33
	BRA StorePCNPC_XSpriteAssemblyZSaber
	
	PCNPC_XHelmetZSaber:
	LDA #$34 ;X Z-Saber sprite assembly
	
	StorePCNPC_XSpriteAssemblyZSaber:
	STA !PCNPC_SpriteAssembly_16
	REP #$30
	
	XSpritehitbox:
	SEP #$30
	LDA #$01
	STA !PCSpritePriority_09EA
	LDA #$FF ;Bit testing to determine direction of projectiles/objects from PC
	STA !PCNPC_UNKNOWN_10
	REP #$30
	LDA #$B404 ;hitbox of X
	STA !PCNPC_Hitbox_20
	JSL PCNPC_DirectionPaletteVRAM
	
	REP #$30
	LDA !RideChipsOrigin_7E1FD7
	AND #$00F0
	CMP #$00F0
	BEQ PCNPC_XGoldenArmor
	LDY #$0100 ;Load X's regular palette
	BRA PCNPC_XLoadPalette
	
	PCNPC_XGoldenArmor:
	LDY #$01B8 ;Load X's Golden Armor palette
	
	PCNPC_XLoadPalette:
	JSL !Palette
	SEP #$30
	LDA #$FF ;???
	STA !PCNPC_UNKNOWN_45
	RTL
}
		
;***************************
; Sets data for Zero's Z-Saber
;***************************
ZSaberZeroSetup:  ;Load Zero's Z-Saber Sprite setup for PC NPC (Sprite Assembly, which Z-Saber type, VRAM, direction.)
{
	JSL !CheckMissileRoom
	BNE EndZeroZSaberSetup
	INC $0000,x
	LDA #$02 ;Set Z-Saber event to active
	STA $000A,x
	LDA #$82 ;Set Z-Saber storage type [80+ = NPC. 80 = X, 82 = Zero]
	STA $000B,x
	LDA #$06 ;Set Z-Saber VRAM location
	STA $0018,x
	LDA $11 ;Load PC NPC's direction and stores same value into Z-Saber
	AND #$70
	ORA #$0E
	STA $0011,x
	LDA !PCNPC_OnGround_2B
	BIT #$04
	BNE ZeroZSaberGround
	LDA #$07 ;Sprite assembly setup to use [00 = On Ground, 07 = In Air]
	BRA SkipZeroZSaberGround
	
	ZeroZSaberGround:
	LDA #$00 ;Sprite assembly setup to use [00 = On Ground, 07 = In Air]
	
	SkipZeroZSaberGround:
	STA $003C,x
	STA $1F44
	STZ $0012,x
	
	EndZeroZSaberSetup:
	RTL
}
	
;***************************
; Sets data for X's Z-Saber
;***************************
ZSaberXSetup:
{
	JSL !CheckMissileRoom
	BNE EndXZSaberSetup
	INC $0000,x
	LDA #$02 ;Set Z-Saber event to active
	STA $000A,x
	LDA #$80 ;Set Z-Saber storage type [80+ = NPC. 80 = X, 82 = Zero]
	STA $000B,x
	LDA #$08 ;Set Z-Saber VRAM location
	STA $0018,x
	LDA $11 ;Load PC NPC's direction and stores same value into Z-Saber
	AND #$70
	ORA #$0E
	STA $0011,x
	LDA !PCNPC_OnGround_2B
	BIT #$04
	BNE XZSaberGround
	LDA #$07 ;Sprite assembly setup to use [00 = On Ground, 07 = In Air]
	BRA SkipXZSaberGround
	
	XZSaberGround:
	LDA #$00 ;Sprite assembly setup to use [00 = On Ground, 07 = In Air]
	
	SkipXZSaberGround:
	STA $003C,x
	STA $1F44
	STZ $0012,x
	
	EndXZSaberSetup:
	RTL
}
	
;***************************
; Missile flickering
;***************************
MissileFlickering: ;Routine used as a timer that allows missiles to 'flicker' as a pseudo transparent effect
{
	REP #$10
	DEC $43 ;Used as a timer for missile flickering sometimes
	BNE noflicker
	LDA #$03
	STA $43
	LDX $3F
	LDA $0003,x
	EOR #$01
	STA $0003,x
	
	noflicker:
	SEP #$10
	RTL
}
		
;***************************
; Set PC NPC direction, palette slot and VRAM slot
;***************************	
PCNPC_DirectionPaletteVRAM: ;Load PC NPC palette storage INTO RAM
{
	LDA !PCNPC_PaletteDirection_11 ;This whole section sets where to store the palette into RAM
	AND #$000E
	SEC
	SBC #$0002
	AND #$000E
	ASL #3
	TAX
	
	;Set PC NPC palette selection FOR RAM then set VRAM
	LDA !PCXCoordinate_09DD
	SEC
	SBC !ScreenXCoordinate_1E5D
	CMP #$0080
	BMI SkipDirectionSprites
	LDA #$0040 ;Set palette/direction in RAM for PC NPC
	TSB !PCNPC_PaletteDirection_11
	
	SkipDirectionSprites:
	SEP #$30
	LDA #$30 ;Set VRAM area for PC NPC
	STA !PCNPC_VRAMSlot_18
	RTL
}
		
;***************************
; Various PC, NPC, enemy and objects falling velocity setup
;***************************
FallingVelocity: ;Common routine that sets up various PC, NPC, Enemy and objects falling velocity
{
	REP #$20
	LDA #$FA80
	CMP !PCNPC_Velocity_1C
	BMI SkipVelocityStorage
	STA !PCNPC_Velocity_1C
	
	SkipVelocityStorage:
	SEP #$20
	RTL
}
			
;***************************
; Sets data for X's X-Buster. X/Y coordinates, palette RAM slot, VRAM slot.
;***************************
BusterXSetup: ;Routine to set up X's Buster data (X/Y coordinates, palette RAM slot, VRAM slot, graphics)
{
	JSL !CheckMissileRoom
	BEQ BusterSetup
	
	EndBuster:
	SEP #$20
	RTL
	
	BusterSetup:	
	SEP #$20
	INC $0A0D ;Increase current missiles on screen
	LDA #$FF ;Used for bit testing with Buster X/Y coordinates
	STA !PCNPC_UNKNOWN_10
	STA $0010,x
	LDA #$03 ;Set missile to use
	STA $000A,x
	LDA #$00 ;Used to determine if it's Zero or X's buster (00 = X, 02 = Zero)
	STA $000B,x
	LDA #$01
	STA $003E,x
	STA !PCorPCNPC_Buster_7EF4EB
	;This MUST be set to 00 otherwise things will bug
	LDA #$28 ;Set Z-Saber palette RAM selection
	STA $0018,x
	LDA $11 ;Load PC NPC's direction and stores same value into Z-Saber
	AND #$70
	ORA #$06
	STA $0011,x
	LDA #$00 ;Sprite assembly setup to use
	STA $003C,x
	STA $1F44
	STZ $0012,x
	
	
	INC $0000,x ;Set missile to active
	STZ $0004
	REP #$20
	STX $000B
	LDA !PCNPC_CurrentFrame_17
	AND #$007F
	TAX
	LDA XSubWeapSingleByte,x
	AND #$00FF
	TAX
	TAY
	BEQ EndBuster
	LDA XSubWeapXCoord,x
	AND #$00FF
	BIT #$0080
	BEQ IgnoreYChange
	ORA #$FF00
	
	IgnoreYChange:
	STA $0002
	BIT $0003
	BMI SkipYStorage
	CLC
	ADC !PCNPC_YCoordinate_08
	LDX $000B
	STA $0008,x
	
	SkipYStorage:
	PHX
	TYX
	INX
	LDA XSubWeapXCoord,x
	AND #$00FF
	BIT #$0080
	BEQ IgnoreXChange
	ORA #$FF00
	
	IgnoreXChange:
	PLX
	BIT $0010,x
	BVC SkipXStorage
	EOR #$FFFF
	INC
	
	SkipXStorage:
	CLC
	ADC !PCNPC_XCoordinate_05
	STA $0005,x	
	
	SEP #$20
	LDA #$05
	JSL !PlaySFX
	RTL
}

;***************************
;***************************
; Splits PCs events up so they each can have their own custom events
;***************************
PCEventSplit: ;Routine that loads whose events get loaded up based on which PC you are. (This allows for all PCs to have their own custom events)
{
	SEP #$30
	STX $0000
	LDX !CurrentPC_0A8E
	JMP (PCEventSplitPointers,x)
	RTL
		
		PCEventSplitPointers:
			dw X_EventSplit
			dw Zero_EventSplit
			dw PC3_EventSplit
			dw PC4_EventSplit
			db $FF,$FF
			db $FF,$FF

		
		X_EventSplit:
			LDX $0000
			JML !ZeroMainEvents ;X load Zero
			
		Zero_EventSplit:
			LDX $0000
			JML !XMainEvents ;Zero load X
			
		PC3_EventSplit:
			LDX $0000
			JML !XMainEvents			
	
		PC4_EventSplit:
			LDX $0000
			JML !XMainEvents
}

;***************************
;***************************
; Determines if a PC or PC NPC is firing X-Buster level 1/2/3
;***************************
XBusterPCNPC_Level1_2:
{
	LDA !PCorPCNPC_Buster_7EF4EB
	BNE XBusterPCNPC_Level1_2IgnoreStorage
	LDA $09E9
	AND #$70
	ORA $0000
	STA $11
	STZ $30
	
	XBusterPCNPC_Level1_2IgnoreStorage:
	RTL
}

;***************************
;***************************
; Determines if a PC or PC NPC is firing X-Buster level 1/2/3
;***************************	
XBusterPCNPC_Level3:
{
	LDA !PCorPCNPC_Buster_7EF4EB
	BNE XBusterPCNPC_Level3IgnoreStorage
	LDA $09E9
	AND #$70
	ORA #$06
	STA $11
	
	XBusterPCNPC_Level3IgnoreStorage:
	RTL
}

;***************************
;***************************
; Determines if PC X or NPC X is on screen to display armor
; Writes new code to check if NPC X is on screen, if so, swap the sprite priority of the armor and X
; Might need to update this and add a new section of RAM where both PC and PC NPC X can wear armor at the same time on screen in case.
;***************************
CheckPCArmorValue: ;Routine that determines whether PC or PC NPC is wearing X's armor.
{
	LDA $0CC8
	BEQ CheckPCInstead
	LDA !CurrentPCAction_09DA
	CMP #$2C
	BEQ CheckPCInstead
	LDA !PCSpritePriority_09EA ;Check for PCNPC_ armor value set
	BNE PCNPC_XOnScreen
	
	CheckPCInstead:
	STZ !PCSpritePriority_09EA
	LDA !CurrentPC_0A8E
	BNE SetZeroFF
	BRA CheckValue01
	
	SetZeroFF:
	LDA #$FF
	STA $01
	
	CheckValue01:
	LDX $01
	BPL DisplayArmorCheck
	STZ $0E
	RTL
	
	DisplayArmorCheck:
	BNE DisplayArmorPC
	INC $01
	LDA $0B ;Load OAM base of Armors
	CLC
	ADC $10 ;Add additional OAM to armors
	STA $16 ;Store to Armor OAM setup
	
	DisplayArmorPC:
	LDA !PCVisibility_09E6
	STA $0E ;Armor visibility
	LDA $09EF ;PC's current frame
	STA $17
	LDA !PCPaletteDirection_09E9
	STA $11
	
	REP #$20
	LDA $09F0 ;PC VRAM Slot
	STA $18
	LDA !PCXCoordinate_09DD
	STA $05
	LDA !PCYCoordinate_09E0
	STA $08
	RTL
	
	PCNPC_XOnScreen:
	LDA $0B ;Load OAM base of armor
	BEQ PCNPC_XTestArmors00
	ASL #2
	BRA PCNPC_XStoreValue
	
	PCNPC_XTestArmors00:
	INC
	ASL
	
	PCNPC_XStoreValue:
	STA $001A
	LDA !XArmorsByte1_7EF418
	BIT $001A
	BNE PCNPC_XSetArmor
	LDA #$00 ;Load #$00 for Armor NOT to display
	BRA PCNPC_XStoreArmor
	
	PCNPC_XSetArmor:
	LDA #$01 ;Load #$01 for Armor Display
	
	PCNPC_XStoreArmor:
	STA $01 ;Store to $01 in Armor Setup so it displays active armor
	STA $0E ;Store to $0E so Armor is properly displayed
	
	LDA $0CDE
	CMP #$33
	BEQ PCNPC_XZSaber
	CMP #$34
	BEQ PCNPC_XZSaber
	LDA #$5D
	BRA PCNPC_XStorageSA
	
	PCNPC_XZSaber:
	LDA #$35 ;Sprite assembly of armor pieces with Z-Saber sprites
	
	PCNPC_XStorageSA:
	STA $10
	STA $16

	PCNPC_XSkipStorage:
	LDA $0B ;Load OAM base of Armors
	CLC
	ADC $10 ;Add additional OAM to armors
	STA $16 ;Store to Armor OAM setup
	
	LDA $0CDF ;PCNPC_ Current Frame
	STA $17
	LDA $0CD9 ;PCNPC_ Palette Direction
	STA $11
	
	REP #$20
	LDA $0CE0 ;PCNPC_ VRAM Slot
	STA $18
	LDA $0CCD ;PCNPC_ X Coordinate
	STA $05
	LDA $0CD0 ;PCNPC_ Y coordinate
	STA $08
	RTL	
}
	
SwapSpritePriority: ;Routine that swaps the sprite priority of PC Armor and PC Sprite.
{
	LDA !PCSpritePriority_09EA ;Check for PCNPC_ armor value set 
	BNE SwapXandArmor
	JSL $838F3F ;Load Armor Sprite data
	JSL $838FE2 ;Load PC Sprite data
	RTL
	
	SwapXandArmor:
	JSL $838FE2 ;Load PC Sprite data
	JSL $838F3F ;Load Armor Sprite data
	RTL	
}

;***************************
;***************************
; Routine that alters whether a PC displays an example of the capsule obtained or not.
;***************************
PCCapsuleExamples:
{
	SEP #$20
	TAX
	STX $0010
	LDX !CurrentPC_0A8E
	JSR (PCCapsuleExamplePointers,x)
	RTL
		
		PCCapsuleExamplePointers:
			dw X_CapsuleExample
			dw Zero_CapsuleExample
			dw PC3_CapsuleExample
			dw PC4_CapsuleExample
			db $FF,$FF
			db $FF,$FF

		
		X_CapsuleExample:
			LDX $0010
			LDA $CD09,x
			RTS
		
		Zero_CapsuleExample:
			LDX $0010
			LDA #$FF
			RTS
		
		PC3_CapsuleExample:
			LDX $0010
			LDA #$FF
			RTS
		
		PC4_CapsuleExample:
			LDX $0010
			LDA #$FF
			RTS
}
	
;***************************
;***************************
; Store extra sub-weapon healing to other sub-weapons if one is full
; This routine is slightly broken currently as it needs to check if the life is #$1C or #$5C
;***************************
RefillSubWeaponAmmo: ;Begin routine to heal sub-weapons when one is full
{
	PHP
	SEP #$20
	STZ $0002
	LDA $27
	STA $0000
	
	LDX #$01
	
	HealVariousSubWeaponsLoop:
	LDA #$1C
	STA $0004
	JSL LoadPCSplitSubWeapon
	BEQ HealVariousSubWeaponsIncreaseX
	CMP #$C0
	BEQ SetCurrentSubWeaponTo00
	
	CMP #$5C
	BEQ HealVariousSubWeaponsEndRoutine
	BIT #$40
	BEQ HealVariousSubWeaponsSet1Cto5CIgnore
	PHA
	LDA #$5C
	STA $0004
	PLA
	
	HealVariousSubWeaponsSet1Cto5CIgnore:	
	CMP $0004
	BCS HealVariousSubWeaponsIncreaseX
	
	HealVariousSubWeaponsBeginHealing:
	CLC
	ADC $0000
	CMP $0004
	BCC HealVariousSubWeaponSTZ0002
	
	SBC $0004
	STA $0000
	BEQ HealVariousSubWeaponsIgnoreSetBitToEndRoutine
	INC $0002
	
	HealVariousSubWeaponsIgnoreSetBitToEndRoutine:
	LDA $0004
	
	HealVariousSubWeaponsIgnoreSTA1C:
	JSL StorePCSplitSubWeapon
	
	LDA #$16
	JSL !PlaySFX
	
	LDA $0002
	BEQ HealVariousSubWeaponsEndRoutine
	
	HealVariousSubWeaponsIncreaseX:
	INX
	CPX #$09
	BEQ HealVariousSubWeaponsIncreaseX
	CPX #$10
	BNE HealVariousSubWeaponsLoop
	
	HealVariousSubWeaponsEndRoutine:
	PLP
	RTL

	HealVariousSubWeaponSTZ0002:
	STZ $0002
	BRA HealVariousSubWeaponsIgnoreSTA1C
	
	SetCurrentSubWeaponTo00:
	LDA #$00
	JSL StorePCSplitSubWeapon
	BRA HealVariousSubWeaponsBeginHealing
}
	
;*********************************************************************************
;Loads basis for new decompressed data pointers so it's outside of normal ROM space.
;*********************************************************************************	
NewDecompressedLocation:
{
	REP #$20
	TYX
	LDA DecompressedDataTable,x
	STA $10
	LDA #$00C8 ;Sets bank of pointers
	STA $12
	RTL
}
	
;*********************************************************************************
; Sets PC Get Weapon graphics, tile map and palette properly
;*********************************************************************************
PCGetWeaponGraphics: ;Routine that obtains PC's GET WEAPON graphics depending on which PC you are.
{
	SEP #$20
	STX $0002
	LDX !CurrentPCCheck_1FFF
	JSR (PCGetWeaponGraphicsPointers,x)
	RTL

	PCGetWeaponGraphicsPointers:
		dw X_GetWeaponGraphics
		dw Zero_GetWeaponGraphics
		dw PC3_GetWeaponGraphics
		dw PC4_GetWeaponGraphics
		db $FF,$FF
		db $FF,$FF
	
	
	X_GetWeaponGraphics:
		LDY #$34
		JSL $80F510 ;Load code location for jumping from one bank to another for COMPRESSED data
		LDX $0002
		RTS
		
	Zero_GetWeaponGraphics:
		SEP #$20
		LDY #$B2 ;Load new data for Zero's Get Weapon image
		JSL !LoadDecompressedGraphics_Long ;Load code location for jumping from one bank to another for DECOMPRESSED data
		LDX $0002
		RTS
		
	PC3_GetWeaponGraphics:
		SEP #$20
		LDY #$B2 ;Load new data for Zero's Get Weapon image
		JSL !LoadDecompressedGraphics_Long ;Load code location for jumping from one bank to another for DECOMPRESSED data
		LDX $0002
		RTS
		
	PC4_GetWeaponGraphics:
		SEP #$20
		LDY #$B2 ;Load new data for Zero's Get Weapon image
		JSL !LoadDecompressedGraphics_Long ;Load code location for jumping from one bank to another for DECOMPRESSED data
		LDX $0002
		RTS
}
PCGetWeaponTilemap: ;Routine that obtains PC's GET WEAPON tile map depending on which PC you are.
{
	SEP #$20
	STX $0002
	LDX !CurrentPCCheck_1FFF
	JSR (PCGetWeaponTilemapPointers,x)
	RTL

	PCGetWeaponTilemapPointers:
		dw X_GetWeaponTilemap
		dw Zero_GetWeaponTilemap
		dw PC3_GetWeaponTilemap
		dw PC4_GetWeaponTilemap
		db $FF,$FF
		db $FF,$FF
	
	
	X_GetWeaponTilemap:
		LDY #$58
		JSL $80F510 ;Load code location for jumping from one bank to another for COMPRESSED data

		LDX $0002
		RTS
		
	Zero_GetWeaponTilemap:
		LDY #$B4 ;Load new data for Zero's Get Weapon image
		JSL !LoadDecompressedGraphics_Long ;Load code location for jumping from one bank to another for DECOMPRESSED data
		LDX $0002
		RTS
		
	PC3_GetWeaponTilemap:
		LDY #$B4 ;Load new data for Zero's Get Weapon image
		JSL !LoadDecompressedGraphics_Long ;Load code location for jumping from one bank to another for DECOMPRESSED data
		LDX $0002
		RTS
		
	PC4_GetWeaponTilemap:
		LDY #$B4 ;Load new data for Zero's Get Weapon image
		JSL !LoadDecompressedGraphics_Long ;Load code location for jumping from one bank to another for DECOMPRESSED data
		LDX $0002
		RTS
}
PCGetWeaponPalette: ;Routine that gets palette for GET WEAPON PC image for each PC
{
	STX $0010
	SEP #$30
	LDX !CurrentPCCheck_1FFF
	JSR (PCGetWeaponPalettePointers,x)
	RTL

	PCGetWeaponPalettePointers:
		dw X_GetWeaponPalette
		dw Zero_GetWeaponPalette
		dw PC3_GetWeaponPalette
		dw PC4_GetWeaponPalette
		db $FF,$FF
		db $FF,$FF
	
	
	X_GetWeaponPalette:
		REP #$30
		LDX $0010 ;Load X's regular palette
		LDY #$0320
		LDA #$001F
		RTS
		
	Zero_GetWeaponPalette:
		REP #$30
		LDX #$F460 ;Hard load Zero's palette (Blue)
		LDY #$0320
		LDA #$001F
		MVN $0C00
		
		LDX #$F480 ;Hard load Zero's palette (Green)
		LDY #$0360
		LDA #$001F
		RTS
		
	PC3_GetWeaponPalette:
		REP #$30
		LDX $0010
		LDY #$0320
		LDA #$001F
		RTS
		
	PC4_GetWeaponPalette:
		REP #$30
		LDX $0010
		LDY #$0320
		LDA #$001F
		RTS
}
PCGetWeaponGatherPalette: ;Routine that loads the correct palette location for the Get Weapon and then stores it.
{
	STA $00CC
	STA $00CD
	
	PHB
	LDA $0D4F ;Loads current level from RAM using temp. address
	TAX
	LDA $9C6D,x
	REP #$30
	AND #$00FF
	ASL #5
	CLC
	ADC #$AA20
	TAX
	JSL PCGetWeaponPalette ;Loads routine that gets palette for GET WEAPON PC image for each PC
	MVN $0C80
	PLB
	SEP #$30
	LDA #$01
	STA $00A1 ;This triggers the palettes to change properly
	RTL
}	
PCGetWeaponMaxYCoordinate: ;Routine that sets the max Y coordinate for each PC before teleport finishes
{
	SEP #$20
	LDX !CurrentPCCheck_1FFF
	JSR (PCGetWeaponMaxYCoordinatePointers,x)
	RTL

	PCGetWeaponMaxYCoordinatePointers:
		dw X_GetWeaponMaxYCoordinate
		dw Zero_GetWeaponMaxYCoordinate
		dw PC3_GetWeaponMaxYCoordinate
		dw PC4_GetWeaponMaxYCoordinate
		db $FF,$FF
		db $FF,$FF
		
		
		X_GetWeaponMaxYCoordinate:
			REP #$20
			LDA #$00A0
			RTS
		
		Zero_GetWeaponMaxYCoordinate:
			REP #$20
			LDA #$009C
			RTS
			
		PC3_GetWeaponMaxYCoordinate:
			REP #$20
			LDA #$00A0
			RTS
			
		PC4_GetWeaponMaxYCoordinate:
			REP #$20
			LDA #$00A0
			RTS
		
}

;*********************************************************************************
; Sets X & Zero's X/Y coordinates properly on the Cliff Scene and the Credit Roll screen.
;*********************************************************************************
PCCliffSceneCoordinates: ;Sets PC's X/Y coordinates on the Cliff Scene
{
	SEP #$30
	LDX !CurrentPCCheck_1FFF
	JSR (PCCliffSceneCoordinatesPointers,x)
	RTL

	PCCliffSceneCoordinatesPointers:
		dw X_CliffSceneCoordinatesPointers
		dw Zero_CliffSceneCoordinatesPointers
		dw PC3_CliffSceneCoordinatesPointers
		dw PC4_CliffSceneCoordinatesPointers
		db $FF,$FF
		db $FF,$FF
	
	
	X_CliffSceneCoordinatesPointers:
		REP #$30
		LDA #$00A8
		STA !PCXCoordinate_09DD
		LDA #$00A0
		STA !PCYCoordinate_09E0

		LDA #$00D0
		STA $0CCD ;PCNPC X Coordinates
		LDA #$0098
		STA $0CD0 ; PCNPC Y Coordinates
		RTS
	
	Zero_CliffSceneCoordinatesPointers:
		REP #$30
		LDA #$00A8
		STA !PCXCoordinate_09DD
		LDA #$0098
		STA !PCYCoordinate_09E0

		LDA #$00D0
		STA $0CCD ;PCNPC X Coordinates
		LDA #$00A0
		STA $0CD0 ; PCNPC Y Coordinates
		RTS
		
	PC3_CliffSceneCoordinatesPointers:
		REP #$30
		LDA #$00A8
		STA !PCXCoordinate_09DD
		LDA #$00A0
		STA !PCYCoordinate_09E0

		LDA #$00D0
		STA $0CCD ;PCNPC X Coordinates
		LDA #$0098
		STA $0CD0 ; PCNPC Y Coordinates
		RTS
		
	PC4_CliffSceneCoordinatesPointers:
		REP #$30
		LDA #$00A8
		STA !PCXCoordinate_09DD
		LDA #$00A0
		STA !PCYCoordinate_09E0

		LDA #$00D0
		STA $0CCD ;PCNPC X Coordinates
		LDA #$0098
		STA $0CD0 ; PCNPC Y Coordinates
		RTS
}	
	
PCCreditRollCoordinates: ;Sets PC's X/Y coordinates on the Credit Roll scene
{
	SEP #$30
	LDX !CurrentPCCheck_1FFF
	JSR (PCCreditRollCoordinatesPointers,x)
	RTL

	PCCreditRollCoordinatesPointers:
		dw X_CreditRollCoordinates
		dw Zero_CreditRollCoordinates
		dw PC3_CreditRollCoordinates
		dw PC4_CreditRollCoordinates
		db $FF,$FF
		db $FF,$FF
	
	
		X_CreditRollCoordinates:
		REP #$30
		LDA #$00A8
		STA !PCXCoordinate_09DD
		LDA #$07B0
		STA !PCYCoordinate_09E0

		LDA #$00D0
		STA $0CCD ;PCNPC X Coordinates
		LDA #$07A8
		STA $0CD0 ; PCNPC Y Coordinates
		RTS
	
	Zero_CreditRollCoordinates:
		REP #$30
		LDA #$00A8
		STA !PCXCoordinate_09DD
		LDA #$07A8
		STA !PCYCoordinate_09E0

		LDA #$00D0
		STA $0CCD ;PCNPC X Coordinates
		LDA #$07B0
		STA $0CD0 ; PCNPC Y Coordinates
		RTS
		
	PC3_CreditRollCoordinates:
		REP #$30
		LDA #$00A8
		STA !PCXCoordinate_09DD
		LDA #$07B0
		STA !PCYCoordinate_09E0

		LDA #$00D0
		STA $0CCD ;PCNPC X Coordinates
		LDA #$07A8
		STA $0CD0 ; PCNPC Y Coordinates
		RTS
		
	PC4_CreditRollCoordinates:
		REP #$30
		LDA #$00A8
		STA !PCXCoordinate_09DD
		LDA #$07B0
		STA !PCYCoordinate_09E0

		LDA #$00D0
		STA $0CCD ;PCNPC X Coordinates
		LDA #$07A8
		STA $0CD0 ; PCNPC Y Coordinates
		RTS
}
	
;*********************************************************************************
; Checks for specific bosses being defeated to determine various data depending on when it's called
; Some of those routines are not used, they are there just in case for various instances they may be called
;*********************************************************************************
{
CheckForToxicSeaHorse:
	LDA !BossesDefeated1_7EF4E2
	BIT #$01
	RTL
CheckForBlastHornet:
	LDA !BossesDefeated1_7EF4E2
	BIT #$02
	RTL
	
CheckForVoltCatfish:
	LDA !BossesDefeated1_7EF4E2
	BIT #$04
	RTL
	
CheckForCrushCrawfish:
	LDA !BossesDefeated1_7EF4E2
	BIT #$08
	RTL
	
CheckForNeonTiger:
	LDA !BossesDefeated1_7EF4E2
	BIT #$10
	RTL
	
CheckForGravityBeetle:
	LDA !BossesDefeated1_7EF4E2
	BIT #$20
	RTL
	
CheckForBlizzardBuffalo:
	LDA !BossesDefeated1_7EF4E2
	BIT #$40
	RTL
	
CheckForTunnelRhino:
	LDA !BossesDefeated1_7EF4E2
	BIT #$80
	RTL
	
CheckGravityBeetleLevel:
	JSL CheckForBlastHornet
	RTL
	
CheckBlizzardBuffaloLevel:
	JSL CheckForVoltCatfish
	RTL
}

;*********************************************************************************
; Code checks in each boss to determine whether they'll spawn or not
;*********************************************************************************	
CheckBossesSpawnPerLevel:
{
	LDX !CurrentLevel_1FAE
	LDA !BossesDefeated1_7EF4E2 ;Load bosses defeated bit mask
	STA $0000 ;Store to temp. $0000 so it can be checked
	
	LDA BossDefeatedTable,x
	BIT $0000
	RTL
}
	
;*********************************************************************************
; Code at title screen to switch X to Zero, vice versa, to allow you to start the game as that character
; Code for general Title Screen data so another text string can be fit
;*********************************************************************************
TitleScreenSwitch:
{
	LDA !CurrentPCAction_09DA
	CMP #$76
	BEQ LoopAnimation
	LDA $AD ;Loads current key being pressed
	BIT #$20
	BEQ TitleScreenSwitchEnd
	
	STZ !CurrentPCSubAction_09DB
	LDA !CapsuleIntro_7EF4E4
	STA $0000
	LDA !CurrentPCCheck_1FFF
	CMP #$02
	BEQ TitleScreenSwitchToX
	
	TitleScreenSwitchToZero:
	LDA #$02
	TSB !CurrentPCCheck_1FFF
	LDA #$80
	TSB $0000
	LDA $0000
	STA !CapsuleIntro_7EF4E4
	BRA LoopAnimation
	
	TitleScreenSwitchToX:
	LDA #$02
	TRB !CurrentPCCheck_1FFF
	LDA #$80
	TRB $0000
	LDA $0000
	STA !CapsuleIntro_7EF4E4
	
	LoopAnimation:
	LDA !CurrentPCSubAction_09DB
	CMP #$06
	BNE TitleScreenSwitchIgnoreDrawText
	
	JSL PCTitleScreenDrawText
	
	TitleScreenSwitchIgnoreDrawText:
	LDA #$76
	STA !CurrentPCAction_09DA
	LDA #$24
	STA !CurrentHealth_09FF

	JSL $48000 ;Loads basis for X actions on the title screen
	
	LDA #$04
	STA !PCHealthBar_1F22
	
	LDA #$FF ;Sets title screen timer back to #$FF
	STA $003B
	
	JSL PCTitleScreenCoordinates
	LDA #$00 ;Sets 'A' to #$00 so you can't start game until switching is complete
	STZ $AD
	BRA TitleScreenSwitchTotalEnd
	
	TitleScreenSwitchEnd:
	LDA $AD
	BIT #08 ;Checks for 'Up' key to be moved
	
	TitleScreenSwitchTotalEnd:
	RTL
}
	
VariousTitleScreen:
{
	STZ $00E4
	STZ $00E6
	LDA #$08
	STA !PCHealthBar_1F22
	JSL PCTitleScreenDrawText
	JSL PCTitleScreenCoordinates
	RTL
}
	
PCTitleScreenDrawText: ;Routine used to draw which PC you can change to on title screen
{
	LDX !CurrentPCCheck_1FFF
	JSR (PCTitleScreenDrawTextPointers,x)
	STA !PCYCoordinate_09E0
	RTL

	PCTitleScreenDrawTextPointers:
		dw X_TitleScreenDrawText
		dw Zero_TitleScreenDrawText
		dw PC3_TitleScreenDrawText
		dw PC4_TitleScreenDrawText
		db $FF,$FF
		db $FF,$FF
	
	
		X_TitleScreenDrawText:
			LDA #$71
			JSL $80868D
			RTS
			
		Zero_TitleScreenDrawText:
			LDA #$70
			JSL $80868D
			RTS
			
		PC3_TitleScreenDrawText:
			LDA #$73
			JSL $80868D
			RTS
			
		PC4_TitleScreenDrawText:
			LDA #$72
			JSL $80868D
			RTS
}

PCTitleScreenCoordinates:
{
	LDX !CurrentPCCheck_1FFF
	JSR (PCTitleScreenCoordinatesPointers,x)
	STA !PCYCoordinate_09E0
	RTL

	PCTitleScreenCoordinatesPointers:
		dw X_TitleScreenCoordinates
		dw Zero_TitleScreenCoordinates
		dw PC3_TitleScreenCoordinates
		dw PC4_TitleScreenCoordinates
		db $FF,$FF
		db $FF,$FF
	
	
		X_TitleScreenCoordinates:
			LDX $3C ;Loads current option PC is on
			LDA $87F8,x
			RTS
		
		Zero_TitleScreenCoordinates:
			LDX $3C ;Loads current option PC is on
			LDA $97AF,x
			RTS
		
		PC3_TitleScreenCoordinates:
			LDX $3C ;Loads current option PC is on
			LDA $87F8,x
			RTS
		PC4_TitleScreenCoordinates:
			LDX $3C ;Loads current option PC is on
			LDA $87F8,x
			RTS
}

;*********************************************************************************
; Sets X/Y coordinates of the 'SHING' effect on the victory animation
;*********************************************************************************	
PCVictoryShingXCoordinate: ;Routine that sets X/Y coordinates of the 'SHING' effect on the victory animation
{
	STX $0000
	SEP #$30
	LDX !CurrentPCCheck_1FFF
	JSR (PCVictoryShingXCoordinatePointers,x)
	RTL

	PCVictoryShingXCoordinatePointers:
		dw X_VictoryShingXCoordinate
		dw Zero_VictoryShingXCoordinate
		dw PC3_VictoryShingXCoordinate
		dw PC4_VictoryShingXCoordinate
		db $FF,$FF
		db $FF,$FF
	
	
		X_VictoryShingXCoordinate:
			REP #$30
			LDX $0000
			LDA $05
			STA $0005,x
			RTS
		
		
		Zero_VictoryShingXCoordinate:
			REP #$30
			LDX $0000
			LDA !PCPaletteDirection_09E9
			AND #$00FF
			BIT #$0040
			BNE Zero_RedirectVictoryShingXCoordinate
			
			LDA $05
			CLC
			ADC #$0012
			STA $0005,x
			RTS
			
			Zero_RedirectVictoryShingXCoordinate:
			LDA $05
			SEC
			SBC #$0012
			STA $0005,x
			RTS
		
		
		PC3_VictoryShingXCoordinate:
			REP #$30
			LDX $0000
			LDA $05
			STA $0005,x
			RTS
			
		PC4_VictoryShingXCoordinate:
			REP #$30
			LDX $0000
			LDA $05
			STA $0005,x
			RTS
}

;*********************************************************************************
; All data related to 1-up icon rewriting. (Allows for each PC to have their own icon) (Enables/Disables them from appearing on screen based on circumstances by going through $7E:1518 [$7E:1522 specifically])
;*********************************************************************************
{
PC1Up_InGameIcon_SpriteAssembly:
{
	LDA !CurrentPCCheck_1FFF
	TAX
	JSR (PC1Up_InGameIcon_SpriteAssemblyPointers,x)
	RTL

	PC1Up_InGameIcon_SpriteAssemblyPointers:
		dw X_1Up_InGameIcon_SpriteAssembly
		dw Zero_1Up_InGameIcon_SpriteAssembly
		dw PC3_1Up_InGameIcon_SpriteAssembly
		dw PC4_1Up_InGameIcon_SpriteAssembly
		db $FF,$FF
		db $FF,$FF
	
	
	X_1Up_InGameIcon_SpriteAssembly:
		LDA #$11
		RTS
		
	Zero_1Up_InGameIcon_SpriteAssembly:
		LDA #$D8
		RTS
	
	PC3_1Up_InGameIcon_SpriteAssembly:
		LDA #$11
		RTS
		
	PC4_1Up_InGameIcon_SpriteAssembly:
		LDA #$11
		RTS
}
PC1UpIcon_CheckAndDisable: ;Disables the PC 1-up on screen when swapping characters
{
	REP #$30
	LDX #$1518 ;Load base RAM for all item objects
	
	PC1UpIcon_LoopPoint:
	LDA $7E000A,x ;Loads current item object
	AND #$00FF
	CMP #$0003 ;Check for 1-up icon (No idea why they use two separate values but they do)
	BEQ PC1UpIcon_Disable
	
		CMP #$0004 ;Check for 1-up icon (No idea why they use two separate values but they do)
		BEQ PC1UpIcon_Disable
			BRA PC1UpIcon_IgnoreDisable
	
	PC1UpIcon_Disable:
	SEP #$20
	LDA #$0C ;Loads sprite priority value as #$0C so the object is invisible
	STA $7E0012,x ;Store to sprite priority for item object
	
	PHX
	LDA #$00
	XBA
	JSL PC1Up_InGameIcon_SpriteAssembly
	PLX
	STA $7E0016,x ;Stores Sprite Assembly of 1-up icon into RAM
	
	PC1UpIcon_IgnoreDisable:
	REP #$30
	TXA
	CLC
	ADC #$0030
	TAX
	CPX #$1818
	BNE PC1UpIcon_LoopPoint
	
	SEP #$30
	RTL
}
PC1UpIcon_CheckAndEnable: ;Disables the PC 1-up on screen when swapping characters
{
	REP #$30
	LDX #$1518 ;Load base RAM for all item objects
	
	PC1UpIcon_EnableLoopPoint:
	LDA $7E000A,x ;Loads current item object
	AND #$00FF
	CMP #$0003 ;Check for 1-up icon (No idea why they use two separate values but they do)
	BEQ PC1UpIcon_Enable
	
		CMP #$0004 ;Check for 1-up icon (No idea why they use two separate values but they do)
		BEQ PC1UpIcon_Enable
			BRA PC1UpIcon_IgnoreEnable
	
	PC1UpIcon_Enable:
	SEP #$20
	LDA #$00
	STA $7E0012,x ;Store to sprite priority for item object
	
	PC1UpIcon_IgnoreEnable:
	REP #$30
	TXA
	CLC
	ADC #$0030
	TAX
	CPX #$1818
	BNE PC1UpIcon_EnableLoopPoint
	
	SEP #$30
	RTL
}

}
;*********************************************************************************
; Sets PC's height when they're teleporting in through PC swapping
;*********************************************************************************		
PCSwap_TeleportHeight:
{
	SEP #$20
	LDX !CurrentPC_0A8E
	JSR (PCSwap_TeleportHeightPointers,x)
	RTL

	PCSwap_TeleportHeightPointers:
		dw X_Swap_TeleportHeight
		dw Zero_Swap_TeleportHeight
		dw PC3_Swap_TeleportHeight
		dw PC4_Swap_TeleportHeight
		db $FF,$FF
		db $FF,$FF
	
	
	X_Swap_TeleportHeight:
		REP #$20
		LDA #$0008
		CLC
		ADC !PCYCoordinate_09E0
		STA !PCYCoordinate_09E0
		DEC
		STA $24 ;Stores to 7E:09FC
		RTS
		
	Zero_Swap_TeleportHeight:
		REP #$20
		LDA #$FFF8
		CLC
		ADC !PCYCoordinate_09E0
		STA !PCYCoordinate_09E0
		DEC
		STA $24 ;Stores to 7E:09FC
		RTS
		
	PC3_Swap_TeleportHeight:
		REP #$20
		LDA #$0008
		CLC
		ADC !PCYCoordinate_09E0
		STA !PCYCoordinate_09E0
		DEC
		STA $24 ;Stores to 7E:09FC
		RTS
		
	PC4_Swap_TeleportHeight:
		REP #$20
		LDA #$0008
		CLC
		ADC !PCYCoordinate_09E0
		STA !PCYCoordinate_09E0
		DEC
		STA $24 ;Stores to 7E:09FC
		RTS
}
	
;*********************************************************************************
; Resets various mid-boss damage timers when they spawn so comboing works properly
;*********************************************************************************
BossDoors_ClearVariousEnemyData:
{
	REP #$30
	LDX #$0D18
	
	BossDoors_StartClearing:
	STZ $0000,x ;Blanks out initiation value/current even
	STZ $0002,x ;Blanks out current sub-event/excess sub-event
	STZ $000E,x ;Blanks out ???
	STZ $0027,x ;Blanks out ???
	STZ $0037,x ;Blanks out damage timer
	TXA
	CLC
	ADC #$0040
	TAX
	CMP #$10D8
	BCC BossDoors_StartClearing
	SEP #$30
	RTL
}
	
;*********************************************************************************
; Creates a damage table switch value for Worm Seeker mid-boss in Neon Tiger's level
;*********************************************************************************	
WormSeeker_DamageTableSwitch:
{
	LDA #$60
	STA $37
	JSL BossCheckDisableZSaber
	RTL
}


;*********************************************************************************
; Various PC RAM combining routines
;*********************************************************************************
{
PCCombineHeartTanks:
	LDA !XHeartTank_7EF41C
	ORA !ZeroHeartTank_7EF44C
	ORA !PC3HeartTank_7EF47C
	ORA !PC4HeartTank_7EF4AC
	RTL
	
PCCombineSubTanks:
	LDA !XSubTankCollect_7EF41D
	ORA !ZeroSubTankCollect_7EF44D
	ORA !PC3SubTankCollect_7EF47D
	ORA !PC4SubTankCollect_7EF4AD
	RTL
}
	
;*********************************************************************************
; Crush Crawfish's platform. Has it's own check routine instead of sharing to prevent various crashes.
;*********************************************************************************
CrushCrawfish_Platform_DamageCheck:
{
	REP #$50
	STZ $30 ;This disables the platform from being invincible.
	LDA $27 ;Load platform's current life
	AND #$7F
	STA $27
	BEQ CrushCrawfish_Platform_LifeCheck
	LDA $30
	BNE CrushCrawfish_Platform_EndRoutine
	LDA $0E
	BEQ CrushCrawfish_Platform_EndRoutine
	
	LDX #$10D8 ;Loads base missile
	
	CrushCrawfish_Platform_Loop:
	SEP #$20
	LDA $0000,x
	BEQ CrushCrawfish_Platform_NextMissile
	LDA $0030,x
	BNE CrushCrawfish_Platform_NextMissile
	
	CrushCrawfish_Platform_LifeCheck:
	LDA $27 ;Load current life of platform
	BNE CrushCrawfish_Platform_SkipCheck
	INC $02
	INC $02
	LDA #$50 ;Delay timer before platform finishes exploding
	STA $34
	BRA CrushCrawfish_Platform_EndRoutine
	
	CrushCrawfish_Platform_SkipCheck:
	JSL $84CC5C
	BCC CrushCrawfish_Platform_NextMissile
	JML $84CEDC
	
	CrushCrawfish_Platform_NextMissile:
	REP #$21
	TXA
	ADC #$0040
	TAX
	CMP #$1318
	BCC CrushCrawfish_Platform_Loop
	
	CrushCrawfish_Platform_EndRoutine:
	SEP #$30
	LDA #$00
	RTL
}

;*********************************************************************************
; Altering Helmet Hologram routine so it reads from the same RAM values with a JSL routine instead of JSR
; The current RAM data at $7E:1FD1 and $7E:1FD4 will be temporarily stored somewhere else just to bypass this routine's mess then it'll store back after.
;*********************************************************************************
PC_HelmetHologram:
{
	INC $03
	INC $03
	
	LDA !CurrentPCArmorOriginShort_1FD1
	STA $0014
	LDA !HeartTankCollection_1FD4
	STA $0016
	
	JSL PCCombineHeartTanks
	BVS PC_HelmetHologram_StoreFF
	BRA PC_HelmetHologram_IgnoreFF
	
	PC_HelmetHologram_StoreFF:
	LDA #$FF
	
	PC_HelmetHologram_IgnoreFF:
	STA !HeartTankCollection_1FD4
	
	LDA !XArmorsByte1_7EF418
	STA !CurrentPCArmorOriginShort_1FD1
	
	JSL PCCombineSubTanks
	ORA !CurrentPCArmorOriginShort_1FD1
	STA !CurrentPCArmorOriginShort_1FD1
	
	JSL $849036
	
	LDA $0014
	STA !CurrentPCArmorOriginShort_1FD1
	LDA $0016
	STA !HeartTankCollection_1FD4
	
	RTL
}


;*********************************************************************************
; New code that loads the READY sprites for each PC and possibly writes their palettes into RAM as well.
;*********************************************************************************
{
PC_Ready_Sprites:
{
	SEP #$20
	LDA !CapsuleIntro_7EF4E4
	BIT #$80 ;Checks if you're using Zero on introduction or not
	BNE PC_Ready_Sprites_IsZeroIntro
	LDX !CurrentPCCheck_1FFF
	JSR (PC_Ready_SpritesPointers,x)
	RTL
	
	PC_Ready_Sprites_IsZeroIntro:
	LDX #$02
	JSR (PC_Ready_SpritesPointers,x)
	RTL

	PC_Ready_SpritesPointers:
		dw X_Ready_Sprites
		dw Zero_Ready_Sprites
		dw PC3_Ready_Sprites
		dw PC4_Ready_Sprites
		db $FF,$FF
		db $FF,$FF
	
	
	X_Ready_Sprites:
		REP #$30
		LDY #$0100
		JSL !PaletteAlternate
		SEP #$30
		LDY #$2A
		JSL $80B476 ;Loads routine to load COMPRESSED sprites from across bank
		RTS
	
	Zero_Ready_Sprites:
		REP #$30
		LDA !CurrentLevel_1FAE
		AND #$00FF
		BNE Zero_Ready_Sprites_LoadNormalReady
		LDX #$0050 ;Load RAM location to store palette
		LDY #$00D0
		JSL !Palette
		BRA Zero_Ready_Sprites_SetSprite
		
		Zero_Ready_Sprites_LoadNormalReady:
		REP #$30
		LDY #$00D0
		JSL !PaletteAlternate
		
		Zero_Ready_Sprites_SetSprite:
		SEP #$30
		LDA $09D9 ;Checks for PC being active on screen
		BNE Zero_Ready_Sprites_LoadLaterVRAM
		LDY #$C8
		BRA Zero_Ready_Sprites_LoadGraphics
		
		Zero_Ready_Sprites_LoadLaterVRAM:
		LDY #$CA
		
		Zero_Ready_Sprites_LoadGraphics:
		JSL !LoadDecompressedGraphics_Long
		RTS
	
	PC3_Ready_Sprites:
		REP #$20
		LDY #$0100
		JSL !PaletteAlternate
		SEP #$30
		LDY #$2A
		JSL $80B476 ;Loads routine to load COMPRESSED sprites from across bank
		RTS
	
	PC4_Ready_Sprites:
		REP #$20
		LDY #$0100
		JSL !PaletteAlternate
		SEP #$30
		LDY #$2A
		JSL $80B476 ;Loads routine to load COMPRESSED sprites from across bank
		RTS
}

PC_Ready_Sprites_Intro: ;Loads graphics setup for 'READY' text in INTRO STAGE ONLY!
{
	SEP #$20
	LDX !CurrentPCCheck_1FFF
	JSR (PC_Ready_Sprites_IntroPointers,x)
	RTL

	PC_Ready_Sprites_IntroPointers:
		dw X_Ready_Sprites_Intro
		dw Zero_Ready_Sprites_Intro
		dw PC3_Ready_Sprites_Intro
		dw PC4_Ready_Sprites_Intro
		db $FF,$FF
		db $FF,$FF
	
	
	X_Ready_Sprites_Intro:
		JSL $80B4FF
		RTS
	
	Zero_Ready_Sprites_Intro:
		JSL PC_Ready_Sprites
		JSL AllowBankSendToVRAM
		RTS
		
	PC3_Ready_Sprites_Intro:
		JSL $80B4FF
		RTS
	
	PC4_Ready_Sprites_Intro:
		JSL $80B4FF
		RTS
}

PC_Ready_Intro_Palette: ;Loads palette slot code for 'READY' text.
{
	SEP #$20
	LDX !CurrentPCCheck_1FFF
	JSR (PC_Ready_Intro_PalettePointers,x)
	RTL

	PC_Ready_Intro_PalettePointers:
		dw X_Ready_Intro_Palette
		dw Zero_Ready_Intro_Palette
		dw PC3_Ready_Intro_Palette
		dw PC4_Ready_Intro_Palette
		db $FF,$FF
		db $FF,$FF
	
	
	X_Ready_Intro_Palette:
		LDA #$32 ;Which palette slot for 'READY' text to use
		STA $11
		RTS
	
	Zero_Ready_Intro_Palette:
		LDA !CurrentLevel_1FAE
		BNE X_Ready_Intro_Palette
		LDA #$3C ;Which palette slot for 'READY' text to use
		STA $11
		RTS
		
	PC3_Ready_Intro_Palette:
		LDA #$32 ;Which palette slot for 'READY' text to use
		STA $11
		RTS
	
	PC4_Ready_Intro_Palette:
		LDA #$32 ;Which palette slot for 'READY' text to use
		STA $11
		RTS
}

}

;*********************************************************************************
; Sets new data for Hangar in introduction level and Mac
;*********************************************************************************


;*********************************************************************************
; Setting up Save/Load Screen
;*********************************************************************************
;$0020 - Current SRAM location to read from
;$0022 - Current Save Page
;$0024 - Total SRAM (May not be needed, but mainly for changing pages to keep track of everything in total)
;$0026 - BIT flag to initiate blanking out all text if there is no save.
{

LoadScreen_PresetAllData: ;Loads all data as the Loading screen is loading up so everything is preset.
{
	LDY #$AC ;Load Ride Chip sprites (Decompressed)
	JSL !LoadDecompressedGraphics_Long ;Decompressed graphics routine
	JSL AllowBankSendToVRAM
	LDY #$BA ;Load Armor Chip sprites (Decompressed)
	JSL !LoadDecompressedGraphics_Long ;Decompressed graphics routine
	JSL AllowBankSendToVRAM
	LDY #$14 ;Load X idle pose into VRAM (Decompressed)
	JSL !LoadDecompressedGraphics_Long ;Decompressed graphics routine
	JSL AllowBankSendToVRAM
	LDY #$C6 ;Load Zero idle pose into VRAM (Save Menu) (Decompressed)
	JSL !LoadDecompressedGraphics_Long ;Decompressed graphics routine
	JSL AllowBankSendToVRAM
	LDY #$C0 ;Loads Password Screen Layer #1 Tile Map (Decompressed)
	JSL !LoadDecompressedGraphics_Long
	JSL AllowBankSendToVRAM
	LDY #$C2 ;Loads Password Screen Layer #3 Tile Map (Decompressed)
	JSL !LoadDecompressedGraphics_Long
	JSL AllowBankSendToVRAM
	LDY #$C4 ;Load Zero 1-up Icon (Save Menu) sprite (Decompressed)
	JSL !LoadDecompressedGraphics_Long ;Decompressed graphics routine
	JSL AllowBankSendToVRAM
	
	STZ $04 ;Sets save column (Page now) to be #$00
	STZ $07 ;Sets save row to be #$00
	STZ $0A ;Sets 'Yes No' selection to #$00 so it selects Yes by default
	JSL DisplaySavedData_SetSaveSlot
	
	LDA #$80
	STA $2115
	LDX #$0A ;Load 'Select file to load. (Layer 3)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	JSL AllowBankSendToVRAM
	
	JSL DisplaySavedData_AllTextData
	
	LDY #$F8 ;Loads Password Screen Palette (Originally #$CE)
	JSL !PaletteAlternate
	
	REP #$10
	LDY #$0142 ;Load which palette to use for Password Numbers/Zero Face/Doppler Face/Cursor
	LDX #$0030 ;Which RAM location to store palette to
	JSL !Palette
	
	LDY #$0100 ;X Regular Palette
	JSL !PaletteAlternate
	
	LDY #$01B8 ;X Golden Armor Palette
	LDX #$0030 ;Which RAM location to store palette to (Will store to fifth palette swatch)
	JSL !Palette
	
	LDY #$0204 ;Zero Black Armor
	LDX #$0040 ;Which RAM location to store palette to (Will store to sixth palette swatch)
	JSL !Palette
	
	;First palette swatch is unused
	;Second palette swatch is X's plain palette
	;Third palette swatch is Zero's general palette
	;Fourth palette swatch is Ride Chips
	;Fifth palette swatch is unused (Will be X's Golden Armor palette)
	;Sixth palette swatch is unused (Will be Zero's Black Armor palette)
	;Seventh palette swatch is flashing file selector
	;Eighth palette swatch is Heart Tank
	
	LDY #$0218 ;Load palette # for Ride Chips
	JSL !PaletteAlternate
	
	LDY #$021C ;Load palette # for Dark Menu Icons
	JSL !PaletteAlternate
	RTL
}
SaveScreen_PresetAllData: ;Loads all data as the Loading screen is loading up so everything is preset.
{
	LDY #$AC ;Load Ride Chip sprites (Decompressed)
	JSL !LoadDecompressedGraphics_Long ;Decompressed graphics routine
	JSL AllowBankSendToVRAM
	LDY #$BA ;Load Armor Chip sprites (Decompressed)
	JSL !LoadDecompressedGraphics_Long ;Decompressed graphics routine
	JSL AllowBankSendToVRAM
	LDY #$14 ;Load X idle pose into VRAM (Decompressed)
	JSL !LoadDecompressedGraphics_Long ;Decompressed graphics routine
	JSL AllowBankSendToVRAM
	LDY #$C6 ;Load Zero idle pose into VRAM (Save Menu) (Decompressed)
	JSL !LoadDecompressedGraphics_Long ;Decompressed graphics routine
	JSL AllowBankSendToVRAM
	LDY #$C0 ;Loads Password Screen Layer #1 Tile Map (Decompressed)
	JSL !LoadDecompressedGraphics_Long
	JSL AllowBankSendToVRAM
	LDY #$C2 ;Loads Password Screen Layer #3 Tile Map (Decompressed)
	JSL !LoadDecompressedGraphics_Long
	JSL AllowBankSendToVRAM
	LDY #$C4 ;Load Zero 1-up Icon (Save Menu) sprite (Decompressed)
	JSL !LoadDecompressedGraphics_Long ;Decompressed graphics routine
	JSL AllowBankSendToVRAM
	
	STZ $04 ;Sets save column (Page now) to be #$00
	STZ $07 ;Sets save row to be #$00
	STZ $0A ;Sets 'Yes No' selection to #$00 so it selects Yes by default
	JSL DisplaySavedData_SetSaveSlot
	
	LDA #$80
	STA $2115
	LDX #$0E ;Load 'Select file to save to. (Layer 3)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	JSL AllowBankSendToVRAM
	
	JSL DisplaySavedData_AllTextData
	
	LDY #$F8 ;Loads Password Screen Palette (Originally #$CE)
	JSL !PaletteAlternate
	
	REP #$10
	LDY #$0142 ;Load which palette to use for Password Numbers/Zero Face/Doppler Face/Cursor
	LDX #$0030 ;Which RAM location to store palette to
	JSL !Palette
	
	LDY #$0100 ;X Regular Palette
	JSL !PaletteAlternate
	
	LDY #$01B8 ;X Golden Armor Palette
	LDX #$0030 ;Which RAM location to store palette to (Will store to fifth palette swatch)
	JSL !Palette
	
	LDY #$0204 ;Zero Black Armor
	LDX #$0040 ;Which RAM location to store palette to (Will store to sixth palette swatch)
	JSL !Palette
	
	;First palette swatch is unused
	;Second palette swatch is X's plain palette
	;Third palette swatch is Zero's general palette
	;Fourth palette swatch is Ride Chips
	;Fifth palette swatch is unused (Will be X's Golden Armor palette)
	;Sixth palette swatch is unused (Will be Zero's Black Armor palette)
	;Seventh palette swatch is flashing file selector
	;Eighth palette swatch is Heart Tank
	
	LDY #$0218 ;Load palette # for Ride Chips
	JSL !PaletteAlternate
	
	LDY #$021C ;Load palette # for Dark Menu Icons
	JSL !PaletteAlternate
	RTL
}

DisplaySavedData_CheckForBadSave: ;Routine that checks whether a save has data or not.
{
	REP #$30
	STZ $0026
	LDA $0020
	STA $0000
	LDY #$0000
	
	DisplaySavedData_CheckForBadSave_Loop:
	LDX $0000
	LDA $700000,x
	PHA
	TXA
	SEC
	SBC $0020
	TAX
	PLA
	CMP $80FFC0,x
	BNE DisplaySavedData_CheckForBadSave_BadSave
	
		INC $0000
		INC $0000
		INY
		CPY #$000B
		
	BNE DisplaySavedData_CheckForBadSave_Loop
	SEP #$30
	LDA #$00
	STA $0026
	RTL
	
	DisplaySavedData_CheckForBadSave_BadSave:
	SEP #$30
	LDA #$01
	STA $0026
	RTL
}
DisplaySavedData_AllTextData: ;Loads routine to display all main text data
{
	JSL DisplaySavedData_CheckForBadSave
	
	DisplaySavedData_AllTextDataSkipBadSave:
	JSL DisplaySavedData_NonEnemyText
	JSL DisplaySavedData_EnemyText
	JSL DisplaySavedData_WeaponsIcons
	JSL DisplaySavedData_HeartTankCounter
	JSL DisplaySavedData_1UpCounter
	JSL DisplaySavedData_Upgrades
	JSL DisplaySavedData_SubTanks
	RTL

	
DisplaySavedData_NonEnemyText: ;$7E:1E5F = Which row you're on (Currently is which File #) | $7E:1E5C = Which column you're on (Will be which page)
{
	SEP #$30

	LDA #$80
	STA $2115
	LDX #$00 ;Load Weapons text
	LDA #$30
	LDY $0026
	JSL DisplayNewMenuText

	LDA #$80
	STA $2115
	LDX #$01 ;Load Life text
	LDA #$30
	LDY $0026
	JSL DisplayNewMenuText
	
	LDA #$80
	STA $2115
	LDX #$02 ;Load S-Tank text
	LDA #$30
	LDY $0026
	JSL DisplayNewMenuText
	
	LDA #$80
	STA $2115
	LDX #$03 ;Load Modules text
	LDA #$30
	LDY $0026
	JSL DisplayNewMenuText
	
	LDA #$80
	STA $2115
	LDX #$04 ;Load Chips text
	LDA #$30
	LDY $0026
	JSL DisplayNewMenuText
	
	
	SEP #$20
	REP #$10
	
	LDX $0020
	LDA $700129,x
	
	SEP #$30
	BIT #$10
	BNE DisplaySavedData_NonEnemyText_Clear
	LDY #$01
	BRA DisplaySavedData_NonEnemyText_Clear_SkipSetY
	
	DisplaySavedData_NonEnemyText_Clear:
	LDY $0026
	
	DisplaySavedData_NonEnemyText_Clear_SkipSetY:
	LDA #$80
	STA $2115
	LDX #$11 ;Load Clear text
	LDA #$30
	JSL DisplayNewMenuText
	BRA DisplaySavedData_NonEnemyText_End
	
	DisplaySavedData_NonEnemyText_End:
	JSL AllowBankSendToVRAM
	JSL DisplaySavedData_PageCounter
	RTL
}
DisplaySavedData_EnemyText: ;Loads routine that shows Bit/Byte/Vile text on screen to determine who's been defeated or not
{
	SEP #$20
	REP #$10
	
	LDA $0026
	BNE DisplaySavedData_AllText_NoEnemyDisplay
	
	LDX $0020
	LDA $700020,x
	BIT #$40
	BEQ DisplaySavedData_AllText_NoEnemyDisplay
	
	LDY #$0000
	BRA DisplaySavedData_AllText_EnemyDisplay
	
	DisplaySavedData_AllText_NoEnemyDisplay:
	LDY #$0001
	
	DisplaySavedData_AllText_EnemyDisplay:
	;Load Bit text
		LDX $0020
		LDA $700048,x
		BIT #$02
		BEQ DisplaySavedData_AllText_BitDark
		LDA #$3C
		BRA DisplaySavedData_AllText_DisplayBit
		
		DisplaySavedData_AllText_BitDark:
		LDA #$30
		
		DisplaySavedData_AllText_DisplayBit:
		SEP #$30
		PHA
		LDA #$80
		STA $2115
		PLA
		LDX #$05 ;Load Bit text
		JSL DisplayNewMenuText
		
	;Load Byte Text
		SEP #$20
		REP #$10

		LDX $0020
		LDA $700048,x
		BIT #$08
		BEQ DisplaySavedData_AllText_ByteDark
		LDA #$3C
		BRA DisplaySavedData_AllText_DisplayByte
		
		DisplaySavedData_AllText_ByteDark:
		LDA #$30
		
		DisplaySavedData_AllText_DisplayByte:
		SEP #$30
		PHA
		LDA #$80
		STA $2115
		PLA
		LDX #$06 ;Load Byte text
		JSL DisplayNewMenuText
		
	;Load Vile Text
		SEP #$20
		REP #$10

		LDX $0020
		LDA $700048,x
		BIT #$10
		BEQ DisplaySavedData_AllText_VileDark
		LDA #$3C
		BRA DisplaySavedData_AllText_DisplayVile
		
		DisplaySavedData_AllText_VileDark:
		LDA #$30
		
		DisplaySavedData_AllText_DisplayVile:
		SEP #$30
		PHA
		LDA #$80
		STA $2115
		PLA
		LDX #$07 ;Load Vile text
		JSL DisplayNewMenuText
		JSL AllowBankSendToVRAM
		RTL
}
DisplaySavedData_WeaponsIcons: ;Loads routine that displays all sub-weapons PC has obtained in the save.
{
	STZ $0004
	STZ $0005
	LDA #$01 ;Load BIT test for checking which bosses are defeated
	STA $0006
	STZ $0007
	
	DisplaySavedData_LoopWeaponIcons:
	REP #$30
	LDA $0020
	CLC
	ADC $0004
	TAY
	
	SEP #$20
	REP #$10
	
	LDA $0026
	BNE DisplaySavedData_DisplayNoIcon	
	
	LDX $0020
	LDA $700129,x ;Loads save to determine if it's NG+ or not
	BIT #$10
	BEQ DisplaySavedData_DisplayNotNGPlus ;If it's not NG+, jump straight to light icon drawing
	
	LDA $70012B,x ;Loads current bosses defeated
	BIT $0006 ;BIT test with value at $7E:0006
	BEQ DisplaySavedData_DisplayDarkPalette ;If value is not set, load dark palette
	BRA DisplaySavedData_DisplayLightPalette ;Always load light palette with NG+ since the weapon 'should' be there
	
	DisplaySavedData_DisplayNotNGPlus:
	TYX
	LDA $70002B,x ;Loads sub-weapons to see if there's ANY value stored here
	BEQ DisplaySavedData_DisplayNoIcon
	
	DisplaySavedData_DisplayLightPalette:
	LDA #$28 ;Palette for icon (LIGHT)
	BRA DisplaySavedData_DisplayIcon
	
	DisplaySavedData_DisplayDarkPalette:
	LDA #$34 ;Palette for icon (DARK)
	
	DisplaySavedData_DisplayIcon:
	LDY #$0000
	LDX $0004
	JSL DisplayNewMenu_SubWeaponIcon
	BRA DisplaySavedData_JumpNextIcon
	
	DisplaySavedData_DisplayNoIcon:
	LDA #$30
	LDY #$0001
	LDX $0004
	JSL DisplayNewMenu_SubWeaponIcon
	
	DisplaySavedData_JumpNextIcon:
	ASL $0006
	LDA $0004
	INC $0004
	CMP #$07
	BNE DisplaySavedData_LoopWeaponIcons
	RTL
}
DisplaySavedData_HeartTankCounter: ;Routine that draws how many Heart Tanks you have in total
{
	SEP #$20
	REP #$10
	
	LDX #$00FF
	PHX
	LDY #$0000
	LDA #$80
	STA $2115
	
	REP #$20
	LDA #$590E ;X/Y coordinates of Heart Tank Counter numbers (Top)
	STA $2116
	
	SEP #$20
	REP #$10
	LDX $0020 ;Temp. storage for which save slot
	LDA $700065,x ;Load X's Heart Tank Total
	CLC
	ADC $700095,x ;Load Zero's Heart Tank Total
	ADC $7000C5,x ;Load PC3's Heart Tank Total
	ADC $7000F5,x ;Load PC4's Heart Tank Total
	PLX
	PHA
	PLA
	BCS DisplaySavedData_HeartTank_SetTotalToFF
	BRA DisplayNewMenu_HeartTankCounter_ROL
	
	DisplaySavedData_HeartTank_SetTotalToFF:
	LDA #$FF
	
	DisplayNewMenu_HeartTankCounter_ROL:
	ROL
	BCC DisplayNewMenu_HeartTankCounter_IncreaseY
	INX
	
	DisplayNewMenu_HeartTankCounter_IncreaseY:
	INY
	CPY #$0008
	BNE DisplayNewMenu_HeartTankCounter_ROL
	
	TXA
	ADC #$56
	
	PHY
	LDY $0026
	BEQ DisplayNewMenu_HeartTankCounter_StoreTopTile
	LDA #$0F
	
	DisplayNewMenu_HeartTankCounter_StoreTopTile:
	PLY
	STA $2118
	
	PHA
	LDA #$30
	STA $2119
	
	REP #$20
	LDA #$592E ;X/Y coordinates of Heart Tank Counter numbers (Bottom)
	STA $2116
	
	SEP #$20
	PLA
	CLC
	ADC #$10
	PHY
	LDY $0026
	BEQ DisplayNewMenu_HeartTankCounter_StoreBottomTile
	LDA #$0F
	
	DisplayNewMenu_HeartTankCounter_StoreBottomTile:
	PLY
	STA $2118
	LDA #$30
	STA $2119
	RTL
}
DisplaySavedData_1UpCounter: ;Routine that draws how many Heart Tanks you have in total
{
	LDA #$80
	STA $2115
	
	REP #$20
	LDA #$5913 ;X/Y coordinates of 1-up Counter numbers (Top)
	STA $2116
	
	LDX $0020
	LDA $700024,x ;Load 1-up total lives
	AND #$00FF
	
	SEP #$20
	ADC #$56
	PHY
	LDY $0026
	BEQ DisplayNewMenu_1UpCounter_StoreTopTile
	LDA #$0F
	
	DisplayNewMenu_1UpCounter_StoreTopTile:
	PLY
	STA $2118
	
	PHA
	LDA #$30
	STA $2119
	
	REP #$20
	LDA #$5933 ;X/Y coordinates of Heart Tank Counter numbers (Bottom)
	STA $2116
	
	SEP #$20
	PLA
	CLC
	ADC #$10
	PHY
	LDY $0026
	BEQ DisplayNewMenu_1UpCounter_StoreBottomTile
	LDA #$0F
	
	DisplayNewMenu_1UpCounter_StoreBottomTile:
	PLY
	
	STA $2118
	LDA #$30
	STA $2119
	RTL
}
DisplaySavedData_Upgrades: ;Loads routine that displays the Z-Saber icon.
{
	SEP #$20
	REP #$10
	
	LDA $0026
	BNE DisplaySavedData_DisplayNoZSaber
	
	LDX $0020
	LDA $700022,x
	BEQ DisplaySavedData_DisplayNoZSaber
	BIT #$80
	BNE DisplaySavedData_DisplayZSaber
	
	DisplaySavedData_DisplayNoZSaber:
	LDA #$30
	LDY #$0001
	LDX #$0009
	JSL DisplayNewMenu_SubWeaponIcon
	BRA DisplaySavedData_ZSaberText

	DisplaySavedData_DisplayZSaber:
	LDA #$28 ;Palette for icon
	LDY #$0000
	LDX #$0009 ;Load Z-Saber icon
	JSL DisplayNewMenu_SubWeaponIcon
	
	DisplaySavedData_ZSaberText:
	LDA #$80
	STA $2115
	
	SEP #$20
	REP #$10
	
	LDA $0026
	BNE DisplaySavedData_NonEnemyText_ZSaberNoText
	
	LDX $0020
	LDA $700022,x ;Load Z-Saber bit value
	BEQ DisplaySavedData_NonEnemyText_ZSaberNoText
	BIT #$02 ;Checks for Zero with X-Buster upgrade
	BNE DisplaySavedData_NonEnemyText_ZSaberText
	BIT #$80 ;Checks for X with Z-Saber upgrade
	BNE DisplaySavedData_NonEnemyText_ZSaberText
	
	DisplaySavedData_NonEnemyText_ZSaberNoText:
	LDY #$0001
	BRA DisplaySavedData_NonEnemyText_ZSaberTextSet
	
	DisplaySavedData_NonEnemyText_ZSaberText:
	LDY #$0000
	
	DisplaySavedData_NonEnemyText_ZSaberTextSet:
	LDX #$0009 ;Load Upgrades text
	
	SEP #$30
	LDA #$30
	JSL DisplayNewMenuText
	RTL
}
DisplaySavedData_SubTanks: ;Loads routine to draw sub-tanks onto the menu
{
	STZ $0002 ;Counter for Sub-Tanks
	STZ $0003
	
	DisplaySavedData_SubTanks_Begin:
	REP #$30
	LDA $0020 ;Load base SRAM
	CLC
	ADC $0002 ;Add counter for Sub-Tanks
	TAX
	LDA $700027,x ;Loads Sub-Tanks from SRAM
	AND #$00FF
	SEP #$30
	BNE DisplaySavedData_LoadSubTankTiles
	INC $0026
	JSL DisplaySavedData_SubTanksTiles
	DEC $0026
	BRA DisplaySavedData_LoadSubTankTiles_Loop
	
	DisplaySavedData_LoadSubTankTiles:
	AND #$0F
	TAY
	JSL DisplaySavedData_SubTanksTiles
	
	DisplaySavedData_LoadSubTankTiles_Loop:
	INC $0002
	LDA $0002
	CMP #$04
	BNE DisplaySavedData_SubTanks_Begin
	
	JSL AllowBankSendToVRAM
	RTL
	
	
	
	DisplaySavedData_SubTanksTiles: ;Routine to display sub-tanks tiles
	{
	STY $0000
	LDY $0026
	BNE DisplaySavedData_SubTanksTiles_BlankPalette
	LDA #$2C ;Palette of sub-tanks
	BRA DisplaySavedData_SubTanksTiles_StorePalette
	
	DisplaySavedData_SubTanksTiles_BlankPalette:
	LDA #$30 
	
	DisplaySavedData_SubTanksTiles_StorePalette:
	STA $0006
	LDA $0002
	ASL A
	TAX
	LDY $00A5
	LDA #$80
	STA $0600,y
	STA $0608,y
	
	REP #$20
	LDA SaveMenu_SubTankXY,x
	STA $0601,y
	CLC
	ADC #$0020
	STA $0609,y
	
	DisplaySavedData_SubTanksTiles_Continue:
	SEP #$20
	LDA #$04
	STA $0603,y
	STA $060B,y
	LDA $0006
	STA $0605,y
	STA $060D,y
	LDA $0006
	ORA #$40
	STA $0607,y
	STA $060F,y
	
	LDA $0026
	BNE DisplaySavedData_SubTanks_LoadBlank1
	
	LDA $0000
	CMP #$06
	BCC DisplaySavedData_SubTanks_CLC
	LDA #$26
	BRA DisplaySavedData_SubTanks_SkipCLC
	
	DisplaySavedData_SubTanks_CLC:
	CLC
	ADC #$20
	BRA DisplaySavedData_SubTanks_SkipCLC
	
	DisplaySavedData_SubTanks_LoadBlank1:
	LDA #$0F
	
	DisplaySavedData_SubTanks_SkipCLC:
	STA $060C,y
	STA $060E,y
	
	LDA $0026
	BNE DisplaySavedData_SubTanks_LoadBlank2
	
	LDA $0000
	SEC
	SBC #$06
	BMI DisplaySavedData_SubTanks_Load27
	CLC
	ADC #$27
	BRA DisplaySavedData_SubTanks_Skip27
	
	DisplaySavedData_SubTanks_Load27:
	LDA #$27
	BRA DisplaySavedData_SubTanks_Skip27
	
	DisplaySavedData_SubTanks_LoadBlank2:
	LDA #$0F
	
	DisplaySavedData_SubTanks_Skip27:
	STA $0604,y
	STA $0606,y
	TYA
	CLC
	ADC #$10
	STA $00A5
	RTL
}
}
DisplaySavedData_PageCounter: ;Loads routine to display page counter
{
	LDA #$80
	STA $2115
	
	REP #$20
	LDA #$0AA8 ;X/Y coordinates of 1-up Counter numbers (Top)
	STA $2116
	
	SEP #$30
	LDA $1E5C
	CLC
	ADC #$31
	STA $2118
	LDA #$20
	STA $2119
	RTL
}
DisplayNewMenuText: ;Routine that draws Layer #1/#2 menu text onto screen (Set Y to #$01 and it'll draw blank text)
{
	STA $0002
	
	REP #$20
	TXA
	STA $0000
	ASL
	TAX
	
	LDA DisplayNewText_XYCoordinates,x
	STA $2116
	LDA $0000
	ASL
	CLC
	ADC $0000
	TAX
	
	LDA DisplayNewText_Pointers,x
	STA $10
	INX #2
	
	SEP #$20
	LDA DisplayNewText_Pointers,x ;Loads bank
	STA $12
	
	DisplayNewText_LoadText: ;Routine now checks if Y is #$01. If so, it'll blank out strings as they're drawn.
	LDA [$10]
	BEQ DisplayNewText_End	
	
		CPY #$01
		BEQ DisplayNewText_LoadBlankText
		
			LDY $0026
			BEQ DisplayNewText_LoadNormalText
		
		DisplayNewText_LoadBlankText:
		LDA #$0F
		
		DisplayNewText_LoadNormalText:
		STA $2118
		LDA $0002
		STA $2119
		REP #$20
		INC $10
		SEP #$20
		BRA DisplayNewText_LoadText
	
	DisplayNewText_End:
	RTL
}
DisplayNewMenu_SubWeaponIcon: ;Sets and draws data for sub-weapon icon X/Y coordinates and graphics
{
	STA $0003
	STZ $0002
	
	REP #$20
	TXA
	ASL
	TAX
	LDA DisplayNewMenu_SubWeaponIcon_XYCoordinates,x
	STA $2116
	STA $0010
	CLC
	ADC #$0020
	CPY #$0001
	BEQ DisplayNewMenu_SubWeaponIcon_BlankIcon
	
	LDA DisplayNewMenu_SubWeaponIcon_Graphics,x
	BRA DisplayNewMenu_SubWeaponIcon_ShowIcon
	
	DisplayNewMenu_SubWeaponIcon_BlankIcon:
	LDA #$015E
	
	DisplayNewMenu_SubWeaponIcon_ShowIcon:
	ORA $0002
	STA $2118
	INC
	STA $2118
	STA $0000
	LDA $0010
	CLC
	ADC #$0020
	STA $2116
	
	LDA $0000
	CLC
	ADC #$000F
	STA $2118
	INC
	STA $2118
	SEP #$30
	RTL

}

}
DisplayNewMenu_AllSprites: ;Routine that loads all sprites on screen
{
	LDA $0026
	BEQ DisplayNewMenu_AllSprites_Start
	RTL
	
	DisplayNewMenu_AllSprites_Start:
	JSL DisplayNewMenu_AllSprites_HeartTank
	
	REP #$30
	LDX $0020 ;Load temp. storage for which storage slot location in SRAM
	LDA $700016,x ;Loads which PC you were playing as
	AND #$00FF
	STA $0010 ;Store to temp. variable at $0010
	
	LDA $700047,x ;Loads total Ride Chip data
	AND #$00FF
	STA $0012 ;Store to temp. variable at $0012
	
	LDA $700061,x ;Loads Armor Upgrades
	AND #$00FF
	STA $0014 ;Store to temp. variable at $0014
	
	LDA $700022,x ;Loads Z-Saber obtained BIT
	SEP #$30
	BIT #$40
	BEQ DisplayNewMenu_AllSprites_CheckForX
	
		INC $0010
		JSL DisplayNewMenu_AllSprites_XSprites
		JSL DisplayNewMenu_AllSprites_1UpIcon_X
		DEC $0010
		BRA DisplayNewMenu_AllSprites_NextSprite

	DisplayNewMenu_AllSprites_CheckForX:
	BIT #$01
	BEQ DisplayNewMenu_AllSprites_CheckAllPCs
	
	STZ $0010
	JSL DisplayNewMenu_AllSprites_Zero
	JSL DisplayNewMenu_AllSprites_1UpIcon_Zero
	BRA DisplayNewMenu_AllSprites_NextSprite
	
	DisplayNewMenu_AllSprites_CheckAllPCs:
	JSL DisplayNewMenu_AllSprites_XSprites
	JSL DisplayNewMenu_AllSprites_Zero
	
	LDA $0010
	BNE DisplayNewMenu_AllSprites_1UpIcon_DisplayZeroFirst
	JSL DisplayNewMenu_AllSprites_1UpIcon_X
	JSL DisplayNewMenu_AllSprites_1UpIcon_Zero
	BRA DisplayNewMenu_AllSprites_NextSprite
	
	DisplayNewMenu_AllSprites_1UpIcon_DisplayZeroFirst:
	JSL DisplayNewMenu_AllSprites_1UpIcon_Zero
	JSL DisplayNewMenu_AllSprites_1UpIcon_X
	
	
	
	DisplayNewMenu_AllSprites_NextSprite:
	REP #$30
	LDX $0020 ;Load temp. storage for which storage slot location in SRAM
	LDA $700047,x ;Loads total Ride Chip data
	AND #$00FF
	STA $0010 ;Store to temp. variable at $0010
	JSL DisplayNewMenu_AllSprites_RideChips
	
	REP #$30
	LDX $0020 ;Load temp. storage for which storage slot location in SRAM
	LDA $700041,x ;Loads total Chip Collection
	AND #$00FF
	STA $0012 ;Store to temp. variable at $0012
	JSL DisplayNewMenu_AllSprites_XArmorChips
	RTL



DisplayNewMenu_AllSprites_HeartTank: ;Routine that draws new Heart Tank sprite on screen
{
	PEA $1898
	PLD
	LDA $01
	BNE DisplayNewMenu_HeartTankEnd
	LDA #$2F ;Palette of Heart Tank
	STA $11
	STA $2F
	STZ $12
	
	LDA #$F0 ;VRAM slot to use for Heart Tank
	STA $18
	
	LDA #$38 ;Sprite assembly?
	STA $16
	LDA #$00 ;Which animation to use
	JSL $84B967
	
	REP #$20
	LDA #$0067 ;X Coordinates of Heart Tank
	STA $05
	LDA #$0047 ;Y coordinates of Heart Tank
	STA $08
	SEP #$20
	
	DisplayNewMenu_HeartTankEnd:
	JSL $82D636
	RTL
}

DisplayNewMenu_AllSprites_1UpIcon_X: ;Loads routine to display X's 1-up icon
{
	PEA $18B8
	PLD
	SEP #$20
	LDA $01
	BNE DisplayNewMenu_1UpIconsXEnd
	LDA #$22 ;Palette of X 1-up icon
	STA $11
	STA $2F
	STZ $12
	
	LDA #$00 ;VRAM slot to use for Heart Tank (Use #$F9 for Zero)
	STA $18
	
	LDA #$11 ;Sprite assembly
	STA $16
	LDA #$00 ;Which animation to use
	JSL $84B967
	
	REP #$20
	LDA $0010 ;Load temp. variable for which PC you were playing as
	BNE DisplayNewMenu_AllSprites_1UpIcon_X_PushedCoordinates
	LDA #$0086 ;X Coordinates of X 1-up Icon
	BRA DisplayNewMenu_AllSprites_1UpIcon_X_StoreXCoordinates
	
	DisplayNewMenu_AllSprites_1UpIcon_X_PushedCoordinates:
	LDA #$008E ;X Coordinates of X 1-up Icon
	
	DisplayNewMenu_AllSprites_1UpIcon_X_StoreXCoordinates:
	STA $05
	LDA #$0047 ;Y coordinates of X 1-up Icon
	STA $08
	SEP #$20
	
	DisplayNewMenu_1UpIconsXEnd:
	JSL $82D636
	RTL
}

DisplayNewMenu_AllSprites_1UpIcon_Zero: ;Loads routine to display Zero's 1-up icon
{
	PEA $18D8
	PLD
	SEP #$20
	LDA $01
	BNE DisplayNewMenu_1UpIconsZeroEnd
	
	LDA $0012 ;Temp. variable for Ride Armor Chip Total
	CMP #$F0
	BCC DisplayNewMenu_AllSprites_1UpIcon_Zero_RegularPalette
	LDA #$2A ;Palette of Zero 1-Up Icon (Black)
	BRA DisplayNewMenu_AllSprites_1UpIcon_ZeroStorePalette
	
	DisplayNewMenu_AllSprites_1UpIcon_Zero_RegularPalette:
	LDA #$24 ;Palette of Zero 1-Up Icon (Regular)
	
	DisplayNewMenu_AllSprites_1UpIcon_ZeroStorePalette:
	STA $11
	STA $2F
	STZ $12
	
	LDA #$06 ;VRAM slot to use for Zero 1-up icon
	STA $18
	
	LDA #$D8 ;Sprite assembly
	STA $16
	LDA #$00 ;Which animation to use
	JSL $84B967
	
	REP #$20
	LDA $0010 ;Load temp. variable for which PC you were playing as
	BEQ DisplayNewMenu_AllSprites_1UpIcon_Zero_PushedCoordinates
	LDA #$0086
	BRA DisplayNewMenu_AllSprites_1UpIcon_Zero_StoreXCoordinates
	
	DisplayNewMenu_AllSprites_1UpIcon_Zero_PushedCoordinates:
	LDA #$008D ;X Coordinates of Zero 1-up Icon
	
	DisplayNewMenu_AllSprites_1UpIcon_Zero_StoreXCoordinates:
	STA $05
	LDA #$0047 ;Y coordinates of Zero 1-up Icon
	STA $08
	SEP #$20
	
	DisplayNewMenu_1UpIconsZeroEnd:
	JSL $82D636
	RTL
	}

DisplayNewMenu_AllSprites_RideChips: ;Routine that bit checks and loads Ride Chip X/Y coordinates
{
	LDA #$0001 ;Bit test start
	STA $0000
	LDA #$16D8 ;RAM location start
	STA $0002
	STZ $0004 ;Counter for Chip X coordinates
	STZ $0006 ;Total counter for Ride Chips
	LDA #$00B0
	STA $0008 ;Base VRAM slot for Ride Chips
	
DisplayNewMenu_AllSprites_RideChipStartRoutine:
	LDA $0010 ;Loads Ride Chips from temp. variable
	AND #$00FF
	BIT $0000
	BEQ DisplayNewMenu_AllSprites_RideChipMenuSetupEnd
	LDA $0002 ;Load base RAM location
	TCD
	LDA $0008 ;Load VRAM slot
	STA $18
	JSL $82D636
	
	LDX $0004
	LDA $9FDA,x ;Load X coordinates of Ride Chip
	STA $05
	STZ $06
	STZ $09
	LDA $9FDB,x ;Load Y coordinates
	STA $08
	LDA #$26 ;Palette to use
	STA $11
	STZ $12
	LDA #$10 ;Sprite Assembly to use
	STA $16
	LDA #$00 ;Animation to use
	JSL $84B967


DisplayNewMenu_AllSprites_RideChipMenuSetupEnd:
	ASL $0000 ;Double BIT test
	INC $0004 ;Increase counter for chip X/Y coordiunates
	INC $0004 ;Increase counter for chip X/Y coordiunates
	INC $0008 ;Increase VRAM slot
	INC $0008 ;Increase VRAM slot
	REP #$30
	LDA $0002 ;Load base RAM location
	CLC
	ADC #$0020 ;Add #$20 to current value
	STA $0002 ;Store back to base RAM location
	INC $0006 ;Increase total counter for Ride Chips
	LDA $0006 ;Load total counter for Ride Chips
	CMP #$0004 ;Check if it's #$0004
	BNE DisplayNewMenu_AllSprites_RideChipStartRoutine ;If not, go through the routine again
	SEP #$20
	RTL
}		

DisplayNewMenu_AllSprites_XArmorChips: ;Routine that displays all Armor Chips
{
;10 - Helmet
;20 - Buster
;40 - Armor
;80 - Legs
		
	LDA #$0010 ;Bit test start
	STA $0000
	LDA #$1778 ;RAM location start
	STA $0002
	STZ $0004 ;Counter for Chip X coordinates
	STZ $0006 ;Total counter for Armor Pieces
	LDA #$00B8
	STA $0008 ;Base VRAM slot for Armor Pieces
	
	DisplayNewMenu_AllSprites_XArmorChipsRoutine:
	SEP #$20
	LDA $0012 ;Loads temp. variable for chips
	CMP #$F0
	BCS DisplayNewMenu_AllSprites_XArmorChips_SkipCheckingChipTotal
	LDA $0012 ;Loads temp. variable for armor pieces
	BIT $0000
	BEQ DisplayNewMenu_AllSprites_XArmorChipsEnd
	
	DisplayNewMenu_AllSprites_XArmorChips_SkipCheckingChipTotal:
	REP #$20
	LDA $0002
	TCD
	LDA $0008
	STA $18
	JSL $82D636
	
	LDX $0004 ;Counter for coordinates
	LDA $9FDA,x ;Load X coordinates of Armor pieces
	CLC
	ADC #$48
	STA $05
	STZ $06
	STZ $09
	LDA $9FDB,x ;Load Y coordinates of Armor pieces
	STA $08
	
	LDA $0010
	BIT $0000
	BEQ DisplayNewMenu_AllSprites_XArmorChips_DoNOTMakeGold
	LDA #$28 ;Palette of Armor pieces ;28 for Golden Armor
	BRA DisplayNewMenu_AllSprites_XArmorChips_StorePalette
	
	DisplayNewMenu_AllSprites_XArmorChips_DoNOTMakeGold:
	LDA #$22
	
	DisplayNewMenu_AllSprites_XArmorChips_StorePalette:
	STA $11
	STZ $12
	LDA #$10 ;Sprite Assembly of armor pieces
	STA $16
	LDA #$00
	JSL $84B967


	DisplayNewMenu_AllSprites_XArmorChipsEnd:
	ASL $0000
	INC $0004
	INC $0004
	INC $0008
	INC $0008
	REP #$20
	LDA $0002
	CLC
	ADC #$0020
	STA $0002
	INC $0006
	LDA $0006
	CMP #$0004
	BNE DisplayNewMenu_AllSprites_XArmorChipsRoutine
	SEP #$20
	
	DisplayNewMenu_AllSprites_XArmorChipsTotalEnd:
	RTL
}		

DisplayNewMenu_AllSprites_Zero: ;Loads routine to display Zero
{
	PEA $18F8
	PLD
	SEP #$20
	LDA $01
	BNE DisplayNewMenu_AllSprites_Zero_End
	LDA $0012 ;Temp. variable for Ride Armor Chip Total
	CMP #$F0
	BCC DisplayNewMenu_AllSprites_Zero_RegularPalette
	LDA #$2A ;Palette of Zero(Black)
	BRA DisplayNewMenu_AllSprites_ZeroStorePalette
	
	DisplayNewMenu_AllSprites_Zero_RegularPalette:
	LDA #$24 ;Palette of Zero(Regular)
	
	DisplayNewMenu_AllSprites_ZeroStorePalette:
	STA $11
	STZ $12
	
	LDA #$80 ;VRAM slot to use for Zero
	STA $18
	
	LDA #$4A ;Sprite assembly
	STA $16
	LDA #$50 ;Which animation to use
	JSL $84B967
	
	REP #$20
	LDA $0010 ;Load temp. variable for which PC you were playing as
	BEQ DisplayNewMenu_AllSprites_Zero_PushedCoordinates
	LDA #$00B3 ;X Coordinates of Zero
	BRA DisplayNewMenu_AllSprites_Zero_StoreXCoordinates
	
	DisplayNewMenu_AllSprites_Zero_PushedCoordinates:
	LDA #$00D4 ;X Coordinates of Zero
	
	DisplayNewMenu_AllSprites_Zero_StoreXCoordinates:
	STA $05
	LDA #$0096 ;Y coordinates of Zero
	STA $08
	SEP #$20
	
	DisplayNewMenu_AllSprites_Zero_End:
	JSL $82D636
	RTL
}

DisplayNewMenu_AllSprites_X: ;Loads routine to display X
{
	PEA $1918
	PLD
	
	SEP #$20
	
	LDA $0014
	AND #$01
	BEQ DisplayNewMenu_AllSprites_X_DrawHelmet
	LDA #$18 ;Sprite assembly
	BRA DisplayNewMenu_AllSprites_X_SetSpriteAssembly
	
	DisplayNewMenu_AllSprites_X_DrawHelmet:
	LDA #$00
	
	DisplayNewMenu_AllSprites_X_SetSpriteAssembly:
	STA $16
	
	DisplayNewMenu_AllSprites_X_SharedRoutineWithArmor:
	LDA $01
	BNE DisplayNewMenu_AllSprites_X_End
	LDA $0012 ;Temp. variable for Ride Armor Chip Total
	CMP #$F0
	BCC DisplayNewMenu_AllSprites_X_RegularPalette
	LDA #$28 ;Palette of X (Gold)
	BRA DisplayNewMenu_AllSprites_XStorePalette
	
	DisplayNewMenu_AllSprites_X_RegularPalette:
	LDA #$22 ;Palette of X (Regular)
	
	DisplayNewMenu_AllSprites_XStorePalette:
	STA $11
	STZ $12
	
	LDA #$AA ;VRAM slot to use for X
	STA $18
	
	LDA #$50 ;Which animation to use
	JSL $84B967
	
	REP #$20
	LDA $0010 ;Load temp. variable for which PC you were playing as
	BNE DisplayNewMenu_AllSprites_X_PushedCoordinates
	LDA #$00AF ;X Coordinates of X
	BRA DisplayNewMenu_AllSprites_X_StoreXCoordinates
	
	DisplayNewMenu_AllSprites_X_PushedCoordinates:
	LDA #$00D8 ;X Coordinates of X
	
	DisplayNewMenu_AllSprites_X_StoreXCoordinates:
	STA $05
	LDA #$009E ;Y coordinates of X
	STA $08
	SEP #$20
	
	DisplayNewMenu_AllSprites_X_End:
	JSL $82D636
	RTL
}

DisplayNewMenu_AllSprites_X_Buster: ;Loads routine to display X's Buster
{
	PEA $1938
	PLD
	
	SEP #$20
	LDA #$5D ;Sprite assembly
	STA $16
	JSL DisplayNewMenu_AllSprites_X_SharedRoutineWithArmor
	RTL
}

DisplayNewMenu_AllSprites_X_Armor: ;Loads routine to display X's Armor
{
	PEA $1958
	PLD
	
	SEP #$20
	LDA #$5E ;Sprite assembly
	STA $16
	JSL DisplayNewMenu_AllSprites_X_SharedRoutineWithArmor
	RTL
}

DisplayNewMenu_AllSprites_X_Legs: ;Loads routine to display X's Legs
{
	PEA $1978
	PLD
	
	SEP #$20
	LDA #$5F ;Sprite assembly
	STA $16
	JSL DisplayNewMenu_AllSprites_X_SharedRoutineWithArmor
	RTL
}


DisplayNewMenu_AllSprites_XSprites:
{
	LDA $0014 ;Loads armor upgrades
	AND #$08
	BEQ DisplayNewMenu_AllSprites_LoadPCs_X_CheckArmor
	JSL DisplayNewMenu_AllSprites_X_Legs
	
	DisplayNewMenu_AllSprites_LoadPCs_X_CheckArmor:
	LDA $0014 ;Loads armor upgrades
	AND #$04
	BEQ DisplayNewMenu_AllSprites_LoadPCs_X_CheckBuster
	JSL DisplayNewMenu_AllSprites_X_Armor
	
	DisplayNewMenu_AllSprites_LoadPCs_X_CheckBuster:
	LDA $0014 ;Loads armor upgrades
	AND #$02
	BEQ DisplayNewMenu_AllSprites_LoadPCs_LoadXZero
	JSL DisplayNewMenu_AllSprites_X_Buster

	DisplayNewMenu_AllSprites_LoadPCs_LoadXZero:
	JSL DisplayNewMenu_AllSprites_X
	RTL
}

}
DisplaySavedData_SetSaveSlot: ;Sets save slot so it can gather proper SRAM
{
	REP #$20
	LDA $07 ;Gathers save slot ($1E5E)
	AND #$00FF
	ASL #5
	STA $0000
	ASL
	STA $0002
	ASL #2
	CLC
	ADC $0000
	CLC
	ADC $0002
	STA $0020
	
	;06E0 ;Page 2
	;0DC0 ;Page 3
	;14A0 ;Page 4
	
	
	LDA $04 ;Gathers save slot ($1E5E)
	AND #$00FF
	STA $0000
	ASL #2
	CLC
	ADC $0000
	
	ASL #5
	STA $0000
	ASL
	STA $0002
	ASL #2
	CLC
	ADC $0000
	CLC
	ADC $0002
	CLC
	ADC $0020
	STA $0020 ;Sets exact SRAM position
	SEP #$30
	RTL
}

LoadScreen_KeyPresses: ;Loads routine that determines what happens with key presses on screen.
{
	SEP #$20
	
	
	;Up Arrow
	LoadScreen_KeyPresses_UpArrow:
	LDA $00AD ;Loads which button is being pressed
	BIT #$08 ;'Up' key
	BEQ LoadScreen_KeyPresses_DownArrow
	DEC $07 ;Decreases which row you're on for save slot
	LDA $07 ;Load which row you're on
	BNE LoadScreen_KeyPresses_UpArrow_CheckIfLastRow
	LDA #$00 ;Sets row to row #5 so it loops properly
	BRA LoadScreen_KeyPresses_StoreRowUpdate
	
	LoadScreen_KeyPresses_UpArrow_CheckIfLastRow:
	CMP #$00 ;Check if row number is max
	BPL LoadScreen_KeyPresses_StoreRowUpdate
	LDA #$04 ;Store row number back to #$00 so it loops properly
	BRA LoadScreen_KeyPresses_StoreRowUpdate
	
	;Down Arrow
	LoadScreen_KeyPresses_DownArrow: ;Loads 'down' arrow key command
	LDA $00AD ;Loads which button is being pressed
	BIT #$04 ;'Down' key
	BEQ LoadScreen_KeyPresses_LeftArrow
	INC $07 ;Increases which row you're on for save slot
	LDA $07 ;Load which row you're on
	BPL LoadScreen_KeyPresses_DownArrow_CheckIfLastRow
	LDA #$04 ;Sets row to row #5 so it loops properly
	BRA LoadScreen_KeyPresses_StoreRowUpdate
	
	LoadScreen_KeyPresses_DownArrow_CheckIfLastRow:
	CMP #$05 ;Check if row number is max
	BMI LoadScreen_KeyPresses_StoreRowUpdate
	LDA #$00 ;Store row number back to #$00 so it loops properly
	
	LoadScreen_KeyPresses_StoreRowUpdate:
	STA $07 ;Store which row you're on back to $07
	JSL DisplaySavedData_SetSaveSlot
	LDA #$1C
	JSL !PlaySFX
	JSL DisplaySavedData_AllTextData ;Load routine to update save data on screen when moving to a new slot
	
	
	;Left Arrow
	LoadScreen_KeyPresses_LeftArrow:
	LDA $00AD ;Loads which button is being pressed
	BIT #$02 ;'Left' key
	BEQ LoadScreen_KeyPresses_RightArrow
	DEC $04 ;Decreases which column you're on for save slot
	LDA $04 ;Load which column you're on
	BNE LoadScreen_KeyPresses_LeftArrow_CheckIfLastRow
	LDA #$00 ;Sets column to column #4 so it loops properly
	BRA LoadScreen_KeyPresses_StoreColumnUpdate
	
	LoadScreen_KeyPresses_LeftArrow_CheckIfLastRow:
	CMP #$00 ;Check if column number is max
	BPL LoadScreen_KeyPresses_StoreColumnUpdate
	LDA #$03 ;Store column number back to #$00 so it loops properly
	BRA LoadScreen_KeyPresses_StoreColumnUpdate
	
	
	;Right Arrow
	LoadScreen_KeyPresses_RightArrow: ;Loads 'right' arrow key command
	LDA $00AD ;Loads which button is being pressed
	BIT #$01 ;'Right' key
	BEQ LoadScreen_KeyPresses_Y
	INC $04 ;Increases which column you're on for save slot
	LDA $04 ;Load which column you're on
	BPL LoadScreen_KeyPresses_RightArrow_CheckIfLastColumn
	LDA #$03 ;Sets column to #4 so it loops properly
	BRA LoadScreen_KeyPresses_StoreColumnUpdate
	
	LoadScreen_KeyPresses_RightArrow_CheckIfLastColumn:
	CMP #$04 ;Check if column number is max
	BMI LoadScreen_KeyPresses_StoreColumnUpdate
	LDA #$00 ;Store column number back to #$00 so it loops properly
	
	LoadScreen_KeyPresses_StoreColumnUpdate:
	STA $04 ;Store which column you're on back to $07
	JSL DisplaySavedData_SetSaveSlot
	LDA #$41
	JSL !PlaySFX
	JSL DisplaySavedData_AllTextData ;Load routine to update save data on screen when moving to a new slot
	
	
	;Y Button
	LoadScreen_KeyPresses_Y:
	LDA $00AD ;Load button being pressed
	AND #$40 ;Checks if 'B' button is being pressed to back out of menu
	BEQ LoadScreen_KeyPresses_A
	BRA LoadScreen_KeyPresses_SetLoadFile
	RTL
	
	;A Button
	LoadScreen_KeyPresses_A:
	LDA $00AC ;Load button being pressed
	AND #$80 ;Checks if 'A' button is being pressed to back out of menu
	BEQ LoadScreen_KeyPresses_B
	BRA LoadScreen_KeyPresses_SetLoadFile
	RTL
	
	;B Button
	LoadScreen_KeyPresses_B:
	LDA $00AD ;Load button being pressed
	AND #$80 ;Checks if 'B' button is being pressed to back out of menu
	BEQ LoadScreen_KeyPresses_Select
	LDA #$0C ;Sets value to load PasswordScreen_Event0C to back out of screen
	STA $01
	RTL
	
	;Select Button
	LoadScreen_KeyPresses_Select:
	LDA $00AD ;Load button being pressed
	AND #$20 ;Checks if 'Select' button is being pressed to erase a file
	BEQ LoadScreen_KeyPresses_Start
	
	JSL DisplaySavedData_CheckForBadSave
	LDA $0026
	BNE LoadScreen_KeyPresses_Select_NoErase
	
	STZ $0A ;Sets 'Yes No' selection to #$00 so it selects Yes by default
	LDA #$80
	STA $2115
	LDX #$10 ;Load 'Load this file? (Layer 3)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	
	LDA #$80
	STA $2115
	LDX #$0C ;Load 'Yes      No (Layer 3)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	JSL AllowBankSendToVRAM
	
	LDA #$0E
	STA $01 ;Sets password screen event to #$06
	LDA #$18
	JSL !PlaySFX
	RTL
	
	LoadScreen_KeyPresses_Select_NoErase:
	LDA #$1F
	JSL !PlaySFX
	RTL
	
	;Start Button
	LoadScreen_KeyPresses_Start:
	LDA $00AD ;Load button being pressed
	AND #$10 ;Checks if 'Start' button is being pressed to accept the save/load
	BEQ LoadScreen_KeyPresses_End
	
	;Set Load Screen to event #$06
	LoadScreen_KeyPresses_SetLoadFile:
	SEP #$30
	LDA $0026
	BNE LoadScreen_KeyPresses_NoLoad
	
		STZ $0A ;Sets 'Yes No' selection to #$00 so it selects Yes by default
		
		LDA #$80
		STA $2115
		LDX #$0B ;Load 'Load this file? (Layer 3)' text
		LDA #$20 ;Palette of text
		STZ $0026
		JSL DisplayNewMenuText
		
		LDA #$80
		STA $2115
		LDX #$0C ;Load 'Yes      No (Layer 3)' text
		LDA #$20 ;Palette of text
		STZ $0026
		JSL DisplayNewMenuText
		JSL AllowBankSendToVRAM
		
		LDA #$06
		STA $01 ;Sets password screen event to #$06
		LDA #$18
		JSL !PlaySFX
		RTL
	
	LoadScreen_KeyPresses_NoLoad:
	LDA #$1F
	JSL !PlaySFX
	
	LoadScreen_KeyPresses_End:
	RTL	
}
LoadScreen_LoadFileKeyPresses: ;Key presses for the 'Load this file?' text
{
	LoadScreen_LoadFileKeyPresses_LeftArrow:
	LDA $00AD ;Loads which button is being pressed
	BIT #$02 ;'Left' key
	BEQ LoadScreen_LoadFileKeyPresses_RightArrow
	DEC $0A ;Decreases which column you're on for save slot
	LDA $0A ;Load which column you're on
	BNE LoadScreen_LoadFileKeyPresses_LeftArrow_CheckIfLast
	LDA #$00 ;Sets column to column #4 so it loops properly
	BRA LoadScreen_LoadFileKeyPresses_StoreUpdate
	
	LoadScreen_LoadFileKeyPresses_LeftArrow_CheckIfLast:
	CMP #$00 ;Check if column number is max
	BPL LoadScreen_LoadFileKeyPresses_StoreUpdate
	LDA #$01 ;Store column number back to #$00 so it loops properly
	BRA LoadScreen_LoadFileKeyPresses_StoreUpdate
	
	
	;Right Arrow
	LoadScreen_LoadFileKeyPresses_RightArrow: ;Loads 'right' arrow key command
	LDA $00AD ;Loads which button is being pressed
	BIT #$01 ;'Right' key
	BEQ LoadScreen_LoadFileKeyPresses_Y
	INC $0A ;Increases which column you're on for save slot
	LDA $0A ;Load which column you're on
	BPL LoadScreen_LoadFileKeyPresses_RightArrow_CheckIfLast
	LDA #$01 ;Sets column to #4 so it loops properly
	BRA LoadScreen_LoadFileKeyPresses_StoreUpdate
	
	LoadScreen_LoadFileKeyPresses_RightArrow_CheckIfLast:
	CMP #$02 ;Check if column number is max
	BMI LoadScreen_LoadFileKeyPresses_StoreUpdate
	LDA #$00 ;Store column number back to #$00 so it loops properly
	
	
	LoadScreen_LoadFileKeyPresses_StoreUpdate:
	STA $0A ;Store which column you're on back to $07
	JSL DisplaySavedData_SetSaveSlot
	LDA #$4B
	JSL !PlaySFX
	
	
	;Y Button
	LoadScreen_LoadFileKeyPresses_Y:
	LDA $00AD ;Load button being pressed
	AND #$40 ;Checks if 'Y' button is being pressed to back out of menu
	BEQ LoadScreen_LoadFileKeyPresses_A
	LDA $1E62 ;Load which option you're on (Yes No)
	BNE LoadScreen_LoadFileKeyPresses_BackToFileSelect
	BRA LoadScreen_LoadFileKeyPresses_LoadSuccess
	RTL
	
	;A Button
	LoadScreen_LoadFileKeyPresses_A:
	LDA $00AC ;Load button being pressed
	AND #$80 ;Checks if 'A' button is being pressed to back out of menu
	BEQ LoadScreen_LoadFileKeyPresses_B
	LDA $1E62 ;Load which option you're on (Yes No)
	BNE LoadScreen_LoadFileKeyPresses_BackToFileSelect
	BRA LoadScreen_LoadFileKeyPresses_LoadSuccess
	RTL
	
	;B Button
	LoadScreen_LoadFileKeyPresses_B:
	LDA $00AD ;Load button being pressed
	AND #$80 ;Checks if 'B' button is being pressed to back out of menu
	BEQ LoadScreen_LoadFileKeyPresses_Start
	
	LoadScreen_LoadFileKeyPresses_BackToFileSelect:
	SEP #$30
	LDA #$80
	STA $2115
	LDX #$0A ;Load 'Select file to load. (Layer 3)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	
	LDA #$80
	STA $2115
	LDX #$0D ;Load '           ' (Layer 3) (Used to blank out Yes No)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	JSL AllowBankSendToVRAM
	
	LDA #$18
	JSL !PlaySFX
	
	LDA #$04 ;Sets value to load PasswordScreen_Event04 to back out to selecting a file again
	STA $01
	RTL
	
	
	;Start Button
	LoadScreen_LoadFileKeyPresses_Start:
	LDA $00AD ;Load button being pressed
	AND #$10 ;Checks if 'Start' button is being pressed to accept the save/load
	BEQ LoadScreen_LoadFileKeyPresses_End
	LDA $1E62 ;Load which option you're on (Yes No)
	BNE LoadScreen_LoadFileKeyPresses_BackToFileSelect
	
	LoadScreen_LoadFileKeyPresses_LoadSuccess:
	LDA #$1D
	JSL !PlaySFX
	LDA #$08
	STA $40
	LDA #$20 ;Fade out time
	STA $41
	LDA #$08
	STA $01
	RTL
	
	LoadScreen_LoadFileKeyPresses_End:
	RTL	
}
LoadScreen_SelectionCursor: ;Loads cursor for selecting Yes or No
{	
	PHD
	PEA $0D38
	PLD
	
	LDA $01
	BNE LoadScreen_SelectionCursor_CheckSelection
	
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
	
	LDA #$0D ;Load animation to use
	STA $0B
	JSL !AnimationOneFrame
	
	LDA #$2C ;Loads palette
	STA $11
	
	LoadScreen_SelectionCursor_CheckSelection:
	LDA #$5B ;Load base X coordinates of cursor
	STA $05 ;Stores to $7E:0005 (Temp. storage for cursor X coordinate)
	LDA #$0D
	CMP $0B ;Compares with value at $0B
	BEQ LoadScreen_SelectionCursor_SkipAnimationUpdate
	
	STA $0B
	JSL !AnimationOneFrame
	
	LoadScreen_SelectionCursor_SkipAnimationUpdate:
	;Sets X coordinates of password cursor
	LDA $1E62 ;Check temp. storage for row selected with password cursor
	BEQ LoadScreen_SelectionCursor_IgnoreSetToNo
	
		LDA $05 ;Loads $7E:0005 (Temp. storage for cursor X coordinate)
		CLC
		ADC #$28 ;Adds #$28 to current value.
		STA $05 ;Stores to $7E:0005 (Temp. storage for cursor X coordinate)

	LoadScreen_SelectionCursor_IgnoreSetToNo:
	LDA #$C9 ;Set base X coordinate for password cursor
	STA $08
	
	JSL !VRAMRoutineAlt
	JSL !EventLoop
	
	PLD
	RTL
}
LoadScreen_EraseFileKeyPresses: ;Key presses for the 'Load this file?' text
{
	LoadScreen_EraseFileKeyPresses_LeftArrow:
	LDA $00AD ;Loads which button is being pressed
	BIT #$02 ;'Left' key
	BEQ LoadScreen_EraseFileKeyPresses_RightArrow
	DEC $0A ;Decreases which column you're on for save slot
	LDA $0A ;Load which column you're on
	BNE LoadScreen_EraseFileKeyPresses_LeftArrow_CheckIfLast
	LDA #$00 ;Sets column to column #4 so it loops properly
	BRA LoadScreen_EraseFileKeyPresses_StoreUpdate
	
	LoadScreen_EraseFileKeyPresses_LeftArrow_CheckIfLast:
	CMP #$00 ;Check if column number is max
	BPL LoadScreen_EraseFileKeyPresses_StoreUpdate
	LDA #$01 ;Store column number back to #$00 so it loops properly
	BRA LoadScreen_EraseFileKeyPresses_StoreUpdate
	
	
	;Right Arrow
	LoadScreen_EraseFileKeyPresses_RightArrow: ;Loads 'right' arrow key command
	LDA $00AD ;Loads which button is being pressed
	BIT #$01 ;'Right' key
	BEQ LoadScreen_EraseFileKeyPresses_Y
	INC $0A ;Increases which column you're on for save slot
	LDA $0A ;Load which column you're on
	BPL LoadScreen_EraseFileKeyPresses_RightArrow_CheckIfLast
	LDA #$01 ;Sets column to #4 so it loops properly
	BRA LoadScreen_EraseFileKeyPresses_StoreUpdate
	
	LoadScreen_EraseFileKeyPresses_RightArrow_CheckIfLast:
	CMP #$02 ;Check if column number is max
	BMI LoadScreen_EraseFileKeyPresses_StoreUpdate
	LDA #$00 ;Store column number back to #$00 so it loops properly
	
	
	LoadScreen_EraseFileKeyPresses_StoreUpdate:
	STA $0A ;Store which column you're on back to $07
	JSL DisplaySavedData_SetSaveSlot
	LDA #$4B
	JSL !PlaySFX
	
	
	;Y Button
	LoadScreen_EraseFileKeyPresses_Y:
	LDA $00AD ;Load button being pressed
	AND #$40 ;Checks if 'B' button is being pressed to back out of menu
	BEQ LoadScreen_EraseFileKeyPresses_A
	LDA $1E62 ;Load which option you're on (Yes No)
	BNE LoadScreen_EraseFileKeyPresses_BackToFileSelect
	BRA LoadScreen_EraseFileKeyPresses_EraseSuccess
	RTL
	
	;A Button
	LoadScreen_EraseFileKeyPresses_A:
	LDA $00AC ;Load button being pressed
	AND #$80 ;Checks if 'B' button is being pressed to back out of menu
	BEQ LoadScreen_EraseFileKeyPresses_B
	LDA $1E62 ;Load which option you're on (Yes No)
	BNE LoadScreen_EraseFileKeyPresses_BackToFileSelect
	BRA LoadScreen_EraseFileKeyPresses_EraseSuccess
	RTL
	
	;B Button
	LoadScreen_EraseFileKeyPresses_B:
	LDA $00AD ;Load button being pressed
	AND #$80 ;Checks if 'B' button is being pressed to back out of menu
	BEQ LoadScreen_EraseFileKeyPresses_Start
	
	LoadScreen_EraseFileKeyPresses_BackToFileSelect:
	SEP #$30
	LDA #$80
	STA $2115
	LDX #$0A ;Load 'Select file to load. (Layer 3)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText

	
	LDA #$80
	STA $2115
	LDX #$0D ;Load '           ' (Layer 3) (Used to blank out Yes No)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	JSL AllowBankSendToVRAM
	
	LDA #$18
	JSL !PlaySFX
	
	LDA #$04 ;Sets value to load PasswordScreen_Event04 to back out to selecting a file again
	STA $01
	RTL
	
	
	;Start Button
	LoadScreen_EraseFileKeyPresses_Start:
	LDA $00AD ;Load button being pressed
	AND #$10 ;Checks if 'Start' button is being pressed to accept the save/load
	BEQ LoadScreen_EraseFileKeyPresses_End
	LDA $1E62 ;Load which option you're on (Yes No)
	BNE LoadScreen_EraseFileKeyPresses_BackToFileSelect
	
	LoadScreen_EraseFileKeyPresses_EraseSuccess:
	REP #$30
	LDX $0020
	LDY #$0000
	LDA #$6060
	
	LoadScreen_EraseFileKeyPresses_EraseSuccess_Loop:
	STA $700000,x
	INX #2
	INY
	CPY #$00B0
	BNE LoadScreen_EraseFileKeyPresses_EraseSuccess_Loop
	JSL AllowBankSendToVRAM
	
	SEP #$30
	LDA #$80
	STA $2115
	LDX #$0A ;Load 'Select file to load. (Layer 3)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	
	LDA #$80
	STA $2115
	LDX #$0D ;Load '           ' (Layer 3) (Used to blank out Yes No)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	JSL AllowBankSendToVRAM
	
	LDA #$1D
	JSL !PlaySFX
	
	JSL DisplaySavedData_AllTextData
	
	LDA #$04
	STA $01

	LoadScreen_EraseFileKeyPresses_End:
	RTL	
}	
LoadScreen_SendSRAMToRAM: ;Loads SRAM data to store into RAM
{
	PHP
	PHB
	SEP #$30
	LDA #$7E
	PHA
	PLB
	
	SEP #$20
	REP #$10
	LDX $0020
	LDA $700016,x ;Loads current PC you're playing as
	STA !CurrentPCCheck_1FFF
	
	; LDY #$0000
	
	; LoadScreen_SendSRAMToRAM_SendButtons:
	; LDA $700017,x ;Loads buttons to store into RAM
	; STA $FFC0,y
	; INX
	; INY
	; CPY #$0008
	; BNE LoadScreen_SendSRAMToRAM_SendButtons
	
	
	LDY #$0000
	LDX $0020
	
	LoadScreen_SendSRAMToRAM_VariousData:
	LDA $70001F,x
	STA $1FAF,y
	INX 
	INY
	CPY #$002A
	BNE LoadScreen_SendSRAMToRAM_VariousData
	
	LDY #$0000
	LDX $0020
	
	LoadScreen_SendSRAMToRAM_AllPCData:
	LDA $700049,x
	STA $F400,y
	INX
	INY
	CPY #$100
	BNE LoadScreen_SendSRAMToRAM_AllPCData
	
	PLB
	PLP
	SEP #$30
	RTL
}	
	
SaveScreen_KeyPresses: ;Loads routine that determines what happens with key presses on screen.
{
	SEP #$20
	
	
	;Up Arrow
	SaveScreen_KeyPresses_UpArrow:
	LDA $00AD ;Loads which button is being pressed
	BIT #$08 ;'Up' key
	BEQ SaveScreen_KeyPresses_DownArrow
	DEC $07 ;Decreases which row you're on for save slot
	LDA $07 ;Load which row you're on
	BNE SaveScreen_KeyPresses_UpArrow_CheckIfLastRow
	LDA #$00 ;Sets row to row #5 so it loops properly
	BRA SaveScreen_KeyPresses_StoreRowUpdate
	
	SaveScreen_KeyPresses_UpArrow_CheckIfLastRow:
	CMP #$00 ;Check if row number is max
	BPL SaveScreen_KeyPresses_StoreRowUpdate
	LDA #$04 ;Store row number back to #$00 so it loops properly
	BRA SaveScreen_KeyPresses_StoreRowUpdate
	
	;Down Arrow
	SaveScreen_KeyPresses_DownArrow: ;Loads 'down' arrow key command
	LDA $00AD ;Loads which button is being pressed
	BIT #$04 ;'Down' key
	BEQ SaveScreen_KeyPresses_LeftArrow
	INC $07 ;Increases which row you're on for save slot
	LDA $07 ;Load which row you're on
	BPL SaveScreen_KeyPresses_DownArrow_CheckIfLastRow
	LDA #$04 ;Sets row to row #5 so it loops properly
	BRA SaveScreen_KeyPresses_StoreRowUpdate
	
	SaveScreen_KeyPresses_DownArrow_CheckIfLastRow:
	CMP #$05 ;Check if row number is max
	BMI SaveScreen_KeyPresses_StoreRowUpdate
	LDA #$00 ;Store row number back to #$00 so it loops properly
	
	SaveScreen_KeyPresses_StoreRowUpdate:
	STA $07 ;Store which row you're on back to $07
	JSL DisplaySavedData_SetSaveSlot
	LDA #$1C
	JSL !PlaySFX
	JSL DisplaySavedData_AllTextData ;Load routine to update save data on screen when moving to a new slot
	
	
	;Left Arrow
	SaveScreen_KeyPresses_LeftArrow:
	LDA $00AD ;Loads which button is being pressed
	BIT #$02 ;'Left' key
	BEQ SaveScreen_KeyPresses_RightArrow
	DEC $04 ;Decreases which column you're on for save slot
	LDA $04 ;Load which column you're on
	BNE SaveScreen_KeyPresses_LeftArrow_CheckIfLastRow
	LDA #$00 ;Sets column to column #4 so it loops properly
	BRA SaveScreen_KeyPresses_StoreColumnUpdate
	
	SaveScreen_KeyPresses_LeftArrow_CheckIfLastRow:
	CMP #$00 ;Check if column number is max
	BPL SaveScreen_KeyPresses_StoreColumnUpdate
	LDA #$03 ;Store column number back to #$00 so it loops properly
	BRA SaveScreen_KeyPresses_StoreColumnUpdate
	
	
	;Right Arrow
	SaveScreen_KeyPresses_RightArrow: ;Loads 'right' arrow key command
	LDA $00AD ;Loads which button is being pressed
	BIT #$01 ;'Right' key
	BEQ SaveScreen_KeyPresses_Y
	INC $04 ;Increases which column you're on for save slot
	LDA $04 ;Load which column you're on
	BPL SaveScreen_KeyPresses_RightArrow_CheckIfLastColumn
	LDA #$03 ;Sets column to #4 so it loops properly
	BRA SaveScreen_KeyPresses_StoreColumnUpdate
	
	SaveScreen_KeyPresses_RightArrow_CheckIfLastColumn:
	CMP #$04 ;Check if column number is max
	BMI SaveScreen_KeyPresses_StoreColumnUpdate
	LDA #$00 ;Store column number back to #$00 so it loops properly
	
	SaveScreen_KeyPresses_StoreColumnUpdate:
	STA $04 ;Store which column you're on back to $07
	JSL DisplaySavedData_SetSaveSlot
	JSL AllowBankSendToVRAM
	LDA #$41
	JSL !PlaySFX
	JSL DisplaySavedData_AllTextData ;Load routine to update save data on screen when moving to a new slot
	
	
	;Y Button
	SaveScreen_KeyPresses_Y:
	LDA $00AD ;Load button being pressed
	AND #$40 ;Checks if 'B' button is being pressed to back out of menu
	BEQ SaveScreen_KeyPresses_A
	BRA SaveScreen_KeyPresses_SetSaveFile
	RTL
	
	;A Button
	SaveScreen_KeyPresses_A:
	LDA $00AC ;Load button being pressed
	AND #$80 ;Checks if 'A' button is being pressed to back out of menu
	BEQ SaveScreen_KeyPresses_B
	BRA SaveScreen_KeyPresses_SetSaveFile
	RTL
	
	;B Button
	SaveScreen_KeyPresses_B:
	LDA $00AD ;Load button being pressed
	AND #$80 ;Checks if 'B' button is being pressed to back out of menu
	BEQ SaveScreen_KeyPresses_Start
	LDA #$08 ;Sets value to load PasswordScreen_Event0C to back out of screen
	STA $01
	RTL
	
	;Start Button
	SaveScreen_KeyPresses_Start:
	LDA $00AD ;Load button being pressed
	AND #$10 ;Checks if 'Start' button is being pressed to accept the save/load
	BEQ SaveScreen_KeyPresses_End
	
	;Set Load Screen to event #$06
	SaveScreen_KeyPresses_SetSaveFile:
	SEP #$30
	LDA $0026
	BNE SaveScreen_KeyPresses_NoLoad
	STZ $0A ;Sets 'Yes No' selection to #$00 so it selects Yes by default
	LDA #$80
	STA $2115
	LDX #$0F ;Load 'Overwrite this file? (Layer 3)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	
	LDA #$80
	STA $2115
	LDX #$0C ;Load 'Yes      No (Layer 3)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	JSL AllowBankSendToVRAM
	
	LDA #$06
	STA $01 ;Sets password screen event to #$06
	LDA #$18
	JSL !PlaySFX
	RTL
	
	SaveScreen_KeyPresses_NoLoad:
	LDA #$1D
	JSL !PlaySFX
	
	JSL SaveScreen_SendRAMToSRAM
	JSL AllowBankSendToVRAM
	STZ $0026
	JSL DisplaySavedData_AllTextDataSkipBadSave
	RTL
	
	SaveScreen_KeyPresses_End:
	RTL
}	
SaveScreen_SaveFileKeyPresses: ;Key presses for the 'Load this file?' text
{
	SaveScreen_SaveFileKeyPresses_LeftArrow:
	LDA $00AD ;Loads which button is being pressed
	BIT #$02 ;'Left' key
	BEQ SaveScreen_SaveFileKeyPresses_RightArrow
	DEC $0A ;Decreases which column you're on for save slot
	LDA $0A ;Load which column you're on
	BNE SaveScreen_SaveFileKeyPresses_LeftArrow_CheckIfLast
	LDA #$00 ;Sets column to column #4 so it loops properly
	BRA SaveScreen_SaveFileKeyPresses_StoreUpdate
	
	SaveScreen_SaveFileKeyPresses_LeftArrow_CheckIfLast:
	CMP #$00 ;Check if column number is max
	BPL SaveScreen_SaveFileKeyPresses_StoreUpdate
	LDA #$01 ;Store column number back to #$00 so it loops properly
	BRA SaveScreen_SaveFileKeyPresses_StoreUpdate
	
	
	;Right Arrow
	SaveScreen_SaveFileKeyPresses_RightArrow: ;Loads 'right' arrow key command
	LDA $00AD ;Loads which button is being pressed
	BIT #$01 ;'Right' key
	BEQ SaveScreen_SaveFileKeyPresses_Y
	INC $0A ;Increases which column you're on for save slot
	LDA $0A ;Load which column you're on
	BPL SaveScreen_SaveFileKeyPresses_RightArrow_CheckIfLast
	LDA #$01 ;Sets column to #4 so it loops properly
	BRA SaveScreen_SaveFileKeyPresses_StoreUpdate
	
	SaveScreen_SaveFileKeyPresses_RightArrow_CheckIfLast:
	CMP #$02 ;Check if column number is max
	BMI SaveScreen_SaveFileKeyPresses_StoreUpdate
	LDA #$00 ;Store column number back to #$00 so it loops properly
	
	
	SaveScreen_SaveFileKeyPresses_StoreUpdate:
	STA $0A ;Store which column you're on back to $07
	JSL DisplaySavedData_SetSaveSlot
	LDA #$4B
	JSL !PlaySFX
	
	
	;Y Button
	SaveScreen_SaveFileKeyPresses_Y:
	LDA $00AD ;Load button being pressed
	AND #$40 ;Checks if 'B' button is being pressed to back out of menu
	BEQ SaveScreen_SaveFileKeyPresses_A
	LDA $1E62 ;Load which option you're on (Yes No)
	BNE SaveScreen_SaveFileKeyPresses_BackToFileSelect
	BRA SaveScreen_SaveFileKeyPresses_SaveSuccess
	RTL
	
	;A Button
	SaveScreen_SaveFileKeyPresses_A:
	LDA $00AC ;Load button being pressed
	AND #$80 ;Checks if 'B' button is being pressed to back out of menu
	BEQ SaveScreen_SaveFileKeyPresses_B
	LDA $1E62 ;Load which option you're on (Yes No)
	BNE SaveScreen_SaveFileKeyPresses_BackToFileSelect
	BRA SaveScreen_SaveFileKeyPresses_SaveSuccess
	RTL
	
	;B Button
	SaveScreen_SaveFileKeyPresses_B:
	LDA $00AD ;Load button being pressed
	AND #$80 ;Checks if 'B' button is being pressed to back out of menu
	BEQ SaveScreen_SaveFileKeyPresses_Start
	
	SaveScreen_SaveFileKeyPresses_BackToFileSelect:
	SEP #$30
	LDA #$80
	STA $2115
	LDX #$0E ;Load 'Select file to save to. (Layer 3)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	
	LDA #$80
	STA $2115
	LDX #$0D ;Load '           ' (Layer 3) (Used to blank out Yes No)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	JSL AllowBankSendToVRAM
	
	LDA #$18
	JSL !PlaySFX
	
	LDA #$04 ;Sets value to load PasswordScreen_Event04 to back out to selecting a file again
	STA $01
	RTL
	
	
	;Start Button
	SaveScreen_SaveFileKeyPresses_Start:
	LDA $00AD ;Load button being pressed
	AND #$10 ;Checks if 'Start' button is being pressed to accept the save/load
	BEQ SaveScreen_SaveFileKeyPresses_End
	LDA $1E62 ;Load which option you're on (Yes No)
	BNE SaveScreen_SaveFileKeyPresses_BackToFileSelect
	
	SaveScreen_SaveFileKeyPresses_SaveSuccess:
	SEP #$30
	LDA #$80
	STA $2115
	LDX #$0E ;Load 'Select file to save to. (Layer 3)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	
	LDA #$80
	STA $2115
	LDX #$0D ;Load '           ' (Layer 3) (Used to blank out Yes No)' text
	LDA #$20 ;Palette of text
	STZ $0026
	JSL DisplayNewMenuText
	JSL AllowBankSendToVRAM
	
	LDA #$1D
	JSL !PlaySFX
	
	JSL SaveScreen_SendRAMToSRAM
	STZ $0026
	JSL DisplaySavedData_AllTextDataSkipBadSave
	
	LDA #$04
	STA $01
	RTL
	
	SaveScreen_SaveFileKeyPresses_End:
	RTL	
}

SaveScreen_SendRAMToSRAM: ;Stores RAM data into SRAM
{
	SEP #$20
	REP #$10
	
	LDY $0020
	STY $0000
	LDX #$0000
	
	SaveScreen_SendRAMToSRAM_StoreRomHeader:
	PHX
	LDA $80FFC0,x
	LDX $0000
	STA $700000,x
	INC $0000
	PLX
	INX
	CPX #$0016
	BNE SaveScreen_SendRAMToSRAM_StoreRomHeader
	
	SEP #$30
	
	PHP
	PHB
	SEP #$30
	LDA #$7E
	PHA
	PLB
	
	SEP #$20
	REP #$10
	
	LDX $0020
	LDA !CurrentPCCheck_1FFF ;Loads current PC
	STA $700016,x ;Stores current PC into SRAM
	
	; LDY #$0000
	
	; SaveScreen_SendSRAMToRAM_SendButtons:
	; LDA $FFC0,y ;Loads buttons to store into SRAM
	; STA $700017,x 
	; INX
	; INY
	; CPY #$0008
	; BNE SaveScreen_SendSRAMToRAM_SendButtons
	
	
	LDY #$0000
	LDX $0020
	
	SaveScreen_SendSRAMToRAM_VariousData:
	LDA $1FAF,y ;Loads various bit flags and data to store into SRAM
	STA $70001F,x
	INX 
	INY
	CPY #$002A
	BNE SaveScreen_SendSRAMToRAM_VariousData
	
	LDY #$0000
	LDX $0020
	
	SaveScreen_SendSRAMToRAM_AllPCData:
	LDA $F400,y ;Load all PC data and store into SRAM
	STA $700049,x
	INX
	INY
	CPY #$100
	BNE SaveScreen_SendSRAMToRAM_AllPCData
	
	PLB
	PLP
	SEP #$30
	RTL
}	


}

;*********************************************************************************
; Rewrites the 'Thank you for playing' scene
;*********************************************************************************
;B0EC
;B0F6
;B100
;B112
;B11C
{

EndingCredits_ThankYouForPlaying:
{
	LDX $D5
	JSR (EndingCredits_ThankYouForPlayingPointers,x)
	RTL
	
	EndingCredits_ThankYouForPlayingPointers:
	dw EndingCredits_ThankYouForPlaying_Event00
	dw EndingCredits_ThankYouForPlaying_Event02
	dw EndingCredits_ThankYouForPlaying_Event04
	dw EndingCredits_ThankYouForPlaying_Event06
	dw EndingCredits_ThankYouForPlaying_Event08
	dw EndingCredits_ThankYouForPlaying_Event0A
	
	
	EndingCredits_ThankYouForPlaying_Event00:
	LDA #$48 ;Loads 'Thank you for playing!!' text
	JSL $80868D ;Load routine to get JSR to load Layer 3 text on screen
	LDA #$49 ;Loads 'PRESENTED BY' text
	JSL $80868D ;Load routine to get JSR to load Layer 3 text on screen
	LDA #$4A ;Loads 'CAPCOM' logo
	JSL $80868D ;Load routine to get JSR to load Layer 3 text on screen
	STZ $1F55
	
	LDA #$4B ;Timer before Capcom logo flashes
	STA $1F56

	LDA #$02
	STA $D5
	RTS
	
	EndingCredits_ThankYouForPlaying_Event02:
	JSL $87FBDB ;Routine to check for wait time then flash Capcom logo
	BEQ EndingCredits_ThankYouForPlaying_Event02_SkipSetEvent
	LDA #$04
	STA $D5
	LDA #$74 ;Loads 'Press any button to save.' logo
	JSL $80868D ;Load routine to get JSR to load Layer 3 text on screen
	
	EndingCredits_ThankYouForPlaying_Event02_SkipSetEvent:
	RTS
	
	EndingCredits_ThankYouForPlaying_Event04:
	LDA $00AC
	BNE EndingCredits_ThankYouForPlaying_Event04_FadeScreen
	LDA $00AD
	BNE EndingCredits_ThankYouForPlaying_Event04_FadeScreen
	RTS
	
	EndingCredits_ThankYouForPlaying_Event04_FadeScreen:
	LDA #$06
	STA $D5
	RTS
	
	EndingCredits_ThankYouForPlaying_Event06:
	LDA !Difficulty_7EF4E0
	STA $0000
	
	LDA $0000
	ORA #$10 ;Sets game to NG+
	STA !Difficulty_7EF4E0
	LDA #$00
	STA !BossesDefeated1_7EF4E2 ;Remove all bosses defeated
	STZ !IntroductionLevelBIT_1FD3 ;Remove introduction bit done
	LDA !ZSaberObtained_1FB2 ;Load Z-Saber bit
	AND #$80 ;AND #$80 so it removes everything but the #$80
	STA !ZSaberObtained_1FB2 ;Store back to Z-Saber
	STZ !DopplerLabBIT_1FB0 ;Set Doppler Lab event to #$00
	STZ !CurrentDopplerLevel_1FAF ;Set current Doppler level to #$00
	STZ !SetCredits_1FB3 ;Store credits data to #$00
	STZ !BitByteVileCheck_1FD8 ;Store bit/byte/vile to #$00
	STZ $1FD9 ;Maybe something with Bit/Byte/Vile ;Set extra data for Bit/Byte/Vile to #$00
	STZ !DopplerTeleporters_1FDA ;Store Doppler Boss Teleporters done to #$00
	LDA !CurrentPCCheck_1FFF ;Load current PC
	BEQ EndingCredits_ThankYouForPlaying_Event06_NotZero
	LDA !CapsuleIntro_7EF4E4
	ORA #$80 ;This sets Zero as being the PC in NG for save
	STA !CapsuleIntro_7EF4E4
	BRA EndingCredits_ThankYouForPlaying_Event06_BeginSubWeapon
	
	EndingCredits_ThankYouForPlaying_Event06_NotZero:
	LDA !CapsuleIntro_7EF4E4
	AND #$01
	STA !CapsuleIntro_7EF4E4
	
	EndingCredits_ThankYouForPlaying_Event06_BeginSubWeapon:
	LDX #$00
	EndingCredits_ThankYouForPlaying_Event06_StoreSubWeaponLife:
	LDA #$1C
	STA !SubWeap_1FBB,x
	INX
	CPX #$08
	BNE EndingCredits_ThankYouForPlaying_Event06_StoreSubWeaponLife
	
	LDA !RideChipsOrigin_7E1FD7
	CMP #$F0
	BCS EndingCredits_ThankYouForPlaying_Event06_StoreHyperChargeLife
	BIT #$20
	BNE EndingCredits_ThankYouForPlaying_Event06_StoreHyperChargeLife
	BRA EndingCredits_ThankYouForPlaying_Event06_EndEvent
	
	EndingCredits_ThankYouForPlaying_Event06_StoreHyperChargeLife:
	LDX #$08
	LDA #$1C
	STA !SubWeap_1FBB,x
	STZ $1F5F ;Allows mid-boss doors to be opened, not sure if this is being stored properly so it'll be blanked.
	
	EndingCredits_ThankYouForPlaying_Event06_EndEvent:
	JSL $80B0DD ;Load Fade Out Screen
	RTS
	
	EndingCredits_ThankYouForPlaying_Event08:
	LDA #$09
	STA $CF
	JSL $80B10D ;Load Save Screen
	LDA #$0A
	STA $D5
	RTS
	
	EndingCredits_ThankYouForPlaying_Event0A: ;This sets it to go back to the title screen after saving or not saving
	JSL ClearPCRAM
	
	; REP #$30
	; LDX #$1F02
	
	; EndingCredits_ThankYouForPlaying_Event0A_ClearAllRAM:
	; STZ $DE,x
	; DEX
	; DEX
	; BPL EndingCredits_ThankYouForPlaying_Event0A_ClearAllRAM
	; STZ $1FFE
	
	; LDA #$0D37 ;Sets data so smoke/explosions work properly
	; STA $09D6

	; SEP #$30
	; LDA #$02
	; STA $38
	; LDA #$00
	; STA $39
	; STA $3A
	
	STZ $1FFE
	SEP #$30
	JML $808012
	RTS
}

}

;*********************************************************************************
; Recoded X spiral buster so it supports Zero as well
;*********************************************************************************
{
PC_BusterShot_Level4_5_FirstShot:
{
	STX $0010
	LDA !CurrentPC_0A8E
	TAX
	JSR (PC_BusterShot_Level4_5_FirstShotPointers,x)
	LDX $0010
	RTL

	PC_BusterShot_Level4_5_FirstShotPointers:
		dw X_BusterShot_Level4_5_FirstShot
		dw Zero_BusterShot_Level4_5_FirstShot
		dw PC3_BusterShot_Level4_5_FirstShot
		dw PC4_BusterShot_Level4_5_FirstShot
		db $FF,$FF
		db $FF,$FF
	
	
	X_BusterShot_Level4_5_FirstShot:
		LDA $8E
		TAX
		LDA X_Level4_5_Shots,x
		RTS
	
	Zero_BusterShot_Level4_5_FirstShot:
		LDA !ZSaberObtained_1FB2
		BIT #$02
		BNE Zero_BusterShot_Level4_5_FirstShot_Spiral
		LDA $8E
		TAX
		LDA Zero_Level4_5_Shots,x
		RTS
		
		Zero_BusterShot_Level4_5_FirstShot_Spiral:
		LDA $8E
		TAX
		LDA Zero_Level4_5_Spiral_Shots,x
		RTS
	
	PC3_BusterShot_Level4_5_FirstShot:
		LDA $8E
		TAX
		LDA Zero_Level4_5_Shots,x
		RTS
	
	PC4_BusterShot_Level4_5_FirstShot:
		LDA $8E
		TAX
		LDA Zero_Level4_5_Shots,x
		RTS
}

PC_BusterShot_Level4_5_SecondShot:
{
	STX $0010
	LDA !CurrentPC_0A8E
	TAX
	JSR (PC_BusterShot_Level4_5_SecondShotPointers,x)
	LDX $0010
	RTL

	PC_BusterShot_Level4_5_SecondShotPointers:
		dw X_BusterShot_Level4_5_SecondShot
		dw Zero_BusterShot_Level4_5_SecondShot
		dw PC3_BusterShot_Level4_5_SecondShot
		dw PC4_BusterShot_Level4_5_SecondShot
		db $FF,$FF
		db $FF,$FF
	
	
	X_BusterShot_Level4_5_SecondShot:
		LDA $8F
		CLC
		ADC #$04
		TAX
		LDA X_Level4_5_Shots,x
		RTS
	
	Zero_BusterShot_Level4_5_SecondShot:
		LDA !ZSaberObtained_1FB2
		BIT #$02
		BNE Zero_BusterShot_Level4_5_SecondShot_Spiral
		LDA $8F
		CLC
		ADC #$04
		TAX
		LDA Zero_Level4_5_Shots,x
		RTS
		
		Zero_BusterShot_Level4_5_SecondShot_Spiral:
		LDA $8F
		CLC
		ADC #$04
		TAX
		LDA Zero_Level4_5_Spiral_Shots,x
		RTS
	
	PC3_BusterShot_Level4_5_SecondShot:
		LDA $8F
		CLC
		ADC #$04
		TAX
		LDA Zero_Level4_5_Shots,x
		RTS
	
	PC4_BusterShot_Level4_5_SecondShot:
		LDA $8F
		CLC
		ADC #$04
		TAX
		LDA Zero_Level4_5_Shots,x
		RTS
}

Zero_SpiralBuster_SetMissile:
{
	LDA !CurrentPC_0A8E
	BNE Zero_SpiralBuster_SetMissile_27
	LDA #$1D ;Set X's missile to be #$1D
	BRA Zero_SpiralBuster_SetMissile_End
	
	Zero_SpiralBuster_SetMissile_27:
	LDA #$27 ;Set Zero's missile to #$27
	
	Zero_SpiralBuster_SetMissile_End:
	STA $000A,x
	RTL
}



Zero_SpiralBuster:
{
	; STZ $10E3 ;Sets main missile value to #$00 so Zero can properly load it up as well
	STZ $0B ;This should be removed for when Zero_SpiralBusterWIP is going
	
	LDA #$1D ;This should be removed for when Zero_SpiralBusterWIP is going
	STA $0A ;This should be removed for when Zero_SpiralBusterWIP is going
	JSL $81C0E8 ;Change this to load Zero_SpiralBusterWIP
	
	; JSL Zero_SpiralBusterWIP
	RTL
}


Zero_SpiralBusterWIP: ;Loads main central buster (Will probably need to recode this to be back to X2's normal way (Minus the X/Y coordinates)
{
	LDA $0B
	CMP #$02
	BEQ Zero_SpiralBusterWIP_LoadMainBuster
	JML Zero_SpiralBusterSpirals
	; JML $818974 ;This should be replaced to load the spirals
	RTL
	
	Zero_SpiralBusterWIP_LoadMainBuster:
	LDX $01
	JMP (Zero_SpiralBusterWIP_Pointers,x) ;This loads the main buster shot itself
	RTL
	
	Zero_SpiralBusterWIP_Pointers:
		dw Zero_SpiralBusterWIP_MissileEvent00
		dw Zero_SpiralBusterWIP_MissileEvent02
		dw Zero_SpiralBusterWIP_MissileEvent04
		dw Zero_SpiralBusterWIP_MissileEvent06
		dw Zero_SpiralBusterWIP_MissileEvent08
		dw Zero_SpiralBusterWIP_MissileEvent0A

		
		Zero_SpiralBusterWIP_MissileEvent00: ;Missing sprite assembly (Currently using X3's default for it)
		{
			LDA #$00
			JSL $84A556
			
			LDA #$02
			STA $01
			LDA #$FF
			STA $10
			INC $0A55
			STZ $30
			LDA #$04
			STA $12
			LDA #$08
			STA $18
			
			LDA !PCPaletteDirection_09E9
			AND #$70
			ORA #$06
			STA $11
			JSL $818398 ;Loads routine to get X/Y coordinates of buster (Needs a JSR)

			
			REP #$20
			LDA #$0200 ;Beginning speed of buster shot
			BIT $10
			BVS Zero_SpiralBusterWIP_MissileEvent00_IgnoreSpeedChange
			LDA #$FE00
			
			Zero_SpiralBusterWIP_MissileEvent00_IgnoreSpeedChange:
			STA $1A
			STZ $1C
			LDA #$4000 ;Final speed of buster
			STA $1E
			
			LDA #$B867 ;Buster hit box pointer
			STA $20
			
			LDA #$DDE5 ;VRAM Pointer
			STA $31
			
			SEP #$20
			REP #$10
			LDY #$0002 ;How many sub-missiles to load around the buster [MUST CHANGE BACK TO #$02 once the other missiles are loaded!]
			
			Zero_SpiralBusterWIP_MissileEvent00_CheckMissileRoom:
			JSL !CheckMissileRoom
			BNE Zero_SpiralBusterWIP_MissileEvent00_IgnoreLoadingMissile
			
			INC $0000,x
			LDA #$27 ;Set sub-missile data (Probably set to #$27)
			STA $000A,x
			TYA
			STA $000B,x
			LDA $11
			STA $0011,x
			LDA $18
			STA $0018,x
			
			REP #$20
			TDC
			STA $000C,x
			LDA $05
			STA $0005,x
			LDA $08
			STA $0008,x
			
			SEP #$20
			DEY
			BNE Zero_SpiralBusterWIP_MissileEvent00_CheckMissileRoom
			
			Zero_SpiralBusterWIP_MissileEvent00_IgnoreLoadingMissile:
			SEP #$10
			LDA #$4E ;Sprite assembly (Using default from X3)
			STA $16
			LDA #$01 ;Animation Data
			JSL !AnimationOneFrame
			JSL !VRAMRoutineAlt
			JML !EventLoop
		}
			
		Zero_SpiralBusterWIP_MissileEvent02: ;Complete
		{
			LDA $0E
			BNE Zero_SpiralBusterWIP_MissileEvent02_SkipSet0A
			LDA #$0A
			STA $01
			RTL
			
			Zero_SpiralBusterWIP_MissileEvent02_SkipSet0A:
			BIT $11
			BVS Zero_SpiralBusterWIP_MissileEvent02_Check82D719
			JSL !CheckForGround
			
			REP #$20
			LDA #$F800
			CMP $1A
			BMI Zero_SpiralBusterWIP_MissileEvent02_SkipStore1A
			STA $1A
			BRA Zero_SpiralBusterWIP_MissileEvent02_SkipStore1A
			
			Zero_SpiralBusterWIP_MissileEvent02_Check82D719:
			JSL $82D719 ;Possibly Check For Air?
			
			REP #$20
			LDA #$0800
			CMP $1A
			BPL Zero_SpiralBusterWIP_MissileEvent02_SkipStore1A
			STA $1A
			
			Zero_SpiralBusterWIP_MissileEvent02_SkipStore1A:
			SEP #$20
			JSL !VRAMRoutineAlt
			JSL $84BDB9
			JML !EventLoop
			
			JSL !AnimationOneFrame
			JSL !VRAMRoutineAlt
			JML !EventLoop
		}
			
		Zero_SpiralBusterWIP_MissileEvent04: ;Complete
		{
			LDX $02
			BNE Zero_SpiralBusterWIP_MissileEvent04_Check0F
			INC $02
			LDA #$03
			JSL !AnimationOneFrame
			
			Zero_SpiralBusterWIP_MissileEvent04_Check0F:
			LDA $0F
			BPL Zero_SpiralBusterWIP_MissileEvent04_End
			LDA #$0A
			STA $01
			
			Zero_SpiralBusterWIP_MissileEvent04_End:
			JSL !VRAMRoutineAlt
			JSL $84BDB9
			JML !EventLoop
		}
		
		Zero_SpiralBusterWIP_MissileEvent06: ;Complete
		{
			LDA #$02
			STA $01
			STZ $30
			BRL Zero_SpiralBusterWIP_MissileEvent02
		}
		
		Zero_SpiralBusterWIP_MissileEvent08: ;Complete
		{
			LDA #$0A
			STA $01
			JML $84D757
		}
		
		Zero_SpiralBusterWIP_MissileEvent0A: ;Complete
		{
			DEC $0A0D
			DEC $0A55
			JML $82D933
		}
		
}

Zero_SpiralBusterSpirals:
{
	LDX $01
	JMP (Zero_SpiralBusterSpirals_Pointers,x)
	RTL
	
	Zero_SpiralBusterSpirals_Pointers:
		dw Zero_SpiralBusterSpirals_MissileEvent00
		dw Zero_SpiralBusterSpirals_MissileEvent02
		dw Zero_SpiralBusterSpirals_MissileEvent04
		dw Zero_SpiralBusterSpirals_MissileEvent06
		dw Zero_SpiralBusterSpirals_MissileEvent08
		dw Zero_SpiralBusterSpirals_MissileEvent0A
		
	
		Zero_SpiralBusterSpirals_MissileEvent00:
		{
			LDA #$02
			STA $01
			LDA #$FF
			STA $10
			INC $0A0D
			INC $0A55
			STZ $30

			LDA $0B
			TAX
			
			bank noassume : LDA Zero_SpiralBusterSpirals_TrajectorySetup,x ;Loads projectile trajectory?
			bank auto
			STA $37
			
			LDA #$01
			STA $38
			
			LDA $18
			CLC
			ADC #$04
			STA $18

			REP #$20
			LDA $0B
			AND #$00FF
			DEC A 
			ASL A 
			TAX
			
			bank noassume : LDA Zero_SpiralBusterSpirals_XCoordinates,x ;X coordinates of missile
			bank auto
			
			AND #$00FF
			BIT #$0080
			BEQ Zero_SpiralBusterSpirals_MissileEvent00_NoORA1
			ORA #$FF00
			
			Zero_SpiralBusterSpirals_MissileEvent00_NoORA1:
			CLC
			ADC $05
			STA $05

			bank noassume : LDA Zero_SpiralBusterSpirals_YCoordinates,x ;Y coordinates of missile
			bank auto
			
			AND #$00FF
			BIT #$0080
			BEQ Zero_SpiralBusterSpirals_MissileEvent00_NoORA2
			ORA #$FF00
			
			Zero_SpiralBusterSpirals_MissileEvent00_NoORA2:
			CLC
			ADC $08
			STA $08

			LDA #$BB1A ;Buster hit box pointer
			STA $20
			LDA #$DCF0 ;VRAM Pointer
			STA $31

			LDA $0B
			AND #$00FF
			DEC A 
			XBA
			CLC
			ADC #$B800 ;???
			STA $39

			SEP #$20
			JSL $818390
			JSL Zero_SpiralBusterSpirals_Custom

			STZ $3D
			JSL Zero_SpiralBusterSpirals_Trajectory ;Loads routine to get trajectory data for weapon

			LDA #$54
			STA $16

			LDA #$01
			JSL !AnimationOneFrame

			LDA $0B
			CMP #$01
			BNE Zero_SpiralBusterSpirals_MissileEvent00_End
			JSL $84BDB9
			
			Zero_SpiralBusterSpirals_MissileEvent00_End:
			JML !EventLoop



		; $2A/C30B A9 02       LDA #$02                A:0302 X:0000 Y:0008 P:envMXdIZc
		; $2A/C30D 85 01       STA $01    [$00:1119]   A:0302 X:0000 Y:0008 P:envMXdIzc
		; $2A/C30F A9 FF       LDA #$FF                A:0302 X:0000 Y:0008 P:envMXdIzc
		; $2A/C311 85 10       STA $10    [$00:1128]   A:03FF X:0000 Y:0008 P:eNvMXdIzc
		; $2A/C313 EE 0D 0A    INC $0A0D  [$06:0A0D]   A:03FF X:0000 Y:0008 P:eNvMXdIzc
		; $2A/C316 EE 55 0A    INC $0A55  [$06:0A55]   A:03FF X:0000 Y:0008 P:envMXdIzc
		; $2A/C319 64 30       STZ $30    [$00:1148]   A:03FF X:0000 Y:0008 P:envMXdIzc
		; $2A/C31B A6 0B       LDX $0B    [$00:1123]   A:03FF X:0000 Y:0008 P:envMXdIzc
		; $2A/C31D BD 59 BA    LDA $BA59,x[$06:BA5B]   A:03FF X:0002 Y:0008 P:envMXdIzc ;Load missile data? [Loads only 06:BA5A/06:BA5B]
		; $2A/C320 85 37       STA $37    [$00:114F]   A:032A X:0002 Y:0008 P:envMXdIzc
		; $2A/C322 A9 01       LDA #$01                A:032A X:0002 Y:0008 P:envMXdIzc
		; $2A/C324 85 38       STA $38    [$00:1150]   A:0301 X:0002 Y:0008 P:envMXdIzc
		; $2A/C326 A5 18       LDA $18    [$00:1130]   A:0301 X:0002 Y:0008 P:envMXdIzc
		; $2A/C328 18          CLC                     A:0308 X:0002 Y:0008 P:envMXdIzc
		; $2A/C329 69 04       ADC #$04                A:0308 X:0002 Y:0008 P:envMXdIzc
		; $2A/C32B 85 18       STA $18    [$00:1130]   A:030C X:0002 Y:0008 P:envMXdIzc
		; $2A/C32D C2 20       REP #$20                A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C32F A5 0B       LDA $0B    [$00:000B]   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C331 29 FF 00    AND #$00FF              A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C334 3A          DEC A                   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C335 0A          ASL A                   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C336 AA          TAX                     A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C337 BD 55 BA    LDA $BA55,x[$06:BB54]   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C33A 29 FF 00    AND #$00FF              A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C33D 89 80 00    BIT #$0080              A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C340 F0 03       BEQ $03    [$C345]      A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C342 09 00 FF    ORA #$FF00              A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C345 18          CLC                     A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C346 65 05       ADC $05    [$00:0005]   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C348 85 05       STA $05    [$00:0005]   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C34A BD 56 BA    LDA $BA56,x[$06:BB55]   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C34D 29 FF 00    AND #$00FF              A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C350 89 80 00    BIT #$0080              A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C353 F0 03       BEQ $03    [$C358]      A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C355 09 00 FF    ORA #$FF00              A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C358 18          CLC                     A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C359 65 08       ADC $08    [$00:0008]   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C35B 85 08       STA $08    [$00:0008]   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C35D A9 51 BA    LDA #$BA51              A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C360 85 20       STA $20    [$00:0020]   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C362 A9 58 9C    LDA #$9C58              A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C365 85 31       STA $31    [$00:0031]   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C367 A5 0B       LDA $0B    [$00:000B]   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C369 29 FF 00    AND #$00FF              A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C36C 3A          DEC A                   A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C36D EB          XBA                     A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C36E 18          CLC                     A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C36F 69 00 B8    ADC #$B800              A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C372 85 39       STA $39    [$00:0039]   A:0100 X:00FF Y:0001 P:envmxdIZc

		; $2A/C374 E2 20       SEP #$20                A:0100 X:00FF Y:0001 P:envmxdIZc
		; $2A/C376 20 DF C4    JSR $C4DF  [$00:C4DF]   A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C379 20 AB C4    JSR $C4AB  [$00:C4AB]   A:0100 X:00FF Y:0001 P:envMxdIZc

		; $2A/C37C 64 3D       STZ $3D    [$00:003D]   A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C37E 20 32 C4    JSR $C432  [$00:C432]   A:0100 X:00FF Y:0001 P:envMxdIZc

		; $2A/C381 A9 54       LDA #$54                A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C383 85 16       STA $16    [$00:0016]   A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C385 A9 01       LDA #$01                A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C387 22 90 C6 08 JSL $08C690[$08:C690]   A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C38B A5 0B       LDA $0B    [$00:000B]   A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C38D C9 01       CMP #$01                A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C38F D0 04       BNE $04    [$C395]      A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C391 22 B8 C9 08 JSL $08C9B8[$08:C9B8]   A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C395 5C 59 D8 00 JMP $00D859[$00:D859]   A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C399 A9 02       LDA #$02                A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C39B 85 01       STA $01    [$00:0001]   A:0100 X:00FF Y:0001 P:envMxdIZc
		; $2A/C39D 64 30       STZ $30    [$00:0030]   A:0100 X:00FF Y:0001 P:envMxdIZc
		}

		Zero_SpiralBusterSpirals_MissileEvent02:
		{
			LDA $0E
			BNE Zero_SpiralBusterSpirals_MissileEvent02_Continue
			LDA #$0A 
			STA $01
			RTL

			Zero_SpiralBusterSpirals_MissileEvent02_Continue:
			BIT $11
			BVS Zero_SpiralBusterSpirals_MissileEvent02_JSL

			JSL $82D6F8

			REP #$20 
			LDA #$F800
			CMP $1A
			BMI Zero_SpiralBusterSpirals_MissileEvent02_IgnoreSTA
			STA $1A
			BRA Zero_SpiralBusterSpirals_MissileEvent02_IgnoreSTA

			Zero_SpiralBusterSpirals_MissileEvent02_JSL:
			JSL $82D719

			REP #$20 
			LDA #$0800
			CMP $1A
			BPL Zero_SpiralBusterSpirals_MissileEvent02_IgnoreSTA
			STA $1A

			Zero_SpiralBusterSpirals_MissileEvent02_IgnoreSTA:
			SEP #$20 
			JSL !VRAMRoutineAlt
			JSL $84BDB9
			JML !EventLoop
		
		}
		
		Zero_SpiralBusterSpirals_MissileEvent04:
		{
			LDX $02
			BNE Zero_SpiralBusterSpirals_MissileEvent04_SkipAnimationOneFrame
			INC $02
			LDA #$03
			JSL !AnimationOneFrame

			Zero_SpiralBusterSpirals_MissileEvent04_SkipAnimationOneFrame:
			LDA $0F
			BPL Zero_SpiralBusterSpirals_MissileEvent04_SkipStorage
			LDA #$0A
			STA $01

			Zero_SpiralBusterSpirals_MissileEvent04_SkipStorage:
			JSL !VRAMRoutineAlt
			JSL $84BDB9
			JML !EventLoop
		}
		
		Zero_SpiralBusterSpirals_MissileEvent06:
		{
			LDA #$02
			STA $01
			STZ $30
			BRL Zero_SpiralBusterSpirals_MissileEvent02
		}

		Zero_SpiralBusterSpirals_MissileEvent08:
		{
			LDA #$0A
			STA $01
			JML $84D757
		}
			
		Zero_SpiralBusterSpirals_MissileEvent0A:
		{
			DEC $0A0D
			DEC $0A55
			JML $82D933
		}
		
		
		
		
		
		
		Zero_SpiralBusterSpirals_Custom:
		{
			REP #$10
			LDY #$0002

			Zero_SpiralBusterSpirals_Custom_LoopPoint:
			JSL $82D873
			BNE Zero_SpiralBusterSpirals_Custom_End

			INC $0000,x
			LDA #$05 
			STA $000A,x
			LDA $11
			STA $0011,x
			TYA
			STA $000B,x
			LDA $18
			STA $0018,x

			REP #$20 
			TDC
			STA $000C,x
			LDA $39
			STA $001A,x

			SEP #$20 
			DEY
			BPL Zero_SpiralBusterSpirals_Custom_LoopPoint

			Zero_SpiralBusterSpirals_Custom_End:
			SEP #$10 
			RTL
		}
		
		Zero_SpiralBusterSpirals_Trajectory:
		{
			DEC $38
			BNE Zero_SpiralBusterSpirals_Trajectory_End

			Zero_SpiralBusterSpirals_Trajectory_Loop:
			PHX
			LDX $37
			
			bank noassume : LDA Zero_SpiralBusterSpirals_TrajectoryData,x ;Y coordinates of missile
			bank auto
			
			BNE Zero_SpiralBusterSpirals_Trajectory_SkipLoop
			STZ $37
			BRA Zero_SpiralBusterSpirals_Trajectory_Loop

			Zero_SpiralBusterSpirals_Trajectory_SkipLoop:
			STA $38
			INX
			
			bank noassume : LDA Zero_SpiralBusterSpirals_TrajectoryData,x ;Y coordinates of missile
			bank auto
			STA $12

			REP #$20
			bank noassume : LDA Zero_SpiralBusterSpirals_TrajectoryData,x ;Y coordinates of missile
			bank auto
			STA $1A
			
			bank noassume : LDA Zero_SpiralBusterSpirals_TrajectoryData,x ;Y coordinates of missile
			bank auto
			STA $1C

			SEP #$20
			LDA $37
			CLC
			ADC #$06
			STA $37
			
			PLX

			Zero_SpiralBusterSpirals_Trajectory_End:
			RTL
		}
		
		
		
		Zero_SpiralBusterSpirals_XCoordinates: ;Loads X coordinates of Spirals
		{
			db $08
			db $00
			db $F8
			db $00
		
		Zero_SpiralBusterSpirals_YCoordinates: ;Loads X coordinates of Spirals
			db $EB
			db $00
			db $15
			db $00
		}

		Zero_SpiralBusterSpirals_TrajectorySetup:
		{
			db $00
			db $00
			db $2A
		}
		
		Zero_SpiralBusterSpirals_TrajectoryData:
		{
			db $01,$02,$00,$FC,$00,$FF,$01,$02,$00,$FA,$00,$FB,$01,$02,$00,$FB
			db $00,$F7,$01,$02,$00,$FD,$00,$F8,$01,$02,$00,$FF,$00,$F6,$01,$02
			db $00,$01,$00,$FB,$01,$02,$00,$02,$00,$FC,$01,$06,$00,$04,$00,$01
			db $01,$06,$00,$06,$00,$05,$01,$06,$00,$05,$00,$09,$01,$06,$00,$03
			db $00,$08,$01,$06,$00,$01,$00,$0A,$01,$06,$00,$FF,$00,$05,$01,$06
			db $00,$FE,$00,$04,$00,$00,$00,$06,$06,$00,$00,$13,$0E,$00,$00,$06
			db $06,$00

		}
		
		
		
		}
}

;*********************************************************************************
; Various sub-weapon alterations
;*********************************************************************************
{
PC_SetGravityWell_Physics: ;Sets PC physics when Charged Gravity Well is in progress.
{
	LDX !CurrentPC_0A8E
	JSR (PC_SetGravityWell_PhysicsPointers,x)
	RTL

	PC_SetGravityWell_PhysicsPointers:
		dw X_SetGravityWell_Physics
		dw Zero_SetGravityWell_Physics
		dw PC3_SetGravityWell_Physics
		dw PC4_SetGravityWell_Physics
		db $FF,$FF
		db $FF,$FF
	
	
	X_SetGravityWell_Physics:
		LDA #$08
		TSB $0550 ;Sets Gravity Well to 'slam' enemies
		
		LDA #$20
		TSB $1F40 ;Sets underwater physics for PC
		RTS
		
	Zero_SetGravityWell_Physics:
		LDA #$08
		TSB $0550 ;Sets Gravity Well to 'slam' enemies
		
		LDA #$20
		TSB $1F40 ;Sets underwater physics for PC
		RTS
		
	PC3_SetGravityWell_Physics:
		LDA #$08
		TSB $0550 ;Sets Gravity Well to 'slam' enemies
		
		LDA #$20
		TSB $1F40 ;Sets underwater physics for PC
		RTS
		
	PC4_SetGravityWell_Physics:
		LDA #$08
		TSB $0550 ;Sets Gravity Well to 'slam' enemies
		
		LDA #$20
		TSB $1F40 ;Sets underwater physics for PC
		RTS
}

PC_ResetGravityWell_Physics: ;Sets PC physics when Charged Gravity Well is in progress.
{
	LDX !CurrentPC_0A8E
	JSR (PC_ResetGravityWell_PhysicsPointers,x)
	RTL

	PC_ResetGravityWell_PhysicsPointers:
		dw X_ResetGravityWell_Physics
		dw Zero_ResetGravityWell_Physics
		dw PC3_ResetGravityWell_Physics
		dw PC4_ResetGravityWell_Physics
		db $FF,$FF
		db $FF,$FF
	
	
	X_ResetGravityWell_Physics:
		LDA #$08
		TRB $0550
		
		LDA #$20
		TRB $1F40 ;Sets underwater physics for PC
		RTS
		
	Zero_ResetGravityWell_Physics:
		LDA #$08
		TRB $0550
		
		LDA #$20
		TRB $1F40 ;Sets underwater physics for PC
		RTS
		
	PC3_ResetGravityWell_Physics:
		LDA #$08
		TRB $0550
		
		LDA #$20
		TRB $1F40 ;Sets underwater physics for PC
		RTS
		
	PC4_ResetGravityWell_Physics:
		LDA #$08
		TRB $0550
		
		LDA #$20
		TRB $1F40 ;Sets underwater physics for PC
		RTS
}

PC_Menu_ChangedSubWeapon: ;Resets data when leaving menu and you don't have the same sub-weapon on.
{
	LDA #$20
	TRB $1F40 ;Sets underwater physics for PC
	LDA $0A
	STA !CurrentPCSubWeapon_0A0B
	RTL
}

PC_GravityWell_UnderwaterBubbles: ;Sets code for when underwater and $7E:1F40 is set (Unsure what this is)
{
	REP #$20
	LDA $1F40
	BEQ PC_GravityWell_UnderwaterBubbles_IgnoreLand
	BIT #$0020
	BNE PC_GravityWell_UnderwaterBubbles_IgnoreLand
	STA $08
	
	PC_GravityWell_UnderwaterBubbles_IgnoreLand:
	RTL
}

PC_GravityWell_Bubbles: ;Sets code for when underwater and $7E:1F40 is set
{
	REP #$20
	LDA $1F40
	BEQ PC_GravityWell_Bubbles_SkipStorage
	BIT #$0020
	BNE PC_GravityWell_Bubbles_SkipStorage
	CMP $08
	
	PC_GravityWell_Bubbles_SkipStorage:
	SEP #$20
	BEQ PC_GravityWell_Bubbles_EraseBubbles
	BCC PC_GravityWell_Bubbles_End
	
	PC_GravityWell_Bubbles_EraseBubbles:
	JML $82D928
	
	PC_GravityWell_Bubbles_End:
	LDX #$00
	RTL
}

}

;*********************************************************************************
; Modifying various enemy events and such.
;*********************************************************************************	
{
MacEventNoLifeBar:
{
	LDA #$04
	STA !PCHealthBar_1F22
	STA !PCSubWeaponAmmoBar_1F23
	STZ !CurrentPCSubWeapon_0A0B
	
	JSL PCGeneralPalettes
	JSL !ClearMissiles ;Clears missiles off screen
	
	REP #$20
	STZ $08
	RTL
}
Mac_AI_0A: ;Loads routine to get Mac's AI event for when he's hit by Z-Saber or Tornado Fang.
{
	JSL $82DDFE
	LDA $01
	CMP #$04 ;Z-Saber Wave
	BNE Mac_AI_0A_NotZSaber
	
		JML $93E699
		RTL
	
	Mac_AI_0A_NotZSaber:
	JSL $84D8D5
	JML $88B808
	RTL
}
MaohTheGiant_AI:
{
	LDX $01
	JMP (MaohTheGiant_AI_Pointers,x)
	RTL
	
	MaohTheGiant_AI_Pointers:
	dw MaohTheGiant_AI_00
	dw MaohTheGiant_AI_02
	dw MaohTheGiant_AI_04
	dw MaohTheGiant_AI_06
	dw MaohTheGiant_AI_08
	dw MaohTheGiant_AI_0A
	
	MaohTheGiant_AI_00:
		JML $82E7EB
		
	MaohTheGiant_AI_02:
		JML $82E876
		
	MaohTheGiant_AI_04:
		JML $82EAC5
		
	MaohTheGiant_AI_06: ;DOESN'T EXIST
		RTL
		
	MaohTheGiant_AI_08: ;DOESN'T EXIST
		RTL
		
	MaohTheGiant_AI_0A:
		JSL $82DDFE
		LDA $01
		CMP #$04 ;Z-Saber Wave
		BNE MaohTheGiant_AI_0A_NotZSaber
		JML $93EC4C
		RTL
		
	MaohTheGiant_AI_0A_NotZSaber:
		JSL $84D8D5
		JSL $82DF64
		JML $82E876
		RTL
}

}
