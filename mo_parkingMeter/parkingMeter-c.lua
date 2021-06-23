--[[--------------------------]]--
--[[  Created by Mo1810#4230  ]]--
--[[--------------------------]]--

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --  VARIABLES  -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local parkingMeter = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --  MAIN PART  -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Citizen.CreateThread(function()
	while true do
		for k,v in ipairs(ESX.Game.GetObjects()) do
			local playerCoords = GetEntityCoords(PlayerPedId())
			local objectCoords = GetEntityCoords(v)
			while GetDistanceBetweenCoords(playerCoords, objectCoords, true) < 2.5 and GetEntityModel(v) == GetHashKey("prop_parknmeter_01") do
				playerCoords = GetEntityCoords(PlayerPedId())
				objectCoords = GetEntityCoords(v)
				local colour = nil
				local found = false
				for k,v in ipairs(parkingMeter) do
					if parkingMeter[k].coords == objectCoords then
						found = true
						hoursLeft = parkingMeter[k].hoursLeft
					end
				end
				
				if hoursLeft == nil or not found then
					hoursLeft = 0
				end
				
				if hoursLeft > 0 then
					colour = "~g~"
				else
					colour = "~r~"
				end
				Draw3DText(objectCoords.x, objectCoords.y, objectCoords.z + 1.0, "~b~"..Config.price.." ~s~".._U('hour').."~n~"..colour..hoursLeft.." ~s~".._U('hoursLeft').."~n~".."~y~[E] ~s~| ".._U('extend1').."  ~y~[X] ~s~| ".._U('extend10'))
				
				--[[1 HOUR]]
				if IsControlJustReleased(0, Config.trigger_key1) then
					local hours = 1
					if #parkingMeter == 0 then
						ESX.TriggerServerCallback('parkingMeter:removeMoney', function(removed)
							if removed then
								table.insert(parkingMeter, {coords = objectCoords, hoursLeft = hours})
								TriggerServerEvent('parkingMeter:syncTable', parkingMeter)
								notify(_U('removed', (Config.price * hours), hours))
							else
								notify(_U('noMoney', (Config.price * hours)))
							end
						end, hours)
					else
						local found = false
						for k,v in ipairs(parkingMeter) do
							if parkingMeter[k].coords == objectCoords then
								found = true
								ESX.TriggerServerCallback('parkingMeter:removeMoney', function(removed)
									if removed then
										parkingMeter[k].hoursLeft = (parkingMeter[k].hoursLeft + hours)
										TriggerServerEvent('parkingMeter:syncTable', parkingMeter)
										notify(_U('removed', (Config.price * hours), hours))
									else
										notify(_U('noMoney', (Config.price * hours)))
									end
								end, hours)
							end
						end
						
						if not found then
							ESX.TriggerServerCallback('parkingMeter:removeMoney', function(removed)
								if removed then
									table.insert(parkingMeter, {coords = objectCoords, hoursLeft = hours})
									TriggerServerEvent('parkingMeter:syncTable', parkingMeter)
									notify(_U('removed', (Config.price * hours), hours))
								else
									notify(_U('noMoney', (Config.price * hours)))
								end
							end, hours)
						end
					end
				end
				--[[1 HOUR]]
				
				--[[10 HOURS]]
				if IsControlJustReleased(0, Config.trigger_key10) then
					local hours = 10
					if #parkingMeter == 0 then
						ESX.TriggerServerCallback('parkingMeter:removeMoney', function(removed)
							if removed then
								table.insert(parkingMeter, {coords = objectCoords, hoursLeft = hours})
								TriggerServerEvent('parkingMeter:syncTable', parkingMeter)
								notify(_U('removed', (Config.price * hours), hours))
							else
								notify(_U('noMoney', (Config.price * hours)))
							end
						end, hours)
					else
						found = false
						for k,v in ipairs(parkingMeter) do
							if parkingMeter[k].coords == objectCoords then
								found = true
								ESX.TriggerServerCallback('parkingMeter:removeMoney', function(removed)
									if removed then
										parkingMeter[k].hoursLeft = (parkingMeter[k].hoursLeft + hours)
										TriggerServerEvent('parkingMeter:syncTable', parkingMeter)
										notify(_U('removed', (Config.price * hours), hours))
									else
										notify(_U('noMoney', (Config.price * hours)))
									end
								end, hours)
							end
						end
						
						if not found then
							ESX.TriggerServerCallback('parkingMeter:removeMoney', function(removed)
								if removed then
									table.insert(parkingMeter, {coords = objectCoords, hoursLeft = hours})
									TriggerServerEvent('parkingMeter:syncTable', parkingMeter)
									notify(_U('removed', (Config.price * hours), hours))
								else
									notify(_U('noMoney', (Config.price * hours)))
								end
							end, hours)
						end
					end
				end
				--[[10 HOURS]]
				Citizen.Wait(5)
			end
		end
		Citizen.Wait(1000)
	end
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- EVENT -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RegisterNetEvent('parkingMeter:syncTable')
AddEventHandler('parkingMeter:syncTable', function(_parkingMeter)
	parkingMeter = _parkingMeter
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --  FUNCTIONS  -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.0, 0.4)
        SetTextLeading(true)
        SetTextFont(4)
        SetTextProportional(0.5)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        if Config.greySquare == true then
			local factor = (string.len(text)) / 370
			DrawRect(_x,_y+0.0125, 0.015+ factor, 0.038, 003, 003, 003, 75)
        end
        DrawText(_x, _y)
    end
end

function notify(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	EndTextCommandThefeedPostTicker(false, true)
end

--[[--------------------------]]--
--[[  Created by Mo1810#4230  ]]--
--[[--------------------------]]--