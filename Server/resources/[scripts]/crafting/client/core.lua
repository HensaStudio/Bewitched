-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("crafting")
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
		Callback({ Primary = Primary, Secondary = ItemList[Opened], PrimaryMaxWeight = PrimaryWeight, SecondarySlots = (#ItemList[Opened] > 20 and #ItemList[Opened] or 20) })
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
-- CRAFTING:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("crafting:Open",function(Number)
	if vSERVER.Check() then
		if Location[Number] then
			if vSERVER.Permission(Location[Number]["Mode"]) then
				Opened = Location[Number]["Mode"]

				TriggerEvent("inventory:Open",{
					Type = "Shops",
					Mode = "Buy",
					Resource = "crafting"
				})
			end
		else
			if vSERVER.Permission(Number) then
				Opened = Number

				TriggerEvent("inventory:Open",{
					Type = "Shops",
					Mode = "Buy",
					Resource = "crafting"
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
		if v["Gang"] then
			exports["target"]:AddCircleZone("Crafting:"..Number,v["Coords"],v["Circle"],{
				name = "Crafting:"..Number,
				heading = 0.0,
				useZ = true
			},{
				shop = Number,
				Distance = 2.0,
				options = {
					{
						event = "crafting:Open",
						label = "Criações",
						tunnel = "client"
					}, {
						event = "shops:ClandestineWayPoint",
						label = "Loja Clandestina",
						tunnel = "client"
					}, {
						event = "deliver:MaterialsWayPoint",
						label = "Coleta de Materiais",
						tunnel = "client"
					}
				}
			})
		else
			exports["target"]:AddCircleZone("Crafting:"..Number,v["Coords"],v["Circle"],{
				name = "Crafting:"..Number,
				heading = 0.0,
				useZ = true
			},{
				shop = Number,
				Distance = 2.0,
				options = {
					{
						event = "crafting:Open",
						label = "Abrir",
						tunnel = "client"
					}
				}
			})
		end
	end
end)