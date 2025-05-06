-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Opened = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	if Opened then
		Opened = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Mount",function(Data,Callback)
	local Primary,PrimaryWeight = vSERVER.Mount(Opened)
	if Primary then
		Callback({ Primary = Primary, Secondary = ItemList[Opened], PrimaryMaxWeight = PrimaryWeight, SecondarySlots = (#ItemList[Opened] > 25 and #ItemList[Opened] or 25) })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Take(Data["item"],Data["amount"],Data["target"],Opened)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Store(Data["item"],Data["amount"],Data["target"],Opened)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("shops:Open",function(Number)
	if vSERVER.Check() then
		if Location[Number] then
			if Location[Number]["Service"] and vSERVER.HasService(Location[Number]["Service"]) then
				TriggerEvent("Notify","Atenção","Existem pessoas em serviço no momento, procure por um atendente.","amarelo",5000)
				return false
			end

			if vSERVER.Permission(Location[Number]["Mode"]) then
				Opened = Location[Number]["Mode"]

				TriggerEvent("inventory:Open",{
					Type = "Shops",
					Mode = List[Opened]["Mode"],
					Item = (List[Opened]["Item"] or DefaultMoneyOne),
					Resource = "shops"
				})

				if Location[Number]["Sound"] then
					TriggerEvent("sounds:Private","shop",0.5)
				end
			end
		else
			if vSERVER.Permission(Number) then
				Opened = Number

				TriggerEvent("inventory:Open",{
					Type = "Shops",
					Mode = List[Opened]["Mode"],
					Item = (List[Opened]["Item"] or DefaultMoneyOne),
					Resource = "shops"
				})
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Location) do
		if v["Circle"] then
			exports["target"]:AddCircleZone("Shops:"..Number,v["Coords"],v["Circle"],{
				name = "Shops:"..Number,
				heading = 0.0,
				useZ = true
			},{
				shop = Number,
				Distance = 2.0,
				options = {
					{
						event = "shops:Open",
						label = "Abrir",
						tunnel = "client"
					}
				}
			})
		elseif v["CityHall"] then
			exports["target"]:AddBoxZone("Shops:"..Number,v["Coords"],0.75,0.75,{
				name = "Shops:"..Number,
				heading = 0.0,
				minZ = v["Coords"]["z"] - 1.0,
				maxZ = v["Coords"]["z"] + 1.0
			},{
				shop = Number,
				Distance = 2.0,
				options = {
					{
						event = "shops:Open",
						label = "Comprar Passaporte",
						tunnel = "client"
					}, {
						event = "player:WantedList",
						label = "Lista de Procurados",
						tunnel = "client"
					}
				}
			})
		else
			exports["target"]:AddBoxZone("Shops:"..Number,v["Coords"],0.75,0.75,{
				name = "Shops:"..Number,
				heading = 0.0,
				minZ = v["Coords"]["z"] - 1.0,
				maxZ = v["Coords"]["z"] + 1.0
			},{
				shop = Number,
				Distance = 2.0,
				options = {
					{
						event = "shops:Open",
						label = "Abrir",
						tunnel = "client"
					}
				}
			})
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:CLANDESTINEWAYPOINT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shops:ClandestineWayPoint")
AddEventHandler("shops:ClandestineWayPoint", function()
	if CheckGang() then
		TriggerEvent("Notify","Sucesso","Você marcou o local da <b>Loja Clandestina</b>.","verde",5000)
		SetNewWaypoint(179.9,2779.98)
	else
		TriggerEvent("Notify","Atenção","Você não tem permissões para isso.","amarelo",5000)
	end
end)