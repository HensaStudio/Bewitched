-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hensa = {}
Tunnel.bindInterface("skinshop", Hensa)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Check()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports["hud"]:Reposed(Passport, source) and not exports["hud"]:Wanted(Passport, source) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Update(Clothes)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Clothings", Information = json.encode(Clothes) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("skinshop:Remove")
AddEventHandler("skinshop:Remove", function(Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local ClosestPed = vRPC.ClosestPed(source, 3)
		if ClosestPed then
			if vRP.HasService(Passport, "Policia") then
				TriggerClientEvent("skinshop:set" .. Mode, ClosestPed)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:SEECLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("skinshop:SeeClothes")
AddEventHandler("skinshop:SeeClothes", function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Clothes = vRP.UserData(Passport, "Clothings")
		if Clothes then
			local AllClothes = ""
			for k, v in pairs(Clothes) do
				AllClothes = AllClothes .. k .. ": Item: = " .. v.item .. ", Textura: = " .. v.texture .. "\n"
			end

			vKEYBOARD.Copy(source, "Roupas:", AllClothes)
		end
	end
end)