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
;***************************
header : lorom

;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Various padbytes to remove many original tables, coding locations or other miscellaneous data in bulk.
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
org $869FAA ;Original code location for all sub-weapon icon, graphics, text, ammo and their text coordinates.
	padbyte $FF ;All of it was removed as it's no longer needed.
	pad $86A07D
	
org $8D96F2 ;This blanks out all walking frames for Frog Armor
	padbyte $FF
	pad $8D970D
	
org $80C715 ;Original offset location for each pointer to each menu command)
	padbyte $FF
	pad $80C72B

org $B9C1BC ;Original code location for all dialogue pointers and the dialogue itself.
	padbyte $FF ;All of it was removed as it has been moved and split up based on which PC you are.
	pad $B9FFFF
	
org $80D1F0 ;Clears out the entirety of the sub-weapon icon/text/graphics routines along with the Ride Chip routine since it's moved
	padbyte $EA
	pad $80D2D7

org $86E4A7 ;Original damage table pointers and values. (Removed as they're not needed anymore)
	padbyte $FF
	pad $86EA1D
	
org $80D160 ;Clears out the entirety of the sub-weapon life bar setup
	padbyte $EA
	pad $80D191
	
org $80E7D6 ;Removes command 84/85's text data
;84/85 were used for Japanese Katakana in the original
	padbyte $EA
	pad $80E82D

org $83BB37 ;Original code location for setting up PC NPC code for X and Zero
	padbyte $FF ;Completely removed as it's been moved and rewritten.
	pad $83BB84

org $84B5BB ;Original code location that stores 00 to Sprite Assembly on introduction (Maybe others?)
	padbyte $FF ;Removed as it's completely rewritten
	pad $84B5FB

org $80CF08 ;Loads original code location that determined whether you could leave a level or not depending on if you defeated a boss.
	padbyte $EA ;Routine was NOP'd entirely as it was moved to a new location and rewritten.
	pad $80CF14
	
org $83A181 ;Loads original code location to set PC Ride Armor sprites
	padbyte $EA ;Blanks out most of the routine so it could be rewritten
	pad $83A1B4
	
org $868180 ;Original palettes location
	padbyte $FF
	pad $868380
	
org $848DC3 ;Sets PC's life and icon when swapping inside a level then sets the new PC value.
	padbyte $EA
	pad $848DF8
	
org $84DBA6 ;Blanks out original Heart Tank routine as it's no longer used.
	padbyte $FF
	pad $84DBC6
	
org $81E9D1	;Blanks out original routine to increase PC's max health when obtaining a Heart Tank.
	padbyte $EA
	pad $81E9EA
	
org $81E968 ;Blanks out original Heart Tank counter routine as it's no longer used.
	padbyte $EA
	pad $81E980
	
org $80CEAC ;Routine to re-order sub-tanks. (NOW REMOVED)
	padbyte $FF
	pad $80CEF4
	
org $80CEF4 ;Routine to check whether you can exit certain levels or not.
	padbyte $FF
	pad $80CF1D
	
org $80D451 ;Loads original routine to draw PC lives counter in main menu
	padbyte $FF
	pad $80D485
	
org $80D485 ;Original routine to draw sub-tanks in the menu
	padbyte $FF
	pad $80D4AF
	
org $80C901
	padbyte $FF
	pad $80C93F
	
org $84CD8E ;Loads original code location for Hyper Charge recovering life when damaged.
	padbyte $EA
	pad $84CDF5
	
org $B99000 ;Original location of X's single-byte ADC and X/Y coordinates. They are blanked out now as it's useless
	padbyte $FF
	pad $B990A0
	
org $B990A0 ;Original location of X's single-byte ADC and X/Y coordinates of drill. They are blanked out now as it's useless
	padbyte $FF
	pad $B99161

org $81965B ;Original code location for setting how much smoke appears when Acid Burst hits anything.
	padbyte $FF
	pad $81969E
	
org $B99161 ;Original location of Zero's single-byte ADC and X/Y coordinates for Zero. They are blanked out now as it's useless. (This might've possibly been unused!)
	padbyte $FF
	pad $B99225

org $84A566 ;Load original code location for sub-weapon ammo usage.
	padbyte $FF ;Blanks out the entire original sub-weapon ammo usage routine
	pad $84A5D9
	
org $86B346 ;Loads velocity per animation frame for vertical dash
	padbyte $00 ;Removed as it's unnecessary now
	pad $86B353
	
org $848BCA ;Loads original code that was a command that allowed the vertical dash to transition into falling
	padbyte $FF ;Command to allow vertical dash to transition into falling is removed as it's useless now and breaks various things.
	pad $848C05
	
org $8487FA ;Routine to spawn forcefield as a sprite
	padbyte $EA
	pad $848837
	
org $84AEE8 ;Original code that disabled the Z-Saber from being used until after the buster shots were off screen
	padbyte $FF ;Now blanked out entirely so the routine can be rewritten
	pad $84AF12

org $84B6D6 ;Original code location for loading the general palette routine for PCs on various circumstances
	padbyte $FF
	pad $84B723

org $93C548 ;Original code location for PC palette flashing in capsule
	padbyte $EA ;NOP'd so the entire routine could be rewritten
	pad $93C563
	
org $83A22A ;Original code that determined PC's hitbox when they were jumping, landing, jumping out of Ride Armor, etc...
	padbyte $EA ;NOP'd so most of the routine was rewritten
	pad $83A246
	
org $84A63C ;Loads original code location to set PC general sprites
	padbyte $FF ;Blanked the entire routine so it could be rewritten.
	pad $84A68A
	
org $84A68A ;Loads original code location to set PC general Z-Saber sprites
	padbyte $FF ;Blanked the entire routine so it could be rewritten.
	pad $84A6D4
	
org $93C00B ;Original code location for the capsule routine to check various instances for Golden Armor or Armor Parts.
	padbyte $FF ;Blanked so most of the routine was rewritten
	pad $93C0B2
	
org $BCC491 ;Removed code so Byte can spawn regardless if the current level was beaten or not.
	padbyte $EA
	pad $BCC4C2
	
org $878F85 ;Removed code so Bit can spawn regardless if the current level was beaten or not.
	padbyte $EA
	pad $878FB8

org $82E27B ;Routine to check if current level has been done to prevent Bit/Byte from spawning. (REMOVED)
	padbyte $FF
	pad $82E28B	
	
org $85CE45 ;Removes X, X Z-Saber and X Ride Armor VRAM
	padbyte $FF
	pad $85D5FE

;05:CE45 - 05:D334 X
;05:D334 - 05:D568 X Z-Saber
;05:D568 - 05:D5FE X Ride Armor

org $85D6A8 ;Removes Zero & Zero Z-Saber VRAM
	padbyte $FF
	pad $85DC19

;05:D6A8 - 05:DB47 ;Zero
;05:DB47 - 05:DC19 ;Zero Z-Saber
	
org $83A822 ;Load base location of all Zero PC NPC events. Stop at PC Teleport.
	padbyte $FF
	pad $83A9EE
	
org $83A9FF ;Load base location of all Zero PC NPC events and remove data
	padbyte $FF
	pad $83AFBA
	
org $83AFD5 ;Stop at dialogue box then continue NOPing after
	padbyte $FF
	pad $83B508
	
org $83B53D ;Stop at wall explosion and continue after
	padbyte $FF
	pad $83B74D
	
org $83B76D ;Stop at PC NPC check walk
	padbyte $FF
	pad $83B767
	
org $83BA33 ;Remove end credits and credit roll
	padbyte $FF
	pad $83BA9D
	
org $81836B ;Original location of armor setup
	padbyte $FF
	pad $8183A0

org $81D533 ;Loads base JMP,x pointers for ammo capsules routine and their data
	padbyte $FF
	pad $81D60F
	
org $81D625 ;Loads original routine that stores health to sub-weapons
	padbyte $FF ;Completely blanks out so it can be rewritten
	pad $81D67B
	
org $80FA2F ;Loads original Interactive Object list and removes it entirely
	padbyte $FF
	pad $80FD20
	
org $84B006 ;Loads original code location for scrolling through sub-weapons with L/R
	padbyte $FF
	pad $84B097
	
org $80F49B ;Removes original pointers and JSL's for all Item Objects and select few circumstances.
	padbyte $FF
	pad $80F527
	
org $81E83D ;Loads basis for Heart Tank routine and removes it since it's moved now.
	padbyte $FF
	pad $81E88D

org $84CD95 ;Loads original code location for Hyper Charge gaining life upon being hit
	padbyte $EA
	pad $84CDF5
	
org $84AA62 ;Loads original code for Hyper Charge being checked to see if you can use it.
	padbyte $EA
	pad $84AABF
	
org $8697AD ;Loads original pointers and data for decompressed tile data in-game
	padbyte $FF
	pad $869B2A
	
org $80A3BC ;Loads original code to restore sub-weapon ammo upon entering a level
	padbyte $FF
	pad $80A3ED
	
org $80F7A8 ;Loads original code for all missile pointers and JSLs
	padbyte $FF ;All removed as they've been shoved into a new bank
	pad $80F7F4
	
org $80A678 ;Loads original code that sets X's Get Weapon palette on screen.
	padbyte $EA
	pad $80A69F
	
org $8385D2 ;Loads original code to check on stage select screen for Heart Tanks obtained per level
	padbyte $FF
	pad $83862F
	
org $84CE3C ;Loads Body Armor/Body Chip upgrade test for damage. Then removes a check for Ride Armor chips.
	padbyte $FF
	pad $84CE8F
	
org $81DAD2 ;Loads original Sub-Tank item object location and removes it since it's no longer used.
	padbyte $FF
	pad $81DB23
	
org $868EA9 ;Loads text data for 'OPENING DEMO' text which goes unused
	padbyte $FF
	pad $868EBA
	
org $86F47B ;Removes pointer location setup for X/Zero introduction graphics
	padbyte $FF
	pad $86F47D
	
org $86F6B4
	padbyte $FF
	pad $86F6BA
	
org $86FAA2 ;Removes pointer to X/Zero introduction graphic VRAM/Graphic ROM pointer
	padbyte $FF
	pad $86FAA7
	
org $A98D55 ;Removes pointer/VRAM data of X/Zero introduction graphic
	padbyte $FF
	pad $A9A31D
	
org $80CBB2 ;Routine that sets whether PC's can swap in menu or not
	padbyte $EA
	pad $80CC00

org $81D933 ;Blanks out the first portion of the 1-up icon event code
	padbyte $FF
	pad $81D96A
	
org $848D6D ;Blanks out entirety of PC swapping in-game command (Action #76)
	padbyte $FF
	pad $848E81
	
org $84D394 ;Blanks out entirety of original code that blanks out various enemy data upon entering a boss door
	padbyte $FF
	pad $84D3B3
	
org $80D521 ;Blanks out entire routine for PC's health bar in menu
	padbyte $FF
	pad $80D5B9
	
	
	
	
	
	
	
org $86F40D	;Removes pointer to compressed Password Screen Tile Map
	db $FF,$FF
	
org $86F57D ;Removes basis setup data for Password Screen Tile Map
	db $FF,$FF,$FF,$FF,$FF,$FF
	
org $86F953 ;Removes pointers and how many bytes to store into RAM for decompression of Password Screen Tile Map
	db $FF,$FF,$FF,$FF,$FF
	
org $A3F72A ;Removes entire password screen tile map decompression
	padbyte $FF
	pad $A3F90E
	
org $8182C7 ;Blanks out entirety of Password Screen cursor sprite setup
	padbyte $FF
	pad $81836B

org $80ED8C ;Blanks out entirety of Password Screen events
	padbyte $FF
	pad $80EFC9
	
org $80F3AE ;Blanks out something with sprite data on Password Screen (It's not needed anymore since the numbers no longer load on screen)
	padbyte $EA
	pad $80F3E4
	
org $80F44C ;Blanks out entirety of Password Screen 'Key Presses' routine since that's moved and expanded upon.
	padbyte $FF
	pad $80F471
	
	
	
	
org $80B0D8 ;Blanks out entire routine for 'Thank you for playing' scene
	padbyte $FF
	pad $80B11D
	
