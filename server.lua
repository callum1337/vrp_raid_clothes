local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","raid_clothes")

vRPclothes = {}
Tunnel.bindInterface("raid_clothes",vRPclothes)
Proxy.addInterface("raid_clothes",vRPclothes)
vRPCclothes = Tunnel.getInterface("raid_clothes","raid_clothes")

function vRPclothes.getPlayerSkin()
    local thePlayer = source
	local user_id = vRP.getUserId({thePlayer})
    if user_id ~= nil then
		local userData = vRP.getUserDataTable({user_id})
		if(userData)then
			if(userData.customization)then
				return userData.customization
			end
		end
    end
	return nil
end

RegisterServerEvent('raid_clothes:save')
AddEventHandler('raid_clothes:save', function()
    local thePlayer = source
    if thePlayer ~= nil then
        local user_id = vRP.getUserId({thePlayer})
        if user_id ~= nil then
			vRPCclothes.savePlayerSkin(thePlayer, {})
			vRPclient.notify(thePlayer, {"~g~Your skin has been saved!"})
        end
    end
end)

AddEventHandler("vRP:playerSpawn",function(user_id,thePlayer,first_spawn)
    if first_spawn then
		local userData = vRP.getUserDataTable({user_id})
		if(userData)then
			if(userData.customization)then
				TriggerClientEvent('raid_clothes:loadclothes', thePlayer, userData.customization)
			end
		end   
	end
end)