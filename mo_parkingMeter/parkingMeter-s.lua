--[[--------------------------]]--
--[[      Made by Mo1810      ]]--
--[[--------------------------]]--

local parkingMeters = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- --   MAIN THREAD  -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.HourTimer * 60000)
		for k,v in ipairs(parkingMeters) do
			if v.hoursLeft ~= 0 then
				v.hoursLeft = (v.hoursLeft - 1)
			end
		end
		local xPlayer = ESX.GetPlayerFromId(1)
		TriggerClientEvent('parkingMeter:syncTable', -1, parkingMeters)
	end
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- --  SERVER CALLBACK  -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

ESX.RegisterServerCallback("parkingMeter:removeMoney",function(source, cb, hours)
	local xPlayer = ESX.GetPlayerFromId(source)
	Citizen.Wait(10)
	if xPlayer.getAccount(Config.accountType).money >= (hours * Config.price) then
		xPlayer.removeAccountMoney(Config.accountType, hours * Config.price)
		cb(true)
	else
		cb(false)
	end
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- EVENT -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RegisterServerEvent('parkingMeter:syncTable')
AddEventHandler('parkingMeter:syncTable', function(_parkingMeters)
	parkingMeters = _parkingMeters
	TriggerClientEvent('parkingMeter:syncTable', -1, parkingMeters)
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
	print('Script by Mo1810 - https://discord.gg/Q25mtKms8c')
end)

--[[--------------------------]]--
--[[      Made by Mo1810      ]]--
--[[--------------------------]]--
