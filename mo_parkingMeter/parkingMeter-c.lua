--[[--------------------------]]--
--[[      Made by Mo1810      ]]--
--[[--------------------------]]--

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --  VARIABLES  -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local parkingMeters = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- --  MAIN PART  -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Citizen.CreateThread(function()
	local wait = 2000
	while true do
		local meterObject, distance = ESX.Game.GetClosestObject(coords, Config.props)
		
		if meterObject and distance < 2.5 then
			wait = 6
			local playerCoords = GetEntityCoords(PlayerPedId())
			local objectCoords = GetEntityCoords(meterObject)
			local hoursLeft = 0
			
			local colour = nil
			for k,v in ipairs(parkingMeters) do
				if v.coords == objectCoords then
					hoursLeft = v.hoursLeft
				end
			end
			
			if hoursLeft == nil or hoursLeft == 0 then
				hoursLeft = 0
				colour = "~r~"
			elseif hoursLeft > 0 then
				colour = "~g~"
			end
			
			Draw3DText(objectCoords.x, objectCoords.y, objectCoords.z + 1.0, "~b~"..Config.price.." ~HC_40~".._U('hour').."~n~"..colour..hoursLeft.." ~s~".._U('hoursLeft').."~n~".."~y~[E] ~s~| ~s~".._U('extend1').."  ~y~[X] ~s~| ~s~".._U('extend10'))
			
			--[[1 HOUR]]
			if IsControlJustReleased(0, Config.trigger_key1) then
				TriggerEvent('parkingMeter:addTime', objectCoords, 1)
			end
			--[[1 HOUR]]
				
			--[[10 HOURS]]
			if IsControlJustReleased(0, Config.trigger_key10) then
				TriggerEvent('parkingMeter:addTime', objectCoords, 10)
			end
			--[[10 HOURS]]
		elseif wait ~= 1000 then
			wait = 1000
		end
		Citizen.Wait(wait)
	end
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- EVENT -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RegisterNetEvent('parkingMeter:addTime')
AddEventHandler('parkingMeter:addTime', function(meterCoords, timeAmount)
	local meterIndex = 0
	if #parkingMeters == 0 then
		table.insert(parkingMeters, {coords = meterCoords, hoursLeft = 0})
		meterIndex = 1
	else
		for k,v in ipairs(parkingMeters) do
			if v.coords == meterCoords then
				meterIndex = k
			end
		end
		if meterIndex == 0 then
			table.insert(parkingMeters, {coords = meterCoords, hoursLeft = 0})
			meterIndex = #parkingMeters
		end
	end
	
	ESX.TriggerServerCallback('parkingMeter:removeMoney', function(removed)
		if removed then
			parkingMeters[meterIndex].hoursLeft = (parkingMeters[meterIndex].hoursLeft + timeAmount)
			TriggerServerEvent('parkingMeter:syncTable', parkingMeters)
			notify(_U('removed', (Config.price * timeAmount), timeAmount))
		else
			notify(_U('noMoney', (Config.price * timeAmount)))
		end
	end, timeAmount)
end)

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
        if Config.graySquare then
			local factor = (string.len(text)) / 1500
			DrawRect(_x,_y + 0.040, 0.015 + factor, 0.10, 3, 3, 3, 75)
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
--[[      Made by Mo1810      ]]--
--[[--------------------------]]--
