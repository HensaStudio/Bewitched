-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTROLS
-----------------------------------------------------------------------------------------------------------------------------------------
local CONTROLS = { 37,204,211,349,192,157,158,159,160,161,162,163,164,165 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUNNYHOPE
-----------------------------------------------------------------------------------------------------------------------------------------
local BUNNYHOPE = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROOFS
-----------------------------------------------------------------------------------------------------------------------------------------
local PROOFS = {
	bulletProof = false,
	fireProof = false,
	explosionProof = false,
	collisionProof = false,
	meleeProof = false,
	steamProof = false,
	drownProof = false,
	bulletImpactProof = false
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local BLIPS = {
	{ -545.31,-203.74,38.22, 267, 5,  "Prefeitura", 0.6 },

	{ 486.93,-921.71,26.4, 106, 1, "Bottom Dollar", 0.5 },

	{ 300.16,-584.9,43.29, 80, 49, "Hospital", 0.5 },

	{ -505.63,282.49,83.29, 355, 50, "DigitalDen", 0.6 },

	{ 435.47,-981.86,30.68, 60, 31, "LS: Departamento Policial", 0.6 },
	{ -438.61,6012.81,32.28, 60, 21, "PB: Departamento Policial", 0.6 },
	{ 1854.64,3684.22,34.22, 60, 16, "SS: Departamento Policial", 0.6 },
	{ 386.85,793.81,187.45, 60, 52, "PR: Departamento Policial", 0.6 },

	{ -196.47,-1728.96,32.65, 164, 2, "Families", 0.8 },
	{ 97.68,-1982.13,20.54, 164, 7, "Ballas", 0.8 },
	{ 353.62,-2050.23,21.82, 164, 5, "Vagos", 0.8 },

	{ 945.82,-984.14,39.5, 402, 18, "Mecânica AutoCare", 0.8 },

	{ -1816.64,-1193.73,14.31, 68, 18, "Pescador", 0.6 },

	{ 1961.61,5179.26,47.94, 285, 10, "Lenhador", 0.6 },

	{ -773.14,5599.65,33.75, 141, 51, "Cabana de Caça", 0.8 },

	{ -1204.85,-1564.27, 4.6, 126, 30, "Academia", 0.7 },

	{ 963.13,-2215.33,30.55, 77, 32, "Leiteiro", 0.5 },

	{ 264.74,219.99,101.67, 67, 4, "Transportador", 0.6 },

	{ 1239.87,-3257.2,7.09, 67, 4, "Caminhoneiro", 0.6 },

	{ 453.47,-602.34,28.59, 513, 4, "Motorista", 0.6 },

	{ -193.25,-1162.39,23.67, 477, 4, "Reboque", 0.6 },

	{ 901.97,-167.97,74.07, 198, 70, "Taxista", 0.6 },

	{ 68.99,127.46,79.21, 478, 20, "Go Postal", 0.6 },

	{ -628.79,-238.7,38.05, 617, 26, "Joalheria", 0.6 },

	{ 2953.93,2787.49,41.5, 617, 56, "Minerador", 0.6 },

	{ -1741.52,-219.85,56.14, 429, 62, "Cemitério", 0.5 },

	{ 1272.51,-1713.05,54.63, 77, 28, "Lester", 0.5 },

	{ 174.88,-1323.7,29.35, 643, 22, "PawnShop", 0.7 },

	{ 369.74,-346.95,46.78, 408, 6, "Arriba", 0.6 },

	{ 46.7,-1749.71,29.62, 78, 30, "Mega Mall", 0.5 },

	{ 1110.8,-2008.75,31.43, 648, 44, "Refinaria", 0.6 },

	{ -345.38,-1555.59,25.22, 318, 39, "Catador de Reciclagem", 0.7 },

	{ -172.89,6381.32,31.48, 403, 5, "Farmácia", 0.7 },
	{ 1690.07,3581.68,35.62, 403, 5, "Farmácia", 0.7 },
	{ 114.49,-5.03,67.82, 403, 5, "Farmácia", 0.7 },

	{ -772.76,312.81,85.7, 475, 36, "Hotel", 0.7 },

	{ -56.98,-1098.79,26.42, 225, 62, "Concessionária", 0.6 },

	{ 966.47,-1914.76,31.14, 467, 11, "Recicladora", 0.7 },
	{ -178.19,6261.09,31.49, 467, 11, "Recicladora", 0.7 },
	{ 270.14,2858.27,43.64, 467, 11, "Recicladora", 0.7 },

	{ 149.64,-1041.36,29.59, 108, 82, "Banco", 0.7 },
	{ 313.95,-279.74,54.39, 108, 82, "Banco", 0.7 },
	{ -351.2,-50.57,49.26, 108, 82, "Banco", 0.7 },
	{ -2961.85,482.87,15.92, 108, 82, "Banco", 0.7 },
	{ 1175.09,2707.53,38.31, 108, 82, "Banco", 0.7 },
	{ -1212.37,-331.37,38.0, 108, 82, "Banco", 0.7 },
	{ -112.86,6470.46,31.85, 108, 82, "Banco", 0.7 },
	{ 235.36,216.94,106.29, 108, 82, "Banco", 0.7 },

	{ 1692.27,3760.91,34.69, 76, 35, "Loja de Armas", 0.5 },
	{ 253.8,-50.47,69.94, 76, 35, "Loja de Armas", 0.5 },
	{ 842.54,-1035.25,28.19, 76, 35, "Loja de Armas", 0.5 },
	{ -331.67,6084.86,31.46, 76, 35, "Loja de Armas", 0.5 },
	{ -662.37,-933.58,21.82, 76, 35, "Loja de Armas", 0.5 },
	{ -1304.12,-394.56,36.7, 76, 35, "Loja de Armas", 0.5 },
	{ -1118.98,2699.73,18.55, 76, 35, "Loja de Armas", 0.5 },
	{ 2567.98,292.62,108.73, 76, 35, "Loja de Armas", 0.5 },
	{ -3173.51,1088.35,20.84, 76, 35, "Loja de Armas", 0.5 },
	{ 22.53,-1105.52,29.79, 76, 35, "Loja de Armas", 0.5 },
	{ 810.22,-2158.99,29.62, 76, 35, "Loja de Armas", 0.5 },

	{ 1327.98,-1654.78,52.03, 75, 13, "Loja de Tatuagem", 0.6 },
	{ -1149.04,-1428.64,4.71, 75, 13, "Loja de Tatuagem", 0.6 },
	{ 322.01,186.24,103.34, 75, 13, "Loja de Tatuagem", 0.6 },
	{ -3175.64,1075.54,20.58, 75, 13, "Loja de Tatuagem", 0.6 },
	{ 1866.01,3748.07,32.79, 75, 13, "Loja de Tatuagem", 0.6 },
	{ -295.51,6199.21,31.24, 75, 13, "Loja de Tatuagem", 0.6 },

	{ -815.12,-184.15,37.57, 71, 13, "Barbearia", 0.6 },
	{ 139.56,-1704.12,29.05, 71, 13, "Barbearia", 0.6 },
	{ -1278.11,-1116.66,6.75, 71, 13, "Barbearia", 0.6 },
	{ 1928.89,3734.04,32.6, 71, 13, "Barbearia", 0.6 },
	{ 1217.05,-473.45,65.96, 71, 13, "Barbearia", 0.6 },
	{ -34.08,-157.01,56.83, 71, 13, "Barbearia", 0.6 },
	{ -274.5,6225.27,31.45, 71, 13, "Barbearia", 0.6 },

	{ 86.06,-1391.64,29.23, 366, 51, "Loja de Roupas", 0.5 },
	{ -719.94,-158.18,37.0, 366, 51, "Loja de Roupas", 0.5 },
	{ -152.79,-306.79,38.67, 366, 51, "Loja de Roupas", 0.5 },
	{ -816.39,-1081.22,11.12, 366, 51, "Loja de Roupas", 0.5 },
	{ -1206.51,-781.5,17.12, 366, 51, "Loja de Roupas", 0.5 },
	{ -1458.26,-229.79,49.2, 366, 51, "Loja de Roupas", 0.5 },
	{ -2.41,6518.29,31.48, 366, 51, "Loja de Roupas", 0.5 },
	{ 1682.59,4819.98,42.04, 366, 51, "Loja de Roupas", 0.5 },
	{ 129.46,-205.18,54.51, 366, 51, "Loja de Roupas", 0.5 },
	{ 618.49,2745.54,42.01, 366, 51, "Loja de Roupas", 0.5 },
	{ 1197.93,2698.21,37.96, 366, 51, "Loja de Roupas", 0.5 },
	{ -3165.74,1061.29,20.84, 366, 51, "Loja de Roupas", 0.5 },
	{ -1093.76,2703.99,19.04, 366, 51, "Loja de Roupas", 0.5 },
	{ 414.86,-807.57,29.34, 366, 51, "Loja de Roupas", 0.5 },

	{ 76.99,-194.58,54.49, 357, 32, "Garagem", 0.6 },
	{ -1686.58,26.39,64.38, 357, 32, "Garagem", 0.6 },
	{ -616.03,-1209.16,14.2, 357, 32, "Garagem", 0.6 },
	{ 964.11,-1035.85,40.83, 357, 32, "Garagem", 0.6 },
	{ 453.0,-1917.46,24.7, 357, 32, "Garagem", 0.6 },
	{ 1700.43,3766.2,34.42, 357, 32, "Garagem", 0.6 },
	{ -197.57,6233.16,31.49, 357, 32, "Garagem", 0.6 },
	{ 1109.02,2660.88,37.98, 357, 32, "Garagem", 0.6 },
	{ -766.65,5580.45,33.6, 357, 32, "Garagem", 0.6 },
	{ 55.88,-876.34,30.65, 357, 32, "Garagem", 0.6 },
	
	{ 29.2,-1351.89,29.34, 59, 4, "Lojas 24/7", 0.6 },
	{ 2561.74,385.22,108.61, 59, 4, "Lojas 24/7", 0.6 },
	{ 1160.21,-329.4,69.03, 59, 4, "Lojas 24/7", 0.6 },
	{ -711.99,-919.96,19.01, 59, 4, "Lojas 24/7", 0.6 },
	{ -54.56,-1758.56,29.05, 59, 4, "Lojas 24/7", 0.6 },
	{ 375.87,320.04,103.42, 59, 4, "Lojas 24/7", 0.6 },
	{ -3237.48,1004.72,12.45, 59, 4, "Lojas 24/7", 0.6 },
	{ 1730.64,6409.67,35.0, 59, 4, "Lojas 24/7", 0.6 },
	{ 543.51,2676.85,42.14, 59, 4, "Lojas 24/7", 0.6 },
	{ 1966.53,3737.95,32.18, 59, 4, "Lojas 24/7", 0.6 },
	{ 2684.73,3281.2,55.23, 59, 4, "Lojas 24/7", 0.6 },
	{ 1696.12,4931.56,42.07, 59, 4, "Lojas 24/7", 0.6 },
	{ -1820.18,785.69,137.98, 59, 4, "Lojas 24/7", 0.6 },
	{ 1395.35,3596.6,34.86, 59, 4, "Lojas 24/7", 0.6 },
	{ -2977.14,391.22,15.03, 59, 4, "Lojas 24/7", 0.6 },
	{ -3034.99,590.77,7.8, 59, 4, "Lojas 24/7", 0.6 },
	{ 1144.46,-980.74,46.19, 59, 4, "Lojas 24/7", 0.6 },
	{ 1166.06,2698.17,37.95, 59, 4, "Lojas 24/7", 0.6 },
	{ -1493.12,-385.55,39.87, 59, 4, "Lojas 24/7", 0.6 },
	{ -1228.6,-899.7,12.27, 59, 4, "Lojas 24/7", 0.6 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALPHAS
-----------------------------------------------------------------------------------------------------------------------------------------
local ALPHAS = {
	{ vec3(827.1, 5426.91, 485.51), 200, 51, 700.0 }, -- Caça 1
	{ vec3(-2080.6, 1357.4, 257.87), 200, 51, 500.0 }, -- Caça 2
	{ vec3(1183.88,4002.14,30.23), 200, 31, 150.0 }, -- Vara de Madeira
	{ vec3(-230.83,-3332.51,0.59), 200, 25, 150.0 }, -- Vara de Grafite
	{ vec3(-1314.5,6207.45,-0.56), 200, 38, 150.0 }, -- Vara de Fibra
	{ vec3(-627.61,7597.86,-0.42), 200, 49, 150.0 } -- Vara de Carbono
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local TELEPORT = {
	{ vec3(332.33,-595.66,43.29),vec3(344.37,-586.21,28.8) },
	{ vec3(344.37,-586.21,28.8),vec3(332.33,-595.66,43.29) },

	{ vec3(330.39,-601.25,43.29),vec3(330.4,-601.23,43.29) },
	{ vec3(330.4,-601.23,43.29),vec3(330.39,-601.25,43.29) },

	{ vec3(327.12,-603.89,43.29),vec3(338.52,-583.76,74.16) },
	{ vec3(338.52,-583.76,74.16),vec3(327.12,-603.89,43.29) }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISLAND
-----------------------------------------------------------------------------------------------------------------------------------------
local ISLAND = {
	"h4_islandairstrip",
	"h4_islandairstrip_props",
	"h4_islandx_mansion",
	"h4_islandx_mansion_props",
	"h4_islandx_props",
	"h4_islandxdock",
	"h4_islandxdock_props",
	"h4_islandxdock_props_2",
	"h4_islandxtower",
	"h4_islandx_maindock",
	"h4_islandx_maindock_props",
	"h4_islandx_maindock_props_2",
	"h4_IslandX_Mansion_Vault",
	"h4_islandairstrip_propsb",
	"h4_beach",
	"h4_beach_props",
	"h4_beach_bar_props",
	"h4_islandx_barrack_props",
	"h4_islandx_checkpoint",
	"h4_islandx_checkpoint_props",
	"h4_islandx_Mansion_Office",
	"h4_islandx_Mansion_LockUp_01",
	"h4_islandx_Mansion_LockUp_02",
	"h4_islandx_Mansion_LockUp_03",
	"h4_islandairstrip_hangar_props",
	"h4_IslandX_Mansion_B",
	"h4_islandairstrip_doorsclosed",
	"h4_Underwater_Gate_Closed",
	"h4_mansion_gate_closed",
	"h4_aa_guns",
	"h4_IslandX_Mansion_GuardFence",
	"h4_IslandX_Mansion_Entrance_Fence",
	"h4_IslandX_Mansion_B_Side_Fence",
	"h4_IslandX_Mansion_Lights",
	"h4_islandxcanal_props",
	"h4_beach_props_party",
	"h4_islandX_Terrain_props_06_a",
	"h4_islandX_Terrain_props_06_b",
	"h4_islandX_Terrain_props_06_c",
	"h4_islandX_Terrain_props_05_a",
	"h4_islandX_Terrain_props_05_b",
	"h4_islandX_Terrain_props_05_c",
	"h4_islandX_Terrain_props_05_d",
	"h4_islandX_Terrain_props_05_e",
	"h4_islandX_Terrain_props_05_f",
	"h4_islandx_terrain_01",
	"h4_islandx_terrain_02",
	"h4_islandx_terrain_03",
	"h4_islandx_terrain_04",
	"h4_islandx_terrain_05",
	"h4_islandx_terrain_06",
	"h4_ne_ipl_00",
	"h4_ne_ipl_01",
	"h4_ne_ipl_02",
	"h4_ne_ipl_03",
	"h4_ne_ipl_04",
	"h4_ne_ipl_05",
	"h4_ne_ipl_06",
	"h4_ne_ipl_07",
	"h4_ne_ipl_08",
	"h4_ne_ipl_09",
	"h4_nw_ipl_00",
	"h4_nw_ipl_01",
	"h4_nw_ipl_02",
	"h4_nw_ipl_03",
	"h4_nw_ipl_04",
	"h4_nw_ipl_05",
	"h4_nw_ipl_06",
	"h4_nw_ipl_07",
	"h4_nw_ipl_08",
	"h4_nw_ipl_09",
	"h4_se_ipl_00",
	"h4_se_ipl_01",
	"h4_se_ipl_02",
	"h4_se_ipl_03",
	"h4_se_ipl_04",
	"h4_se_ipl_05",
	"h4_se_ipl_06",
	"h4_se_ipl_07",
	"h4_se_ipl_08",
	"h4_se_ipl_09",
	"h4_sw_ipl_00",
	"h4_sw_ipl_01",
	"h4_sw_ipl_02",
	"h4_sw_ipl_03",
	"h4_sw_ipl_04",
	"h4_sw_ipl_05",
	"h4_sw_ipl_06",
	"h4_sw_ipl_07",
	"h4_sw_ipl_08",
	"h4_sw_ipl_09",
	"h4_islandx_mansion",
	"h4_islandxtower_veg",
	"h4_islandx_sea_mines",
	"h4_islandx",
	"h4_islandx_barrack_hatch",
	"h4_islandxdock_water_hatch",
	"h4_beach_party",
	"h4_mph4_terrain_01_grass_0",
	"h4_mph4_terrain_01_grass_1",
	"h4_mph4_terrain_02_grass_0",
	"h4_mph4_terrain_02_grass_1",
	"h4_mph4_terrain_02_grass_2",
	"h4_mph4_terrain_02_grass_3",
	"h4_mph4_terrain_04_grass_0",
	"h4_mph4_terrain_04_grass_1",
	"h4_mph4_terrain_04_grass_2",
	"h4_mph4_terrain_04_grass_3",
	"h4_mph4_terrain_05_grass_0",
	"h4_mph4_terrain_06_grass_0",
	"h4_mph4_airstrip_interior_0_airstrip_hanger"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- IPL_LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local IPL_LIST = {
	{
		["Props"] = {
			"swap_clean_apt",
			"layer_debra_pic",
			"layer_whiskey",
			"swap_sofa_A"
		},
		["Coords"] = vec3(-1150.70,-1520.70,10.60)
	},{
		["Props"] = {
			"csr_beforeMission",
			"csr_inMission"
		},
		["Coords"] = vec3(-47.10,-1115.30,26.50)
	},{
		["Props"] = {
			"V_Michael_bed_tidy",
			"V_Michael_M_items",
			"V_Michael_D_items",
			"V_Michael_S_items",
			"V_Michael_L_Items"
		},
		["Coords"] = vec3(-802.30,175.00,72.80)
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Blackout",nil,function(Name,Key,Value)
	SetArtificialLightsState(Value)
	SetArtificialLightsStateAffectsVehicles(false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	if GlobalState["Blackout"] then
		SetArtificialLightsState(true)
		SetArtificialLightsStateAffectsVehicles(false)
	end

	while true do
		local Pid = PlayerId()
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			DisableControlAction(0,345,true)

			if IsPedInAnyHeli(Ped) then
				local Vehicle = GetVehiclePedIsUsing(Ped)
				if IsControlJustPressed(1,154) and not IsAnyPedRappellingFromHeli(Vehicle) and (GetPedInVehicleSeat(Vehicle,1) == Ped or GetPedInVehicleSeat(Vehicle,2) == Ped) then
					TaskRappelFromHeli(Ped,1)
				end
			end
		else
			if BUNNYHOPE >= GetGameTimer() then
				DisableControlAction(1,22,true)
			elseif IsPedJumping(Ped) and BUNNYHOPE <= GetGameTimer() then
				BUNNYHOPE = GetGameTimer() + 1000
			end
		end

		for Number = 1,22 do
			if Number ~= 14 and Number ~= 16 then
				HideHudComponentThisFrame(Number)
			end
		end

		for _,control in ipairs(CONTROLS) do
			DisableControlAction(0,control,true)
		end

		DisableVehicleDistantlights(true)
		SetAllVehicleGeneratorsActive()
		CancelCurrentPoliceReport()
		BlockWeaponWheelThisFrame()
		SetCreateRandomCops(false)
		SetPoliceRadarBlips(false)
		DistantCopCarSirens(false)
		SetPauseMenuActive(false)

		SetVehicleDensityMultiplierThisFrame(1.0)
		SetRandomVehicleDensityMultiplierThisFrame(1.0)
		SetParkedVehicleDensityMultiplierThisFrame(1.0)
		SetScenarioPedDensityMultiplierThisFrame(1.0,1.0)
		SetPedDensityMultiplierThisFrame(1.0)

		if IsPedArmed(Ped,6) then
			DisableControlAction(0,140,true)
			DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
		end

		if IsPedUsingActionMode(Ped) then
			SetPedUsingActionMode(Ped,-1,-1,1)
		end

		SetPlayerTargetingMode(3)
		DisablePlayerVehicleRewards(Pid)
		SetPlayerLockonRangeOverride(Pid,0.0)
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetPedInfiniteAmmoClip(Ped,LocalPlayer["state"]["Arena"] and true or false)
		SetEntityProofs(Ped,PROOFS.bulletProof,PROOFS.fireProof,PROOFS.explosionProof,PROOFS.collisionProof,PROOFS.meleeProof,PROOFS.steamProof,PROOFS.drownProof,PROOFS.bulletImpactProof)

		if IsPlayerWantedLevelGreater(Pid,0) then
			ClearPlayerWantedLevel(Pid)
		end

		if LocalPlayer["state"]["Active"] then
			NetworkOverrideClockTime(GlobalState["Hours"],GlobalState["Minutes"],0)
		else
			NetworkOverrideClockTime(12,0,0)
		end

		Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			local Distance = #(Coords - vec3(253.73, 224.19, 101.91))
			if Distance <= 1.5 then
				TimeDistance = 1

				if IsControlJustPressed(1, 38) then
					local Handle, Object = FindFirstObject()
					local Finished = false

					repeat
						local Heading = GetEntityHeading(Object)
						local CoordsObj = GetEntityCoords(Object)
						local DistanceObjs = #(CoordsObj - Coords)

						if DistanceObjs < 3.0 and GetEntityModel(Object) == 961976194 then
							if Heading > 150.0 then
								SetEntityHeading(Object, 0.0)
							else
								SetEntityHeading(Object, 160.0)
							end

							FreezeEntityPosition(Object, true)
							Finished = true
						end

						Finished, Object = FindNextObject(Handle)
					until not Finished

					EndFindObject(Handle)
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local mapZoomData = {
		{ 0,0.96,0.9,0.08,0.0,0.0 },
		{ 1,1.6,0.9,0.08,0.0,0.0 },
		{ 2,8.6,0.9,0.08,0.0,0.0 },
		{ 3,12.3,0.9,0.08,0.0,0.0 },
		{ 4,22.3,0.9,0.08,0.0,0.0 }
	}

	for _,zoomData in ipairs(mapZoomData) do
		SetMapZoomDataLevel(zoomData[1],zoomData[2],zoomData[3],zoomData[4],zoomData[5],zoomData[6])
	end

	for _,v in pairs(IPL_LIST) do
		local Interior = GetInteriorAtCoords(v["Coords"])
		LoadInterior(Interior)

		if v["Props"] then
			for _,Index in pairs(v["Props"]) do
				EnableInteriorProp(Interior,Index)
			end
		end

		RefreshInterior(Interior)
	end

	for _,alphaData in ipairs(ALPHAS) do
		local radius = alphaData[1]
		local Blip = AddBlipForRadius(radius["x"],radius["y"],radius["z"],alphaData[4])
		SetBlipAlpha(Blip,alphaData[2])
		SetBlipColour(Blip,alphaData[3])
	end

	for _,blipData in ipairs(BLIPS) do
		local Blip = AddBlipForCoord(blipData[1],blipData[2],blipData[3])
		SetBlipSprite(Blip,blipData[4])
		SetBlipDisplay(Blip,4)
		SetBlipAsShortRange(Blip,true)
		SetBlipColour(Blip,blipData[5])
		SetBlipScale(Blip,blipData[7])

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(blipData[6])
		EndTextCommandSetBlipName(Blip)

		Wait(10)
	end

	local teleportData = {}
	for _,v in ipairs(TELEPORT) do
		table.insert(teleportData,{ v[1],2.5,"E","Pressione","para acessar" })
	end

	TriggerEvent("hoverfy:Insert",teleportData)

	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			for Number = 1,#TELEPORT do
				if #(Coords - TELEPORT[Number][1]) <= 1.0 then
					TimeDistance = 1

					if IsControlJustPressed(1,38) then
						SetEntityCoords(Ped,TELEPORT[Number][2])
					end
				end
			end
		end

		InvalidateVehicleIdleCam()
		InvalidateIdleCam()

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local IslandLoaded = false
	for _,v in pairs(ISLAND) do
		RequestIpl(v)
	end

	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		if #(Coords - vec3(4840.57,-5174.42,2.0)) <= 2000 then
			if not IslandLoaded then
				IslandLoaded = true
				SetIslandHopperEnabled("HeistIsland",true)
				SetAiGlobalPathNodesType(1)
			end
		else
			if IslandLoaded then
				IslandLoaded = false
				SetIslandHopperEnabled("HeistIsland",false)
				SetAiGlobalPathNodesType(0)
			end
		end

		for _,Entity in pairs(GetGamePool("CPed")) do
			if (NetworkGetEntityOwner(Entity) == -1 or NetworkGetEntityOwner(Entity) == PlayerId()) and GetPedArmour(Entity) <= 0 and not NetworkGetEntityIsNetworked(Entity) then
				if IsPedInAnyVehicle(Entity) then
					local Vehicle = GetVehiclePedIsUsing(Entity)
					if NetworkGetEntityIsNetworked(Vehicle) then
						TriggerServerEvent("garages:Delete",NetworkGetNetworkIdFromEntity(Vehicle),GetVehicleNumberPlateText(Vehicle))
					else
						DeleteEntity(Vehicle)
					end
				else
					DeleteEntity(Entity)
				end
			end
		end

		for _,Vehicle in pairs(GetGamePool("CVehicle")) do
			if (NetworkGetEntityOwner(Vehicle) == -1 or NetworkGetEntityOwner(Vehicle) == PlayerId()) and not NetworkGetEntityIsNetworked(Vehicle) and GetVehicleNumberPlateText(Vehicle) ~= "PDMSPORT" then
				DeleteEntity(Vehicle)
			end
		end

		for Number = 1,121 do
			EnableDispatchService(Number,false)
		end

		Wait(10000)
	end
end)