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
Tunnel.bindInterface("hud", Hensa)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Work"] = 0
GlobalState["Points"] = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIME
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Hours"] = 07
GlobalState["Minutes"] = 30
-----------------------------------------------------------------------------------------------------------------------------------------
-- SOUTH
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["TemperatureS"] = 20
GlobalState["WeatherS"] = "EXTRASUNNY"
-----------------------------------------------------------------------------------------------------------------------------------------
-- NORTH
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["TemperatureN"] = 22
GlobalState["WeatherN"] = "EXTRASUNNY"
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUBOS
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Roubos"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local function updateTemperature(weather, temperature, minTemp, maxTemp)
		local change = math.random(2)
		local currentTemp = GlobalState[temperature]

		if math.random(100) >= 50 then
			currentTemp = math.min(currentTemp + change, maxTemp)
		else
			currentTemp = math.max(currentTemp - change, minTemp)
		end

		GlobalState[temperature] = currentTemp
	end

	local function isWeatherType(weather, types)
		for _, w in ipairs(types) do
			if GlobalState[weather] == w then
				return true
			end
		end

		return false
	end

	local sunnyWeathers = { "EXTRASUNNY", "CLEAR", "SMOG", "CLEARING", "NEUTRAL" }
	local cloudyWeathers = { "CLOUDS", "FOGGY", "OVERCAST", "RAIN", "THUNDER", "SNOW", "BLIZZARD", "SNOWLIGHT", "XMAS" }

	while true do
		local work = GlobalState["Work"]
		local points = GlobalState["Points"]
		local minutes = GlobalState["Minutes"]

		work = work + 1
		points = points + 1
		minutes = minutes + 1

		GlobalState["Work"] = work
		GlobalState["Points"] = points
		GlobalState["Minutes"] = minutes

		if points >= 30 then
			if math.random(100) >= 50 then
				if isWeatherType("WeatherS", sunnyWeathers) then
					updateTemperature("WeatherS", "TemperatureS", 10, 40)
				end

				if isWeatherType("WeatherN", sunnyWeathers) then
					updateTemperature("WeatherN", "TemperatureN", 5, 35)
				end
			else
				if isWeatherType("WeatherS", cloudyWeathers) then
					updateTemperature("WeatherS", "TemperatureS", 10, 40)
				end

				if isWeatherType("WeatherN", cloudyWeathers) then
					updateTemperature("WeatherN", "TemperatureN", 5, 35)
				end
			end

			GlobalState["Points"] = 0
		end

		if minutes >= 60 then
			GlobalState["Hours"] = (GlobalState["Hours"] + 1) % 24
			GlobalState["Minutes"] = 0

			if GlobalState["Hours"] == 0 then
				repeat
					local randWeather = math.random(#WeatherListS)
				until GlobalState["WeatherS"] ~= WeatherListS[randWeather]

				GlobalState["WeatherS"] = WeatherListS[randWeather]
				GlobalState["TemperatureS"] = 18

				repeat
					local randWeather = math.random(#WeatherListN)
				until GlobalState["WeatherN"] ~= WeatherListN[randWeather]

				GlobalState["WeatherN"] = WeatherListN[randWeather]
				GlobalState["TemperatureN"] = 22

				GlobalState["Roubos"] = "Sul e Norte"
			end

			if GlobalState["Hours"] >= 7 then
				GlobalState["Roubos"] = false
			end
		end

		Wait(10000)
	end
end)