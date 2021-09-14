config = {}
config.UsingRayzoneTarget = true --set to false if you are not using Renzu RayZone
config.WhitelistEvents = false -- enable/disable whitelist of events
config.MenuSounds = true -- enable / disable menu GUI Sound
config.MenuVolume = 0.1
config.Events = { -- list of events to whitelist, any events not listed here will be block using the Event trigger function
    [1] = 'myevent', -- event sample
    [2] = 'exports["cd_keymaster"]:StartKeyMaster', -- export sample, without ()
}
config.disablemouse = false -- enable / disable mousemove while menu is open (disable if your other resource already do this eg. target script)
config.keepinput = true -- if true you can walk while menu is open
config.defaultFA = '<i class="fad fa-tasks-alt"></i>'