# APCS Final Project
## Group Info
Group members: Arslan Ayushin
## Overview
This is a bullet hell game in Processing inspired by Touhou. The player moves around shooting enemies while dodging enemies' bullets. Each enemy has its own attack pattern. The player wins after killing the boss and loses if they get hit too many times.
## Instructions
 - Make sure you have the Processing sound library (if not, download it)
 - Open the project in Processing and run it
 - Click Inf lives (gives 99 lives) or Skip + Inf lives (skips straight to boss + 99 lives) if you want that cheat to be on
 - Click the Play button
 - Click Reimu or Marisa on the character select screen
 - Move with arrow keys
 - Hold shift to focus
    - Makes you move slower
    - Makes your bullets shoot narrower
    - Makes hitbox visible in red
 - The character shoots upwards automatically while in the game
 - During dialogue, click anywhere to go to the next line
 - In the game over screen, click Play Again? to return to the menu
## Characters
1. Reimu
 - Shoots 3 normal bullets in a cone and 2 homing bullets (x0.5 damage) every 100 ms
    - Speed = 8
    - Focus Speed = 5
    - Size = 7
    - Damage = 1
 - Good character for crowd control and easy to dodge enemy attacks but low damage output

2. Marisa
 - Shoots 3 normal bullets every 100 ms and 2 lasers (x10 damage) every 2000 ms
    - Speed = 9
    - Focus Speed = 6
    - Size = 7.5
    - Damage = 1.2
 - Good character for single target damage but hard to dodge enemy attacks because of high speed and size
## Enemies
1. Nerd
 - Shoots a line and then a circle of bullets at you every 2 seconds
2. Book
 - Shoots two circles of bullets every 1 second
3. Zygarde
 - Shoots an accelerating line and then a small arc of bullets at you every 2 seconds
4. Teacher (BOSS)
 - Phase 1 and 4: Shoots four arcs with bullets removed with different velocities and then one circle with bullets removed every 2 seconds. Moves every 1.2 seconds.
 - Phase 2: Shoots lines of bullets at you and arcs of bullets to the side at the same time. Moves every 1.2 seconds.
 - Phase 3: Moves across the screen spawning bullets accelerating downward every 2 seconds. Attack speeds up as boss health gets lower.