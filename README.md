# Mega Man X3 - Base Mod (Zero Project)

A mod of the original Mega Man X3 game by Capcom for the Super Nintendo. This aims to make Zero fully playable without him being cut from the game when you die as him.
Requirements

http://www.romhacking.net/utilities/224/ - Atlas

https://github.com/RPGHacker/asar - Asar

http://www.romhacking.net/utilities/27/ - Lunar Expand

## Requirements
* Lunar Expand is needed to expand the ROM to 4MB before compiling.
* Atlas is needed to insert various table files and text data.
  * It is highly recommended to do this first after ROM expansion so you won't need to constantly recompile any coding changes.
* Asar must be used as the compiler.
* MUST have a clean Mega Man X3 (U) ROM renamed to a .sfc header as this notates that it's unheadered for Asar.

### Features (Zero)

* Zero is playable at any time including the introduction level! However, if the player obtains the Z-Saber as per usual then Zero is unavailable.
* Zero can use sub-weapons, although at double the cost and he cannot charge them.
* Zero starts off with his air-dash and double jump.
* Zero CANNOT use the Hyper Charge (Hyper C.) and is unable to select it via L/R buttons or even in the menu. 
* Zero can collect all normal upgrades and benefit from them, while capsules can be collected for X by Zero.
* Zero ONLY gets one capsule upgrade and that is the the Golden Armor/Black Armor capsule.
	* He will have an overall speed increase, defense increase, the Z-Saber will deal an extra +2 damage with a new purple hue, Zero's air-dash time and ground-dash time are also lengthened. His sub-weapon ammo consumption returns to normal after the Black Armor is obtained.
* Z-Saber damaged is varied per boss based on their credit roll statistics. It uses their speed + power as the general idea. Whomever has the most combined takes the least damage.
* Zero can use Ride Armors.
* Zero has +4 more health than X to help offset his size difference.
* Zero CANNOT use the Hyper Charge (Hyper C.) and is unable to select it via L/R buttons or even in the menu. However, X can use it at any time if the ammo is +4. Though, X CANNOT use the Z-Saber when using the Hyper Charge. It will only use Charged Shots.
* Zero has increased animation speed with is Z-Saber and a slight increase with his buster speed.
* Zero will get warned by X about Mosquitus in the first Doppler Lab level. This is done so the player don't accidentally walk in with Zero and lose the Z-Saber.
* Zero has his own unique 'GET WEAPON' portrait. (Thanks to Metalwario64 for his gracious work!)
* Zero has his own 1-up icon in game now.

#### Features (X)

* X can use the Hyper Charge (Hyper C.) at any time if the ammo is >= 4. Though, X CANNOT use the Z-Saber when using the Hyper Charge. It will only use Charged Shots.
* X's buster animation speed has been greatly increased. His Z-Saber swing animation has been very subtly sped up as well.
* X’s vertical dash speed has been increased slightly.
* X no longer has a ‘shield’ with any of the armor upgrades but he does retain the overall defense increase.
* X’s health regeneration is much quicker with the Helmet Chip and it also heals more over time. If health is regenerated successfully, it’ll double each time capping at a max of 08. So, it’ll heal 01, 02, 04, 08. This GREATLY reduces the time X must wait to refill Sub-tanks and his own health.
* X's Helmet Upgrade has been changed to also cut the sub-weapon ammo usage in half.
	* The code indicates that you had to have both helmet and armor upgrades, but in other instances the code only checked for the helmet. So this was altered to be apart of the helmet. The dialogue has been updated to compensate for this change as well.
* X's cross-over shot has been altered so the smaller energy shots cross each other in a smaller screen range but will hit their target a lot more steadily dealing massive damage.
* X's 'GET WEAPON' screen is slightly updated.
	* He'll show his unused blue palette upon first loading but when the screen flashes it'll load his weapon palette.

##### General Changes And Enhancements
* The password system has been entirely removed and the game now uses 'saved game' system instead. Up to twenty games can be saved in separate files! The downside is some emulators may not work, such as bsnes due to this change. Save files will display:
	* Sub-weapons obtained.
	* Heart tanks obtained.
	* Current lives.
	* Sub-tanks obtained.
	* Ride Armor modules obtained.
	* Armor enhancement chips obtained.
	* Whether Bit/Byte/Vile are destroyed.
	* Whether the game is New Game+ or not using 'CLEAR' as the note..
	* Who was last played with (X or Zero will be up front to notate this).
	* All armor upgrades (Will be displayed on the character).
	* New Game+ weapons will be grayed out and then re-lit up once you have obtained them
* New Game+ has been introduced into the game. This will carry over any upgrade that was obtained from the last game.
* When the game is cleared, there'll be a new screen dictating to 'Press Any Button' and will allow you to save your data. Immediately after, the game will reset.
* Dialogue can now be skipped by pressing the 'START' button. This cuts straight to the end of the sequence.
* The in-game menu has been slightly updated. If X has obtained the Z-Saber, it'll show a Z-Saber icon. Zero has his own icon for the 'Z-Buster'.
* The ‘Lemon Bug’ in which you would be stuck using base buster shots until you opened the menu screen and switched to a new sub-weapon has been fixed... Hopefully.
* Double air-dash and vertical dash code has been greatly rewritten so it's based on a specific number depending on which character you're playing as. Easily changable in the code.
* Dialogue has been heavily updated to indicate both characters being playable.
	* Dialogue has been completely split as well so any PC has their own dialogue in a separate text file.
* Events in which Zero would show up now display X if Zero is currently being played. Vice versa for the other character.
* Events in which X appear as an NPC now have him display his armor properly!
* Sub-tanks are updated to work like Mega Man Zero in which they only refill until your health is full.
* The game remembers who was last played as when either the player runs out of lives or completes a level.
* The combo system is 'technically' reintroduced from X2 with each character's buster and/or saber can cause consecutive damage.
	* Buster shots from both characters can combo together. Technically, sub-weapons can combo as well but their damage has been set to 00 in the combo tables due to multiple hits or quick spam.
* Ride Armor chips can be gathered and used at any time as long as you have at least one Ride Armor chip. You don't need the first in the list anymore.
* The 'X' on the Stage Select screen can be used for a quick swap before entering a level. It'll show an 'X' for X and a 'Z' for Zero.
* Black Armor and Golden Armor have new portrait palettes inside the menu.
* MSU-1 should be compatible no matter the version. The coding area remains untouched in which the MSU-1 uses.
* X and Zero's upgrade data that gets saved has been moved entirely into a new location.
	* This is easier for modifying and technically allows up to four playable characters in total in a single game if modified properly.
* The Golden Armor can be obtained in two manners instead of just the one.
	* The first one is still as normal, get all upgrades, have full life. 
	* The second one just requires the user to 'collect' each chip enhancement. If that is done then you can also collect the Golden Armor. Each enhancement chip collected will appear in the menu and will have a golden color if it's currently the one being used.
* The (F)rog Armor has been updated greatly.
	* It can now function on land like a normal Ride Armor including walking, dashing, and proper jumping. 
	* It'll function like it normally does underwater with the added bonus of being able to walk instead of hop everywhere.
* The boulders in Tunnel Rhino's stage can be destroyed by a plethora of weapons now including:
	* Z-Saber (X or Zero)
	* Tornado Fang (T. Fang)
	* Spinning Blade (S. Blade)
	* Charged Triad Thunder (Triad T.)
* Tornado Fang's spread has been increased.
* The platform in Crush Crawfish's stage that gets blown up to find the (H)awk Armor chip can now be destroyed by Tornado Fang and the (F)rog Armor missiles. 
* The Gravity Well section in Volt Catfish's stage has been entirely replaced with a spiked wall jump area instead.
	* This allows for gathering the Armor upgrade a lot earlier instead of locking it off with an upgrade only mechanic.
* Zero has his own unique 'GET WEAPON' portrait. (Thanks to Metalwario64 for his gracious work!)
* X's 'GET WEAPON' screen is slightly updated.
	* He'll show his unused blue palette upon first loading but when the screen flashes it'll load his weapon palette.
* Bit and Byte now spawn 50/50 chance.
	* There's no specific designation of when they will now spawn.
	* If 7 bosses are destroyed and either Bit or Byte is destroyed then the survivor will have a 100% chance of spawning no matter what unless they've been fought once as well.
* Bit/Byte/Vile encounters have had their battle theme changed to Doppler's battle theme to note their alliance with him.
* Bit/Byte can be encountered on any stage including ones that have been beaten as long as Doppler's Lab hasn't been unconvered.

