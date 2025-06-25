-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hensa = {}
Tunnel.bindInterface("bank", Hensa)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Cooldown = 0
local AtmTimers = {}
local Explosives = {}
local NeedPolice = false
local ExplosiveTimers = {}
local NeedPoliceAmount = 2
local ExplosiveItem = "c4"
local NeedItem = "ssddrive"
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADACTIVES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if os.time() >= Cooldown then
			Cooldown = os.time() + 3600
			vRP.Query("investments/Actives")
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Check(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Number and Explosives[Number] then
			Explosives[Number] = nil

			local Coords = vRP.GetEntityCoords(source)
			TriggerClientEvent("Hensa:Explosion", source, Coords["x"], Coords["y"], Coords["z"], 2, 1.0, true, false, 1.0, true)

			TriggerClientEvent("Notify", source, "Aviso", "Este ATM estava sabotado.", "vermelho", 5000)

			return false
		end

		if not exports["hud"]:Reposed(Passport, source) and not exports["hud"]:Wanted(Passport, source) then
			local Consult = vRP.Query("characters/Person", { Passport = Passport })
			if Consult[1] and Consult[1]["Password"] == 0 then
				TriggerClientEvent("Notify", source, "Aviso", "Por segurança, crie uma senha de <b>4</b> a <b>20</b> números para acessar sua conta bancária.", "vermelho", 10000)

				if vRP.Request(source, "Banco", "Você deseja criar uma senha de acesso agora?") then
					local Keyboard = vKEYBOARD.Password(source, "Nova Senha")
					if Keyboard then
						local Password = sanitizeString(Keyboard[1],"0123456789")
						if string.len(Password) >= 4 and string.len(Password) <= 20 then
							vRP.Query("characters/BankPassword",{ Password = Password, Passport = Passport })
							TriggerClientEvent("Notify",source,"Sucesso","Senha atualizada.","verde",5000)
						else
							TriggerClientEvent("Notify",source,"Atenção","Necessário possuir entre <b>4</b> e <b>20</b> números.","amarelo",5000)
						end
					end
				end
			else
				local Keyboard = vKEYBOARD.Password(source,"Senha")
				if Keyboard then
					local BankAccess = vRP.Query("characters/BankAccess",{ Passport = Passport, Password = Keyboard[1] })
					if BankAccess[1] then
						return true
					else
						TriggerClientEvent("Notify",source,"Aviso","Senha incorreta.","vermelho",5000)
					end
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK:CHANGEPASSWORD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("bank:ChangePassword")
AddEventHandler("bank:ChangePassword",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end
	local Consult = vRP.Query("characters/Person", { Passport = Passport })
	if Consult[1] then
		local Keyboard = vKEYBOARD.Password(source, "Nova Senha")
		if Keyboard then
			local Password = sanitizeString(Keyboard[1],"0123456789")
			if string.len(Password) >= 4 and string.len(Password) <= 20 then
				vRP.Query("characters/BankPassword",{ Password = Password, Passport = Passport })
				TriggerClientEvent("Notify",source,"Sucesso","Senha atualizada.","verde",5000)
			else
				TriggerClientEvent("Notify",source,"Atenção","Necessário possuir entre <b>4</b> e <b>20</b> números.","amarelo",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK:SABOTAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("bank:Sabotage")
AddEventHandler("bank:Sabotage",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] then return end

	if Explosives[Number] then
		TriggerClientEvent("Notify",source,"Aviso","Este ATM já está sabotado.","vermelho",5000)
		return
	end

	if ExplosiveTimers[Number] and os.time() < ExplosiveTimers[Number] then
		TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(ExplosiveTimers[Number] - os.time())..".","amarelo",5000)
		return
	end

	if vRP.ConsultItem(Passport,ExplosiveItem,1) then
		if vRP.Request(source,"ATM","Você realmente deseja implementar uma <b>"..ItemName(ExplosiveItem).."</b> e causar uma <b>Explosão</b> quando alguém for <b>Abrir</b> o sistema neste <b>ATM</b>?") then
			Active[Passport] = true
			Player(source)["state"]["Buttons"] = true

			vRPC.PlayAnim(source,false,{"amb@medic@standing@tendtodead@idle_a","idle_a"},true)
			TriggerClientEvent("Progress", source, "Sabotando", 30000)

			ExplosiveTimers[Number] = os.time() + 3600

			SetTimeout(30000, function()
				if vRP.TakeItem(Passport,ExplosiveItem,1,true) then
					Explosives[Number] = true
					TriggerClientEvent("Notify",source,"Sucesso","ATM sabotado com sucesso.","verde",5000)
				end

				exports["vrp"]:CallPolice({
					Source = source,
					Passport = Passport,
					Permission = "Policia",
					Name = "Sabotagem de ATM",
					Wanted = 1800,
					Code = 31,
					Color = 22
				})

				vRPC.StopAnim(source)
				Active[Passport] = nil
				Player(source)["state"]["Buttons"] = false
			end)
		end
	else
		TriggerClientEvent("Notify",source,"Atenção","Você precisa de 1x "..ItemName(ExplosiveItem)..".","amarelo",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK:DISARM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("bank:Disarm")
AddEventHandler("bank:Disarm",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] then return end

	if vRP.HasGroup(Passport,"Policia") then
		if Explosives[Number] then
			Explosives[Number] = nil

			TriggerClientEvent("Notify",source,"Sucesso","Este ATM havia sido sabotado e você desativou com sucesso o sistema explosivo.","verde",5000)
		else
			TriggerClientEvent("Notify",source,"Aviso","Este ATM não está sabotado.","vermelho",5000)
		end
	else
		TriggerClientEvent("Notify",source,"Atenção","Você não tem permissões para isso.","amarelo",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Home()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Yield = 0
		local Identity = vRP.Identity(Passport)

		local InvestmentCheck = vRP.Query("investments/Check",{ Passport = Passport })
		if InvestmentCheck[1] then
			Yield = InvestmentCheck[1]["Monthly"]
		end

		return {
			["yield"] = Yield,
			["balance"] = Identity["Bank"],
			["transactions"] = Transactions(Passport)
		}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONHISTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.TransactionHistory()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		return Transactions(Passport,50)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Deposit(Valuation)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and parseInt(Valuation) > 0 then
		Active[Passport] = true

		if vRP.ConsultItem(Passport,DefaultMoneyOne,Valuation) and vRP.TakeItem(Passport,DefaultMoneyOne,Valuation) then
			vRP.GiveBank(Passport,Valuation,true)
		end

		Active[Passport] = nil

		return {
			["balance"] = vRP.Identity(Passport)["Bank"],
			["transactions"] = Transactions(Passport)
		}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Withdraw(Valuation)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and parseInt(Valuation) > 0 and not exports["bank"]:CheckFines(Passport) then
		Active[Passport] = true

		vRP.WithdrawCash(Passport,Valuation)

		Active[Passport] = nil

		return {
			["balance"] = vRP.Identity(Passport)["Bank"],
			["transactions"] = Transactions(Passport)
		}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Transfer(OtherPassport,Valuation)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and OtherPassport ~= Passport and parseInt(Valuation) > 0 and not exports["bank"]:CheckFines(Passport) then
		Active[Passport] = true

		if vRP.Identity(OtherPassport) and vRP.PaymentBank(Passport,Valuation,true) then
			vRP.GiveBank(OtherPassport,Valuation,true)
		end

		Active[Passport] = nil
	end

	return {
		["balance"] = vRP.Identity(Passport)["Bank"],
		["transactions"] = Transactions(Passport)
	}
end
----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Transactions(Passport,Limit)
	local Transaction = {}
	local TransactionList = vRP.Query("transactions/List",{ Passport = Passport, Limit = Limit or 4 })
	if TransactionList[1] then
		for _,v in pairs(TransactionList) do
			Transaction[#Transaction + 1] = {
				["type"] = v["Type"],
				["date"] = v["Date"],
				["value"] = v["Price"],
				["balance"] = v["Balance"]
			}
		end
	end

	return Transaction
end
----------------------------------------------------------------------------------------------------------------------------------------
-- FINES
-----------------------------------------------------------------------------------------------------------------------------------------
function Fines(Passport)
	local Fines = {}
	local FineList = vRP.Query("fines/List",{ Passport = Passport })
	if FineList[1] then
		for _,v in pairs(FineList) do
			Fines[#Fines + 1] = {
				["id"] = v["id"],
				["name"] = v["Name"],
				["value"] = v["Price"],
				["date"] = v["Date"],
				["hour"] = v["Hour"],
				["message"] = v["Message"]
			}
		end
	end

	return Fines
end
----------------------------------------------------------------------------------------------------------------------------------------
-- FINELIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.FineList()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		return Fines(Passport)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKFINES
-----------------------------------------------------------------------------------------------------------------------------------------
exports("CheckFines",function(Passport)
	if Passport and vRP.Query("fines/List",{ Passport = Passport })[1] then
		return true
	end

	return false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINEPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.FinePayment(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		local Fine = vRP.Query("fines/Check",{ Passport = Passport, id = Number })
		if Fine[1] then
			if vRP.PaymentBank(Passport,Fine[1]["Price"]) then
				vRP.Query("fines/Remove",{ Passport = Passport, id = Number })
				Active[Passport] = nil

				return true
			end
		end

		Active[Passport] = nil
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINEPAYMENTALL
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.FinePaymentAll()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		local FineList = vRP.Query("fines/List",{ Passport = Passport })
		if FineList[1] then
			for _,v in pairs(FineList) do
				if vRP.PaymentBank(Passport,v["Price"]) then
					vRP.Query("fines/Remove",{ Passport = Passport, id = v["id"] })
				end
			end
		end

		Active[Passport] = nil

		return Fines(Passport)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXS
-----------------------------------------------------------------------------------------------------------------------------------------
function Taxs(Passport)
	local Taxs = {}
	local TaxList = vRP.Query("taxs/List",{ Passport = Passport })
	if TaxList[1] then
		for _,v in pairs(TaxList) do
			Taxs[#Taxs + 1] = {
				["id"] = v["id"],
				["name"] = v["Name"],
				["value"] = v["Price"],
				["date"] = v["Date"],
				["hour"] = v["Hour"],
				["message"] = v["Message"]
			}
		end
	end

	return Taxs
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.TaxList()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		return Taxs(Passport)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.TaxPayment(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		local Tax = vRP.Query("taxs/Check",{ Passport = Passport, id = Number })
		if Tax[1] then
			if vRP.PaymentBank(Passport,Tax[1]["Price"]) then
				vRP.Query("taxs/Remove",{ Passport = Passport, id = Number })
				Active[Passport] = nil

				return true
			end
		end

		Active[Passport] = nil
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKTAXS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("CheckTaxs",function(Passport)
	if Passport and vRP.Query("taxs/List",{ Passport = Passport })[1] then
		return true
	end

	return false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICELIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.InvoiceList()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		return Invoices(Passport)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEINVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.MakeInvoice(OtherPassport,Valuation,Reason)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and OtherPassport ~= Passport and parseInt(Valuation) > 0 then
		Active[Passport] = true

		local OtherSource = vRP.Source(OtherPassport)
		if OtherSource then
			if vRP.Request(OtherSource,"Banco","<b>"..vRP.FullName(Passport).."</b> lhe enviou uma fatura de <b>"..Currency..""..Dotted(Valuation).."</b>, deseja aceita-la?") then
				vRP.Query("invoices/Add",{ Passport = OtherPassport, Received = Passport, Type = "received", Reason = Reason, Holder = vRP.FullName(Passport), Price = Valuation })
				vRP.Query("invoices/Add",{ Passport = Passport, Received = OtherPassport, Type = "sent", Reason = Reason, Holder = "Você", Price = Valuation })
				Active[Passport] = nil

				return Invoices(Passport)
			end
		end

		Active[Passport] = nil
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICEPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.InvoicePayment(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		local Invoice = vRP.Query("invoices/Check",{ id = Number })
		if Invoice[1] then
			if vRP.PaymentBank(Passport,Invoice[1]["Price"]) then
				vRP.GiveBank(Invoice[1]["Received"],Invoice[1]["Price"],true)
				vRP.Query("invoices/Remove",{ id = Number })
				Active[Passport] = nil

				return true
			end
		end

		Active[Passport] = nil
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICES
-----------------------------------------------------------------------------------------------------------------------------------------
function Invoices(Passport)
	local Invoices = {}
	local InvoiceList = vRP.Query("invoices/List",{ Passport = Passport })
	if InvoiceList[1] then
		for _,v in pairs(InvoiceList) do
			local Type = v["Type"]

			if not Invoices[Type] then
				Invoices[Type] = {}
			end

			Invoices[Type][#Invoices[Type] + 1] = {
				["id"] = v["id"],
				["reason"] = v["Reason"],
				["holder"] = v["Holder"],
				["value"] = v["Price"]
			}
		end
	end

	return Invoices
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Investments()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Total,Brute,Liquid,Deposit = 0,0,0,0
		local InvestmentCheck = vRP.Query("investments/Check",{ Passport = Passport })
		if InvestmentCheck[1] then
			Total = InvestmentCheck[1]["Deposit"] + InvestmentCheck[1]["Liquid"]
			Brute = InvestmentCheck[1]["Deposit"]
			Liquid = InvestmentCheck[1]["Liquid"]
			Deposit = InvestmentCheck[1]["Deposit"]
		end

		return {
			["total"] = Total,
			["brute"] = Brute,
			["liquid"] = Liquid,
			["deposit"] = Deposit
		}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Invest(Valuation)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and parseInt(Valuation) > 0 then
		Active[Passport] = true

		if vRP.PaymentBank(Passport,Valuation) then
			local InvestmentCheck = vRP.Query("investments/Check",{ Passport = Passport })
			if InvestmentCheck[1] then
				vRP.Query("investments/Invest",{ Passport = Passport, Price = Valuation })
			else
				vRP.Query("investments/Add",{ Passport = Passport, Deposit = Valuation })
			end

			Active[Passport] = nil

			return true
		end

		Active[Passport] = nil
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTRESCUE
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.InvestRescue()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		local InvestmentCheck = vRP.Query("investments/Check",{ Passport = Passport })
		if InvestmentCheck[1] then
			local Valuation = InvestmentCheck[1]["Deposit"] + InvestmentCheck[1]["Liquid"]
			vRP.Query("investments/Remove",{ Passport = Passport })
			vRP.GiveBank(Passport,Valuation,true)
		end

		Active[Passport] = nil
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTAXS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddTaxs",function(Passport,source,Name,Valuation,Message)
	if vRP.UserPremium(Passport) then
		local Hierarchy = vRP.GetUserHierarchy(Passport,"Premium")
		if Hierarchy == 1 then
			Valuation = Valuation * 0.0125
		elseif Hierarchy == 2 then
			Valuation = Valuation * 0.0250
		else
			Valuation = Valuation * 0.0375
		end
	else
		Valuation = Valuation * 0.05
	end

	vRP.Query("taxs/Add",{ Passport = Passport, Name = Name, Date = os.date("%d/%m/%Y"), Hour = os.date("%H:%M"), Price = parseInt(Valuation), Message = Message })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTRANSACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddTransactions",function(Passport,Type,Valuation)
	vRP.Query("transactions/Add",{ Passport = Passport, Type = Type, Date = os.date("%d/%m/%Y"), Price = Valuation, Balance = vRP.GetBank(Passport) })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDFINES
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddFines",function(Passport,OtherPassport,Valuation,Message)
	vRP.Query("fines/Add",{ Passport = Passport, Name = vRP.FullName(OtherPassport), Date = os.date("%d/%m/%Y"), Hour = os.date("%H:%M"), Price = Valuation, Message = Message })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK:EXPLODEATM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("bank:ExplodeAtm")
AddEventHandler("bank:ExplodeAtm",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] then return end

	if NeedPolice and vRP.AmountService("Policia") < NeedPoliceAmount then
		TriggerClientEvent("Notify",source,"Atenção","Contingente indisponível.","amarelo",5000)
		return
	end

	if AtmTimers[Number] and os.time() < AtmTimers[Number] then
		TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(AtmTimers[Number] - os.time())..".","amarelo",5000)
		return
	end

	if vRP.ConsultItem(Passport,NeedItem,1) then
		local Coords = vRP.GetEntityCoords(source)

		Active[Passport] = true
		Player(source)["state"]["Buttons"] = true

		if not vRP.Safecrack(source,1) then
			TriggerClientEvent("Hensa:Explosion",source,Coords.x,Coords.y,Coords.z,2,1.0,true,false,1.0,true)
			Active[Passport] = nil
			Player(source)["state"]["Buttons"] = false
			return
		end

		vRPC.PlayAnim(source, false, { "mini@repair", "fixing_a_player" }, true)
		TriggerClientEvent("Progress", source, "Vasculhando", 20000)

		AtmTimers[Number] = os.time() + 3600

		SetTimeout(10000, function()
			if math.random(100) >= 95 then
				TriggerClientEvent("Notify",source,"Polícia","Um segurança foi acionado.","policia",5000)
				TriggerClientEvent("bank:SpawnSecurity",source)
			end

			exports["vrp"]:CallPolice({
				Source = source,
				Passport = Passport,
				Permission = "Policia",
				Name = "Explosão de ATM",
				Wanted = 1800,
				Code = 31,
				Color = 22
			})
		end)

		SetTimeout(20000, function()
			if vRP.TakeItem(Passport,NeedItem,1,true) then
				TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","roxo",5000)
				exports["inventory"]:Drops(Passport,source,DefaultMoneyTwo,math.random(275,550))
				TriggerClientEvent("player:Residual",source,"Resquício de Línter")
				vRP.UpgradeStress(Passport,5)

				TriggerClientEvent("Hensa:Explosion",source,Coords.x,Coords.y,Coords.z,70,1.0,true,false,1.0,true)
			end

			vRPC.StopAnim(source)
			Active[Passport] = nil
			Player(source)["state"]["Buttons"] = false
		end)
	else
		TriggerClientEvent("Notify",source,"Atenção","Você precisa de 1x "..ItemName(NeedItem)..".","amarelo",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Taxs",Taxs)
exports("Fines",Fines)
exports("Invoices",Invoices)
exports("Dependents",Dependents)
exports("Transactions",Transactions)