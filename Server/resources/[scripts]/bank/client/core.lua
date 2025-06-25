-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("bank")-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Amounts = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Peds = { "s_m_m_security_01" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATION
-----------------------------------------------------------------------------------------------------------------------------------------
local Location = {
	vec3(149.64, -1041.36, 29.59),
	vec3(313.95, -279.74, 54.39),
	vec3(-351.2, -50.57, 49.26),
	vec3(-2961.85, 482.87, 15.92),
	vec3(1175.09, 2707.53, 38.31),
	vec3(-1212.37, -331.37, 38.0),
	vec3(-112.86, 6470.46, 31.85)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADLOCATION
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(AtmList) do
		exports["target"]:AddCircleZone("Atm:"..Number,v,0.5,{
			name = "Atm:"..Number,
			heading = 0.0
		}, {
			Distance = 1.75,
			options = {
				{
					event = "bank:Open",
					label = "Abrir",
					tunnel = "products",
					service = Number
				}, {
					event = "bank:ExplodeAtm",
					label = "Roubar",
					tunnel = "proserver",
					service = Number
				}, {
					event = "bank:Sabotage",
					label = "Sabotar",
					tunnel = "proserver",
					service = Number
				}, {
					event = "bank:Disarm",
					label = "Verificar",
					tunnel = "proserver",
					service = Number
				}, {
					event = "bank:ChangePassword",
					label = "Atualizar senha",
					tunnel = "server"
				}
			}
		})
	end

	for Number,v in pairs(Location) do
		exports["target"]:AddCircleZone("Bank:"..Number,v,0.1,{
			name = "Bank:"..Number,
			heading = 0.0,
			useZ = true
		},{
			Distance = 1.75,
			options = {
				{
					event = "bank:Open",
					label = "Abrir",
					tunnel = "products",
					service = Number
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("bank:Open",function(Number)
	if vSERVER.Check(Number) then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		TriggerEvent("hud:Active",false)
		SendNUIMessage({ Action = "Open", name = LocalPlayer["state"]["Name"] })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data, Callback)
	SetNuiFocus(false,false)
	TransitionFromBlurred(1000)
	TriggerEvent("hud:Active",true)
	SendNUIMessage({ Action = "Hide" })

	Callback(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Home", function(Data, Callback)
	Callback(vSERVER.Home())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Deposit", function(Data, Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.Deposit(Data["value"]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Withdraw", function(Data, Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.Withdraw(Data["value"]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Transfer", function(Data, Callback)
	if Data["targetId"] and Data["value"] and MumbleIsConnected() then
		Callback(vSERVER.Transfer(Data["targetId"], Data["value"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Investments", function(Data, Callback)
	Callback(vSERVER.Investments())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Invest", function(Data, Callback)
	if Data["value"] and MumbleIsConnected() then
		Callback(vSERVER.Invest(Data["value"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTRESCUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvestRescue", function(Data, Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.InvestRescue())
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONHISTORY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("TransactionHistory", function(Data, Callback)
	Callback(vSERVER.TransactionHistory())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEINVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("MakeInvoice", function(Data, Callback)
	if Data["passport"] and Data["value"] and Data["reason"] and MumbleIsConnected() then
		Callback(vSERVER.MakeInvoice(Data["passport"], Data["value"], Data["reason"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICEPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvoicePayment", function(Data, Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.InvoicePayment(Data["id"]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvoiceList", function(Data, Callback)
	Callback(vSERVER.InvoiceList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FineList", function(Data, Callback)
	Callback(vSERVER.FineList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINEPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FinePayment", function(Data, Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.FinePayment(Data["id"]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINEPAYMENTALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FinePaymentAll", function(Data, Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.FinePaymentAll())
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Taxes", function(Data, Callback)
	Callback(vSERVER.TaxList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("TaxPayment", function(Data, Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.TaxPayment(Data["id"]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK:SPAWNSECURITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("bank:SpawnSecurity")
AddEventHandler("bank:SpawnSecurity",function()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)

	for Number = 1,Amounts do
		local Cooldown = 0
		local OtherPeds = math.random(#Peds)
		local SpawnX = Coords["x"] + math.random(-20,20)
		local SpawnY = Coords["y"] + math.random(-20,20)
		local HitZ,GroundZ = GetGroundZFor_3dCoord(SpawnX,SpawnY,Coords["z"],true)
		local HitSafe,SafeCoords = GetSafeCoordForPed(SpawnX,SpawnY,GroundZ,false,16)

		repeat
			Cooldown = Cooldown + 1
			SpawnX = Coords["x"] + math.random(-20,20)
			SpawnY = Coords["y"] + math.random(-20,20)
			HitZ,GroundZ = GetGroundZFor_3dCoord(SpawnX,SpawnY,Coords["z"],true)
			HitSafe,SafeCoords = GetSafeCoordForPed(SpawnX,SpawnY,GroundZ,false,16)
		until (HitZ and HitSafe) or Cooldown >= 100

		if HitZ and HitSafe then
			local Network = vRPS.CreateModels(Peds[OtherPeds],SafeCoords["x"],SafeCoords["y"],SafeCoords["z"])
			if Network then
				SetTimeout(2500,function()
					local Entity = LoadNetwork(Network)
					if Entity then
						SetPedAccuracy(Entity,75)
						SetPedAlertness(Entity,3)
						SetPedAsEnemy(Entity,true)
						SetPedMaxHealth(Entity,200)
						SetEntityHealth(Entity,200)
						SetPedKeepTask(Entity,true)
						SetPedCombatRange(Entity,2)
						StopPedSpeaking(Entity,true)
						SetPedCombatMovement(Entity,2)
						DisablePedPainAudio(Entity,true)
						SetPedPathAvoidFire(Entity,true)
						SetPedConfigFlag(Entity,208,true)
						SetPedSeeingRange(Entity,10000.0)
						SetPedCanEvasiveDive(Entity,false)
						SetPedHearingRange(Entity,10000.0)
						SetPedDiesWhenInjured(Entity,false)
						SetPedPathCanUseLadders(Entity,true)
						SetPedFleeAttributes(Entity,0,false)
						SetPedCombatAttributes(Entity,46,true)
						SetPedFiringPattern(Entity,0xC6EE6B4C)
						SetCanAttackFriendly(Entity,true,false)
						SetPedSuffersCriticalHits(Entity,false)
						SetPedPathCanUseClimbovers(Entity,true)
						SetPedDropsWeaponsWhenDead(Entity,false)
						SetPedEnableWeaponBlocking(Entity,false)
						SetPedPathCanDropFromHeight(Entity,false)
						RegisterHatedTargetsAroundPed(Entity,100.0)
						GiveWeaponToPed(Entity,"WEAPON_PISTOL_MK2",-1,false,true)
						SetCurrentPedWeapon(Entity,"WEAPON_PISTOL_MK2",true)
						SetPedInfiniteAmmo(Entity,true,"WEAPON_PISTOL_MK2")
						SetPedRelationshipGroupHash(Entity,GetHashKey("HATES_PLAYER"))
						SetEntityCanBeDamagedByRelationshipGroup(Entity,false,"HATES_PLAYER")
						SetRelationshipBetweenGroups(5,GetHashKey("HATES_PLAYER"),GetHashKey("PLAYER"))
						SetRelationshipBetweenGroups(5,GetHashKey("PLAYER"),GetHashKey("HATES_PLAYER"))
						TaskCombatPed(Entity,Ped,0,16)

						SetTimeout(1000,function()
							TaskWanderInArea(Entity,SafeCoords["x"],SafeCoords["y"],SafeCoords["z"],25.0,0.0,0.0)
							SetModelAsNoLongerNeeded(Peds[OtherPeds])
						end)
					end
				end)
			end
		end
	end
end)