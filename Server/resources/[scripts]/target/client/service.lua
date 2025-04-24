-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICES
-----------------------------------------------------------------------------------------------------------------------------------------
local Services = {
	{
		["Permission"] = "LSPD",
		["Coords"] = vec3(441.82,-982.05,30.84),
		["Distance"] = 1.5,
		["Weight"] = 0.1
	},{
		["Permission"] = "SSPD",
		["Coords"] = vec3(1852.87,3687.8,34.08),
		["Distance"] = 1.5,
		["Weight"] = 0.1
	},{
		["Permission"] = "PBPD",
		["Coords"] = vec3(-447.28,6013.02,32.42),
		["Distance"] = 1.5,
		["Weight"] = 0.1
	},{
		["Permission"] = "PRPD",
		["Coords"] = vec3(385.46,794.43,187.49),
		["Distance"] = 1.5,
		["Weight"] = 0.1
	},{
		["Permission"] = "Mecanico",
		["Coords"] = vec3(952.0,-969.32,39.31),
		["Distance"] = 1.5,
		["Weight"] = 0.1
	},{
		["Permission"] = "Restaurante",
		["Coords"] = vec3(-270.21,236.12,90.89),
		["Distance"] = 1.5,
		["Weight"] = 0.1
	},{
		["Permission"] = "Paramedico",
		["Coords"] = vec3(307.54,-595.29,43.13),
		["Distance"] = 1.5,
		["Weight"] = 0.1
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Index,v in pairs(Services) do
		exports["target"]:AddCircleZone("Service:"..Index,v["Coords"],v["Weight"],{
			name = "Service:"..Index,
			heading = 0.0,
			useZ = true
		},{
			Distance = v["Distance"],
			options = {
				{
					event = "target:Service",
					label = "Interagir",
					service = v["Permission"],
					tunnel = "proserver"
				}
			}
		})
	end
end)