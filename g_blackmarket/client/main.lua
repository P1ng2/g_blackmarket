Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    local hash = GetHashKey(Config.pedModel)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end



    local pedscoords = Config.pedCoords
    local ped = CreatePed("Scenariomale", hash, pedscoords, Config.pedHeading, false, true)
    local prop = CreateObject(GetHashKey('prop_box_wood05a'), 1546.1, 2184.01, 77.8, true, false, false)
    local prop2 = CreateObject(GetHashKey('prop_box_wood05a'), 1546.1, 2184.01, 78.6, true, false, false)

    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)

    if Config.BlipHabilitado == true then
        local blip = AddBlipForCoord(Config.Blip.Coords)
        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipColour(blip, Config.Blip.Color)
        SetBlipScale(blip, Config.Blip.Scale)
    end


    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - pedscoords)
        
        if distance <= 3 then
            ESX.ShowFloatingHelpNotification(Config.pedMensaje, Config.pedMensajeCoords)

            if IsControlJustPressed(0, 38) then
                local options = {}

                ESX.TriggerServerCallback('goofy_blackmarket:getArmas', function(respuesta)
                    if respuesta then
                      
                        for k, v in pairs(respuesta) do
                          
                            table.insert(options, {
                                title = tostring(v.arma),
                                description = 'Precio: ' .. tostring(formatNumberWithPoints(v.precio)) .. '\n Stock: ' .. tostring(v.stock),
                                icon = 'gun',
                                disabled = DisableForStock(v.stock), 
                                onSelect = function()
                                    SetEntityHeading(ped, 226.388)
                                    
                                    playPedAnimation(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer")
                                    Wait(3000)
                                    ClearPedTasks(ped)
                

                                    SetEntityHeading(ped, Config.pedHeading)
                                    playPedAnimation(ped, "mp_common", "givetake1_a")
                                    Wait(1200)
                                    ClearPedTasks(ped)
                                
                                    TriggerServerEvent('goofy_blackmarket:ComprarArma', v.arma, v.precio, v.modelo)
                               
                                
                                end,
                            })
                        end
                    else
                        
                    end
                    lib.registerContext({
                        id = 'pre_black_market_menu',
                        title = 'Mercado Negro',
                        options = {
                            {
                                title = 'Comprar Armas',
                                description = 'Haz click para comprar Armas',
                                icon = 'gun',
                                onSelect = function()
                                    lib.showContext('black_market_menu')
                                end,
                            },
                            {
                                title = 'Llamar a la policia',
                                description = 'Haz click para entregar a Raul',
                                icon = 'fas fa-user-shield',
                                onSelect = function()
                                    
                                    playPedAnimation(ped, "weapons@first_person@aim_lt@p_m_zero@heavy@rail_gun@fidgets@c", "fidget_med_loop")
                                    Wait(1000)
                                    PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true)
                                    ExecuteCommand('kill '..GetPlayerServerId(PlayerId()))
                                    ClearPedTasks(ped)
                                    
                                    
                                end
                            }
                        }
                    })


                    lib.registerContext({
                        id = 'black_market_menu',
                        title = 'Mercado Negro',
                        options = options,
                    })
                    
                    

                    lib.showContext('pre_black_market_menu')
                end)
            end
        end
    end
end)


function DisableForStock(stock)
    if stock > 0 then
        return false
    else
        return true
    end





end
function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end
function playPedAnimation(ped, animDict, animName)
    loadAnimDict(animDict)
    TaskPlayAnim(ped, animDict, animName, 8.0, 8.0, -1, 49, 0, false, false, false)
end
function formatNumberWithPoints(number)
    local formatted = tostring(number)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if k == 0 then
            break
        end
    end
    return formatted
end


