local blip = nil
local _blip2 = nil
local started = false

local EventEnCourds = false

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports["es_extended"]:getSharedObject()
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("NeVo_Event:GetInfo")
AddEventHandler("NeVo_Event:GetInfo", function(startPos, endPos, desc, NombreJoueurs, veh, prix, ArgentPropre)
    SetAudioFlag("LoadMPData", 1)
    if not EventEnCourds then
        EventEnCourds = true
        PlaySoundFrontend(-1, "10s", "MP_MISSION_COUNTDOWN_SOUNDSET", 1)
        PlaySoundFrontend(-1, "10s", "MP_MISSION_COUNTDOWN_SOUNDSET", 1)
        Wait(10*1000)
        PlaySoundFrontend(-1, "Boss_Message_Orange", "GTAO_Boss_Goons_FM_Soundset", 1)
        PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

        started = false
        RageUI.Popup({
            message = "~g~EVENEMENT CITOYEN\n~w~"..desc
        })
        if ArgentPropre then
            RageUI.Popup({
                message = "~g~INFORMATION\n~w~Participant Max: ~b~"..NombreJoueurs.."\n~w~Type de véhicule: ~b~"..veh.."\n~w~Gain: ~b~"..prix.."~w~$\nType de gain: ~g~Argent propre."
            })
        else
            RageUI.Popup({
                message = "~g~INFORMATION\n~w~Participant Max: ~b~"..NombreJoueurs.."\n~w~Type de véhicule: ~b~"..veh.."\n~w~Gain: ~b~"..prix.."~w~$\nType de gain: ~r~Argent sale."
            })
        end
        Wait(3*1000)
        PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
        PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
        PlaySoundFrontend(-1, "Boss_Blipped", "GTAO_Magnate_Hunt_Boss_SoundSet", 1)
        PlaySoundFrontend(-1, "Airhorn", "DLC_TG_Running_Back_Sounds", 1)

        blip = AddBlipForCoord(startPos)
        SetBlipSprite(blip, 586)
        SetBlipScale(blip, 1.0)

        _blip2 = AddBlipForCoord(startPos)
        SetBlipSprite(_blip2, 161)
        SetBlipColour(_blip2, 69)

        BeginTextCommandSetBlipName('STRING')
    	AddTextComponentString("Evenement citoyen")
        EndTextCommandSetBlipName(blip)

        local pPed = GetPlayerPed(-1)
        local pressed = false
        while not started do
            Citizen.Wait(10)
            DrawMarker(32, startPos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 170, 1, 1, 2, 0, nil, nil, 0)
            local pCoords = GetEntityCoords(pPed)
            local dst = GetDistanceBetweenCoords(startPos, pCoords, true)
            if dst <= 3.0 then
                RageUI.Text({
                    message = "Appuyer sur ~b~[E]~w~ pour lancer la mission"
                })
                if IsControlJustReleased(1, 38) and not pressed and not IsPedInAnyVehicle(pPed, false) and ESX.Game.IsSpawnPointClear(startPos, 5.0) then
                    pressed = true
                    TriggerServerEvent("NeVo_Event:AddPlayer")
                    StartMission(startPos, endPos, veh, prix, ArgentPropre)
                else
                    RageUI.Popup({
                        message = "Tu dois être à pied pour lancer la mission, appuie sûr ~b~E~w~ pour lancer la mission\n~r~La zone doit être dégagé pour sortir le véhicule d'event !"
                    })
                end
            end
        end
    end
end)



function StartMission(startPos, endPos, veh, prix, ArgentPropre)
    RageUI.Popup({
        message = "~g~MISSION\n~w~Apporte le véhicule rapidement ! Suis le chemin GPS !"
    })
    LoadModel(GetHashKey(veh))
    local _blip = AddBlipForCoord(endPos)
    SetBlipSprite(_blip, 586)
    SetBlipScale(_blip, 1.0)
    SetBlipRoute(_blip, true)
    
    local veh = CreateVehicle(GetHashKey(veh), startPos, GetEntityHeading(GetPlayerPed(-1)), 1, 1)
    SetPedIntoVehicle(GetPlayerPed(-1), veh, -1)

    BeginTextCommandSetBlipName('STRING')
	AddTextComponentString("Evenement citoyen fin")
    EndTextCommandSetBlipName(_blip)

    local finish = false
    local pPed = GetPlayerPed(-1)
    while not finish do
        Citizen.Wait(1)
        local pCoords = GetEntityCoords(pPed)
        local dst = GetDistanceBetweenCoords(pCoords, endPos)
        if dst <= 50.0 then
            DrawMarker(29, endPos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 170, 1, 1, 2, 0, nil, nil, 0)
            if dst <= 3.0 then
                local veh = GetVehiclePedIsIn(pPed, true)
                SetEntityAsNoLongerNeeded(veh)
                DeleteEntity(veh)
                local prix = prix + math.random(1,1000)
                RageUI.Popup({
                    message = "~g~INFORMATION\n~w~Event terminé, tu à gagné: ~b~"..prix.."~w~$ cash"
                })
                TriggerServerEvent("NeVo_EventS:Finish", prix, ArgentPropre)
                break
            end
        end
    end
    RemoveBlip(blip)
    RemoveBlip(_blip2)
    RemoveBlip(_blip)
    ClearAllBlipRoutes()
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
        RequestModel(model)
    end
end


RegisterNetEvent("NeVo_Event:MaxPlayerReach")
AddEventHandler("NeVo_Event:MaxPlayerReach", function()
    EventEnCourds = false
    RemoveBlip(blip)
    RemoveBlip(_blip2)
    started = true
    RageUI.Popup({
        message = "~g~INFORMATION\n~w~Event terminé, nombre de participant max atteinds."
    })
end)