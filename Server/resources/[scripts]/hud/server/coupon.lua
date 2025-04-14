-----------------------------------------------------------------------------------------------------------------------------------------
-- COUPON
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Coupon"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ADDCOUPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("hud:AddCoupon")
AddEventHandler("hud:AddCoupon", function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "Admin", 1) then
			local Coupons = vRP.GetServerData("Coupons") or {}
			if #Coupons > 0 then
				TriggerClientEvent("Notify", source, "Aviso", "Já existe um cupom ativo no momento.", "vermelho", 5000)
				return
			end

			local Keyboard = vKEYBOARD.Coupon(source, "Título:", "Descrição:")
			if Keyboard then
				local AddCoupon = { Title = Keyboard[1], Description = Keyboard[2] }
				table.insert(Coupons, AddCoupon)

				vRP.SetServerData("Coupons", Coupons)
				GlobalState["Coupon"] = { Keyboard[1], Keyboard[2] }

				TriggerClientEvent("Notify", source, "Sucesso", "Cupom adicionado com sucesso.", "verde", 5000)
			end
		else
			TriggerClientEvent("Notify", source, "Atenção", "Você não tem permissões para isso.", "amarelo", 5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVECOUPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("hud:RemoveCoupon")
AddEventHandler("hud:RemoveCoupon", function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "Admin", 1) then
			local Coupons = vRP.GetServerData("Coupons")
			if Coupons and #Coupons > 0 then
				TriggerClientEvent("dynamic:Close", source)

				if vRP.Request(source, "Cupom", "Você realmente deseja remover o <b>Cupom</b> atual?") then
					vRP.RemoveServerData("Coupons")
					GlobalState["Coupon"] = false

					TriggerClientEvent("Notify", source, "Atenção", "Cupom removido com sucesso.", "amarelo", 5000)
				end
			else
				TriggerClientEvent("Notify", source, "Aviso", "Nenhum cupom ativo para remover.", "vermelho", 5000)
			end
		else
			TriggerClientEvent("Notify", source, "Atenção", "Você não tem permissões para isso.", "amarelo", 5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStart", function(resource)
	if resource == "hud" then
		local Coupons = vRP.GetServerData("Coupons")
		if Coupons and #Coupons > 0 then
			GlobalState["Coupon"] = { Coupons[1].Title, Coupons[1].Description }
		end
	end
end)