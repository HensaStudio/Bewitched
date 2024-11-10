RegisterCommand("hensa",function(source)
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.Request(source, "Request", "Você gosta da Hensa?") then
			TriggerClientEvent("Notify",source,"Admin","oie","update",5000)
		end
		-- local Hensa = vRP.GetUserHierarchy(Passport,"Policia")

		-- TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","roxo",5000)
		-- exports["inventory"]:Drops(Passport,source,"dollar",1)
	end
end)