ESX = nil
 
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- Intéraction [E]

Citizen.CreateThread(function()
    while true do
        local wait = 900
        for k,v in pairs(Config.Positions) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)
            if dist <= 5 then 
                wait = 1                                                 
                DrawMarker(6, v.x, v.y, v.z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
             end
            if dist <= 2 then
                wait = 1
                Visual.Subtitle("Appuyer sur ~y~[E]~s~ pour accèder au ~y~DarkShop ~s~!", 1) 
                if IsControlJustPressed(1,51) then
                    OpenLocation()
                end
            end 
        end
    Citizen.Wait(wait)
    end
end)

-- NPC

CreateThread(function()
    local canCallJob = false
    for k, v in pairs(Config.NPC) do
        RequestModel(GetHashKey(v.typePed))
        while not HasModelLoaded(GetHashKey(v.typePed)) do
            Wait(1)
        end
        local npc = CreatePed(4, v.typePed, v.position.x, v.position.y, v.position.z-0.98, v.heading,  false, true)
        SetPedFleeAttributes(npc, 0, 0)
        SetPedDropsWeaponsWhenDead(npc, false)
        SetPedDiesWhenInjured(npc, false)
        SetEntityInvincible(npc , true)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
    end
end)

-- Menu

local open = false 
local mainMenu = RageUI.CreateMenu('DarkShop', 'ACHAT ILLÉGAL')
mainMenu.Display.Header = true 
mainMenu.Closed = function()
  FreezeEntityPosition(PlayerPedId(), false)
  open = false
end

function OpenLocation()
    if open then 
        open = false
        RageUI.Visible(mainMenu, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do 

                RageUI.IsVisible(mainMenu, function() 

                    RageUI.Separator("↓ ~y~ DarkShop ~s~↓")
                    RageUI.Separator("→ Mode de Paiement : ~y~Liquide ~s~ ←")

                    for k,v in pairs(Config.Items) do
                        RageUI.Button(v.Label, nil, {RightLabel = "~y~" ..v.Prix.. "$"}, true , {
                            onSelected = function()
                                Model = v.Model
                                Prix = v.Prix
                                TriggerServerEvent("pDarkShop:achatliquide", Model, Prix)
                            end
                        })
                    end
                end)

            Wait(0)
            end
        end)
    end
end