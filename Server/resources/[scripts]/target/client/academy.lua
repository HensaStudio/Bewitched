-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Index,v in pairs(Academy) do
		exports["target"]:AddCircleZone("Academy:"..Index,v["Target"],0.15,{
			name = "Academy:"..Index,
			heading = 0.0,
			useZ = true
		},{
			shop = Index,
			Distance = 1.75,
			options = {
				{
					event = "target:Academy",
					label = "Exercitar",
					tunnel = "client"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:ACADEMY
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("target:Academy", function(Number)
	if Academy[Number] and not GlobalState["Academy-"..Number] then
		local Ped = PlayerPedId()

		SetEntityHeading(Ped, Academy[Number]["Coords"]["w"])
		SetEntityCoords(Ped, Academy[Number]["Coords"]["xyz"])

		local Chance = math.random(1,100)
		if Chance <= 30 then
			vRP.Destroy()

			CreateThread(function()
				ApplyDamageToPed(Ped,10,true,false,true)
				SetPedToRagdoll(Ped,5000,5000,0,true,true,false)
				TriggerEvent("Notify","Aviso","Você se acidentou durante o treino e desmaiou.","blood",5000)
			end)

			return
		else
			if vSERVER.Academy(Number) then
				TriggerEvent("emotes", Academy[Number]["Anim"])

				TriggerEvent("Progress","Malhando",30000)

				SetTimeout(30000, function()
					vSERVER.AcademyWeight(Number)
					vRP.Destroy()
				end)
			end
		end
	end
end)