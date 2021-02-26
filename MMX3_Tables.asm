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
;2. If Neon Tiger is hit with the Z-Saber wave (I think only when blocking?) it alters his palette... not sure why this would do that since Z-Saber Wave hasn't even been touched.
	;Can't reproduce this one.
;3. There's a bug for sure with the stats at $7E:F300. This HAS just been confirmed. It seems to possibly only occur when you're playing as Zero in Doppler Stage 1.
	;It writes RAM data to $7E:F200 but sometimes it can actually overlap into the $7E:F300 area. I'm not sure why quite yet.
	;Might possibly have to do with $82/C66A or $82/C66C or $82/C6E5 or something later in the code. It's very well possible that it's all due to the falling ceiling.
	;$82/C57F 20 43 C6  JSR $C643  [$82:C643] A:50DF X:0C74 Y:0008 P:envmxdIzC - Start of the routine
	;It's very possible that the PC stats will HAVE to be moved to $7E:F400 just to avoid any possibility of this happening anymore.

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
	
;Add in new code so when L/R are pressed at the same time, it sets the sub-weapon back to your buster.




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

incsrc MMX3_VariousImports.asm
incsrc MMX3_VariousAddresses.asm

;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Beginning of .ASM file. Writes ALL tables into a couple banks with excess room for more tables
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
org $86B353 ;Sub-weapon ammo usage
{
	db $05 ;UNUSED sub-weapon life value (Buster probably) ;This byte is used for the vertical dash. DO NOT MODIFY
	db $01 ;Acid Burst
	db $01 ;Parasitic Bomb
	db $01 ;Triad Thunder
	db $01 ;Spinning Blades
	db $01 ;Ray Splasher
	db $01 ;Gravity Well
	db $01 ;Frost Shield
	db $01 ;Tornado Fang
	db $04 ;Hyper Charge
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	
;Extra values that would go unused now
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED

org $86B368 ;Sub-weapon charged ammo usage
	db $05 ;UNUSED sub-weapon life value (Buster probably) ;This byte is used for the vertical dash. DO NOT MODIFY
	db $03 ;Acid Burst
	db $01 ;Parasitic Bomb
	db $03 ;Triad Thunder
	db $03 ;Spinning Blades
	db $03 ;Ray Splasher
	db $03 ;Gravity Well
	db $03 ;Frost Shield
	db $03 ;Tornado Fang
	db $00 ;Hyper Charge
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	
;Extra values that would go unused now
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
	db $FF ;UNUSED
}
org $86E290 ;Enemy Table Setup
{
	;Enemy #01 Unknown(Unused?) 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $67 ;Enemy Value?
		db $61 ;Sprite Assembly

	;Enemy #02 Unknown(Unused?) 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $1C ;Enemy Value?
		db $1A ;Sprite Assembly

	;Enemy #03 Blady  
		db $02 ;Collision Damage
		db $09 ;Enemy Health
		db $06 ;Damage Table
		db $02 ;Enemy Value?
		db $00 ;Sprite Assembly

	;Enemy #04 Instant Win  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $02 ;Enemy Value?
		db $00 ;Sprite Assembly

	;Enemy #05 Large Elevator 
		db $02 ;Collision Damage
		db $05 ;Enemy Health
		db $00 ;Damage Table
		db $09 ;Enemy Value?
		db $05 ;Sprite Assembly

	;Enemy #06 Earth Commander  
		db $02 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $03 ;Enemy Value?
		db $01 ;Sprite Assembly

	;Enemy #07 Unknown(Unused?) 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $04 ;Enemy Value?
		db $02 ;Sprite Assembly

	;Enemy #08 Notor Banger 
		db $02 ;Collision Damage
		db $09 ;Enemy Health
		db $03 ;Damage Table
		db $0A ;Enemy Value?
		db $06 ;Sprite Assembly

	;Enemy #09 Escanail 
		db $01 ;Collision Damage
		db $3F ;Enemy Health
		db $02 ;Damage Table
		db $14 ;Enemy Value?
		db $07 ;Sprite Assembly

	;Enemy #0A Carry Arm  
		db $02 ;Collision Damage
		db $12 ;Enemy Health
		db $02 ;Damage Table
		db $1F ;Enemy Value?
		db $08 ;Sprite Assembly

	;Enemy #0B Caterkiller (00-Right Wall, 80-Left Wall) 
		db $02 ;Collision Damage
		db $05 ;Enemy Health
		db $05 ;Damage Table
		db $15 ;Enemy Value?
		db $03 ;Sprite Assembly

	;Enemy #0C Drimole-W  
		db $04 ;Collision Damage
		db $12 ;Enemy Health
		db $02 ;Damage Table
		db $16 ;Enemy Value?
		db $04 ;Sprite Assembly

	;Enemy #0D Helit  
		db $02 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $24 ;Enemy Value?
		db $16 ;Sprite Assembly

	;Enemy #0E Wall Cancer (00-Right Wall, 01-Left Wall) 
		db $02 ;Collision Damage
		db $0C ;Enemy Health
		db $05 ;Damage Table
		db $2C ;Enemy Value?
		db $2B ;Sprite Assembly

	;Enemy #0F Blast Hornet Airship Event  
		db $00 ;Collision Damage
		db $05 ;Enemy Health
		db $0D ;Damage Table
		db $23 ;Enemy Value?
		db $15 ;Sprite Assembly

	;Enemy #10 Unknown(Unused?) 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $20 ;Enemy Value?
		db $11 ;Sprite Assembly

	;Enemy #11 Crablaster (00-Floor, B0-Ceiling) 
		db $02 ;Collision Damage
		db $0C ;Enemy Health
		db $02 ;Damage Table
		db $2F ;Enemy Value?
		db $2E ;Sprite Assembly

	;Enemy #12 Blizzard Buffalo Ice Break  
		db $00 ;Collision Damage
		db $0A ;Enemy Health
		db $0E ;Damage Table
		db $2C ;Enemy Value?
		db $2B ;Sprite Assembly

	;Enemy #13 Blast Hornet Wall Break 
		db $00 ;Collision Damage
		db $0A ;Enemy Health
		db $0E ;Damage Table
		db $26 ;Enemy Value?
		db $1E ;Sprite Assembly

	;Enemy #14 Spycopter  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $1E ;Enemy Value?
		db $25 ;Sprite Assembly

	;Enemy #15 Ride Armor (Test Boss) 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $2B ;Enemy Value?
		db $29 ;Sprite Assembly

	;Enemy #16 Meta-Capsule (00-Floor, 01-Ceiling) 
		db $02 ;Collision Damage
		db $05 ;Enemy Health
		db $04 ;Damage Table
		db $27 ;Enemy Value?
		db $1F ;Sprite Assembly

	;Enemy #17 Spycopter Large  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $2A ;Enemy Value?
		db $28 ;Sprite Assembly

	;Enemy #18 Head Gunner  
		db $02 ;Collision Damage
		db $0C ;Enemy Health
		db $04 ;Damage Table
		db $02 ;Enemy Value?
		db $00 ;Sprite Assembly

	;Enemy #19 Medium Elevator  
		db $02 ;Collision Damage
		db $05 ;Enemy Health
		db $00 ;Damage Table
		db $02 ;Enemy Value?
		db $00 ;Sprite Assembly

	;Enemy #1A Crush Crawfish Wall Break 
		db $01 ;Collision Damage
		db $0F ;Enemy Health
		db $0C ;Damage Table
		db $32 ;Enemy Value?
		db $31 ;Sprite Assembly

	;Enemy #1B Ganseki Carrier Ball 
		db $02 ;Collision Damage
		db $05 ;Enemy Health
		db $0C ;Damage Table
		db $31 ;Enemy Value?
		db $30 ;Sprite Assembly

	;Enemy #1C Mine Tortoise  
		db $02 ;Collision Damage
		db $09 ;Enemy Health
		db $03 ;Damage Table
		db $29 ;Enemy Value?
		db $21 ;Sprite Assembly

	;Enemy #1D Wild Tank  
		db $04 ;Collision Damage
		db $12 ;Enemy Health
		db $04 ;Damage Table
		db $28 ;Enemy Value?
		db $20 ;Sprite Assembly

	;Enemy #1E Victoroid (00-Normal, 01-Custom)  
		db $04 ;Collision Damage
		db $1C ;Enemy Health
		db $02 ;Damage Table
		db $47 ;Enemy Value?
		db $4A ;Sprite Assembly

	;Enemy #1F Tombort  
		db $01 ;Collision Damage [Unused]
		db $0F ;Enemy Health
		db $09 ;Damage Table
		db $42 ;Enemy Value?
		db $45 ;Sprite Assembly

	;Enemy #20 Intro Falling Ceiling  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $00 ;Damage Table
		db $44 ;Enemy Value?
		db $47 ;Sprite Assembly

	;Enemy #21 Intro Glass Shatter  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $00 ;Damage Table
		db $48 ;Enemy Value?
		db $4B ;Sprite Assembly

	;Enemy #22 Atareeter  
		db $04 ;Collision Damage
		db $1C ;Enemy Health
		db $04 ;Damage Table
		db $21 ;Enemy Value?
		db $12 ;Sprite Assembly

	;Enemy #23 Snow Slider(00)/Rider(02) 
		db $03 ;Collision Damage
		db $09 ;Enemy Health
		db $02 ;Damage Table
		db $43 ;Enemy Value?
		db $46 ;Sprite Assembly

	;Enemy #24 Blizzard Buffalo Snowfall 
		db $01 ;Collision Damage
		db $20 ;Enemy Health
		db $02 ;Damage Table
		db $40 ;Enemy Value?
		db $3D ;Sprite Assembly

	;Enemy #25 Gravity Beetle Falling Floor  
		db $01 ;Collision Damage
		db $01 ;Enemy Health
		db $00 ;Damage Table
		db $41 ;Enemy Value?
		db $3F ;Sprite Assembly

	;Enemy #26 Small Elevator 
		db $01 ;Collision Damage
		db $01 ;Enemy Health
		db $00 ;Damage Table
		db $49 ;Enemy Value?
		db $4E ;Sprite Assembly

	;Enemy #27 Worm Seeker-R  
		db $04 ;Collision Damage
		db $40 ;Enemy Health
		db $21 ;Damage Table
		db $59 ;Enemy Value?
		db $50 ;Sprite Assembly

	;Enemy #28 Walk Blaster 
		db $03 ;Collision Damage
		db $0F ;Enemy Health
		db $02 ;Damage Table
		db $5A ;Enemy Value?
		db $57 ;Sprite Assembly

	;Enemy #29 De Voux  
		db $02 ;Collision Damage
		db $0A ;Enemy Health
		db $02 ;Damage Table
		db $35 ;Enemy Value?
		db $47 ;Sprite Assembly

	;Enemy #2A Crush Crawfish Power Generator  
		db $01 ;Collision Damage
		db $0F ;Enemy Health
		db $02 ;Damage Table
		db $58 ;Enemy Value?
		db $4F ;Sprite Assembly

	;Enemy #2B Drill Waying 
		db $03 ;Collision Damage
		db $0F ;Enemy Health
		db $02 ;Damage Table
		db $67 ;Enemy Value?
		db $5E ;Sprite Assembly

	;Enemy #2C Genjibo (Loads Shurikein) 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $0E ;Damage Table
		db $66 ;Enemy Value?
		db $5D ;Sprite Assembly

	;Enemy #2D Hamma Hamma  
		db $03 ;Collision Damage
		db $1F ;Enemy Health
		db $02 ;Damage Table
		db $37 ;Enemy Value?
		db $32 ;Sprite Assembly

	;Enemy #2E Sigma Lava 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $3F ;Enemy Value?
		db $3C ;Sprite Assembly

	;Enemy #2F Unknown (Sometimes Teleport Sometimes Ride Armor Pad) 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $B5 ;Enemy Value?
		db $A9 ;Sprite Assembly

	;Enemy #30 Hell Crusher 
		db $02 ;Collision Damage
		db $20 ;Enemy Health
		db $19 ;Damage Table
		db $72 ;Enemy Value?
		db $62 ;Sprite Assembly

	;Enemy #31 Vile Factory Elevator Shaft 
		db $01 ;Collision Damage
		db $01 ;Enemy Health
		db $00 ;Damage Table
		db $80 ;Enemy Value?
		db $A8 ;Sprite Assembly

	;Enemy #32 Electric Spark Vertical 
		db $02 ;Collision Damage
		db $05 ;Enemy Health
		db $0E ;Damage Table
		db $84 ;Enemy Value?
		db $AC ;Sprite Assembly

	;Enemy #33 Falling Rock 
		db $04 ;Collision Damage
		db $20 ;Enemy Health
		db $02 ;Damage Table
		db $84 ;Enemy Value?
		db $AC ;Sprite Assembly

	;Enemy #34 Tunnel Rhino Boulder Blockade 
		db $04 ;Collision Damage
		db $07 ;Enemy Health
		db $08 ;Damage Table
		db $91 ;Enemy Value?
		db $8A ;Sprite Assembly

	;Enemy #35 Ganseki Carrier (01-Boulder)  
		db $04 ;Collision Damage
		db $0C ;Enemy Health
		db $02 ;Damage Table
		db $9A ;Enemy Value?
		db $C0 ;Sprite Assembly

	;Enemy #36 Doppler One Spike Ceiling 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $0E ;Damage Table
		db $73 ;Enemy Value?
		db $70 ;Sprite Assembly

	;Enemy #37 Gravity Well Elevator  
		db $01 ;Collision Damage
		db $01 ;Enemy Health
		db $11 ;Damage Table
		db $98 ;Enemy Value?
		db $BE ;Sprite Assembly

	;Enemy #38 Doppler Wall Crushers  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $0E ;Damage Table
		db $97 ;Enemy Value?
		db $BD ;Sprite Assembly

	;Enemy #39 Vile Falling Floor 
		db $01 ;Collision Damage
		db $01 ;Enemy Health
		db $03 ;Damage Table
		db $00 ;Enemy Value?
		db $00 ;Sprite Assembly

	;Enemy #3A Volt Catfish Ride Armor Floor 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $99 ;Enemy Value?
		db $BF ;Sprite Assembly

	;Enemy #3B Crush Crawfish Floor Generator? 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $00 ;Damage Table
		db $61 ;Enemy Value?
		db $62 ;Sprite Assembly

	;Enemy #3C Crush Crawfish Ride Armor Floor 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $23 ;Damage Table
		db $9B ;Enemy Value?
		db $C6 ;Sprite Assembly

	;Enemy #3D Trapper  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $0C ;Damage Table
		db $B9 ;Enemy Value?
		db $D8 ;Sprite Assembly

	;Enemy #3E REX-2000 Spike Ceiling 
		db $01 ;Collision Damage
		db $20 ;Enemy Health
		db $02 ;Damage Table
		db $01 ;Enemy Value?
		db $09 ;Sprite Assembly

	;Enemy #3F Tunnel Rhino Mud 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $02 ;Damage Table
		db $99 ;Enemy Value?
		db $BF ;Sprite Assembly

	;Enemy #40 Vile Countdown 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $00 ;Damage Table
		db $77 ;Enemy Value?
		db $79 ;Sprite Assembly

	;Enemy #41 Unknown(Unused?) 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $23 ;Enemy Value?
		db $15 ;Sprite Assembly

	;Enemy #42 Hotareeca  
		db $02 ;Collision Damage
		db $20 ;Enemy Health
		db $1A ;Damage Table
		db $74 ;Enemy Value?
		db $75 ;Sprite Assembly

	;Enemy #43 Godkarmachine O Inary Parts 
		db $06 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $73 ;Enemy Value?
		db $74 ;Sprite Assembly

	;Enemy #44 Kaiser Sigma Parts 
		db $08 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $7C ;Enemy Value?
		db $73 ;Sprite Assembly

	;Enemy #45 Godkarmachine O Inary Loader  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $8A ;Enemy Value?
		db $6E ;Sprite Assembly

	;Enemy #46 Bit  
		db $02 ;Collision Damage
		db $20 ;Enemy Health
		db $1A ;Damage Table
		db $AD ;Enemy Value?
		db $CC ;Sprite Assembly

	;Enemy #47 Byte 
		db $02 ;Collision Damage
		db $20 ;Enemy Health
		db $1B ;Damage Table
		db $94 ;Enemy Value?
		db $9A ;Sprite Assembly

	;Enemy #48 Dr. Doppler  
		db $03 ;Collision Damage
		db $20 ;Enemy Health
		db $1E ;Damage Table
		db $22 ;Enemy Value?
		db $33 ;Sprite Assembly

	;Enemy #49 Vile (Ride Armor)
		db $04 ;Collision Damage
		db $20 ;Enemy Health
		db $1C ;Damage Table
		db $A0 ;Enemy Value?
		db $C8 ;Sprite Assembly

	;Enemy #4A Volt Kurageil  
		db $04 ;Collision Damage
		db $20 ;Enemy Health
		db $1A ;Damage Table
		db $2C ;Enemy Value?
		db $2B ;Sprite Assembly

	;Enemy #4B Blast Hornet Boxes 
		db $00 ;Collision Damage
		db $05 ;Enemy Health
		db $0E ;Damage Table
		db $46 ;Enemy Value?
		db $49 ;Sprite Assembly

	;Enemy #4C Blast Hornet Ride Armor 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $02 ;Damage Table
		db $88 ;Enemy Value?
		db $88 ;Sprite Assembly

	;Enemy #4D Dr. Light Capsule  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $1E ;Enemy Value?
		db $1C ;Sprite Assembly

	;Enemy #4E Dr. Light Lightning Strike  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $15 ;Enemy Value?
		db $15 ;Sprite Assembly

	;Enemy #4F Shurikein  
		db $03 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $45 ;Enemy Value?
		db $48 ;Sprite Assembly

	;Enemy #50 Maoh The Giant 
		db $01 ;Collision Damage
		db $20 ;Enemy Health
		db $10 ;Damage Table
		db $86 ;Enemy Value?
		db $65 ;Sprite Assembly

	;Enemy #51 REX-2000 
		db $03 ;Collision Damage
		db $20 ;Enemy Health
		db $10 ;Damage Table
		db $61 ;Enemy Value?
		db $5A ;Sprite Assembly

	;Enemy #52 Blizzard Buffalo 
		db $03 ;Collision Damage
		db $20 ;Enemy Health
		db $13 ;Damage Table
		db $52 ;Enemy Value?
		db $23 ;Sprite Assembly

	;Enemy #53 Blast Hornet 
		db $03 ;Collision Damage
		db $20 ;Enemy Health
		db $12 ;Damage Table
		db $68 ;Enemy Value?
		db $5F ;Sprite Assembly

	;Enemy #54 Crush Crawfish 
		db $04 ;Collision Damage
		db $20 ;Enemy Health
		db $17 ;Damage Table
		db $25 ;Enemy Value?
		db $1D ;Sprite Assembly

	;Enemy #55 Tunnel Rhino 
		db $03 ;Collision Damage
		db $20 ;Enemy Health
		db $18 ;Damage Table
		db $79 ;Enemy Value?
		db $26 ;Sprite Assembly

	;Enemy #56 Neon Tiger 
		db $03 ;Collision Damage
		db $20 ;Enemy Health
		db $19 ;Damage Table
		db $92 ;Enemy Value?
		db $99 ;Sprite Assembly

	;Enemy #57 Toxic Seahorse 
		db $02 ;Collision Damage
		db $20 ;Enemy Health
		db $15 ;Damage Table
		db $AE ;Enemy Value?
		db $CD ;Sprite Assembly

	;Enemy #58 Volt Catfish 
		db $02 ;Collision Damage
		db $20 ;Enemy Health
		db $16 ;Damage Table
		db $5B ;Enemy Value?
		db $59 ;Sprite Assembly

	;Enemy #59 Gravity Beetle 
		db $03 ;Collision Damage
		db $20 ;Enemy Health
		db $14 ;Damage Table
		db $85 ;Enemy Value?
		db $AB ;Sprite Assembly

	;Enemy #5A Press Disposer 
		db $03 ;Collision Damage
		db $20 ;Enemy Health
		db $1B ;Damage Table
		db $82 ;Enemy Value?
		db $AA ;Sprite Assembly

	;Enemy #5B Mosquitus  
		db $03 ;Collision Damage
		db $20 ;Enemy Health
		db $10 ;Damage Table
		db $89 ;Enemy Value?
		db $89 ;Sprite Assembly

	;Enemy #5C Dr. Light  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $69 ;Enemy Value?
		db $D0 ;Sprite Assembly

	;Enemy #5D Godkarmachine O Inary  
		db $06 ;Collision Damage
		db $20 ;Enemy Health
		db $14 ;Damage Table
		db $B1 ;Enemy Value?
		db $CE ;Sprite Assembly

	;Enemy #5E Sigma  
		db $04 ;Collision Damage
		db $20 ;Enemy Health
		db $1F ;Damage Table
		db $9B ;Enemy Value?
		db $8F ;Sprite Assembly

	;Enemy #5F Kaiser Sigma 
		db $08 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $9B ;Enemy Value?
		db $8F ;Sprite Assembly

	;Enemy #60 Sigma Virus  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $77 ;Enemy Value?
		db $74 ;Sprite Assembly

	;Enemy #61 Vile 
		db $04 ;Collision Damage
		db $20 ;Enemy Health
		db $1C ;Damage Table
		db $8C ;Enemy Value?
		db $72 ;Sprite Assembly

	;Enemy #62 Mac  
		db $02 ;Collision Damage
		db $20 ;Enemy Health
		db $24 ;Damage Table
		db $9C ;Enemy Value?
		db $C7 ;Sprite Assembly

	;Enemy #63 Vile (Goliath)
		db $06 ;Collision Damage
		db $20 ;Enemy Health
		db $1D ;Damage Table
		db $9D ;Enemy Value?
		db $96 ;Sprite Assembly

	;Enemy #64 Sigma Virus Event  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $30 ;Enemy Value?
		db $2F ;Sprite Assembly

	;Enemy #65 Placed In Doppler Boss Room 
		db $01 ;Collision Damage
		db $40 ;Enemy Health
		db $02 ;Damage Table
		db $53 ;Enemy Value?
		db $51 ;Sprite Assembly

	;Enemy #66 Boss End Portrait Loader  
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $94 ;Enemy Value?
		db $9B ;Sprite Assembly

	;Enemy #67 Unknown(Unused?) 
		db $01 ;Collision Damage
		db $20 ;Enemy Health
		db $20 ;Damage Table
		db $3A ;Enemy Value?
		db $39 ;Sprite Assembly

	;Enemy #68 BROKEN 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $A9 ;Enemy Value?
		db $D2 ;Sprite Assembly

	;Enemy #69 Boss Selected Screen 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $39 ;Enemy Value?
		db $3D ;Sprite Assembly

	;Enemy #6A Unknown(Unused?) 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $3A ;Enemy Value?
		db $39 ;Sprite Assembly

	;Enemy #6B Unknown(Unused?) 
		db $01 ;Collision Damage
		db $05 ;Enemy Health
		db $03 ;Damage Table
		db $92 ;Enemy Value?
		db $00 ;Sprite Assembly
}
org $86E290 ;Enemy Table Setup (ORIGINAL) [COMMENTED OUT]
{
	; ;Enemy #01 Unknown(Unused?) 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $67 ;Enemy Value?
		; db $61 ;Sprite Assembly

	; ;Enemy #02 Unknown(Unused?) 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $1C ;Enemy Value?
		; db $1A ;Sprite Assembly

	; ;Enemy #03 Blady  
		; db $02 ;Collision Damage
		; db $09 ;Enemy Health
		; db $06 ;Damage Table
		; db $02 ;Enemy Value?
		; db $00 ;Sprite Assembly

	; ;Enemy #04 Instant Win  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $02 ;Enemy Value?
		; db $00 ;Sprite Assembly

	; ;Enemy #05 Large Elevator 
		; db $02 ;Collision Damage
		; db $05 ;Enemy Health
		; db $00 ;Damage Table
		; db $09 ;Enemy Value?
		; db $05 ;Sprite Assembly

	; ;Enemy #06 Earth Commander  
		; db $02 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $03 ;Enemy Value?
		; db $01 ;Sprite Assembly

	; ;Enemy #07 Unknown(Unused?) 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $04 ;Enemy Value?
		; db $02 ;Sprite Assembly

	; ;Enemy #08 Notor Banger 
		; db $02 ;Collision Damage
		; db $09 ;Enemy Health
		; db $03 ;Damage Table
		; db $0A ;Enemy Value?
		; db $06 ;Sprite Assembly

	; ;Enemy #09 Escanail 
		; db $01 ;Collision Damage
		; db $3F ;Enemy Health
		; db $02 ;Damage Table
		; db $14 ;Enemy Value?
		; db $07 ;Sprite Assembly

	; ;Enemy #0A Carry Arm  
		; db $02 ;Collision Damage
		; db $12 ;Enemy Health
		; db $02 ;Damage Table
		; db $1F ;Enemy Value?
		; db $08 ;Sprite Assembly

	; ;Enemy #0B Caterkiller (00-Right Wall, 80-Left Wall) 
		; db $02 ;Collision Damage
		; db $05 ;Enemy Health
		; db $05 ;Damage Table
		; db $15 ;Enemy Value?
		; db $03 ;Sprite Assembly

	; ;Enemy #0C Drimole-W  
		; db $04 ;Collision Damage
		; db $12 ;Enemy Health
		; db $02 ;Damage Table
		; db $16 ;Enemy Value?
		; db $04 ;Sprite Assembly

	; ;Enemy #0D Helit  
		; db $02 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $24 ;Enemy Value?
		; db $16 ;Sprite Assembly

	; ;Enemy #0E Wall Cancer (00-Right Wall, 01-Left Wall) 
		; db $02 ;Collision Damage
		; db $0C ;Enemy Health
		; db $05 ;Damage Table
		; db $2C ;Enemy Value?
		; db $2B ;Sprite Assembly

	; ;Enemy #0F Blast Hornet Airship Event  
		; db $00 ;Collision Damage
		; db $05 ;Enemy Health
		; db $0D ;Damage Table
		; db $23 ;Enemy Value?
		; db $15 ;Sprite Assembly

	; ;Enemy #10 Unknown(Unused?) 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $20 ;Enemy Value?
		; db $11 ;Sprite Assembly

	; ;Enemy #11 Crablaster (00-Floor, B0-Ceiling) 
		; db $02 ;Collision Damage
		; db $0C ;Enemy Health
		; db $02 ;Damage Table
		; db $2F ;Enemy Value?
		; db $2E ;Sprite Assembly

	; ;Enemy #12 Blizzard Buffalo Ice Break  
		; db $00 ;Collision Damage
		; db $0A ;Enemy Health
		; db $0E ;Damage Table
		; db $2C ;Enemy Value?
		; db $2B ;Sprite Assembly

	; ;Enemy #13 Blast Hornet Wall Break 
		; db $00 ;Collision Damage
		; db $0A ;Enemy Health
		; db $0E ;Damage Table
		; db $26 ;Enemy Value?
		; db $1E ;Sprite Assembly

	; ;Enemy #14 Spycopter  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $1E ;Enemy Value?
		; db $25 ;Sprite Assembly

	; ;Enemy #15 Ride Armor (Test Boss) 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $2B ;Enemy Value?
		; db $29 ;Sprite Assembly

	; ;Enemy #16 Meta-Capsule (00-Floor, 01-Ceiling) 
		; db $02 ;Collision Damage
		; db $05 ;Enemy Health
		; db $04 ;Damage Table
		; db $27 ;Enemy Value?
		; db $1F ;Sprite Assembly

	; ;Enemy #17 Spycopter Large  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $2A ;Enemy Value?
		; db $28 ;Sprite Assembly

	; ;Enemy #18 Head Gunner  
		; db $04 ;Collision Damage
		; db $0C ;Enemy Health
		; db $04 ;Damage Table
		; db $02 ;Enemy Value?
		; db $00 ;Sprite Assembly

	; ;Enemy #19 Medium Elevator  
		; db $02 ;Collision Damage
		; db $05 ;Enemy Health
		; db $00 ;Damage Table
		; db $02 ;Enemy Value?
		; db $00 ;Sprite Assembly

	; ;Enemy #1A Crush Crawfish Wall Break 
		; db $01 ;Collision Damage
		; db $0F ;Enemy Health
		; db $0C ;Damage Table
		; db $32 ;Enemy Value?
		; db $31 ;Sprite Assembly

	; ;Enemy #1B Ganseki Carrier Ball 
		; db $02 ;Collision Damage
		; db $05 ;Enemy Health
		; db $0C ;Damage Table
		; db $31 ;Enemy Value?
		; db $30 ;Sprite Assembly

	; ;Enemy #1C Mine Tortoise  
		; db $02 ;Collision Damage
		; db $09 ;Enemy Health
		; db $03 ;Damage Table
		; db $29 ;Enemy Value?
		; db $21 ;Sprite Assembly

	; ;Enemy #1D Wild Tank  
		; db $04 ;Collision Damage
		; db $12 ;Enemy Health
		; db $04 ;Damage Table
		; db $28 ;Enemy Value?
		; db $20 ;Sprite Assembly

	; ;Enemy #1E Victoroid (00-Normal, 01-Custom)  
		; db $08 ;Collision Damage
		; db $1E ;Enemy Health
		; db $02 ;Damage Table
		; db $47 ;Enemy Value?
		; db $4A ;Sprite Assembly

	; ;Enemy #1F Tombort  
		; db $06 ;Collision Damage
		; db $12 ;Enemy Health
		; db $09 ;Damage Table
		; db $42 ;Enemy Value?
		; db $45 ;Sprite Assembly

	; ;Enemy #20 Intro Falling Ceiling  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $00 ;Damage Table
		; db $44 ;Enemy Value?
		; db $47 ;Sprite Assembly

	; ;Enemy #21 Intro Glass Shatter  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $00 ;Damage Table
		; db $48 ;Enemy Value?
		; db $4B ;Sprite Assembly

	; ;Enemy #22 Atareeter  
		; db $08 ;Collision Damage
		; db $1E ;Enemy Health
		; db $04 ;Damage Table
		; db $21 ;Enemy Value?
		; db $12 ;Sprite Assembly

	; ;Enemy #23 Snow Slider(00)/Rider(02) 
		; db $03 ;Collision Damage
		; db $09 ;Enemy Health
		; db $02 ;Damage Table
		; db $43 ;Enemy Value?
		; db $46 ;Sprite Assembly

	; ;Enemy #24 Blizzard Buffalo Snowfall 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $02 ;Damage Table
		; db $40 ;Enemy Value?
		; db $3D ;Sprite Assembly

	; ;Enemy #25 Gravity Beetle Falling Floor  
		; db $01 ;Collision Damage
		; db $01 ;Enemy Health
		; db $00 ;Damage Table
		; db $41 ;Enemy Value?
		; db $3F ;Sprite Assembly

	; ;Enemy #26 Small Elevator 
		; db $01 ;Collision Damage
		; db $01 ;Enemy Health
		; db $00 ;Damage Table
		; db $49 ;Enemy Value?
		; db $4E ;Sprite Assembly

	; ;Enemy #27 Worm Seeker-R  
		; db $04 ;Collision Damage
		; db $40 ;Enemy Health
		; db $21 ;Damage Table
		; db $59 ;Enemy Value?
		; db $50 ;Sprite Assembly

	; ;Enemy #28 Walk Blaster 
		; db $03 ;Collision Damage
		; db $0F ;Enemy Health
		; db $02 ;Damage Table
		; db $5A ;Enemy Value?
		; db $57 ;Sprite Assembly

	; ;Enemy #29 De Voux  
		; db $02 ;Collision Damage
		; db $0A ;Enemy Health
		; db $02 ;Damage Table
		; db $35 ;Enemy Value?
		; db $47 ;Sprite Assembly

	; ;Enemy #2A Crush Crawfish Power Generator  
		; db $01 ;Collision Damage
		; db $0F ;Enemy Health
		; db $02 ;Damage Table
		; db $58 ;Enemy Value?
		; db $4F ;Sprite Assembly

	; ;Enemy #2B Drill Waying 
		; db $03 ;Collision Damage
		; db $0F ;Enemy Health
		; db $02 ;Damage Table
		; db $67 ;Enemy Value?
		; db $5E ;Sprite Assembly

	; ;Enemy #2C Genjibo (Loads Shurikein) 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $0E ;Damage Table
		; db $66 ;Enemy Value?
		; db $5D ;Sprite Assembly

	; ;Enemy #2D Hamma Hamma  
		; db $03 ;Collision Damage
		; db $1F ;Enemy Health
		; db $02 ;Damage Table
		; db $37 ;Enemy Value?
		; db $32 ;Sprite Assembly

	; ;Enemy #2E Sigma Lava 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $3F ;Enemy Value?
		; db $3C ;Sprite Assembly

	; ;Enemy #2F Unknown(Sometimes Teleport Sometimes Ride Armor Pad) 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $B5 ;Enemy Value?
		; db $A9 ;Sprite Assembly

	; ;Enemy #30 Hell Crusher 
		; db $02 ;Collision Damage
		; db $20 ;Enemy Health
		; db $19 ;Damage Table
		; db $72 ;Enemy Value?
		; db $62 ;Sprite Assembly

	; ;Enemy #31 Vile Factory Elevator Shaft 
		; db $01 ;Collision Damage
		; db $01 ;Enemy Health
		; db $00 ;Damage Table
		; db $80 ;Enemy Value?
		; db $A8 ;Sprite Assembly

	; ;Enemy #32 Electric Spark Vertical 
		; db $02 ;Collision Damage
		; db $05 ;Enemy Health
		; db $0E ;Damage Table
		; db $84 ;Enemy Value?
		; db $AC ;Sprite Assembly

	; ;Enemy #33 Falling Rock 
		; db $04 ;Collision Damage
		; db $20 ;Enemy Health
		; db $02 ;Damage Table
		; db $84 ;Enemy Value?
		; db $AC ;Sprite Assembly

	; ;Enemy #34 Tunnel Rhino Boulder Blockade 
		; db $04 ;Collision Damage
		; db $07 ;Enemy Health
		; db $08 ;Damage Table
		; db $91 ;Enemy Value?
		; db $8A ;Sprite Assembly

	; ;Enemy #35 Ganseki Carrier (01-Boulder)  
		; db $04 ;Collision Damage
		; db $0C ;Enemy Health
		; db $02 ;Damage Table
		; db $9A ;Enemy Value?
		; db $C0 ;Sprite Assembly

	; ;Enemy #36 Doppler One Spike Ceiling 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $0E ;Damage Table
		; db $73 ;Enemy Value?
		; db $70 ;Sprite Assembly

	; ;Enemy #37 Gravity Well Elevator  
		; db $01 ;Collision Damage
		; db $01 ;Enemy Health
		; db $11 ;Damage Table
		; db $98 ;Enemy Value?
		; db $BE ;Sprite Assembly

	; ;Enemy #38 Doppler Wall Crushers  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $0E ;Damage Table
		; db $97 ;Enemy Value?
		; db $BD ;Sprite Assembly

	; ;Enemy #39 Vile Falling Floor 
		; db $01 ;Collision Damage
		; db $01 ;Enemy Health
		; db $03 ;Damage Table
		; db $00 ;Enemy Value?
		; db $00 ;Sprite Assembly

	; ;Enemy #3A Volt Catfish Ride Armor Floor 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $99 ;Enemy Value?
		; db $BF ;Sprite Assembly

	; ;Enemy #3B Crush Crawfish Floor Generator? 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $00 ;Damage Table
		; db $61 ;Enemy Value?
		; db $62 ;Sprite Assembly

	; ;Enemy #3C Crush Crawfish Ride Armor Floor 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $23 ;Damage Table
		; db $9B ;Enemy Value?
		; db $C6 ;Sprite Assembly

	; ;Enemy #3D Trapper  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $0C ;Damage Table
		; db $B9 ;Enemy Value?
		; db $D8 ;Sprite Assembly

	; ;Enemy #3E REX-2000 Spike Ceiling 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $02 ;Damage Table
		; db $01 ;Enemy Value?
		; db $09 ;Sprite Assembly

	; ;Enemy #3F Tunnel Rhino Mud 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $02 ;Damage Table
		; db $99 ;Enemy Value?
		; db $BF ;Sprite Assembly

	; ;Enemy #40 Vile Countdown 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $00 ;Damage Table
		; db $77 ;Enemy Value?
		; db $79 ;Sprite Assembly

	; ;Enemy #41 Unknown(Unused?) 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $23 ;Enemy Value?
		; db $15 ;Sprite Assembly

	; ;Enemy #42 Hotareeca  
		; db $02 ;Collision Damage
		; db $20 ;Enemy Health
		; db $1A ;Damage Table
		; db $74 ;Enemy Value?
		; db $75 ;Sprite Assembly

	; ;Enemy #43 Godkarmachine O Inary Parts 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $73 ;Enemy Value?
		; db $74 ;Sprite Assembly

	; ;Enemy #44 Kaiser Sigma Parts 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $7C ;Enemy Value?
		; db $73 ;Sprite Assembly

	; ;Enemy #45 Godkarmachine O Inary Loader  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $8A ;Enemy Value?
		; db $6E ;Sprite Assembly

	; ;Enemy #46 Bit  
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $1A ;Damage Table
		; db $AD ;Enemy Value?
		; db $CC ;Sprite Assembly

	; ;Enemy #47 Byte 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $1B ;Damage Table
		; db $94 ;Enemy Value?
		; db $9A ;Sprite Assembly

	; ;Enemy #48 Dr. Doppler  
		; db $06 ;Collision Damage
		; db $20 ;Enemy Health
		; db $1E ;Damage Table
		; db $22 ;Enemy Value?
		; db $33 ;Sprite Assembly

	; ;Enemy #49 Vile Ride Armor  
		; db $02 ;Collision Damage
		; db $20 ;Enemy Health
		; db $1C ;Damage Table
		; db $A0 ;Enemy Value?
		; db $C8 ;Sprite Assembly

	; ;Enemy #4A Volt Kurageil  
		; db $06 ;Collision Damage
		; db $20 ;Enemy Health
		; db $1A ;Damage Table
		; db $2C ;Enemy Value?
		; db $2B ;Sprite Assembly

	; ;Enemy #4B Blast Hornet Boxes 
		; db $00 ;Collision Damage
		; db $05 ;Enemy Health
		; db $0E ;Damage Table
		; db $46 ;Enemy Value?
		; db $49 ;Sprite Assembly

	; ;Enemy #4C Blast Hornet Ride Armor 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $02 ;Damage Table
		; db $88 ;Enemy Value?
		; db $88 ;Sprite Assembly

	; ;Enemy #4D Dr. Light Capsule  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $1E ;Enemy Value?
		; db $1C ;Sprite Assembly

	; ;Enemy #4E Dr. Light Lightning Strike  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $15 ;Enemy Value?
		; db $15 ;Sprite Assembly

	; ;Enemy #4F Shurikein  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $45 ;Enemy Value?
		; db $48 ;Sprite Assembly

	; ;Enemy #50 Maoh The Giant 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $10 ;Damage Table
		; db $86 ;Enemy Value?
		; db $65 ;Sprite Assembly

	; ;Enemy #51 REX-2000 
		; db $08 ;Collision Damage
		; db $20 ;Enemy Health
		; db $10 ;Damage Table
		; db $61 ;Enemy Value?
		; db $5A ;Sprite Assembly

	; ;Enemy #52 Blizzard Buffalo 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $13 ;Damage Table
		; db $52 ;Enemy Value?
		; db $23 ;Sprite Assembly

	; ;Enemy #53 Blast Hornet 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $12 ;Damage Table
		; db $68 ;Enemy Value?
		; db $5F ;Sprite Assembly

	; ;Enemy #54 Crush Crawfish 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $17 ;Damage Table
		; db $25 ;Enemy Value?
		; db $1D ;Sprite Assembly

	; ;Enemy #55 Tunnel Rhino 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $18 ;Damage Table
		; db $79 ;Enemy Value?
		; db $26 ;Sprite Assembly

	; ;Enemy #56 Neon Tiger 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $19 ;Damage Table
		; db $92 ;Enemy Value?
		; db $99 ;Sprite Assembly

	; ;Enemy #57 Toxic Seahorse 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $15 ;Damage Table
		; db $AE ;Enemy Value?
		; db $CD ;Sprite Assembly

	; ;Enemy #58 Volt Catfish 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $16 ;Damage Table
		; db $5B ;Enemy Value?
		; db $59 ;Sprite Assembly

	; ;Enemy #59 Gravity Beetle 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $14 ;Damage Table
		; db $85 ;Enemy Value?
		; db $AB ;Sprite Assembly

	; ;Enemy #5A Press Disposer 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $1B ;Damage Table
		; db $82 ;Enemy Value?
		; db $AA ;Sprite Assembly

	; ;Enemy #5B Mosquitus  
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $10 ;Damage Table
		; db $89 ;Enemy Value?
		; db $89 ;Sprite Assembly

	; ;Enemy #5C Dr. Light  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $69 ;Enemy Value?
		; db $D0 ;Sprite Assembly

	; ;Enemy #5D Godkarmachine O Inary  
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $14 ;Damage Table
		; db $B1 ;Enemy Value?
		; db $CE ;Sprite Assembly

	; ;Enemy #5E Sigma  
		; db $08 ;Collision Damage
		; db $20 ;Enemy Health
		; db $1F ;Damage Table
		; db $9B ;Enemy Value?
		; db $8F ;Sprite Assembly

	; ;Enemy #5F Kaiser Sigma 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $9B ;Enemy Value?
		; db $8F ;Sprite Assembly

	; ;Enemy #60 Sigma Virus  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $77 ;Enemy Value?
		; db $74 ;Sprite Assembly

	; ;Enemy #61 Vile 
		; db $04 ;Collision Damage
		; db $20 ;Enemy Health
		; db $1C ;Damage Table
		; db $8C ;Enemy Value?
		; db $72 ;Sprite Assembly

	; ;Enemy #62 Mac  
		; db $02 ;Collision Damage
		; db $20 ;Enemy Health
		; db $24 ;Damage Table
		; db $9C ;Enemy Value?
		; db $C7 ;Sprite Assembly

	; ;Enemy #63 Vile Goliath 
		; db $06 ;Collision Damage
		; db $20 ;Enemy Health
		; db $1D ;Damage Table
		; db $9D ;Enemy Value?
		; db $96 ;Sprite Assembly

	; ;Enemy #64 Sigma Virus Event  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $30 ;Enemy Value?
		; db $2F ;Sprite Assembly

	; ;Enemy #65 Placed In Doppler Boss Room 
		; db $01 ;Collision Damage
		; db $40 ;Enemy Health
		; db $02 ;Damage Table
		; db $53 ;Enemy Value?
		; db $51 ;Sprite Assembly

	; ;Enemy #66 Boss End Portrait Loader  
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $94 ;Enemy Value?
		; db $9B ;Sprite Assembly

	; ;Enemy #67 Unknown(Unused?) 
		; db $01 ;Collision Damage
		; db $20 ;Enemy Health
		; db $20 ;Damage Table
		; db $3A ;Enemy Value?
		; db $39 ;Sprite Assembly

	; ;Enemy #68 BROKEN 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $A9 ;Enemy Value?
		; db $D2 ;Sprite Assembly

	; ;Enemy #69 Boss Selected Screen 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $39 ;Enemy Value?
		; db $3D ;Sprite Assembly

	; ;Enemy #6A Unknown(Unused?) 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $3A ;Enemy Value?
		; db $39 ;Sprite Assembly

	; ;Enemy #6B Unknown(Unused?) 
		; db $01 ;Collision Damage
		; db $05 ;Enemy Health
		; db $03 ;Damage Table
		; db $92 ;Enemy Value?
		; db $00 ;Sprite Assembly
}




org $C88900 ;Location for all the new tables in-game!
PCIconBytes: ;Loads a table to set the PC's icon bytes for their health bar and other instances
{
	db $5A ;X's health icon
	db $5C ;Zero's health icon
	db $00 ;PC #3's health icon
	db $00 ;PC #4's health icon
	db $FF,$FF,$FF,$FF,$FF,$FF;EXTRAS
	db $FF,$FF,$FF,$FF,$FF,$FF ;EXTRAS
}

;All 4 PC's tables to determine whether they can swap or not on specific levels.
{ 
	XMenuSwapLevelTable: ;X's level table to determine when character switch available; (00 = Yes, 01 = No)
	{
		db $01 ;Introduction Level
		db $00 ;Blast Hornet
		db $00 ;Blizzard Buffalo
		db $00 ;Gravity Beetle
		db $00 ;Toxic Seahorse
		db $00 ;Volt Catfish
		db $00 ;Crush Crawfish
		db $00 ;Tunnel Rhino
		db $00 ;Neon Tiger
		db $01 ;Abandoned Factory (Vile)
		db $00 ;Doppler Stage #1 (Golden Armor)
		db $00 ;Doppler Stage #2 (Intact - Z-Saber)
		db $01 ;Doppler Stage #3 (Doppler)
		db $01 ;Sigma (Final Level)
		db $00 ;Doppler Stage #2 (Destroyed - Refight Vile)
		db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Extra data
		db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Extra data
	}
	ZeroMenuSwapLevelTable: ;Zero's level table to determine when character switch available; (00 = Yes, 01 = No)
	{
		db $01 ;Introduction Level
		db $00 ;Blast Hornet
		db $00 ;Blizzard Buffalo
		db $00 ;Gravity Beetle
		db $00 ;Toxic Seahorse
		db $00 ;Volt Catfish
		db $00 ;Crush Crawfish
		db $00 ;Tunnel Rhino
		db $00 ;Neon Tiger
		db $01 ;Abandoned Factory (Vile)
		db $00 ;Doppler Stage #1 (Golden Armor)
		db $00 ;Doppler Stage #2 (Intact - Z-Saber)
		db $01 ;Doppler Stage #3 (Doppler)
		db $01 ;Sigma (Final Level)
		db $00 ;Doppler Stage #2 (Destroyed - Refight Vile)
		db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Extra data
		db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Extra data
	}
	PC3MenuSwapLevelTable: ;PC3's level table to determine when character switch available; (00 = Yes, 01 = No)
	{
		db $01 ;Introduction Level
		db $00 ;Blast Hornet
		db $00 ;Blizzard Buffalo
		db $00 ;Gravity Beetle
		db $00 ;Toxic Seahorse
		db $00 ;Volt Catfish
		db $00 ;Crush Crawfish
		db $00 ;Tunnel Rhino
		db $00 ;Neon Tiger
		db $01 ;Abandoned Factory (Vile)
		db $00 ;Doppler Stage #1 (Golden Armor)
		db $00 ;Doppler Stage #2 (Intact - Z-Saber)
		db $01 ;Doppler Stage #3 (Doppler)
		db $01 ;Sigma (Final Level)
		db $00 ;Doppler Stage #2 (Destroyed - Refight Vile)
		db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Extra data
		db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Extra data
	}
	PC4MenuSwapLevelTable: ;PC4's level table to determine when character switch available; (00 = Yes, 01 = No)
	{
		db $01 ;Introduction Level
		db $00 ;Blast Hornet
		db $00 ;Blizzard Buffalo
		db $00 ;Gravity Beetle
		db $00 ;Toxic Seahorse
		db $00 ;Volt Catfish
		db $00 ;Crush Crawfish
		db $00 ;Tunnel Rhino
		db $00 ;Neon Tiger
		db $01 ;Abandoned Factory (Vile)
		db $00 ;Doppler Stage #1 (Golden Armor)
		db $00 ;Doppler Stage #2 (Intact - Z-Saber)
		db $01 ;Doppler Stage #3 (Doppler)
		db $01 ;Sigma (Final Level)
		db $00 ;Doppler Stage #2 (Destroyed - Refight Vile)
		db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Extra data
		db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Extra data
	}
}

;PC's Single Byte Weapon Table to get X/Y coordinates of sub-weapon projectiles.
{
XSubWeapSingleByte: ;X's single-byte ADC to get X/Y coordinates of sub-weapon projectiles
{
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$04,$06
	db $08,$0A,$0C,$0E,$10,$12,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $16,$18,$1A,$1C,$1E,$20,$22,$00,$00,$00,$00,$00,$24,$26,$28,$2A
	db $2C,$2E,$30,$00,$00,$00,$00,$00,$00,$32,$34,$36,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$38,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$3A,$3A,$00,$00,$00,$3A,$3A,$00,$00,$3A,$3A,$00
	db $00,$3A,$3A,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
ZeroSubWeapSingleByte: ;Zero's single-byte ADC to get X/Y coordinates of sub-weapon projectiles
{
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$04,$06
	db $08,$0A,$0C,$0E,$10,$12,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $16,$16,$16,$16,$16,$16,$16,$00,$00,$00,$00,$00,$18,$1A,$1C,$1E
	db $20,$22,$24,$00,$00,$00,$00,$00,$00,$26,$26,$28,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2A,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$2C,$2E,$00,$00,$30,$32,$34,$00,$00,$36,$38,$00
	db $00,$3A,$3C,$00,$00,$00,$3E,$40,$00,$00,$00,$00,$42,$44,$44,$44
	db $46,$00,$48,$00,$4A,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
PC3SubWeapSingleByte: ;PC3's single-byte ADC to get X/Y coordinates of sub-weapon projectiles
{
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$04,$06
	db $08,$0A,$0C,$0E,$10,$12,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $16,$18,$1A,$1C,$1E,$20,$22,$00,$00,$00,$00,$00,$24,$26,$28,$2A
	db $2C,$2E,$30,$00,$00,$00,$00,$00,$00,$32,$34,$36,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$38,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$3A,$3A,$00,$00,$00,$3A,$3A,$00,$00,$3A,$3A,$00
	db $00,$3A,$3A,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
PC4SubWeapSingleByte: ;PC4's single-byte ADC to get X/Y coordinates of sub-weapon projectiles
{
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$04,$06
	db $08,$0A,$0C,$0E,$10,$12,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $16,$18,$1A,$1C,$1E,$20,$22,$00,$00,$00,$00,$00,$24,$26,$28,$2A
	db $2C,$2E,$30,$00,$00,$00,$00,$00,$00,$32,$34,$36,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$38,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$3A,$3A,$00,$00,$00,$3A,$3A,$00,$00,$3A,$3A,$00
	db $00,$3A,$3A,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
}
;PC's X/Y coordinates of sub-weapon projectiles.
{
XSubWeapXCoord: ;X's X/Y sub-weapon coordinates
{
	db $00,$00,$FA,$E6,$F9,$E6,$FB,$E6,$FA,$E6,$FA,$E6,$FA,$E6,$F9,$E6
	db $FC,$E6,$FB,$E6,$FB,$E6,$F9,$E3,$F7,$E9,$F7,$EA,$F8,$E9,$F9,$E9
	db $FA,$E7,$FB,$E8,$F9,$E9,$FC,$EC,$FE,$EE,$FA,$EC,$F7,$E9,$FC,$F2
	db $FC,$F2,$FC,$E2,$FC,$E2,$01,$DF,$F7,$F2,$FD,$E8,$00,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
ZeroSubWeapXCoord: ;Zero's X/Y sub-weapon coordinates
{
	db $00,$00,$00,$EA,$FF,$E8,$00,$E8,$01,$E8,$01,$E8,$00,$E8,$FF,$E8
	db $00,$E8,$01,$E8,$01,$E8,$FC,$E8,$FF,$E3,$05,$F0,$03,$E5,$FD,$EA
	db $FB,$ED,$01,$E5,$01,$E9,$03,$E3,$0C,$D7,$01,$EB,$F8,$F8,$03,$E3
	db $F8,$E6,$03,$DE,$03,$DE,$F8,$F8,$FE,$E5,$F4,$E8,$FC,$E3,$FC,$EA
	db $FA,$E8,$03,$E3,$0C,$D7,$02,$E4,$FE,$E4,$FC,$E3
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
PC3SubWeapXCoord: ;PC3's X/Y sub-weapon coordinates
{
	db $00,$00,$FA,$E6,$F9,$E6,$FB,$E6,$FA,$E6,$FA,$E6,$FA,$E6,$F9,$E6
	db $FC,$E6,$FB,$E6,$FB,$E6,$F9,$E3,$F7,$E9,$F7,$EA,$F8,$E9,$F9,$E9
	db $FA,$E7,$FB,$E8,$F9,$E9,$FC,$EC,$FE,$EE,$FA,$EC,$F7,$E9,$FC,$F2
	db $FC,$F2,$FC,$E2,$FC,$E2,$01,$DF,$F7,$F2,$FD,$E8,$00,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
PC4SubWeapXCoord: ;PC4's X/Y sub-weapon coordinates
{
	db $00,$00,$FA,$E6,$F9,$E6,$FB,$E6,$FA,$E6,$FA,$E6,$FA,$E6,$F9,$E6
	db $FC,$E6,$FB,$E6,$FB,$E6,$F9,$E3,$F7,$E9,$F7,$EA,$F8,$E9,$F9,$E9
	db $FA,$E7,$FB,$E8,$F9,$E9,$FC,$EC,$FE,$EE,$FA,$EC,$F7,$E9,$FC,$F2
	db $FC,$F2,$FC,$E2,$FC,$E2,$01,$DF,$F7,$F2,$FD,$E8,$00,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}

}
;PC's Single Byte setup for Tornado Fang to get it's X/Y/Animation setup data.
{
XDrillSingleBye:
{
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$06,$09
	db $0C,$0F,$12,$15,$18,$1B,$1E,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $21,$24,$27,$2A,$2D,$30,$33,$00,$36,$39,$00,$00,$3C,$3F,$42,$45
	db $48,$4B,$4E,$00,$00,$00,$00,$00,$00,$51,$54,$57,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$5A,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
ZeroDrillSingleByte:
{
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$06,$09
	db $0C,$0C,$09,$06,$09,$0C,$03,$00,$00,$00,$00,$00,$00,$24,$00,$00
	db $12,$12,$12,$15,$18,$1B,$1E,$00,$36,$2A,$00,$00,$30,$3F,$42,$30
	db $30,$0C,$09,$00,$00,$00,$00,$00,$00,$0C,$24,$27,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$39,$00,$00,$00,$00,$00
	db $00,$09,$27,$27,$27,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$FF,$FF,$12,$18,$FF,$FF,$FF,$FF,$24,$27,$27,$27
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
PC3DrillSingleByte:
{
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$06,$09
	db $0C,$0F,$12,$15,$18,$1B,$1E,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $21,$24,$27,$2A,$2D,$30,$33,$00,$36,$39,$00,$00,$3C,$3F,$42,$45
	db $48,$4B,$4E,$00,$00,$00,$00,$00,$00,$51,$54,$57,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$5A,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
PC4DrillSingleByte:
{
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$06,$09
	db $0C,$0F,$12,$15,$18,$1B,$1E,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $21,$24,$27,$2A,$2D,$30,$33,$00,$36,$39,$00,$00,$3C,$3F,$42,$45
	db $48,$4B,$4E,$00,$00,$00,$00,$00,$00,$51,$54,$57,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$5A,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}

}
;PC's X/Y/Animation coordinates of Tornado Fang.
{
XDrillYCoord: ;X's Y/X/Animation drill setup
{
	db $00,$00,$00,$FB,$E7,$0C,$FA,$E7,$0C,$FB,$E7,$10,$FC,$E7,$11,$FC
	db $E7,$0C,$FB,$E7,$0C,$FA,$E7,$0C,$FC,$E7,$0C,$FC,$E7,$0C,$FC,$E7
	db $0C,$FA,$E8,$0C,$F8,$E8,$0C,$F8,$E9,$0C,$F9,$E8,$0C,$FA,$E8,$0C
	db $FB,$E8,$0C,$FC,$E9,$0C,$EB,$07,$0D,$F0,$09,$0E,$FA,$EA,$0C,$FD
	db $EC,$0C,$FF,$ED,$0C,$FB,$ED,$0C,$F8,$EA,$0C,$FD,$F1,$0C,$FD,$F2
	db $0C,$FD,$E4,$0C,$FD,$E4,$0C,$02,$DE,$0C,$FA,$F1,$0C,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
ZeroDrillYCoord: ;Zero's Y/X/Animation drill setup
{
	db $00,$00,$00,$00,$E6,$10,$FF,$E6,$0C,$00,$E6,$0C,$01,$E6,$0C,$00
	db $E6,$0C,$FB,$EA,$0C,$FB,$E7,$0C,$FA,$E6,$0C,$F9,$E8,$0C,$FF,$E8
	db $0C,$FF,$E9,$0C,$04,$EA,$0C,$0A,$D7,$0C,$F0,$09,$0E,$FB,$07,$0D
	db $FA,$EA,$0C,$ED,$0C,$FB,$EB,$07,$0D,$01,$EA,$0C,$FF,$FF,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
PC3DrillYCoord: ;PC #3's Y/X/Animation drill setup
{
	db $00,$00,$00,$FB,$E7,$0C,$FA,$E7,$0C,$FB,$E7,$10,$FC,$E7,$11,$FC
	db $E7,$0C,$FB,$E7,$0C,$FA,$E7,$0C,$FC,$E7,$0C,$FC,$E7,$0C,$FC,$E7
	db $0C,$FA,$E8,$0C,$F8,$E8,$0C,$F8,$E9,$0C,$F9,$E8,$0C,$FA,$E8,$0C
	db $FB,$E8,$0C,$FC,$E9,$0C,$EB,$07,$0D,$F0,$09,$0E,$FA,$EA,$0C,$FD
	db $EC,$0C,$FF,$ED,$0C,$FB,$ED,$0C,$F8,$EA,$0C,$FD,$F1,$0C,$FD,$F2
	db $0C,$FD,$E4,$0C,$FD,$E4,$0C,$02,$DE,$0C,$FA,$F1,$0C,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}
PC4DrillYCoord: ;PC #4's Y/X/Animation drill setup
{
	db $00,$00,$00,$FB,$E7,$0C,$FA,$E7,$0C,$FB,$E7,$10,$FC,$E7,$11,$FC
	db $E7,$0C,$FB,$E7,$0C,$FA,$E7,$0C,$FC,$E7,$0C,$FC,$E7,$0C,$FC,$E7
	db $0C,$FA,$E8,$0C,$F8,$E8,$0C,$F8,$E9,$0C,$F9,$E8,$0C,$FA,$E8,$0C
	db $FB,$E8,$0C,$FC,$E9,$0C,$EB,$07,$0D,$F0,$09,$0E,$FA,$EA,$0C,$FD
	db $EC,$0C,$FF,$ED,$0C,$FB,$ED,$0C,$F8,$EA,$0C,$FD,$F1,$0C,$FD,$F2
	db $0C,$FD,$E4,$0C,$FD,$E4,$0C,$02,$DE,$0C,$FA,$F1,$0C,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}

}

;Table that dictates BIT settings used for bosses defeated.
{ 
BossDefeatedTable:
	db $00,$02,$40,$20,$01,$04,$08,$80,$10,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
BossSingleByteTable:
	db $00,$02,$07,$06,$01,$03,$04,$08,$05,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
}

PCNPC_VRAMStartTable: ;Table that dictates each PC's VRAM pointer setup (Regular, Z-Saber, Ride Armor, etc..)
{
	dw $8000 ;X VRAM Setup
	dw $8A00 ;Zero VRAM Setup
	dw $9400 ;PC #3 VRAM Setup
	dw $9E00 ;PC #4 VRAM Setup
	
	dw $A800 ;X Z-Saber VRAM Setup
	dw $B200 ;Zero Z-Saber VRAM Setup
	dw $BC00 ;PC #3 Z-Saber VRAM Setup
	dw $C600 ;PC #4 Z-Saber VRAM Setup
	
	dw $D000 ;X Ride Armor VRAM Setup	
	dw $DA00 ;Zero Ride Armor VRAM Setup
	dw $E400 ;PC #3 Ride Armor VRAM Setup
	dw $EE00 ;PC #4 Ride Armor VRAM Setup
	
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}

;Table pointers for each difficulties Damage Table and Combo Damage Table
{
DifficultyDamagePointers: ;2-byte pointers for Damage Table
	db !DamageTablePointersNormal ;Normal difficulty	(CB:8000)
	db !DamageTablePointersHard ;Hard difficulty		(CB:8080)
	db !DamageTablePointersXtreme ;Xtreme difficulty	(CB:8100)
	
DifficultyComboDamagePointers: ;2-byte pointers for Combo Damage Table
	db !ComboDamageTablePointersNormal ;Normal difficulty	(CB:8180)
	db !ComboDamageTablePointersHard ;Hard difficulty		(CB:8200)
	db !ComboDamageTablePointersXtreme ;Xtreme difficulty	(CB:8280)
	db $FF,$FF,$FF,$FF ;Filler bytes, absolutely nothing
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
}

;Loads palette table from new location starting in bank $C8 with the rest of the tables.
;The pointers all lead to bank $86.
;Inside the palette setup data, it loads all palettes from bank $8C.
{
NewPaletteTable: ;Loads from bank $C8
	dw $8380
	dw $838F
	dw $8394
	dw $8399
	dw $839E
	dw $83A3
	dw $83A8
	dw $83A9
	dw $83AE
	dw $83BB
	dw $83C0
	dw $83C5 ;Broken?
	dw $83C6
	dw $83CB
	dw $8385
	dw $83CC
	dw $83D1
	dw $83D6
	dw $83DB
	dw $83DC
	dw $83E1
	dw $83E6
	dw $83EB
	dw $83F0
	dw $83FA
	dw $83FF

	dw $8404
	dw $8409
	dw $840E
	dw $840F
	dw $8414
	dw $8419
	dw $841E
	dw $8423
	dw $8428
	dw $842D
	dw $8432
	dw $8437
	dw $843C
	dw $8441
	dw $8446
	dw $841E ;Repeat
	dw $844B
	dw $8450
	dw $8455
	dw $845A
	dw $845F
	dw $8464
	dw $846D
	dw $8472
	dw $8477
	dw $847C
	dw $8481
	dw $8486
	dw $848B
	dw $8490
	dw $8495
	dw $849A
	dw $849F
	dw $84A4
	dw $84A9
	dw $84AE
	dw $84B3
	dw $84B8
	dw $84BD
	dw $84C2
	dw $84C7
	dw $84CC
	dw $84D1
	dw $84D5
	dw $84D6
	dw $84DB
	dw $84E0
	dw $84E5
	dw $84EA
	dw $84EF
	dw $84F4
	dw $84F9
	dw $84FE

	dw $8503

	dw $838A

	dw $8508
	dw $850D
	dw $8512
	dw $8517
	dw $851C
	dw $8521
	dw $8526
	dw $852B
	dw $8530
	dw $8530 ;Repeat
	dw $8530 ;Repeat
	dw $8531
	dw $8531 ;Repeat
	dw $8531 ;Repeat
	dw $8531 ;Repeat
	dw $8532
	dw $8537

	dw $83F5

	dw $853C
	dw $8541
	dw $8546
	dw $8547 
	dw $854C
	dw $8551 
	dw $8556

	dw $86AE
	dw $86B3
	dw $86BC
	dw $86C5
	dw $86BC ;Repeat

	dw $855B
	dw $855B ;Repeat
	dw $8560
	dw $8565
	dw $856A
	dw $856F
	dw $8574
	dw $8579
	dw $857E
	dw $8583
	dw $8588
	dw $858D
	dw $8592
	dw $8597
	dw $85A0
	dw $85A5
	dw $85AA
	dw $85AF
	dw $85B4
	dw $85B9
	dw $85BE
	dw $85C3
	dw $85C8
	dw $85CD
	dw $85D2
	dw $85D7
	dw $85DC
	dw $85DC
	dw $85E1
	dw $85E6
	dw $85EB
	dw $85F0
	dw $85F5
	dw $85FA
	dw $85FF

	dw $8604
	dw $8609
	dw $860E
	dw $8613
	dw $8618
	dw $861D
	dw $8622
	dw $8627
	dw $862C
	dw $8631
	dw $8636
	dw $863B
	dw $8640
	dw $8645
	dw $864A
	dw $864F
	dw $8654
	dw $8659
	dw $865A
	dw $865F
	dw $8664
	dw $8669
	dw $866E ;Broken?
	dw $866F
	dw $8674
	dw $8679
	dw $867E
	dw $8683

	dw $8688
	dw $868D
	dw $868E
	dw $8693
	dw $869C
	dw $86A5
	dw $869C
	dw $86CE ;Broken?
	dw $86CF
	dw $86D4
	dw $86D9
	dw $86DE
	dw $86E3
	dw $86E8 ;Broken?
	dw $86E9 ;Broken?
	dw $86EA ;Broken?
	dw $86EB ;Broken?
	dw $86EC
	dw $86F1
	dw $86F6
	dw $86FB

	dw $8700
	dw $8705
	dw $870A
	dw $870B
	dw $870C
	dw $870D
	dw $8712
	dw $8713
	dw $8718
	dw $871D
	dw $8722
	dw $8727
	dw $8727 ;Repeat
	dw $8728 ;Broken
	dw $872D
	dw $8732
	dw $8737
	dw $873C
	dw $8741
	dw $8746
	dw $874B
	dw $8750
	dw $8750 ;Repeat
	dw $8750 ;Repeat
	dw $8750 ;Repeat
	dw $8750 ;Repeat
	dw $8755
	dw $8755 ;Repeat
	dw $8755 ;Repeat

	dw $FBA8 ;NEW PALETTE

	dw $8756
	dw $8756 ;Repeat
	dw $8763
	dw $8768
	dw $876D
	dw $8772
	dw $8777
	dw $877C
	dw $8781
	dw $8786
	dw $878B
	dw $8790
	dw $8795
	dw $879A
	dw $879F
	dw $87A4
	dw $87A9
	dw $87AE
	dw $87B3
	dw $87B8
	dw $87BD
	dw $87C2
	dw $87C7
	dw $87CC
	dw $87D1
	dw $87D6
	dw $87DB
	dw $87E0
	dw $87E5
	dw $87EA
	dw $87EF

	;NEW PALETTES
	;------------------
	dw $8180 ;Zero Black Armor Menu Portrait
	dw $8185 ;X Golden Armor Menu Portrait
	dw $818A ;Zero Black Armor In-Game
	dw $818F ;Zero Buster palette/Purple Z-Saber In-Game

	dw $8194 ;Zero inside BLUE capsule flashing
	dw $819D ;Zero inside BLUE capsule flashing
	dw $81A6 ;Zero inside BLUE capsule flashing
	dw $8194 ;Zero inside BLUE capsule flashing

	dw $81AF ;Zero inside PINK capsule flashing
	dw $81B8 ;Zero inside PINK capsule flashing
	dw $81C1 ;Zero inside PINK capsule flashing
	dw $81AF ;Zero inside PINK capsule flashing (Palette #$0214)

	dw $81D0 ;Ride Chip sprite palette in menu (This may be redundant since there technically is a palette for this already for the platforms)
	dw $81D5 ;Zero Introduction Palette (Green)
	dw $81E0 ;Grayscale weapon icons for save screen
	
	dw $81E5 ;Zero's 'Acid Burst' palette (Palette #$021E)
	dw $81EA ;Zero's 'Parasitic Bomb' palette
	dw $81EF ;Zero's 'Triad Thunder' palette
	dw $81F4 ;Zero's 'Spinning Blade' palette
	dw $81F9 ;Zero's 'Ray Splasher' palette
	dw $81FE ;Zero's 'Gravity Well' palette
	dw $8203 ;Zero's 'Frost Shield' palette
	dw $8208 ;Zero's 'Tornado Fang' palette
	dw $820D ;Zero's 'Hyper Charge' palette [Possibly just pointless]
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $FFFF ;BLANK
	dw $825D ;Zero's 'Level 1' charge palette
	dw $8262 ;Zero's 'Level 2' charge palette
	dw $8267 ;Zero's 'Level 3' charge palette
	
	dw $826C ;X's Get Weapon Armored Palette
}

;Loads pointers for Portrait Palettes in menu.
{
XPortraitPalettePointers:
	dw $012A ;Normal palette
	dw $0202 ;Golden Armor palette
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	
ZeroPortraitPalettePointers:
	dw $012C ;Normal palette
	dw $0200 ;Black Armor palette
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF

PC3PortraitPalettePointers:
	dw $012C ;Normal palette
	dw $0200 ;Black Armor palette
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	
PC4PortraitPalettePointers:
	dw $012C ;Normal palette
	dw $0200 ;Black Armor palette
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
	db $FF,$FF
}

;PC sub-weapon text X/Y coordinates in menu.
{
XSubTextCoord: ;X's Menu Sub-Weapon Text X/Y coordinates
{
	dw $50A6 ;Acid Burst		Text Coordinates
	dw $50E6 ;Parasitic Bomb	Text Coordinates
	dw $5126 ;Triad Thunder		Text Coordinates
	dw $5166 ;Spinning Blades	Text Coordinates
	dw $51A6 ;Ray Splasher		Text Coordinates
	dw $51E6 ;Gravity Well		Text Coordinates
	dw $5226 ;Frost Shield		Text Coordinates
	dw $5266 ;Tornado Fang		Text Coordinates
	dw $52E6 ;Hyper Charge		Text Coordinates
	dw $FFFF ;UNUSED			Text Coordinates
	dw $5066 ;X-Buster			Text Coordinates
	dw $5A59 ;Exit				Text Coordinates

	dw $5B35 ;Chip				Text Coordinates
	dw $5066 ;X-Buster (With Z-Saber)			Text Coordinates
	dw $FFFF ;BLANK				Text Coordinates
	dw $FFFF ;BLANK				Text Coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Text Coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Text Coordinates
}
ZeroSubTextCoord: ;Zero's Menu Sub-Weapon Text X/Y coordinates
{
	dw $50A6 ;Acid Burst		Text Coordinates
	dw $50E6 ;Parasitic Bomb	Text Coordinates
	dw $5126 ;Triad Thunder		Text Coordinates
	dw $5166 ;Spinning Blades	Text Coordinates
	dw $51A6 ;Ray Splasher		Text Coordinates
	dw $51E6 ;Gravity Well		Text Coordinates
	dw $5226 ;Frost Shield		Text Coordinates
	dw $5266 ;Tornado Fang		Text Coordinates
	dw $52E6 ;Hyper Charge		Text Coordinates
	dw $FFFF ;UNUSED			Text Coordinates
	dw $5066 ;X-Buster			Text Coordinates
	dw $5A59 ;Exit				Text Coordinates

	dw $5B35 ;Chip				Text Coordinates
	dw $FFFF ;BLANK				Text Coordinates
	dw $FFFF ;BLANK				Text Coordinates
	dw $FFFF ;BLANK				Text Coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Text Coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Text Coordinates
}
PC3SubTextCoord: ;PC3's Menu Sub-Weapon Text X/Y coordinates
{
	dw $50A6 ;Acid Burst		Text Coordinates
	dw $50E6 ;Parasitic Bomb	Text Coordinates
	dw $5126 ;Triad Thunder		Text Coordinates
	dw $5166 ;Spinning Blades	Text Coordinates
	dw $51A6 ;Ray Splasher		Text Coordinates
	dw $51E6 ;Gravity Well		Text Coordinates
	dw $5226 ;Frost Shield		Text Coordinates
	dw $5266 ;Tornado Fang		Text Coordinates
	dw $52E6 ;Hyper Charge		Text Coordinates
	dw $FFFF ;UNUSED			Text Coordinates
	dw $5066 ;X-Buster			Text Coordinates
	dw $5A59 ;Exit				Text Coordinates

	dw $5B35 ;Chip				Text Coordinates
	dw $FFFF ;BLANK				Text Coordinates
	dw $FFFF ;BLANK				Text Coordinates
	dw $FFFF ;BLANK				Text Coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Text Coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Text Coordinates
}
PC4SubTextCoord: ;PC4's Menu Sub-Weapon Text X/Y coordinates
{
	dw $50A6 ;Acid Burst		Text Coordinates
	dw $50E6 ;Parasitic Bomb	Text Coordinates
	dw $5126 ;Triad Thunder		Text Coordinates
	dw $5166 ;Spinning Blades	Text Coordinates
	dw $51A6 ;Ray Splasher		Text Coordinates
	dw $51E6 ;Gravity Well		Text Coordinates
	dw $5226 ;Frost Shield		Text Coordinates
	dw $5266 ;Tornado Fang		Text Coordinates
	dw $52E6 ;Hyper Charge		Text Coordinates
	dw $FFFF ;UNUSED			Text Coordinates
	dw $5066 ;X-Buster			Text Coordinates
	dw $5A59 ;Exit				Text Coordinates

	dw $5B35 ;Chip				Text Coordinates
	dw $FFFF ;BLANK				Text Coordinates
	dw $FFFF ;BLANK				Text Coordinates
	dw $FFFF ;BLANK				Text Coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Text Coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Text Coordinates
}

}
;PC sub-weapon icon X/Y coordinates in menu
{
XSubIconCoord: ;X's sub-weapon icon coordinates
{
	dw $50A3 ;Acid Burst		Icon X/Y coordinates
	dw $50E3 ;Parasitic Bomb	Icon X/Y coordinates
	dw $5123 ;Triad Thunder		Icon X/Y coordinates
	dw $5163 ;Spinning Blades	Icon X/Y coordinates
	dw $51A3 ;Ray Splasher		Icon X/Y coordinates
	dw $51E3 ;Gravity Well		Icon X/Y coordinates
	dw $5223 ;Frost Shield		Icon X/Y coordinates
	dw $5263 ;Tornado Fang		Icon X/Y coordinates
	dw $52E3 ;Hyper Charge		Icon X/Y coordinates
	dw $FFFF ;UNUSED			Icon X/Y coordinates
	
	dw $5063 ;X-Buster			Icon X/Y coordinates
	dw $59DA ;Exit				Icon X/Y coordinates
	
	dw $FFFF ;Chip				Icon X/Y coordinates
	dw $5063 ;X-Buster(With Z-Saber)				Icon X/Y coordinates
	dw $FFFF ;BLANK				Icon X/Y coordinates
	dw $FFFF ;BLANK				Icon X/Y coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon X/Y coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon X/Y coordinates
}
ZeroSubIconCoord: ;Zero's sub-weapon icon coordinates
{
	dw $50A3 ;Acid Burst		Icon X/Y coordinates
	dw $50E3 ;Parasitic Bomb	Icon X/Y coordinates
	dw $5123 ;Triad Thunder		Icon X/Y coordinates
	dw $5163 ;Spinning Blades	Icon X/Y coordinates
	dw $51A3 ;Ray Splasher		Icon X/Y coordinates
	dw $51E3 ;Gravity Well		Icon X/Y coordinates
	dw $5223 ;Frost Shield		Icon X/Y coordinates
	dw $5263 ;Tornado Fang		Icon X/Y coordinates
	dw $52E3 ;Hyper Charge		Icon X/Y coordinates
	dw $FFFF ;UNUSED			Icon X/Y coordinates
	
	dw $5063 ;Z-Buster			Icon X/Y coordinates
	dw $59DA ;Exit				Icon X/Y coordinates
	
	dw $FFFF ;Chip				Icon X/Y coordinates
	dw $FFFF ;BLANK				Icon X/Y coordinates
	dw $FFFF ;BLANK				Icon X/Y coordinates
	dw $FFFF ;BLANK				Icon X/Y coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon X/Y coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon X/Y coordinates
}
PC3SubIconCoord: ;PC3's sub-weapon icon coordinates
{
	dw $50A3 ;Acid Burst		Icon X/Y coordinates
	dw $50E3 ;Parasitic Bomb	Icon X/Y coordinates
	dw $5123 ;Triad Thunder		Icon X/Y coordinates
	dw $5163 ;Spinning Blades	Icon X/Y coordinates
	dw $51A3 ;Ray Splasher			Icon X/Y coordinates
	dw $51E3 ;Gravity Well		Icon X/Y coordinates
	dw $5223 ;Frost Shield		Icon X/Y coordinates
	dw $5263 ;Tornado Fang		Icon X/Y coordinates
	dw $52E3 ;Hyper Charge		Icon X/Y coordinates
	dw $FFFF ;UNUSED			Icon X/Y coordinates
	
	dw $5063 ;X-Buster			Icon X/Y coordinates
	dw $59DA ;Exit				Icon X/Y coordinates
	
	dw $FFFF ;Chip				Icon X/Y coordinates
	dw $FFFF ;BLANK				Icon X/Y coordinates
	dw $FFFF ;BLANK				Icon X/Y coordinates
	dw $FFFF ;BLANK				Icon X/Y coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon X/Y coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon X/Y coordinates
}
PC4SubIconCoord: ;PC4's sub-weapon icon coordinates
{
	dw $50A3 ;Acid Burst		Icon X/Y coordinates
	dw $50E3 ;Parasitic Bomb	Icon X/Y coordinates
	dw $5123 ;Triad Thunder		Icon X/Y coordinates
	dw $5163 ;Spinning Blades	Icon X/Y coordinates
	dw $51A3 ;Ray Splasher			Icon X/Y coordinates
	dw $51E3 ;Gravity Well		Icon X/Y coordinates
	dw $5223 ;Frost Shield		Icon X/Y coordinates
	dw $5263 ;Tornado Fang		Icon X/Y coordinates
	dw $52E3 ;Hyper Charge		Icon X/Y coordinates
	dw $FFFF ;UNUSED			Icon X/Y coordinates
	
	dw $5063 ;X-Buster			Icon X/Y coordinates
	dw $59DA ;Exit				Icon X/Y coordinates
	
	dw $FFFF ;Chip				Icon X/Y coordinates
	dw $FFFF ;BLANK				Icon X/Y coordinates
	dw $FFFF ;BLANK				Icon X/Y coordinates
	dw $FFFF ;BLANK				Icon X/Y coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon X/Y coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon X/Y coordinates
}

}
;PC sub-weapon icon graphic setup in menu
{
XSubIconGraph: ;X's sub-weapon icon graphics
{
	dw $0032 ;Acid Burst		Icon Graphics
	dw $0034 ;Parasitic Bomb	Icon Graphics
	dw $0036 ;Triad Thunder		Icon Graphics
	dw $0038 ;Spinning Blades	Icon Graphics
	dw $003A ;Ray Splasher			Icon Graphics
	dw $003C ;Gravity Well		Icon Graphics
	dw $003E ;Frost Shield		Icon Graphics
	dw $0050 ;Tornado Fang		Icon Graphics
	dw $0052 ;Hyper Charge		Icon Graphics
	dw $0054 ;UNUSED			Icon Graphics
	
	dw $0030 ;X-Buster			Icon Graphics
	dw $0054 ;Exit				Icon Graphics
	
	dw $FFFF ;Chip				Icon Graphics
	dw $015C ;X-Buster (With Z-Saber)			Icon Graphics
	dw $FFFF ;BLANK				Icon Graphics
	dw $FFFF ;BLANK				Icon Graphics

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon Graphics
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon Graphics
}
ZeroSubIconGraph: ;Zero's sub-weapon icon graphics
{
	dw $00F6 ;Acid Burst		Icon Graphics
	dw $00FC ;Parasitic Bomb	Icon Graphics
	dw $0112 ;Triad Thunder		Icon Graphics
	dw $0118 ;Spinning Blades	Icon Graphics
	dw $011E ;Ray Splasher			Icon Graphics
	dw $0134 ;Gravity Well		Icon Graphics
	dw $013A ;Frost Shield		Icon Graphics
	dw $0150 ;Tornado Fang		Icon Graphics
	dw $0156 ;Hyper Charge		Icon Graphics
	dw $0054 ;UNUSED			Icon Graphics
	
	dw $00F0 ;Z-Buster			Icon Graphics
	dw $0054 ;Exit				Icon Graphics
	
	dw $FFFF ;Chip				Icon Graphics
	dw $FFFF ;BLANK				Icon Graphics
	dw $FFFF ;BLANK				Icon Graphics
	dw $FFFF ;BLANK				Icon Graphics

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon Graphics
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon Graphics
}
PC3SubIconGraph: ;PC3's sub-weapon icon graphics
{
	dw $00F8 ;Acid Burst		Icon Graphics
	dw $00FE ;Parasitic Bomb	Icon Graphics
	dw $0114 ;Triad Thunder		Icon Graphics
	dw $011A ;Spinning Blades	Icon Graphics
	dw $0130 ;Ray Splasher			Icon Graphics
	dw $0136 ;Gravity Well		Icon Graphics
	dw $013C ;Frost Shield		Icon Graphics
	dw $0152 ;Tornado Fang		Icon Graphics
	dw $0158 ;Hyper Charge		Icon Graphics
	dw $0054 ;UNUSED			Icon Graphics

	dw $00F2 ;X-Buster			Icon Graphics
	dw $0054 ;Exit				Icon Graphics

	dw $FFFF ;Chip				Icon Graphics
	dw $FFFF ;BLANK				Icon Graphics
	dw $FFFF ;BLANK				Icon Graphics
	dw $FFFF ;BLANK				Icon Graphics

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon Graphics
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon Graphics
}
PC4SubIconGraph: ;PC4's sub-weapon icon graphics
{
	dw $00FA ;Acid Burst		Icon Graphics
	dw $0110 ;Parasitic Bomb	Icon Graphics
	dw $0116 ;Triad Thunder		Icon Graphics
	dw $011C ;Spinning Blades	Icon Graphics
	dw $0132 ;Ray Splasher			Icon Graphics
	dw $0138 ;Gravity Well		Icon Graphics
	dw $013E ;Frost Shield		Icon Graphics
	dw $0154 ;Tornado Fang		Icon Graphics
	dw $015A ;Hyper Charge		Icon Graphics
	dw $0054 ;UNUSED			Icon Graphics

	dw $00F4 ;X-Buster			Icon Graphics
	dw $0054 ;Exit				Icon Graphics

	dw $FFFF ;Chip				Icon Graphics
	dw $FFFF ;BLANK				Icon Graphics
	dw $FFFF ;BLANK				Icon Graphics
	dw $FFFF ;BLANK				Icon Graphics

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon Graphics
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Icon Graphics
}

}
;PC Sub-weapon ammo bar X/Y coordinates in menu
{
XLifeBarCoord: ;X's sub-weapon life bar coordinate
{
	dw $50C5 ;Acid Burst		Life Bar X/Y coordinates
	dw $5105 ;Parasitic Bomb	Life Bar X/Y coordinates
	dw $5145 ;Triad Thunder		Life Bar X/Y coordinates
	dw $5185 ;Spinning Blades	Life Bar X/Y coordinates
	dw $51C5 ;Ray Splasher			Life Bar X/Y coordinates
	dw $5205 ;Gravity Well		Life Bar X/Y coordinates
	dw $5245 ;Frost Shield		Life Bar X/Y coordinates
	dw $5285 ;Tornado Fang		Life Bar X/Y coordinates
	dw $5305 ;Hyper Charge		Life Bar X/Y coordinates
	dw $5325 ;UNUSED			Life Bar X/Y coordinates
	
	dw $5085; X-Buster			Life Bar X/Y coordinates
	dw $FFFF ;Exit (NO BAR)		Life Bar X/Y coordinates

	dw $FFFF ;Chip (NO BAR)		Life Bar X/Y coordinates
	dw $5085; X-Buster (With Z-Saber)	Life Bar X/Y coordinates
	dw $FFFF ;BLANK				Life Bar X/Y coordinates
	dw $FFFF ;BLANK				Life Bar X/Y coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Life Bar X/Y coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Life Bar X/Y coordinates
}
ZeroLifeBarCoord: ;Zero's sub-weapon life bar coordinate
{
	dw $50C5 ;Acid Burst		Life Bar X/Y coordinates
	dw $5105 ;Parasitic Bomb	Life Bar X/Y coordinates
	dw $5145 ;Triad Thunder		Life Bar X/Y coordinates
	dw $5185 ;Spinning Blades	Life Bar X/Y coordinates
	dw $51C5 ;Ray Splasher			Life Bar X/Y coordinates
	dw $5205 ;Gravity Well		Life Bar X/Y coordinates
	dw $5245 ;Frost Shield		Life Bar X/Y coordinates
	dw $5285 ;Tornado Fang		Life Bar X/Y coordinates
	dw $5305 ;Hyper Charge		Life Bar X/Y coordinates
	dw $5325 ;UNUSED			Life Bar X/Y coordinates
	
	dw $5085; X-Buster			Life Bar X/Y coordinates
	dw $FFFF ;Exit (NO BAR)		Life Bar X/Y coordinates

	dw $FFFF ;Chip (NO BAR)		Life Bar X/Y coordinates
	dw $FFFF ;BLANK				Life Bar X/Y coordinates
	dw $FFFF ;BLANK				Life Bar X/Y coordinates
	dw $FFFF ;BLANK				Life Bar X/Y coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Life Bar X/Y coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Life Bar X/Y coordinates
}
PC3LifeBarCoord: ;PC3's sub-weapon life bar coordinate
{
	dw $50C5 ;Acid Burst		Life Bar X/Y coordinates
	dw $5105 ;Parasitic Bomb	Life Bar X/Y coordinates
	dw $5145 ;Triad Thunder		Life Bar X/Y coordinates
	dw $5185 ;Spinning Blades	Life Bar X/Y coordinates
	dw $51C5 ;Ray Splasher			Life Bar X/Y coordinates
	dw $5205 ;Gravity Well		Life Bar X/Y coordinates
	dw $5245 ;Frost Shield		Life Bar X/Y coordinates
	dw $5285 ;Tornado Fang		Life Bar X/Y coordinates
	dw $5305 ;Hyper Charge		Life Bar X/Y coordinates
	dw $5325 ;UNUSED			Life Bar X/Y coordinates
	
	dw $5085; X-Buster			Life Bar X/Y coordinates
	dw $FFFF ;Exit (NO BAR)		Life Bar X/Y coordinates

	dw $FFFF ;Chip (NO BAR)		Life Bar X/Y coordinates
	dw $FFFF ;BLANK				Life Bar X/Y coordinates
	dw $FFFF ;BLANK				Life Bar X/Y coordinates
	dw $FFFF ;BLANK				Life Bar X/Y coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Life Bar X/Y coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Life Bar X/Y coordinates
}
PC4LifeBarCoord: ;PC4's sub-weapon life bar coordinate
{
	dw $50C5 ;Acid Burst		Life Bar X/Y coordinates
	dw $5105 ;Parasitic Bomb	Life Bar X/Y coordinates
	dw $5145 ;Triad Thunder		Life Bar X/Y coordinates
	dw $5185 ;Spinning Blades	Life Bar X/Y coordinates
	dw $51C5 ;Ray Splasher			Life Bar X/Y coordinates
	dw $5205 ;Gravity Well		Life Bar X/Y coordinates
	dw $5245 ;Frost Shield		Life Bar X/Y coordinates
	dw $5285 ;Tornado Fang		Life Bar X/Y coordinates
	dw $5305 ;Hyper Charge		Life Bar X/Y coordinates
	dw $5325 ;UNUSED			Life Bar X/Y coordinates
	
	dw $5085; X-Buster			Life Bar X/Y coordinates
	dw $FFFF ;Exit (NO BAR)		Life Bar X/Y coordinates

	dw $FFFF ;Chip (NO BAR)		Life Bar X/Y coordinates
	dw $FFFF ;BLANK				Life Bar X/Y coordinates
	dw $FFFF ;BLANK				Life Bar X/Y coordinates
	dw $FFFF ;BLANK				Life Bar X/Y coordinates

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Life Bar X/Y coordinates
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;Excess Life Bar X/Y coordinates
}

}	
	
;PC Stage select icon pointer setup
{
PCStageSelectPCIconPointers:
	dw PCStageSelectZero
	dw PCStageSelectX
	dw PCStageSelectPC4
	dw PCStageSelectPC3
	

PCStageSelectTileMapBase:
PCStageSelectX:
	db $00,$00,$00,$00,$00,$00,$00,$00,$F8,$12,$F9,$12,$FA,$12,$FB,$12
	db $FC,$12,$FD,$12,$FE,$12,$FF,$12,$00,$13,$01,$13,$02,$13,$03,$13
PCStageSelectZero:
	db $00,$00,$00,$00,$00,$00,$00,$00,$31,$10,$32,$10,$F4,$10,$F5,$10
	db $41,$10,$42,$10,$02,$11,$03,$11,$50,$10,$51,$10,$10,$11,$11,$11
PCStageSelectPC3:
	db $00,$00,$00,$00,$00,$00,$00,$00,$F8,$12,$F9,$12,$FA,$12,$FB,$12
	db $FC,$12,$FD,$12,$FE,$12,$FF,$12,$00,$13,$01,$13,$02,$13,$03,$13
PCStageSelectPC4:
	db $00,$00,$00,$00,$00,$00,$00,$00,$F8,$12,$F9,$12,$FA,$12,$FB,$12
	db $FC,$12,$FD,$12,$FE,$12,$FF,$12,$00,$13,$01,$13,$02,$13,$03,$13
}

;Load Save/Load screen menu text X/Y coordinates for Layer #1/#2/#3.
{
	DisplayNewText_XYCoordinates: ;X's Menu Sub-Weapon Text X/Y coordinates
	dw $506C ;Weapons		Text Coordinates
	dw $50EC ;Life			Text Coordinates
	dw $50F5 ;S-Tank		Text Coordinates
	dw $516C ;Modules		Text Coordinates
	dw $5175 ;Chips			Text Coordinates
	dw $526C ;Bit			Text Coordinates
	dw $528C ;Byte			Text Coordinates
	dw $52AC ;Vile			Text Coordinates
	dw $FFFF ;Sigma			Text Coordinates
	dw $51EC ;Z-Saber		Text Coordinates
	dw $0B03 ;Select a file to load (Layer 3)			Text Coordinates
	dw $0B03 ;Load this file? 		(Layer 3)			Text Coordinates
	dw $0B2C ;Yes  No			(Layer 3)			Text Coordinates
	dw $0B23 ; 			(Layer 3)			Text Coordinates
	dw $0B03 ;Select a file to save to.	(Layer 3)			Text Coordinates
	dw $0B03 ;Overwrite this file?	(Layer 3)			Text Coordinates
	dw $0B03 ;Erase this file?		(Layer 3)			Text Coordinates
	dw $51F5 ;Clear			Text Coordinates
}
;Load Save/Load screen Menu text Pointers/text for Layer #1/#2/#3
{
	DisplayNewText_Pointers:
	dl Pointer00 ;Weapons
	dl Pointer01 ;Life
	dl Pointer02 ;S-Tank
	dl Pointer03 ;Modules
	dl Pointer04 ;Chips
	dl Pointer05 ;Bit
	dl Pointer06 ;Byte
	dl Pointer07 ;Vile
	dl Pointer08 ;Sigma
	dl Pointer09 ;Z-Saber
	dl Pointer0A ;Select a file to load. (Layer 3)
	dl Pointer0B ;Load this file? (Layer 3)
	dl Pointer0C ;Yes  No	(Layer 3)
	dl Pointer0D ; 	(Layer 3) (Used to blank out Yes No)
	dl Pointer0E ;Select a file to save to.	(Layer 3)
	dl Pointer0F ;Overwrite this file?	(Layer 3)
	dl Pointer10 ;Erase this file?		(Layer 3)
	dl Pointer11 ;Clear
	
	Pointer00: db $86,$74,$70,$7F,$7E,$7D,$82,$00 ;Weapons
	Pointer01: db $7B,$78,$75,$74,$00 ;Life
	Pointer02: db $82,$8B,$83,$70,$7D,$7A,$00 ;S-Tank
	Pointer03: db $7C,$7E,$73,$84,$7B,$74,$82,$00 ;Modules
	Pointer04: db $72,$77,$78,$7F,$82,$00 ;Chips
	Pointer05: db $71,$78,$83,$00 ;Bit
	Pointer06: db $71,$88,$83,$74,$00 ;Byte
	Pointer07: db $85,$78,$7B,$74,$00 ;Vile
	Pointer08: db $82,$78,$76,$7C,$70,$00 ;Sigma
	Pointer09: db $89,$8B,$82,$70,$71,$74,$81,$00 ;Z-Saber
	Pointer0A: db "Select a file to load.   ",$00 ;Select a file to load (Layer 3)
	Pointer0B: db "Load this file?          ",$00 ;Load this file? (7 spaces)
	Pointer0C: db "Yes  No                  ",$00 ;Yes  No (Layer 3)
	Pointer0D: db "                         ",$00 ;  (Layer 3) (Used to blank out Yes No)
	Pointer0E: db "Select a file to save to.",$00 ;(Layer 3)
	Pointer0F: db "Overwrite this file?     ",$00 ;(Layer 3)
	Pointer10: db "Erase this file?         ",$00 ;(Layer 3)
	Pointer11: db $72,$7B,$74,$70,$81,$00 	;Clear

}
;Load Save/Load screen menu sub-weapon icons X/Y coordinates & Graphics
{
	DisplayNewMenu_SubWeaponIcon_XYCoordinates:
	dw $508C ;Acid Burst		Icon X/Y coordinates
	dw $508E ;Parasitic Bomb	Icon X/Y coordinates
	dw $5090 ;Triad Thunder		Icon X/Y coordinates
	dw $5092 ;Spinning Blades	Icon X/Y coordinates
	dw $5094 ;Ray Splasher		Icon X/Y coordinates
	dw $5096 ;Gravity Well		Icon X/Y coordinates
	dw $5098 ;Frost Shield		Icon X/Y coordinates
	dw $509A ;Tornado Fang		Icon X/Y coordinates
	dw $FFFF ;Hyper Charge		Icon X/Y coordinates
	dw $520C ;Z-Saber			Icon X/Y coordinates
	
	
	DisplayNewMenu_SubWeaponIcon_Graphics:
	dw $0032 ;Acid Burst		Icon Graphics
	dw $0034 ;Parasitic Bomb	Icon Graphics
	dw $0036 ;Triad Thunder		Icon Graphics
	dw $0038 ;Spinning Blades	Icon Graphics
	dw $003A ;Ray Splasher		Icon Graphics
	dw $003C ;Gravity Well		Icon Graphics
	dw $003E ;Frost Shield		Icon Graphics
	dw $0050 ;Tornado Fang		Icon Graphics
	dw $0052 ;Hyper Charge		Icon Graphics
	dw $015C ;Z-Saber			Icon Graphics
}
SaveMenu_SubTankXY: ;Load Save/Load screen menu sub-tank icons X/Y coordinates
{
	dw $5915 ;Sub-Tank #1
	dw $5917 ;Sub-Tank #2
	dw $5919 ;Sub-Tank #3
	dw $591B ;Sub-Tank #4
}

X_ChargingPalettesSetup: ;Loads X's charging palette table
{
	dw $0136,$0000 ;Level 1
	dw $0144,$0000 ;Hyper Charge
	dw $013A,$0000 ;Level 3
	dw $0138,$0000 ;Level 2
}
Zero_ChargingPalettesSetup: ;Loads X's charging palette table
{
	dw $024C,$0000 ;Level 1
	dw $0000,$0000 ;Hyper Charge
	dw $0250,$0000 ;Level 3
	dw $024E,$0000 ;Level 2
}

SplitSAADTable: ;Single byte data for loading split Sprite Assembly/Animation Data for enemies, PCs, etc.. (This allows them to share the same byte instead of having repeats)
{
	db $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
	db $10,$11,$12,$13,$14,$15,$16,$17,$00,$19,$1A,$1B,$1C,$1D,$1E,$1F
	db $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F
	db $30,$31,$32,$33,$33,$33,$33,$33,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F
	db $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F
	db $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A,$5B,$5C,$00,$00,$00
	db $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6A,$6A,$6A,$6A,$6A,$6F
	db $6F,$6F,$72,$73,$74,$75,$76,$77,$78,$79,$7A,$7B,$7C,$7D,$7E,$7F
	db $80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8A,$8B,$8C,$8D,$8D,$8D
	db $8D,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9A,$9B,$9C,$9D,$9E,$9F
	db $A0,$A1,$A2,$A3,$A4,$A4,$A4,$A4,$A8,$A9,$AA,$AB,$AC,$AD,$AE,$AF
	db $B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF
	db $C0,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1,$C1
	db $C1,$D1,$D2,$D3,$D4,$D5,$D6,$D7
	db $11 ;(Zero 1-up Icon) (Loads $3F:8033 for Animation Data which loads $3F:9A74 same as X's) ($0D:8288 --> $0D:82B8/$0D:B2D9 to $0D:82FA for sprite assembly)	
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $2D,$2D,$2D,$2D,$2D,$55,$6E,$75,$73,$65,$64,$2D,$2D,$2D,$2D,$2D
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $18,$2C,$34,$35,$36,$37,$5D,$5E,$5F,$6B,$6C,$6D,$6E,$70,$71,$8E
	db $8F,$90,$A5,$A6,$A7,$C2,$C3,$C4,$C5,$C7,$C8,$C9,$C9,$CA,$CB,$CC
	db $CD,$CE,$CF,$D0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
}

DecompressedDataTable: ;Loads pointers and entirety of Decompressed Data setup
{
	dw Decompressed_Data_00
	dw Decompressed_Data_02
	dw Decompressed_Data_04
	dw Decompressed_Data_06
	dw Decompressed_Data_08
	dw Decompressed_Data_0A
	dw Decompressed_Data_0C
	dw Decompressed_Data_0E ;Layer 3 dialogue font
	dw Decompressed_Data_10
	dw Decompressed_Data_12
	dw Decompressed_Data_14 ;X Menu
	dw Decompressed_Data_16
	dw Decompressed_Data_18
	dw Decompressed_Data_1A
	dw Decompressed_Data_1C ;Zero Menu
	dw Decompressed_Data_1E
	dw Decompressed_Data_20
	dw Decompressed_Data_22
	dw Decompressed_Data_24
	dw Decompressed_Data_26
	dw Decompressed_Data_28
	dw Decompressed_Data_2A
	dw Decompressed_Data_2C
	dw Decompressed_Data_2E
	dw Decompressed_Data_30
	dw Decompressed_Data_32
	dw Decompressed_Data_34
	dw Decompressed_Data_36
	dw Decompressed_Data_38
	dw Decompressed_Data_3A
	dw Decompressed_Data_3C
	dw Decompressed_Data_3E
	dw Decompressed_Data_40
	dw Decompressed_Data_42
	dw Decompressed_Data_44
	dw Decompressed_Data_46
	dw Decompressed_Data_48
	dw Decompressed_Data_4A
	dw Decompressed_Data_4C
	dw Decompressed_Data_4E
	dw Decompressed_Data_50
	dw Decompressed_Data_52 ;Charged Tornado Fang Frame #1
	dw Decompressed_Data_54 ;Charged Tornado Fang Frame #2
	dw Decompressed_Data_56 ;Charged Tornado Fang Frame #3
	dw Decompressed_Data_58 ;Charged Tornado Fang Frame #4
	dw Decompressed_Data_5A
	dw Decompressed_Data_5C
	dw Decompressed_Data_5E
	dw Decompressed_Data_60
	dw Decompressed_Data_62
	dw Decompressed_Data_64
	dw Decompressed_Data_66
	dw Decompressed_Data_68
	dw Decompressed_Data_6A
	dw Decompressed_Data_6C
	dw Decompressed_Data_6E
	dw Decompressed_Data_70
	dw Decompressed_Data_72
	dw Decompressed_Data_74
	dw Decompressed_Data_76
	dw Decompressed_Data_78
	dw Decompressed_Data_7A
	dw Decompressed_Data_7C
	dw Decompressed_Data_7E
	dw Decompressed_Data_80
	dw Decompressed_Data_82
	dw Decompressed_Data_84
	dw Decompressed_Data_86
	dw Decompressed_Data_88
	dw Decompressed_Data_8A
	dw Decompressed_Data_8C
	dw Decompressed_Data_8E
	dw Decompressed_Data_90
	dw Decompressed_Data_92 ;X 1-Up Icon
	dw Decompressed_Data_94
	dw Decompressed_Data_96
	dw Decompressed_Data_98
	dw Decompressed_Data_9A
	dw Decompressed_Data_9C
	dw Decompressed_Data_9E
	dw Decompressed_Data_A0
	dw Decompressed_Data_A2
	dw Decompressed_Data_A4
	dw Decompressed_Data_A6
	dw Decompressed_Data_A8
	
;New decompressed data:
	dw Decompressed_Data_AA ;Decompressed general VRAM
	dw Decompressed_Data_AC ;Decompressed Ride Chips in Menu
	dw Decompressed_Data_AE ;Decompressed In-Game Menu Graphic Tiles
	dw Decompressed_Data_B0 ;Decompressed 'Z' graphic
	dw Decompressed_Data_B2 ;Decompressed Zero Get Weapon Graphics
	dw Decompressed_Data_B4 ;Decompressed Zero Get Weapon Tile Map
	dw Decompressed_Data_B6 ;Decompressed In-Game Menu Graphic Tile Map
	dw Decompressed_Data_B8 ;Decompressed X & Zero Introduction Graphics
	dw Decompressed_Data_BA ;Decompressed X Armor Chip Menu Sprites
	dw Decompressed_Data_BC ;Decompressed Zero 1-up Icon (In-game)
	dw Decompressed_Data_BE ;Decompressed X Menu Portrait
	dw Decompressed_Data_C0 ;Decompressed Password Screen Layer #1 Tile Map
	dw Decompressed_Data_C2 ;Decompressed Password Screen Layer #3 Tile Map
	dw Decompressed_Data_C4 ;Decompressed Zero 1-up Icon (Save Menu)
	dw Decompressed_Data_C6 ;Decompressed Zero Idle Pose (Save Menu)
	dw Decompressed_Data_C8 ;Decompressed 'READY' text specifically for Zero
	dw Decompressed_Data_CA ;Decompressed 'READY' text specifically for Zero (When PC is already on screen)
	dw Decompressed_Data_CC ;Decompressed Layer 3 Get Weapon Tile Map
	dw Decompressed_Data_CE ;Decompressed X Get Weapon Armor pieces
	dw Decompressed_Data_D0 ;Decompressed Layer 1/2 Get Weapon Box Tile Map (Used to clear layer 3)
	dw Decompressed_Data_D2 ;Decompressed Layer 1/2 Get Weapon Box Tile Map
	dw Decompressed_Data_D4 ;Decompressed Layer 1 X Get Weapon Tile Map (Helmet)
	

	
	Decompressed_Data_00: db $00,$2E,$00,$11,$00,$00,$7F,$FF
	Decompressed_Data_02: db $FF
	Decompressed_Data_04: db $40,$01,$00,$60,$00,$80,$3C,$00,$01,$00,$61,$40,$81,$3C,$FF
	Decompressed_Data_06: db $00,$08,$00,$08,$00,$D0,$7F,$FF
	Decompressed_Data_08: db $FF
	Decompressed_Data_0A: db $00,$08,$00,$58,$00,$00,$7F,$FF
	Decompressed_Data_0C: db $FF
	Decompressed_Data_0E: db $00,$09,$00,$00,$00,$80,$3E,$FF
	Decompressed_Data_10: db $00,$10,$00,$50,$00,$D0,$7F,$FF
	Decompressed_Data_12: db $00,$08,$00,$58,$00,$89,$3E,$FF
	Decompressed_Data_14: db $00,$04,$A0,$6A,$00,$80,$2D,$FF ;X Menu
	Decompressed_Data_16: db $00,$01,$00,$63,$20,$FE,$2E,$40,$00,$00,$64,$20,$FF,$2E,$FF
	Decompressed_Data_18: db $00,$08,$00,$08,$00,$00,$7F,$FF
	Decompressed_Data_1A: db $40,$01,$80,$62,$E0,$BB,$2C,$00,$01,$80,$63,$20,$BD,$2C,$FF
	Decompressed_Data_1C: db $A0,$01,$E0,$6A,$00,$80,$31,$80,$01,$E0,$6B,$A0,$81,$31,$FF ;Zero Menu
	Decompressed_Data_1E: db $FF
	Decompressed_Data_20: db $00,$08,$00,$58,$00,$E0,$AF,$FF
	Decompressed_Data_22: db $FF
	Decompressed_Data_24: db $A0,$00,$00,$65,$A0,$EA,$3A,$A0,$00,$00,$66,$40,$EB,$3A,$FF
	Decompressed_Data_26: db $00,$01,$80,$66,$80,$D7,$3E,$00,$01,$80,$67,$80,$D8,$3E,$FF
	Decompressed_Data_28: db $C0,$00,$80,$66,$80,$D9,$3E,$C0,$00,$80,$67,$40,$DA,$3E,$FF
	Decompressed_Data_2A: db $C0,$00,$80,$66,$00,$DB,$3E,$C0,$00,$80,$67,$C0,$DB,$3E,$FF
	Decompressed_Data_2C: db $C0,$00,$80,$66,$80,$DC,$3E,$C0,$00,$80,$67,$40,$DD,$3E,$FF
	Decompressed_Data_2E: db $C0,$00,$80,$66,$00,$DE,$3E,$C0,$00,$80,$67,$C0,$DE,$3E,$FF
	Decompressed_Data_30: db $C0,$00,$80,$66,$80,$DF,$3E,$C0,$00,$80,$67,$40,$E0,$3E,$FF
	Decompressed_Data_32: db $C0,$00,$80,$66,$00,$E1,$3E,$C0,$00,$80,$67,$C0,$E1,$3E,$FF
	Decompressed_Data_34: db $C0,$00,$80,$66,$80,$E2,$3E,$C0,$00,$80,$67,$40,$E3,$3E,$FF
	Decompressed_Data_36: db $C0,$00,$80,$66,$00,$E4,$3E,$C0,$00,$80,$67,$C0,$E4,$3E,$FF
	Decompressed_Data_38: db $00,$04,$00,$63,$00,$A7,$2C,$FF
	Decompressed_Data_3A: db $E0,$00,$00,$63,$40,$AE,$2C,$80,$00,$00,$64,$20,$AF,$2C,$FF
	Decompressed_Data_3C: db $00,$01,$80,$63,$20,$90,$2C,$00,$01,$80,$64,$20,$92,$2C,$A0,$01,$00,$65,$20,$93,$2C,$00,$01,$00,$66,$C0,$94,$2C,$40,$00,$C0,$6A,$A0,$87,$2C,$40,$00,$C0,$6B,$A0,$89,$2C,$FF
	Decompressed_Data_3E: db $00,$01,$80,$63,$20,$90,$2C,$00,$01,$80,$64,$20,$92,$2C,$A0,$01,$00,$65,$20,$93,$2C,$00,$01,$00,$66,$C0,$94,$2C,$40,$00,$C0,$6A,$A0,$87,$2C,$40,$00,$C0,$6B,$A0,$89,$2C,$FF
	Decompressed_Data_40: db $00,$01,$80,$63,$20,$90,$2C,$00,$01,$80,$64,$20,$92,$2C,$A0,$01,$00,$65,$20,$93,$2C,$00,$01,$00,$66,$C0,$94,$2C,$40,$00,$C0,$6A,$A0,$87,$2C,$40,$00,$C0,$6B,$A0,$89,$2C,$FF
	Decompressed_Data_42: db $40,$00,$C0,$6A,$E0,$87,$2C,$40,$00,$C0,$6B,$E0,$89,$2C,$FF
	Decompressed_Data_44: db $00,$03,$00,$65,$00,$AB,$2C,$40,$00,$00,$67,$00,$AE,$2C,$40,$00,$C0,$6A,$20,$88,$2C,$40,$00,$C0,$6B,$20,$8A,$2C,$FF
	Decompressed_Data_46: db $40,$00,$C0,$6A,$60,$88,$2C,$40,$00,$C0,$6B,$60,$8A,$2C,$FF
	Decompressed_Data_48: db $00,$06,$00,$63,$20,$BF,$2C,$40,$00,$C0,$6A,$A0,$88,$2C,$40,$00,$C0,$6B,$A0,$8A,$2C,$FF
	Decompressed_Data_4A: db $80,$00,$80,$65,$40,$C6,$2C,$40,$00,$C0,$6A,$E0,$88,$2C,$40,$00,$C0,$6B,$E0,$8A,$2C,$FF
	Decompressed_Data_4C: db $40,$00,$C0,$6A,$20,$89,$2C,$40,$00,$C0,$6B,$20,$8B,$2C,$FF
	Decompressed_Data_4E: db $00,$04,$00,$63,$40,$F7,$2C,$80,$01,$00,$65,$40,$FB,$2C,$00,$01,$00,$66,$C0,$FC,$2C,$40,$00,$C0,$6A,$60,$89,$2C,$40,$00,$C0,$6B,$60,$8B,$2C,$FF
	Decompressed_Data_50: db $40,$00,$C0,$6A,$A0,$8B,$2C,$40,$00,$C0,$6B,$E0,$8B,$2C,$FF
	Decompressed_Data_52: db $60,$00,$20,$65,$C0,$FD,$2C,$60,$00,$20,$66,$20,$FE,$2C,$FF
	Decompressed_Data_54: db $60,$00,$20,$65,$80,$FE,$2C,$60,$00,$20,$66,$E0,$FE,$2C,$FF
	Decompressed_Data_56: db $60,$00,$20,$65,$40,$FF,$2C,$60,$00,$20,$66,$A0,$FF,$2C,$FF
	Decompressed_Data_58: db $60,$00,$20,$65,$80,$FB,$2C,$60,$00,$20,$66,$00,$FD,$2C,$FF
	Decompressed_Data_5A: db $40,$00,$60,$68,$20,$8C,$2C,$40,$00,$60,$69,$E0,$8C,$2C,$FF
	Decompressed_Data_5C: db $40,$00,$60,$68,$20,$8D,$2C,$40,$00,$60,$69,$E0,$8D,$2C,$FF
	Decompressed_Data_5E: db $40,$00,$60,$68,$20,$8E,$2C,$40,$00,$60,$69,$60,$8E,$2C,$FF
	Decompressed_Data_60: db $40,$00,$A0,$6A,$A0,$8E,$2C,$40,$00,$A0,$6B,$E0,$8E,$2C,$FF
	Decompressed_Data_62: db $00,$01,$00,$67,$20,$E5,$2C,$FF
	Decompressed_Data_64: db $00,$03,$00,$65,$20,$E2,$2C,$FF
	Decompressed_Data_66: db $00,$04,$00,$63,$20,$DE,$2C,$FF
	Decompressed_Data_68: db $FF
	Decompressed_Data_6A: db $FF
	Decompressed_Data_6C: db $FF
	Decompressed_Data_6E: db $FF
	Decompressed_Data_70: db $FF
	Decompressed_Data_72: db $FF
	Decompressed_Data_74: db $FF
	Decompressed_Data_76: db $FF
	Decompressed_Data_78: db $FF
	Decompressed_Data_7A: db $FF
	Decompressed_Data_7C: db $FF
	Decompressed_Data_7E: db $FF
	Decompressed_Data_80: db $40,$00,$C0,$6A,$A0,$87,$2C,$40,$00,$C0,$6B,$A0,$89,$2C,$FF
	Decompressed_Data_82: db $40,$00,$C0,$6A,$E0,$87,$2C,$40,$00,$C0,$6B,$E0,$89,$2C,$FF
	Decompressed_Data_84: db $40,$00,$C0,$6A,$20,$88,$2C,$40,$00,$C0,$6B,$20,$8A,$2C,$FF
	Decompressed_Data_86: db $40,$00,$C0,$6A,$60,$88,$2C,$40,$00,$C0,$6B,$60,$8A,$2C,$FF
	Decompressed_Data_88: db $40,$00,$C0,$6A,$A0,$88,$2C,$40,$00,$C0,$6B,$A0,$8A,$2C,$FF
	Decompressed_Data_8A: db $40,$00,$C0,$6A,$E0,$88,$2C,$40,$00,$C0,$6B,$E0,$8A,$2C,$FF
	Decompressed_Data_8C: db $40,$00,$C0,$6A,$20,$89,$2C,$40,$00,$C0,$6B,$20,$8B,$2C,$FF
	Decompressed_Data_8E: db $40,$00,$C0,$6A,$60,$89,$2C,$40,$00,$C0,$6B,$60,$8B,$2C,$FF
	Decompressed_Data_90: db $40,$00,$C0,$6A,$A0,$8B,$2C,$40,$00,$C0,$6B,$E0,$8B,$2C,$FF
	Decompressed_Data_92: db $80,$00,$A0,$6C,$60,$8C,$2C,$FF
	Decompressed_Data_94: db $00,$0A,$00,$00,$00,$60,$00,$FF
	Decompressed_Data_96: db $00,$0A,$00,$00,$00,$60,$00,$FF
	Decompressed_Data_98: db $00,$0A,$00,$00,$00,$60,$00,$FF
	Decompressed_Data_9A: db $00,$0A,$00,$00,$00,$60,$00,$FF
	Decompressed_Data_9C: db $00,$0A,$00,$00,$00,$60,$00,$FF
	Decompressed_Data_9E: db $00,$0A,$00,$00,$00,$60,$00,$FF
	Decompressed_Data_A0: db $00,$0A,$00,$00,$00,$60,$00,$FF
	Decompressed_Data_A2: db $00,$08,$00,$08,$00,$D0,$7F,$FF
	Decompressed_Data_A4: db $00,$08,$00,$0C,$00,$D8,$7F,$FF
	Decompressed_Data_A6: db $00,$08,$00,$30,$00,$D0,$7F,$FF
	Decompressed_Data_A8: db $00,$08,$00,$34,$00,$D8,$7F,$FF
	
;New decompressed data:
	Decompressed_Data_AA: ;Decompressed general VRAM
	dw $1080 ;How many bytes to send to VRAM
	dw $67C0 ;Where to store graphics in VRAM
	dl $FFBF80 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_AC: ;Decompressed Ride Chips in Menu
	dw $0400 ;How many bytes to send to VRAM
	dw $6E00 ;Where to store graphics in VRAM
	dl $FFB800 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_AE: ;Decompressed In-Game Menu Graphic Tiles
	dw $2E00 ;How many bytes to send to VRAM
	dw $1000 ;Where to store graphics in VRAM
	dl $FFD200 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_B0: ;Decompressed 'Z' graphic
	dw $0200 ;How many bytes to send to VRAM
	dw $3F80 ;Where to store graphics in VRAM
	dl $FFD000 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_B2: ;Decompressed Zero Get Weapon Graphics
	dw $2C00 ;How many bytes to send to VRAM
	dw $1000 ;Where to store graphics in VRAM
	dl $FF8C00 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_B4: ;Decompressed Zero Get Weapon Tile Map
	dw $0700 ;How many bytes to send to VRAM
	dw $5800 ;Where to store graphics in VRAM
	dl $C98000 ;Pointer to graphics in ROM
	db $FF ;End byte

	Decompressed_Data_B6: ;Decompressed In-Game Menu Tile Map
	dw $0700 ;How many bytes to send to VRAM
	dw $5800 ;Where to store graphics in VRAM
	dl $C8F800 ;Pointer to graphics in ROM
	db $FF ;End byte	

	Decompressed_Data_B8: ;Decompressed X & Zero Introduction Graphics
	dw $1CE0 ;How many bytes to send to VRAM
	dw $1000 ;Where to store graphics in VRAM
	dl $FEEF20 ;Pointer to graphics in ROM
	db $FF ;End byte	
	
	Decompressed_Data_BA: ;Decompressed X Menu Armor Chip Sprites
	dw $0100 ;How many bytes to send to VRAM
	dw $6E80 ;Where to store graphics in VRAM
	dl $FEEAE0 ;Pointer to graphics in ROM
	
	dw $0100 ;How many bytes to send to VRAM
	dw $6F80 ;Where to store graphics in VRAM
	dl $FEECE0 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_BC: ;Decompressed Zero 1-Up Sprites (In-Game)
	dw $00C0 ;How many bytes to send to VRAM
	dw $6CA0 ;Where to store graphics in VRAM
	dl $FFBC00 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_BE: ;Decompressed X Menu Portrait Sprites
	dw $0600 ;How many bytes to send to VRAM
	dw $6800 ;Where to store graphics in VRAM
	dl $FEE4E0 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_C0: ;Decompressed Password Screen Layer #1 Tile Map
	dw $0800 ;How many bytes to send to VRAM
	dw $5000 ;Where to store graphics in VRAM
	dl $C98800 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_C2: ;Decompressed Password Screen Layer #3 Tile Map
	dw $0800 ;How many bytes to send to VRAM
	dw $0800 ;Where to store graphics in VRAM
	dl $C99000 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_C4: ;Decompressed Zero 1-Up Sprites (Save Menu)
	dw $00C0 ;How many bytes to send to VRAM
	dw $6D00 ;Where to store graphics in VRAM
	dl $FFBC00 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_C6: ;Decompressed Zero Idle Pose (Save Menu)
	dw $01A0 ;How many bytes to send to VRAM
	dw $6800 ;Where to store graphics in VRAM
	dl $B18000 ;Pointer to graphics in ROM
	
	dw $0180 ;How many bytes to send to VRAM
	dw $6900 ;Where to store graphics in VRAM
	dl $B181A0 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_C8: ;Decompressed 'READY' text for Zero
	dw $02C0 ;How many bytes to send to VRAM
	dw $6000 ;Where to store graphics in VRAM
	dl $FFBCC0 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_CA: ;Decompressed 'READY' text for Zero when PC is already on screen
	dw $02C0 ;How many bytes to send to VRAM
	dw $6600 ;Where to store graphics in VRAM
	dl $FFBCC0 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_CC: ;Decompressed Layer 3 Get Weapon Tile Map
	dw $0700 ;How many bytes to send to VRAM
	dw $0800 ;Where to store graphics in VRAM
	dl $C9A000 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_CE: ;Decompressed X Get Weapon Armor pieces
	dw $2C00 ;How many bytes to send to VRAM
	dw $2000 ;Where to store graphics in VRAM
	dl $FEB800 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_D0: ;Decompressed Layer 1 box tilemap
	dw $0200 ;How many bytes to send to VRAM
	dw $5200 ;Where to store graphics in VRAM
	dl $C9B000 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_D2: ;Decompressed Layer 1 box tilemap (Used to wipe Layer 3's box)
	dw $0200 ;How many bytes to send to VRAM
	dw $0A00 ;Where to store graphics in VRAM
	dl $C9B000 ;Pointer to graphics in ROM
	db $FF ;End byte
	
	Decompressed_Data_D4: ;Decompressed Layer 1 X Get Weapon Tile Map (Helmet)
	dw $0200 ;How many bytes to send to VRAM
	dw $5000 ;Where to store graphics in VRAM
	dl $C9B200 ;Pointer to graphics in ROM
	db $FF ;End byte
}

LoadPCMissiles: ;Routine for Loading PC missiles. Had to be moved with the table itself otherwise it'd break)
{ 
	 { ;Load PC Missiles routine
		LDA $0A
		ASL
		TAX
		JSR (PC_MissileObjects_Pointers,x)
		RTL
	}

PC_MissileObjects_Pointers: ;Loads pointers and JSL for all PC Missile Objects in-game
	{
		dw PC_MissileObject_00 ;Level 1 buster
		dw PC_MissileObject_01 ;Level 2 buster
		dw PC_MissileObject_02 ;Level 3 buster/Z-Saber
		dw PC_MissileObject_03 ;Level 4/5 buster (Using Level 3 shot)
		dw PC_MissileObject_04 ;Z-Saber Wave
		dw PC_MissileObject_05 ;Z-Saber Wave (Cutting enemy)
		dw PC_MissileObject_06 ;Level 1 Buster (Dashing)
		dw PC_MissileObject_07 ;Acid Burst
		dw PC_MissileObject_08 ;Parasitic Bomb
		dw PC_MissileObject_09 ;Triad Thunder
		dw PC_MissileObject_0A ;Spinning Blades
		dw PC_MissileObject_0B ;Ray Splasher
		dw PC_MissileObject_0C ;Gravity Well
		dw PC_MissileObject_0D ;Frost Shield
		dw PC_MissileObject_0E ;Tornado Fang
		dw PC_MissileObject_0F ;Triad Thunder (Electric Connection Orbs)
		dw PC_MissileObject_10 ;Acid Burst (Charged)
		dw PC_MissileObject_11 ;Parasitic Bomb (Charged)
		dw PC_MissileObject_12 ;Triad Thunder (Charged)
		dw PC_MissileObject_13 ;Spinning Blades (Charged)
		dw PC_MissileObject_14 ;Ray Splasher (Charged)
		dw PC_MissileObject_15 ;Gravity Well (Charged)
		dw PC_MissileObject_16 ;Frost Shield (Charged)
		dw PC_MissileObject_17 ;Tornado Fang (Charged)
		dw PC_MissileObject_18 ;Acid Burst droplets
		dw PC_MissileObject_19 ;Ride Armor Punch (All)
		dw PC_MissileObject_1A ;???
		dw PC_MissileObject_1B ;Triad Thunder lightning
		dw PC_MissileObject_1C ;Ray Splasher projectiles
		dw PC_MissileObject_1D ;Level 4 Buster (X - Spiral)
		dw PC_MissileObject_1E ;Parasitic Bomb (Latched on enemy)
		dw PC_MissileObject_1F ;Combined X Shot (Large center shot)
		dw PC_MissileObject_20 ;Combined X Shot (Pellets)
		dw PC_MissileObject_21 ;Frost Shield (Charged - When touches enemy)
		dw PC_MissileObject_22 ;Kangaroo Armor (Charged)
		dw PC_MissileObject_23 ;Hawk Armor (Missiles)
		dw PC_MissileObject_24 ;Frog Armor (Missiles)
		dw PC_MissileObject_25 ;BLANK

		;New missiles
		dw PC_MissileObject_26 ;Level 2 buster again just so it doesn't stack damage
		dw PC_MissileObject_27 ;Level 4 Buster (Zero - Spiral)




		PC_MissileObject_00: JSL $8188D2 : RTS	;22 D2 88 01 60 ;Level 1 buster
		PC_MissileObject_01: JSL $818974 : RTS	;22 74 89 01 60 ;Level 2 buster
		PC_MissileObject_02: JSL $818CC2 : RTS	;22 C2 8C 01 60 ;Level 3 buster/Z-Saber
		PC_MissileObject_03: JSL $818FA2 : RTS	;22 A2 8F 01 60 ;Level 4/5 buster (Using Level 3 shot)
		PC_MissileObject_04: JSL $818E3A : RTS	;22 3A 8E 01 60 ;Z-Saber Wave
		PC_MissileObject_05: JSL $818E3A : RTS	;22 3A 8E 01 60 ;Z-Saber Wave (Cutting enemy)
		PC_MissileObject_06: JSL $818AE9 : RTS	;22 E9 8A 01 60 ;Level 1 buster (Dashing)
		PC_MissileObject_07: JSL $819143 : RTS	;22 43 91 01 60 ;Acid Burst
		PC_MissileObject_08: JSL $8196EA : RTS	;22 EA 96 01 60 ;Parasitic Bomb
		PC_MissileObject_09: JSL $819A0B : RTS	;22 0B 9A 01 60 ;Triad Thunder
		PC_MissileObject_0A: JSL $81A035 : RTS	;22 35 A0 01 60 ;Spinning Blades
		PC_MissileObject_0B: JSL $81A18B : RTS	;22 8B A1 01 60 ;Ray Splasher
		PC_MissileObject_0C: JSL $81A3CD : RTS	;22 CD A3 01 60 ;Gravity Well
		PC_MissileObject_0D: JSL $81A672 : RTS	;22 72 A6 01 60 ;Frost Shield
		PC_MissileObject_0E: JSL $81A9F6 : RTS	;22 F6 A9 01 60 ;Tornado Fang
		PC_MissileObject_0F: JSL $81B230 : RTS	;22 30 B2 01 60 ;Triad Thunder (Electric Connection Orbs)
		PC_MissileObject_10: JSL $81946D : RTS	;22 6D 94 01 60 ;Acid Burst (Charged)
		PC_MissileObject_11: JSL $81AC82 : RTS	;22 82 AC 01 60 ;Parasitic Bomb (Charged)
		PC_MissileObject_12: JSL $81B167 : RTS	;22 67 B1 01 60 ;Triad Thunder (Charged)
		PC_MissileObject_13: JSL $81B423 : RTS	;22 23 B4 01 60 ;Spinning Blades (Charged)
		PC_MissileObject_14: JSL $81B7B6 : RTS	;22 B6 B7 01 60 ;Ray Splasher (Charged)
		PC_MissileObject_15: JSL $81B915 : RTS	;22 15 B9 01 60 ;Gravity Well (Charged)
		PC_MissileObject_16: JSL $81BAC8 : RTS	;22 C8 BA 01 60 ;Frost Shield (Charged)
		PC_MissileObject_17: JSL $81BE58 : RTS	;22 58 BE 01 60 ;Tornado Fang (Charged)
		PC_MissileObject_18: JSL $8193AC : RTS	;22 AC 93 01 60 ;Acid Burst droplets
		PC_MissileObject_19: JSL $81C095 : RTS	;22 95 C0 01 60 ;Ride Armor Punch (All)
		PC_MissileObject_1A: JSL $81C095 : RTS	;22 95 C0 01 60 ;???
		PC_MissileObject_1B: JSL $819CD3 : RTS	;22 D3 9C 01 60 ;Triad Thunder (Lightning)
		PC_MissileObject_1C: JSL $81A243 : RTS	;22 43 A2 01 60 ;Ray Splasher (Projectiles)
		PC_MissileObject_1D: JSL $81C0E8 : RTS	;22 E8 C0 01 60 ;Level 4 Buster (X - Spiral)
		PC_MissileObject_1E: JSL $8197AB : RTS	;22 AB 97 01 60 ;Parasitic Bomb (Latched on enemy)
		PC_MissileObject_1F: JSL $81C54D : RTS	;22 4D C5 01 60 ;Combined X Shot (Large center shot)
		PC_MissileObject_20: JSL $81C54D : RTS	;22 4D C5 01 60 ;Combined X shot (Pellets)
		PC_MissileObject_21: JSL $81BAC8 : RTS	;22 C8 BA 01 60 ;Frost Shield (Charged - When touches enemy)
		PC_MissileObject_22: JSL $81C763 : RTS	;22 63 C7 01 60 ;Kangaroo Armor (Charged)
		PC_MissileObject_23: JSL $81C8AF : RTS	;22 AF C8 01 60 ;Hawk Armor (Missiles)
		PC_MissileObject_24: JSL $81C97A : RTS	;22 7A C9 01 60 ;Frog Armor (Missiles)
		PC_MissileObject_25: RTS			;60 ;BLANK


		;New missiles
		PC_MissileObject_26: JSL $818974 : RTS	;Level 2 Buster Repeat (So it doesn't allow spamming level 2 shots for constant damage)
		PC_MissileObject_27: JSL Zero_SpiralBuster : RTS	;Level 4 Buster (Zero - Spiral)
	}
}

;PC Level 4/5 missiles to launch
{
X_Level4_5_Shots: ;Load X's first/second shot for Level 4/5 buster
	db $00,$1D,$1D,$00,$00,$01,$03,$00
Zero_Level4_5_Shots: ;Load Zero's first/second shot for Level 4/5 buster
	db $00,$01,$03,$00,$00,$03,$03,$00
Zero_Level4_5_Spiral_Shots: ;Load Zero's first/second shot for Level 4/5 buster
	db $00,$01,$03,$00,$00,$03,$27,$00
}
