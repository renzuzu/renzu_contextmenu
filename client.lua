local open = false

RegisterNUICallback('close', function(data, cb)
    open = false
    SendNUIMessage({type = "reset", content = true})
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)
    if config.UsingRayzoneTarget then
        TriggerEvent('renzu_rayzone:close')
    end
end)

RegisterNetEvent('renzu_contextmenu:insert')
AddEventHandler('renzu_contextmenu:insert', function(table,title,entity,clear)
    local table = {
        content = table,
        k = title,
        entity = entity,
        clear = clear
    }
    print(table,"GAGO",title,entity,clear)
    SendNUIMessage({type = "insert", content = table})
end)

RegisterNetEvent('renzu_contextmenu:insertmulti')
AddEventHandler('renzu_contextmenu:insertmulti', function(table,title,entity,clear)
    for k,v in pairs(table) do
        local table = {
            content = v.data,
            k = v.title,
            entity = v.entity,
            clear = v.clear
        }
        print(table,"GAGO",title,entity,clear)
        SendNUIMessage({type = "insert", content = table})
    end
end)

RegisterNetEvent('renzu_contextmenu:show')
AddEventHandler('renzu_contextmenu:show', function(table,title,entity,clear)
    SendNUIMessage({type = "show", content = true})
    SetNuiFocus(true,true)
end)

RegisterNUICallback('receivedata', function(data, cb)
    ReceiveData(data)
end)

function ReceiveData(data)
    local foundevent = false-- security pass the events if its registered only at config!
    local data = data.table
    print(data.content)
    if data.variables.onclickcloseui then -- close the ui before any trigger event, prevent UI bug from other NUI focus.
        SendNUIMessage({type = "reset", content = true})
        SetNuiFocus(false,false)
        SetNuiFocusKeepInput(false)
        if config.UsingRayzoneTarget then
            TriggerEvent('renzu_rayzone:close')
        end
    end
    Wait(100)
    if data.variables.server then -- is this a server event?
        if data.variables.send_entity then -- pass the entity only ?
            TriggerServerEvent(data.content,data.variables.entity)
        else -- else pass the whole variables for custom table etc..
            if data.variables.arg_unpack then
                TriggerServerEvent(data.content,unfuck(table.unpack(data.variables.custom_arg)))
            else
                TriggerServerEvent(data.content,data.variables.custom_arg)
            end
        end
    else -- else client event only
        if data.variables.send_entity then -- pass the entity only ?
            TriggerEvent(data.content,data.variables.entity)
        else -- else pass the whole variables for custom table etc..
            if data.variables.arg_unpack then
                TriggerEvent(data.content,unfuck(table.unpack(data.variables.custom_arg)))
            else
                TriggerEvent(data.content,data.variables.custom_arg)
            end
        end
    end
end

RegisterNetEvent('renzu_contextmenu:close')
AddEventHandler('renzu_contextmenu:close', function(table)
    open = false
    SendNUIMessage({type = "reset", content = true})
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)
    if config.UsingRayzoneTarget then
        TriggerEvent('renzu_rayzone:close')
    end
end)

function Event(data,custom_arg)
    if data == nil or data.table == nil then
        local t = data
        data = {}
        data.table = t
    end
    if custom_arg == nil then
        custom_arg = {}
    end
    if data.table['server_event'] and data.table['event'] ~= nil then
        TriggerServerEvent(data.table['event'],unfuck(table.unpack(custom_arg)))
    elseif data.table['event'] ~= nil then
        TriggerEvent(data.table['event'],unfuck(table.unpack(custom_arg)))
    end
end

function unfuck(...)
    local a = {...}
    local t = {}
    for k,v in pairs(a) do
        table.insert(t,v)
    end
    return table.unpack(t)
end