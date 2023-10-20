local ESX = nil
local startPos = nil
local endPos = nil
local desc = ""
local NombreJoueurs = nil
local typeVeh = ""
local prix = 0
local ArgentPropre = false




local participantMax = {
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
}

local index = {
    participant = 1,
}

Citizen.CreateThread(function()
    if CFG_Evenement.NewESX == true then
    ESX = exports["es_extended"]:getSharedObject()
    else
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
	while ESX == nil do Citizen.Wait(100) end
end)

RegisterCommand(CFG_Evenement.command, function()
    ESX.TriggerServerCallback('NeVo_Event:getUsergroup', function(result)
        if result == "superadmin" or result == "admin" or  result == "mod" then
            MenuEvent()
        else
            ESX.ShowNotification(CFG_Evenement.unauthorized)
        end
    end)
end, false)
RegisterKeyMapping('startevent', 'Ouvrir menu Evenement', 'keyboard', 'F4')


function MenuEvent()
    local eventmenu = RageUI.CreateMenu("Menu Evenement", CFG_Evenement.nameserver)
    eventmenu:SetRectangleBanner(11, 11, 11, 0)
                RageUI.Visible(eventmenu, not RageUI.Visible(eventmenu))
                while eventmenu do
                Wait(0)
    
    RageUI.IsVisible(eventmenu, true, true, true, function()

        RageUI.ButtonWithStyle("Fixé la pos start", "Determine la position de dépars" , {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                startPos = GetEntityCoords(GetPlayerPed(-1))
                RageUI.Popup({
                    message = "~g~Coordonée de début définit"
                })
            end
        end)

        RageUI.ButtonWithStyle("Fixé la pos de fin", "Determine la position de fin" , {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                endPos = GetEntityCoords(GetPlayerPed(-1))
                RageUI.Popup({
                    message = "~g~Coordonée de fin définit"
                })
            end
        end)

        RageUI.ButtonWithStyle("Fixé la déscription de l'évent", "Desc: "..desc , {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                AddTextEntry("Déscription évent", "")
                DisplayOnscreenKeyboard(1, "Déscription évent", '', "", '', '', '', 256)
            
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Citizen.Wait(0)
                end
            
                if UpdateOnscreenKeyboard() ~= 2 then
                    desc = GetOnscreenKeyboardResult()
                    Citizen.Wait(1)
                else
                    Citizen.Wait(1)
                end
            end
        end)

        RageUI.List("Nombre de participants", participantMax, index.participant, nil, {}, true, function(Hovered, Active, Selected, Index)
            if (Selected) then
                NombreJoueurs = Index;
            end
            index.participant = Index;
        end)

        RageUI.ButtonWithStyle("Fixé le véhicule de l'event", "Véhicule: "..typeVeh, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                AddTextEntry("VehEvent", "")
                DisplayOnscreenKeyboard(1, "VehEvent", '', "", '', '', '', 20)
            
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Citizen.Wait(0)
                end
            
                if UpdateOnscreenKeyboard() ~= 2 then
                    typeVeh = GetOnscreenKeyboardResult()
                    Citizen.Wait(1)
                else
                    Citizen.Wait(1)
                end
            end
        end)

        RageUI.ButtonWithStyle("Fixé le prix", "Prix: "..prix, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                AddTextEntry("Déscription évent", "")
                DisplayOnscreenKeyboard(1, "Déscription évent", '', "", '', '', '', 20)
            
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Citizen.Wait(0)
                end
            
                if UpdateOnscreenKeyboard() ~= 2 then
                    prix = tonumber(GetOnscreenKeyboardResult())
                    Citizen.Wait(1)
                else
                    Citizen.Wait(1)
                end
            end
        end)

        RageUI.Checkbox("Argent propre ?", "Si activer, l'argent reçu sera de l'argent propre.", ArgentPropre, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
            ArgentPropre = Checked;
        end)

        RageUI.ButtonWithStyle("~g~Validé l'évent", "Commencer l'évent", {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("NeVo_Event:SendInfo", startPos, endPos, desc, index.participant, typeVeh, prix, ArgentPropre)
            end
        end)

    end, function()
    end)
        if not RageUI.Visible(eventmenu) then
            eventmenu = RMenu:DeleteType("eventmenu", true)
        end
    end
    end