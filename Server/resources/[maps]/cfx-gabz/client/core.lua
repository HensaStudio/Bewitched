-----------------------------------------------------------------------------------------------------------------------------------------
-- GABZINTERIORS
-----------------------------------------------------------------------------------------------------------------------------------------
local GabzInteriors = {
	-- PILLBOX HOSPITAL
	{
		ipl = "gabz_pillbox_milo_",
		coords = vec3(311.2546, -592.4204, 42.32737),
		removeIpls = {
			"rc12b_fixed",
			"rc12b_destroyed",
			"rc12b_default",
			"rc12b_hospitalinterior_lod",
			"rc12b_hospitalinterior"
		}
	},

	-- IMPORT GARAGE
	{
		ipl = "gabz_imp_impexp_interior_placement_interior_1_impexp_intwaremed_milo_",
		coords = vec3(941.0084, -972.6645, 39.14678),
		props = { "branded_style_set", "car_floor_hatch" }
	},

	-- LSPD - MISSION ROW
	{
		ipl = "gabz_mrpd_milo_",
		coords = vec3(451.0129, -993.3741, 29.1718),
		props = (function()
			local t = {}
			for i = 1, 31 do t[#t+1] = "v_gabz_mrpd_rm"..i end
			return t
		end)()
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GABZTHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for _, data in ipairs(GabzInteriors) do
		if data.ipl then
			RequestIpl(data.ipl)
		end

		local interior = GetInteriorAtCoords(data.coords.x, data.coords.y, data.coords.z)
		if IsValidInterior(interior) then
			if data.removeIpls then
				for _, iplName in ipairs(data.removeIpls) do
					RemoveIpl(iplName)
				end
			end

			if data.props then
				for _, prop in ipairs(data.props) do
					EnableInteriorProp(interior, prop)
				end
			end

			RefreshInterior(interior)
		end
	end
end)