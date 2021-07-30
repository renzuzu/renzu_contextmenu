# renzu_contextmenu
FIVEM - CONTEXTMENU NUI. Targeting or Other Interaction Purpose

# SAMPLE USAGE SINGLE EXPORT

```
uidata = {
    ['Ask Question'] = {
        ['title'] = 'Ask',
        ['fa'] = '<i class="fad fa-question-square"></i>',
        ['type'] = 'export', -- event / export
        ['content'] = 'ask', -- important to rename this, this will be the id of submenu, this will be also the event if using event type, if using export using only as div id
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {}, arg_unpack = false, exports = (function() e = exports["cd_keymaster"]:StartKeyMaster() end)}, -- change only this 'exports["cd_keymaster"]:StartKeyMaster()' in able to execute exports.
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

# SAMPLE USAGE MULTI EXPORT

```
local multimenu = {}
firstmenu = {
    ['Ask Question'] = {
        ['title'] = 'Ask',
        ['fa'] = '<i class="fad fa-question-square"></i>',
        ['type'] = 'export', -- event / export
        ['content'] = 'ask', -- important to rename this, this will be the id of submenu, this will be also the event if using event type, if using export using only as div id
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {}, arg_unpack = false, exports = (function() e = exports["cd_keymaster"]:StartKeyMaster() end)}, -- change only this 'exports["cd_keymaster"]:StartKeyMaster()' in able to execute exports.
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
}
secondmenu = {
    ['Ask Question'] = {
        ['title'] = 'Ask',
        ['fa'] = '<i class="fad fa-question-square"></i>',
        ['type'] = 'export', -- event / export
        ['content'] = 'ask', -- important to rename this, this will be the id of submenu, this will be also the event if using event type, if using export using only as div id
        ['variables'] = {server = false, send_entity = true, onclickcloseui = true, custom_arg = {}, arg_unpack = false, exports = (function() e = exports["cd_keymaster"]:StartKeyMaster() end)}, -- change only this 'exports["cd_keymaster"]:StartKeyMaster()' in able to execute exports.
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
}
multimenu['FIRST MENU TITLE'] = firstmenu
multimenu['SECOND MENU TITLE'] = secondmenu
```
```
TriggerEvent('renzu_contextmenu:insertmulti',multimenu,"MENU TITLE","ENTITY",true)
```

# SHOW THE MENU
- the Data must be populated first using the exports sample above
- ```TriggerEvent('renzu_contextmenu:show') ```

# CLOSE MENU
```TriggerEvent('renzu_contextmenu:close')```
