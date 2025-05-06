-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hensa = {}
Tunnel.bindInterface("paramedic", Hensa)
vSERVER = Tunnel.getInterface("paramedic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Damaged = {}
local Bleedings = 0
local Injuried = GetGameTimer()
local BloodTimers = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(Event,Message)
	if Event ~= "CEventNetworkEntityDamage" or PlayerPedId() ~= Message[1] then
		return
	end

	if (Message[7] == 126349499 or Message[7] == 1064738331 or Message[7] == 85055149) and GetEntityHealth(Message[1]) > 100 then
		SetPedToRagdoll(Message[1],2500,2500,0,0,0,0)
	else
		if GetGameTimer() >= Injuried and not IsPedInAnyVehicle(Message[1]) and GetEntityHealth(Message[1]) > 100 then
			Injuried = GetGameTimer() + 1000

			local Hit,Mark = GetPedLastDamageBone(Message[1])
			if Hit and not Damaged[Mark] and Mark ~= 0 then
				TriggerServerEvent("evidence:Drop", "Yellow")
				ClearPedBloodDamage(Message[1])
				Bleedings = Bleedings + 1
				Damaged[Mark] = true

				if Bleedings >= 5 then
					Bleedings = 5
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLOODTICK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if Bleedings >= 1 and GetGameTimer() >= BloodTimers and GetEntityHealth(Ped) > 100 then
			TriggerEvent("Notify","Saúde","Você está com sangramento.","blood",5000)
			BloodTimers = GetGameTimer() + 30000
			ApplyDamageToPed(Ped,1,false)
			ClearPedBloodDamage(Ped)
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:RESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("paramedic:Reset")
AddEventHandler("paramedic:Reset", function()
	Damaged = {}
	Bleedings = 0
	Injuried = GetGameTimer()
	BloodTimers = GetGameTimer()
	ClearPedBloodDamage(PlayerPedId())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLEEDING
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Bleeding()
	return Bleedings
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANDAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Bandage()
	local Humanes = ""
	for Number,_ in pairs(Damaged) do
		TriggerEvent("Notify","Saúde","Passou ataduras no(a) <b>"..Bone(Number).."</b>.","blood",5000)
		TriggerEvent("sounds:Private","bandage",0.5)
		Bleedings = Bleedings - 1
		Humanes = Bone(Number)
		Damaged[Number] = nil

		break
	end

	ClearPedBloodDamage(PlayerPedId())

	return Humanes
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OXYCONTIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Oxycontin()
	Damaged = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:INJURIES
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("paramedic:Injuries",function()
	local Ticks = 0
	local Injuries = ""

	for Number,_ in pairs(Damaged) do
		Ticks = Ticks + 1
		Injuries = Injuries.."<b>"..Ticks.."</b>: "..Bone(Number).."<br>"
	end

	if Injuries == "" then
		TriggerEvent("Notify","Saúde","Nenhum ferimento encontrado.","blood",5000)
	else
		TriggerEvent("Notify","Ferimentos",Injuries,"blood",10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Diagnostic()
	return Damaged,Bleedings
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:CLANDESTINEWAYPOINT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("paramedic:ClandestineWayPoint")
AddEventHandler("paramedic:ClandestineWayPoint", function()
	if CheckGang() then
		TriggerEvent("Notify","Hospital Clandestino","Você marcou o local.","hospital",5000)
		SetNewWaypoint(-471.17,6287.35)
	else
		TriggerEvent("Notify","Atenção","Você não tem permissões para isso.","amarelo",5000)
	end
end)