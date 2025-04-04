-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Weapon = ""
local Skins = {}
local Objects = {}
TakeWeapon = false
StoreWeapon = false
local Reloaded = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:SKINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Skins")
AddEventHandler("inventory:Skins",function(Table)
	Skins = Table
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTOREWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	LoadAnim("rcmjosh4")
	LoadAnim("weapons@pistol@")

	while true do
		local TimeDistance = 999
		if Weapon ~= "" and Actived then
			TimeDistance = 100

			local Ped = PlayerPedId()
			local Ammo = GetAmmoInPedWeapon(Ped,Weapon)

			if GetGameTimer() >= Reloaded and IsPedReloading(Ped) then
				vSERVER.PreventWeapons(Weapon,Ammo)
				Reloaded = GetGameTimer() + 100
			end

			if IsPedInAnyVehicle(Ped) then
				local Vehicle = GetVehiclePedIsUsing(Ped)
				if IsPedShooting(Ped) and (GetVehicleClass(Vehicle) ~= 15 and GetVehicleClass(Vehicle) ~= 16) then
					ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.05)
				end
			end

			if Ammo <= 0 or (Weapon == "WEAPON_PETROLCAN" and Ammo <= 135 and IsPedShooting(Ped)) or IsPedSwimming(Ped) then
				if Types ~= "" then
					vSERVER.RemoveThrowing(Types)
				else
					vSERVER.PreventWeapons(Weapon,Ammo)
				end

				TriggerEvent("inventory:CleanWeapons")
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:VERIFYWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:VerifyWeapon")
AddEventHandler("inventory:VerifyWeapon",function(Item)
	local Name = SplitOne(Item)

	if Weapon ~= "" then
		local Ped = PlayerPedId()
		local AmmoItem = WeaponAmmo(Item)
		local AmmoHand = WeaponAmmo(Weapon)

		if AmmoItem and AmmoHand then
			if AmmoItem ~= AmmoHand then
				local Ammo = GetAmmoInPedWeapon(Ped,Name)
				if not vSERVER.VerifyWeapon(Name,Ammo) then
					TriggerEvent("inventory:CleanWeapons")
				end
			elseif Weapon == Name then
				local Ammo = GetAmmoInPedWeapon(Ped,Weapon)
				if not vSERVER.VerifyWeapon(Weapon,Ammo) then
					TriggerEvent("inventory:CleanWeapons")
				end
			end
		end
	else
		vSERVER.VerifyWeapon(Name)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLEANWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:CleanWeapons",function()
	if Weapon ~= "" then
		local Ped = PlayerPedId()
		local Ammo = GetAmmoInPedWeapon(Ped,Weapon)

		TriggerEvent("Weapon","")
		TriggerEvent("hud:Weapon",false)
		RemoveAllPedWeapons(Ped,true)

		Actived = false
		Weapon = ""
		Types = ""
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.ReturnWeapon()
	return Weapon ~= "" and Weapon or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.CheckWeapon(Hash)
	return Weapon == Hash and true or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVECOMPONENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.GiveComponent(Component)
	GiveWeaponComponentToPed(PlayerPedId(),Weapon,Component)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.TakeWeapon(Name,Ammo,Components,Type,Skin)
	if not TakeWeapon then
		if not Ammo then
			Ammo = 0
		end

		if Ammo > 0 then
			Actived = true
		end

		TakeWeapon = true
		LocalPlayer["state"]:set("Cancel",true,true)

		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			TaskPlayAnim(Ped,"rcmjosh4","josh_leadout_cop2",8.0,8.0,-1,48,1,0,0,0)

			Wait(200)

			Weapon = Name
			TriggerEvent("Weapon",Weapon)
			GiveWeaponToPed(Ped,Weapon,Ammo,false,true)

			if Skin then
				GiveWeaponComponentToPed(Ped,Weapon,Skin)
			end

			if Components then
				for Item,_ in pairs(Components) do
					local Comp = WeaponAttach(SplitOne(Item),Weapon)
					GiveWeaponComponentToPed(Ped,Weapon,Comp)
				end
			end

			Wait(300)

			ClearPedTasks(Ped)
		else
			Weapon = Name
			TriggerEvent("Weapon",Weapon)
			GiveWeaponToPed(Ped,Weapon,Ammo,false,true)

			if Skin then
				GiveWeaponComponentToPed(Ped,Weapon,Skin)
			end

			if Components then
				for Item,_ in pairs(Components) do
					local Comp = WeaponAttach(SplitOne(Item),Weapon)
					GiveWeaponComponentToPed(Ped,Weapon,Comp)
				end
			end
		end

		if Type then
			Types = Type
		end

		TakeWeapon = false
		LocalPlayer["state"]:set("Cancel",false,true)

		if WeaponAmmo(Weapon) then
			TriggerEvent("hud:Weapon",true,Weapon)
		end

		if (IsPedInAnyVehicle(Ped) and not ItemVehicle(Weapon)) or vSERVER.CheckExistWeapons(Weapon) or LocalPlayer["state"]["Safezone"] then
			TriggerEvent("inventory:CleanWeapons")
		end

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.StoreWeapon()
	if not StoreWeapon and Weapon ~= "" then
		StoreWeapon = true

		local Lasted = Weapon
		local Ped = PlayerPedId()
		local Ammo = GetAmmoInPedWeapon(Ped,Weapon)
		LocalPlayer["state"]:set("Cancel",true,true)

		if not IsPedInAnyVehicle(Ped) then
			TaskPlayAnim(Ped,"weapons@pistol@","aim_2_holster",8.0,8.0,-1,48,1,0,0,0)

			Wait(450)

			ClearPedTasks(Ped)
		end

		StoreWeapon = false
		TriggerEvent("inventory:CleanWeapons")
		LocalPlayer["state"]:set("Cancel",false,true)

		return true,Ammo,Lasted
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFOWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.InfoWeapon(Type)
	local Ammo = 0

	if Weapon ~= "" then
		Ammo = GetAmmoInPedWeapon(PlayerPedId(),Weapon)
	end

	return Weapon,Ammo
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RELOADING
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Reloading(Hash,Ammo)
	AddAmmoToPed(PlayerPedId(),Hash,Ammo)
	Actived = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARACHUTE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Parachute()
	GiveWeaponToPed(PlayerPedId(),"GADGET_PARACHUTE",1,false,true)
end