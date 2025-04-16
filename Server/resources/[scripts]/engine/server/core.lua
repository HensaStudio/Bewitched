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
Tunnel.bindInterface("engine", Hensa)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Brakes = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.RechargeFuel(Price)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Price then
		if vRP.PaymentFull(Passport,Price) then
			exports["bank"]:AddTaxs(Passport,source,"Posto de Gasolina",Price,"Gastos com combustível.")

			return true
		else
			TriggerClientEvent("Notify",source,"Aviso","<b>"..ItemName(DefaultMoneyOne).."</b> insuficientes.","vermelho",5000)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.VehicleBrakes(Vehicle)
	if Brakes[Vehicle] == nil then
		Brakes[Vehicle] = { 0.55, 0.35, 0.45 }
	end

	return Brakes[Vehicle]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:TryBrakes")
AddEventHandler("engine:TryBrakes",function(Vehicle,Status,PlayerAround)
	Brakes[Vehicle] = Status

	if PlayerAround then
		for _,v in ipairs(PlayerAround) do
			async(function()
				TriggerClientEvent("engine:SyncBrakes",v,Vehicle,Status)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:InsertBrakes")
AddEventHandler("engine:InsertBrakes",function(Vehicle,Brake)
	if Brake == "" then
		Brakes[Vehicle] = { 0.90, 0.55, 0.75 }
	else
		Brakes[Vehicle] = json.decode(Brake)

		if Brakes[Vehicle][1] > 0.90 then
			Brakes[Vehicle][1] = 0.90
		end

		if Brakes[Vehicle][2] > 0.55 then
			Brakes[Vehicle][2] = 0.55
		end

		if Brakes[Vehicle][3] > 0.75 then
			Brakes[Vehicle][3] = 0.75
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:APPLYBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:ApplyBrakes")
AddEventHandler("engine:ApplyBrakes", function(Item, Vehicle, Brake, PlayerAround)
	local Config = BrakesConfig[Item]
	if Config and Brakes[Vehicle] then
		local i = Config.Index
		Brakes[Vehicle][i] = math.min(Brakes[Vehicle][i] + (Brake * Config.Multiplier), Config.Max)

		for _, v in ipairs(PlayerAround) do
			async(function()
				TriggerClientEvent("engine:SyncBrakes", v, Vehicle, Brakes[Vehicle])
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:MAXBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:MaxBrakes")
AddEventHandler("engine:MaxBrakes", function(Vehicle, PlayerAround)
	if Brakes[Vehicle] then
		Brakes[Vehicle][1] = 0.90
		Brakes[Vehicle][2] = 0.55
		Brakes[Vehicle][3] = 0.75

		for _, v in ipairs(PlayerAround) do
			async(function()
				TriggerClientEvent("engine:SyncBrakes", v, Vehicle, Brakes[Vehicle])
			end)
		end
	end
end)