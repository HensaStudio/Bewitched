-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadModel(Hash)
	if type(Hash) == "string" then
		Hash = GetHashKey(Hash)
	end

	if not IsModelInCdimage(Hash) or not IsModelValid(Hash) then
		return false
	end

	RequestModel(Hash)
	local Looping = GetGameTimer()
	while not HasModelLoaded(Hash) do
		Wait(100)

		if GetGameTimer() - Looping > 1000 then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadAnim(Dict)
	if HasAnimDictLoaded(Dict) then
		return true
	end

	RequestAnimDict(Dict)
	local Looping = GetGameTimer()
	while not HasAnimDictLoaded(Dict) do
		Wait(100)

		if GetGameTimer() - Looping > 1000 then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADTEXTURE
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadTexture(Library)
	if HasStreamedTextureDictLoaded(Library) then
		return true
	end

	local Looping = GetGameTimer()
	RequestStreamedTextureDict(Library,false)
	while not HasStreamedTextureDictLoaded(Library) do
		Wait(100)

		if GetGameTimer() - Looping > 1000 then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADMOVEMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadMovement(Library)
	if HasAnimSetLoaded(Library) then
		return true
	end

	RequestAnimSet(Library)
	local Looping = GetGameTimer()
	while not HasAnimSetLoaded(Library) do
		Wait(100)

		if GetGameTimer() - Looping > 1000 then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADPTFXASSET
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadPtfxAsset(Library)
	if HasNamedPtfxAssetLoaded(Library) then
		return true
	end

	RequestNamedPtfxAsset(Library)
	local Looping = GetGameTimer()
	while not HasNamedPtfxAssetLoaded(Library) do
		Wait(100)

		if GetGameTimer() - Looping > 1000 then
			return false
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADNETWORK
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadNetwork(Network)
	local Looping = GetGameTimer() + 1000
	while not NetworkDoesNetworkIdExist(Network) and GetGameTimer() <= Looping do
		Wait(1)
	end

	if NetworkDoesNetworkIdExist(Network) then
		local Object = NetToEnt(Network)

		if DoesEntityExist(Object) then
			Looping = GetGameTimer() + 1000
			NetworkRequestControlOfEntity(Object)
			while not NetworkHasControlOfEntity(Object) and GetGameTimer() <= Looping do
				NetworkRequestControlOfEntity(Object)
				Wait(1)
			end

			Looping = GetGameTimer() + 1000
			SetEntityAsMissionEntity(Object,true,true)
			while not IsEntityAMissionEntity(Object) and GetGameTimer() <= Looping do
				SetEntityAsMissionEntity(Object,true,true)
				Wait(1)
			end

			return Object,ObjToNet(Object)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckPolice()
	return LocalPlayer["state"]["LSPD"] or LocalPlayer["state"]["PBPD"] or LocalPlayer["state"]["SSPD"] or LocalPlayer["state"]["PRPD"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKGANG
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckGang()
	return LocalPlayer["state"]["Ballas"] or LocalPlayer["state"]["Vagos"] or LocalPlayer["state"]["Families"]
end