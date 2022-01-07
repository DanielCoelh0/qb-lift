-- Copyright (C) 2021 KUMApt & Shadowskrt

local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local PlayerJob, PlayerGang = {}
local floorsMenu = {}

AddEventHandler('onResourceStart', function(resource)
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    PlayerGang = PlayerData.gang
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    PlayerGang = PlayerData.gang
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerJob = job
end)
RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    PlayerGang = gang
end)

local DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function openFloorsMenu(lift, floor)
    floorsMenu = {
        {
            header = Config.Elevators[lift].Name,
            text = Config.Language[Config.UseLanguage].CurrentFloor .. Config.Elevators[lift].Floors[floor].Label,
            isMenuHeader = true
        },
    }

    for j = 1, #Config.Elevators[lift].Floors, 1 do
        if j ~= floor then
            floorsMenu[#floorsMenu + 1] = {
                header = '' .. Config.Elevators[lift].Floors[j].Label ..'',
                txt = '' .. Config.Elevators[lift].Floors[j].FloorDesc ..'',
                params = {
                    event = 'qb-lift:checkFloorPermission',
                    args = {
                        lift = lift,
                        floor = Config.Elevators[lift].Floors[j],
                    }
                }
            }
        end
	end
    exports['qb-menu']:openMenu(floorsMenu)
end

local function changeFloor(data)
    local ped = PlayerPedId()

    QBCore.Functions.Progressbar("callLift", Config.Language[Config.UseLanguage].Waiting, 5000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@apt_trans@elevator",
        anim = "elev_1",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, "anim@apt_trans@elevator", "elev_1", 1.0)
        DoScreenFadeOut(500)
        Citizen.Wait(1000)
        if Config.UseSoundEffect then
            TriggerServerEvent("InteractSound_SV:PlayOnSource", Config.Elevators[data.lift].Sound, 0.05)
        end
        SetEntityCoords(ped, data.floor.Coords.x, data.floor.Coords.y, data.floor.Coords.z, 0, 0, 0, false)
        SetEntityHeading(ped, data.floor.ExitHeading)
        Citizen.Wait(1000)
        DoScreenFadeIn(600)
        
    end)
end

CreateThread(function()
    Wait(1000)
    while true do
        Wait(5)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inLiftRange = false
        for k, v in pairs(Config.Elevators) do
            for i, b in pairs(Config.Elevators[k].Floors) do
                local liftDist = #(pos - b.Coords)
                if liftDist <= 4 then
                    inLiftRange = true
                    DrawMarker(2, b.Coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if liftDist <= 1.5 then
                        if not IsPedInAnyVehicle(ped) then
                            DrawText3Ds(b.Coords.x, b.Coords.y, b.Coords.z + 0.2, Config.Language[Config.UseLanguage].Call)
                            if IsControlJustPressed(0, 38) then
                                openFloorsMenu(k, i)
                            end
                        end
                    end
                end
            end
        end
        if not inLiftRange then
            Wait(1000)
        end
    end
end)

RegisterNetEvent('qb-lift:checkFloorPermission')
AddEventHandler('qb-lift:checkFloorPermission', function(data)
    if Config.Elevators[data.lift].Group then
        if data.floor.Restricted then
            if IsAuthorized(data.lift) then
                changeFloor(data)
            else
                QBCore.Functions.Notify(Config.Language[Config.UseLanguage].Restricted, "error")
            end
        else
            changeFloor(data)
        end
    else
        changeFloor(data)
    end
end)

--helper function
function IsAuthorized(lift)
    for a=1, #Config.Elevators[lift].Group do
        if PlayerJob.name == Config.Elevators[lift].Group[a] or PlayerGang.name == Config.Elevators[lift].Group[a] then
            return true
        end
    end
    return false
end