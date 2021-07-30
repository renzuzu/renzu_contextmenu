# renzu_contextmenu
FIVEM - CONTEXTMENU NUI. Targeting or Other Interaction Purpose
# FEATURE
- Multiple Submenu
- Easy Implementation
- Clean UI
- GUI Sounds (optional)
- Whitelisted Events (optional)
- Easy to integrated to Any Target Script
- Trigger Export
- Trigger Client or Server
- Pass Any Arguments as optional to the receiver
# SAMPLE USAGE SINGLE EXPORT

```
uidata = {
    ['Ask Question'] = {
        ['title'] = 'EXPORT SAMPLE',
        ['fa'] = '<i class="fad fa-question-square"></i>',
        ['type'] = 'export', -- event / export
        ['content'] = 'ask', -- EVENT
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {}, arg_unpack = false, exports = 'exports["cd_keymaster"]:StartKeyMaster'}, -- WITHOUT ()
    },
    ['Steal'] = {
        ['title'] = 'Steal',
        ['fa'] = '<i class="fad fa-hood-cloak"></i>',
        ['type'] = 'event', -- event / export
        ['content'] = 'holdup',
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {}, arg_unpack = false},
    },
    ['SellDrag'] = {
        ['title'] = 'Sell Meth',
        ['fa'] = '<i class="fad fa-hand-holding-magic"></i>',
        ['type'] = 'event', -- event / export
        ['content'] = 'kill',
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {}, arg_unpack = false},
    },
},
 ```
 ```
 TriggerEvent('renzu_contextmenu:insert',uidata,"MENU TITLE","ENTITY",true)
 ```
- RESULT
- ![ezgif-7-8fbc6c927f43](https://user-images.githubusercontent.com/82306584/127671328-68c72bb7-719f-4aab-a907-bca1ddb917dc.gif)


# SAMPLE USAGE MULTI EXPORT

```
local multimenu = {}
firstmenu = {
    ['Ask Question'] = {
        ['title'] = 'EXPORT SAMPLE',
        ['fa'] = '<i class="fad fa-question-square"></i>',
        ['type'] = 'export', -- event / export
        ['content'] = 'ask', -- EVENT
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {}, arg_unpack = false, exports = 'exports["cd_keymaster"]:StartKeyMaster'},
    },
    ['Steal'] = {
        ['title'] = 'Steal',
        ['fa'] = '<i class="fad fa-hood-cloak"></i>',
        ['type'] = 'event', -- event / export
        ['content'] = 'holdup',
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {1,2,true,"STRING"}, arg_unpack = false},
    },
    ['SellDrag'] = {
        ['title'] = 'Sell Meth',
        ['fa'] = '<i class="fad fa-hand-holding-magic"></i>',
        ['type'] = 'event', -- event / export
        ['content'] = 'kill',
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {false,2,3,4}, arg_unpack = false},
    },
}
secondmenu = {
    ['Ask Question'] = {
        ['title'] = 'EXPORT SAMPLE',
        ['fa'] = '<i class="fad fa-question-square"></i>',
        ['type'] = 'export', -- event / export
        ['content'] = 'ask', -- EVENT
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {}, arg_unpack = false, exports = 'exports["cd_keymaster"]:StartKeyMaster'},
    },
    ['Steal'] = {
        ['title'] = 'Steal',
        ['fa'] = '<i class="fad fa-hood-cloak"></i>',
        ['type'] = 'event', -- event / export
        ['content'] = 'holdup',
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {1,true,3,4}, arg_unpack = false},
    },
    ['SellDrag'] = {
        ['title'] = 'Sell Meth',
        ['fa'] = '<i class="fad fa-hand-holding-magic"></i>',
        ['type'] = 'event', -- event / export
        ['content'] = 'kill',
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {1,2,3,4}, arg_unpack = false},
    },
}
multimenu['FIRST MENU TITLE'] = firstmenu
multimenu['SECOND MENU TITLE'] = secondmenu
```
```
TriggerEvent('renzu_contextmenu:insertmulti',multimenu,"ENTITY",true)
```
# Result 
- ![ezgif-7-bf45a61bf40c](https://user-images.githubusercontent.com/82306584/127672457-6fbbab27-9538-41b0-8afd-2f1ab2eb3e08.gif)


# SHOW THE MENU
- the Data must be populated first using the exports sample above
- ```TriggerEvent('renzu_contextmenu:show') ```

# CLOSE MENU
```TriggerEvent('renzu_contextmenu:close')```

# Video Short Demo
https://streamable.com/6k8oji
