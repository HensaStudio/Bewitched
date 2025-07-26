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
Tunnel.bindInterface("player", Hensa)
vCLIENT = Tunnel.getInterface("player")
vSKINSHOP = Tunnel.getInterface("skinshop")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Recycled = {}
local DogTag = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RECYCLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Recycle")
AddEventHandler("player:Recycle",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Recycled[Passport] and not exports["hud"]:Reposed(Passport, source) and not exports["hud"]:Wanted(Passport, source) and vRP.Request(source,"Recicladora","Está apenas com itens que deseja reciclar em sua mochila?") then
		local Notify = false
		Recycled[Passport] = true
		local Inv = vRP.Inventory(Passport)

		for Slot = 1,5 do
			local Slot = tostring(Slot)
			if Inv[Slot] and Inv[Slot]["item"] and Inv[Slot]["amount"] > 0 then
				for Item,Amount in pairs(ItemRecycle(Inv[Slot]["item"])) do
					if vRP.TakeItem(Passport,Inv[Slot]["item"],Inv[Slot]["amount"],false,Slot) then
						vRP.GenerateItem(Passport,Item,Inv[Slot]["amount"] * Amount,true,Slot)
						Notify = true
					end
				end
			end
		end

		if Notify then
			TriggerClientEvent("Notify",source,"Recicladora","Processo concluído.","ilegal",5000)
		else
			TriggerClientEvent("Notify",source,"Recicladora","Nenhum item encontrado.","vermelho",5000)
		end

		Recycled[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:SURVIVAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Survival")
AddEventHandler("player:Survival",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.ClearInventory(Passport)
		vRP.UpgradeThirst(Passport,100)
		vRP.UpgradeHunger(Passport,100)
		vRP.DowngradeStress(Passport,100)
		exports["discord"]:Embed("Airport","**Source:** "..source.."\n**Passaporte:** "..Passport.."\n**Coords:** "..vRP.GetEntityCoords(source))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("me", function(source, Message, History)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] then
		if vRP.GetHealth(source) > 100 then
			local Message = string.sub(History:sub(4), 1, 100)

			local Players = vRPC.Players(source)
			for _, v in pairs(Players) do
				async(function()
					TriggerClientEvent("showme:pressMe", v, source, Message, 10)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DEMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Demand")
AddEventHandler("player:Demand",function(OtherSource)
	local source = source
	local Passport = vRP.Passport(source)
	local OtherPassport = vRP.Passport(OtherSource)
	if Passport and OtherPassport and not exports["bank"]:CheckFines(OtherPassport) then
		local Keyboard = vKEYBOARD.Primary(source,"Valor da Cobrança.")
		if Keyboard and vRP.Passport(OtherSource) then
			if vRP.Request(OtherSource,"Cobrança","Aceitar a cobrança de <b>"..Currency..""..Dotted(Keyboard[1]).."</b> feita por <b>"..vRP.FullName(Passport).."</b>.") then
				if vRP.PaymentBank(OtherPassport,Keyboard[1],true) then
					vRP.GiveBank(Passport,Keyboard[1],true)
				end
			else
				TriggerClientEvent("Notify",source,"Cobrança","Pedido recusado.","vermelho",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
local Debug = {}
RegisterServerEvent("player:Debug")
AddEventHandler("player:Debug",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Debug[Passport] or os.time() > Debug[Passport] then
		TriggerClientEvent("target:Debug",source)
		TriggerEvent("DebugObjects",Passport)
		Debug[Passport] = os.time() + 300
		vRPC.ReloadCharacter(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Stress")
AddEventHandler("player:Stress",function(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.DowngradeStress(Passport,Number)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		if Message[2] == "friend" then
			local ClosestPed = vRPC.ClosestPed(source)
			if ClosestPed and vRP.GetHealth(ClosestPed) > 100 and not Player(ClosestPed)["state"]["Handcuff"] then
				if vRP.Request(ClosestPed,"Animação","Pedido de <b>"..vRP.FullName(Passport).."</b> da animação <b>"..Message[1].."</b>?") then
					TriggerClientEvent("emotes",ClosestPed,Message[1])
					TriggerClientEvent("emotes",source,Message[1])
				end
			end
		else
			TriggerClientEvent("emotes",source,Message[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e2",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		local ClosestPed = vRPC.ClosestPed(source)
		if ClosestPed then
			if vRP.HasService(Passport,"Paramedico") then
				TriggerClientEvent("emotes",ClosestPed,Message[1])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E3
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e3",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		if vRP.HasGroup(Passport,"Admin",2) then
			local Players = vRPC.ClosestPeds(source,50)
			for _,v in pairs(Players) do
				async(function()
					TriggerClientEvent("emotes",v,Message[1])
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Doors")
AddEventHandler("player:Doors",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Vehicle,Network = vRPC.VehicleList(source)
		if Vehicle then
			local Players = vRPC.Players(source)
			for _,v in pairs(Players) do
				async(function()
					TriggerClientEvent("player:syncDoors",v,Network,Number)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CVFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:cvFunctions")
AddEventHandler("player:cvFunctions",function(Mode)
	local Distance = 1
	if Mode == "rv" then
		Distance = 10
	end

	local source = source
	local Passport = vRP.Passport(source)
	local OtherSource = vRPC.ClosestPed(source,Distance)
	if Passport and OtherSource then
		if vRP.HasService(Passport,"Emergencia") or vRP.ConsultItem(Passport,"rope",1) then
			local Vehicle,Network = vRPC.VehicleList(source)
			if Vehicle then
				local Networked = NetworkGetEntityFromNetworkId(Network)
				if DoesEntityExist(Networked) and GetVehicleDoorLockStatus(Networked) <= 1 then
					if Mode == "rv" then
						vCLIENT.RemoveVehicle(OtherSource)
					elseif Mode == "cv" then
						vCLIENT.PlaceVehicle(OtherSource,Network)
						TriggerEvent("inventory:CarryDetach",source,Passport)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Preset")
AddEventHandler("player:Preset",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasService(Passport,"Emergencia") and Presets[Number] then
		local Model = vRP.ModelPlayer(source)

		if Presets[Number][Model] then
			TriggerClientEvent("skinshop:Apply",source,Presets[Number][Model])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrunk")
AddEventHandler("player:checkTrunk",function()
	local source = source
	local ClosestPed = vRPC.ClosestPed(source)
	if ClosestPed then
		TriggerClientEvent("player:checkTrunk",ClosestPed)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrash")
AddEventHandler("player:checkTrash",function()
	local source = source
	local ClosestPed = vRPC.ClosestPed(source)
	if ClosestPed then
		TriggerClientEvent("player:checkTrash",ClosestPed)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKSHOES
-----------------------------------------------------------------------------------------------------------------------------------------
local UniqueShoes = {}
RegisterServerEvent("player:checkShoes")
AddEventHandler("player:checkShoes",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not UniqueShoes[Entity] then
			UniqueShoes[Entity] = os.time()
		end

		if os.time() >= UniqueShoes[Entity] and vSKINSHOP.checkShoes(Entity) then
			vRP.GenerateItem(Passport,"WEAPON_SHOES",2,true)
			UniqueShoes[Entity] = os.time() + 300
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVIT
-----------------------------------------------------------------------------------------------------------------------------------------
local Removit = {
	["mp_m_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 14, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 5, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 14, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 5, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:OUTFIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Outfit")
AddEventHandler("player:Outfit",function(Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports["hud"]:Reposed(Passport,source) and not exports["hud"]:Wanted(Passport,source) then
		if Mode == "aplicar" then
			local Result = vRP.GetServerData("Outfit:"..Passport)
			if Result["pants"] then
				TriggerClientEvent("skinshop:Apply",source,Result)
				TriggerClientEvent("Notify",source,"Sucesso","Roupas aplicadas.","verde",5000)
			else
				TriggerClientEvent("Notify",source,"Aviso","Roupas não encontradas.","amarelo",5000)
			end
		elseif Mode == "salvar" then
			local Custom = vSKINSHOP.Customization(source)
			if Custom then
				vRP.SetServerData("Outfit:"..Passport,Custom)
				TriggerClientEvent("Notify",source,"Sucesso","Roupas salvas.","verde",5000)
			end
		elseif Mode == "aplicarpre" then
			local Result = vRP.GetServerData("Premiumfit:"..Passport)
			if Result["pants"] then
				TriggerClientEvent("skinshop:Apply",source,Result)
				TriggerClientEvent("Notify",source,"Sucesso","Roupas aplicadas.","verde",5000)
			else
				TriggerClientEvent("Notify",source,"Aviso","Roupas não encontradas.","amarelo",5000)
			end
		elseif Mode == "salvarpre" then
			local Custom = vSKINSHOP.Customization(source)
			if Custom then
				vRP.SetServerData("Premiumfit:"..Passport,Custom)
				TriggerClientEvent("Notify",source,"Sucesso","Roupas salvas.","verde",5000)
			end
		elseif Mode == "remover" then
			local Model = vRP.ModelPlayer(source)

			if Removit[Model] then
				TriggerClientEvent("skinshop:Apply",source,Removit[Model])
			end
		else
			TriggerClientEvent("skinshop:set"..Mode,source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DEATH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Death")
AddEventHandler("player:Death", function(AttackerServerId, HashWeapons, IsHeadshot)
	local source = source
	local Passport = vRP.Passport(source)
	local OtherPassport = vRP.Passport(AttackerServerId)
	if Passport and OtherPassport and Passport ~= OtherPassport and vRP.DoesEntityExist(source) and vRP.DoesEntityExist(AttackerServerId) then
		local HeadShot = "Não"

		if IsHeadshot then
			HeadShot = "Sim"
		end

		exports["discord"]:Embed("Deaths","**[PASSAPORTE ASSASSINO]:** "..OtherPassport.."\n**[LOCALIAÇÃO ASSASSINO]:** "..vRP.GetEntityCoords(AttackerServerId).."\n\n**[PASSAPORTE VÍTIMA]:** "..Passport.."\n**[LOCALIZAÇÃO VÍTIMA]:** "..vRP.GetEntityCoords(source).."\n**[ARMA USADA]:** "..HashWeapons.."\n**[HEADSHOT]:** "..HeadShot.."\n**[DATA & HORA]:** "..os.date("%d/%m/%Y").." às "..os.date("%H:%M"))

		if DogTag then
			exports["inventory"]:Drops(Passport,source,"dogtag-"..Passport,1)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.WantedList()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Result = vRP.Query("characters/Wanted")
		if Result and #Result > 0 then
			return Result
		else
			TriggerClientEvent("Notify",source,"Lista de Procurados","A lista se encontra vázia.","policia",5000)
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:SEARCHWANTED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:SearchWanted")
AddEventHandler("player:SearchWanted",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Keyboard = vKEYBOARD.Primary(source,"Passaporte:")
		if Keyboard then
			local Identity = vRP.Identity(Keyboard[1])
			if Identity then
				if Identity["Wanted"] >= 1 then
					TriggerClientEvent("Notify",source,"Lista de Procurados","<b>"..Identity["Name"].." "..Identity["Lastname"].."</b> está com nível: <b>"..Identity["Wanted"].."</b>.","vermelho",5000)
				else
					TriggerClientEvent("Notify",source,"Lista de Procurados","<b>"..Identity["Name"].." "..Identity["Lastname"].."</b> está com a ficha limpa.","verde",5000)
				end
			else
				TriggerClientEvent("Notify",source,"Lista de Procurados","Nada encontrado com esse passaporte.","amarelo",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:LIKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Like")
AddEventHandler("player:Like",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local OtherPassport = vRP.Passport(Entity)
		local Identity = vRP.Identity(OtherPassport)
		if Identity then
			if vRP.TakeItem(Passport,"vote",1,true) then
				vRP.GiveLikes(OtherPassport,1)
			else
				TriggerClientEvent("Notify",source,"Atenção","Você precisa de <b>1x "..ItemName("vote").."</b>.","amarelo",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:UNLIKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:UnLike")
AddEventHandler("player:UnLike",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local OtherPassport = vRP.Passport(Entity)
		local Identity = vRP.Identity(OtherPassport)
		if Identity then
			if vRP.TakeItem(Passport,"vote",1,true) then
				vRP.GiveUnLikes(OtherPassport,1)
			else
				TriggerClientEvent("Notify",source,"Atenção","Você precisa de <b>1x "..ItemName("vote").."</b>.","amarelo",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.GetReputation(source)
	local Passport = vRP.Passport(source)
	if Passport then
		local Reputation = {
			[1] = vRP.GetLikes(Passport),
			[2] = vRP.GetUnLikes(Passport)
		}

		return Reputation
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("player:DuiTable",source,DuiTextures)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Debug[Passport] then
		Debug[Passport] = nil
	end

	if Recycled[Passport] then
		Recycled[Passport] = nil
	end
end)