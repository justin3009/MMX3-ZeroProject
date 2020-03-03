;Bugs
;-----------------




;==================================================================================
; Mega Man X3 (Base Mod Project)
; By xJustin3009x (Shishisenkou) (Justin3009)
;==================================================================================
; This file is used to import the code changes that separate all characters from one
; another so they can have individual stats instead of group stats.
;==================================================================================
; NOTE: The ROM MUST be expanded to 4MB first WITHOUT a header!
;==================================================================================
;***************************
;Blank data
;***************************
;B9:C1BC - $B9:FFFF
;***************************
;***************************
; ROM Addresses
;***************************
		!XMainEvents	= $E0C000
;***************************
header : lorom

incsrc MMX3_NewCode_Locations.asm
incsrc MMX3_VariousAddresses.asm

;***************************
;***************************
; Pointers to X Events
;***************************
org !XMainEvents
	LDX $01
	JMP (XMainEventPointers,x)
	
XMainEventPointers:
	dw XEvent00SpyCopterBase
	dw XEvent02XGetsCapturedBase
	dw XEvent04RescueXBase
	dw XEvent06XMaohGiantBase
	dw XEvent08XPowerCellDamagedBase ;UNUSED AND COMPLETELY BLANK
	dw XEvent0ADrCainFindLabBase
	dw XEvent0CREX2000Base
	dw XEvent0EMosquitusBase
	dw XEvent10BusterWallBase
	dw XEvent12SigmaVirusBase
	dw XEvent14CliffSceneBase
	dw XEvent16CreditsBase
	dw $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
	dw $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
	dw $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
	dw $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
	dw $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF
	dw $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF

;***************************
;***************************
; Event #00: Spycopter 
;***************************
XEvent00SpyCopterBase:
	LDX !PCNPC_EventID_02
	JMP (XEvent00SpyCopterEvents,x)

XEvent00SpyCopterEvents:
	dw XSpyCopter00
	dw XSpyCopter02
	dw XSpyCopter04
	dw XSpyCopter06
	dw XSpyCopter08
	dw XSpyCopter0A
	dw XSpyCopter0C
	dw XSpyCopter0E
	dw XSpyCopter10
	dw XSpyCopter12
	dw XSpyCopter14
	dw XSpyCopter16
	db $FF,$FF


	;***************************
	; Sub-event #00: Sets X's sprite data up & palette, Z-Saber palette, X's jump velocity, distance and hitbox.
	;***************************
XSpyCopter00:
		INC !PCNPC_EventID_02 ;Increase X Introduction Event to 02
		INC !PCNPC_EventID_02 ;Increase X Introduction Event to 02
		LDA #$2C ;Set PC NPC's palette RAM location [ABSOLUTELY REQUIRED BEFORE JSLING TO SPRITES FIRST TIME]
		STA !PCNPC_PaletteDirection_11
		JSL XSetup ;Load X's sprite settings
		LDA #$04
		STA !PCNPC_SpritePriority_12
		LDA #$52 ;X Jump Animation
		JSL !AnimationOneFrame
		JSL NewVRAMRoutine
		
		REP #$10
		LDX #$0070 ;Load RAM location to store palette
		LDY #$0040 ;Load Buster palette
		JSL !Palette
		REP #$20
		LDA !ScreenXCoordinate_1E5D
		CLC
		ADC #$0100
		STA !PCNPC_XCoordinate_05
		LDA !ScreenYCoordinate_1E60
		CLC
		ADC #$00E0
		STA !PCNPC_YCoordinate_08
		LDA #$0710 ;Load velocity of X
		STA !PCNPC_Velocity_1C
		LDA #$FE80 ;Load distance/speed of X
		STA !PCNPC_SpeedDistance_1A
		LDA #$0040 ;Load hitbox of X
		STA !PCNPC_JumpHeight_1E
		SEP #$30
		RTL
		
	;***************************
	; Sub-event #02: X flying up to land on Spycopter
	;***************************
XSpyCopter02:
		JSL !CheckForGround
		BIT $1D
		BPL SpyCopter02Loop
		REP #$20
		LDA $08 ;Y coordinate of NPC
		CMP #$0178 ;Check for value
		SEP #$20
		BMI SpyCopter02Loop ;If <= #$0178, BMI to $03/A8D2 to ignore event increase and loop event
		
		INC !PCNPC_EventID_02 ;Increase X Introduction Spycopter Event to 04
		INC !PCNPC_EventID_02 ;Increase X Introduction Spycopter Event to 04
		LDA #$6F ;Load animation for X landing on Spycopter
		JML !VRAMRoutineConsistent
SpyCopter02Loop:
		JML !AnimationConsistent
		
	;***************************
	; Sub-event #04: X landing on Spycopter
	;***************************
XSpyCopter04:
		REP #$30
		LDX $1F57 ;Load base RAM for Spycopter
		LDA $0005,x ;X coordinates of Spycopter
		CLC
		ADC #$0018
		STA !PCNPC_XCoordinate_05 ;Store to NPC RAM X coordinates
		LDA $0008,x
		STA !PCNPC_YCoordinate_08 ;Store to NPC RAM Y coordinates
		LDA !ScreenXCoordinate_1E5D
		CMP #$09D0
		BPL XSpyCopter04Increase
		SEP #$30
		JML !AnimationConsistent
		
XSpyCopter04Increase:
		LDA #$0600 ;Load speed/stance of NPC
		STA !PCNPC_SpeedDistance_1A
		LDA #$0380 ;Load velocity of NPC 
		STA !PCNPC_Velocity_1C
		SEP #$30
		INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 06
		INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 06
		LDA #$72 ;Load X kicking off wall animation
		JML !VRAMRoutineConsistent
		
	;***************************
	; Sub-event #06: Check for PC landing on spy copter
	;***************************
XSpyCopter06:
		JSL !CheckForGround
		LDA $0F
		BMI XSpyCopter06Increase
		JML !AnimationConsistent
		
XSpyCopter06Increase:
		INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 08
		INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 08
		REP #$20
		STZ !PCNPC_SpeedDistance_1A  ;Store 00 to PC NPC RAM at $7E:0CE2 (PC NPC jump speed/distance low byte)
		SEP #$20
		STZ !PCNPC_TempStorage_33
		LDA #$03
		STA !PCNPC_DelayTimer_3C
		LDA #$03 ;Load X buster animation
		JML !VRAMRoutineConsistent
		
	;***************************
	; Sub-event #08: Draw Buster object
	;***************************
XSpyCopter08:
			JSL !CheckForGround
			
			REP #$20
			LDA #$FA80
			CMP !PCNPC_Velocity_1C
			BMI XSpyCopter08IgnoreStorage
			STA !PCNPC_Velocity_1C
XSpyCopter08IgnoreStorage:
			SEP #$20

			DEC !PCNPC_DelayTimer_3C
			BNE XSpyCopter08Animation
			
			LDA !PCNPC_TempStorage_33
			BNE XSpyCopter08Increase
			
			LDA #$04
			STA !PCNPC_DelayTimer_3C
		
			LDA #$05 ;Kinda janky but having the actual X-Buster appear breaks because main PC is already firing missiles.
			;This causes the Buster's X/Y coordinate data to get overwritten by what's on screen at the time.
			JSL !PlaySFX

			LDA !PCNPC_PaletteDirection_11 ;Load PC NPC's direction and stores same value into Z-Saber
			AND #$70
			ORA #$0E
			STA $0011,x
			REP #$30
			STX !PCNPC_UNKNOWN_45
			SEP #$30
			
			LDA #$01
			STA !PCNPC_TempStorage_33

XSpyCopter08Animation:			
			SEP #$30
			JML !AnimationConsistent
			
XSpyCopter08Increase:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0A
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0A
			
			REP #$30
			LDX !PCNPC_UNKNOWN_45
			STZ $003F,x
			SEP #$30
			
			STZ !PCNPC_TempStorage_33
			LDA #$57 ;Load X falling animation
			JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #0A: Spycopter breaking with NPC X falling/landing
	;***************************
XSpyCopter0A:
			REP #$20
			LDA #$FA80
			CMP !PCNPC_Velocity_1C
			BMI XSpyCopter0AIgnoreStorage
			STA !PCNPC_Velocity_1C
XSpyCopter0AIgnoreStorage:
			SEP #$20
			
			JSL !CheckForGround
			JSL !LandOnGround
			LDA !PCNPC_OnGround_2B ;Load byte to determine if NPC is on ground or in air
			BIT #$04 ;BIT #$04 (On ground)
			BNE XSpyCopter0AIncrease
			JML !AnimationConsistent
			
XSpyCopter0AIncrease:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0C
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0C
			LDA #$3C ;Load delay timer before dialogue box can load up
			STA !PCNPC_DelayTimer_3C ;Store to NPC RAM at $7E:0D04
			LDA #$50 ;Load animation for X landing on ground
			JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #0C: Initiate data to draw dialogue box
	;***************************
XSpyCopter0C:
			DEC !PCNPC_DelayTimer_3C ;Decrease delay timer from $7E:0D04
			BEQ XSpyCopter0CSkipAnimation
			JSL !VRAMRoutineAlt ;Load alternate force VRAM update? (Can be changed to 04:BCA2 and it works just fine still?)
			JML !EventLoop
			
XSpyCopter0CSkipAnimation:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0E
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0E
			LDA #$3C ;Load delay timer before X teleports out after dialogue
			STA !PCNPC_DelayTimer_3C
			
			REP #$20
			LDA !CurrentPCAction_09DA
			STA !PCNPC_TempStorage_33
			LDA #$0866
			STA !CurrentPCAction_09DA
			SEP #$20
			
			LDA #$30 ;Load which dialogue to use
			JSL !DialogueBoxNormal
			LDA #$50 ;Load frame to use after X NPC is done talking
			STA !PCNPC_AnimationFrameDoneTalk_43
			LDA #$87 ;Load frame for X Talking
			JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #0E: Initiate data to draw dialogue box
	;***************************
XSpyCopter0E:
			LDA !EnableEventLock_1F3F
			BPL XSpyCopter0EIncrease
			LDA $1F51 ;Load NPC talk animation bit
			BNE XSpyCopter0ECheckVRAM
			
			LDA $1F50 ;Check for NPC allowed to talk animation bit
			CMP #$01
			BEQ XSpyCopter0EVRAMUpdate
			
XSpyCopter0ECheckVRAM:
			LDA !PCNPC_IsAnimating_0F ;Load flag to check if NPC needs to update their VRAM data
			BEQ XSpyCopter0EEventLoop
			
XSpyCopter0EVRAMUpdate:
			JSL !VRAMRoutineAlt
			
XSpyCopter0EEventLoop:
			JML !EventLoop
			
XSpyCopter0EIncrease:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 10
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 10
			
			REP #$20
			LDA !PCNPC_TempStorage_33
			STA !CurrentPCAction_09DA
			SEP #$20
			
			LDA #$80 ;Load idle
			STA $09EF ;Current PC Frame
			
			LDA !PCNPC_AnimationFrameDoneTalk_43 ;Load frame to load after talking
			JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #10: Initiate data to draw dialogue box
	;***************************
XSpyCopter10:
			DEC !PCNPC_DelayTimer_3C ;Decrease delay timer from $7E:0D04
			BEQ XSpyCopter10Increase
			JSL !VRAMRoutineAlt
			JML !EventLoop
			
XSpyCopter10Increase:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 12
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 12
			LDA #$11 ;Load teleport out SFX
			JSL !PlaySFX
			LDA #$7F ;Load X begin teleporting out animation
			JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #12: Common event for NPC begin teleport out
	;***************************	
XSpyCopter12:
			LDA !PCNPC_IsAnimating_0F ;Load flag to check if NPC needs to update their VRAM data
			BMI XSpyCopter12Increase
			JML !AnimationConsistent
			
XSpyCopter12Increase:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 14
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 14
			REP #$20
			LDA #$0AA6 ;Load velocity of X
			STA !PCNPC_Velocity_1C
			SEP #$20
			LDA #$10 ;Load teleport out SFX #2
			JSL !PlaySFX
			LDA #$7D ;Load X teleport out animation
			JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #14: X teleporting out
	;***************************	
XSpyCopter14:
			JSL !MoveObjectUp
			LDA !PCNPC_Animate_0E ;Load whether NPC is animating or not
			BEQ XSpyCopter14Increase
			JML !EventLoop
			
XSpyCopter14Increase:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 16
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 16
			RTL
			
	;***************************
	; Sub-event #16: End Introduction event
	;***************************	
XSpyCopter16:
			STZ !PCNPC_Active_00 ;Store 00 to NPC RAM at $7E:0CC8 so NPC is removed from screen
			JSL !PalettePCBuster
			JSL PCIconRoutine
			LDA #$FF
			STA !CurrentHealth_09FF
			RTL

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #02: X Gets Captured 
;***************************
XEvent02XGetsCapturedBase:
	LDX !PCNPC_EventID_02
	JMP (XEvent02XGetsCapturedEvents,x)

XEvent02XGetsCapturedEvents:
	dw XEvent02XGetsCaptured00
	dw XEvent02XGetsCaptured02
	dw XEvent02XGetsCaptured04
	dw XEvent02XGetsCaptured06
	dw XEvent02XGetsCaptured08
	dw XEvent02XGetsCaptured0A
	dw XEvent02XGetsCaptured0C
	dw XEvent02XGetsCaptured0E
	dw XEvent02XGetsCaptured10
	dw XEvent02XGetsCaptured12
	dw XEvent02XGetsCaptured14
	dw XEvent02XGetsCaptured12
	dw XEvent02XGetsCaptured18
	dw XEvent02XGetsCaptured1A
	dw XEvent02XGetsCaptured1C
	dw XEvent02XGetsCaptured12
	dw XEvent02XGetsCaptured20
	dw $FF
	
	;***************************
	; Sub-event #00: Set X NPC sprites up
	;***************************
XEvent02XGetsCaptured00:
		INC !PCNPC_EventID_02 ;Increase X Introduction Event to 02
		INC !PCNPC_EventID_02 ;Increase X Introduction Event to 02
		
		LDA #$04
		STA !PCNPC_SpritePriority_12
		LDA #$26
		STA !PCNPC_PaletteDirection_11
		LDA #$40 ;Manually set PC NPC direction
		TSB !PCNPC_PaletteDirection_11
		JSL ZeroSetup
		LDA #$30
		STA !PCNPC_VRAMSlot_18
		
		INC !DisableLRSubWeaponScroll_1F45
		INC !DisableMenuOpening_1F4F
		INC !PCGodMode_1F1D		;Might not be needed
		STZ !CurrentPCSubWeapon_0A0B
		STZ !PCVisibility_09E6
		STZ !PCVisibility2_0A43	;Might not be needed
		INC !PCNPC_UNKNOWN_30 ;Might not be needed
		LDA !PCPaletteDirection_09E9
		STA !PCNPC_PaletteDirection_11
		REP #$20
		LDA !PCXCoordinate_09DD
		STA !PCNPC_XCoordinate_05
		LDA !PCYCoordinate_09E0
		STA !PCNPC_YCoordinate_08
		LDA !CurrentPCHitbox_09F8
		STA !PCNPC_Hitbox_20
		SEP #$20
		LDA #$03
		STA !PCNPC_AnimationFrameDoneTalk_43
		LDA #$50
		CLC
		ADC $0A4B
		JSL !AnimationOneFrame
		
	;***************************
	; Sub-event #02: Sets X breathing and collapsing. Clears out all charges.
	;***************************
XEvent02XGetsCaptured02:
		REP #$10
		LDX !PCNPC_TempStorage_0C
		JSL !MissileHitObject
		BCC XEvent02JumptoAnimation02
		
		LDA #$0D
		JSL !PlaySFX
		
		LDA #$04
		STA $0001,x
		JSL !ClearPCCharge
		STZ $0A2F ;Clears current charge time
		JSL !LoadPCWeaponPalette
		
		INC !DisablePCCharging_0A54
		LDX !PCNPC_TempStorage_0C
		LDA #$04 ;Animation to play for missile
		STA $0001,x
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$78 ;Set timer until dialogue box appears
		STA !PCNPC_DelayTimer_3C
		JSL ZeroZSaberSetup
		
		LDA #$1C ;Load animation for NPC X to use
		JSL !AnimationOneFrame
		INC $3D	;Enables object above PC
		INC $3E ;Enables object above PC
		JSL !CheckSpecialFXSlot
		
		BNE XEvent02JumptoAnimation02
		INC $0000,x ;Loads code for missile objects
		LDA #$10
		STA $000A,x
		LDA #$1E
		STA $0002,x
		LDA #$01
		STA $0003,x
		LDA #$1C
		STA $000B,x
		LDY !PCNPC_JumpHeight_1E ;Used as a temp. storage for where to get RAM on missile
		LDA $0011,y
		CLC
		ADC #$02
		STA $0011,x
		REP #$20
		LDA !PCNPC_XCoordinate_05
		STA $0005,x
		LDA !PCNPC_YCoordinate_08
		CLC
		ADC #$000A
		STA $0008,x
		LDA #$0D05
		STA $000C,x
		TXA
		STA $3F
XEvent02JumptoAnimation02:
		JML !AnimationConsistent
		
	;***************************
	; Sub-event #04: Countdown timer to load next dialogue box/flickering
	;***************************
XEvent02XGetsCaptured04:
		JSL MissileFlickering ;Sets flickering for object covering X
		DEC !PCNPC_DelayTimer_3C
		BNE XEvent02JumptoAnimation04
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02

		LDA #$31 ;Load dialogue to use
		JSL !DialogueBoxNormal
		
XEvent02JumptoAnimation04:
		JML !AnimationConsistent
		
	;***************************
	; Sub-event #06: Sets event lock then loads object to pick NPC X up
	;***************************
XEvent02XGetsCaptured06:
		JSL MissileFlickering
		LDA !EnableEventLock_1F3F
		BMI XEvent02JumptoAnimation06
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		JSL !CheckSpecialFXSlot
		BNE XEvent02JumptoAnimation06
		
		INC $0000,x
		LDA #$10
		STA $000A,x
		LDA #$1E
		STA $0002,x
		STA $0003,x
		LDA #$1A
		STA $000B,x
		LDA #$21
		STA $0011,x
		REP #$20
		LDA !ScreenXCoordinate_1E5D
		CLC
		ADC #$0100
		STA $0005,x
		LDA !ScreenYCoordinate_1E60
		CLC
		ADC #$004A
		STA $0008,x
		LDA #$FC00
		STA $001A,x
		LDA #$FF00
		STA $001C,x
		LDA #$0D06
		STA $000C,x
		TXA
		STA $41 ;Temp. Storage on PC NPC
		
XEvent02JumptoAnimation06:
		SEP #$30
		JML !AnimationConsistent
		
	;***************************
	; Sub-event #08: Object checking for coordinates and picking up NPC X
	;***************************
XEvent02XGetsCaptured08:
		JSL MissileFlickering
		REP #$20
		PHD
		LDA $41 ;Temp. Storage on PC NPC
		TCD
		JSL !CheckForLanding
		
		LDA $0CCD ;PC NPC X coordinates. This is HARD SET due to the missile using the main RAM
		CMP !PCNPC_XCoordinate_05 ;Check object X coordinates using OBJECT RAM at $7E:185D
		BMI XEvent02IgnoreSTZ08
		STZ !PCNPC_SpeedDistance_1A ;Store 00 to OBJECT RAM at $7E:1872
XEvent02IgnoreSTZ08:
		LDA !PCNPC_YCoordinate_08 ;Load OBJECT RAM Y coordinates
		CMP #$068F
		BPL XEvent02IgnoreContinue08
		PLD
		JML !AnimationConsistent
		
XEvent02IgnoreContinue08:
		LDA #$068F
		STA !PCNPC_YCoordinate_08 ;Store to OBJECT RAM X coordinates
		PLD
		SEP #$20
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$3C
		STA !PCNPC_DelayTimer_3C
		JML !AnimationConsistent

	;***************************
	; Sub-event #0A: Sets life to invisible and X gets picked up
	;	;Altered so life bar doesn't get set to invisible
	;***************************
XEvent02XGetsCaptured0A:
		JSL MissileFlickering
		DEC !PCNPC_DelayTimer_3C
		BNE XEvent02JumptoAnimation0A
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		REP #$10
		LDX $41
		LDA #$80
		STA $000B,x
		REP #$20
		LDA #$0078
		STA !PCNPC_DelayTimer_3C
		LDA #$0300
		STA !PCNPC_SpeedDistance_1A ;OBJECT that drags X off screen
		LDA #$0200
		STA !PCNPC_Velocity_1C ;OBJECT that drags X off screen
XEvent02JumptoAnimation0A:
		JML !AnimationConsistent
		
	;***************************
	; Sub-event #0C: X gets picked up and dragged off screen
	;***************************
XEvent02XGetsCaptured0C:
		JSL MissileFlickering
	
		DEC !PCNPC_DelayTimer_3C
		BEQ XEvent02JumptoAnimation0C
		JML !AnimationConsistent
		
XEvent02JumptoAnimation0C:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		JSL ZeroSetup
		LDA #$7B
		JML !VRAMRoutineConsistent
	
	;***************************
	; Sub-event #0E: Moves object that has X up (Merges with next event)
	;***************************
XEvent02XGetsCaptured0E:
		JSL MissileFlickering
		
		REP #$30
		LDA !PCNPC_YCoordinate_08
		CMP #$0680
		BPL XEvent02MoveObjectUp0E
		
		SEP #$20
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
XEvent02MoveObjectUp0E:
		JSL !MoveObjectUp
		BRA XEvent02SkipMoveObjectRight0E

	;***************************
	; Sub-event #10: Moves object that has X to the right and off screen
	;***************************
XEvent02XGetsCaptured10:	
		JSL !MoveObjectRight
XEvent02SkipMoveObjectRight0E:
		REP #$30
		LDX $3F ;PC NPC temporary storage
		LDY !PCNPC_TempStorage_41
		LDA !PCNPC_XCoordinate_05
		STA $0005,x
		STA $0005,y
		LDA !PCNPC_YCoordinate_08
		STA $0008,x
		CLC
		ADC #$FFE0
		STA $0008,y
		JSL !AnimationConsistent
		
		REP #$10
		LDA !PCNPC_Animate_0E
		BNE XEvent02SkipMacIncrease10
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		STZ $3E ;PC NPC temp storage
		LDA #$B4
		STA !PCNPC_DelayTimer_3C
		LDX !PCNPC_JumpHeight_1E ;Used as temp. storage for Mac's RAM
		INC $0002,x ;Increase Mac's event
		INC $0002,x ;Increase Mac's event
XEvent02SkipMacIncrease10:
		RTL
		
	;***************************
	; Sub-event #12: Common Event used for strictly count downs to get to the next event
	;***************************
XEvent02XGetsCaptured12:	
		DEC !PCNPC_DelayTimer_3C
		BNE XEvent02IgnoreCounter12
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
XEvent02IgnoreCounter12:
		RTL
	
	;***************************
	; Sub-event #14: Ceiling shake/Fall
	;***************************
XEvent02XGetsCaptured14:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$C0
		STA !PCNPC_DelayTimer_3C
		JSL !CheckEnemyRoom
		BNE XEvent02NoOpenEnemy14
		;Sets data up for falling ceiling tile
		INC $0000,x
		LDA #$20
		STA $000A,x
		LDA #$01
		STA $000B,x
		REP #$20
		LDA #$1170
		STA $0005,x
		LDA #$0606
		STA $0008,x
XEvent02NoOpenEnemy14:
		RTL
		
	;***************************
	; Sub-event #16: Event used for strictly count downs to get to the next event (Same as #12)
	;***************************
		;JMP XEvent02XGetsCaptured12
	
	
	;***************************
	; Sub-event #18: Load X falling from ceiling & sets health
	;***************************
XEvent02XGetsCaptured18:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDY #$5A ;Loads music fade and PC icon
		JSL !LoadSubWeaponIcon
		
		SEP #$30
		LDA #$3C
		STA !PCNPC_DelayTimer_3C
		STZ !PCGodMode_1F1D ;Might not be needed
		INC !PCVisibility_09E6
		
		LDA #$00
		STA !CurrentPC_0A8E
		STA !CurrentPCCheck_1FFF
		JSL HeartTank
		LDA #$FF
		STA !CurrentHealth_09FF
		LDA #$01
		STA !JumpDashFlag_7EF4E7
		JSL SetJumpValues
		
		JSL PCGeneralPalettes

		REP #$20
		LDA #$1170
		STA !PCXCoordinate_09DD
		LDA #$05E0
		STA !PCYCoordinate_09E0
		LDA #$04B4
		STA !CurrentPCHitbox_09F8
		
		SEP #$20
		LDA #$04
		TRB $0A03
		
		JSL !PalettePCBuster ;Sets PC's weapon palette
		
		LDA #$21
		JSL !PlayMusic
		
		JSL $84D1CA ;Prevents X from being damaged when falling
		
		STZ !PCHealthBar_1F22
		STZ !PCSubWeaponAmmoBar_1F23
		STZ !DisablePCCharging_0A54
		DEC !DisableMenuOpening_1F4F
		RTL
		
	;***************************
	; Sub-event #1A: ???
	;***************************
XEvent02XGetsCaptured1A:
		LDA $1F18
		STA !PCNPC_AnimationFrameDoneTalk_43 ;Temp. storage
		LDA #$0F
		STA $1F18
		JSL $80B1DC
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		RTL
		
	;***************************
	; Sub-event #1C: X falling
	;***************************
XEvent02XGetsCaptured1C:
		LDA $0040
		BNE XEvent02IgnoreSubEvent1C
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$01
		STA $1F19
		JSL $80B5A5
XEvent02IgnoreSubEvent1C:
		RTL


	;***************************
	; Sub-event #1E: Event used for strictly count downs to get to the next event (Same as #12)
	;***************************
	
	
	
	;***************************
	; Sub-event #20: X lands
	;***************************
XEvent02XGetsCaptured20:
		LDA $0A03 ;Load PC NPC to check if on ground or air
		BIT #$04
		BEQ XEvent02PCNPC_isNotOnGround20
		
		DEC !DisableLRSubWeaponScroll_1F45
		DEC !DisableMenuOpening_1F4F
		LDA !PCNPC_AnimationFrameDoneTalk_43 ;Load temp. storage
		STA $1F18
		STZ $1F19
		JSL $84D1EF
		STZ $00 ;Disables PC NPC event
XEvent02PCNPC_isNotOnGround20:
		RTL
		
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #04: Rescue X from Mac
;***************************
XEvent04RescueXBase:
	LDX !PCNPC_EventID_02
	JMP (XEvent04RescueXEvents,x)

XEvent04RescueXEvents:
	dw XEvent04RescueX00
	dw XEvent04RescueX02
	dw XEvent04RescueX04
	dw XEvent04RescueX06
	dw XEvent04RescueX08
	dw XEvent04RescueX0A
	dw XEvent04RescueX0C
	dw XEvent04RescueX0E
	dw XEvent04RescueX10
	dw $FF
	
	;***************************
	; Sub-event #00: Set X hanging from object
	;***************************
XEvent04RescueX00:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA !PCPaletteDirection_09E9
		AND #$30
		ORA #$01
		ORA !PCNPC_PaletteDirection_11
		STA !PCNPC_PaletteDirection_11
		JSL XSetup
		LDA #$20
		STA !PCNPC_VRAMSlot_18
		LDA #$04 
		STA !PCNPC_SpritePriority_12
		
		REP #$20
		STZ !PCNPC_SpeedDistance_1A
		STZ !PCNPC_Velocity_1C
		LDA #$0040
		STA !PCNPC_JumpHeight_1E
		LDA #$B404
		STA !PCNPC_Hitbox_20
		SEP #$20
		LDA #$7B ;Load frame of X being held
		JSL !AnimationOneFrame
		JSL !VRAMRoutineAllowMissiles
		JML !EventLoop
		
	;***************************
	; Sub-event #02: Repeat animation
	;***************************
XEvent04RescueX02:
		LDA !PCNPC_Animate_0E
		BMI XEvent04RescueX02SkipAnimate
		JSL !VRAMRoutineAlt
		JSL !VRAMRoutineAllowMissiles
XEvent04RescueX02SkipAnimate:
		LDA $157A
		CMP #$10
		BNE XEvent04RescueX02IncreaseEvent
		LDA $0D58 ;Check object holding X to see if active
		BNE XEvent04RescueX02IncreaseEvent
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		INC !DisableLRSubWeaponScroll_1F45
		INC !DisableMenuOpening_1F4F
		LDA #$04
		STA !PCHealthBar_1F22
		STA !PCSubWeaponAmmoBar_1F23
XEvent04RescueX02IncreaseEvent:	
		JML !EventLoop
		
	;***************************
	; Sub-event #04: Initiate X falling
	;***************************
XEvent04RescueX04:
		REP #$20
		LDA !ScreenXCoordinate_1E5D
		CLC
		ADC #$0050
		JSL $84D24B ;Sets PC NPC coordinates to walk
		
		SEP #$20
		JSL $848E81 ;???
		JSL $84B6D0 ;???
		
		INC !DisablePCCharging_0A54 ;??? [Doesn't seem like it's needed]
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$57
		JSL !AnimationOneFrame
		JSL !VRAMRoutineAllowMissiles
		JML !EventLoop
	
	;***************************
	; Sub-event #06: X falling/check for landing
	;***************************
XEvent04RescueX06:
		JSL !CheckForGround
		JSL FallingVelocity
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BNE XEvent04RescueX06OnGround
		JML !EventLoop
		
XEvent04RescueX06OnGround:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$50
		JSL !AnimationOneFrame
		JSL !VRAMRoutineAllowMissiles
		JML !EventLoop

	;***************************
	; Sub-event #08: X landed
	;***************************
XEvent04RescueX08:
		LDA !CurrentPCSubAction_09DB
		CMP #$08
		BNE XEvent04RescueX08IgnoreEventIncrease
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
XEvent04RescueX08IgnoreEventIncrease:		
		JML !EventLoop
		
	;***************************
	; Sub-event #0A: Sets PC back to X and loads dialogue
	;***************************
XEvent04RescueX0A:
		REP #$30
		LDA !PCXCoordinate_09DD
		LDX !PCNPC_XCoordinate_05
		STA !PCNPC_XCoordinate_05
		STX !PCXCoordinate_09DD
		LDA !PCYCoordinate_09E0
		LDX !PCNPC_YCoordinate_08
		STA !PCNPC_YCoordinate_08
		STX !PCYCoordinate_09E0
		
		SEP #$20
		PHD
		PEA $09D8
		PLD
		STZ !CurrentPC_0A8E
		STZ !CurrentPCCheck_1FFF
		
		REP #$20
		LDA #$B40E
		STA !CurrentPCHitbox_09F8
		SEP #$20
		LDA #$40
		TRB !PCNPC_PaletteDirection_11 ;PC's Palette/Direction
		TRB $69
		JSL XSetup
		STZ $09F0 ;Sets PC VRAM slot to 00
		
		LDA #$50
		JSL !AnimationOneFrame
		JSL NewVRAMRoutine
		
		REP #$30
		PLD
		JSL ZeroSetup
		
		LDA #$87
		JSL !AnimationOneFrame
		JSL !VRAMRoutineAllowMissiles
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$3B
		JSL !DialogueBoxNormal
		
		LDA #$7F
		STA !PCNPC_AnimationFrameDoneTalk_43
		JML !EventLoop
		
	;***************************
	; Sub-event #0C ;NPC talking
	;***************************
XEvent04RescueX0C:
		LDA !EnableEventLock_1F3F
		BPL XEvent04RescueX0CIncreaseEvent
		LDA $1F51
		BNE XEvent04RescueX0CNPCAnimating
		
		LDA $1F50
		CMP #$01
		BEQ XEvent04RescueX0CAnimate
		
XEvent04RescueX0CNPCAnimating:
		LDA !PCNPC_IsAnimating_0F
		BEQ XEvent04RescueX0CEventLoop
		
XEvent04RescueX0CAnimate:
		JSL !VRAMRoutineAlt

XEvent04RescueX0CEventLoop:
		JML !EventLoop
		
XEvent04RescueX0CIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA !PCNPC_AnimationFrameDoneTalk_43
		JSL !AnimationOneFrame
		JSL !VRAMRoutineAllowMissiles
		JML !EventLoop

	;***************************
	; Sub-event #0E ;X begin teleport out
	;***************************
XEvent04RescueX0E:
		LDA !PCNPC_IsAnimating_0F
		BMI XEvent04RescueX0EIncreaseEvent
		
		JSL !VRAMRoutineAlt
		JSL !VRAMRoutineAllowMissiles
		JML !EventLoop
		
XEvent04RescueX0EIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		REP #$20
		LDA #$0AA6
		STA !PCNPC_Velocity_1C
		SEP #$20
		LDA #$10
		JSL !PlaySFX
		
		LDA #$7D
		JSL !AnimationOneFrame
		JSL !VRAMRoutineAllowMissiles
		JML !EventLoop

	;***************************
	; Sub-event #10 ;X teleport out and end routine
	;***************************
XEvent04RescueX10:
		JSL !MoveObjectUp
		
		LDA !PCNPC_Animate_0E
		BEQ XEvent04RescueX10NoAnimate
		JML !EventLoop
		
XEvent04RescueX10NoAnimate:
		LDA #$FF
		STA !CurrentHealth_09FF
		JSL HeartTank
		STZ !CurrentPCSubWeapon_0A0B
		STZ !PCHealthBar_1F22
		STZ !PCSubWeaponAmmoBar_1F23
		LDY #$5C
		JSL !LoadSubWeaponIcon
		
		STZ !DisablePCCharging_0A54 ;??? [Doesn't seem like it's needed]
		JSL PCBusterPalette
		SEP #$30
		
		STZ !PCNPC_Active_00
		LDA #$12
		JML !PlayMusic

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #06: X teleport in after Maoh the Giant
;***************************
XEvent06XMaohGiantBase:
	LDX !PCNPC_EventID_02
	JMP (XEvent06XMaohGiantEvents,x)

XEvent06XMaohGiantEvents:
	dw XEvent06XMaohGiant00
	dw XEvent06XMaohGiant02
	dw XEvent06XMaohGiant04
	dw XEvent06XMaohGiant06
	dw XEvent06XMaohGiant08
	dw XEvent06XMaohGiant0A
	dw XEvent06XMaohGiant0C
	dw XEvent06XMaohGiant0E
	dw $FF
	
	;***************************
	; Sub-event #00: Set X's sprites & teleport in speed
	;***************************
XEvent06XMaohGiant00:
		LDA #$2C
		STA !PCNPC_PaletteDirection_11
		JSL XSetup ;Load X's sprite settings
		
		LDA #$04
		STA !PCNPC_SpritePriority_12

		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$04
		STA !PCHealthBar_1F22
		STA !PCSubWeaponAmmoBar_1F23
		LDA #$07
		STA !PCNPC_DelayTimer_3C
		REP #$20
		LDA #$0040
		TRB $11
		LDA !PCXCoordinate_09DD
		SEC
		SBC !ScreenXCoordinate_1E5D
		CMP #$0080
		BMI XEvent06XMaohGiant00ChangeDirection
		LDA #$0040
		TSB !PCNPC_PaletteDirection_11
		LDA #$FFD0
		BRA XEvent06XMaohGiant00SkipChangeDirection
		
XEvent06XMaohGiant00ChangeDirection:
		LDA #$0030
XEvent06XMaohGiant00SkipChangeDirection:
		CLC
		ADC !PCXCoordinate_09DD
		STA !PCNPC_XCoordinate_05
		LDA !ScreenYCoordinate_1E60
		CLC
		ADC #$FFE0
		STA !PCNPC_YCoordinate_08
		BRA XEvent06XMaohGiant00SkipLoadPCNPC_
UniversalTeleportInSettings:
		SEP #$30
		LDA #$26
		STA !PCNPC_PaletteDirection_11
UniversalTeleportInSettingsSkipPalette:
		JSL XSetup
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
XEvent06XMaohGiant00SkipLoadPCNPC_:
		REP #$20
		STZ !PCNPC_SpeedDistance_1A
		LDA #$F55A
		STA !PCNPC_Velocity_1C
		SEP #$20
		LDA #$10
		JSL !PlaySFX
		
		LDA #$7D
		JML !VRAMRoutineConsistent

	;***************************
	; Sub-event #02: X teleport in check for landing
	;***************************
XEvent06XMaohGiant02:
		JSL !CheckForLanding
		
		LDA !PCNPC_DelayTimer_3C
		BEQ XEvent06XMaohGiant02ContinueEvent
		DEC !PCNPC_DelayTimer_3C
		BRA XEvent06XMaohGiant02EndRoutine
		
XEvent06XMaohGiant02ContinueEvent:
		JSL $84C0F7 ;Blanks out various object data?
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BEQ XEvent06XMaohGiant02EndRoutine
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$7E
		JML !VRAMRoutineConsistent
		
XEvent06XMaohGiant02EndRoutine:
		JML !AnimationConsistent

	;***************************
	; Sub-event #04: X landing
	;***************************
XEvent06XMaohGiant04:
		LDA !PCNPC_IsAnimating_0F
		BMI XEvent06XMaohGiant04IncreaseEvent
		JML !AnimationConsistent
		
XEvent06XMaohGiant04IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$40
		TRB !PCDirection_0A41
		AND $11
		EOR #$40
		TSB !PCDirection_0A41
		
		LDA #$50
		STA !PCNPC_AnimationFrameDoneTalk_43
		LDA #$3C
		STA !PCNPC_DelayTimer_3C
		LDA #$3C
		JSL !DialogueBoxSmall
		
		LDA #$87
		JML !VRAMRoutineConsistent
		
	;***************************
	; Sub-event #06: Initate common event for dialogue and animation updating
	; [Different location than the other pieces]
	;***************************
XEvent06XMaohGiant06:
		LDA !EnableEventLock_1F3F
		BPL XEvent06XMaohGiant06IncreaseEvent
		LDA $1F51
		BNE XEvent06XMaohGiant06NPCAnimating
		
		LDA $1F50
		CMP #$01
		BEQ XEvent06XMaohGiant06Animate
		
XEvent06XMaohGiant06NPCAnimating:
		LDA !PCNPC_IsAnimating_0F
		BEQ XEvent06XMaohGiant06EventLoop
		
XEvent06XMaohGiant06Animate:
		JSL !VRAMRoutineAlt

XEvent06XMaohGiant06EventLoop:
		JML !EventLoop
		
XEvent06XMaohGiant06IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA !PCNPC_AnimationFrameDoneTalk_43
		JML !VRAMRoutineConsistent


	;***************************
	; Sub-event #08: Dialogue finished
	;***************************
XEvent06XMaohGiant08:
		DEC !PCNPC_DelayTimer_3C
		BEQ XEvent06XMaohGiant08IncreaseEvent
		JSL !VRAMRoutineAlt
		JML !EventLoop
		
XEvent06XMaohGiant08IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$11
		JSL !PlaySFX
		
		LDA #$7F
		JML !VRAMRoutineConsistent


	;***************************
	; Sub-event #0A: Common event for NPC begin teleport out
	;***************************
XEvent06XMaohGiant0A:
		LDA !PCNPC_IsAnimating_0F
		BMI XEvent06XMaohGiant0AIncreaseEvent
		JML !AnimationConsistent
		
XEvent06XMaohGiant0AIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		REP #$20
		LDA #$0AA6
		STA !PCNPC_Velocity_1C
		SEP #$20
		LDA #$10
		JSL !PlaySFX
		LDA #$7D
		JML !VRAMRoutineConsistent
		
	;***************************
	; Sub-event #0C: Common event for NPC teleport out
	;***************************
XEvent06XMaohGiant0C:
		JSL !MoveObjectUp
		
		LDA !PCNPC_Animate_0E
		BEQ XEvent06XMaohGiant0CIncreaseEvent
		JML !EventLoop
		
XEvent06XMaohGiant0CIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		RTL

	;***************************
	; Sub-event #0E: End event
	;***************************
XEvent06XMaohGiant0E:
		STZ $00
		INC $1F36 ;Initiate X teleport out
		RTL

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #08: X power cell damaged [THIS WHOLE EVENT IS UNUSED! Must NOP out the entire old event of it]
;***************************
XEvent08XPowerCellDamagedBase:
	LDX !PCNPC_EventID_02
	JMP (XEvent08XPowerCellDamagedEvents,x)

XEvent08XPowerCellDamagedEvents:
	dw XEvent08XPowerCellDamaged00
	dw $FF
	
	;***************************
	; Sub-event #0E: End event
	;***************************
XEvent08XPowerCellDamaged00:
	RTL
	
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #0A: Dr. Cain pinpoints Dr. Doppler's lab
;***************************
XEvent0ADrCainFindLabBase:
	LDX !PCNPC_EventID_02
	JMP (XEvent0ADrCainFindLabEvents,x)

XEvent0ADrCainFindLabEvents:
	dw XEvent0ADrCainFindLab00
	dw XEvent0ADrCainFindLab02
	dw XEvent0ADrCainFindLab04
	dw XEvent0ADrCainFindLab06
	dw XEvent06XMaohGiant06
	dw XEvent0ADrCainFindLab06
	dw XEvent06XMaohGiant06
	dw XEvent0ADrCainFindLab06
	dw XEvent06XMaohGiant06
	dw XEvent0ADrCainFindLab06
	dw XEvent06XMaohGiant06
	dw XEvent0ADrCainFindLab16
	dw XEvent06XMaohGiant0A
	dw XEvent06XMaohGiant0C
	dw XEvent0ADrCainFindLab1C
	dw $FF
	
	;***************************
	; Sub-event #00: Set X sprites and begin teleport settings
	;***************************
XEvent0ADrCainFindLab00:
		LDA !ZSaberObtained_1FB2
		BIT #$40
		BEQ XEvent0ADrCainFindLab00SkipZSaber
		LDA #$1C
		STA !PCNPC_EventID_02
		JML !EventLoop
		
XEvent0ADrCainFindLab00SkipZSaber:
		LDA !CurrentPCAction_09DA
		CMP #$22
		BEQ XEvent0ADrCainFindLab00SkipRTL
		RTL
XEvent0ADrCainFindLab00SkipRTL:
		REP #$20
		LDA !PCXCoordinate_09DD
		CLC
		ADC #$FFE0
		STA !PCNPC_XCoordinate_05
		LDA !PCYCoordinate_09E0
		STA !PCNPC_YCoordinate_08
		JMP UniversalTeleportInSettings

	;***************************
	; Sub-event #02: X begin teleport in
	;***************************
XEvent0ADrCainFindLab02:
		JSL !CheckForLanding
		
		REP #$20
		LDA !ScreenYCoordinate_1E60
		CLC
		ADC #$0080
		CMP !PCNPC_YCoordinate_08
		BPL XEvent0ADrCainFindLab02Animate
		
		SEP #$20
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BEQ XEvent0ADrCainFindLab02Animate
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02

		LDA #$04
		STA !PCNPC_SpritePriority_12		
	
		LDA #$7E
		JML !VRAMRoutineConsistent
XEvent0ADrCainFindLab02Animate:
		JML !AnimationConsistent

	;***************************
	; Sub-event #04 ;Set PC frame for landing and for dialogue
	;***************************
XEvent0ADrCainFindLab04:
		LDA #$40
		TSB !PCNPC_PaletteDirection_11
		LDA !PCNPC_IsAnimating_0F
		BMI XEvent0ADrCainFindLab04IncreaseEvent
		JML !AnimationConsistent
		
XEvent0ADrCainFindLab04IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$50 ;Load PC NPC frame for when done talking
		STA !PCNPC_AnimationFrameDoneTalk_43
		LDA #$3C
		STA !PCNPC_DelayTimer_3C
		LDA #$50 ;Load PC NPC frame for idle
		JML !VRAMRoutineConsistent

	;***************************
	; Sub-event #06: Set common event for event lock and X NPC speaking
	;***************************
XEvent0ADrCainFindLab06:
		LDA !EnableEventLock_1F3F
		BMI XEvent0ADrCainFindLab06IncreaseEvent
		JML !AnimationConsistent
		
XEvent0ADrCainFindLab06IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$87 ;Set frame start for talking
		JML !VRAMRoutineConsistent



	;***************************
	; Sub-event #08: Initate common event for dialogue and animation updating
	; [Different location than the other pieces]
	;***************************
;XEvent0ADrCainFindLab08:
		;JMP XEvent06XMaohGiant06
		
		
	;***************************
	; Sub-event #0A: Set common event for event lock and X NPC speaking
	;***************************
;XEvent0ADrCainFindLab0A:
		;JMP XEvent0ADrCainFindLab06
		
	;***************************
	; Sub-event #0C: Initate common event for dialogue and animation updating
	; [Different location than the other pieces]
	;***************************
;XEvent0ADrCainFindLab0c:
		;JMP XEvent06XMaohGiant06
		
	;***************************
	; Sub-event #0E: Set common event for event lock and X NPC speaking
	;***************************
;XEvent0ADrCainFindLab0e:
		;JMP XEvent0ADrCainFindLab06
		
	;***************************
	; Sub-event #10: Initate common event for dialogue and animation updating
	; [Different location than the other pieces]
	;***************************
;XEvent0ADrCainFindLab10:
		;JMP XEvent06XMaohGiant06
		
	;***************************
	; Sub-event #12: Set common event for event lock and X NPC speaking
	;***************************
;XEvent0ADrCainFindLab12:
		;JMP XEvent0ADrCainFindLab06
		
	;***************************
	; Sub-event #14: Initate common event for dialogue and animation updating
	; [Different location than the other pieces]
	;***************************
;XEvent0ADrCainFindLab14:
		;JMP XEvent06XMaohGiant06
	
	;***************************
	; Sub-event 16: Set X to begin teleport
	;***************************
XEvent0ADrCainFindLab16:
		LDA !CurrentPCAction_09DA
		CMP #$34
		BEQ XEvent0ADrCainFindLab16IncreaseEvent
		JSL !VRAMRoutineAlt
		JML !EventLoop
		
XEvent0ADrCainFindLab16IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$11
		JSL !PlaySFX
		
		LDA #$7F
		JML !VRAMRoutineConsistent

		
	;***************************
	; Sub-event #18: Common event for NPC begin teleport out
	; 
	;***************************
;XEvent0ADrCainFindLab18:
		;JMP XEvent06XMaohGiant0A

	
	;***************************
	; Sub-event #1A: Common event for NPC teleport out
	; 
	;***************************
;XEvent0ADrCainFindLab1A:
		;JMP XEvent06XMaohGiant0C
	
	
	;***************************
	; Sub-event 1C: End Event
	;***************************
XEvent0ADrCainFindLab1C:
		STZ !PCNPC_Active_00
		RTL
		
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #0C: REX-2000
;***************************
XEvent0CREX2000Base:
	LDX !PCNPC_EventID_02
	JMP (XEvent0CREX2000Events,x)

XEvent0CREX2000Events:
	dw XEvent0CREX2000_00
	dw XEvent0ADrCainFindLab02
	dw XEvent0CREX2000_04
	dw XEvent06XMaohGiant06
	dw XEvent0CREX2000_08
	dw XEvent0CREX2000_0A
	dw XEvent0CREX2000_0C
	dw XEvent0CREX2000_0E
	dw XEvent06XMaohGiant06
	dw XEvent0CREX2000_12
	dw XEvent06XMaohGiant0A
	dw XEvent06XMaohGiant0C
	dw XEvent0CREX2000_18
	dw $FF
	
	;***************************
	; Sub-event #00: Set X sprites then load teleport in common event
	;***************************
XEvent0CREX2000_00:
		INC !DisableEnemyAI_1F27
		INC !DisableLRSubWeaponScroll_1F45
		INC !DisableMenuOpening_1F4F
		LDA #$04
		STA !PCHealthBar_1F22
		STA !PCSubWeaponAmmoBar_1F23
		LDA #$04
		STA !PCNPC_SpritePriority_12
		
		REP #$20
		LDA !ScreenXCoordinate_1E5D
		CLC
		ADC #$00C0
		STA !PCNPC_XCoordinate_05
		LDA !ScreenYCoordinate_1E60
		STA !PCNPC_YCoordinate_08
		LDA #$0708
		STA !PCNPC_DelayTimer_3C
		
		SEP #$30
		LDA #$2C
		STA !PCNPC_PaletteDirection_11
		
		JMP UniversalTeleportInSettingsSkipPalette

	;***************************
	; Sub-event #02: Load common event for X teleport in
	;***************************
;XEvent0CREX2000_02:	
		;JMP XEvent0ADrCainFindLab02
		
		
	;***************************
	; Sub-event #04: Set dialogue
	;***************************
XEvent0CREX2000_04:
		LDA #$40
		TRB !PCNPC_PaletteDirection_11
		LDA !PCNPC_IsAnimating_0F
		BMI XEvent0CREX2000_04IncreaseEvent
		JML !AnimationConsistent
		
XEvent0CREX2000_04IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$48
		JSL !DialogueBoxNormal
		
		LDA #$50
		STA !PCNPC_AnimationFrameDoneTalk_43
		LDA #$3C
		STA !PCNPC_DelayTimer_3C
		LDA #$87
		JML !VRAMRoutineConsistent

		
	;***************************
	; Sub-event #06: Initate common event for dialogue and animation updating
	;***************************
;XEvent0CREX2000_06:
;		JMP XEvent06XMaohGiant06


	;***************************
	; Sub-event #08 ;Set X walking speed
	;***************************
XEvent0CREX2000_08:
		LDA #$40
		TSB !PCNPC_PaletteDirection_11
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		REP #$20
		LDA #$0178
		STA !PCNPC_SpeedDistance_1A
		SEP #$20
		LDA #$5C
		JSL !VRAMRoutineConsistent


	;***************************
	; Sub-event #0A: X Walking off screen
	;***************************
XEvent0CREX2000_0A:
		JSL !MoveObjectRight
		
		LDA !PCNPC_Animate_0E
		BEQ XEvent0CREX2000_0AIncreaseEvent
		JML !AnimationConsistent
		
XEvent0CREX2000_0AIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		STZ !PCHealthBar_1F22
		STZ !PCSubWeaponAmmoBar_1F23
		DEC !DisableMenuOpening_1F4F
		DEC !DisableLRSubWeaponScroll_1F45
		JSL $84D1EF ;Reenables X moving
		STZ !DisableEnemyAI_1F27
		
		LDA #$40
		TRB !PCNPC_PaletteDirection_11
		REP #$20
		LDA #$0BB8
		STA !PCNPC_XCoordinate_05
		JSL !ReloadSubWeapGreaphics ;Set X's palette by checking for sub-weapon. Also sets proper VRAM graphics for sub-weapon
		RTL


	;***************************
	; Sub-event #0C: Event to continue checking for ceiling to stop falling or enemy death
	;***************************
XEvent0CREX2000_0C:
		REP #$30
		LDA !PCNPC_DelayTimer_3C
		BEQ XEvent0CREX2000_0CCheckEnemy
		
		DEC !PCNPC_DelayTimer_3C
		BNE XEvent0CREX2000_0CCheckEnemy
		
		SEP #$20
		LDA #$02
		STA $1F5F ;Something to do with event bit flags
		
XEvent0CREX2000_0CCheckEnemy:
		SEP #$20
		LDX !PCNPC_TempStorage_0C
		LDA $0000,x
		BNE XEvent0CREX2000_0CEndRoutine
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$02
		STA $1F5F ;Something to do with event bit flags
		JSL $84D4BF ;Something to do with ceiling
		
		LDA #$50
		JSL !AnimationOneFrame
		JSL NewVRAMRoutine
		
		REP #$20
		LDA !PCNPC_XCoordinate_05
		CLC 
		ADC #$FFD0
		JSL $84D24B ;???
		
		INC !DisableLRSubWeaponScroll_1F45
		REP #$20
		JML !EventLoop

XEvent0CREX2000_0CEndRoutine:
		RTL

	;***************************
	; Sub-event #0E: Set X to walk
	;***************************
XEvent0CREX2000_0E:
		LDA !CurrentPCAction_09DA
		CMP #$66 ;Check if 'walking'
		BEQ XEvent0CREX2000_0ECheckPCAction
		
		REP #$20
		LDA !PCNPC_XCoordinate_05
		CLC
		ADC #$FFD0
		JSL $84D24B ;Something with PCNPC coordinates

XEvent0CREX2000_0ECheckPCAction:
		SEP #$20
		LDA #$04
		STA !PCHealthBar_1F22
		STA !PCSubWeaponAmmoBar_1F23
		INC !DisableMenuOpening_1F4F
		INC !DisableLRSubWeaponScroll_1F45
		
		LDA !CurrentPCSubAction_09DB
		CMP #$08
		BEQ XEvent0CREX2000_0EIncreaseEvent
		JML !AnimationConsistent
		
XEvent0CREX2000_0EIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$49
		JSL !DialogueBoxNormal
		
		LDA #$87
		JML !VRAMRoutineConsistent
		

	;***************************
	; Sub-event #10: Initate common event for dialogue and animation updating
	;[Different location than the other pieces]
	;***************************
;XEvent0CREX2000_10:
		;JMP XEvent06XMaohGiant06
		
		
	;***************************
	; Sub-event #12: Set X teleport out
	;***************************
XEvent0CREX2000_12:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
;		JSL XSetup ;Not needed
		
		LDA #$11
		JSL !PlaySFX
		
		LDA #$7F
		JML !VRAMRoutineConsistent

		
	;***************************
	; Sub-event #14: Common event for NPC begin teleport out
	;***************************
;XEvent0CREX2000_14:
;		JMP XEvent06XMaohGiant0A


	;***************************
	; Sub-event #16: Common event for NPC teleport out
	;***************************
;XEvent0CREX2000_16:
;		JMP XEvent06XMaohGiant0C


	;***************************
	; Sub-event #18: End event
	;***************************
XEvent0CREX2000_18:
		STZ !PCNPC_Active_00
		STZ !PCHealthBar_1F22
		STZ !PCSubWeaponAmmoBar_1F23
		STZ !DisableLRSubWeaponScroll_1F45
		JSL !ReloadSubWeapGreaphics ;Set X's palette by checking for sub-weapon. Also sets proper VRAM graphics for sub-weapon
		JSL $84D169 ;???
		JSL !PalettePCBuster
		STZ !PCNPC_Active_00
		STZ !PCHealthBar_1F22
		STZ !PCSubWeaponAmmoBar_1F23
		STZ !DisableLRSubWeaponScroll_1F45
		STZ !DisableMenuOpening_1F4F
		RTL
	
		
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #0E: Damaged by Mosquitus
;***************************
XEvent0EMosquitusBase:
	LDX !PCNPC_EventID_02
	JMP (XEvent0EMosquitusEvents,x)

XEvent0EMosquitusEvents:
	dw XEvent0EMosquitus00
	dw XEvent0EMosquitus02
	dw XEvent0EMosquitus04
	dw XEvent0EMosquitus06
	dw XEvent06XMaohGiant06
	dw XEvent0EMosquitus0A
	dw XEvent06XMaohGiant0A
	dw XEvent06XMaohGiant0C
	dw XEvent0EMosquitus10
	dw $FF
	
	;***************************
	; Sub-event #00: Set Zero NPC sprites and facing
	;***************************
XEvent0EMosquitus00:
		STZ !PCVisibility_09E6
		LDA #$04
		STA !PCNPC_SpritePriority_12
		REP #$20
		LDA !PCXCoordinate_09DD
		STA !PCNPC_XCoordinate_05
		LDA !PCYCoordinate_09E0
		STA !PCNPC_YCoordinate_08
		
		SEP #$20
		LDA #$78
		STA !PCNPC_DelayTimer_3C
		
		LDA #$2C
		STA !PCNPC_PaletteDirection_11
		JSL ZeroZSaberSetup
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$5B
		STA !PCNPC_TempStorage_0A
		JSL $84D3B3 ;Find free enemy storage? [Unsure]
		
		LDA $0000
		STA !PCNPC_JumpHeight_1E ;Used as Temp. Storage
		LDA $0001
		STA $1F ;Used as Temp. Storage
		LDA #$01
		STA !PCNPC_TempStorage_0A
		
		REP #$20
		LDA !ScreenXCoordinate_1E5D
		CLC
		ADC #$0080
		CMP !PCNPC_XCoordinate_05
		SEP #$20
		BMI XEvent0EMosquitus00SetDirection
		LDA #$40
		TSB !PCNPC_PaletteDirection_11
		BRA XEvent0EMosquitus00SkipDirection
		
XEvent0EMosquitus00SetDirection:
		LDA #$40
		TRB !PCNPC_PaletteDirection_11
		
XEvent0EMosquitus00SkipDirection:
		JSL !ClearPCCharge
		
		STZ $0A2F ;Clears current charge time
		STZ !CurrentPCSubWeapon_0A0B
		INC !DisablePCCharging_0A54
		
		LDA #$0D
		JSL !PlaySFX
		
		LDA #$1D
		JML !VRAMRoutineConsistent

	;***************************
	; Sub-event #02: Set Zero damaged kneel
	;***************************
XEvent0EMosquitus02:
		LDA !PCNPC_IsAnimating_0F
		BMI XEvent0EMosquitus02IncreaseEvent
		JML !AnimationConsistent
		
XEvent0EMosquitus02IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$1C
		JML !VRAMRoutineConsistent

	;***************************
	; Sub-event #04: Set X direction and set PC back to X
	;***************************
XEvent0EMosquitus04:
		REP #$10
		LDX !PCNPC_JumpHeight_1E ;Used as Temp. Storage
		LDA $0034,x
		BPL XEvent0EMosquitus04Animate
		
		SEP #$10
		DEC !PCNPC_DelayTimer_3C
		BEQ XEvent0EMosquitus04IncreaseEvent
XEvent0EMosquitus04Animate:
		JML !AnimationConsistent
		
XEvent0EMosquitus04IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		INC !DisableEnemyAI_1F27
		INC !DisableScreenScroll_1F2B
		
		PHD
		PEA $09D8 ;Set to use PC RAM
		PLD
		JSL $80E5CC ;???
		PLD
		
		REP #$30
		LDA !ScreenXCoordinate_1E5D
		CLC
		ADC #$0080
		CMP !PCNPC_XCoordinate_05
		BMI XEvent0EMosquitus04SetDirection
		LDA #$0030
		BRA XEvent0EMosquitus04SkipDirection
XEvent0EMosquitus04SetDirection:
		LDA #$FFD0
XEvent0EMosquitus04SkipDirection:
		TAX
		CLC
		ADC !PCNPC_XCoordinate_05
		STA !PCXCoordinate_09DD
		LDA !ScreenYCoordinate_1E60
		STA !PCYCoordinate_09E0
		SEP #$30
		XBA
		STA !PCNPC_TempStorage_33
		LDA #$04
		STA !PCHealthBar_1F22
		STA !PCSubWeaponAmmoBar_1F23
		STZ !CurrentPC_0A8E
		STZ !CurrentPCCheck_1FFF
		JSL !LoadPCWeaponPalette
		JSL !PalettePCBuster
		
		LDA #$80
		TRB $0A7D
		TSB $0A9B
		LDA #$A2
		STA $0A7B
		INC !PCVisibility_09E6
		LDA #$1C
		STA !PCNPC_AnimationFrameDoneTalk_43
		LDA #$1F
		JML !VRAMRoutineConsistent

	;***************************
	; Sub-event #06: Set X direction and load dialogue
	;***************************
XEvent0EMosquitus06:
		LDA !PCYCoordinate_09E0
		CMP #$60
		BMI XEvent0EMosquitus06EndRoutine
		STZ !DisableScreenScroll_1F2B
		
		LDA !CurrentPCAction_09DA
		BNE XEvent0EMosquitus06EndRoutine
		
		LDA #$40
		TRB !PCDirection_0A41
		LDA !PCNPC_PaletteDirection_11
		AND #$40
		EOR #$40
		TSB !PCDirection_0A41
		JSL $84D1CA ;???
		LDA #$4D
		JSL !DialogueBoxNormal
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02

XEvent0EMosquitus06EndRoutine:
		JML !EventLoop

	;***************************
	; Sub-event #08: Initate common event for dialogue and animation updating
	;***************************
;	XEvent0EMosquitus08:
;		JMP XEvent06XMaohGiant06


	;***************************
	; Sub-event #0A: Set X teleport out
	;***************************
	XEvent0EMosquitus0A:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		JSL XSetup
		
		LDA #$11
		JSL !PlaySFX
		
		LDA #$7F
		JML !VRAMRoutineConsistent

	;***************************
	; Sub-event #0C: Common event for NPC begin teleport out
	;***************************
;	XEvent0EMosquitus0C:
;		JMP XEvent06XMaohGiant0A
	

	;***************************
	; Sub-event #0E: Common event for NPC teleport out
	;***************************
;	XEvent0EMosquitus0E:
;		JMP XEvent06XMaohGiant0C


	;***************************
	; Sub-event #10: Sets PC's data and ends event
	;***************************
	XEvent0EMosquitus10:
		JSL PCSwapHealth
		JSL PCIconBase
		STZ !PCHealthBar_1F22
		STZ !PCSubWeaponAmmoBar_1F23
		
		LDA #$C0
		TSB !ZSaberObtained_1FB2
		STZ !DisableEnemyAI_1F27
		STZ !PCNPC_Active_00
		STZ !DisablePCCharging_0A54
		LDA #$17
		JSL !PlayMusic
		
		; LDA #$01
		; TRB $1F5F
		STZ $1F5F
		STZ !DisableLRSubWeaponScroll_1F45
		STZ !DisableMenuOpening_1F4F
		JML $84D1EF
		
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #10: Buster Sigma Wall
;***************************
XEvent10BusterWallBase:
	LDX !PCNPC_EventID_02
	JMP (XEvent10BusterWallEvents,x)

XEvent10BusterWallEvents:
	dw XEvent10BusterWall00
	dw XEvent10BusterWall02
	dw XEvent10BusterWall04
	dw XEvent10BusterWall06	
	dw XEvent06XMaohGiant06
	dw XEvent10BusterWall0A
	dw XEvent10BusterWall02
	dw XEvent10BusterWall0E
	dw XEvent10BusterWall10
	dw XEvent10BusterWall12
	dw XEvent10BusterWall14
	dw XEvent10BusterWall16
	dw XEvent10BusterWall18
	dw $FF
	
	;***************************
	; Sub-event #00: Set walking, end walking, load X sprites then go to next event
	;***************************
	XEvent10BusterWall00:
		LDA #$04
		STA !PCHealthBar_1F22
		STA !PCSubWeaponAmmoBar_1F23
		LDA !CurrentPCAction_09DA
		CMP #$66
		BNE XEvent10BusterWall00RTL
		
		LDA !CurrentPCSubAction_09DB
		CMP #$08
		BEQ XEvent10BusterWall00IncreaseEvent
XEvent10BusterWall00RTL:
		RTL
		
XEvent10BusterWall00IncreaseEvent:
		LDA #$2C
		STA !PCNPC_PaletteDirection_11
		JSL XSetup
		
		LDA #$04
		STA !PCNPC_SpritePriority_12
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		INC !DisableLRSubWeaponScroll_1F45
		INC !DisableMenuOpening_1F4F
		
		LDA #$40
		TSB !PCNPC_PaletteDirection_11
		
		REP #$20
		LDA !ScreenXCoordinate_1E5D
		STA !PCNPC_XCoordinate_05
		LDA !ScreenYCoordinate_1E60
		CLC
		ADC #$00A1
		STA !PCNPC_YCoordinate_08
		LDA #$0178
		STA !PCNPC_SpeedDistance_1A
		STZ !PCNPC_Velocity_1C
		LDA #$0040
		STA !PCNPC_JumpHeight_1E
		SEP #$20
		LDA #$5C
		JML !VRAMRoutineConsistent
	
	;***************************
	; Sub-event #02: Set X on ground/walking
	;***************************
	XEvent10BusterWall02:
		REP #$20
		LDA !PCNPC_TempStorage_0C
		CMP !PCNPC_XCoordinate_05
		BPL XEvent10BusterWall02SkipIncrease
			
		STA !PCNPC_XCoordinate_05
		SEP #$20
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$50
		JML !VRAMRoutineConsistent
		
XEvent10BusterWall02SkipIncrease:
		SEP #$20
		JSL !CheckForLanding
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BEQ XEvent10BusterWall02SkipAnimate
		JML !AnimationConsistent
		
XEvent10BusterWall02SkipAnimate:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$51
		JML !VRAMRoutineConsistent
		
	;***************************
	; Sub-event #04: Check for PC landing on solid ground
	;***************************
	XEvent10BusterWall04:
		JSL FallingVelocity
		JSL !CheckForGround
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BNE XEvent10BusterWall04SetEvent
		JML !AnimationConsistent
		
XEvent10BusterWall04SetEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		REP #$20
		LDA #$0178
		STA !PCNPC_SpeedDistance_1A
		STZ !PCNPC_Velocity_1C
		
		SEP #$20
		LDA #$5C
		JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #06: Set text to use
	;***************************
	XEvent10BusterWall06:
		LDA #$40
		TRB !PCDirection_0A41
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$4F
		JSL !DialogueBoxNormal
		
		LDA #$50
		STA !PCNPC_AnimationFrameDoneTalk_43
		LDA #$87
		JML !VRAMRoutineConsistent
	
			
	;***************************
	; Sub-event #08: Initate common event for dialogue and animation updating
	;***************************
;	XEvent10BusterWall08:
;		JMP XEvent06XMaohGiant06


	;***************************
	; Sub-event #0A: Set PC NPC walk to wall
	;***************************
	XEvent10BusterWall0A:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		REP #$20
		LDA #$0178
		STA !PCNPC_SpeedDistance_1A
		STZ !PCNPC_Velocity_1C
		LDA #$0040
		STA !PCNPC_JumpHeight_1E
		
		LDA !ScreenXCoordinate_1E5D
		CLC
		ADC #$00C8
		STA !PCNPC_TempStorage_0C
		LDA #$003C
		STA !PCNPC_DelayTimer_3C
		LDA #$005C
		JML !VRAMRoutineConsistent
	
	;***************************
	; Sub-event #0C: Set X on ground/walking
	;***************************
;	XEvent10BusterWall0C:
;		JMP XEvent10BusterWall02

	;***************************
	; Sub-event #0E: Set Buster X sprites
	;***************************
	XEvent10BusterWall0E:
		DEC !PCNPC_DelayTimer_3C
		BNE XEvent10BusterWall0EAnimate
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$00
		JML !VRAMRoutineConsistent
		
XEvent10BusterWall0EAnimate:
		JML !AnimationConsistent
	
	
	;***************************
	; Sub-event #10: Load Buster/wall explosion
	;***************************
	XEvent10BusterWall10:
		REP #$30
		LDX #$0050 ;Load RAM location
		LDY #$0040 ;Load Palette location of X-Buster
		JSL !Palette
		
		SEP #$30
		JSL BusterXSetup
		
		STX !PCNPC_TempStorage_0C
		
		LDA !PCNPC_PaletteDirection_11 ;Load PC NPC's direction and stores same value into Z-Saber
		AND #$70
		ORA #$0A
		STA $0011,x
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$08
		STA !PCNPC_DelayTimer_3C

		JML !AnimationConsistent
		
	;***************************
	; Sub-event #12: Check for PC NPC active when dashing off screen
	;***************************
	XEvent10BusterWall12:
		DEC !PCNPC_DelayTimer_3C
		BNE XEvent10BusterWall12Animate
		
		REP #$30
		LDX !PCNPC_TempStorage_0C
		
		SEP #$30
		LDA #$00 ;This must be initiated after every buster setup for it to properly set coordinates back to PC
		STA !PCorPCNPC_Buster_7EF4EB
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$50
		JML !VRAMRoutineConsistent

XEvent10BusterWall12Animate:
		SEP #$30
		JML !AnimationConsistent

	;***************************
	; Sub-event #14: Check for PC NPC active when dashing off screen
	;***************************
	XEvent10BusterWall14:
		REP #$30
		LDX !PCNPC_TempStorage_0C
		LDA $0000,x
		BEQ XEvent10BusterWall14IncreaseEvent
		LDA $0005,x
		SEC
		SBC !ScreenXCoordinate_1E5D
		SEP #$30
		
		CMP #$20
		BCS XEvent10BusterWall14Animate
		JSL $83B508 ;Sets wall explosion & tile map update

XEvent10BusterWall14Animate:
		SEP #$30
		JML !AnimationConsistent		
		
XEvent10BusterWall14IncreaseEvent:
		STZ $000B,x
		REP #$20
		LDA #$0375
		STA !PCNPC_SpeedDistance_1A
		SEP #$20
		LDA #$0A
		JSL !PlaySFX
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$66
		JML !VRAMRoutineConsistent	

	
	;***************************
	; Sub-event #16: Check for PC NPC active when dashing off screen
	;***************************	
	XEvent10BusterWall16:
		JSL !MoveObjectRight
		
		LDA !PCNPC_Animate_0E
		BEQ XEvent10BusterWall16IncreaseEvent
		JML !AnimationConsistent
		
XEvent10BusterWall16IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		RTL
	
	;***************************
	; Sub-event #18: Reenable weapon switching, menu opening and set weapon palette/VRAM
	;***************************
	XEvent10BusterWall18:
		STZ !PCNPC_Active_00
		STZ !PCHealthBar_1F22
		STZ !PCSubWeaponAmmoBar_1F23
		
		JSL !ReloadSubWeapGreaphics ;Set X's weapon palette and VRAM
		JSL $84D169
		JSL !PalettePCBuster

		STZ !DisableLRSubWeaponScroll_1F45
		STZ !DisableMenuOpening_1F4F
		
		LDA #$01
		TSB $1FE0 ;Bit flag for event being done
		REP #$20
		SEP #$20
		RTL
	
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #12: Sigma Virus
;***************************
XEvent12SigmaVirusBase:
	LDX !PCNPC_EventID_02
	JMP (XEvent12SigmaVirusEvents,x)

XEvent12SigmaVirusEvents:
	dw XEvent12SigmaVirus00
	dw XEvent12SigmaVirus02
	dw XEvent12SigmaVirus04
	dw XEvent12SigmaVirus06
	dw XEvent12SigmaVirus08
	dw XEvent12SigmaVirus0A
	dw XEvent12SigmaVirus0C
	dw XEvent06XMaohGiant06
	dw XEvent12SigmaVirus10
	dw XEvent12SigmaVirus12
	dw XEvent12SigmaVirus14
	dw XEvent06XMaohGiant0A
	dw XEvent12SigmaVirus18
	dw XEvent12SigmaVirus1A
	
	dw XEvent12SigmaVirusDoppler00 ;Initiate Dr. Doppler variation
	dw XEvent12SigmaVirusDoppler02
	dw XEvent12SigmaVirusDoppler04
	dw XEvent12SigmaVirusDoppler06
	dw XEvent12SigmaVirusDoppler08
	dw XEvent12SigmaVirusDoppler0A
	dw XEvent12SigmaVirusDoppler0C
	dw XEvent12SigmaVirusDoppler0E
	dw XEvent12SigmaVirusDoppler10
	dw XEvent12SigmaVirusDoppler12
	dw $FF
	
	;***************************
	; Sub-event #00: Set music
	;***************************
	XEvent12SigmaVirus00:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		STZ !PCNPC_SubEvent_03
		
		LDA #$3C
		STA !PCNPC_DelayTimer_3C
		LDA #$30
		TSB !PCDirection_0A41
		
		LDA !ZSaberObtained_1FB2
		BIT #$40
		BNE XEvent12SigmaVirus00LoadDopplerMusic
		LDA #$21 ;Load X's theme (Dr. Cain's theme)
		BRA XEvent12SigmaVirus00SkipDopplerMusic
XEvent12SigmaVirus00LoadDopplerMusic:
		LDA #$22 ;Load Doppler's theme
		
XEvent12SigmaVirus00SkipDopplerMusic:
		JML !PlayMusic
	
	;***************************
	; Sub-event #02: Load ceiling explosions
	;***************************
	XEvent12SigmaVirus02:
		DEC !PCNPC_DelayTimer_3C
		BEQ XEvent12SigmaVirus02IncreaseEvent
		RTL
		
XEvent12SigmaVirus02IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$23
		JSL !PlaySFX
		
		LDA #$01
		JSL $82C400 ;???
		
		LDA #$01
		TSB $1F5D ;Bit flag for event
		
		REP #$20
		LDA #$0A70
		STA !PCNPC_XCoordinate_05
		LDA !ScreenYCoordinate_1E60
		STA !PCNPC_YCoordinate_08
		STZ !PCNPC_SpeedDistance_1A
		STZ !PCNPC_Velocity_1C
		LDA #$0040
		STA !PCNPC_JumpHeight_1E
		
;This section has something to do with the explosions on the ceiling
XEvent12SigmaVirus02Explosions:
		STZ $0000
		LDA #$FFF0
		STA $0002
		LDA #$001F
		STA $0004
		LDA #$003F
		STA $0006
		STZ $0008
		LDY #$10
XEvent12SigmaVirus02ExplosionLoop:
		JSL $84D6FB
		DEY
		BNE XEvent12SigmaVirus02ExplosionLoop
		RTL
	
	;***************************
	; Sub-event #04: Load X or Dr. Doppler falling from ceiling
	;***************************
	XEvent12SigmaVirus04:
		REP #$20
		JSL XEvent12SigmaVirus02Explosions ;MIGHT just have to copy/paste the code
		
		SEP #$20
		LDA !ZSaberObtained_1FB2
		BIT #$40
		BNE XEvent12SigmaVirus04DopplerLoading
		
		LDA #$2C
		STA !PCNPC_PaletteDirection_11
		JSL XSetup
		
		LDA #$04
		STA !PCNPC_SpritePriority_12
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$40
		TSB !PCNPC_PaletteDirection_11
		
		LDA #$57
		JML !VRAMRoutineConsistent
		
XEvent12SigmaVirus04DopplerLoading:
		LDA #$1C ;Store PCNCPC event to get Doppler's loading data
		STA !PCNPC_EventID_02
		
		LDA $7F82D9
		STA !PCNPC_VRAMSlot_18
		LDA $7F83D9
		ORA #$40
		STA !PCNPC_PaletteDirection_11
		LDA #$04
		STA !PCNPC_SpritePriority_12
		LDA #$4D
		STA !PCNPC_Hitbox_20
		LDA #$B5
		STA $21 ;High byte of PC NPC hitbox
		LDA #$BA
		STA !PCNPC_SpriteAssembly_16
		STZ !PCSpritePriority_09EA
		LDA #$00
		JSL !AnimationOneFrame
		JML !EventLoop
		
		
	;***************************
	; Sub-event #06: PC NPC falling and landing
	;***************************
	XEvent12SigmaVirus06:
		JSL FallingVelocity
		JSL !CheckForGround
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BNE XEvent12SigmaVirus06IncreaseEvent
		JML !AnimationConsistent
		
XEvent12SigmaVirus06IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$00
		JML !VRAMRoutineConsistent
		
	
	;***************************
	; Sub-event #08: Load Buster
	;***************************
	XEvent12SigmaVirus08:
		REP #$10
		LDX #$0050 ;Load RAM location
		LDY #$0040 ;Load Palette location of X-Buster
		JSL !Palette
		
		JSL BusterXSetup
		
		STX !PCNPC_TempStorage_41
		
		LDA !PCNPC_PaletteDirection_11 ;Load PC NPC's direction and stores same value into Z-Saber
		AND #$70
		ORA #$0A
		STA $0011,x
		
		LDA #$08
		STA !PCNPC_DelayTimer_3C
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
	
		SEP #$30
		JML !AnimationConsistent
		
		
	;***************************
	; Sub-event #0A: Timer for buster then switch X animation
	;***************************
	XEvent12SigmaVirus0A:
		DEC !PCNPC_DelayTimer_3C
		BNE XEvent12SigmaVirus0AAnimate
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		REP #$20
		LDX !PCNPC_TempStorage_41

		LDA #$FE88
		STA !PCNPC_SpeedDistance_1A
		LDA #$0553
		STA !PCNPC_Velocity_1C
		SEP #$20
		LDA #$00
		STA !PCorPCNPC_Buster_7EF4EB
		LDA #$02
		TRB $1F53 ;Set flag to trigger screen explosions
		
		LDA #$51
		JML !VRAMRoutineConsistent

XEvent12SigmaVirus0AAnimate:
		SEP #$30
		JML !AnimationConsistent
	
	;***************************
	; Sub-event #0C ;Check for PC NPC landing and then trigger dialogue
	;***************************
	XEvent12SigmaVirus0C:
		JSL !CheckForGround
		JSL FallingVelocity
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BNE XEvent12SigmaVirus0CIncreaseEvent
		JML !AnimationConsistent
		
XEvent12SigmaVirus0CIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$00
		JSL !DialogueBoxSmall
		
		LDA #$01
		TRB $1F53 ;Set bit flag for event
		LDA #$50
		STA !PCNPC_AnimationFrameDoneTalk_43
		LDA #$87
		JML !VRAMRoutineConsistent

	;***************************
	; Sub-event #0E ;Initate common event for dialogue and animation updating
	; [Different location than the other pieces]
	;***************************
;	XEvent12SigmaVirus0E:
;		JMP XEvent06XMaohGiant06

	;***************************
	; Sub-event #10 ;Set PC NPC triggers and data for walking speed
	;***************************
	XEvent12SigmaVirus10:
		LDA $1F53 ;Check flag for event triggers
		BIT #$01
		BEQ XEvent12SigmaVirus10SkipIncrease
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$1E
		STA !PCNPC_DelayTimer_3C
		REP #$20
		LDA #$0178
		STA !PCNPC_SpeedDistance_1A
		SEP #$20
		
XEvent12SigmaVirus10SkipIncrease:
		JML !AnimationConsistent
	
	;***************************
	; Sub-event #12 ;Set PC NPC walk animation
	;***************************
	XEvent12SigmaVirus12:
		DEC !PCNPC_DelayTimer_3C
		BEQ XEvent12SigmaVirus12IncreaseEvent
		JML !AnimationConsistent
		
XEvent12SigmaVirus12IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$1E
		STA !PCNPC_DelayTimer_3C
		LDA #$5C
		JML !VRAMRoutineConsistent
	
	
	;***************************
	; Sub-event #14 ;PC NPC walking
	;***************************
	XEvent12SigmaVirus14:
		LDA #$40
		TRB !PCDirection_0A41
		TRB !PCPaletteDirection_09E9
		
		LDA !PCNPC_DelayTimer_3C
		BEQ XEvent12SigmaVirus14MoveNPC
		DEC !PCNPC_DelayTimer_3C
		BNE XEvent12SigmaVirus14MoveNPC
		
		REP #$20
		LDA #$0A70
		JSL $84D24B ;Sets PC NPC coordinates for max walking distance?
		
XEvent12SigmaVirus14MoveNPC:
		REP #$20
		JSL !MoveObjectRight
		
		LDA #$0A70
		CMP !PCNPC_XCoordinate_05
		BMI XEvent12SigmaVirus14IgnoreAnimate
		JML !AnimationConsistent
		
XEvent12SigmaVirus14IgnoreAnimate:
		STA !PCNPC_XCoordinate_05
		LDA #$0AA6
		STA !PCNPC_Velocity_1C
		SEP #$20
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$11
		JSL !PlaySFX
		LDA #$7F
		
		JML !VRAMRoutineConsistent
	
	;***************************
	; Sub-event #16: Common event for NPC begin teleport out
	;***************************
;		XEvent12SigmaVirus16:
;			JMP XEvent06XMaohGiant0A

	;***************************
	; Sub-event #18: Set PC and PC NPC teleport out
	;***************************
	XEvent12SigmaVirus18:
		JSL $83B74D ;Check of PC done walking?
		JMP XEvent06XMaohGiant0C
		
	;***************************
	; Sub-event #1A: PC teleport out
	;***************************
	XEvent12SigmaVirus1A:
		JSL $83B74D ;Check of PC done walking?
		JML $83B867 ;Sets data for Z-Saber slices to appear around Sigma Virus 
		
		LDA #$40
		TRB !PCDirection_0A41
		TRB !PCPaletteDirection_09E9
		
		LDA !CurrentPCAction_09DA
		CMP #$66
		BNE XEvent12SigmaVirus1AEndRoutine
		
		LDA !CurrentPCSubAction_09DB
		CMP #$08
		BNE XEvent12SigmaVirus1AEndRoutine
		
		LDA #$20
		TSB $1F5F ;Set event trigger
		
XEvent12SigmaVirus1AEndRoutine:
		RTS

;***************************		
;DR. DOPPLER EVENTS ONLY
;***************************
	;***************************
	; Sub-event #1C: Dr. Doppler falling & landing
	;***************************
	XEvent12SigmaVirusDoppler00:
		JSL FallingVelocity
		JSL !CheckForGround
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		AND #$04
		BEQ XEvent12SigmaVirusDoppler00EndRoutine
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
XEvent12SigmaVirusDoppler00EndRoutine:
		JML !EventLoop
	
	
	;***************************
	; Sub-event #1E: Set Doppler velocity and jump distance
	;***************************
	XEvent12SigmaVirusDoppler02:
		LDA !PCNPC_IsAnimating_0F
		BPL XEvent12SigmaVirusDoppler02Animate
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$01
		JSL !AnimationOneFrame
		
		REP #$20
		LDA #$0378
		STA !PCNPC_SpeedDistance_1A
		LDA #$0353
		STA !PCNPC_Velocity_1C
		SEP #$20
		
XEvent12SigmaVirusDoppler02Animate:
		JSL !VRAMRoutineAlt
		JML !EventLoop
	
	;***************************
	; Sub-event #20: Dr. Doppler begin jump
	;***************************
	XEvent12SigmaVirusDoppler04:
		LDA !PCNPC_IsAnimating_0F
		BPL XEvent12SigmaVirusDoppler04Animate
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
XEvent12SigmaVirusDoppler04Animate:
		JSL !VRAMRoutineAlt
		JML !EventLoop
	
	;***************************
	; Sub-event #22: Dr. Doppler jump & touch Sigma
	;***************************
	XEvent12SigmaVirusDoppler06:
		JSL !CheckForGround
		REP #$10
		LDX !PCNPC_TempStorage_0C
		JSL $84CC5C ;Check for enemy to touch another object then drag it with
		SEP #$30
		BCC XEvent12SigmaVirusDoppler06EventLoop
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$02
		TRB $1F53 ;Set event flag
		
		REP #$30
		STZ !PCNPC_SpeedDistance_1A
		STZ !PCNPC_Velocity_1C
		SEP #$30
		
		LDA #$03
		JSL !AnimationOneFrame
		
XEvent12SigmaVirusDoppler06EventLoop:
		JML !EventLoop
		
	;***************************
	; Sub-event #24: Doppler falling with Sigma with him
	;***************************
	XEvent12SigmaVirusDoppler08:
		JSL !CheckForGround
		JSL !LandOnGround
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BEQ XEvent12SigmaVirus22EndRoutine
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
XEvent12SigmaVirus22EndRoutine:
		JML !EventLoop
		
		
	;***************************
	; Sub-event #26 ;Doppler land & initiate dialogue
	;***************************
	XEvent12SigmaVirusDoppler0A:
		LDA !PCNPC_IsAnimating_0F
		BPL XEvent12SigmaVirusDoppler0AAnimate
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$01
		JSL !DialogueBoxSmall
		
		LDA #$01
		TRB $1F53 ;Set bit flag for event
		
XEvent12SigmaVirusDoppler0AAnimate:
		JSL !VRAMRoutineAlt
		JML !EventLoop
		
	;***************************
	; Sub-event #28: Set animation for Doppler talking
	;***************************		
	XEvent12SigmaVirusDoppler0C:
		LDA !EnableEventLock_1F3F
		BPL XEvent12SigmaVirusDoppler0CIncreaseEvent
		LDA $1F51
		BNE XEvent12SigmaVirusDoppler0CAnimating
		
		LDA $1F50
		CMP #$03
		BEQ XEvent12SigmaVirusDoppler0CAnimate
		
XEvent12SigmaVirusDoppler0CAnimating:
		LDA !PCNPC_IsAnimating_0F
		BEQ XEvent12SigmaVirusDoppler0CEventLoop
		
XEvent12SigmaVirusDoppler0CAnimate:
		JSL !VRAMRoutineAlt

XEvent12SigmaVirusDoppler0CEventLoop:
		JML !EventLoop
		
XEvent12SigmaVirusDoppler0CIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		JML !EventLoop
		
	;***************************
	; Sub-event #2A: Initiate final sequence of event
	;***************************		
	XEvent12SigmaVirusDoppler0E:
		LDA $1F53 ;Check for event bit flag
		BIT #$01
		BNE XEvent12SigmaVirusDoppler0EEventLoop
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$F0
		STA !PCNPC_DelayTimer_3C
		
XEvent12SigmaVirusDoppler0EEventLoop:
		JML !EventLoop
	
	;***************************
	; Sub-event #2C: Timer & PC teleport out
	;***************************		
	XEvent12SigmaVirusDoppler10:
		DEC !PCNPC_DelayTimer_3C
		BNE XEvent12SigmaVirusDoppler10EventLoop
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$20
		TSB $1F5F ;Set event bit flag
		JSL $84D2D6 ;Load PC teleport out
		
XEvent12SigmaVirusDoppler10EventLoop:
		JML !EventLoop
	
	;***************************
	; Sub-event #2E ;Set Z-Saber slash around Sigma Virus
	;***************************		
	XEvent12SigmaVirusDoppler12:
		JML $83B863 ;JML to final doppler events NPC data
		
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #14: Cliff
;***************************
XEvent14CliffSceneBase:
	LDX !PCNPC_EventID_02
	JMP (XEvent14CliffSceneEvents,x)

XEvent14CliffSceneEvents:
	dw XEvent14CliffScene00
	dw XEvent14CliffScene02
	dw $FF
	
	
	;***************************
	; Sub-event #00 ;Set X on cliff
	;***************************		
	XEvent14CliffScene00:
		STZ $00DF
		LDA !ZSaberObtained_1FB2
		BIT #$40
		BEQ XEvent14CliffScene00IncreaseEvent
		RTL
		
XEvent14CliffScene00IncreaseEvent:
		LDA #$26
		STA !PCNPC_PaletteDirection_11
		LDA #$04
		STA !PCNPC_SpritePriority_12
		JSL XSetup
		LDA !PCNPC_PaletteDirection_11
		SEC
		SBC #$40
		STA !PCNPC_PaletteDirection_11
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$50
		JSL !AnimationOneFrame

	;***************************
	; Sub-event #02 ;Animate X Idle
	;***************************
	XEvent14CliffScene02:
		LDA $1F38
		BNE XEvent14CliffScene02EventLoop
		
		JSL !VRAMRoutineAlt
		JSL NewVRAMRoutine
		
XEvent14CliffScene02EventLoop:
		JML !EventLoop
		
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #16: Credit Roll
;***************************
XEvent16CreditsBase:
	LDX !PCNPC_EventID_02
	JMP (XEvent16CreditsEvents,x)

XEvent16CreditsEvents:
	dw XEvent16Credits00
	dw XEvent16Credits02
	dw $FF
	
	
	;***************************
	; Sub-event #00 ;Set X on floor for credit roll
	;***************************		
	XEvent16Credits00:
		LDA !ZSaberObtained_1FB2
		BIT #$40
		BEQ XEvent16Credits00IncreaseEvent
		RTL
		
XEvent16Credits00IncreaseEvent:
		LDA #$26
		STA !PCNPC_PaletteDirection_11
		LDA #$04
		STA !PCNPC_SpritePriority_12
		JSL XSetup
		LDA !PCNPC_PaletteDirection_11
		SEC
		SBC #$40
		STA !PCNPC_PaletteDirection_11
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$5C ;Set animation for X to run
		JSL !AnimationOneFrame

	;***************************
	; Sub-event #02 ;Animate X walking
	;***************************
	XEvent16Credits02:
		LDA $1F38
		BNE XEvent16Credits02EventLoop
		
		JSL !VRAMRoutineAlt
		JSL NewVRAMRoutine
		
XEvent16Credits02EventLoop:
		JML !EventLoop