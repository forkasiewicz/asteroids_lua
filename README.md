# Asteroids in LÖVE2D
### Description:
For this project I decided to try and recreate the classic Asteroids game from 1979 inside of the `LÖVE2D` engine. 

The game follows a simple mechanic, and is very similar to the original Asteroids game in many aspects, except for procedural asteroid generation, and in my opinion cooler looking particle effects.

The player controls a ship, and is given 3 lives at the start, there is no end goal besides seeing how long the player can withstand new asteroid waves while trying to gain the max amount of points. Points are awarded for destroying large, medium, and small asteroids, worth 20, 50, and 100 points respectively.

## Design Decisions:

### The reason behind choosing `LÖVE2D`:
The reason I decided to create a game is due to the fact that I had always been fascinated with projects that let me see the visual output of my work but what bugs me about web design is that it doesn't involve cool logic or maths.

I really wanted to choose a barebones game engine and decided to go with `LÖVE2D` because while researching this, I realised that my C skills aren't good enough and I heard a lot of good things about this game engine. I decided that remaking asteroids would be sufficiently complex while also being extremely fun, and enjoyable to write.

The game uses vector-based line rendering for all graphics, generated in its entirety through code. The entire vector library has been created by me.

### Challenges I've faced:
For me, the main challenge was figuring out a way to implement the vector rotation function. While in principle it's pretty simple compared to 3d rotation which is a lot more nuanced, it was my first time trying to implement such a function involving math beyond the standard four operations. I was ultimately able to do it with the help of this article on wikipedia:
https://en.wikipedia.org/wiki/Rotation_matrix#In_two_dimensions

I've also had great fun trying to figure out the conversion from degrees to radians to evenly disperse points around a circle to create asteroids.

I had trouble understanding when to convert between local and global coordinates when rotating or translating objects. The fix was to apply rotation in local space, then offset by the object’s world position.
## File structure:
### `vector.lua`:
Vectors are simple two element tables of numbers which you can perform operations on.

Vectors were used all throughout my project so the natural decision was to implement my own custom library for them. This library contains methods for vector manipulation (e.g. rotation, normalization, addition, subtraction, scale).
### `line.lua`:
Lines are two element tables of vectors. Lines have multiple methods, some of which are just vector methods applied to each vector of the line, but it also contains methods used for collision detection (line intersection), and an internal draw method for ease of use.
### `particle.lua`:
This is another library for creating particles, it takes the lines of an object, and creates new particle objects that draw each line segment with its own random rotation, and speed.
### `ship.lua`:
This file contains all of the code used to control the player's ship. 

It is able to thrust forward through a basic movement script which also has a drag function implemented to give the ship inertia dependent on the delta-time that `LÖVE2D` outputs by default.

### `asteroid.lua`:
This file handles logic related to the asteroids, such as:
- All of the logic for spawning asteroids outside of the screen, and setting their movement vector to a random location around the center of the screen at a random speed.
- Unlike the original game which uses predefined sprites, my remake uses procedural generation which works by creating points around a circle - each point placed at a random position away from the circle in a certain range.
- Upon colliding with the ship or the bullet, the asteroid will call the function to create two new asteroids, each half the size of their parent and each having their own movement vector with a randomized direction and speed dependent on the parent's movement vector.
### `bullet.lua`:
This file only contains the information needed to create, and update the bullet's position based on the ship's rotation at the time the bullet was shot. The logic for collision detection with the asteroids, and splitting them is defined within `main.lua`

### `main.lua`:
this file contains the 3 main `LÖVE2D` callback functions:

`love.load()` - which only calls `Reset()`

`love.update()` - is updated every frame, calls all of the local `update` methods of each script containing one, such as `ship.lua`, `asteroid.lua`, and `bullet.lua`. Besides that it handles:
- The wave logic: spawns two new asteroids every 10 seconds if the total amount of asteroids is below 11.
- Collision logic: loops through every asteroid to determine whether any of the bullets or the ship are colliding with it - in turn splitting the asteroid and depending on the object it will perform a set of instructions such as removing it from a global table or subtracting a life from the player, and resetting the ship.
- Invincibility: Upon respawning of the ship this script checks if there are any asteroids in a certain range around the center of the screen to determine whether to give the player temporary immunity to asteroids.

`love.draw()` - is updated every frame, calls all of the local `draw` methods of each script containing one, such as `ship.lua`, `asteroid.lua`, and `bullet.lua`. It also draws all of the UI such as the game over screen, the score, and player lives.

And my own functions:

`Reset()` - initializes the game, setting all of the necessary values, and creating objects such as the ship, and 4 asteroids at the start.

`fontSize()` - Because `LÖVE2D` doesn't allow changing the font size dynamically, this function will create a new font of the size of the input number and cache it, effectively avoiding unnecessarily allocating more memory by reusing cached fonts when the same size is requested again.

`centerText()` - Takes the width and height of the font, dividing it by two and subtracting that from the height and width of the inputted 2d vector position, resulting in text centered at the chosen point.

### `conf.lua`:

By design `LÖVE2D` contains a `conf.lua` file which specifies which modules the game should use such as `joystick` or `physics`, but it is also used to configure the default window title, and size of the game.

## How to run:
### On MacOS:

1. download and run the installer: https://github.com/love2d/love/releases/download/11.5/love-11.5-macos.zip
2. `cd` into the project directory and run:
```sh
open -n -a love "./"
```
### On windows:

1. download and run the installer: https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.exe
2. `cd` into the project folder and run:
```sh
& "C:\Program Files\LOVE\love.exe"
```
