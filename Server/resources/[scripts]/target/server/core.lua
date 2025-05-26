-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Hensa = {}
Tunnel.bindInterface("target", Hensa)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Calls = {}
local Workout = {}
local Announces = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
for Number,_ in pairs(Academy) do
	GlobalState["Academy-"..Number] = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMY
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.Academy(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not GlobalState["Academy-"..Number] and not Workout[Passport] then
		Player(source)["state"]["Buttons"] = true
		Player(source)["state"]["Cancel"] = true
		GlobalState["Academy-"..Number] = true
		Workout[Passport] = Number

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMYWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.AcademyWeight(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Academy-"..Number] and Workout[Passport] == Number then
		local MaxWeight = 72
		if vRP.GetWeight(Passport) < MaxWeight then
			vRP.SetWeight(Passport,2)
			vRP.UpgradeStress(Passport,2)
			vRP.DowngradeThirst(Passport,2)
			TriggerClientEvent("Notify",source,"Academia","Sinto minha força alcançando novos patamares, não há limites quando se trata de determinação e dedicação.","verde",5000)
		end

		Player(source)["state"]["Buttons"] = false
		Player(source)["state"]["Cancel"] = false
		GlobalState["Academy-"..Number] = false
		Workout[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Hensa.CheckIn()
	local Return = false
	local source = source
	local Alimentation = false
	local Valuation,Reposed = 1000,1200
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.UserPremium(Passport) then
			Valuation,Reposed = 500,600
		end

		if vRP.Request(source,"Centro Médico","Deseja adicionar o serviço de alimentação pagando <b>"..Currency..""..Dotted(500).." "..ItemName(DefaultMoneyOne).."</b>?") then
			Valuation = Valuation + 500
			Alimentation = true
		end

		if vRP.GetHealth(source) <= 100 then
			Valuation = Valuation + 500
			Reposed = Reposed + 600
		end

		if vRP.PaymentFull(Passport,Valuation) then
			if Alimentation then
				vRP.UpgradeThirst(Passport,25)
				vRP.UpgradeHunger(Passport,25)
			end

			TriggerEvent("Reposed",source,Passport,Reposed)
			Return = true
		else
			TriggerClientEvent("Notify",source,"Aviso","<b>"..ItemName(DefaultMoneyOne).."</b> insuficientes.","vermelho",5000)
		end
	end

	return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:ANNOUNCES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Announces")
AddEventHandler("target:Announces", function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Announces[Service] then
			Announces[Service] = os.time()
		end

		if os.time() >= Announces[Service] then
			if Service == "Policia" then
				if vRP.HasGroup(Passport, "Policia") then
					Announces[Service] = os.time() + 600
					TriggerClientEvent("Notify", -1, "Los Santos Police Department", "Sinta-se seguro(a) agora mesmo, pois há policiais realizando patrulhas em nossa cidade neste exato instante.", "policia", 15000)
				else
					TriggerClientEvent("Notify", source, "Aviso", "Você não pode enviar um anúncio.", "vermelho", 5000)
				end
			elseif Service == "Paramedico" then
				if vRP.HasGroup(Passport, "Paramedico") then
					Announces[Service] = os.time() + 600
					TriggerClientEvent("Notify", -1, "Pillbox Medical Center", "Estamos em busca de doadores de sangue, seja solidário e ajude o próximo, procure um de nossos profissionais.", "hospital", 15000)
				else
					TriggerClientEvent("Notify", source, "Aviso", "Você não pode enviar um anúncio.", "vermelho", 5000)
				end
			elseif Service == "Mecanico" then
				if vRP.HasGroup(Passport, "Mecanico") then
					Announces[Service] = os.time() + 600
					TriggerClientEvent("Notify", -1, "Los Santos Customs", "Necessita dos serviços de uma oficina mecânica? Temos profissionais disponíveis. Faça agora mesmo a sua solicitação.", "mechanic", 15000)
				else
					TriggerClientEvent("Notify", source, "Aviso", "Você não pode enviar um anúncio.", "vermelho", 5000)
				end
			else
				if vRP.HasGroup(Passport, Service) then
					Announces[Service] = os.time() + 600
					TriggerClientEvent("Notify", -1, "Anúncio de "..Service.."", "Estamos em busca de trabalhadores, compareça ao estabelecimento, procure um de nossos funcionários e consulte nosso serviço de entregas.", "announcement", 15000)
				else
					TriggerClientEvent("Notify", source, "Aviso", "Você não pode enviar um anúncio.", "vermelho", 5000)
				end
			end
		else
			local Cooldown = parseInt(Announces[Service] - os.time())
			TriggerClientEvent("Notify", source, "Anúncios", "Aguarde <b>"..Cooldown.."</b> segundos.", "azul", 5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:CALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Call")
AddEventHandler("target:Call", function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	local Identity = vRP.Identity(Passport)
	if Passport and Identity then
		if not Calls[Service] then
			Calls[Service] = os.time()
		end

		if os.time() >= Calls[Service] then
			local Group,Total = vRP.NumPermission(Service)
			if Total == 0 then
				TriggerClientEvent("Notify",source,"Atenção","O serviço selecionado no momento está inativo.","amarelo",5000)
			else
				local CallPrice = 55
				if vRP.Request(source, "Emergência", "Você realmente deseja ligar para <b>"..Service.."</b> por <b>"..Currency..""..Dotted(CallPrice).." "..ItemName(DefaultMoneyOne).."</b>?") then
					TriggerClientEvent("emotes", source, "ligar")

					local Keyboard = vKEYBOARD.Area(source,"Qual o motivo do chamado?")
					if Keyboard then
						if vRP.PaymentFull(Passport,CallPrice) then
							local Coords = vRP.GetEntityCoords(source)
							local Permission = vRP.NumPermission(Service)
							for Passports,Sources in pairs(Permission) do
								async(function()
									TriggerClientEvent("NotifyPush",Sources,{ code = 20, phone = Identity["Phone"], title = "Chamado de " .. Identity["Name"] .. " " .. Identity["Lastname"], text = Keyboard[1], x = Coords["x"], y = Coords["y"], z = Coords["z"], time = "Recebido às " .. os.date("%H:%M"), blipColor = 2 })
								end)
							end

							exports["bank"]:AddTaxs(Passport,source,"Prefeitura",CallPrice,"Telefone Coletivo.")

							Calls[Service] = os.time() + 350
						else
							TriggerClientEvent("Notify",source,"Aviso","<b>"..ItemName(DefaultMoneyOne).."</b> insuficientes.","vermelho",5000)
						end
					end

					vRPC.Destroy(source, "one")
				end
			end
		else
			local Cooldown = CompleteTimers(Calls[Service] - os.time())
			TriggerClientEvent("Notify", source, "Prefeitura", "Aguarde <b>"..Cooldown.."</b> segundos.", "azul", 5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Reposed")
AddEventHandler("target:Reposed",function(OtherSource)
	local source = source
	local Passport = vRP.Passport(source)
	local OtherPassport = vRP.Passport(OtherSource)
	local Keyboard = vKEYBOARD.Primary(source,"Minutos.")
	if Passport and OtherPassport and Keyboard and parseInt(Keyboard[1]) > 0 then
		TriggerClientEvent("Notify",source,"Centro Médico","Adicionou "..Keyboard[1].." minutos de repouso.","hospital",5000)
		TriggerEvent("Reposed",OtherSource,OtherPassport,parseInt(Keyboard[1]) * 60)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:SERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Service")
AddEventHandler("target:Service",function(Permission)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,Permission) then
		vRP.ServiceToggle(source,Passport,Permission,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Workout[Passport] then
		GlobalState["Academy-"..Workout[Passport]] = false
		Workout[Passport] = nil
	end
end)