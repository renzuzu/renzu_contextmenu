config = {}
config.UsingRayzoneTarget = true --set to false if you are not using Renzu RayZone
config.WhitelistEvents = false -- enable/disable whitelist of events
config.MenuSounds = true -- enable / disable menu GUI Sound
config.Events = { -- list of events to whitelist, any events not listed here will be block using the Event trigger function
    [1] = 'myevent',
}