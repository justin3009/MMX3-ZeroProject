# Mega Man X3 - Base Mod (Zero Project)
A mod of the original Mega Man X3 game by Capcom for the Super Nintendo. This aims to make Zero fully playable without him being cut from the game when you die as him.

## Requirements
http://www.romhacking.net/utilities/224/ - Atlas
https://github.com/RPGHacker/asar - Asar
http://www.romhacking.net/utilities/27/ - Lunar Expand

In order to compile all the files, you MUST have clean Mega Man X3 (U) ROM that has NO HEADER. Asar must also be used to compile all the files. The file extension for the ROM must be renamed to .sfc as that's noted to asar that it's an unheadered file. It's very likely you'll need to expand the game to 4MB as well by using Lunar Expand. I generally labeled the base file as 'Base_ROM.sfc' and when the 'Asar MMX3.bat' file is run, it'll spit out MMX3.sfc which houses all the changes. It's highly recommended to run this through Atlas first for the base ROM so you don't have to keep redoing Atlas everytime you update.

The 'Atlas' folder just needs an 'Atlas.exe' in there and you can use any of the .bats to update things as needed.

### Features/Changes

* Zero is playable at any time including the introduction level! However, if you obtain the Z-Saber as per usual, Zero is unavailable.
* Zero can use sub-weapons, although at double the cost and he cannot charge them.
* Zero starts off with his air-dash and double jump.
* Zero can collect all normal upgrades and benefit from them, while capsules can be collected for X by Zero.
* The Golden Armor/Black Armor capsule is the only capsule that gives Zero an upgrade. He will have an overall speed increase, defense increase, the Z-Saber will deal an extra +2 damage with a new purple hue, Zero's air-dash time and ground-dash time are also lengthened. His sub-weapon ammo consumption returns to normal after the Black Armor is obtained.
* Z-Saber damaged is varied per boss based on their credit roll statistics. It uses their speed + power as the general idea. Whomever has the most combined takes the least damage.
* Zero can use Ride Armors.
* Zero has +4 more health than X to help offset his size difference.
* Zero CANNOT use the Hyper Charge (Hyper C.) and is unable to select it via L/R buttons or even in the menu. However, X can use it at any time if the ammo is +4. Though, X CANNOT use the Z-Saber when using the Hyper Charge. It will only use Charged Shots.
* X and Zero both have increased animation speed with their buster and Z-Saber animations. Zero's Z-Saber animation is much quicker and X's buster animations are also quicker. X’s vertical dash speed has been increased slightly as well.
* X no longer has a ‘shield’ with any of the armor upgrades but he does retain the overall defense increase.
* X’s health regeneration is much quicker with the Helmet Chip and it also heals more over time. If health is regenerated successfully, it’ll double each time capping at a max of 08. So, it’ll heal 01, 02, 04, 08. This GREATLY reduces the time X must wait to refill Sub-tanks and his own health.
* The Helmet Upgrade has been changed to also cut the sub-weapon ammo usage in half. The code indicates that you had to have both Helmet and Armor upgrades, but in other instances the code only checked for the helmet. So this was altered to be apart of the helmet. The dialogue has been updated to compensate for this change as well.
* Various normal game bugs have been fixed including (hopefully) the ‘Lemon Bug’ in which you would be stuck using base buster shots until you opened the menu screen and switched to a new sub-weapon.
* Dialogue has been heavily updated to indicate both characters being playable.
* Events in which Zero would show up now display X if you're playing as Zero. Vice versa for the other character.
* Sub-tanks are updated to work like Mega Man Zero in which they only refill until your health is full.
* The game remembers who you last played as when you either die or complete a level
* The combo system is 'technically' reintroduced from X2 with each character's buster and/or saber combo. Buster shots from both characters can combo together. Zero can combo with his saber slash. Technically, sub-weapons can combo as well but their damage has been set to 00 due to multiple hits or quick spam.
* X's cross-over shot has been altered so the smaller energy shots cross each other in a smaller screen range but will hit their target a lot more steadily dealing massive damage.
* Ride Armor chips can be gathered and used at any time as long as you have at least one Ride Armor chip. You don't need the first in the list anymore.
* The 'X' on the Stage Select screen can be used for a quick swap before entering a level. It'll show an 'X' for X and a 'Z' for Zero.
* Black Armor and Golden Armor have new portrait palettes inside the menu.
* Zero will get warned by X about Mosquitus in the first Doppler Lab level. This is done so you don't accidentally walk in with Zero and lose the Z-Saber.
* New Game+ has been introduced into the game along with a save system. However, the save system breaks compatability with some emulators (Such as bsnes).
* MSU-1 should be compatible no matter the version. The coding area remains untouched in which the MSU-1 uses.
* X and Zero's upgrade data that gets saved has been moved entirely into a new location. This is easier for modifying and technically allows up to four playable characters in total in a single game if modified properly.
* The Golden Armor can be obtained in two manners instead of just the one. The first one is still as normal, get all upgrades, have full life. The second one just requires the user to 'collect' each chip enhancement. If that is done then you can also collect the Golden Armor. Each enhancement chip collected will appear in the menu and will have a golden color if it's currently the one being used.
* The (F)rog Armor has been updated greatly. It can now function on land like a normal Ride Armor including walking, dashing, and proper jumping. It'll function like it normally does underwater with the added bonus of being able to walk instead of hop everywhere.
* The boulders in Tunnel Rhino's stage can be destroyed by a plethora of weapons now. The Z-Saber, Tornado Drill, Spinning Blades, and Triad Thunder now all work on it.
* The platform in Crush Crawfish's stage that gets blown up to find the (H)awk Armor chip can now be destroyed by Tornado Fang and the (F)rog Armor missiles. Tornado Drill's spread has been increased so now it's capable of hitting the platform.
* The Gravity Well section in Volt Catfish's stage has been entirely replaced with a spiked wall jump area instead. This allows for gathering the Armor upgrade a lot earlier instead of locking it off with an upgrade only mechanic.
* Zero has his own unique 'GET WEAPON' portrait. (Thanks to Metalwario64 for his gracious work!)
* X's 'GET WEAPON' screen is slightly updated. He'll show his unused blue palette upon first loading but when the screen flashes it'll load his weapon palette.
* X and Zero now have their own 1-up icons displayed in-game.
* Bit and Byte now spawn 50/50. There's no specific designation of when they will now spawn. If 7 or more bosses are destroyed and either Bit or Byte is destroyed, the other will have a 100% chance of spawning no matter what unless they've been fought once as well.
* Bit/Byte/Vile encounters have had their battle theme changed to Doppler's battle theme to note their alliance with him.
* Bit/Byte can be encountered on any stage including ones that have been beaten as long as Doppler's Lab hasn't been unconvered.
* Dialogue can now be skipped by pressing the 'START' button. This cuts straight to the end of the sequence.

