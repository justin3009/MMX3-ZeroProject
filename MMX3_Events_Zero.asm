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
		!ZeroMainEvents	= $E08080
;***************************
header : lorom
	
incsrc MMX3_NewCode_Locations.asm
incsrc MMX3_VariousAddresses.asm

;***************************
;***************************
; Pointers to Zero Events
;***************************
org !ZeroMainEvents
	LDX $01
	JMP (ZeroMainEventPointers,x)
	
ZeroMainEventPointers:
	dw ZeroEvent00SpyCopterBase
	dw ZeroEvent02XGetsCapturedBase
	dw ZeroEvent04RescueXBase
	dw ZeroEvent06ZeroMaohGiantBase
	dw ZeroEvent08ZeroPowerCellDamagedBase ;UNUSED AND COMPLETELY BLANK
	dw ZeroEvent0ADrCainFindLabBase
	dw ZeroEvent0CREX2000Base
	dw ZeroEvent0EMosquitusBase
	dw ZeroEvent10ZSaberWallBase
	dw ZeroEvent12SigmaVirusBase
	dw ZeroEvent14CliffSceneBase
	dw ZeroEvent16CreditsBase
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
{
ZeroEvent00SpyCopterBase:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent00SpyCopterEvents,x)

ZeroEvent00SpyCopterEvents:
	dw ZeroSpyCopter00
	dw ZeroSpyCopter02
	dw ZeroSpyCopter04
	dw ZeroSpyCopter06
	dw ZeroSpyCopter08
	dw ZeroSpyCopter0A
	dw ZeroSpyCopter0C
	dw ZeroSpyCopter0E
	dw ZeroSpyCopter10
	dw ZeroSpyCopter12
	dw ZeroSpyCopter14
	dw ZeroSpyCopter16
	db $FF,$FF


	;***************************
	; Sub-event #00: Sets Zero's sprite data up & palette, Z-Saber palette, Zero's jump velocity, distance and hitbox.
	;***************************
ZeroSpyCopter00:
		INC !PCNPC_EventID_02 ;Increase Zero Introduction Event to 02
		INC !PCNPC_EventID_02 ;Increase Zero Introduction Event to 02
		LDA #$2C ;Set PC NPC's palette RAM location [ABSOLUTELY REQUIRED BEFORE JSLING TO SPRITES FIRST TIME]
		STA !PCNPC_PaletteDirection_11
		JSL ZeroSetup ;Load Zero's sprite settings
		LDA #$52 ;Zero Jump Animation
		JSL !AnimationOneFrame
		JSL NewVRAMRoutine
		
		REP #$10
		LDX #$0070 ;Load RAM location to store palette
		
		LDA !RideChipsOrigin_7E1FD7
		AND #$F0
		CMP #$F0
		BEQ LoadZeroPurpleSaber
		LDY #$00D2 ;Load Z-Saber palette
		BRA LoadZeroBusterPaletteEnd
		
		LoadZeroPurpleSaber:
		LDY #$0206 ;Load Z-Saber Purple palette
		
		LoadZeroBusterPaletteEnd:	
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
		LDA #$0710 ;Load velocity of Zero
		STA !PCNPC_Velocity_1C
		LDA #$FE80 ;Load distance/speed of Zero
		STA !PCNPC_SpeedDistance_1A
		LDA #$0040 ;Load hitbox of Zero
		STA !PCNPC_JumpHeight_1E
		SEP #$30
		RTL
		
	;***************************
	; Sub-event #02: Zero flying up to land on Spycopter
	;***************************
ZeroSpyCopter02:
		JSL !CheckForGround
		BIT $1D
		BPL SpyCopter02Loop
		REP #$20
		LDA $08 ;Y coordinate of NPC
		CMP #$0178 ;Check for value
		SEP #$20
		BMI SpyCopter02Loop ;If <= #$0178, BMI to $03/A8D2 to ignore event increase and loop event
		
		INC !PCNPC_EventID_02 ;Increase Zero Introduction Spycopter Event to 04
		INC !PCNPC_EventID_02 ;Increase Zero Introduction Spycopter Event to 04
		LDA #$6F ;Load animation for Zero landing on Spycopter
		JML !VRAMRoutineConsistent
SpyCopter02Loop:
		JML !AnimationConsistent
		
	;***************************
	; Sub-event #04: Zero landing on Spycopter
	;***************************
ZeroSpyCopter04:
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
		BPL ZeroSpyCopter04Increase
		SEP #$30
		JML !AnimationConsistent
		
ZeroSpyCopter04Increase:
		LDA #$0600 ;Load speed/stance of NPC
		STA !PCNPC_SpeedDistance_1A
		LDA #$0380 ;Load velocity of NPC 
		STA !PCNPC_Velocity_1C
		SEP #$30
		INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 06
		INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 06
		LDA #$72 ;Load Zero kicking off wall animation
		JML !VRAMRoutineConsistent
		
	;***************************
	; Sub-event #06: Check for ??? then load Zero's Z-Saber sprite assembly data and animation
	;***************************
ZeroSpyCopter06:
		JSL !CheckForGround
		LDA $0F
		BMI ZeroSpyCopter06Increase
		JML !AnimationConsistent
		
ZeroSpyCopter06Increase:
		INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 08
		INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 08
		REP #$20
		STZ !PCNPC_SpeedDistance_1A  ;Store 00 to PC NPC RAM at $7E:0CE2 (PC NPC jump speed/distance low byte)
		SEP #$20
		JSL ZeroZSaberSetup
		LDA #$0E ;Load Zero using Z-Saber animation
		JML !VRAMRoutineConsistent
		
	;***************************
	; Sub-event #08: Draw Z-Saber object
	;***************************
ZeroSpyCopter08:
			JSL !CheckForGround
			
			REP #$20
			LDA #$FA80
			CMP !PCNPC_Velocity_1C
			BMI ZeroSpyCopter08IgnoreStorage
			STA !PCNPC_Velocity_1C
ZeroSpyCopter08IgnoreStorage:
			SEP #$20
			
			BIT !PCNPC_IsAnimating_0F
			BMI ZeroSpyCopter08Increase
			BVC ZeroSpyCopter08Animation
;Z-Saber setup			
			JSL ZSaberZeroSetup

ZeroSpyCopter08Animation:			
			SEP #$30
			JML !AnimationConsistent
			
ZeroSpyCopter08Increase:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0A
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0A
			JSL ZeroSetup
			LDA #$57 ;Load Zero falling animation
			JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #0A: Spycopter breaking with NPC Zero falling/landing
	;***************************
ZeroSpyCopter0A:
			REP #$20
			LDA #$FA80
			CMP !PCNPC_Velocity_1C
			BMI ZeroSpyCopter0AIgnoreStorage
			STA !PCNPC_Velocity_1C
ZeroSpyCopter0AIgnoreStorage:
			SEP #$20
			
			JSL !CheckForGround
			JSL !LandOnGround
			LDA !PCNPC_OnGround_2B ;Load byte to determine if NPC is on ground or in air
			BIT #$04 ;BIT #$04 (On ground)
			BNE ZeroSpyCopter0AIncrease
			JML !AnimationConsistent
			
ZeroSpyCopter0AIncrease:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0C
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0C
			LDA #$3C ;Load delay timer before dialogue box can load up
			STA !PCNPC_DelayTimer_3C ;Store to NPC RAM at $7E:0D04
			LDA #$50 ;Load animation for Zero landing on ground
			JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #0C: Initiate data to draw dialogue box
	;***************************
ZeroSpyCopter0C:
			DEC !PCNPC_DelayTimer_3C ;Decrease delay timer from $7E:0D04
			BEQ ZeroSpyCopter0CSkipAnimation
			JSL !VRAMRoutineAlt ;Load alternate force VRAM update? (Can be changed to 04:BCA2 and it works just fine still?)
			JML !EventLoop
			
ZeroSpyCopter0CSkipAnimation:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0E
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 0E
			LDA #$3C ;Load delay timer before Zero teleports out after dialogue
			STA !PCNPC_DelayTimer_3C		
			
			REP #$20
			LDA !CurrentPCAction_09DA
			STA !PCNPC_TempStorage_33
			LDA #$0866
			STA !CurrentPCAction_09DA
			SEP #$20
			
			LDA #$30 ;Load which dialogue to use
			JSL !DialogueBoxNormal
			LDA #$50 ;Load frame to use after Zero NPC is done talking
			STA !PCNPC_AnimationFrameDoneTalk_43
			LDA #$87 ;Load frame for Zero Talking
			JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #0E: Initiate data to draw dialogue box
	;***************************
ZeroSpyCopter0E:
			LDA $1F3F ;Check for 'Event lock'
			BPL ZeroSpyCopter0EIncrease
			LDA $1F51 ;Load NPC talk animation bit
			BNE ZeroSpyCopter0ECheckVRAM
			
			LDA $1F50 ;Check for NPC allowed to talk animation bit
			CMP #$01
			BEQ ZeroSpyCopter0EVRAMUpdate
			
ZeroSpyCopter0ECheckVRAM:
			LDA !PCNPC_IsAnimating_0F ;Load flag to check if NPC needs to update their VRAM data
			BEQ ZeroSpyCopter0EEventLoop
			
ZeroSpyCopter0EVRAMUpdate:
			JSL !VRAMRoutineAlt
			
ZeroSpyCopter0EEventLoop:
			JML !EventLoop
			
ZeroSpyCopter0EIncrease:
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
ZeroSpyCopter10:
			DEC !PCNPC_DelayTimer_3C ;Decrease delay timer from $7E:0D04
			BEQ ZeroSpyCopter10Increase
			JSL !VRAMRoutineAlt
			JML !EventLoop
			
ZeroSpyCopter10Increase:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 12
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 12
			LDA #$11 ;Load teleport out SFX
			JSL !PlaySFX
			LDA #$7F ;Load Zero begin teleporting out animation
			JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #12: Common event for NPC begin teleport out
	;***************************	
ZeroSpyCopter12:
			LDA !PCNPC_IsAnimating_0F ;Load flag to check if NPC needs to update their VRAM data
			BMI ZeroSpyCopter12Increase
			JML !AnimationConsistent
			
ZeroSpyCopter12Increase:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 14
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 14
			REP #$20
			LDA #$0AA6 ;Load velocity of Zero
			STA !PCNPC_Velocity_1C
			SEP #$20
			LDA #$10 ;Load teleport out SFX #2
			JSL !PlaySFX
			LDA #$7D ;Load Zero teleport out animation
			JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #14: Zero teleporting out
	;***************************	
ZeroSpyCopter14:
			JSL !MoveObjectUp
			LDA !PCNPC_Animate_0E ;Load whether NPC is animating or not
			BEQ ZeroSpyCopter14Increase
			JML !EventLoop
			
ZeroSpyCopter14Increase:
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 16
			INC !PCNPC_EventID_02 ;Increase Introduction Spycopter Event to 16
			RTL
			
	;***************************
	; Sub-event #16: End Introduction event
	;***************************	
ZeroSpyCopter16:
			STZ !PCNPC_Active_00 ;Store 00 to NPC RAM at $7E:0CC8 so NPC is removed from screen
			RTL
}
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #02: X Gets Captured 
;***************************
ZeroEvent02XGetsCapturedBase:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent02XGetsCapturedEvents,x)

ZeroEvent02XGetsCapturedEvents:
	dw ZeroEvent02XGetsCaptured00
	dw ZeroEvent02XGetsCaptured02
	dw ZeroEvent02XGetsCaptured04
	dw ZeroEvent02XGetsCaptured06
	dw ZeroEvent02XGetsCaptured08
	dw ZeroEvent02XGetsCaptured0A
	dw ZeroEvent02XGetsCaptured0C
	dw ZeroEvent02XGetsCaptured0E
	dw ZeroEvent02XGetsCaptured10
	dw ZeroEvent02XGetsCaptured12
	dw ZeroEvent02XGetsCaptured14
	dw ZeroEvent02XGetsCaptured12
	dw ZeroEvent02XGetsCaptured18
	dw ZeroEvent02XGetsCaptured1A
	dw ZeroEvent02XGetsCaptured1C
	dw ZeroEvent02XGetsCaptured12
	dw ZeroEvent02XGetsCaptured20
	dw $FF
	
	;***************************
	; Sub-event #00: Set X NPC sprites up
	;***************************
ZeroEvent02XGetsCaptured00:
		INC !PCNPC_EventID_02 ;Increase Zero Introduction Event to 02
		INC !PCNPC_EventID_02 ;Increase Zero Introduction Event to 02
		
		LDA #$04
		STA !PCNPC_SpritePriority_12
		LDA #$26
		STA !PCNPC_PaletteDirection_11
		LDA #$40 ;Manually set PC NPC direction
		TSB !PCNPC_PaletteDirection_11
		JSL XSetup
		
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
	; Sub-event #02: Sets Zero breathing and collapsing. Clears out all charges.
	;***************************
ZeroEvent02XGetsCaptured02:
		REP #$10
		LDX !PCNPC_TempStorage_0C
		JSL !MissileHitObject
		BCC ZeroEvent02JumptoAnimation02
		
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
		JSL XZSaberSetup
		
		LDA #$1C ;Load animation for NPC X to use
		JSL !AnimationOneFrame
		INC $3D	;Enables object above PC
		INC $3E ;Enables object above PC
		JSL !CheckSpecialFXSlot
		
		BNE ZeroEvent02JumptoAnimation02
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
		STA $0008,x
		LDA #$0D05
		STA $000C,x
		TXA
		STA $3F
ZeroEvent02JumptoAnimation02:
		JML !AnimationConsistent
		
	;***************************
	; Sub-event #04: Countdown timer to load next dialogue box/flickering
	;***************************
ZeroEvent02XGetsCaptured04:
		JSL MissileFlickering ;Sets flickering for object covering X
		DEC !PCNPC_DelayTimer_3C
		BNE ZeroEvent02JumptoAnimation04
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$31 ;Load dialogue to use
		JSL !DialogueBoxNormal
		
ZeroEvent02JumptoAnimation04:
		JML !AnimationConsistent
		
	;***************************
	; Sub-event #06: Sets event lock then loads object to pick NPC X up
	;***************************
ZeroEvent02XGetsCaptured06:
		JSL MissileFlickering
		LDA !EnableEventLock_1F3F
		BMI ZeroEvent02JumptoAnimation06
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		JSL !CheckSpecialFXSlot
		BNE ZeroEvent02JumptoAnimation06
		
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
		ADC #$0040
		STA $0008,x
		LDA #$FC00
		STA $001A,x
		LDA #$FF00
		STA $001C,x
		LDA #$0D06
		STA $000C,x
		TXA
		STA $41 ;Temp. Storage on PC NPC
		
ZeroEvent02JumptoAnimation06:
		SEP #$30
		JML !AnimationConsistent
		
	;***************************
	; Sub-event #08: Object checking for coordinates and picking up NPC X
	;***************************
ZeroEvent02XGetsCaptured08:
		JSL MissileFlickering
		REP #$20
		PHD
		LDA $41 ;Temp. Storage on PC NPC
		TCD
		JSL !CheckForLanding
		
		LDA $0CCD ;PC NPC X coordinates. This is HARD SET due to the missile using the main RAM
		CMP !PCNPC_XCoordinate_05 ;Check object X coordinates using OBJECT RAM at $7E:185D
		BMI ZeroEvent02IgnoreSTZ08
		STZ !PCNPC_SpeedDistance_1A ;Store 00 to OBJECT RAM at $7E:1872
ZeroEvent02IgnoreSTZ08:
		LDA !PCNPC_YCoordinate_08 ;Load OBJECT RAM Y coordinates
		CMP #$068F
		BPL ZeroEvent02IgnoreContinue08
		PLD
		JML !AnimationConsistent
		
ZeroEvent02IgnoreContinue08:
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
ZeroEvent02XGetsCaptured0A:
		JSL MissileFlickering
		DEC !PCNPC_DelayTimer_3C
		BNE ZeroEvent02JumptoAnimation0A
		
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
ZeroEvent02JumptoAnimation0A:
		JML !AnimationConsistent
		
	;***************************
	; Sub-event #0C: X gets picked up and dragged off screen
	;***************************
ZeroEvent02XGetsCaptured0C:
		JSL MissileFlickering
	
		DEC !PCNPC_DelayTimer_3C
		BEQ ZeroEvent02JumptoAnimation0C
		JML !AnimationConsistent
		
ZeroEvent02JumptoAnimation0C:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		JSL XSetup
		LDA #$7B
		JML !VRAMRoutineConsistent
	
	;***************************
	; Sub-event #0E: Moves object that has X up (Merges with next event)
	;***************************
ZeroEvent02XGetsCaptured0E:
		JSL MissileFlickering
		
		REP #$30
		LDA !PCNPC_YCoordinate_08
		CMP #$0680
		BPL ZeroEvent02MoveObjectUp0E
		
		SEP #$20
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
ZeroEvent02MoveObjectUp0E:
		JSL !MoveObjectUp
		BRA ZeroEvent02SkipMoveObjectRight0E

	;***************************
	; Sub-event #10: Moves object that has X to the right and off screen
	;***************************
ZeroEvent02XGetsCaptured10:	
		JSL !MoveObjectRight
ZeroEvent02SkipMoveObjectRight0E:
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
		BNE ZeroEvent02SkipMacIncrease10
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		STZ $3E ;PC NPC temp storage
		LDA #$B4
		STA !PCNPC_DelayTimer_3C
		LDX !PCNPC_JumpHeight_1E ;Used as temp. storage for Mac's RAM
		INC $0002,x ;Increase Mac's event
		INC $0002,x ;Increase Mac's event
ZeroEvent02SkipMacIncrease10:
		RTL
		
	;***************************
	; Sub-event #12: Common Event used for strictly count downs to get to the next event
	;***************************
ZeroEvent02XGetsCaptured12:	
		DEC !PCNPC_DelayTimer_3C
		BNE ZeroEvent02IgnoreCounter12
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
ZeroEvent02IgnoreCounter12:
		RTL
	
	;***************************
	; Sub-event #14: Ceiling shake/Fall
	;***************************
ZeroEvent02XGetsCaptured14:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$C0
		STA !PCNPC_DelayTimer_3C
		JSL !CheckEnemyRoom
		BNE ZeroEvent02NoOpenEnemy14
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
ZeroEvent02NoOpenEnemy14:
		RTL
		
	;***************************
	; Sub-event #16: Event used for strictly count downs to get to the next event (Same as #12)
	;***************************
		;JMP ZeroEvent02XGetsCaptured12
	
	
	;***************************
	; Sub-event #18: Load Zero falling from ceiling & sets health
	;***************************
ZeroEvent02XGetsCaptured18:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDY #$5C ;Loads music fade and PC icon
		JSL !LoadSubWeaponIcon
		
		SEP #$30
		LDA #$3C
		STA !PCNPC_DelayTimer_3C
		STZ !PCGodMode_1F1D ;Might not be needed
		INC !PCVisibility_09E6
		
		LDA #$02
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
		LDA #$0EB4
		STA !CurrentPCHitbox_09F8
		
		SEP #$20
		LDA #$04
		TRB $0A03
		
		JSL !PalettePCBuster ;Sets PC's weapon palette
		
		LDA #$31
		JSL !PlayMusic
		
		JSL $84D1CA ;Prevents Zero from being damaged when falling
		
		STZ !PCHealthBar_1F22
		STZ !PCSubWeaponAmmoBar_1F23
		STZ !DisablePCCharging_0A54
		DEC !DisableMenuOpening_1F4F
		RTL
		
	;***************************
	; Sub-event #1A: ???
	;***************************
ZeroEvent02XGetsCaptured1A:
		LDA $1F18
		STA !PCNPC_AnimationFrameDoneTalk_43 ;Temp. storage
		LDA #$0F
		STA $1F18
		JSL $80B1DC
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		RTL
		
	;***************************
	; Sub-event #1C: Zero falling
	;***************************
ZeroEvent02XGetsCaptured1C:
		LDA $0040
		BNE ZeroEvent02IgnoreSubEvent1C
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$01
		STA $1F19
		JSL $80B5A5
ZeroEvent02IgnoreSubEvent1C:
		RTL


	;***************************
	; Sub-event #1E: Event used for strictly count downs to get to the next event (Same as #12)
	;***************************
	
	
	
	;***************************
	; Sub-event #20: Zero lands
	;***************************
ZeroEvent02XGetsCaptured20:
		LDA $0A03 ;Load PC NPC to check if on ground or air
		BIT #$04
		BEQ ZeroEvent02PCNPC_isNotOnGround20
		
		DEC !DisableLRSubWeaponScroll_1F45
		DEC !DisableMenuOpening_1F4F
		LDA !PCNPC_AnimationFrameDoneTalk_43 ;Load temp. storage
		STA $1F18
		STZ $1F19
		JSL $84D1EF
		STZ $00 ;Disables PC NPC event

ZeroEvent02PCNPC_isNotOnGround20:
		RTL
		
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #04: Rescue X from Mac
;***************************
ZeroEvent04RescueXBase:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent04RescueXEvents,x)

ZeroEvent04RescueXEvents:
	dw ZeroEvent04RescueX00
	dw ZeroEvent04RescueX02
	dw ZeroEvent04RescueX04
	dw ZeroEvent04RescueX06
	dw ZeroEvent04RescueX08
	dw ZeroEvent04RescueX0A
	dw ZeroEvent04RescueX0C
	dw ZeroEvent04RescueX0E
	dw ZeroEvent04RescueX10
	dw $FF
	
	;***************************
	; Sub-event #00: Set X hanging from object
	;***************************
ZeroEvent04RescueX00:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02

		LDA !PCPaletteDirection_09E9
		AND #$30
		ORA #$01
		ORA !PCNPC_PaletteDirection_11
		STA !PCNPC_PaletteDirection_11
		JSL ZeroSetup
		LDA #$20
		STA !PCNPC_VRAMSlot_18
		
		REP #$20
		STZ !PCNPC_SpeedDistance_1A
		STZ !PCNPC_Velocity_1C
		LDA #$0040
		STA !PCNPC_JumpHeight_1E
		LDA #$B40E
		STA !PCNPC_Hitbox_20
		SEP #$20
		LDA #$7B ;Load frame of X being held
		JSL !AnimationOneFrame
		JSL !VRAMRoutineAllowMissiles
		JML !EventLoop
		
	;***************************
	; Sub-event #02: Repeat animation
	;***************************
ZeroEvent04RescueX02:
		LDA !PCNPC_Animate_0E
		BMI ZeroEvent04RescueX02SkipAnimate
		JSL !VRAMRoutineAlt
		JSL !VRAMRoutineAllowMissiles
ZeroEvent04RescueX02SkipAnimate:
		LDA $157A
		CMP #$10
		BNE ZeroEvent04RescueX02IncreaseEvent
		LDA $0D58 ;Check object holding X to see if active
		BNE ZeroEvent04RescueX02IncreaseEvent
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		INC !DisableLRSubWeaponScroll_1F45
		INC !DisableMenuOpening_1F4F
		LDA #$04
		STA !PCHealthBar_1F22
		STA !PCSubWeaponAmmoBar_1F23
ZeroEvent04RescueX02IncreaseEvent:	
		JML !EventLoop
		
	;***************************
	; Sub-event #04: Initiate X falling
	;***************************
ZeroEvent04RescueX04:
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
ZeroEvent04RescueX06:
		JSL !CheckForGround
		JSL FallingVelocity
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BNE ZeroEvent04RescueX06OnGround
		JML !EventLoop
		
ZeroEvent04RescueX06OnGround:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$50
		JSL !AnimationOneFrame
		JSL !VRAMRoutineAllowMissiles
		JML !EventLoop

	;***************************
	; Sub-event #08: X landed
	;***************************
ZeroEvent04RescueX08:
		LDA !CurrentPCSubAction_09DB
		CMP #$08
		BNE ZeroEvent04RescueX08IgnoreEventIncrease
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
ZeroEvent04RescueX08IgnoreEventIncrease:		
		JML !EventLoop
		
	;***************************
	; Sub-event #0A: Sets PC back to X and loads dialogue
	;***************************
ZeroEvent04RescueX0A:
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
		LDA #$02
		STA !CurrentPC_0A8E
		STA !CurrentPCCheck_1FFF
		
		REP #$20
		LDA #$B404
		STA !CurrentPCHitbox_09F8
		SEP #$20
		LDA #$40
		TRB !PCNPC_PaletteDirection_11 ;PC's Palette/Direction
		TRB $69
		JSL ZeroSetup
		STZ $09F0 ;Sets PC VRAM slot to 00
		
		LDA #$50
		JSL !AnimationOneFrame
		JSL NewVRAMRoutine
		
		REP #$30
		PLD
		JSL XSetup
		
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
ZeroEvent04RescueX0C:
		LDA !EnableEventLock_1F3F
		BPL ZeroEvent04RescueX0CIncreaseEvent
		LDA $1F51
		BNE ZeroEvent04RescueX0CNPCAnimating
		
		LDA $1F50
		CMP #$01
		BEQ ZeroEvent04RescueX0CAnimate
		
ZeroEvent04RescueX0CNPCAnimating:
		LDA !PCNPC_IsAnimating_0F
		BEQ ZeroEvent04RescueX0CEventLoop
		
ZeroEvent04RescueX0CAnimate:
		JSL !VRAMRoutineAlt

ZeroEvent04RescueX0CEventLoop:
		JML !EventLoop
		
ZeroEvent04RescueX0CIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA !PCNPC_AnimationFrameDoneTalk_43
		JSL !AnimationOneFrame
		JSL !VRAMRoutineAllowMissiles
		JML !EventLoop

	;***************************
	; Sub-event #0E ;Zero begin teleport out
	;***************************
ZeroEvent04RescueX0E:
		LDA !PCNPC_IsAnimating_0F
		BMI ZeroEvent04RescueX0EIncreaseEvent
		
		JSL !VRAMRoutineAlt
		JSL !VRAMRoutineAllowMissiles
		JML !EventLoop
		
ZeroEvent04RescueX0EIncreaseEvent:
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
	; Sub-event #10 ;Zero teleport out and end routine
	;***************************
ZeroEvent04RescueX10:
		JSL !MoveObjectUp
		
		LDA !PCNPC_Animate_0E
		BEQ ZeroEvent04RescueX10NoAnimate
		JML !EventLoop
		
ZeroEvent04RescueX10NoAnimate:
		LDA #$FF
		STA !CurrentHealth_09FF
		JSL HeartTank
		STZ !CurrentPCSubWeapon_0A0B
		STZ !PCHealthBar_1F22
		STZ !PCSubWeaponAmmoBar_1F23
		LDY #$5A
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
; Event #06: Zero teleport in after Maoh the Giant
;***************************
ZeroEvent06ZeroMaohGiantBase:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent06ZeroMaohGiantEvents,x)

ZeroEvent06ZeroMaohGiantEvents:
	dw ZeroEvent06ZeroMaohGiant00
	dw ZeroEvent06ZeroMaohGiant02
	dw ZeroEvent06ZeroMaohGiant04
	dw ZeroEvent06ZeroMaohGiant06
	dw ZeroEvent06ZeroMaohGiant08
	dw ZeroEvent06ZeroMaohGiant0A
	dw ZeroEvent06ZeroMaohGiant0C
	dw ZeroEvent06ZeroMaohGiant0E
	dw $FF
	
	;***************************
	; Sub-event #00: Set Zero's sprites & teleport in speed
	;***************************
ZeroEvent06ZeroMaohGiant00:
		LDA #$26
		STA !PCNPC_PaletteDirection_11
		JSL ZeroSetup
		
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
		BMI ZeroEvent06ZeroMaohGiant00ChangeDirection
		LDA #$0040
		TSB !PCNPC_PaletteDirection_11
		LDA #$FFD0
		BRA ZeroEvent06ZeroMaohGiant00SkipChangeDirection
		
ZeroEvent06ZeroMaohGiant00ChangeDirection:
		LDA #$0030
ZeroEvent06ZeroMaohGiant00SkipChangeDirection:
		CLC
		ADC !PCXCoordinate_09DD
		STA !PCNPC_XCoordinate_05
		LDA !ScreenYCoordinate_1E60
		CLC
		ADC #$FFE0
		STA !PCNPC_YCoordinate_08
		BRA ZeroEvent06ZeroMaohGiant00SkipLoadPCNPC_
UniversalTeleportInSettings:
		SEP #$30
		LDA #$26
		STA !PCNPC_PaletteDirection_11
UniversalTeleportInSettingsSkipPalette:
		JSL ZeroSetup
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
ZeroEvent06ZeroMaohGiant00SkipLoadPCNPC_:
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
	; Sub-event #02: Zero teleport in check for landing
	;***************************
ZeroEvent06ZeroMaohGiant02:
		JSL !CheckForLanding
		
		LDA !PCNPC_DelayTimer_3C
		BEQ ZeroEvent06ZeroMaohGiant02ContinueEvent
		DEC !PCNPC_DelayTimer_3C
		BRA ZeroEvent06ZeroMaohGiant02EndRoutine
		
ZeroEvent06ZeroMaohGiant02ContinueEvent:
		JSL $84C0F7 ;Blanks out various object data?
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BEQ ZeroEvent06ZeroMaohGiant02EndRoutine
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$7E
		JML !VRAMRoutineConsistent
		
ZeroEvent06ZeroMaohGiant02EndRoutine:
		JML !AnimationConsistent

	;***************************
	; Sub-event #04: Zero landing
	;***************************
ZeroEvent06ZeroMaohGiant04:
		LDA !PCNPC_IsAnimating_0F
		BMI ZeroEvent06ZeroMaohGiant04IncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent06ZeroMaohGiant04IncreaseEvent:
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
ZeroEvent06ZeroMaohGiant06:
		LDA !EnableEventLock_1F3F
		BPL ZeroEvent06ZeroMaohGiant06IncreaseEvent
		LDA $1F51
		BNE ZeroEvent06ZeroMaohGiant06NPCAnimating
		
		LDA $1F50
		CMP #$01
		BEQ ZeroEvent06ZeroMaohGiant06Animate
		
ZeroEvent06ZeroMaohGiant06NPCAnimating:
		LDA !PCNPC_IsAnimating_0F
		BEQ ZeroEvent06ZeroMaohGiant06EventLoop
		
ZeroEvent06ZeroMaohGiant06Animate:
		JSL !VRAMRoutineAlt

ZeroEvent06ZeroMaohGiant06EventLoop:
		JML !EventLoop
		
ZeroEvent06ZeroMaohGiant06IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA !PCNPC_AnimationFrameDoneTalk_43
		JML !VRAMRoutineConsistent


	;***************************
	; Sub-event #08: Dialogue finished
	;***************************
ZeroEvent06ZeroMaohGiant08:
		DEC !PCNPC_DelayTimer_3C
		BEQ ZeroEvent06ZeroMaohGiant08IncreaseEvent
		JSL !VRAMRoutineAlt
		JML !EventLoop
		
ZeroEvent06ZeroMaohGiant08IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$11
		JSL !PlaySFX
		
		LDA #$7F
		JML !VRAMRoutineConsistent


	;***************************
	; Sub-event #0A: Common event for NPC begin teleport out
	;***************************
ZeroEvent06ZeroMaohGiant0A:
		LDA !PCNPC_IsAnimating_0F
		BMI ZeroEvent06ZeroMaohGiant0AIncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent06ZeroMaohGiant0AIncreaseEvent:
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
ZeroEvent06ZeroMaohGiant0C:
		JSL !MoveObjectUp
		
		LDA !PCNPC_Animate_0E
		BEQ ZeroEvent06ZeroMaohGiant0CIncreaseEvent
		JML !EventLoop
		
ZeroEvent06ZeroMaohGiant0CIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		RTL

	;***************************
	; Sub-event #0E: End event
	;***************************
ZeroEvent06ZeroMaohGiant0E:
		STZ $00
		INC $1F36 ;Initiate X teleport out
		RTL

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #08: Zero power cell damaged [THIS WHOLE EVENT IS UNUSED! Must NOP out the entire old event of it]
;***************************
ZeroEvent08ZeroPowerCellDamagedBase:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent08ZeroPowerCellDamagedEvents,x)

ZeroEvent08ZeroPowerCellDamagedEvents:
	dw ZeroEvent08ZeroPowerCellDamaged00
	dw $FF
	
	;***************************
	; Sub-event #0E: End event
	;***************************
ZeroEvent08ZeroPowerCellDamaged00:
	RTL
	
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #0A: Dr. Cain pinpoints Dr. Doppler's lab
;***************************
ZeroEvent0ADrCainFindLabBase:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent0ADrCainFindLabEvents,x)

ZeroEvent0ADrCainFindLabEvents:
	dw ZeroEvent0ADrCainFindLab00
	dw ZeroEvent0ADrCainFindLab02
	dw ZeroEvent0ADrCainFindLab04
	dw ZeroEvent0ADrCainFindLab06
	dw ZeroEvent06ZeroMaohGiant06
	dw ZeroEvent0ADrCainFindLab06
	dw ZeroEvent06ZeroMaohGiant06
	dw ZeroEvent0ADrCainFindLab06
	dw ZeroEvent06ZeroMaohGiant06
	dw ZeroEvent0ADrCainFindLab06
	dw ZeroEvent06ZeroMaohGiant06
	dw ZeroEvent0ADrCainFindLab16
	dw ZeroEvent06ZeroMaohGiant0A
	dw ZeroEvent06ZeroMaohGiant0C
	dw ZeroEvent0ADrCainFindLab1C
	dw $FF
	
	;***************************
	; Sub-event #00: Set Zero sprites and begin teleport settings
	;***************************
ZeroEvent0ADrCainFindLab00:
		LDA !ZSaberObtained_1FB2
		BIT #$40
		BEQ ZeroEvent0ADrCainFindLab00SkipZSaber
		LDA #$1C
		STA !PCNPC_EventID_02
		JML !EventLoop
		
ZeroEvent0ADrCainFindLab00SkipZSaber:
		LDA !CurrentPCAction_09DA
		CMP #$22
		BEQ ZeroEvent0ADrCainFindLab00SkipRTL
		RTL
ZeroEvent0ADrCainFindLab00SkipRTL:
		REP #$20
		LDA !PCXCoordinate_09DD
		CLC
		ADC #$FFE0
		STA !PCNPC_XCoordinate_05
		LDA !PCYCoordinate_09E0
		STA !PCNPC_YCoordinate_08
		JMP UniversalTeleportInSettings

	;***************************
	; Sub-event #02: Zero begin teleport in
	;***************************
ZeroEvent0ADrCainFindLab02:
		JSL !CheckForLanding
		
		REP #$20
		LDA !ScreenYCoordinate_1E60
		CLC
		ADC #$0080
		CMP !PCNPC_YCoordinate_08
		BPL ZeroEvent0ADrCainFindLab02Animate
		
		SEP #$20
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BEQ ZeroEvent0ADrCainFindLab02Animate
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$7E
		JML !VRAMRoutineConsistent
ZeroEvent0ADrCainFindLab02Animate:
		JML !AnimationConsistent

	;***************************
	; Sub-event #04 ;Set PC frame for landing and for dialogue
	;***************************
ZeroEvent0ADrCainFindLab04:
		LDA #$40
		TSB !PCNPC_PaletteDirection_11
		LDA !PCNPC_IsAnimating_0F
		BMI ZeroEvent0ADrCainFindLab04IncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent0ADrCainFindLab04IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$50 ;Load PC NPC frame for when done talking
		STA !PCNPC_AnimationFrameDoneTalk_43
		LDA #$3C
		STA !PCNPC_DelayTimer_3C
		LDA #$50 ;Load PC NPC frame for idle
		JML !VRAMRoutineConsistent

	;***************************
	; Sub-event #06: Set common event for event lock and Zero NPC speaking
	;***************************
ZeroEvent0ADrCainFindLab06:
		LDA !EnableEventLock_1F3F
		BMI ZeroEvent0ADrCainFindLab06IncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent0ADrCainFindLab06IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$87 ;Set frame start for talking
		JML !VRAMRoutineConsistent



	;***************************
	; Sub-event #08: Initate common event for dialogue and animation updating
	; [Different location than the other pieces]
	;***************************
;ZeroEvent0ADrCainFindLab08:
		;JMP ZeroEvent06ZeroMaohGiant06
		
		
	;***************************
	; Sub-event #0A: Set common event for event lock and Zero NPC speaking
	;***************************
;ZeroEvent0ADrCainFindLab0A:
		;JMP ZeroEvent0ADrCainFindLab06
		
	;***************************
	; Sub-event #0C: Initate common event for dialogue and animation updating
	; [Different location than the other pieces]
	;***************************
;ZeroEvent0ADrCainFindLab0c:
		;JMP ZeroEvent06ZeroMaohGiant06
		
	;***************************
	; Sub-event #0E: Set common event for event lock and Zero NPC speaking
	;***************************
;ZeroEvent0ADrCainFindLab0e:
		;JMP ZeroEvent0ADrCainFindLab06
		
	;***************************
	; Sub-event #10: Initate common event for dialogue and animation updating
	; [Different location than the other pieces]
	;***************************
;ZeroEvent0ADrCainFindLab10:
		;JMP ZeroEvent06ZeroMaohGiant06
		
	;***************************
	; Sub-event #12: Set common event for event lock and Zero NPC speaking
	;***************************
;ZeroEvent0ADrCainFindLab12:
		;JMP ZeroEvent0ADrCainFindLab06
		
	;***************************
	; Sub-event #14: Initate common event for dialogue and animation updating
	; [Different location than the other pieces]
	;***************************
;ZeroEvent0ADrCainFindLab14:
		;JMP ZeroEvent06ZeroMaohGiant06
	
	;***************************
	; Sub-event 16: Set Zero to begin teleport
	;***************************
ZeroEvent0ADrCainFindLab16:
		LDA !CurrentPCAction_09DA
		CMP #$34
		BEQ ZeroEvent0ADrCainFindLab16IncreaseEvent
		JSL !VRAMRoutineAlt
		JML !EventLoop
		
ZeroEvent0ADrCainFindLab16IncreaseEvent:
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
;ZeroEvent0ADrCainFindLab18:
		;JMP ZeroEvent06ZeroMaohGiant0A

	
	;***************************
	; Sub-event #1A: Common event for NPC teleport out
	; 
	;***************************
;ZeroEvent0ADrCainFindLab1A:
		;JMP ZeroEvent06ZeroMaohGiant0C
	
	
	;***************************
	; Sub-event 1C: End Event
	;***************************
ZeroEvent0ADrCainFindLab1C:
		STZ !PCNPC_Active_00
		RTL
		
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #0C: REX-2000
;***************************
ZeroEvent0CREX2000Base:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent0CREX2000Events,x)

ZeroEvent0CREX2000Events:
	dw ZeroEvent0CREX2000_00
	dw ZeroEvent0ADrCainFindLab02
	dw ZeroEvent0CREX2000_04
	dw ZeroEvent06ZeroMaohGiant06
	dw ZeroEvent0CREX2000_08
	dw ZeroEvent0CREX2000_0A
	dw ZeroEvent0CREX2000_0C
	dw ZeroEvent0CREX2000_0E
	dw ZeroEvent06ZeroMaohGiant06
	dw ZeroEvent0CREX2000_12
	dw ZeroEvent06ZeroMaohGiant0A
	dw ZeroEvent06ZeroMaohGiant0C
	dw ZeroEvent0CREX2000_18
	dw $FF
	
	;***************************
	; Sub-event #00: Set Zero sprites then load teleport in common event
	;***************************
ZeroEvent0CREX2000_00:
		INC !DisableEnemyAI_1F27
		INC !DisableLRSubWeaponScroll_1F45
		INC !DisableMenuOpening_1F4F
		LDA #$04
		STA !PCHealthBar_1F22
		STA !PCSubWeaponAmmoBar_1F23
		
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
	; Sub-event #02: Load common event for Zero teleport in
	;***************************
;ZeroEvent0CREX2000_02:	
		;JMP ZeroEvent0ADrCainFindLab02
		
		
	;***************************
	; Sub-event #04: Set dialogue
	;***************************
ZeroEvent0CREX2000_04:
		LDA #$40
		TRB !PCNPC_PaletteDirection_11
		LDA !PCNPC_IsAnimating_0F
		BMI ZeroEvent0CREX2000_04IncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent0CREX2000_04IncreaseEvent:
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
;ZeroEvent0CREX2000_06:
;		JMP ZeroEvent06ZeroMaohGiant06


	;***************************
	; Sub-event #08 ;Set Zero walking speed
	;***************************
ZeroEvent0CREX2000_08:
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
	; Sub-event #0A: Zero Walking off screen
	;***************************
ZeroEvent0CREX2000_0A:
		JSL !MoveObjectRight
		
		LDA !PCNPC_Animate_0E
		BEQ ZeroEvent0CREX2000_0AIncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent0CREX2000_0AIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		JSL !ReloadSubWeapGreaphics ;Set X's palette by checking for sub-weapon. Also sets proper VRAM graphics for sub-weapon
		
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
		RTL


	;***************************
	; Sub-event #0C: Event to continue checking for ceiling to stop falling or enemy death
	;***************************
ZeroEvent0CREX2000_0C:
		REP #$30
		LDA !PCNPC_DelayTimer_3C
		BEQ ZeroEvent0CREX2000_0CCheckEnemy
		
		DEC !PCNPC_DelayTimer_3C
		BNE ZeroEvent0CREX2000_0CCheckEnemy
		
		SEP #$20
		LDA #$02
		STA $1F5F ;Something to do with event bit flags
		
ZeroEvent0CREX2000_0CCheckEnemy:
		SEP #$20
		LDX !PCNPC_TempStorage_0C
		LDA $0000,x
		BNE ZeroEvent0CREX2000_0CEndRoutine
		
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

ZeroEvent0CREX2000_0CEndRoutine:
		RTL

	;***************************
	; Sub-event #0E: Set X to walk
	;***************************
ZeroEvent0CREX2000_0E:
		LDA !CurrentPCAction_09DA
		CMP #$66 ;Check if 'walking'
		BEQ ZeroEvent0CREX2000_0ECheckPCAction
		
		REP #$20
		LDA !PCNPC_XCoordinate_05
		CLC
		ADC #$FFD0
		JSL $84D24B ;Something with PCNPC_ coordinates

ZeroEvent0CREX2000_0ECheckPCAction:
		SEP #$20
		LDA #$04
		STA !PCHealthBar_1F22
		STA !PCSubWeaponAmmoBar_1F23
		INC !DisableMenuOpening_1F4F
		INC !DisableLRSubWeaponScroll_1F45
		
		LDA !CurrentPCSubAction_09DB
		CMP #$08
		BEQ ZeroEvent0CREX2000_0EIncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent0CREX2000_0EIncreaseEvent:
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
;ZeroEvent0CREX2000_10:
		;JMP ZeroEvent06ZeroMaohGiant06
		
		
	;***************************
	; Sub-event #12: Set Zero teleport out
	;***************************
ZeroEvent0CREX2000_12:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
;		JSL ZeroSetup ;Not needed
		
		LDA #$11
		JSL !PlaySFX
		
		LDA #$7F
		JML !VRAMRoutineConsistent

		
	;***************************
	; Sub-event #14: Common event for NPC begin teleport out
	;***************************
;ZeroEvent0CREX2000_14:
;		JMP ZeroEvent06ZeroMaohGiant0A


	;***************************
	; Sub-event #16: Common event for NPC teleport out
	;***************************
;ZeroEvent0CREX2000_16:
;		JMP ZeroEvent06ZeroMaohGiant0C


	;***************************
	; Sub-event #18: End event
	;***************************
ZeroEvent0CREX2000_18:
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
ZeroEvent0EMosquitusBase:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent0EMosquitusEvents,x)

ZeroEvent0EMosquitusEvents:
	dw ZeroEvent0EMosquitus00
	dw ZeroEvent0EMosquitus02
	dw ZeroEvent0EMosquitus04
	dw ZeroEvent0EMosquitus06
	dw ZeroEvent06ZeroMaohGiant06
	dw ZeroEvent0EMosquitus0A
	dw ZeroEvent06ZeroMaohGiant0A
	dw ZeroEvent06ZeroMaohGiant0C
	dw ZeroEvent0EMosquitus10
	dw $FF
	
	;***************************
	; Sub-event #00: Set X NPC sprites and facing
	;***************************
ZeroEvent0EMosquitus00:
		STZ !PCVisibility_09E6
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
		JSL XZSaberSetup
		LDA #$04
		STA !PCNPC_SpritePriority_12
		
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
		BMI ZeroEvent0EMosquitus00SetDirection
		LDA #$40
		TSB !PCNPC_PaletteDirection_11
		BRA ZeroEvent0EMosquitus00SkipDirection
		
ZeroEvent0EMosquitus00SetDirection:
		LDA #$40
		TRB !PCNPC_PaletteDirection_11
		
ZeroEvent0EMosquitus00SkipDirection:
		JSL !ClearPCCharge
		
		STZ $0A2F ;Clears current charge time
		STZ !CurrentPCSubWeapon_0A0B
		INC !DisablePCCharging_0A54
		
		LDA #$0D
		JSL !PlaySFX
		
		LDA #$1C
		JML !VRAMRoutineConsistent

	;***************************
	; Sub-event #02: Set X damaged kneel
	;***************************
ZeroEvent0EMosquitus02:
		LDA !PCNPC_IsAnimating_0F
		BMI ZeroEvent0EMosquitus02IncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent0EMosquitus02IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		JML !AnimationConsistent

	;***************************
	; Sub-event #04: Set X direction and set PC back to X
	;***************************
ZeroEvent0EMosquitus04:
		REP #$10
		LDX !PCNPC_JumpHeight_1E ;Used as Temp. Storage
		LDA $0034,x
		BPL ZeroEvent0EMosquitus04Animate
		
		SEP #$10
		DEC !PCNPC_DelayTimer_3C
		BEQ ZeroEvent0EMosquitus04IncreaseEvent
ZeroEvent0EMosquitus04Animate:
		JML !AnimationConsistent
		
ZeroEvent0EMosquitus04IncreaseEvent:
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
		BMI ZeroEvent0EMosquitus04SetDirection
		LDA #$0030
		BRA ZeroEvent0EMosquitus04SkipDirection
ZeroEvent0EMosquitus04SetDirection:
		LDA #$FFD0
ZeroEvent0EMosquitus04SkipDirection:
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
		LDA #$02
		STA !CurrentPC_0A8E
		STA !CurrentPCCheck_1FFF
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
ZeroEvent0EMosquitus06:
		LDA !PCYCoordinate_09E0
		CMP #$60
		BMI ZeroEvent0EMosquitus06EndRoutine
		STZ !DisableScreenScroll_1F2B
		
		LDA !CurrentPCAction_09DA
		BNE ZeroEvent0EMosquitus06EndRoutine
		
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

ZeroEvent0EMosquitus06EndRoutine:
		JML !EventLoop

	;***************************
	; Sub-event #08: Initate common event for dialogue and animation updating
	;***************************
;	ZeroEvent0EMosquitus08:
;		JMP ZeroEvent06ZeroMaohGiant06


	;***************************
	; Sub-event #0A: Set Zero teleport out
	;***************************
	ZeroEvent0EMosquitus0A:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		JSL ZeroSetup
		
		LDA #$11
		JSL !PlaySFX
		
		LDA #$7F
		JML !VRAMRoutineConsistent

	;***************************
	; Sub-event #0C: Common event for NPC begin teleport out
	;***************************
;	ZeroEvent0EMosquitus0C:
;		JMP ZeroEvent06ZeroMaohGiant0A
	

	;***************************
	; Sub-event #0E: Common event for NPC teleport out
	;***************************
;	ZeroEvent0EMosquitus0E:
;		JMP ZeroEvent06ZeroMaohGiant0C


	;***************************
	; Sub-event #10: Sets PC's data and ends event
	;***************************
	ZeroEvent0EMosquitus10:
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
; Event #10: Z-Saber Sigma Wall
;***************************
ZeroEvent10ZSaberWallBase:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent10ZSaberWallEvents,x)

ZeroEvent10ZSaberWallEvents:
	dw ZeroEvent10ZSaberWall00
	dw ZeroEvent10ZSaberWall02
	dw ZeroEvent10ZSaberWall04
	dw ZeroEvent06ZeroMaohGiant06
	dw ZeroEvent10ZSaberWall08
	dw ZeroEvent10ZSaberWall02
	dw ZeroEvent10ZSaberWall0C
	dw ZeroEvent10ZSaberWall0E
	dw ZeroEvent10ZSaberWall10
	dw ZeroEvent10ZSaberWall12
	dw ZeroEvent10ZSaberWall14
	dw $FF
	
	;***************************
	; Sub-event #00: Set walking, end walking, load Zero sprites then go to next event
	;***************************
	ZeroEvent10ZSaberWall00:
		LDA #$04
		STA !PCHealthBar_1F22
		STA !PCSubWeaponAmmoBar_1F23
		LDA !CurrentPCAction_09DA
		CMP #$66
		BNE ZeroEvent10ZSaberWall00RTL
		
		LDA !CurrentPCSubAction_09DB
		CMP #$08
		BEQ ZeroEvent10ZSaberWall00IncreaseEvent
ZeroEvent10ZSaberWall00RTL:
		RTL
		
ZeroEvent10ZSaberWall00IncreaseEvent:
		LDA #$2C
		STA !PCNPC_PaletteDirection_11
		JSL ZeroSetup
		
		LDA !RideChipsOrigin_7E1FD7
		AND #$F0
		CMP #$F0
		BEQ ZeroEvent10ZSaberWall00_LoadZeroPurpleSaber
		REP #$10
		LDX #$0070 ;Load RAM palette for Z-Saber
		LDY #$00D2 ;Load palette for Z-Saber
		BRA ZeroEvent10ZSaberWall00_LoadZeroBusterPaletteEnd
		
		ZeroEvent10ZSaberWall00_LoadZeroPurpleSaber:
		REP #$10
		LDX #$0070 ;Load RAM palette for Z-Saber
		LDY #$0206 ;Load palette for Z-Saber
		
		ZeroEvent10ZSaberWall00_LoadZeroBusterPaletteEnd:
		JSL !Palette
		
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
		ADC #$0097
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
	; Sub-event #02: Set Zero on ground/walking
	;***************************
	ZeroEvent10ZSaberWall02:
		REP #$20
		LDA !PCNPC_TempStorage_0C
		CMP !PCNPC_XCoordinate_05
		BPL ZeroEvent10ZSaberWall02SkipIncrease
			
		STA !PCNPC_XCoordinate_05
		SEP #$20
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$50
		JML !VRAMRoutineConsistent
		
ZeroEvent10ZSaberWall02SkipIncrease:
		SEP #$20
		JSL !CheckForLanding
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BEQ ZeroEvent10ZSaberWall02SkipAnimate
		JML !AnimationConsistent
		
ZeroEvent10ZSaberWall02SkipAnimate:
		LDA !PCNPC_EventID_02
		STA !PCNPC_SubEvent_03
		LDA #$14
		STA !PCNPC_EventID_02
		LDA #$51
		JML !VRAMRoutineConsistent
			
	;***************************
	; Sub-event #04: Set text to use
	;***************************
	ZeroEvent10ZSaberWall04:
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
	; Sub-event #06: Initate common event for dialogue and animation updating
	;***************************
;	ZeroEvent10ZSaberWall06:
;		JMP ZeroEvent06ZeroMaohGiant06


	;***************************
	; Sub-event #08: Set PC NPC walk to wall
	;***************************
	ZeroEvent10ZSaberWall08:
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
	; Sub-event #0A: Set X on ground/walking
	;***************************
;	ZeroEvent10ZSaberWall0A:
;		JMP ZeroEvent10ZSaberWall02

	;***************************
	; Sub-event #0C: Set Z-Saber Zero sprites
	;***************************
	ZeroEvent10ZSaberWall0C:
		DEC !PCNPC_DelayTimer_3C
		BNE ZeroEvent10ZSaberWall0CAnimate
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		JSL ZeroZSaberSetup
		LDA #$00
		JML !VRAMRoutineConsistent
		
ZeroEvent10ZSaberWall0CAnimate:
		JML !AnimationConsistent
	
	
	;***************************
	; Sub-event #0E: Load Z-Saber/wall explosion
	;***************************
	ZeroEvent10ZSaberWall0E:
		LDA !PCNPC_IsAnimating_0F
		CMP #$06
		BNE ZeroEvent10ZSaberWall0ECheckAnimate
		JSL $83B508 ;Sets wall explosion & tile map update
		BRA ZeroEvent10ZSaberWall0ESkipZSaber
			
ZeroEvent10ZSaberWall0ECheckAnimate:
		LDA !PCNPC_IsAnimating_0F
		BMI ZeroEvent10ZSaberWall0EIncreaseEvent
		BIT !PCNPC_IsAnimating_0F
		BVC ZeroEvent10ZSaberWall0ESkipZSaber
			
		JSL ZSaberZeroSetup
		LDA #$06
		STA $0018,x
		LDA #$6E
		STA $0011,x
			
ZeroEvent10ZSaberWall0ESkipZSaber:
		SEP #$30
		JML !AnimationConsistent
		
ZeroEvent10ZSaberWall0EIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		JSL ZeroSetup
		
		REP #$20
		LDA #$0375
		STA !PCNPC_SpeedDistance_1A
		SEP #$20
		LDA #$0A
		JSL !PlaySFX
		
		LDA #$66
		JML !VRAMRoutineConsistent
			
	
	;***************************
	; Sub-event #10: Check for PC NPC active when dashing off screen
	;***************************
	ZeroEvent10ZSaberWall10:
		JSL !MoveObjectRight
		
		LDA !PCNPC_Animate_0E
		BEQ ZeroEvent10ZSaberWall10IncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent10ZSaberWall10IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		RTL
	
	;***************************
	; Sub-event #12: Reenable weapon switching, menu opening and set weapon palette/VRAM
	;***************************
	ZeroEvent10ZSaberWall12:
		DEC !DisableLRSubWeaponScroll_1F45
		DEC !DisableMenuOpening_1F4F
		STZ !PCHealthBar_1F22
		STZ !PCSubWeaponAmmoBar_1F23
		JSL !ReloadSubWeapGreaphics ;Set X's weapon palette and VRAM
		JSL $84D169
		
		STZ !PCNPC_Active_00
		LDA #$01
		TSB $1FE0 ;Bit flag for event being done
		REP #$20
		SEP #$20
		RTL
	
	;***************************
	; Sub-event #14: Check for PC landing on solid ground
	;***************************
	ZeroEvent10ZSaberWall14:
		JSL FallingVelocity
		JSL !CheckForGround
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BNE ZeroEvent10ZSaberWall14SetEvent
		JML !AnimationConsistent
		
ZeroEvent10ZSaberWall14SetEvent:
		LDA #$04
		STA !PCNPC_EventID_02
		
		REP #$20
		LDA #$0178
		STA !PCNPC_SpeedDistance_1A
		STZ !PCNPC_Velocity_1C
		
		SEP #$20
		LDA #$5C
		JML !VRAMRoutineConsistent
	
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #12: Sigma Virus
;***************************
ZeroEvent12SigmaVirusBase:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent12SigmaVirusEvents,x)

ZeroEvent12SigmaVirusEvents:
	dw ZeroEvent12SigmaVirus00
	dw ZeroEvent12SigmaVirus02
	dw ZeroEvent12SigmaVirus04
	dw ZeroEvent12SigmaVirus06
	dw ZeroEvent12SigmaVirus08
	dw ZeroEvent12SigmaVirus0A
	dw ZeroEvent06ZeroMaohGiant06
	dw ZeroEvent12SigmaVirus0E
	dw ZeroEvent12SigmaVirus10
	dw ZeroEvent12SigmaVirus12
	dw ZeroEvent06ZeroMaohGiant0A
	dw ZeroEvent12SigmaVirus16
	dw ZeroEvent12SigmaVirus18
	
	dw ZeroEvent12SigmaVirusDoppler00 ;Initiate Dr. Doppler variation
	dw ZeroEvent12SigmaVirusDoppler02
	dw ZeroEvent12SigmaVirusDoppler04
	dw ZeroEvent12SigmaVirusDoppler06
	dw ZeroEvent12SigmaVirusDoppler08
	dw ZeroEvent12SigmaVirusDoppler0A
	dw ZeroEvent12SigmaVirusDoppler0C
	dw ZeroEvent12SigmaVirusDoppler0E
	dw ZeroEvent12SigmaVirusDoppler10
	dw ZeroEvent12SigmaVirusDoppler12
	dw $FF
	
	;***************************
	; Sub-event #00: Set music
	;***************************
	ZeroEvent12SigmaVirus00:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		STZ !PCNPC_SubEvent_03
		
		LDA #$3C
		STA !PCNPC_DelayTimer_3C
		LDA #$30
		TSB !PCDirection_0A41
		
		LDA !ZSaberObtained_1FB2
		BIT #$40
		BNE ZeroEvent12SigmaVirus00LoadDopplerMusic
		LDA #$31 ;Load Zero's theme
		BRA ZeroEvent12SigmaVirus00SkipDopplerMusic
ZeroEvent12SigmaVirus00LoadDopplerMusic:
		LDA #$22 ;Load Doppler's theme
		
ZeroEvent12SigmaVirus00SkipDopplerMusic:
		JML !PlayMusic
	
	;***************************
	; Sub-event #02: Load ceiling explosions
	;***************************
	ZeroEvent12SigmaVirus02:
		DEC !PCNPC_DelayTimer_3C
		BEQ ZeroEvent12SigmaVirus02IncreaseEvent
		RTL
		
ZeroEvent12SigmaVirus02IncreaseEvent:
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
ZeroEvent12SigmaVirus02Explosions:
		STZ $0000
		LDA #$FFF0
		STA $0002
		LDA #$001F
		STA $0004
		LDA #$003F
		STA $0006
		STZ $0008
		LDY #$10
ZeroEvent12SigmaVirus02ExplosionLoop:
		JSL $84D6FB
		DEY
		BNE ZeroEvent12SigmaVirus02ExplosionLoop
		RTL
	
	;***************************
	; Sub-event #04: Load Zero or Dr. Doppler falling from ceiling
	;***************************
	ZeroEvent12SigmaVirus04:
		REP #$20
		JSL ZeroEvent12SigmaVirus02Explosions ;MIGHT just have to copy/paste the code
		
		SEP #$20
		LDA !ZSaberObtained_1FB2
		BIT #$40
		BNE ZeroEvent12SigmaVirus04DopplerLoading
		
		LDA #$2C
		STA !PCNPC_PaletteDirection_11
		JSL ZeroSetup
		
		LDA !RideChipsOrigin_7E1FD7
		AND #$F0
		CMP #$F0
		BEQ ZeroEvent12SigmaVirus04_LoadZeroPurpleSaber
		REP #$10
		LDX #$0070 ;Load RAM palette for Z-Saber
		LDY #$00D2 ;Load palette for Z-Saber
		BRA ZeroEvent12SigmaVirus04_LoadZeroBusterPaletteEnd
		
		ZeroEvent12SigmaVirus04_LoadZeroPurpleSaber:
		REP #$10
		LDX #$0070 ;Load RAM palette for Z-Saber
		LDY #$0206 ;Load palette for Z-Saber
		
		ZeroEvent12SigmaVirus04_LoadZeroBusterPaletteEnd:
		JSL !Palette
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$40
		TSB !PCNPC_PaletteDirection_11
		LDA #$57
		JML !VRAMRoutineConsistent
		
ZeroEvent12SigmaVirus04DopplerLoading:
		LDA #$1A
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
	ZeroEvent12SigmaVirus06:
		JSL FallingVelocity
		JSL !CheckForGround
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BNE ZeroEvent12SigmaVirus06IncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent12SigmaVirus06IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		JSL ZeroZSaberSetup
		
		LDA #$00
		JML !VRAMRoutineConsistent
		
	
	;***************************
	; Sub-event #08: Load Z-saber
	;***************************
	ZeroEvent12SigmaVirus08:
		LDA !PCNPC_IsAnimating_0F
		CMP #$06
		BNE ZeroEvent12SigmaVirus08CheckAnimate
		LDA #$02
		TRB $1F53 ;Set flag to trigger screen explosions
		BRA ZeroEvent12SigmaVirus08SkipZSaber
			
ZeroEvent12SigmaVirus08CheckAnimate:
		LDA !PCNPC_IsAnimating_0F
		BMI ZeroEvent12SigmaVirus08IncreaseEvent
		BIT !PCNPC_IsAnimating_0F
		BVC ZeroEvent12SigmaVirus08SkipZSaber
			
		JSL ZSaberZeroSetup
		
		LDA #$46
		JSL !PlaySFX
			
ZeroEvent12SigmaVirus08SkipZSaber:
		SEP #$30
		JML !AnimationConsistent
		
ZeroEvent12SigmaVirus08IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		JSL ZeroSetup
		
		REP #$20
		LDA #$FE88
		STA !PCNPC_SpeedDistance_1A
		LDA #$0553
		STA !PCNPC_Velocity_1C
		SEP #$20
		LDA #$51
		JML !VRAMRoutineConsistent
	
	;***************************
	; Sub-event #0A ;Check for PC NPC landing and then trigger dialogue
	;***************************
	ZeroEvent12SigmaVirus0A:
		JSL !CheckForGround
		JSL FallingVelocity
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BNE ZeroEvent12SigmaVirus0AIncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent12SigmaVirus0AIncreaseEvent:
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
	; Sub-event #0C ;Initate common event for dialogue and animation updating
	; [Different location than the other pieces]
	;***************************
;	ZeroEvent12SigmaVirus0A:
;		JMP ZeroEvent06ZeroMaohGiant06

	;***************************
	; Sub-event #0E ;Set PC NPC triggers and data for walking speed
	;***************************
	ZeroEvent12SigmaVirus0E:
		LDA $1F53 ;Check flag for event triggers
		BIT #$01
		BEQ ZeroEvent12SigmaVirus0ESkipIncrease
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$1E
		STA !PCNPC_DelayTimer_3C
		REP #$20
		LDA #$0178
		STA !PCNPC_SpeedDistance_1A
		SEP #$20
		
ZeroEvent12SigmaVirus0ESkipIncrease:
		JML !AnimationConsistent
	
	;***************************
	; Sub-event #10 ;Set PC NPC walk animation
	;***************************
	ZeroEvent12SigmaVirus10:
		DEC !PCNPC_DelayTimer_3C
		BEQ ZeroEvent12SigmaVirus10IncreaseEvent
		JML !AnimationConsistent
		
ZeroEvent12SigmaVirus10IncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$1E
		STA !PCNPC_DelayTimer_3C
		LDA #$5C
		JML !VRAMRoutineConsistent
	
	
	;***************************
	; Sub-event #12 ;PC NPC walking
	;***************************
	ZeroEvent12SigmaVirus12:
		LDA #$40
		TRB !PCDirection_0A41
		TRB !PCPaletteDirection_09E9
		
		LDA !PCNPC_DelayTimer_3C
		BEQ ZeroEvent12SigmaVirus12MoveNPC
		DEC !PCNPC_DelayTimer_3C
		BNE ZeroEvent12SigmaVirus12MoveNPC
		
		REP #$20
		LDA #$0A70
		JSL $84D24B ;Sets PC NPC coordinates for max walking distance?
		
ZeroEvent12SigmaVirus12MoveNPC:
		REP #$20
		JSL !MoveObjectRight
		
		LDA #$0A70
		CMP !PCNPC_XCoordinate_05
		BMI ZeroEvent12SigmaVirus12IgnoreAnimate
		JML !AnimationConsistent
		
ZeroEvent12SigmaVirus12IgnoreAnimate:
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
	; Sub-event #14: Common event for NPC begin teleport out
	;***************************
;		ZeroEvent12SigmaVirus14:
;			JMP ZeroEvent06ZeroMaohGiant0A

	;***************************
	; Sub-event #16: Set PC and PC NPC teleport out
	;***************************
	ZeroEvent12SigmaVirus16:
		JSL $83B74D ;Check of PC done walking?
		JMP ZeroEvent06ZeroMaohGiant0C
		
	;***************************
	; Sub-event #18: PC teleport out
	;***************************
	ZeroEvent12SigmaVirus18:
		JSL $83B74D ;Check of PC done walking?
		JML $83B867 ;Sets data for Z-Saber slices to appear around Sigma Virus 
		
		LDA #$40
		TRB !PCDirection_0A41
		TRB !PCPaletteDirection_09E9
		
		LDA !CurrentPCAction_09DA
		CMP #$66
		BNE ZeroEvent12SigmaVirus18EndRoutine
		
		LDA !CurrentPCSubAction_09DB
		CMP #$08
		BNE ZeroEvent12SigmaVirus18EndRoutine
		
		LDA #$20
		TSB $1F5F ;Set event trigger
		
ZeroEvent12SigmaVirus18EndRoutine:
		RTS

;***************************		
;DR. DOPPLER EVENTS ONLY
;***************************
	;***************************
	; Sub-event #1A: Dr. Doppler falling & landing
	;***************************
	ZeroEvent12SigmaVirusDoppler00:
		JSL FallingVelocity
		JSL !CheckForGround
		JSL !LandOnGround
		
		LDA !PCNPC_OnGround_2B
		AND #$04
		BEQ ZeroEvent12SigmaVirusDoppler00EndRoutine
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
ZeroEvent12SigmaVirusDoppler00EndRoutine:
		JML !EventLoop
	
	
	;***************************
	; Sub-event #1C: Set Doppler velocity and jump distance
	;***************************
	ZeroEvent12SigmaVirusDoppler02:
		LDA !PCNPC_IsAnimating_0F
		BPL ZeroEvent12SigmaVirusDoppler02Animate
		
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
		
ZeroEvent12SigmaVirusDoppler02Animate:
		JSL !VRAMRoutineAlt
		JML !EventLoop
	
	;***************************
	; Sub-event #1E: Dr. Doppler begin jump
	;***************************
	ZeroEvent12SigmaVirusDoppler04:
		LDA !PCNPC_IsAnimating_0F
		BPL ZeroEvent12SigmaVirusDoppler04Animate
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
ZeroEvent12SigmaVirusDoppler04Animate:
		JSL !VRAMRoutineAlt
		JML !EventLoop
	
	;***************************
	; Sub-event #20: Dr. Doppler jump & touch Sigma
	;***************************
	ZeroEvent12SigmaVirusDoppler06:
		JSL !CheckForGround
		REP #$10
		LDX !PCNPC_TempStorage_0C
		JSL $84CC5C ;Check for enemy to touch another object then drag it with
		SEP #$30
		BCC ZeroEvent12SigmaVirusDoppler06EventLoop
		
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
		
ZeroEvent12SigmaVirusDoppler06EventLoop:
		JML !EventLoop
		
	;***************************
	; Sub-event #22: Doppler falling with Sigma with him
	;***************************
	ZeroEvent12SigmaVirusDoppler08:
		JSL !CheckForGround
		JSL !LandOnGround
		LDA !PCNPC_OnGround_2B
		BIT #$04
		BEQ ZeroEvent12SigmaVirusDoppler08EndRoutine
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
ZeroEvent12SigmaVirusDoppler08EndRoutine:
		JML !EventLoop
		
		
	;***************************
	; Sub-event #24 ;Doppler land & initiate dialogue
	;***************************
	ZeroEvent12SigmaVirusDoppler0A:
		LDA !PCNPC_IsAnimating_0F
		BPL ZeroEvent12SigmaVirusDoppler0AAnimate
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$01
		JSL !DialogueBoxSmall
		
		LDA #$01
		TRB $1F53 ;Set bit flag for event
		
ZeroEvent12SigmaVirusDoppler0AAnimate:
		JSL !VRAMRoutineAlt
		JML !EventLoop
		
	;***************************
	; Sub-event #26: Set animation for Doppler talking
	;***************************		
	ZeroEvent12SigmaVirusDoppler0C:
		LDA !EnableEventLock_1F3F
		BPL ZeroEvent12SigmaVirusDoppler0CIncreaseEvent
		LDA $1F51
		BNE ZeroEvent12SigmaVirusDoppler0CAnimating
		
		LDA $1F50
		CMP #$03
		BEQ ZeroEvent12SigmaVirusDoppler0CAnimate
		
ZeroEvent12SigmaVirusDoppler0CAnimating:
		LDA !PCNPC_IsAnimating_0F
		BEQ ZeroEvent12SigmaVirusDoppler0CEventLoop
		
ZeroEvent12SigmaVirusDoppler0CAnimate:
		JSL !VRAMRoutineAlt

ZeroEvent12SigmaVirusDoppler0CEventLoop:
		JML !EventLoop
		
ZeroEvent12SigmaVirusDoppler0CIncreaseEvent:
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		JML !EventLoop
		
	;***************************
	; Sub-event #28: Initiate final sequence of event
	;***************************		
	ZeroEvent12SigmaVirusDoppler0E:
		LDA $1F53 ;Check for event bit flag
		BIT #$01
		BNE ZeroEvent12SigmaVirusDoppler0EEventLoop
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		LDA #$F0
		STA !PCNPC_DelayTimer_3C
		
ZeroEvent12SigmaVirusDoppler0EEventLoop:
		JML !EventLoop
	
	;***************************
	; Sub-event #2A: Timer & PC teleport out
	;***************************		
	ZeroEvent12SigmaVirusDoppler10:
		DEC !PCNPC_DelayTimer_3C
		BNE ZeroEvent12SigmaVirusDoppler10EventLoop
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$20
		TSB $1F5F ;Set event bit flag
		JSL $84D2D6 ;Load PC teleport out
		
ZeroEvent12SigmaVirusDoppler10EventLoop:
		JML !EventLoop
	
	;***************************
	; Sub-event #2C ;Set Z-Saber slash around Sigma Virus
	;***************************		
	ZeroEvent12SigmaVirusDoppler12:
		JML $83B863 ;JML to final doppler events NPC data
		
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #14: Cliff
;***************************
ZeroEvent14CliffSceneBase:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent14CliffSceneEvents,x)

ZeroEvent14CliffSceneEvents:
	dw ZeroEvent14CliffScene00
	dw ZeroEvent14CliffScene02
	dw $FF
	
	
	;***************************
	; Sub-event #00 ;Set Zero on cliff
	;***************************		
	ZeroEvent14CliffScene00:
		STZ $00DF
		LDA !ZSaberObtained_1FB2
		BIT #$40
		BEQ ZeroEvent14CliffScene00IncreaseEvent
		RTL
		
ZeroEvent14CliffScene00IncreaseEvent:
		LDA #$26
		STA !PCNPC_PaletteDirection_11
		JSL ZeroSetup
		LDA !PCNPC_PaletteDirection_11
		SEC
		SBC #$40
		STA !PCNPC_PaletteDirection_11
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$50
		JSL !AnimationOneFrame

	;***************************
	; Sub-event #02 ;Animate Zero Idle
	;***************************
	ZeroEvent14CliffScene02:
		LDA $1F38
		BNE ZeroEvent14CliffScene02EventLoop
		
		JSL !VRAMRoutineAlt
		JSL NewVRAMRoutine
		
ZeroEvent14CliffScene02EventLoop:
		JML !EventLoop
		
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
;***************************
; Event #16: Credit Roll
;***************************
ZeroEvent16CreditsBase:
	LDX !PCNPC_EventID_02
	JMP (ZeroEvent16CreditsEvents,x)

ZeroEvent16CreditsEvents:
	dw ZeroEvent16Credits00
	dw ZeroEvent16Credits02
	dw $FF
	
	
	;***************************
	; Sub-event #00 ;Set Zero on cliff
	;***************************		
	ZeroEvent16Credits00:
		LDA !ZSaberObtained_1FB2
		BIT #$40
		BEQ ZeroEvent16Credits00IncreaseEvent
		RTL
		
ZeroEvent16Credits00IncreaseEvent:
		LDA #$26
		STA !PCNPC_PaletteDirection_11
		JSL ZeroSetup
		LDA !PCNPC_PaletteDirection_11
		SEC
		SBC #$40
		STA !PCNPC_PaletteDirection_11
		
		INC !PCNPC_EventID_02
		INC !PCNPC_EventID_02
		
		LDA #$5C
		JSL !AnimationOneFrame

	;***************************
	; Sub-event #02 ;Animate Zero Idle
	;***************************
	ZeroEvent16Credits02:
		LDA $1F38
		BNE ZeroEvent16Credits02EventLoop
		
		JSL !VRAMRoutineAlt
		JSL NewVRAMRoutine
		
ZeroEvent16Credits02EventLoop:
		JML !EventLoop