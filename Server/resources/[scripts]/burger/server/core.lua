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
Tunnel.bindInterface("burger",Hensa)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Drugs = {}
local Active = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BURGER:PACKAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("burger:Package")
AddEventHandler("burger:Package", function()
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport or Active[Passport] then return end

	if not vRP.ConsultItem(Passport,NeedJuiceItem,1) then
		return TriggerClientEvent("Notify",source,"Atenção","Você precisa de 1x "..ItemName(NeedJuiceItem)..".","amarelo",5000)
	end

	if not vRP.ConsultItem(Passport,NeedBurgerItem,1) then
		return TriggerClientEvent("Notify",source,"Atenção","Você precisa de 1x "..ItemName(NeedBurgerItem)..".","amarelo",5000)
	end

	if not vRP.CheckWeight(Passport,Item,1) then
		TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","roxo",5000)
		return exports["inventory"]:Drops(Passport,source,Item,1)
	end

	vRP.RemoveItem(Passport,NeedJuiceItem,1,false)
	vRP.RemoveItem(Passport,NeedBurgerItem,1,false)
	vRP.GenerateItem(Passport,Item,1,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	["cocaine"] = {
		["Timer"] = 15,
		["Percentage"] = 900,
		["Price"] = { ["Min"] = 75, ["Max"] = 100 },
		["Amount"] = { ["Min"] = 2, ["Max"] = 4 }
	},
	["meth"] = {
		["Timer"] = 15,
		["Percentage"] = 900,
		["Price"] = { ["Min"] = 75, ["Max"] = 100 },
		["Amount"] = { ["Min"] = 2, ["Max"] = 4 }
	},
	["joint"] = {
		["Timer"] = 15,
		["Percentage"] = 900,
		["Price"] = { ["Min"] = 75, ["Max"] = 100 },
		["Amount"] = { ["Min"] = 2, ["Max"] = 4 }
	},
	["cokesack"] = {
		["Timer"] = 30,
		["Percentage"] = 725,
		["Price"] = { ["Min"] = 500, ["Max"] = 625 },
		["Amount"] = { ["Min"] = 1, ["Max"] = 1 }
	},
	["methsack"] = {
		["Timer"] = 30,
		["Percentage"] = 725,
		["Price"] = { ["Min"] = 500, ["Max"] = 625 },
		["Amount"] = { ["Min"] = 1, ["Max"] = 1 }
	},
	["weedsack"] = {
		["Timer"] = 30,
		["Percentage"] = 725,
		["Price"] = { ["Min"] = 500, ["Max"] = 625 },
		["Amount"] = { ["Min"] = 1, ["Max"] = 1 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDRUGS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.CheckDrugs()
	local Return = false
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		for Item,v in pairs(List) do
			local Price = math.random(v["Price"]["Min"],v["Price"]["Max"])
			local Amount = math.random(v["Amount"]["Min"],v["Amount"]["Max"])

			if vRP.ConsultItem(Passport,Item,Amount) then
				TriggerClientEvent("Notify",source,"Atenção","Você possui itens ilícitos na mochila e irá vendê-los junto com a entrega.","amarelo",5000)
				Drugs[Passport] = { Item,Amount,Price * Amount,v["Percentage"] }
				Return = v["Timer"]

				break
			end
		end
	end

	return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Payment(Selected)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		if not vRPC.LastVehicle(source,Model) then
			TriggerClientEvent("Notify",source,"Atenção","Precisa utilizar o veículo do <b>BurgerShot</b>.","amarelo",5000)

			return false
		end

		if vRP.TakeItem(Passport,Item,1,true) then
			Active[Passport] = true

			local Coords = vRP.GetEntityCoords(source)
			if not Selected or #(Coords - Locations[Selected]) > 2.5 then
				exports["discord"]:Embed("Hackers","**Passaporte:** "..Passport.."\n**Função:** Payment do Burger",source)
			end

			local GainExperience = 3
			local Amount = math.random(175,275)
			local Experience = vRP.GetExperience(Passport,"BurgerShot")
			local Valuation = Amount + Amount * (0.05 * Experience)

			if exports["inventory"]:Buffs("Dexterity",Passport) then
				Valuation = Valuation + (Valuation * 0.1)
			end

			if vRP.UserPremium(Passport) then
				local Bonification = 0.05
				local Hierarchy = vRP.LevelPremium(Passport)

				if Hierarchy == 1 then
					Bonification = 0.100
				elseif Hierarchy == 2 then
					Bonification = 0.075
				end

				GainExperience = GainExperience + 2
				Valuation = Valuation + (Valuation * Bonification)
			end

			vRP.GenerateItem(Passport,DefaultMoneyOne,Valuation,true)
			vRP.PutExperience(Passport,"BurgerShot",GainExperience)
			vRP.UpgradeStress(Passport,3)

			if Drugs[Passport] and vRP.TakeItem(Passport,Drugs[Passport][1],Drugs[Passport][2]) then
				local GainExperience = 2
				local Amount = Drugs[Passport][3]
				local Experience = vRP.GetExperience(Passport,"Traffic")
				local Valuation = Amount + Amount * (0.05 * Experience)

				if exports["inventory"]:Buffs("Dexterity",Passport) then
					Valuation = Valuation + (Valuation * 0.1)
				end

				if vRP.UserPremium(Passport) then
					local Bonification = 0.050
					local Hierarchy = vRP.LevelPremium(Passport)

					if Hierarchy == 1 then
						Bonification = 0.100
					elseif Hierarchy == 2 then
						Bonification = 0.075
					end

					GainExperience = GainExperience + 1
					Valuation = Valuation + (Valuation * Bonification)
				end

				TriggerClientEvent("player:Residual",source,"Resíduo de Orgânicos")
				vRP.GenerateItem(Passport,DefaultMoneyTwo,Valuation,true)
				vRP.GenerateItem(Passport,"vote",math.random(2),true)
				vRP.PutExperience(Passport,"Traffic",GainExperience)
				vRP.UpgradeStress(Passport,1)

				exports["vrp"]:CallPolice({
					["Source"] = source,
					["Passport"] = Passport,
					["Permission"] = "Policia",
					["Name"] = "Venda de Drogas",
					["Percentage"] = Drugs[Passport][4],
					["Marker"] = 30,
					["Wanted"] = 60,
					["Code"] = 20,
					["Color"] = 16
				})
			end

			Active[Passport] = nil
			Drugs[Passport] = nil

			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Active[Passport] then
		Active[Passport] = nil
	end

	if Drugs[Passport] then
		Drugs[Passport] = nil
	end
end)