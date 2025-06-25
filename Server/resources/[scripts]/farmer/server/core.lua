-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
for Number = 1,#Objects do
	GlobalState["Farmer:"..Number] = 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Minerman")
AddEventHandler("farmer:Minerman",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		if not Number or type(Number) ~= "number" then
			exports["discord"]:Embed("Hackers","**Passaporte:** "..Passport.."\n**Função:** Payment do Farmer")
		end

		if GlobalState["Farmer:"..Number] and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
			local Item = "pickaxe"
			local Pickaxe = vRP.ConsultItem(Passport,Item,1)
			local PickaxePlus = vRP.ConsultItem(Passport,Item.."plus",1)

			if not Pickaxe and not PickaxePlus then
				TriggerClientEvent("Notify",source,"Atenção","Precisa de <b>1x "..ItemName(Item).."</b>.","amarelo",5000)
			else
				Player(source)["state"]["Cancel"] = true
				Player(source)["state"]["Buttons"] = true
				vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)

				if vRP.Task(source,Pickaxe and 10 or 6,20000) and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
					GlobalState["Farmer:"..Number] = GlobalState["Work"] + 60

					local Result = {
						{ ["Item"] = "tin_pure", ["Chance"] = 125, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "lead_pure", ["Chance"] = 125, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "copper_pure", ["Chance"] = 100, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "iron_pure", ["Chance"] = 75, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "gold_pure", ["Chance"] = 75, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "diamond_pure", ["Chance"] = 25, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "ruby_pure", ["Chance"] = 25, ["Min"] = 1, ["Max"] = 1 }
					}

					if PickaxePlus then
						Result = {
							{ ["Item"] = "tin_pure", ["Chance"] = 125, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "lead_pure", ["Chance"] = 125, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "copper_pure", ["Chance"] = 100, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "iron_pure", ["Chance"] = 75, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "gold_pure", ["Chance"] = 75, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "diamond_pure", ["Chance"] = 25, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "ruby_pure", ["Chance"] = 25, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "sapphire_pure", ["Chance"] = 15, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "emerald_pure", ["Chance"] = 10, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "chalcopyrite", ["Chance"] = 1, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "bauxite", ["Chance"] = 1, ["Min"] = 1, ["Max"] = 1 }
						}
					end

					local Consult = RandPercentage(Result)

					if exports["party"]:DoesExist(Passport,2) then
						Consult["Valuation"] = Consult["Valuation"] + (Consult["Valuation"] * 0.5)

						TriggerClientEvent("Notify",source,"Central de Empregos","Você ganhou uma bonificação por estar em um <b>Grupo</b>.","money",5000)
					end

					if exports["inventory"]:Buffs("Luck",Passport) then
						Consult["Valuation"] = Consult["Valuation"] + (Consult["Valuation"] * 0.5)
					end

					if vRP.UserPremium(Passport) then
						Consult["Valuation"] = Consult["Valuation"] + (Consult["Valuation"] * 0.5)
					end

					if vRP.CheckWeight(Passport,Consult["Item"],Consult["Valuation"]) then
						vRP.GenerateItem(Passport,Consult["Item"],Consult["Valuation"],true)
					else
						TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","roxo",5000)
						exports["inventory"]:Drops(Passport,source,Consult["Item"],Consult["Valuation"])
					end

					vRP.UpgradeStress(Passport,1)
				end

				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Cancel"] = false
				vRPC.Destroy(source)
			end
		end

		Active[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUMBERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Lumberman")
AddEventHandler("farmer:Lumberman",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		if not Number or type(Number) ~= "number" then
			exports["discord"]:Embed("Hackers","**Passaporte:** "..Passport.."\n**Função:** Payment do Farmer")
		end

		if GlobalState["Farmer:"..Number] and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
			local Item = "axe"
			local Axe = vRP.ConsultItem(Passport,Item,1)
			local AxePlus = vRP.ConsultItem(Passport,Item.."plus",1)

			if not Axe and not AxePlus then
				TriggerClientEvent("Notify",source,"Atenção","Precisa de <b>1x "..ItemName(Item).."</b>.","amarelo",5000)
			else
				Player(source)["state"]["Cancel"] = true
				Player(source)["state"]["Buttons"] = true
				vRPC.PlayAnim(source,false,{"lumberjackaxe@idle","idle"},true)

				if vRP.Task(source,Axe and 10 or 6,20000) and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
					GlobalState["Farmer:"..Number] = GlobalState["Work"] + 30

					local Valuation = 3

					if exports["party"]:DoesExist(Passport,2) then
						Valuation = Valuation + (Valuation * 0.25)

						TriggerClientEvent("Notify",source,"Central de Empregos","Você ganhou uma bonificação por estar em um <b>Grupo</b>.","money",5000)
					end

					if exports["inventory"]:Buffs("Luck",Passport) then
						Valuation = Valuation + (Valuation * 0.25)
					end

					if vRP.UserPremium(Passport) then
						Valuation = Valuation + (Valuation * 0.25)
					end

					if vRP.CheckWeight(Passport,"woodlog",Valuation) then
						vRP.GenerateItem(Passport,"woodlog",Valuation,true)
					else
						TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","roxo",5000)
						exports["inventory"]:Drops(Passport,source,"woodlog",Valuation)
					end

					vRP.UpgradeStress(Passport,1)
				end

				TriggerClientEvent("inventory:Provisory",source,false)
				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Cancel"] = false
				vRPC.Destroy(source)
			end
		end

		Active[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSPORTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Transporter")
AddEventHandler("farmer:Transporter",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		if not Number or type(Number) ~= "number" then
			exports["discord"]:Embed("Hackers","**Passaporte:** "..Passport.."\n**Função:** Payment do Farmer")
		end

		if GlobalState["Farmer:"..Number] and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
			Player(source)["state"]["Cancel"] = true
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("Progress",source,"Coletando",1000)
			vRPC.PlayAnim(source,false,{"pickup_object","pickup_low"},true)

			SetTimeout(1000,function()
				if GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
					GlobalState["Farmer:"..Number] = GlobalState["Work"] + 18

					local Valuation = 1
					if exports["inventory"]:Buffs("Luck",Passport) then
						Valuation = Valuation + 1
					end

					if vRP.CheckWeight(Passport,"pouch",Valuation) then
						vRP.GenerateItem(Passport,"pouch",Valuation,true)
					else
						TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","roxo",5000)
						exports["inventory"]:Drops(Passport,source,"pouch",Valuation)
					end

					vRP.UpgradeStress(Passport,1)
				end

				vRPC.Destroy(source)
			end)

			Player(source)["state"]["Buttons"] = false
			Player(source)["state"]["Cancel"] = false
		end

		Active[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SANDMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Sandman")
AddEventHandler("farmer:Sandman",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		if not Number or type(Number) ~= "number" then
			exports["discord"]:Embed("Hackers","**Passaporte:** "..Passport.."\n**Função:** Payment do Farmer")
		end

		if GlobalState["Farmer:"..Number] and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
			Player(source)["state"]["Cancel"] = true
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("Progress",source,"Coletando",1700)
			vRPC.PlayAnim(source,false,{"pickup_object","pickup_low"},true)

			SetTimeout(1700,function()
				if GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
					GlobalState["Farmer:"..Number] = GlobalState["Work"] + 30

					local Valuation = 1
					if exports["inventory"]:Buffs("Luck",Passport) then
						Valuation = Valuation + 1
					end

					if vRP.CheckWeight(Passport,"sand",Valuation) then
						vRP.GenerateItem(Passport,"sand",Valuation,true)
					else
						TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","roxo",5000)
						exports["inventory"]:Drops(Passport,source,"sand",Valuation)
					end

					vRP.UpgradeStress(Passport,1)
				end

				vRPC.Destroy(source)
			end)

			Player(source)["state"]["Buttons"] = false
			Player(source)["state"]["Cancel"] = false
		end

		Active[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRASHITENS
-----------------------------------------------------------------------------------------------------------------------------------------
TrashItens = {
	{ ["Item"] = "plastic", ["Chance"] = 100, ["Min"] = 6, ["Max"] = 10 },
	{ ["Item"] = "glass", ["Chance"] = 100, ["Min"] = 6, ["Max"] = 10 },
	{ ["Item"] = "rubber", ["Chance"] = 100, ["Min"] = 6, ["Max"] = 10 },
	{ ["Item"] = "aluminum", ["Chance"] = 50, ["Min"] = 4, ["Max"] = 8 },
	{ ["Item"] = "copper", ["Chance"] = 50, ["Min"] = 4, ["Max"] = 8 },
	{ ["Item"] = "techtrash", ["Chance"] = 5, ["Min"] = 1, ["Max"] = 2 },
	{ ["Item"] = "tarp", ["Chance"] = 7, ["Min"] = 1, ["Max"] = 2 },
	{ ["Item"] = "sheetmetal", ["Chance"] = 5, ["Min"] = 1, ["Max"] = 2 },
	{ ["Item"] = "roadsigns", ["Chance"] = 5, ["Min"] = 1, ["Max"] = 2 },
	{ ["Item"] = "scotchtape", ["Chance"] = 3, ["Min"] = 1, ["Max"] = 2 },
	{ ["Item"] = "insulatingtape", ["Chance"] = 3, ["Min"] = 1, ["Max"] = 2 },
	{ ["Item"] = "electroniccomponents", ["Chance"] = 3, ["Min"] = 1, ["Max"] = 2 },
	{ ["Item"] = "batteryaa", ["Chance"] = 5, ["Min"] = 1, ["Max"] = 2 },
	{ ["Item"] = "batteryaaplus", ["Chance"] = 5, ["Min"] = 1, ["Max"] = 2 },
	{ ["Item"] = "emptybottle", ["Chance"] = 25, ["Min"] = 3, ["Max"] = 4 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRASHER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Trasher")
AddEventHandler("farmer:Trasher",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		if not vRPC.LastVehicle(source,"trash") then
			TriggerClientEvent("Notify",source,"Atenção","Necessário a utilização do veículo <b>"..VehicleName("trash").."</b>.","amarelo",5000)
			Active[Passport] = nil

			return false
		end

		if not Number or type(Number) ~= "number" then
			exports["discord"]:Embed("Hackers","**Passaporte:** "..Passport.."\n**Função:** Payment do Farmer")
		end

		if GlobalState["Farmer:"..Number] and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
			Player(source)["state"]["Cancel"] = true
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("Progress",source,"Coletando",1700)
			vRPC.PlayAnim(source,false,{"pickup_object","pickup_low"},true)

			SetTimeout(1700,function()
				if GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
					GlobalState["Farmer:"..Number] = GlobalState["Work"] + 30

					local GainExperience = 1
					local Experience = vRP.GetExperience(Passport,"Garbageman")

					local Valuation = math.random(65,95)
					if exports["inventory"]:Buffs("Luck",Passport) then
						Valuation = Valuation + 15
						GainExperience = GainExperience + 1
					end

					vRP.GenerateItem(Passport, "dollar", Valuation, true)

					local Result = RandPercentage(TrashItens)
					local Quantity = math.random(Result["Min"], Result["Max"])
					if not vRP.MaxItens(Passport, Result["Item"], Quantity) and vRP.CheckWeight(Passport, Result["Item"], Quantity) then
						vRP.GenerateItem(Passport, Result["Item"], Quantity,true)
					else
						TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","roxo",5000)
						exports["inventory"]:Drops(Passport, source, Result["Item"], Quantity)
					end

					vRP.PutExperience(Passport,"Garbageman",GainExperience)

					vRP.UpgradeStress(Passport,1)
				end

				vRPC.Destroy(source)
			end)

			Player(source)["state"]["Buttons"] = false
			Player(source)["state"]["Cancel"] = false
		end

		Active[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)