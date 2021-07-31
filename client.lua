local open = false

RegisterNetEvent('renzu_contextmenu:insert')
AddEventHandler('renzu_contextmenu:insert', function(table,title,entity,clear)
    local table = {
        content = table,
        k = title or "TITLE MISSING",
        entity = entity or -1,
        clear = clear or false
    }
    SendNUIMessage({type = "insert", content = table})
end)

RegisterNetEvent('renzu_contextmenu:insertmulti')
AddEventHandler('renzu_contextmenu:insertmulti', function(table,entity,clear)
    for k,v in pairs(table) do
        local t = {
            content = v,
            k = k or "TITLE MISSING",
            entity = entity or -1,
            clear = clear or false
        }
        SendNUIMessage({type = "insert", content = t})
    end
end)

RegisterNetEvent('renzu_contextmenu:show')
AddEventHandler('renzu_contextmenu:show', function(table,title,entity,clear)
    SendNUIMessage({type = "show", content = true})
    SetNuiFocus(true,true)
    open = true
    CreateThread(function()
        while open and config.disablemouse do
            DisableControlAction(1, 1, true)
            DisableControlAction(1, 2, true)
            Wait(5)
        end
        return
    end)
    CreateThread(function()
        while open do -- prevent overlapping nui focus to other resources
            SetNuiFocus(true,true)
            SetNuiFocusKeepInput(false)
            Wait(100)
        end
        SetNuiFocus(false,false)
        SetNuiFocusKeepInput(false)
        return
    end)
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
        if data.variables.exports ~= nil and v == data.variables.exports then
            foundevent = true
        end
    end
    print(data.content)
    if not foundevent and config.WhitelistEvents then return end
    if data.variables.onclickcloseui then -- close the ui before any trigger event, prevent UI bug from other NUI focus.
        SendNUIMessage({type = "reset", content = true})
        SetNuiFocus(false,false)
        SetNuiFocusKeepInput(false)
        if config.UsingRayzoneTarget then
            TriggerEvent('renzu_rayzone:close')
        end
        open = false
    end
    print("EVENT")
    Wait(100)
    if data.type == 'event' and data.variables.server then -- is this a server event?
        if data.variables.send_entity then -- pass the entity only ?
            TriggerServerEvent(data.content,data.variables.entity)
        else -- else pass the whole variables for custom table etc..
            if data.variables.arg_unpack then
                TriggerServerEvent(data.content,unfuck(table.unpack(data.variables.custom_arg)))
            else
                TriggerServerEvent(data.content,data.variables.custom_arg)
            end
        end
    elseif data.type == 'event' and not data.variables.server then -- else client event only
        if data.variables.send_entity then -- pass the entity only ?
            TriggerEvent(data.content,data.variables.entity)
        else -- else pass the whole variables for custom table etc..
            if data.variables.arg_unpack then
                TriggerEvent(data.content,unfuck(table.unpack(data.variables.custom_arg)))
            else
                TriggerEvent(data.content,data.variables.custom_arg)
            end
        end
    elseif data.type == 'export' and data.variables.exports ~= nil then
        TriggerExport(data.variables.exports,data.variables.custom_arg)
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
    Wait(10)
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
end)