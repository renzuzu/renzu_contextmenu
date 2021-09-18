local open = false

RegisterNetEvent('renzu_contextmenu:insert')
AddEventHandler('renzu_contextmenu:insert', function(table,title,entity,clear,header)
    local table = {
        header = header or '<i class="fas fa-eye"></i> INTERACTION',
        content = table,
        k = title or "TITLE MISSING",
        entity = entity or -1,
        clear = clear or false
    }
    SendNUIMessage({type = "insert", content = table})
end)

RegisterNetEvent('renzu_contextmenu:insertmulti')
AddEventHandler('renzu_contextmenu:insertmulti', function(table,entity,clear,header)
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
            main_fa = v.main_fa or false
        }
        v.main_fa = nil
        SendNUIMessage({type = "insert", content = t})
    end
end)

RegisterNetEvent('renzu_contextmenu:show')
AddEventHandler('renzu_contextmenu:show', function(table,title,entity,clear)
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
end)

RegisterNetEvent('renzu_contextmenu:clear')
AddEventHandler('renzu_contextmenu:clear', function()
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
                TriggerServerEvent(data.content,unfuck(table.unpack(data.variables.custom_arg)))
            else
                TriggerServerEvent(data.content,data.variables.custom_arg)
            end
        end
    elseif data.type == 'event' and data.variables ~= nil and data.variables.server ~= true then -- else client event only
        if data.variables.send_entity then -- pass the entity only ?
            TriggerEvent(data.content,data.variables.entity)
        else -- else pass the whole variables for custom table etc..
            if data.variables.arg_unpack then
                TriggerEvent(data.content,unfuck(table.unpack(data.variables.custom_arg)))
            else
                TriggerEvent(data.content,data.variables.custom_arg)
            end
        end
    elseif data.type == 'export' and data.variables ~= nil and data.variables.exports ~= nil then
        TriggerExport(data.variables.exports,data.variables.custom_arg)
    elseif data.type == 'shop' then
        TriggerServerEvent("renzu_rayzone:shop",data)
        SendNUIMessage({type = "reset", content = true})
        SetNuiFocus(false,false)
        SetNuiFocusKeepInput(false)
        if config.UsingRayzoneTarget then
            TriggerEvent('renzu_rayzone:close')
        end
        open = false
    end
end

RegisterNetEvent('renzu_contextmenu:close')
AddEventHandler('renzu_contextmenu:close', function()
    close()
end)

RegisterNUICallback('close', function(data)
    close()
end)

function close()
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

function unfuck(...)
    local a = {...}
    local t = {}
    for k,v in pairs(a) do
        --print(v == `street`,v,`street`)
        if v == `street` then
            print("changing")
            local c = GetEntityCoords(PlayerPedId())
            v = GetStreetNameFromHashKey(GetStreetNameAtCoord(c.x,c.y,c.z))
            print(v)
        end
        if v == `coord` then
            print('changing')
            v = GetEntityCoords(PlayerPedId())
            print(v)
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