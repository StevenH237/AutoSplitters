Contents:

* [Features](#features)
* [Settings](#settings)
* [Compatibility](#compatibility)

# Features
This auto splitter offers:

* Automatic start
* Automatic split
* Real time minus loads
* In-game time

## Automatic start
*Automatic start is disabled by default due to a high potential for false starts.*

When enabled, the auto splitter can automatically start the run at the *conclusion* of the loading screen into Sandy Bay's overworld.

An extra setting also allows the run to start with any foyer (because I want to see NG+ runs be a thing).

## Automatic split
By default, the timer will split upon crossing the finish line of a race in 1st place, or returning the last object of a bonus game and thus completing it.

An extra setting also allows any race completion to cause a split.

## Real time minus loads / In-game time
*Lego Racers 2 is currently timed RTA, including loads. Non-RTA timing is included for informational purposes only.*

By default, the Game Timer will count up in all places except for:

* On a loading screen
* In a car-building menu
* When paused
* After five seconds pass beyond winning a race

A setting allows the Game Timer's method to be switched to count race and minigame timers only.

# Settings

## Start the timer whenever the Sandy Bay overworld loads. (Beware of false positives!)
This section is pretty much as described on the tin. It's disabled by default due to the potential for false positives.

Specifically, it'll send a Start signal whenever the load screen for the Sandy Bay hubworld (not any of its races or bonus games) finishes loading.

The magic number used to detect this doesn't like to stay stable, and it's possible this event won't trigger. If this happens, you'll have to restart your whole game to make it auto-start, but also [please let me know](https://github.com/ShadowFoxNixill/AutoSplitters/issues/).

### Also allow any foyer to start the timer. Useful for NG+.
If this is checked, then the script will Start the timer whenever Sandy Bay's overworld, or the foyer hubs of Dino Island, Mars, the Arctic, or Xalax, finish loading.

## Split the timer whenever the player wins a race.
Self-explanatory. Available as an option in case your timer doesn't have splits for individual races.

## Split the timer whenever a minigame finishes.
Also self-explanatory, and available as an option for the same reason.

## In-game timers: Use race and minigame timers instead of all global timers.
*Lego Racers 2 is currently timed RTA, including loads. Non-RTA timing is included for informational purposes only.*

This switches between the two methods mentioned in the [RTA minus loads / IGT](#real-time-minus-loads--in-game-time) section.

### Use race times as part of in-game times.
When using just races and minigames as the in-game time, unchecking this box makes it only minigames.

### Use minigame times as part of in-game times.
When using just races and minigames as the in-game time, unchecking this box makes it only races.

### Include dead attempts (restarted or quit) as part of in-game times.
When using just races and minigames as the in-game time, unchecking this box removes times from unsuccessful attempts at races / minigames.

# Compatibility
Lego Racers 2 is a 2001 CD-ROM game that is not receiving updates. This auto splitter was designed and tested based on the US version, but may still work with the EU version.

# Known bugs
When using just races and minigames as the in-game time, a race doesn't count until the player crosses the starting line. However, the time it took to cross the finish line is still counted.