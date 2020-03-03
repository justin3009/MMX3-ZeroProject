;==================================================================================
; Mega Man X3 (Base Mod Project)
; By: xJustin3009x (Shishisenkou) (Justin3009)
;==================================================================================
; This file is solely reserved for RAM addresses that are used across all files.
;==================================================================================
; NOTE: The ROM MUST be expanded to 4MB first WITHOUT a header!
;==================================================================================
;*********************************************************************************
;*********************************************************************************
; RAM Addresses
;*********************************************************************************
		!CurrentPCAction_09DA				= $09DA
			!CurrentPCSubAction_09DB		= $09DB
		!PCXCoordinate_09DD					= $09DD
		!PCYCoordinate_09E0					= $09E0
		!PCVisibility_09E6					= $09E6
			!PCVisibility2_0A43				= $0A43	
		!PCPaletteDirection_09E9			= $09E9
		!PCSpritePriority_09EA				= $09EA ;NEW SO IT DETERMINES IF PC OR PC NPC IS WEARING ARMOR
		!CurrentPCHitbox_09F8				= $09F8
		!CurrentHealth_09FF					= $09FF
		
		!PCAirGroundDetection_0A03			= $0A03 ;00 = In air, 04 = On ground
		!CurrentPCSubWeapon_0A0B			= $0A0B
			!CurrentPCSubWeaponShort_33		= $33
		!CurrentPCChargeTime_0A2F			= $0A2F
		!CurrentPCCharge_0A30				= $0A30
		!SetFlashForPC_0A32					= $0A32
		!SetBubblesFlashForPC_0A33			= $0A33
		!PCDirection_0A41					= $0A41
		!DisablePCCharging_0A54				= $0A54
		!CurrentPCChargeLevel4_0A66			= $0A66
		!CurrentPCChargeLevel5_0A67			= $0A67
		!CurrentPC_0A8E						= $0A8E
			!CurrentPCShort_B6				= $B6
		!ZSaberCharge_0A8F					= $0A8F
		
		!ScreenXCoordinate_1E5D				= $1E5D
		!ScreenYCoordinate_1E60				= $1E60
		
		!SkipDeathEvent_1F1C				= $1F1C
		!PCGodMode_1F1D						= $1F1D		
		!PCHealthBar_1F22					= $1F22
		!PCSubWeaponAmmoBar_1F23			= $1F23
		!DisablePCProjectiles_1F25			= $1F25
		!DisableEnemyProjectiles_1F26		= $1F26
		!DisableEnemyAI_1F27				= $1F27
		!DisableObjectAnimation_1F28		= $1F28
		!DisableEnemyLoading_1F29			= $1F29
		!DisableEnemyGraphics_1F2A			= $1F2A
		!DisableScreenScroll_1F2B			= $1F2B
		!DamageType_1F2F					= $1F2F
		!MenuIsOpen_1F37					= $1F37
		!EnableEventLock_1F3F				= $1F3F
		!DisableLRSubWeaponScroll_1F45		= $1F45
		!DisableMenuOpening_1F4F			= $1F4F		
		
		!CurrentPCCheck_1FFF				= $1FFF
		!CurrentLevel_1FAE					= $1FAE
		!CurrentDopplerLevel_1FAF			= $1FAF
		!DopplerLabBIT_1FB0					= $1FB0
		!ZSaberObtained_1FB2				= $1FB2
		!SetCredits_1FB3					= $1FB3
		!Checkpoint_1FB5					= $1FB5
		!SubTanksOrigin_1FB7					= $1FB7
		!SubWeap_1FB8						= $1FB8
		!SubWeap_1FB9						= $1FB9
		!SubWeap_1FBA						= $1FBA
		!SubWeap_1FBB						= $1FBB
		!SubWeap_1FBC						= $1FBC
		!PCNPC_VRAMByte_1FCB					= $1FCB
		!ZSaberCheckEnemy_1FCF				= $1FCF
		!CurrentPCArmorOriginFull_7E1FD1	= $7E1FD1
			!CurrentPCArmorOriginShort_1FD1	= $1FD1
		!IntroductionLevelBIT_1FD3			= $1FD3
		!HeartTankCollection_1FD4			= $1FD4
		!DopplerTeleporters_1FDA			= $1FDA
			
		!RideChipsOrigin_7E1FD7				= $7E1FD7
			!RideChipsOrigin_7E1FD7_Short	= $1FD7
		!BitByteVileCheck_1FD8				= $1FD8
		
		!Difficulty_7EF4E0					= $7EF4E0
;		!ModeSelect_7EF4E1					= $7EF4E1 ;May not be used
		!BossesDefeated1_7EF4E2				= $7EF4E2
		!BossesDefeated2_7EF4E3				= $7EF4E3
		!CapsuleIntro_7EF4E4				= $7EF4E4
		!VariousSubWeapCheck_7EF4E5			= $7EF4E5
		!JumpDashAmount_7EF4E6				= $7EF4E6
		!JumpDashFlag_7EF4E7				= $7EF4E7 ;Sets value to note to RTL in the routine to set jump values instead of loading the action code
		!PCVRAMByte_7EF4E8					= $7EF4E8
		!PCHealCounter_7EF4EA				= $7EF4EA
		!PCorPCNPC_Buster_7EF4EB				= $7EF4EB

		!XArmorsByte1_7EF418				= $7EF418
		!XArmorsByte2_7EF419				= $7EF419
		!XSwapHealth_7EF41A					= $7EF41A
		!XMaxHealth_7EF41B					= $7EF41B
		!XHeartTank_7EF41C					= $7EF41C
		!XHeartTank_F41C					= $F41C
		!XSubTankCollect_7EF41D				= $7EF41D
		!XSubTankCollect_F41D				= $F41D
		!XAllArmors_7EF41E					= $7EF41E ;Probably go unused
		!XAvailable_7EF41F					= $7EF41F
		
		!ZeroArmorsByte1_7EF448				= $7EF448
		!ZeroArmorsByte2_7EF449				= $7EF449
		!ZeroSwapHealth_7EF44A				= $7EF44A
		!ZeroMaxHealth_7EF44B				= $7EF44B
		!ZeroHeartTank_7EF44C				= $7EF44C
		!ZeroHeartTank_F44C					= $F44C
		!ZeroSubTankCollect_7EF44D			= $7EF44D
		!ZeroSubTankCollect_F44D			= $F44D
		!ZeroAllArmors_7EF44E				= $7EF44E
		!ZeroAvailable_7EF44F				= $7EF44F
		
		!PC3ArmorsByte1_7EF478				= $7EF478
		!PC3ArmorsByte2_7EF479				= $7EF479
		!PC3SwapHealth_7EF47A				= $7EF47A
		!PC3MaxHealth_7EF47B				= $7EF47B
		!PC3HeartTank_7EF47C				= $7EF47C
		!PC3HeartTank_F47C					= $F47C
		!PC3SubTankCollect_7EF47D			= $7EF47D
		!PC3SubTankCollect_F47D				= $F47D
		!PC3AllArmors_7EF47E				= $7EF47E ;Probably go unused
		!PC3Available_7EF47F				= $7EF47F
		
		!PC4ArmorsByte1_7EF4A8				= $7EF4A8
		!PC4ArmorsByte2_7EF4A9				= $7EF4A9
		!PC4SwapHealth_7EF4AA				= $7EF4AA
		!PC4MaxHealth_7EF4AB				= $7EF4AB
		!PC4HeartTank_7EF4AC				= $7EF4AC
		!PC4HeartTank_F4AC					= $F4AC
		!PC4SubTankCollect_7EF4AD			= $7EF4AD
		!PC4SubTankCollect_F4AD				= $F4AD
		!PC4AllArmors_7EF4AE				= $7EF4AE ;Probably go unused
		!PC4Available_7EF4AF				= $7EF4AF
		
		!XSubTank_7EF400					= $7EF400
		!ZeroSubTank_7EF430					= $7EF430
		!PC3SubTank_7EF460					= $7EF460
		!PC4SubTank_7EF490					= $7EF490
		
		!PCSubWeaponsBase_7EF403			= $7EF403 ;Actually $7EF404 but the X values are +1 so all sub-weapon area is consistent
		!PCSubWeaponsTrueBase_7EF404		= $7EF404
		
		
		!ZSaberEnemyTableForBlanking_7EF4FF	= $7EF4FF
		!ZSaberEnemyTable_7EF500			= $7EF500
		
		!PCNPC_Active_00					= $00
		!PCNPC_EventID_02					= $02
		!PCNPC_SubEvent_03					= $03
		!PCNPC_XCoordinate_05				= $05
		!PCNPC_YCoordinate_08				= $08
		!PCNPC_TempStorage_0A				= $0A
		!PCNPC_TempStorage_0C				= $0C
		!PCNPC_Animate_0E					= $0E
		!PCNPC_IsAnimating_0F				= $0F
		!PCNPC_UNKNOWN_10					= $10
		!PCNPC_PaletteDirection_11			= $11
		!PCNPC_SpritePriority_12			= $12
		!PCNPC_FrameDelay_13				= $13
		!PCNPC_SpriteAssembly_16			= $16
		!PCNPC_CurrentFrame_17				= $17
		!PCNPC_VRAMSlot_18					= $18
		!PCNPC_SpeedDistance_1A				= $1A
		!PCNPC_Velocity_1C					= $1C
		!PCNPC_JumpHeight_1E				= $1E
		!PCNPC_Hitbox_20					= $20
		!PCNPC_OnGround_2B					= $2B
		!PCNPC_UNKNOWN_30					= $30
		!PCNPC_BaseVRAM_31					= $31
		!PCNPC_TempStorage_33				= $33
		!PCNPC_DelayTimer_3C				= $3C
		!PCNPC_TempStorage_41				= $41
		!PCNPC_AnimationFrameDoneTalk_43	= $43
		!PCNPC_UNKNOWN_45					= $45
		!PCNPC_UNKNOWN_47					= $47
		
;***************************
;***************************
; Common Events
;***************************
	!CheckForGround			= $82D6F8
	!LandOnGround			= $84C0F7
	!CheckForLanding		= $82D78E
	
	!DialogueBoxNormal		= $82FCB1
	!DialogueBoxSmall		= $83AFBA
	
	!LoadSubWeaponIcon		= $80872F  ;Debatable on what this is? May actually be sub-weapon icon but it seems to do both?
	!PlayMusic				= $8084BC
	!PlaySFX				= $81802B
	
	!MoveObjectUp			= $82D812
	!MoveObjectRight		= $82D7F3
	!MissileHitObject		= $84CC5C
	!CheckMissileRoom		= $82D8C4
	!CheckSpecialFXSlot		= $82D859
	!CheckEnemyRoom			= $82D8A7
	
	!LoadPCWeaponPalette	= $84B6D0
	!Palette				= $81804A
	!PaletteAlternate		= $81805B
	!PalettePCBuster		= $84FFCA
	!ReloadSubWeapGreaphics	= $83BB88

	!AnimationOneFrame		= $84B967
	!AnimationConsistent	= $83BB11
	!VRAMRoutineConsistent	= $83BB04
	!VRAMRoutine			= $84BCA2
	!VRAMRoutineAllowMissiles	= $84BC95
	!VRAMRoutineAlt			= $84B94A
	!EventLoop				= $82D636
	!ClearMissiles			= $84D4BF
	
	!ClearPCCharge			= $848E81
	!CommonEventEnd			= $82D928
	
	!LoadCompressedGraphics	= $B47A
	!LoadCompressedGraphics_Long	= $80B47A
	!LoadDecompressedGraphics	= $873B
	!LoadDecompressedGraphics_Long	= $80F514
	
	!SendToVRAM_8162				= $8162
	
	