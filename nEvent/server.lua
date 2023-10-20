local ESX = nil
local JoueurMax = 5
local ParticipantId = 0
local lastPart = nil

if CFG_Evenement.NewESX == true then
    ESX = exports["es_extended"]:getSharedObject()
else
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

ESX.RegisterServerCallback('NeVo_Event:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	cb(group)
end)

RegisterNetEvent("NeVo_Event:SendInfo")
AddEventHandler("NeVo_Event:SendInfo", function(startPos, endPos, desc, NombreJoueurs, _typeVeh, prix, ArgentPropre)
    ParticipantId = 0
    JoueurMax = NombreJoueurs
    local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name ~= 'police' then
			TriggerClientEvent("NeVo_Event:GetInfo", xPlayers[i], startPos, endPos, desc, NombreJoueurs, _typeVeh, prix, ArgentPropre)
		end
	end
    
end)


RegisterNetEvent("NeVo_Event:AddPlayer")
AddEventHandler("NeVo_Event:AddPlayer", function()
    if lastPart ~= source then
        lastPart = source
        ParticipantId = ParticipantId + 1
        if ParticipantId >= JoueurMax then
            TriggerClientEvent("NeVo_Event:MaxPlayerReach", -1)
        end
    end
end)



RegisterNetEvent("NeVo_EventS:Finish")
AddEventHandler("NeVo_EventS:Finish", function(prix, ArgentPropre)
    local xPlayer = ESX.GetPlayerFromId(source)
    if ArgentPropre then
        xPlayer.addMoney(prix)
    else
        xPlayer.addAccountMoney('black_money',prix)
    end
end)