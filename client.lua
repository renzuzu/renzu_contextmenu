local open = false

function Insert(table,title,entity,clear,header)
    local table = {
        header = header or '<i class="fas fa-eye"></i> INTERACTION',
        content = table,
        k = title or "TITLE MISSING",
        entity = entity or -1,
        clear = clear or false,
        main_fa = v.main_fa or false,
        input = v.input or false
    }
    SendNUIMessage({type = "insert", content = table})
    MenuShow()
end
exports('Insert', Insert)

function MultiInsert(table,entity,clear,header)
    for k,v in pairs(table) do
        if v.fa == nil then
            v.fa = config.defaultFA
        end
        local t = {
            header = header or '<i class="fas fa-eye"></i> INTERACTION',
            content = v,
            k = k or "TITLE MISSING",
            entity = entity or -1,
            clear = clear or false,
            main_fa = v.main_fa or false,
            input = v.input or false
        }
        v.main_fa = nil
        SendNUIMessage({type = "insert", content = t})
    end
    MenuShow()
end
exports('MultiInsert', MultiInsert)

function MenuShow()
    Wait(100)
    --while IsNuiFocused() do Wait(100) end
    SetNuiFocus(false,false)
    Wait(0)
    SendNUIMessage({type = "show", content = true})
    SetNuiFocus(true,true)
    while open do Wait(500) open = false end
    open = true
    CreateThread(function()
        while open and config.disablemouse do
            DisableControlAction(1, 1, true)
            DisableControlAction(1, 2, true)
            Wait(5)
        end
        while open and config.keepinput do
            DisablePlayerFiring(PlayerId(),true)
            Wait(0)
        end
        return
    end)
    CreateThread(function()
        while open do -- prevent overlapping nui focus to other resources
            if not IsNuiFocused() then
                SetNuiFocus(true,true)
                SetNuiFocusKeepInput(config.keepinput)
            end
            Wait(100)
        end
        SetNuiFocus(false,false)
        SetNuiFocusKeepInput(false)
        return
    end)
end

RegisterNetEvent('renzu_contextmenu:clear', function()
    while open do Wait(1) end
    if not open then
        SendNUIMessage({type = "reset", content = true})
        SetNuiFocus(false,false)
        SetNuiFocusKeepInput(false)
    end
end)

RegisterNUICallback('receivedata', function(data, cb)
    ReceiveData(data)
end)

function ReceiveData(data)
    local foundevent = false-- security pass the events if its registered only at config!
    local data = data.table
    for k,v in pairs(config.Events) do
        if v == data.content then
            foundevent = true
        end
        if data.variables ~= nil and data.variables.exports ~= nil and v == data.variables.exports then
            foundevent = true
        end
    end
    if not foundevent and config.WhitelistEvents then return end
    if data.variables ~= nil and data.variables.onclickcloseui then -- close the ui before any trigger event, prevent UI bug from other NUI focus.
        SendNUIMessage({type = "reset", content = true})
        SetNuiFocus(false,false)
        SetNuiFocusKeepInput(false)
        if config.UsingRayzoneTarget then
            TriggerEvent('renzu_rayzone:close')
        end
        open = false
    end
    if data.type == 'event' and data.variables ~= nil and data.variables.server and data.variables.server ~= 0 then -- is this a server event?
        if data.variables.send_entity then -- pass the entity only ?
            TriggerServerEvent(data.content,data.variables.entity)
        else -- else pass the whole variables for custom table etc..
            if data.variables.arg_unpack then
                table.insert(data.variables.custom_arg,data.inputval)
                TriggerServerEvent(data.content,unfuck(table.unpack(data.variables.custom_arg)))
            else
                TriggerServerEvent(data.content,data.variables.custom_arg,data.inputval)
            end
        end
    elseif data.type == 'event' and data.variables ~= nil and data.variables.server ~= true then -- else client event only
        if data.variables.send_entity then -- pass the entity only ?
            TriggerEvent(data.content,data.variables.entity)
        else -- else pass the whole variables for custom table etc..
            if data.variables.arg_unpack then
                table.insert(data.variables.custom_arg,data.inputval or false)
                TriggerEvent(data.content,unfuck(table.unpack(data.variables.custom_arg)))
            else
                TriggerEvent(data.content,data.variables.custom_arg,data.inputval)
            end
        end
    elseif data.type == 'export' and data.variables ~= nil and data.variables.exports ~= nil then
        TriggerExport(data.variables.exports,data.variables.custom_arg,data.inputval)
    elseif data.type == 'shop' then
        TriggerServerEvent("renzu_rayzone:shop",data,data.inputval)
        SendNUIMessage({type = "reset", content = true})
        SetNuiFocus(false,false)
        SetNuiFocusKeepInput(false)
        if config.UsingRayzoneTarget then
            TriggerEvent('renzu_rayzone:close')
        end
        open = false
    end
    if data.variables ~= nil and data.variables.onclickcloseui then
        closeMenu()
    end
end

RegisterNUICallback('close', function(data)
    closeMenu()
end)

function closeMenu()
    open = false
    SendNUIMessage({type = "reset", content = true})
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)
    if config.UsingRayzoneTarget then
        TriggerEvent('renzu_rayzone:close')
    end
    Wait(1000)
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)
end
exports('closeMenu', closeMenu)

function unfuck(...)
    local a = {...}
    local t = {}
    for k,v in pairs(a) do
        if v == `street` then
            local c = GetEntityCoords(PlayerPedId())
            v = GetStreetNameFromHashKey(GetStreetNameAtCoord(c.x,c.y,c.z))
        end
        if v == `coord` then
            v = GetEntityCoords(PlayerPedId())
        end
        if v == `ent` then
            v = self.target_entity
        end
        if v == `myped` then
            v = PlayerPedId()
        end
        table.insert(t,v)
    end
    return table.unpack(t)
end

function TriggerExport(v,var)
    return assert(load('return '..v..'(...)'))(var)
end

CreateThread(function()
    Wait(1000)
    SendNUIMessage({type = "sound", content = {sound = config.MenuSounds, volume = config.MenuVolume}})
    return
end)

-- Depricated But Still Useable as an event for easy conversion!

RegisterNetEvent('renzu_contextmenu:insert', function(table,title,entity,clear,header)
    Insert(table,title,entity,clear,header)
end)

RegisterNetEvent('renzu_contextmenu:insertmulti', function(table,entity,clear,header)
    MultiInsert(table,entity,clear,header)
end)

RegisterNetEvent('renzu_contextmenu:close', function(table,title,entity,clear,header)
    closeMenu()
end)