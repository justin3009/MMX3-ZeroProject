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
		!BaseItemObjectLocation		= $E48000
;***************************
header : lorom

incsrc MMX3_NewCode_Locations.asm
incsrc MMX3_VariousAddresses.asm
;***************************
org !BaseItemObjectLocation
	LDA $0A
	ASL
	TAX
	JSR (BaseItemObjectPointers,x)
	RTL
	
BaseItemObjectPointers:
	dw Item_Object_00_BLANK ;Blank
	dw Item_Object_01 ;Ammo refill (Large and small)
	dw Item_Object_02 ;Health refill (Large and small)
	dw Item_Object_03 ;1-Up
	dw Item_Object_03 ;1-Up (Repeat)
	dw Item_Object_04 ;S-Tank
	dw Item_Object_05 ;Camera scroll up (Used possibly for Sigma final battle)
	dw Item_Object_06 ;Boss door (Same as Item_Object_0D)
	dw Item_Object_07 ;Camera scroll left (Used possibly for credits scene)
	dw Item_Object_08 ;???
	dw Item_Object_09 ;???
	dw Item_Object_0A ;Heart Tank
	dw Item_Object_0B ;Teleporter instance (Used for boss refight capsules in Doppler level)
	dw Item_Object_0B ;Teleporter instance (Used for boss refight capsules in Doppler level)
	dw Item_Object_0C ;???
	dw Item_Object_0C ;???
	dw Item_Object_0D ;Boss door (Same as Item_Object_06)
	dw Item_Object_0D ;Boss door (Same as Item_Object_06)
	dw Item_Object_0E ;Weird non-stop black bar at top? (Maybe lava in final Sigma level?)
	dw Item_Object_0F ;PC cannot move, charge, open menus, etc..
	dw Item_Object_0F ;PC cannot move, charge, open menus, etc..
	dw Item_Object_0F ;PC cannot move, charge, open menus, etc..
	dw Item_Object_0F ;PC cannot move, charge, open menus, etc..
	dw Item_Object_10 ;??? (Possibly ride modules)
	dw Item_Object_11 ;Vile teleporter
	dw Item_Object_11 ;Vile teleporter (Repeat)
	dw Item_Object_11 ;Vile teleporter (Repeat)
	dw $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF


;Item object base locations. Loads their base routine JSL then returns.
Item_Object_00_BLANK: RTS
Item_Object_01: JSL $81D3EC : RTS	;22 EC D3 01 60 ;Ammo refill capsules (Large and small)
Item_Object_02: JSL $81D6BD : RTS	;22 BD D6 01 60 ;Health refill capsules (Large and small)
Item_Object_03: JSL PC1UpObject : RTS	;22 33 D9 01 60 ;1-Up
Item_Object_04: JSL SubTankObject : RTS	;22 D2 DA 01 60 ;Sub-Tank
Item_Object_05: JSL $81DCC7 : RTS	;22 C7 DC 01 60 ;Camera scroll up (Used possibly for Sigma final battle)
Item_Object_06: JSL $81E037 : RTS	;22 37 E0 01 60 ;Boss door (Same as Item_Object_0D)
Item_Object_07: JSL $81E439 : RTS	;22 39 E4 01 60 ;Camera scroll left (Used possibly for credits scene)
Item_Object_08: JSL $81E5D5 : RTS	;22 D5 E5 01 60 ;???
Item_Object_09: JSL $81CEDE : RTS	;22 DE CE 01 60 ;???
Item_Object_0A: JSL HeartTankObject : RTS	;22 3D E8 01 60 ;Heart Tank
Item_Object_0B: JSL $81EBB8 : RTS	;22 B8 EB 01 60 ;Teleporter instance (Used for boss refight capsules in Doppler level)
Item_Object_0C: JSL $81EA58 : RTS	;22 58 EA 01 60 ;???
Item_Object_0D: JSL $81E037 : RTS	;22 37 E0 01 60 ;Boss door (Same as Item_Object_06)
Item_Object_0E: JSL $83BD80 : RTS	;22 80 BD 03 60 ;Weird non-stop black bar at top? (Maybe lava in final Sigma level?)
Item_Object_0F: JSL $83BB98 : RTS	;22 98 BB 03 60 ;PC cannot move, charge, open menus, etc..
Item_Object_10: JSL $81F0F5 : RTS	;22 F5 F0 01 60 ;Ride Module chips?
Item_Object_11: JSL $81ECEC : RTS	;22 EC EC 01 60 ;Vile teleporter














;*********************************************************************************
; Begin new code changes for various objects
;*********************************************************************************
;*********************************************************************************
; Code for Ammo Refill Object. Moved and redone to support the new sub-weapon locations.
;*********************************************************************************
AmmoRefillObject: ;E4:8000 (Ammo Capsule)
{
	LDX $03
	JMP (AmmoRefillObjectPointers,x)
	
AmmoRefillObjectPointers:
	dw AmmoRefillObject_Event00_SetHealing_CheckHealing
	dw AmmoRefillObject_Event02_BeginHealing
	dw AmmoRefillObject_Event04_EndAmmoRefillObject
	

	;***************************
	; Sub-event #00: Set's base setup for ammo capsule. Big or small, how much healing.
	;***************************
		AmmoRefillObject_Event00_SetHealing_CheckHealing:
		LDA !CurrentHealth_09FF
		AND #$7F
		BEQ AmmoRefillObject_Event_IncreaseEvent01
		
			LDX #$08 ;Max ammo to refill for LARGE ammo capsule
			
			LDA $0B ;Check what type of ammo capsule (Big or small)
			AND #$7F
			BEQ AmmoRefillObject_Event_IgnoreSmallCapsule01
			
				LDX #$02
			
			AmmoRefillObject_Event_IgnoreSmallCapsule01:
			STX $27
			
			LDY !CurrentPCSubWeapon_0A0B
			BEQ AmmoRefillObject_Event_SubWeaponIsEqual
				CPY #$09 ;Check for Hyper Chip
				BCS AmmoRefillObject_Event_SubWeaponIsEqual
					BRA AmmoRefillObject_Event_HealCurrentWeapon
			
			AmmoRefillObject_Event_SubWeaponIsEqual:
			JSL RefillSubWeaponAmmo ;Routine to heal sub-weapons not equipped if current is full
		
		AmmoRefillObject_Event_IncreaseEvent01:
		LDA #$04 ;Increase to next event?
		STA $01
		RTL
		
		AmmoRefillObject_Event_HealCurrentWeapon:
		LDX !CurrentPCSubWeapon_0A0B
		JSL LoadPCSplitSubWeapon
		AND #$1F
		CMP #$1C ;Check for max health
		BEQ AmmoRefillObject_Event_SubWeaponIsEqual
		
		LDA #$02 ;Frame delay per heal
		STA $03
		LDA #$01
		STA !DisablePCProjectiles_1F25
		STA !DisableEnemyProjectiles_1F26
		STA !DisableEnemyAI_1F27
		STA !DisableObjectAnimation_1F28
		STA !DisableEnemyLoading_1F29
		STA !DisableEnemyGraphics_1F2A
		STA !DisableScreenScroll_1F2B
		STA !PCVisibility_09E6
		
		LDA #$7F
		STA !DisableMenuOpening_1F4F
		
		LDA #$80
		TSB $00
		LDA #$04
		STA $26
		
		JSL $84D0E8
		RTL
		
	;***************************
	; Sub-event #02: Set's base setup for ammo capsule. Big or small, how much healing.
	;***************************
	AmmoRefillObject_Event02_BeginHealing:
		LDA !CurrentHealth_09FF
		AND #$7F
		BEQ HealSubWeaponIncreaseEvent
		
			DEC $26 ;Delay between each pellet of health healing
			BNE HealSubWeaponSkipNextEvent
			
				LDA #$1D
				STA $0004

				LDA #$04 ;How many frames to wait per pellet of health
				STA $26
				
				LDX !CurrentPCSubWeapon_0A0B
				JSL LoadPCSplitSubWeapon
				AND #$7F
				INC
				BIT #$40
				BEQ HealSubWeaponCheckFor5C
				
					PHA
					LDA #$5D
					STA $0004
					PLA
				
				HealSubWeaponCheckFor5C:
				CMP $0004
				BCC HealSubWeapon
				
				HealSubWeaponVarious:
				LDA $27 ;Load current life left to store into sub-weapon health
				DEC
				BEQ HealSubWeaponIgnoreHealVarious
				
					STA $27
					JSL RefillSubWeaponAmmo ;Load routine to heal other sub-weapons if current one becomes full
				
				HealSubWeaponIgnoreHealVarious:
				LDX #$04
				STX $03
				LDX !CurrentPCSubWeapon_0A0B
				JSL LoadPCSplitSubWeapon
				
				HealSubWeapon:
				JSL StorePCSplitSubWeapon
				
				LDA #$15
				JSL !PlaySFX
				
				DEC $27
				BNE HealSubWeaponSkipNextEvent
			
			HealSubWeaponIncreaseEvent:
			LDA #$04
			STA $03
			
		HealSubWeaponSkipNextEvent:
		RTL
		
	;***************************
	; Sub-event #04: End ammo capsule event
	;***************************
	AmmoRefillObject_Event04_EndAmmoRefillObject:
		STZ !DisablePCProjectiles_1F25
		STZ !DisableEnemyProjectiles_1F26
		STZ !DisableEnemyAI_1F27
		STZ !DisableObjectAnimation_1F28
		STZ !DisableEnemyLoading_1F29
		STZ !DisableEnemyGraphics_1F2A
		STZ !DisableScreenScroll_1F2B
		STZ !DisableMenuOpening_1F4F
		
		LDA #$04
		STA $01
		LDA #$80
		TRB $00
		JSL $84D130
		RTL
}
		
;*********************************************************************************
; Code for Heart Tank Object. Moved and slightly redone to support how the heart tanks now work.
;*********************************************************************************		
HeartTankObject:
{
	LDX $01 ;Load 'X' value for Heart Tank event RAM from $7E:1519
	JMP (HeartTankObjectPointers,x)
	
	HeartTankObjectPointers:
	dw HeartTankObject_Event00_CheckIfObtained
	dw HeartTankObject_Event02_CommonEvents
	dw HeartTankObject_Event04_CommonEnd
	

	;***************************
	; Sub-event #00: Determines whether the Heart Tank can spawn. Then determines it's palette, sprite assembly, animation etc..
	;***************************
		HeartTankObject_Event00_CheckIfObtained:
		LDA !XHeartTank_7EF41C
		CLC
		ADC !ZeroHeartTank_7EF44C
		ADC !PC3HeartTank_7EF47C
		ADC !PC4HeartTank_7EF4AC
		STA $0000
		LDA $0B ;Loads $7E:1523 to load the Heart Tank's bit test value
		BIT $0000 ;Loads original Heart Tank collection location to compare and see if it's been obtained or not.
		BEQ SkipHeartTankEarlyEnd
		
		JML !CommonEventEnd
		
		SkipHeartTankEarlyEnd:
		LDA #$02 ;Increases Heart Tank routine to #$02
		STA $01 ;Store to event RAM at $7E:1519
		STZ $12
		STZ $28
		
		LDA $7F8236
		STA $18
		
		LDX !CurrentLevel_1FAE
		LDA $B3A2,x ;Loads a table to determine the direction of the Heart Tank. (Left, right, upside down)
		STA $0000
		
		LDA $7F8336 ;Load palette/priority of Heart Tank
		ORA $0000
		STA $11
		STA $2F
		
		REP #$20
		LDA #$D831
		STA $20
		
		JSL $82D636
		
		LDA #$38
		STA $16
		LDA #$00
		JSL $84B967
		RTL
	
	;***************************
	; Sub-event #02: Loads a common routine location for various events.
	;***************************
		HeartTankObject_Event02_CommonEvents:
		JML $81E88D
		RTL
		
	;***************************
	; Sub-event #04: End routine
	;***************************
		HeartTankObject_Event04_CommonEnd:
		STZ !DisableMenuOpening_1F4F
		JML !CommonEventEnd
		RTL
}
		
;*********************************************************************************
; Code for Sub-Tank Objects. Moved and slightly redone to support how the sub-tanks work.
;*********************************************************************************				
SubTankObject:
{
	LDX $01 ;Load 'X' value for Sub-Tank value
	JSR (SubTankObjectPointers,x)
	
	REP #$10
	LDA $28
	BEQ OtherXCoordinates
	
	LDX #$D4DF
	STX $20
	BRA EndSubTankEvent
	
	OtherXCoordinates:
	LDX #$D50B
	STX $20
	
	EndSubTankEvent:
	SEP #$10
	RTL
	
	
	SubTankObjectPointers:
	dw SubTankObject_Event00_CheckIfObtained
	dw SubTankObject_Event02_CommonEvents
	dw SubTankObject_Event04_CommonEnd ;This is generally used to end item object events so it can be used everywhere.


	;***************************	
	;SubTankObject_Event00 ;Checks if PC has collected the sub-tank or not.
	;***************************
		SubTankObject_Event00_CheckIfObtained:
		JSL PCAddAllSubTanks
		AND $0B
		BEQ ContinueCheckingSubTank
		JSL !CommonEventEnd	
		RTS
		
		ContinueCheckingSubTank:
		LDA #$02
		STA $01
		STZ $12
		STZ $18
		STZ $28
		
		LDA #$FF
		STA $26
		STA $2F
		
		LDA $7F828C
		STA $18
		
		LDA !PCPaletteDirection_09E9
		AND #$30
		ORA #$04
		STA $11
		
		LDA $7F838C
		AND #$01
		TSB $11
		JSL !EventLoop
		
		LDA #$96
		STA $16
		LDA #$00
		JSL !AnimationOneFrame
		RTS
	
	;***************************	
	;SubTankObject_Event02 - General common events ;This may actually be incorrect since the original routine goes to ANOTHER routine.. but it doesn't seem like it's needed?
	;***************************
		SubTankObject_Event02_CommonEvents:
		JSL $81DAD2
		RTS
	
	;***************************
	; Sub-event #04: End routine
	;***************************
		SubTankObject_Event04_CommonEnd:
		STZ !DisableMenuOpening_1F4F
		JSL !CommonEventEnd
		RTS
}
	
;*********************************************************************************
; Code for 1-Up Icon Objects. Moved and slightly redone to support both X and Zero sprites
;*********************************************************************************			
PC1UpObject:
{
	LDX $01 ;Load 'X' value for Heart Tank event RAM from $7E:1519
	JSR (PC1UpObjectPointers,x)
	
	REP #$10
	LDA $28
	BEQ PC1UP_OtherXCoordinates
	
	LDX #$D4DF
	STX $20
	BRA PC1UP_EndEvent
	
	PC1UP_OtherXCoordinates:
	LDX #$D501
	STX $20
	
	PC1UP_EndEvent:
	SEP #$10
	RTL
	
	
	PC1UpObjectPointers:
	dw PC1UpObject_Event00_Initiate1Up
	dw PC1UpObject_Event02_CommonEvents
	dw PC1UpObject_Event04_CommonEnd
	

	;***************************
	; Sub-event #00: Spawns the 1-up icon and sets it's palette, sprite assembly and animation down
	;***************************
		PC1UpObject_Event00_Initiate1Up:
		LDA #$02 ;Initiates 1-up icon event to appear
		STA $01
		
		STZ $12
		STZ $18
		STZ $28
		LDA #$FF
		STA $26
		LDA !PCPaletteDirection_09E9
		AND #$30
		ORA #$02
		STA $11
		STA $2F
		JSL !EventLoop
		
		JSL PC1Up_InGameIcon_SpriteAssembly ;Loads sprite assembly for 1-up icon
		STA $16
		LDA #$00
		JSL !AnimationOneFrame
		RTS
		
	;***************************
	; Sub-event #02: Determines whether the 1-up icon has been picked up or not to determine if the event should end or continue.
	;***************************
		PC1UpObject_Event02_CommonEvents:
		JSL $81D933
		RTS
		
	;***************************
	; Sub-event #04: Ends 1-up icon routine
	;***************************
		PC1UpObject_Event04_CommonEnd:
		JSL !CommonEventEnd
		RTS
}
		
		
		
		
		
;*********************************************************************************
; Changes JSL for Ammo Refill Object
;*********************************************************************************
org $81D533 ;Blank space inside normal ROM
	JSL AmmoRefillObject
	RTS
	
;*********************************************************************************
; Changes original location of 1-up icon to JSR to it's Event 02 data so the entire section doesn't have to be rewritten as a sub-routine inside a sub-routine
;*********************************************************************************
org $81D933 ;Blank space inside normal ROM
	JSR $D96A
	RTL
	
;*********************************************************************************
; Changes continue Sub-Tank event in the original location
;*********************************************************************************
org $81DAD2
	JSR $DB23
	RTL