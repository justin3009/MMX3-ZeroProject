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
;*********************************************************************************
header : lorom
;*********************************************************************************
incsrc MMX3_VariousAddresses.asm

;*********************************************************************************
; Graphical/Various data inserts
;*********************************************************************************
incbin Files/Miscellaneous/PC_PCZSaber_PCRideArmor_VRAM_508000.bin -> $508000
incbin Files/Miscellaneous/PC_PCZSaber_PCRideArmor_AnimationData_518000.bin -> $518000
incbin Files/Miscellaneous/PC_PCZSaber_PCRideArmor_SpriteAssembly_528000.bin -> $528000
incbin Files/Miscellaneous/AllAnimationData_3F8000.bin -> $BF8000
incbin Files/Miscellaneous/AllSpriteAssembly_Pointers_0D8000.bin -> $8D8000

incbin Files/Miscellaneous/X_BeamSaberWave_SpriteAssembly_8FDBA5.bin -> $8FDBA5
incbin Files/Miscellaneous/X_Zero_ZSaberVRAM_85E62E.bin -> $85E62E
incbin Files/Miscellaneous/X_ZSaberAirGround_SpriteAssembly_8FDA99.bin -> $8FDA99
incbin Files/Miscellaneous/Zero_ZSaberAirGround_SpriteAssembly_8FDD87.bin -> $8FDD87
incbin Files/Miscellaneous/Zero_VictorySpriteAssembly_92E820.bin -> $92E820

incbin Files/Decompressed/Decompressed_ZeroGetWeaponTileMap_C98000.bin -> $C98000
incbin Files/Decompressed/Decompressed_PasswordScreen_Layer1_TileMap_C98800.bin -> $C98800
incbin Files/Decompressed/Decompressed_PasswordScreen_Layer3_TileMap_C99000.bin -> $C99000


incbin Files/Decompressed/Decompressed_ZSaberSprites_BAE000.bin -> $BAE000
incbin Files/Decompressed/Decompressed_Z-Buster_Sprites_B2E000.bin -> $B2E000
incbin Files/Decompressed/Decompressed_X_Sprites_168000.bin -> $AD8000
incbin Files/Decompressed/Decompressed_ZeroVictory_D68000.bin -> $D68000
incbin Files/Decompressed/Decompressed_ZeroGetWeapon_BF8C00.bin -> $FF8C00
incbin Files/Decompressed/Decompressed_RideModuleChips_BFB800.bin -> $FFB800
incbin Files/Decompressed/Decompressed_Zero_1UP_BFBC00.bin -> $FFBC00
incbin Files/Decompressed/Decompressed_GeneralVRAM_BFBF80.bin -> $FFBF80
incbin Files/Decompressed/Decompressed_ZStageSelect_BFD000.bin -> $FFD000
incbin Files/Decompressed/Decompressed_InGameMenu_BFD200.bin -> $FFD200
incbin Files/Decompressed/Decompressed_InGameMenuTileMap_C8F800.bin -> $C8F800
incbin Files/Decompressed/Decompressed_X_Zero_Introduction_FEEF20.bin -> $FEEF20
incbin Files/Decompressed/Decompressed_X_MenuArmorSprites_FEEAE0.bin -> $FEEAE0
incbin Files/Decompressed/Decompressed_Zero_RideArmorSprites_D6B0A0.bin -> $D6B0A0
incbin Files/Miscellaneous/Zero_RideArmor_SpriteAssembly_92ED9A.bin -> $92ED9A
incbin Files/Decompressed/Decompressed_XMenuPortraitSprite_FEE4E0.bin -> $FEE4E0
incbin Files/Decompressed/Decompressed_Ready_Sprites_BFBCC0.bin -> $FFBCC0

incbin Files/Miscellaneous/BossDoor_Checks_BCD275.bin -> $BCD275

;Remove comment here for sub-weapon palette patch so Zero's chest is blue like his X3 art work.
; incbin Decompressed_ZeroSprites_BlueChest_B08000.bin -> $B08000
; incbin Decompressed_ZeroSprites_BlueChest_RideArmorSprites_D6B0A0.bin -> $D6B0A0
; incbin Decompressed_ZeroSprites_BlueChest_Victory_D68000.bin -> $D68000
