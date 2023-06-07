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