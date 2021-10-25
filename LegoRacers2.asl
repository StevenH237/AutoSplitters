/* This auto splitter was made by Nixill.
 *   https://twitter.nixill.net/
 *
 * The github repository this splitter is in is:
 *   https://github.nixill.net/AutoSplitters/
 *
 * Please see the readme file for more detailed explanations of the options:
 *   https://github.nixill.net/AutoSplitters/blob/master/LegoRacers2.md
 *
 * The "isMapLoaded" variable was found by Torak.
 */
 
state("LEGO Racers 2") {
    // Load screens are used for the auto-starter, which is disabled by default.
    // Torak actually found this one! That's about all the work that was already done for me tho.
    int isMapLoaded: 0x1544B4, 0x44, 0x9F4;

    // This is almost a "map ID" value; the only thing that stops it being such is that there are a couple overlaps.
    // It works well enough for my intended use of it, though.
    int whichMapLoaded: 0x1544B4, 0x44, 0x9E0;

    // These statistics are used to split at the end of a race.
    int currentLap: 0x154474, 0xF0, 0x58, 0x54, 0x5C, 0x74, 0x40, 0x16C;
    int numberOfLaps: 0x154474, 0xF0, 0x58, 0x54, 0x5C, 0x74, 0x40, 0x170;
    int currentPosition: 0x154474, 0xF0, 0x58, 0x54, 0x5C, 0x74, 0x40, 0x17C;

    // These statistics are used to split at the end of a minigame.
    int thingsCollected: 0x1544B4, 0x74;
    int thingsToCollect: 0x1544B4, 0x58;

    // These statistics are used for keeping track of in-game time (counting races and minigames only)
    float globalTimer: 0x154480, 0x46C;
    float minigameTimer: 0x1544B4, 0x64;
    float minigameTimeLimit: 0x1544B4, 0x68;
}

startup {
    settings.Add("readme", false, "Check out the readme for more information about this auto splitter:");
    settings.Add("readmelink", false, "https://github.nixill.net/AutoSplitters/blob/master/LegoRacers2.md", "readme");
    settings.Add("readmedisclaimer", false, "(The above checkboxes don't do anything. You don't have to click them to run the splitter.)", "readme");
    settings.Add("autostart", false, "Start the timer whenever the Sandy Bay overworld loads.");
    settings.Add("autostartanywhere", false, "Allow any map at all to start the timer. Useful for NG+ or meme runs, but causes drastic false positives.", "autostart");
    settings.Add("race", true, "Split the timer whenever the player wins a race.");
    settings.Add("raceany", false, "Allow any finish to cause a split.", "race");
    settings.Add("racelap", false, "Split the timer every lap.", "race");
    settings.Add("minigame", true, "Split the timer whenever a minigame finishes.");
    // settings.Add("parttime", false, "In-game timers: Use race and minigame timers (all displayed timers) instead of all global timers.");

    vars.startTime = null;
    vars.gameTime = 0;
}

start {
    if (!settings["autostart"]) return false;
    if (current.isMapLoaded == 1 && old.isMapLoaded != 1 && (
        settings["autostartanywhere"] || (
            // Check if we're loading the right map
            // Should drastically reduce false positives
            (current.whichMapLoaded >= 1472 && // Sandy Bay overworlds
            current.whichMapLoaded <= 1476)))
    ) {
        current.gtBuffer = 0;
        return true;
    }
    return false;
}

split {
    // At the end of the race:
    if (current.racingState == 4) return settings["race"];

    // At the end of the race, if not first:
    if (current.racingState == 3) return settings["raceany"];

    // When a lap is completed:
    if (current.racingState == 5) return settings["racelap"];

    // At the end of the minigame:
    if (current.minigameState == 4) return settings["minigame"];

    // Both failed
    return false;
}

isLoading {
    return current.isMapLoaded != 1;
}

// gameTime {
//     if (settings["parttime"]) {
//         if (current.racingState == 1) {
//             // On starting a race, reset "currTimer".
//             current.currTimer = current.globalTimer;
//         } else if (current.racingState == 2 || current.racingState == 5 || current.racingState == 6) {
//             // During a race, make sure global timer never resets.
//             // If it does, ignore it and use last known time.
//             if (current.globalTimer < old.currTimer) current.currTimer = old.currTimer;
//             else current.currTimer = current.globalTimer;
//         } else if (current.racingState == 3 || current.racingState == 4) {
//             // On ending a race, add current time to cumulative time.
//             // If the global timer has already reset, use last known time.
//             // But if it hasn't, then it should be used instead.
//             if (current.globalTimer < old.currTimer) vars.gameTime += old.currTimer;
//             else vars.gameTime += current.globalTimer;
//             current.currTimer = 0;
//         } else if (current.minigameState == 1 || current.minigameState == 2 || current.minigameState == 5) {
//             // If we're not racing, we might be playing a minigame.
//             // On starting, in the middle of, or on restarting, a minigame:
//             // the current time is however much time we've taken out of the time limit.
//             current.currTimer = current.minigameTimeLimit - current.minigameTimer;
//         } else if (current.minigameState == 3 || current.minigameState == 4) {
//             // Otherwise, we should add the time taken out of the limit to the cumulative time.
//             vars.gameTime += current.minigameTimeLimit - current.minigameTimer;
//             current.currTimer = 0;
//         } else {
//             // If we're not racing or in a minigame, the current time is 0.
//             current.currTimer = 0;
//         }

//         // The time to display is both the current timer and cumulative time, combined.
//         return TimeSpan.FromSeconds(vars.gameTime + current.currTimer);
//     } else {
//         // If the timer got reset or went away:
//         if ((current.globalTimer == null && old.globalTimer != null) || (current.globalTimer < old.globalTimer))
//             vars.gameTime += old.globalTimer;

//         return TimeSpan.FromSeconds(vars.gameTime + current.globalTimer);
//     }
// }

update {
    // Watch for a run restart, cause we need to clear game time vars
    if (timer.AttemptStarted.Time != null && (vars.startTime == null || vars.startTime < timer.AttemptStarted.Time)) {
        vars.startTime = timer.AttemptStarted.Time;
        vars.gameTime = 0;
    }

    // Get the current racing state
    // 0 = not racing
    // 1 = race started (one frame pulse)
    // 2 = race in progress
    // 3 = race ended (one frame pulse)
    // 4 = race won (one frame pulse)
    // 5 = lap incremented (one frame pulse)
    // 6 = checkpoint incremented (one frame pulse)
    // we can use the "racing" var from last frame as a shortcut
    if (current.currentLap >= 1 && current.currentLap <= current.numberOfLaps && current.currentLap <= 5) {
        current.racing = 1;
        if (old.racing == 1) {
            if (current.currentLap == old.currentLap + 1 && current.currentLap > 1) {
                current.racingState = 5;
            } else {
                current.racingState = 2;
            }
        } else {
            current.racingState = 1;
        }
    } else {
        current.racing = 0;
        if (old.racing == 1) {
            if (current.currentLap == current.numberOfLaps + 1 && current.currentPosition == 1) {
                current.racingState = 4;
            } else {
                current.racingState = 3;
            }
        } else {
            current.racingState = 0;
        } 
    }

    // Get the current minigame state
    // 0 = no minigame
    // 1 = minigame started (one frame pulse)
    // 2 = minigame in progress
    // 3 = minigame ended (one frame pulse)
    // 4 = minigame won (one frame pulse)
    // 5 = minigame restarted (one frame pulse)
    if (current.thingsToCollect <= 10 && current.thingsToCollect >= 1 && current.thingsCollected < current.thingsToCollect) {
        current.minigaming = 1;
        if (old.minigaming == 1) {
            if (current.minigameTimer > old.minigameTimer) {
                current.minigameState = 5;
            } else {
                current.minigameState = 2;
            }
        } else {
            current.minigameState = 1;
        }
    } else {
        current.minigaming = 0;
        if (old.minigaming == 1) {
            if (current.thingsCollected == current.thingsToCollect) {
                current.minigameState = 4;
            } else {
                current.minigameState = 3;
            }
        } else {
            current.minigameState = 0;
        }
    }
}
