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
Hensa = {}
Tunnel.bindInterface("inventory",Hensa)
vGARAGE = Tunnel.getInterface("garages")
vSERVER = Tunnel.getInterface("inventory")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Types = ""
Actived = false
local Swimming = false
local ShotDelay = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLOCKBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if LocalPlayer["state"]["Buttons"] then
			DisableControlAction(0,257,true)
			DisableControlAction(0,75,true)
			DisableControlAction(0,47,true)
			DisablePlayerFiring(Ped,true)

			TimeDistance = 1
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLEARNER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:Cleaner",function(Ped)
	TriggerEvent("hud:Weapon",false)
	RemoveAllPedWeapons(Ped,true)
	TriggerEvent("Weapon","")
	Actived = false
	Weapon = ""
	Types = ""
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REPAIRBOOSTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:RepairBoosts")
AddEventHandler("inventory:RepairBoosts",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) and GetVehicleNumberPlateText(Vehicle) == Plate then
			local Tyres = {}

			for i = 0,7 do
				local Status = false

				if GetTyreHealth(Vehicle,i) ~= 1000.0 then
					Status = true
				end

				Tyres[i] = Status
			end

			local Fuel = GetVehicleFuelLevel(Vehicle)

			SetVehicleUndriveable(Vehicle,false)
			SetVehicleFixed(Vehicle)
			SetVehicleDirtLevel(Vehicle,0.0)
			SetVehicleDeformationFixed(Vehicle)
			SetVehicleFuelLevel(Vehicle,Fuel)

			for Tyre,Burst in pairs(Tyres) do
				if Burst then
					SetVehicleTyreBurst(Vehicle,Tyre,true,1000.0)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REPAIRTYRES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:RepairTyres")
AddEventHandler("inventory:RepairTyres",function(Vehicle,Tyres,Plate)
	if NetworkDoesNetworkIdExist(Vehicle) then
		local Vehicle = NetToEnt(Vehicle)
		if DoesEntityExist(Vehicle) and GetVehicleNumberPlateText(Vehicle) == Plate then
			if Tyres == "All" then
				for i = 0,10 do
					if GetTyreHealth(Vehicle,i) ~= 1000.0 then
						SetVehicleTyreFixed(Vehicle,i)
					end
				end
			else
				for i = 0,10 do
					if GetTyreHealth(Vehicle,i) ~= 1000.0 then
						SetVehicleTyreBurst(Vehicle,i,true,1000.0)
					end
				end

				SetVehicleTyreFixed(Vehicle,Tyres)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REPAIRDEFAULT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:RepairDefault")
AddEventHandler("inventory:RepairDefault",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) and GetVehicleNumberPlateText(Vehicle) == Plate then
			SetVehicleEngineHealth(Vehicle,1000.0)
			SetVehicleBodyHealth(Vehicle,1000.0)
			SetEntityHealth(Vehicle,1000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REPAIRADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:RepairAdmin")
AddEventHandler("inventory:RepairAdmin",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) and GetVehicleNumberPlateText(Vehicle) == Plate then
			local Fuel = GetVehicleFuelLevel(Vehicle)

			SetVehicleUndriveable(Vehicle,false)
			SetVehicleFixed(Vehicle)
			SetVehicleDirtLevel(Vehicle,0.0)
			SetVehicleDeformationFixed(Vehicle)
			SetVehicleFuelLevel(Vehicle,Fuel)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FISHING
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Fishing(Item)
	local Fishings = false
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)

	local Locates = {
		{ ["Coords"] = vec3(1183.88,4002.14,30.23), ["Item"] = "fishingrod" },
		{ ["Coords"] = vec3(-230.83,-3332.51,0.59), ["Item"] = "fishingrod2" },
		{ ["Coords"] = vec3(-1314.5,6207.45,-0.56), ["Item"] = "fishingrod3" },
		{ ["Coords"] = vec3(-627.61,7597.86,-0.42), ["Item"] = "fishingrod4" }
	}

	for _,v in pairs(Locates) do
		if #(Coords - v["Coords"]) <= 200 and Item == v["Item"] then
			Fishings = true
		end
	end

	return Fishings
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:EXPLODETYRES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:explodeTyres")
AddEventHandler("inventory:explodeTyres",function(Network,Plate,Tyre)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) and GetVehicleNumberPlateText(Vehicle) == Plate then
			SetVehicleTyreBurst(Vehicle,Tyre,true,1000.0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYRELIST
-----------------------------------------------------------------------------------------------------------------------------------------
local TyreList = {
	["wheel_lf"] = 0,
	["wheel_rf"] = 1,
	["wheel_lm"] = 2,
	["wheel_rm"] = 3,
	["wheel_lr"] = 4,
	["wheel_rr"] = 5
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYRES
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Tyres()
	local Ped = PlayerPedId()
	if not IsPedInAnyVehicle(Ped) then
		local Vehicle,Model = vRP.ClosestVehicle(7)
		if IsEntityAVehicle(Vehicle) then
			local Coords = GetEntityCoords(Ped)

			for Index,Tyre in pairs(TyreList) do
				local Selected = GetEntityBoneIndexByName(Vehicle,Index)
				if Selected ~= -1 then
					local CoordsWheel = GetWorldPositionOfEntityBone(Vehicle,Selected)
					if #(Coords - CoordsWheel) <= 1.0 and GetTyreHealth(Vehicle,Tyre) ~= 1000.0 then
						return Vehicle,Tyre,VehToNet(Vehicle),GetVehicleNumberPlateText(Vehicle),Model
					end
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYREHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.tyreHealth(Network,Tyre)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			return GetTyreHealth(Vehicle,Tyre)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTEXISTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.ObjectExists(Coords,Hash,Distance)
	return DoesObjectOfTypeExistAtCoords(Coords[1],Coords[2],Coords[3],Distance or 0.35,Hash,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINTERIOR
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.CheckInterior()
	return GetInteriorFromEntity(PlayerPedId()) ~= 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOSSANTOS
-----------------------------------------------------------------------------------------------------------------------------------------
local LosSantos = PolyZone:Create({
	vec2(-2153.08,-3131.33),
	vec2(-1581.58,-2092.38),
	vec2(-3271.05,275.85),
	vec2(-3460.83,967.42),
	vec2(-3202.39,1555.39),
	vec2(-1642.50,993.32),
	vec2(312.95,1054.66),
	vec2(1313.70,341.94),
	vec2(1739.01,-1280.58),
	vec2(1427.42,-3440.38),
	vec2(-737.90,-3773.97)
},{ name = "Santos" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- SANDYSHORES
-----------------------------------------------------------------------------------------------------------------------------------------
local SandyShores = PolyZone:Create({
	vec2(-375.38,2910.14),
	vec2(307.66,3664.47),
	vec2(2329.64,4128.52),
	vec2(2349.93,4578.50),
	vec2(1680.57,4462.48),
	vec2(1570.01,4961.27),
	vec2(1967.55,5203.67),
	vec2(2387.14,5273.98),
	vec2(2735.26,4392.21),
	vec2(2512.33,3711.16),
	vec2(1681.79,3387.82),
	vec2(258.85,2920.16)
},{ name = "Sandy" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- PALETOBAY
-----------------------------------------------------------------------------------------------------------------------------------------
local PaletoBay = PolyZone:Create({
	vec2(-529.40,5755.14),
	vec2(-234.39,5978.46),
	vec2(278.16,6381.84),
	vec2(672.67,6434.39),
	vec2(699.56,6877.77),
	vec2(256.59,7058.49),
	vec2(17.64,7054.53),
	vec2(-489.45,6449.50),
	vec2(-717.59,6030.94)
},{ name = "Paleto" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- CEVENTGUNSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("CEventGunShot",function(_,OtherPeds)
	local Ped = PlayerPedId()
	if Ped == OtherPeds and not LocalPlayer["state"]["Arena"] and not CheckPolice() and GetGameTimer() >= ShotDelay and Weapon ~= "WEAPON_MUSKET" then
		ShotDelay = GetGameTimer() + 60000
		TriggerEvent("player:Residual","Resíduo de Pólvora")

		local Coords = GetEntityCoords(Ped)
		if not IsPedCurrentWeaponSilenced(Ped) then
			if (LosSantos:isPointInside(Coords) or SandyShores:isPointInside(Coords) or PaletoBay:isPointInside(Coords)) then
				vSERVER.ShotsFired(IsPedInAnyVehicle(Ped))
			end
		else
			if math.random(100) >= 75 and (LosSantos:isPointInside(Coords) or SandyShores:isPointInside(Coords) or PaletoBay:isPointInside(Coords)) then
				vSERVER.ShotsFired(IsPedInAnyVehicle(Ped))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTAURANTE:POLYZONE
-----------------------------------------------------------------------------------------------------------------------------------------
local Restaurante = PolyZone:Create({
	vec2(367.75039672852, -380.62030029297),
	vec2(363.62280273438, -379.97207641602),
	vec2(358.79827880859, -377.81262207031),
	vec2(354.94940185547, -375.4841003418),
	vec2(351.69717407227, -373.01776123047),
	vec2(348.82656860352, -369.59860229492),
	vec2(346.4651184082, -365.56262207031),
	vec2(344.98919677734, -361.32705688477),
	vec2(344.60568237305, -359.59918212891),
	vec2(344.16943359375, -356.55249023438),
	vec2(344.65716552734, -350.31552124023),
	vec2(345.44552612305, -344.79568481445),
	vec2(349.02700805664, -332.89541625977),
	vec2(350.78015136719, -327.3567199707),
	vec2(351.83596801758, -323.23330688477),
	vec2(353.44076538086, -317.95428466797),
	vec2(358.81463623047, -301.4807434082),
	vec2(359.76583862305, -298.62030029297),
	vec2(362.17211914062, -293.34097290039),
	vec2(374.36877441406, -298.10305786133),
	vec2(379.05599975586, -299.861328125),
	vec2(384.8349609375, -302.43319702148),
	vec2(390.3132019043, -304.44381713867),
	vec2(399.41357421875, -308.21371459961),
	vec2(403.90765380859, -309.92163085938),
	vec2(404.97247314453, -310.28256225586),
	vec2(411.47192382812, -312.73654174805),
	vec2(416.0569152832, -314.62310791016),
	vec2(421.0158996582, -316.70364379883),
	vec2(431.70574951172, -320.74221801758),
	vec2(436.7158203125, -322.72311401367),
	vec2(441.69430541992, -324.90576171875),
	vec2(436.58615112305, -334.18276977539),
	vec2(434.03314208984, -339.03030395508),
	vec2(425.97479248047, -352.62725830078),
	vec2(422.76550292969, -357.11471557617),
	vec2(419.64260864258, -360.69958496094),
	vec2(416.56063842773, -364.19869995117),
	vec2(413.09643554688, -367.14614868164),
	vec2(409.33102416992, -370.0012512207),
	vec2(405.80380249023, -372.24798583984),
	vec2(401.16848754883, -375.05374145508),
	vec2(396.67416381836, -377.01196289062),
	vec2(392.54379272461, -378.61178588867),
	vec2(387.82946777344, -380.05053710938),
	vec2(382.40707397461, -381.35647583008),
	vec2(376.97897338867, -381.71481323242),
	vec2(371.96710205078, -381.66961669922),
	vec2(368.35327148438, -380.98675537109)
}, {
	name = "Restaurante",
})
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTAURANT
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Restaurant()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)

	return Restaurante:isPointInside(Coords)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADLEAVESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			if LocalPlayer["state"]["Restaurante"] then
				local Coords = GetEntityCoords(Ped)

				if not Restaurante:isPointInside(Coords) then
					TriggerServerEvent("dynamic:ExitService","Restaurante")
				end
			end

			if IsPedSwimming(Ped) then
				if not Swimming and not ScubaTank and not ScubaMask then
					Swimming = true
					vSERVER.Swimming()
				end
			elseif Swimming then
				Swimming = false
			end
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTIITYCOORDSZ
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.EntityCoordsZ()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local _,GroundZ = GetGroundZFor_3dCoord(Coords["x"],Coords["y"],Coords["z"])

	return vec3(Coords["x"],Coords["y"],GroundZ)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSWIMMING
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			if IsPedSwimming(Ped) then
				if not Swimming and not ScubaTank and not ScubaMask then
					Swimming = true

					vSERVER.Swimming()
				end
			elseif Swimming then
				Swimming = false
			end
		end

		Wait(10000)
	end
end)