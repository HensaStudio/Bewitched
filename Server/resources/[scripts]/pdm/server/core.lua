-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hensa = {}
Tunnel.bindInterface("pdm",Hensa)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local VehiclePlate = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
local Premium = {
	[1] = 25,
	[2] = 50,
	[3] = 100
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Check()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports["hud"]:Reposed(Passport, source) and not exports["hud"]:Wanted(Passport, source) then
		TriggerEvent("animals:Delete",Passport,source)

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Discount()
	return { 1.0, 1.0 }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Buy(Name)
	local Source = source
	local Passport = vRP.Passport(Source)

	if not Passport or Active[Passport] or not Name then return end
	Active[Passport] = true

	local Vehicle = vRP.Query("vehicles/selectVehicles", { Passport = Passport, Vehicle = Name })
	if Vehicle[1] then
		TriggerClientEvent("pdm:Close", Source)

		TriggerClientEvent("Notify", Source, "Aviso", "Já possui um <b>"..VehicleName(Name).."</b>.", "amarelo", 5000)
		Active[Passport] = nil
		return
	end

	local Result = vRP.Query("vehicles/Count", { Vehicle = Name })
	local StockLimit = VehicleStock(Name)
	local CurrentStock = Result[1] and Result[1]["COUNT(Vehicle)"] or 0

	if StockLimit and CurrentStock >= StockLimit then
		TriggerClientEvent("Notify", Source, "Aviso", "Estoque insuficiente.", "amarelo", 5000)
		Active[Passport] = nil
		return
	end

	TriggerClientEvent("pdm:Close", Source)

	if VehicleMode(Name) == "Rental" then
		local VehiclePrice = VehicleGemstone(Name)
		if vRP.PaymentGemstone(Passport, VehiclePrice) then
			local Plate = vRP.GeneratePlate()
			TriggerEvent("garages:Pdm", Passport, Source, Name, Plate)
			TriggerClientEvent("Notify", Source, "Sucesso", "Aluguel do veículo <b>"..VehicleName(Name).."</b> concluído.", "verde", 5000)
			vRP.Query("vehicles/rentalVehicles", { Passport = Passport, Vehicle = Name, Plate = Plate, Weight = VehicleWeight(Name), Work = "false" })
		else
			TriggerClientEvent("Notify", Source, "Aviso", "<b>Diamantes</b> insuficientes.", "amarelo", 5000)
		end

	elseif VehicleClass(Name) == "Exclusivos" then
		local VehiclePrice = VehicleGemstone(Name)
		if vRP.TakeItem(Passport, "platinum", VehiclePrice) then
			local Plate = vRP.GeneratePlate()
			TriggerEvent("garages:Pdm", Passport, Source, Name, Plate)
			TriggerClientEvent("Notify", Source, "Sucesso", "Aluguel do veículo <b>"..VehicleName(Name).."</b> concluído.", "verde", 5000)
			vRP.Query("vehicles/rentalVehicles", { Passport = Passport, Vehicle = Name, Plate = Plate, Weight = VehicleWeight(Name), Work = "false" })
		else
			TriggerClientEvent("Notify", Source, "Aviso", "<b>"..ItemName("platinum").."</b> insuficiente.", "vermelho", 5000)
		end

	elseif not exports["bank"]:CheckFines(Passport) then
		local VehiclePrice = VehiclePrice(Name)
		if vRP.PaymentFull(Passport, VehiclePrice) then
			local Plate = vRP.GeneratePlate()
			TriggerEvent("garages:Pdm", Passport, Source, Name, Plate)
			TriggerClientEvent("Notify", Source, "Sucesso", "Compra concluída.", "verde", 5000)
			exports["bank"]:AddTaxs(Passport, Source, "Concessionária", VehiclePrice, "Compra do veículo "..VehicleName(Name)..".")
			vRP.Query("vehicles/addVehicles", { Passport = Passport, Vehicle = Name, Plate = Plate, Weight = VehicleWeight(Name), Work = "false" })
		else
			TriggerClientEvent("Notify", Source, "Aviso", "<b>"..ItemName(DefaultMoneyOne).."</b> insuficientes.", "vermelho", 5000)
		end

	else
		TriggerClientEvent("Notify", Source, "Aviso", "Você possui débitos bancários.", "amarelo", 5000)
	end

	Active[Passport] = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANTRY
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.CanTry()
	local Return = false
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		local Price = 250
		if vRP.UserPremium(Passport) then
			Price = Premium[vRP.GetUserHierarchy(Passport, "Premium")]
		end

		if vRP.PaymentFull(Passport,Price) then
			VehiclePlate[Passport] = "PDMSPORT"
			TriggerEvent("PlateEveryone", VehiclePlate[Passport])

			exports["vrp"]:Bucket(source, "Enter", Passport)

			Return = true
		else
			TriggerClientEvent("Notify",source,"Aviso","<b>"..ItemName(DefaultMoneyOne).."</b> insuficientes.","vermelho",5000)
		end

		Active[Passport] = nil
	end

	return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Remove()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerEvent("PlateReveryone", VehiclePlate[Passport])

		exports["vrp"]:Bucket(source, "Exit")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Active[Passport] then
		Active[Passport] = nil
	end

	if VehiclePlate[Passport] then
		VehiclePlate[Passport] = nil
	end
end)