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
		
		!X_SubStringPointer	= $CAC040
		!Zero_SubStringPointer	= $CAC100
		!PC3_SubStringPointer	= $CAC1C0
		!PC4_SubStringPointer	= $CAC280
		
		!ZeroMainEvents	= $E08080
		!XMainEvents	= $E0C000
		!BaseItemObjectLocation		= $E48000
		!InteractiveObjectBase		= $D78000
;***************************
header : lorom

incsrc MMX3_NewCode_Locations.asm
incsrc MMX3_VariousAddresses.asm

;***************************
;***************************
; New location for Interactive object list
; Removes the entirety of the old Interactive object list and moves it to a new location.
;***************************
org $93C5F3 ;Remove storage to PC Checker so it doesn't break the game.
	NOP #5

org $80DD20
	JSL !InteractiveObjectBase
	RTS
	NOP #2
	
org !InteractiveObjectBase ;IE: Enemies, Capsules, etc..
	LDA $0A
	ASL
	TAX
	JMP (InteractiveObjects,x)

InteractiveObjects:
	dw InteractiveObject00
	dw InteractiveObject01
	dw InteractiveObject02
	dw InteractiveObject03
	dw InteractiveObject04
	dw InteractiveObject05
	dw InteractiveObject06 ;Earth Commander
	dw InteractiveObject07
	dw InteractiveObject08
	dw InteractiveObject09
	dw InteractiveObject0A
	dw InteractiveObject0B
	dw InteractiveObject0C
	dw InteractiveObject0D
	dw InteractiveObject0E
	dw InteractiveObject0F
	dw InteractiveObject10
	dw InteractiveObject11 ;Crabblaster
	dw InteractiveObject12
	dw InteractiveObject13
	dw InteractiveObject14
	dw InteractiveObject15
	dw InteractiveObject16
	dw InteractiveObject17
	dw InteractiveObject18
	dw InteractiveObject19
	dw InteractiveObject1A
	dw InteractiveObject1B
	dw InteractiveObject1C
	dw InteractiveObject1D
	dw InteractiveObject1E
	dw InteractiveObject1F
	dw InteractiveObject20
	dw InteractiveObject21
	dw InteractiveObject22
	dw InteractiveObject23
	dw InteractiveObject24
	dw InteractiveObject25
	dw InteractiveObject26
	dw InteractiveObject27
	dw InteractiveObject28
	dw InteractiveObject29
	dw InteractiveObject2A
	dw InteractiveObject2B
	dw InteractiveObject2C
	dw InteractiveObject2D
	dw InteractiveObject2E
	dw InteractiveObject2F
	dw InteractiveObject30
	dw InteractiveObject31
	dw InteractiveObject32
	dw InteractiveObject33
	dw InteractiveObject34
	dw InteractiveObject35
	dw InteractiveObject36
	dw InteractiveObject37
	dw InteractiveObject38
	dw InteractiveObject39
	dw InteractiveObject3A
	dw InteractiveObject3B
	dw InteractiveObject3C
	dw InteractiveObject3D
	dw InteractiveObject3E
	dw InteractiveObject3F
	dw InteractiveObject40
	dw InteractiveObject41
	dw InteractiveObject42
	dw InteractiveObject43
	dw InteractiveObject44
	dw InteractiveObject45
	dw InteractiveObject46
	dw InteractiveObject47
	dw InteractiveObject48
	dw InteractiveObject49
	dw InteractiveObject4A
	dw InteractiveObject4B
	dw InteractiveObject4C
	dw InteractiveObject4D ;Capsules
	dw InteractiveObject4E
	dw InteractiveObject4F
	dw InteractiveObject50
	dw InteractiveObject51
	dw InteractiveObject52
	dw InteractiveObject53
	dw InteractiveObject54
	dw InteractiveObject55
	dw InteractiveObject56
	dw InteractiveObject57
	dw InteractiveObject58
	dw InteractiveObject59
	dw InteractiveObject5A
	dw InteractiveObject5B
	dw InteractiveObject5C
	dw InteractiveObject5D
	dw InteractiveObject5E
	dw InteractiveObject5F
	dw InteractiveObject60
	dw InteractiveObject61
	dw InteractiveObject62
	dw InteractiveObject63
	dw InteractiveObject64
	dw InteractiveObject65
	dw InteractiveObject66
	dw InteractiveObject67
	dw InteractiveObject68
	dw InteractiveObject69
	dw InteractiveObject6A
	dw InteractiveObject6B
	dw InteractiveObject6C
	dw InteractiveObject6D
	
	
	
	
InteractiveObject00:
	RTL			;60 
InteractiveObject01:
	JSL $82E10E		;22 0E E1 02 60
	RTL				
InteractiveObject02:
	JSL $8784EB		;22 EB 84 07 60
	RTL
InteractiveObject03:
	JSL $878580		;22 80 85 07 60
	RTL
InteractiveObject04:
	JSL $87979F		;22 9F 97 07 60
	RTL
InteractiveObject05:
	JSL $8797CA		;22 CA 97 07 60
	RTL
InteractiveObject06: ;Earth Commander
	JSL $87995D		;22 5D 99 07 60
	RTL
InteractiveObject07:
	JSL $879D66		;22 66 9D 07 60
	RTL
InteractiveObject08:
	JSL $87879F		;22 9F 87 07 60
	RTL
InteractiveObject09:
	JSL $85B7AC		;22 AC B7 05 60
	RTL
InteractiveObject0A:
	JSL $879EB6		;22 B6 9E 07 60
	RTL
InteractiveObject0B:
	JSL $87A2A3		;22 A3 A2 07 60
	RTL
InteractiveObject0C:
	JSL $87A5B3		;22 B3 A5 07 60
	RTL
InteractiveObject0D:
	JSL $87A90A		;22 0A A9 07 60
	RTL
InteractiveObject0E:
	JSL $87ACC1		;22 C1 AC 07 60
	RTL
InteractiveObject0F:
	JSL $87B030		;22 30 B0 07 60
	RTL
InteractiveObject10:
	JSL $87B440		;22 40 B4 07 60
	RTL
InteractiveObject11: ;Crabblaster
	JSL $87B68F		;22 8F B6 07 60
	RTL
InteractiveObject12:
	JSL $87B9C5		;22 C5 B9 07 60
	RTL
InteractiveObject13:
	JSL $87B9C5		;22 C5 B9 07 60
	RTL
InteractiveObject14:
	JSL $87BB2A		;22 2A BB 07 60
	RTL
InteractiveObject15:
	JSL $87BC3A		;22 3A BC 07 60
	RTL
InteractiveObject16:
	JSL $87C064		;22 64 C0 07 60
	RTL
InteractiveObject17:
	JSL $87C2FC		;22 FC C2 07 60
	RTL
InteractiveObject18:
	JSL $87C43F		;22 3F C4 07 60
	RTL
InteractiveObject19:
	JSL $8797CA		;22 CA 97 07 60
	RTL
InteractiveObject1A:
	JSL $87B9C5		;22 C5 B9 07 60
	RTL
InteractiveObject1B:
	JSL $87C777		;22 77 C7 07 60
	RTL
InteractiveObject1C:
	JSL $87CB66		;22 66 CB 07 60
	RTL
InteractiveObject1D:
	JSL $87D011		;22 11 D0 07 60
	RTL
InteractiveObject1E:
	JSL $87D41D		;22 1D D4 07 60
	RTL
InteractiveObject1F:
	JSL $87D82C		;22 2C D8 07 60
	RTL
InteractiveObject20:
	JSL $BFE3A6		;22 A6 E3 3F 60
	RTL
InteractiveObject21:
	JSL $84DF93		;22 93 DF 04 60
	RTL
InteractiveObject22:
	JSL $87DBEE		;22 EE DB 07 60
	RTL
InteractiveObject23:
	JSL $87DE81		;22 81 DE 07 60
	RTL
InteractiveObject24:
	JSL $87E1A9		;22 A9 E1 07 60
	RTL
InteractiveObject25:
	JSL $87E322		;22 22 E3 07 60
	RTL
InteractiveObject26:
	JSL $87E3DE		;22 DE E3 07 60
	RTL
InteractiveObject27:
	JSL $B99225		;22 25 92 39 60
	RTL
InteractiveObject28:
	JSL $87E65D		;22 5D E6 07 60
	RTL
InteractiveObject29:
	JSL $87E9EF		;22 EF E9 07 60
	RTL
InteractiveObject2A:
	JSL $87EE88		;22 88 EE 07 60
	RTL
InteractiveObject2B:
	JSL $87F05A		;22 5A F0 07 60
	RTL
InteractiveObject2C:
	JSL $85B9CA		;22 CA B9 05 60
	RTL
InteractiveObject2D:
	JSL $87F1AD		;22 AD F1 07 60
	RTL
InteractiveObject2E:
	JSL $87F71E		;22 1E F7 07 60
	RTL
InteractiveObject2F:
	JSL $83D6B3		;22 B3 D6 03 60
	RTL
InteractiveObject30:
	JSL $BCA000		;22 00 A0 3C 60
	RTL
InteractiveObject31:
	JSL $84E054		;22 54 E0 04 60
	RTL
InteractiveObject32:
	JSL $85BB08		;22 08 BB 05 60
	RTL
InteractiveObject33:
	JSL $82E28B		;22 8B E2 02 60
	RTL
InteractiveObject34:
	JSL $BCAA18		;22 18 AA 3C 60
	RTL
InteractiveObject35:
	JSL $BCAB43		;22 43 AB 3C 60
	RTL
InteractiveObject36:
	JSL $87F885		;22 85 F8 07 60
	RTL
InteractiveObject37:
	JSL $81CBA9		;22 A9 CB 01 60
	RTL
InteractiveObject38:
	JSL $85BBE6		;22 E6 BB 05 60
	RTL
InteractiveObject39:
	JSL $BCB1B6		;22 B6 B1 3C 60
	RTL
InteractiveObject3A:
	JSL $81CCC4		;22 C4 CC 01 60
	RTL
InteractiveObject3B:
	JSL $81CD9B		;22 9B CD 01 60
	RTL
InteractiveObject3C: ;Crush Crawfish Platform for Triad Thunder to destroy
	JSL $81CDF5		;22 F5 CD 01 60
	RTL
InteractiveObject3D:
	JSL $85BDBF		;22 BF BD 05 60
	RTL
InteractiveObject3E:
	JSL $BCB357		;22 57 B3 3C 60
	RTL
InteractiveObject3F:
	JSL $87F989		;22 89 F9 07 60
	RTL
InteractiveObject40:
	JSL $85C109		;22 09 C1 05 60
	RTL
InteractiveObject41:
	JSL $BCB52A		;22 2A B5 3C 60
	RTL
InteractiveObject42: ;Toxic Seahorse mid-boss
	JSL $BDF884		;22 84 F8 3D 60
	RTL
InteractiveObject43:
	JSL $B2F2E9		;22 E9 F2 32 60
	RTL
InteractiveObject44:
	JSL $878E07		;22 07 8E 07 60
	RTL
InteractiveObject45:
	JSL $878AA3		;22 A3 8A 07 60
	RTL
InteractiveObject46:
	JSL $878F43		;22 43 8F 07 60
	RTL
InteractiveObject47:
	JSL $BCC444		;22 44 C4 3C 60
	RTL
InteractiveObject48:
	JSL $93D58A		;22 8A D5 13 60
	RTL
InteractiveObject49:
	JSL $879474		;22 74 94 07 60
	RTL
InteractiveObject4A:
	JSL $BCB5FD		;22 FD B5 3C 60
	RTL
InteractiveObject4B:
	JSL $85C378		;22 78 C3 05 60
	RTL
InteractiveObject4C:
	JSL $85C5C9		;22 C9 C5 05 60
	RTL
InteractiveObject4D:
	JSL $93C000		;22 00 C0 13 60 ;Capsules
	RTL
InteractiveObject4E:
	JSL $85C6C7		;22 C7 C6 05 60
	RTL
InteractiveObject4F:
	JSL $BCBECE		;22 CE BE 3C 60
	RTL
InteractiveObject50:
	JSL $82E7DE		;22 DE E7 02 60
	RTL
InteractiveObject51:
	JSL $BCCA25		;22 25 CA 3C 60
	RTL
InteractiveObject52:
	JSL $83C861		;22 61 C8 03 60
	RTL
InteractiveObject53:
	JSL $B99BA9		;22 A9 9B 39 60
	RTL
InteractiveObject54:
	JSL $83D03D		;22 3D D0 03 60
	RTL
InteractiveObject55:
	JSL $BFE5E4		;22 E4 E5 3F 60
	RTL
InteractiveObject56:
	JSL $93DCA0		;22 A0 DC 13 60
	RTL
InteractiveObject57:
	JSL $93E493		;22 93 E4 13 60
	RTL
InteractiveObject58:
	JSL $93EA67		;22 67 EA 13 60
	RTL				
InteractiveObject59:
	JSL $93F239		;22 39 F2 13 60
	RTL
InteractiveObject5A:
	JSL $93C5FD		;22 FD C5 13 60
	RTL	
InteractiveObject5B:
	JSL $8891F2		;22 F2 91 08 60
	RTL	
InteractiveObject5C:
	JSL $85C837		;22 37 C8 05 60
	RTL
InteractiveObject5D:
	JSL $858E14		;22 14 8E 05 60
	RTL
InteractiveObject5E:
	JSL $85939E		;22 9E 93 05 60
	RTL
InteractiveObject5F:
	JSL $859904		;22 04 99 05 60
	RTL
InteractiveObject60:
	JSL $859F77		;22 77 9F 05 60
	RTL
InteractiveObject61:
	JSL $85A2D2		;22 D2 A2 05 60
	RTL
InteractiveObject62:
	JSL $88B7B1		;22 B1 B7 08 60
	RTL
InteractiveObject63:
	JSL $85AB30		;22 30 AB 05 60
	RTL
InteractiveObject64:
	JSL $BFECA2		;22 A2 EC 3F 60
	RTL
InteractiveObject65:
	JSL $B9A2A8		;22 A8 A2 39 60
	RTL
InteractiveObject66:
	JSL $82F263		;22 63 F2 02 60
	RTL
InteractiveObject67:
	JSL $85B159		;22 59 B1 05 60
	RTL
InteractiveObject68:
	JSL $B2F73A		;22 3A F7 32 60
	RTL
InteractiveObject69:
	JSL $8181F1		;22 F1 81 01 60
	RTL
InteractiveObject6A:
	RTL				;60 
InteractiveObject6B:
	JSL $87FBDB		;22 DB FB 07 60 
	RTL
InteractiveObject6C:
	RTL				;60
InteractiveObject6D:
	RTL				;60
	
