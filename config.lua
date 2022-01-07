-- Copyright (C) 2021 KUMApt & Shadowskrt

Config = {}

Config.UseLanguage = "en"                                                           -- Select the language you want to use in the script (the translation is at the end of the file)
Config.UseSoundEffect = true                                                        -- Only use this if you use InteractSound

Config.Elevators = {
    -- The following tags are not required! You can add them if you want
    -- Group = "jobname" or "gangname" -> Only player with this job or gang can can go to the restricted floors
    -- Sound = "soundname" -> Use custom sound when player reaches the new floor | You can add your custom sound with .ogg extension in interactSound folder /client/html/sounds
    -- Simple example with restricted floors and custom sound
    ["restricted"] = {
        Group = {"police", "ambulance", "lostmc"},                                -- Leave blank if you don't want to use Player Job - You can add jobs or gangs groups
        Sound = "liftSoundBellRing",                                                -- Leave blank if you don't want to use Custom Sound
        Name = "With Sound & Last Floor Restricted",
        Floors = {
            [1] = {
                Label = "Roof",
                FloorDesc = "Description for roof",
                Restricted = true,
                Coords = vector3(-1072.41, -246.45, 54.01),
                ExitHeading = "297.06"
            },
            [2] = {
                Label = "Floor 2",
                FloorDesc = "Description for floor 2",
                Restricted = false,                                                  -- Only players with defined job (Job = "") can change to this floor
                Coords = vector3(-1075.73, -252.76, 44.02),
                ExitHeading = "28.74"
            },
            [3] = {
                Label = "Floor 1",
                FloorDesc = "Description for floor 1",
                Restricted = false,
                Coords = vector3(-1075.73, -252.76, 37.76),
                ExitHeading = "28.74"
            },
        }
    },
    -- Simple example without custom sound and without restricted floors
    ["noRestricted"] = {
        Name = "Without Sound & Restricted Floor",
        Floors = {
            [1] = {
                Label = "Floor 2",
                FloorDesc = "Description for floor 2",
                Coords = vector3(-1078.34, -254.08, 44.02),
                ExitHeading = "28.74"
            },
            [2] = {
                Label = "Floor 1",
                FloorDesc = "Description for floor 1",
                Coords = vector3(-1078.34, -254.08, 37.76),
                ExitHeading = "28.74"
            },
        }
    },
}

Config.Language = {
    ["en"] = {
        Call = "~g~E~w~ - Call Lift",
        Waiting = "Waiting for Lift...",
        Restricted = "Restricted floor!",
        CurrentFloor = "Current floor: "
    },
    ["pt"] = {
        Call = "~g~E~w~ - Chamar elevador",
        Waiting = "À espera do Elevador...",
        Restricted = "Piso restrito!",
        CurrentFloor = "Piso Atual: "
    }
}
