# Work Log

## ARSLAN AYUSHIN

### 5/22/23

- Added Character class with position and velocity
- Added child of Character class Reimu and made Character abstract
- Movement with arrow keys, set velocity based on which keys are down
- display() character

### 5/23/23

- added bullet and enemy class (forgot to add this file to commit in class)
- added variables to track the time spawned
- Mob/moveable class which is parent of both character and enemy (revision to prototype)

### 5/24/23

- added bullet display()
- added a bulletList to move all bullets every frame
- character spawns moving bullets every 100 ms timer
- merged wip branch to main
- added a list of all mobs and all bullets but theres an error

### 5/25/23

 - fixed mobList by initializing it
 - copy of mobList for changes to fix error when changing while looping through a list
 - spawn a default enemy at start of game
 - bullets check distance and register hit on enemy
 - bullets do damage and kill enemy
 - fixed getPos() to return copy of pvector
 - merged wip branch to main

 ### 5/26/23

 - velocity is multiplied by the change in time
 - spawnEnemies() method that adds enemies based on game time
 - enemy is abstract class

 ### 5/30/23
 
 - bullets owned by enemies kill player
 - first enemy attack pattern
 - nerd enemy attacks every 2 seconds
 - enemey moves off screen and despawns after a few seconds

 ### 5/31/23

 - fixed stayOnScreen()
 - made game area smaller and in the middle of the processing window

 ### 6/1/23

 - drawBorder() draws the background, score, lives, kills outside of the game window
 - added character sprite animations with PImage
    - flipImage() based on which arrow key left/right was held last
    - moving animation
    - death animation
 - character shoots bullets in a cone (different angles)
 - imported sound library for death sound
 - draw() is different based on game state
    - gameOver state with game over screen and play again button
    - start state with play button
 - moved code from setup to newGame()
 - new enemy Book
 - new BossEnemy Teacher with 2 phases
    - one attack pattern per phase

### 6/5/23

 - boss changes phase after 30 second timeout if not killed
 - draw time left before time out
 - give points for
    - killing boss phase before timeout
    - dealing damage to enemies

### 6/6/23

 - character plays reversed moving animation after letting go of left/right
 - added new homing bullets
    - reimu character shoots homing bullets
    - homing bullets find and move towards nearest enemy

### 6/7/23

 - changed the bullet color and size for reimu's homing bullets

### 6/8/23

 - updated character moving animation
 - moved the moving anim code from drawChar() to drawMoving()
 - moving animation loops after the first part finishes in animTime

 ### 6/9/23

 - added Animation class that stores times and keyframes to maybe help with attack patterns
 - idle animation flips in the direction last moved (left/right)
 - character display() draws orbs that float near player
    - homing bullets spawn at orbs
    - orbs come closer together when focusing
 - rewrote button clicking using mousePressed instead of mousePressed() to fix buttons clicking themselves
 - grazing bullets (being near them) gives score
 - save and load high score to a txt file, highScore.txt is added to gitignore file
 - game over screen shows how much score is from time bonus, spellcard (kill boss before timeout) bonus, damage bonus, graze bonus, kill bonus, stage clear bonus
 - added music that plays in the menu and in the game
 - boss deletes old bullets when switching phase

 ### 6/11/23 (Weekend)

 - new enemy Zygarde
 - background color changes based on boss's current phase
 - fixed bug with not using the static version of PVector.add (for targetPos)
 - changed boss second phase
    - first bullet in a line stores character position so all the bullets in the line go to the same target position
 - added third boss phase
    - boss slides across screen and back
    - shoots gravity bullets, special type of bullet that accelerates downward
    - attack pattern gets faster when boss hp drops to 2/3, 1/2, etc.
 - added goTo() to calculate the velocity to reach x position in y milliseconds
 - menu play button leads to character select screen
 - menu cheat buttons change cheat mode instead of putting you straight into the game
 - new character Marisa
    - marisa shoots laser bullets, special bullet that is stationary and rectangular like a laser beam and calculates hits differently
 - sounds for laser hit and time running out
 - names of background music and current boss phase show up and fade out
 - dialogue before and after fighting boss
    - dialogue game state stops game time from being counted and character from being updated
    - methods for getting next dialogue line and drawing dialogue box
    - clicking progresses to the next line/message
    - profile image reactions from the player and the boss in each line of dialogue
 - deleted Animation class because it was unused

### Working Features

 - Menu screen where you can change character (Reimu or Marisa)
 - Character sprite animations: a looping idle animation and moving animation and a short transition to moving animation (I did not draw the sprite sheets)
   - Sprites flip to the direction (left/right) arrow key pressed last
   - Orbs around the character spin and move closer if the player is focused (shift key)
 - Characters/enemies shoot bullets that do damage to enemies/take away lives from the player
 - Bullets are removed if they hit or go off screen
 - Special bullets
   - Homing bullets shot by Reimu's orbs always move toward the nearest enemy
   - Lasers shot by Marisa's orbs are rectangular and stationary but fade away after a few seconds (can only hit one target) and have different hit detection
   - Gravity bullets shot by the boss accelerate downward
 - Enemies spawn and move into the screen in a fixed pattern based on the game time, and they run off screen if they aren't killed in time
 - Game over screen after killing the boss (winning) or dying (losing)
   - Score is earned from: time survived, killing a boss phase before it times out, damage, grazes (how many bullets went near you), kills
   - save and load high score with file highScore.txt
   - Button that leads back to menu
 - Boss enemy spawns with four phases (shown by how many hearts it has) and a health bar at the top of the screen
   - Boss moves to the next phase when their health bar or the timer at the top right goes to 0
   - In the transition between phases, the boss moves to the center and deletes the bullets from the previous phase
   - Different attack pattern for each phase and changes background color
   - For the third phase, the boss speeds up its attack as its health gets lower
 - Dialogue that pauses the game until it is finished
   - After a delay click anywhere to move to the next line
   - Both dialogues are between the chosen character and the boss
   - Each line of dialogue shows the sprite and name of the speaker and previous speaker
   - The dialogue also changes the sprites to different emotions like Angry or Serious
 - Background music that loops in the game
   - Menu screen theme, stage theme, boss theme, ending theme
   - Sounds play when: player dying, grazing, enemies shooting, boss dying, running out of time, Marisa's laser hitting
 - Name of current music or current boss phase shows at the bottom of the screen and fades out

 ### Broken Features / Bugs

 - Audio sometimes breaks and suddenly becomes irreversibly lower quality and stalls
   - I have encountered this when standing near an enemy, at the start of the game, game over screen, and maybe when shooting Marisa's lasers
   - Probably because there are too many loud sounds playing at the same time
 - Reimu's homing bullets can infinitely orbit around an enemy in a perfect circle and build up
   - Can be encountered by just moving to the top left or top right of an enemy
   - Not much of a problem because player bullets are transparent, and they usually don't build up that much
   - Could be fixed by changing how homing works and deleting bullets that are too old
 - Boss third phase where the boss rapidly moves across the screen shooting gravity bullets
   - When the attack speed increases as the boss loses health, the boss teleports and skips forward or backward and skips part of the attack
   - Should just finish the current movement and increase the velocity instead of teleporting

### Useful Resources

 - The gameplay and some attacks are inspired by Touhou Project games
 - Shoutout to this equation from Wikipedia (used for Marisa's lasers)
https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line#Line_defined_by_two_points
