ESX = exports["es_extended"]:getSharedObject()




ESX.RegisterServerCallback('goofy_blackmarket:getArmas', function(src, cb)
    local response = MySQL.query.await('SELECT * FROM `goofy_blackmarket`', {})

    if response then
        cb(response)
    end
end)


RegisterServerEvent('goofy_blackmarket:ComprarArma')
AddEventHandler('goofy_blackmarket:ComprarArma', function(arma, precio, modelo)
    local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getAccount('black_money').money >= precio then
            xPlayer.removeAccountMoney('black_money', precio)
            exports.ox_inventory:AddItem(xPlayer.source, modelo, 1)
            DeleteStock(arma)
            --TriggerClientEvent('goofy_notis:sendnoti', source, { type = 'success', message = 'Compraste una '..arma, 2500 })
            xPlayer.showNotification('Compraste una '..arma)
        else
           
            xPlayer.showNotification('No tienes el dinero en negro suficiente')
        end 
end)

function DeleteStock(arma)
    MySQL.update('UPDATE goofy_blackmarket SET stock = stock - 1 WHERE arma = ?', {
        arma
    }, function(affectedRows)
        
    end)
end

function GiveGun()



end