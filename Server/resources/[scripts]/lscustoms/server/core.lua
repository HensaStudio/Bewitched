-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hensa = {}
Tunnel.bindInterface("lscustoms",Hensa)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Permission(Index)
	local source = source
	local Passport = vRP.Passport(source)
	local Permission = Locations[Index]["Permission"]
	if Passport then
		-- if exports["hud"]:Wanted(Passport,source) then
			-- return false
		-- end

		if not Permission then
			return true
		else
			if vRP.HasService(Passport,Permission) then
				return true
			else
				TriggerClientEvent("Notify", source, "Atenção", "Você não tem permissões.", "amarelo", 5000)
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Save(Model,Plate,Mods,Price)
	local source = source
	local Passport = vRP.Passport(source)

	if Passport then
		if vRP.PaymentFull(Passport,Price) then
			vRP.Query("entitydata/SetData",{ Name = "LsCustoms:"..Passport..":"..Model, Information = json.encode(Mods) })
			return true
		end
	end
	
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local inVehicle = {}
RegisterServerEvent("lscustoms:Network")
AddEventHandler("lscustoms:Network",function(Network,Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Network then
			if inVehicle[Passport] then
				inVehicle[Passport] = nil
			end
		else
			inVehicle[Passport] = { Network,Plate }
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if inVehicle[Passport] then
		Wait(1000)
		TriggerEvent("garages:deleteVehicle",inVehicle[Passport][1],inVehicle[Passport][2])
		inVehicle[Passport] = nil
	end
end)