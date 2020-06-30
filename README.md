This is a repository of LiveSplit auto splitters, developed by Nixill ([Twitch](https://twitch.nixill.net/) / [Twitter](https://twitter.nixill.net/)). I'm going to talk in first-person here.

# What's LiveSplit?
[LiveSplit](https://livesplit.org/) is a popular speedrun timer that can be used to time the individual parts of runs ("splits", as a noun) in addition to the run as a whole. A runner can mark a section as completed and start a new one ("split", as a verb) with a hotkey - [one of my friends](https://twitch.tv/WinnerBit/) even does it with foot pedals - without leaving the game they're playing as they run through it.

# What's an auto splitter?
An auto splitter is a script that can be activated for specific games to detect when splits should be split and automatically do so for the runner, who can then focus more on the game itself. As a casual runner myself, I know I certainly sometimes forget to split and then I just have to skip it and move on.

# How do I use these?
The best way to use these is to get them through LiveSplit itself. When editing your splits, there is a section between the splits themselves and the "Start timer at" / "Attempts" fields. If you've set your game properly, there are two possible scenarios:

1. The section will have some text (which changes for different auto splitters), and either an "Activate" button next to a greyed-out button, or "Deactivate" and "Settings" buttons.
2. The section will say "There is no Auto Splitter available for this game." and have two greyed-out buttons.

## Scenario 1
Just click "Activate" if you see that button. I also recommend checking the settings, and I always write up a help file in this repo to go with the splitter itself.

## Scenario 2
If it's a game I've made a splitter for, but it's not on LiveSplit itself yet (that does take a manual review by their devs), you'll have to follow these steps instead:

1. Download the `.asl` file for the game from this GitHub repo.
2. Edit your layout.
3. Click on the "+" button along the left-side bar.
4. Under "Control", click "Scriptable Auto Splitter".
5. Double-click the new entry in the layout.
6. For "Script path:", navigate to the newly downloaded file.
7. Make sure the settings are as you like them. If you need it, there's a help file right next to the splitter in the repo.

# Something's wrong!
If something's not working with one of these auto splitters, [raise an issue](https://github.com/ShadowFoxNixill/AutoSplitters/issues/)! I'll get to it when time permits.