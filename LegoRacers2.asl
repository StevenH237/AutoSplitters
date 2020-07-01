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
    settings.Add("autostart", false, "Start the timer whenever the Sandy Bay overworld loads. (Beware of false positives!)");
    settings.Add("autostartanywhere", false, "Also allow any foyer to start the timer. Useful for NG+.", "autostart");
    settings.Add("race", true, "Split the timer whenever the player wins a race.");
    settings.Add("minigame", true, "Split the timer whenever a minigame finishes.");
    settings.Add("parttime", false, "In-game timers: Use race and minigame timers instead of all global timers.");
    settings.Add("racetime", true, "Use race times as part of in-game times.", "parttime");
    settings.Add("minigametime", true, "Use minigame times as part of in-game times.", "parttime");
    settings.Add("deadattempt", true, "Include dead attempts (restarted or quit) as part of in-game times.", "parttime");

    vars.startTime = null;
    vars.gameTime = 0;
}

start {
    if (!settings["autostart"]) return false;
    if (current.isMapLoaded == 1 && old.isMapLoaded != 1 && (
        // Check if we're loading the right map
        // Should drastically reduce false positives
        (current.whichMapLoaded >= 1472 && // Sandy Bay overworlds
        current.whichMapLoaded <= 1476) ||
        // Don't ask me what causes the range of valid IDs 
        (settings["autostartanywhere"] && (
            current.whichMapLoaded == 290 || // Dino Island foyer
            current.whichMapLoaded == 277 || // Mars foyer
            current.whichMapLoaded == 263 || // Arctic foyer
            current.whichMapLoaded == 267 // Xalax foyer
        ))
    )) return true;
    return false;
}

split {
    // At the end of the race:
    if (current.currentLap == old.currentLap + 1 && current.currentLap == current.numberOfLaps + 1) {
        if (current.currentPosition == 1) return settings["race"];
    }

    // At the end of the minigame:
    if (current.thingsCollected == old.thingsCollected + 1 && current.thingsCollected == current.thingsToCollect) {
        return settings["minigame"];
    }

    // Both failed
    return false;
}

isLoading {
    return true;
}

gameTime {
    if (settings["parttime"]) {
        if (settings["deadattempt"]) {
            if (settings["racetime"]) {
                // Restarted a race:
                if (current.currentLap == 0 && old.currentLap != null && old.currentLap > 0)
                    vars.gameTime += old.globalTimer;

                // Quit a race:
                if (current.currentLap == null && old.currentLap != null && old.currentLap <= old.numberOfLaps)
                    vars.gameTime += old.globalTimer;
            }

            if (settings["minigametime"]) {
                // Restarted a minigame:
                if (current.thingsToCollect <= 10 && current.thingsToCollect >= 1 && current.thingsCollected == 0 && current.minigameTimer > old.minigameTimer)
                    vars.gameTime += old.minigameTimeLimit - old.minigameTimer;

                // Quit a minigame:
                if ((current.thingsToCollect > 10 || current.thingsToCollect < 1) && (old.thingsToCollect <= 10 && old.thingsToCollect >= 1 && old.thingsCollected < old.thingsToCollect))
                    vars.gameTime += old.minigameTimeLimit - old.minigameTimer;
            }
        }

        // Finished a race
        if (settings["racetime"] && current.currentLap == old.currentLap + 1 && current.currentLap == current.numberOfLaps + 1 && (current.currentPosition == 1 || settings["deadattempt"]))
            vars.gameTime += old.globalTimer;

        // Finished a minigame
        if (settings["minigametime"] && current.thingsCollected == old.thingsCollected + 1 && current.thingsCollected == current.thingsToCollect)
            vars.gameTime += current.minigameTimeLimit - current.minigameTimer;

        float gTime = vars.gameTime;

        // In a race:
        if (settings["racetime"] && current.currentLap != null && current.currentLap <= current.numberOfLaps && current.currentLap > 0)
            gTime += current.globalTimer;

        // In a minigame:
        if (settings["minigametime"] && current.thingsToCollect <= 10 && current.thingsToCollect >= 1 && current.thingsCollected < current.thingsToCollect)
            gTime += current.minigameTimeLimit - current.minigameTimer;

        return TimeSpan.FromSeconds(gTime);
    } else {
        // If the timer got reset or went away:
        if ((current.globalTimer == null && old.globalTimer != null) || (current.globalTimer < old.globalTimer))
            vars.gameTime += old.globalTimer;

        return TimeSpan.FromSeconds(vars.gameTime + current.globalTimer);
    }
}

update {
    if (timer.AttemptStarted.Time != null && (vars.startTime == null || vars.startTime < timer.AttemptStarted.Time)) {
        vars.startTime = timer.AttemptStarted.Time;
        vars.gameTime = 0;
    }
}
