-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:ARRESTITENS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:ArrestItens")
AddEventHandler("police:ArrestItens", function(Entity)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport and vRP.GetHealth(source) > 100 and vRP.HasService(Passport,"Policia") then
        local OtherPassport = vRP.Passport(Entity)
        if OtherPassport then
            local Inventory = vRP.Inventory(OtherPassport)
            if Inventory then
                for Slot,ItemData in pairs(Inventory) do
                    if ItemArrest(ItemData.item) then
                        vRP.RemoveItem(OtherPassport, ItemData.item, ItemData.amount, ArrestNotify)
						TriggerClientEvent("Notify",source,"Sucesso","Objetos apreendidos.","verde",5000)
                    end
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Preset")
AddEventHandler("police:Preset",function(OtherSource)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 and vRP.HasService(Passport,"Policia") then
		local Hash = vRP.ModelPlayer(OtherSource)
		if Hash == "mp_m_freemode_01" or Hash == "mp_f_freemode_01" then
			TriggerClientEvent("skinshop:Apply",OtherSource,Presets[Hash])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:ARRESTVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:ArrestVehicles")
AddEventHandler("police:ArrestVehicles",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local OtherPassport = vRP.PassportPlate(Entity[1])
		if OtherPassport then
			local Vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = OtherPassport, Vehicle = Entity[2] })
			if Vehicle[1] then
				if Vehicle[1]["Arrest"] == 0 then
					TriggerClientEvent("emotes",source,"anotar")

					Player(source)["state"]["Buttons"] = true
					Player(source)["state"]["Cancel"] = true

					if vRP.Request(source,"Reboque","Tem certeza que deseja apreender o veículo de <b>"..vRP.FullName(Vehicle[1]["Passport"]).."</b>, placa <b>"..Vehicle[1]["Plate"].."</b>?") then
						vRP.Query("vehicles/arrestVehicles",{ Passport = OtherPassport, Vehicle = Entity[2] })
						TriggerClientEvent("Notify",source,"Departamento Policial","Veículo apreendido.","policia",5000)

						local OtherSource = vRP.Source(Vehicle[1]["Passport"])
						if OtherSource then
							vRPC.PlaySound(OtherSource,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
							TriggerClientEvent("Notify",OtherSource,"Departamento Policial","Seu veículo com a placa <b>"..Vehicle[1]["Plate"].."</b>, foi apreendido.","policia",5000)
						end
					end

					Player(source)["state"]["Buttons"] = false
					Player(source)["state"]["Cancel"] = false

					vRPC.Destroy(source)
				else
					TriggerClientEvent("Notify",source,"Departamento Policial","Veículo já se encontra apreendido.","policia",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:PLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Plate")
AddEventHandler("police:Plate",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasService(Passport,"Policia") then
		local Keyboard = vKEYBOARD.Primary(source,"Placa:")
		if Keyboard and Keyboard[1] then
			local OtherPassport = vRP.PassportPlate(Keyboard[1])
			if OtherPassport then
				local Identity = vRP.Identity(OtherPassport)
				if Identity then
					TriggerClientEvent("Notify", source, "Emplacamento", "<b>Passaporte:</b> "..Identity["id"].."<br><b>Telefone:</b> "..vRP.GetPhone(OtherPassport).."<br><b>Nome:</b> "..Identity["Name"].." "..Identity["Lastname"], "policia", 10000)
				end
			else
				TriggerClientEvent("Notify", source, "Emplacamento", "Nada encontrado.", "policia", 5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:FINES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Fines")
AddEventHandler("police:Fines", function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasService(Passport, "Policia") then
		local Keyboard = vKEYBOARD.Fines(source, "Passaporte:", "Valor da multa:", "Motivo da multa:")
		if Keyboard and Keyboard[1] and Keyboard[2] and Keyboard[3] then
			TriggerClientEvent("dynamic:Close", source)

			local targetPassport = tonumber(Keyboard[1])
			local fineAmount = tonumber(Keyboard[2])
			local fineReason = Keyboard[3]

			if targetPassport and fineAmount and fineAmount > 0 then
				local Identity = vRP.Identity(targetPassport)
				if Identity then
					local FullName = Identity["Name"] .. " " .. Identity["Lastname"]

					if vRP.Request(source, "Multar", "Você realmente deseja multar <b>" .. FullName .. "</b> no valor de <b>".. Currency .."" .. Dotted(fineAmount) .. "</b>?") then
						exports["bank"]:AddFines(targetPassport, targetPassport, fineAmount, fineReason)

						TriggerClientEvent("Notify", source, "Sucesso", "Você adicionou uma nova multa para <b>" .. FullName .. "</b>.", "verde", 5000)
					end
				else
					TriggerClientEvent("Notify", source, "Aviso", "Passaporte inválido.", "vermelho", 5000)
				end
			else
				TriggerClientEvent("Notify", source, "Aviso", "Os dados estão inválidos.", "vermelho", 5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Wanted")
AddEventHandler("police:Wanted", function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasService(Passport, "Policia") then
		local WantedValues = { "0", "1", "2", "3", "4", "5", "6" }
		local Keyboard = vKEYBOARD.Options(source, "Passaporte:", WantedValues)
		if Keyboard and Keyboard[1] and Keyboard[2] then
			TriggerClientEvent("dynamic:Close", source)

			local targetPassport = tonumber(Keyboard[1])
			local wantedLevel = tonumber(Keyboard[2])

			if targetPassport and wantedLevel and wantedLevel >= 0 and wantedLevel <= 6 then
				local Identity = vRP.Identity(targetPassport)
				if Identity then
					local FullName = Identity["Name"] .. " " .. Identity["Lastname"]

					vRP.UpdateWanted(targetPassport, wantedLevel, "Add")

					TriggerClientEvent("Notify", source, "Sucesso", "Você atualizou o status de procurado de <b>" .. FullName .. "</b>.", "verde", 5000)
				else
					TriggerClientEvent("Notify", source, "Aviso", "Passaporte inválido.", "vermelho", 5000)
				end
			else
				TriggerClientEvent("Notify", source, "Aviso", "Os dados estão inválidos.", "vermelho", 5000)
			end
		end
	end
end)