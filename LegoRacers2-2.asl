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

