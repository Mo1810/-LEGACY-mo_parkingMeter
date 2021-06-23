--[[--------------------------]]--
--[[  Created by Mo1810#4230  ]]--
--[[--------------------------]]--

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj
end)

local parkingMeter = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- --   MAIN THREAD  -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.HourTimer * 60000)
		for k,v in ipairs(parkingMeter) do
			if parkingMeter[k].hoursLeft ~= 0 then
				parkingMeter[k].hoursLeft = (parkingMeter[k].hoursLeft - 1)
			end
		end
		local xPlayer = ESX.GetPlayerFromId(1)
		TriggerClientEvent('parkingMeter:syncTable', -1, parkingMeter)
	end
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- --  SERVER CALLBACK  -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

ESX.RegisterServerCallback("parkingMeter:removeMoney",function(source, cb, hours)
	local xPlayer = ESX.GetPlayerFromId(source)
	Citizen.Wait(10)
	if Config.useCashAccount then
		if xPlayer.getAccount(Config.accountType).money >= (hours * Config.price) then
			xPlayer.removeAccountMoney(Config.accountType, hours * Config.price)
			cb(true)
		else
			cb(false)
		end
	else
		if xPlayer.getMoney() >= (hours * Config.price) then
			xPlayer.removeMoney(hours * Config.price)
			cb(true)
		else
			cb(false)
		end
	end
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- EVENT -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RegisterServerEvent('parkingMeter:syncTable')
AddEventHandler('parkingMeter:syncTable', function(_parkingMeter)
	parkingMeter = _parkingMeter
	TriggerClientEvent('parkingMeter:syncTable', -1, parkingMeter)
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
	print('Script by Mo1810#4230 - https://discord.gg/Q25mtKms8c')
end)

--[[--------------------------]]--
--[[  Created by Mo1810#4230  ]]--
--[[--------------------------]]--