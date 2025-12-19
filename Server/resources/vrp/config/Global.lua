-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
CombatLogMinutes = 3 -- segundos para entrar em combatlog
SalarySeconds = 1800 -- tempo do salário
SpawnCoords = vec3(-1039.47,-2739.57,12.85) -- coordenada padrão de spawn ao criar um personagem
UnprisonCoords = vec3(1896.15,2604.44,45.75) -- coordenada padrão de saida da prisão
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETTINGS
-----------------------------------------------------------------------------------------------------------------------------------------
BaseMode = "license" -- license ou steam
ServerName = "Hensa" -- nome do servidor
UsingLbPhone = false -- se você usa ou não o LB-Phone
UsableF7 = true -- mostrar id encima das cabeças
Whitelisted = true -- whitelist no servidor
ServerLink = "https://Hensa.site" -- link de sua preferência
GiveIdentity = true -- dar o item identidade ao criar um personagem
ShakeVehicleCamera = true -- balançar a câmera do personagem quando bater o veículo
NewItemIdentity = true -- para dar uma identidade única quando criar o personagem
CanPushCars = false -- se você pode empurrar veículos presisonando a letra Q
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCE
-----------------------------------------------------------------------------------------------------------------------------------------
Maintenance = false -- true para ativar a manutenção
MaintenanceLicenses = { -- licenses que podem entrar no servidor durante a manutenção
	["8d0038693c8d128014fb22709c06f122822d5bf1"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTS
-----------------------------------------------------------------------------------------------------------------------------------------
BannedText = "Banido" -- texto de banimento
ReleaseText = "Efetue sua liberação enviando o seu número de whitelist" -- texto de liberação da whitelist
UnprisonText = "Você ganhou a liberdade da <b>Prisão</b>." -- texto de quando a prisão de alguém é limpa
MaintenanceText = "Servidor em manutenção" -- texto de quando o servidor está em manutenção
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
Currency = "R$" -- prefixo que será mostrado
DefaultMoneyOne = "dollar" -- dinheiro padrão
DefaultMoneyTwo = "dirtydollar" -- dinheiro sujo
DefaultMoneyThree = "wetdollar" -- dinheiro sujo especial
DefaultMoneySpecial = "gemstone" -- dinheiro especial premium
-----------------------------------------------------------------------------------------------------------------------------------------
-- BACKPACK
-----------------------------------------------------------------------------------------------------------------------------------------
ClothesBackpack = true -- ativa ou desativa as mochilas equiparem roupas
WipeBackpackDeath = false -- limpar inventário ao morrer
CleanNormalInventory = true -- limpar inventário ao dar /gg
ClearPremiumInventory = true -- limpar inventário de premiums ao dar /gg
DefaultBackpackPremium = 30 -- peso padrão do inventário Premium
DefaultBackpackNormal = 15 -- peso padrão do inventário
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNGER / THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
ConsumeHunger = 2 -- 2% de fome por minuto
ConsumeThirst = 2 -- 2% de sede por minuto
CooldownHungerThrist = 45000 -- tempo de ciclo
-- 45000 ms = 45 segundos (1 minuto)
-- Isso faz com que a fome e a sede zerem em 50 minutos (~45 min de jogo real, considerando pausas e interações)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEME
-----------------------------------------------------------------------------------------------------------------------------------------
Theme = { -- configuração das cores do tema
	["currency"] = Currency,
	["main"] = "#7552d0",
	["common"] = "#6fc66a",
	["rare"] = "#6ac6c5",
	["epic"] = "#c66a75",
	["legendary"] = "#c6986a",
	["accept"] = {
		["letter"] = "#dcffe9",
		["background"] = "#3fa466"
	},
	["reject"] = {
		["letter"] = "#ffe8e8",
		["background"] = "#ad4443"
	},
	["shadow"] = true,
	["main-text"] = "#ffffff",
	["loading"] = {
		["mode"] = "dark", -- [ Opções disponíveis: dark,light ],
		["model"] = 2, -- [ Opções disponíveis: 1,2 ],
		["progress"] = true -- [ Opções disponíveis: true, false ],
	},
	["chat"] = {
		["Admin"] = {
			["background"] = "#E4E76E",
			["letter"] = "#ffffff"
		},
		["Premium"] = {
			["background"] = "#c6986a",
			["letter"] = "#ffffff"
		},
		["Policia"] = {
			["background"] = "#5865f2",
			["letter"] = "#ffffff"
		},
		["Paramedico"] = {
			["background"] = "#5865f2",
			["letter"] = "#ffffff"
		},
		["Mecanico"] = {
			["background"] = "#5865f2",
			["letter"] = "#ffffff"
		},
		["Restaurante"] = {
			["background"] = "#5865f2",
			["letter"] = "#ffffff"
		},
		["Ballas"] = {
			["background"] = "#A66FED",
			["letter"] = "#ffffff"
		},
		["Vagos"] = {
			["background"] = "#5865f2",
			["letter"] = "#ffffff"
		},
		["Families"] = {
			["background"] = "#5865f2",
			["letter"] = "#ffffff"
		},
		["Aztecas"] = {
			["background"] = "#5865f2",
			["letter"] = "#ffffff"
		},
		["Bloods"] = {
			["background"] = "#5865f2",
			["letter"] = "#ffffff"
		}
	},
	["hud"] = {
		["modes"] = {
			["info"] = 1, -- [ Opções disponíveis: 1,2,3 ]
			["icon"] = "fill", -- [ Opções disponíveis: fill,line ]
			["status"] = 4, -- [ Opções disponíveis: 1,2,3,4,5,6,7,8,9,10,11,12 ]
			["vehicle"] = 2 -- [ Opções disponíveis: 1,2,3 ]
		},
		["percentage"] = true,
		["icons"] = "#FFFFFF",
		["nitro"] = "#f69d2a",
		["rpm"] = "#FFFFFF",
		["fuel"] = "#f94c54",
		["engine"] = "#ff4c55",
		["health"] = "#76B984",
		["armor"] = "#A66FED",
		["hunger"] = "#F4B266",
		["thirst"] = "#5da1f8",
		["stress"] = "#E287C9",
		["luck"] = "#F18A7C",
		["dexterity"] = "#E4E76E",
		["repose"] = "#7FCCC7",
		["pointer"] = "#ef4444",
		["progress"] = {
			["background"] = "#FFFFFF",
			["circle"] = "#5da1f8",
			["letter"] = "#FFFFFF"
		}
	},
	["notifyitem"] = {
		["add"] = {
			["letter"] = "#dcffe9",
			["background"] = "#3fa466"
		},
		["remove"] = {
			["letter"] = "#ffe8e8",
			["background"] = "#ad4443"
		}
	},
	["pause"] = {
		["premium"] = true,
		["store"] = true,
		["battlepass"] = false,
		["boxes"] = true,
		["marketplace"] = true,
		["skinweapon"] = false,
		["map"] = true,
		["settings"] = true,
		["disconnect"] = true
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERITENS
-----------------------------------------------------------------------------------------------------------------------------------------
CharacterItens = { -- itens que são dados ao criar um personagem
	["cellphone"] = 1,
	["radio"] = 1,
	["hamburger"] = 4,
	["soda"] = 4
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
GroupBlips = { -- serviços com blips em tempo real
	["LSPD"] = true,
	["PBPD"] = true,
	["SSPD"] = true,
	["PRPD"] = true,
	["Mecanico"] = true,
	["Paramedico"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLIENTSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
ClientState = { -- playerstate das permissões
	["Admin"] = true,
	["LSPD"] = true,
	["PBPD"] = true,
	["SSPD"] = true,
	["PRPD"] = true,
	["Mecanico"] = true,
	["Paramedico"] = true,
	["Arriba"] = true,
	["BurgerShot"] = true,
	["Taxi"] = true,
	["Premium"] = true,
	["Ballas"] = true,
	["Vagos"] = true,
	["Families"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LANG
-----------------------------------------------------------------------------------------------------------------------------------------
Lang = { -- configuração de idioma da fila
	["Join"] = "Entrando...",
	["Connecting"] = "Conectando...",
	["Position"] = "Você é o %d/%d da fila, aguarde sua conexão",
	["Error"] = "Conexão perdida."
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUEUE
-----------------------------------------------------------------------------------------------------------------------------------------
Queue = { -- configuração da fila
	["List"] = {},
	["Players"] = {},
	["Counts"] = 0,
	["Connecting"] = {},
	["Threads"] = 0,
	["Max"] = 2048
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- F7
-----------------------------------------------------------------------------------------------------------------------------------------
UseF7 = { -- ids que podem usar o f7
	[1] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INDEX
-----------------------------------------------------------------------------------------------------------------------------------------
GeneratePlateIndex = "DDLLLDDD"
GeneratePhoneIndex = "DDD-DDD"
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOPINIT
-----------------------------------------------------------------------------------------------------------------------------------------
SkinshopInit = {
	["mp_m_freemode_01"] = {
		["pants"] = { item = 4, texture = 1 },
		["arms"] = { item = 0, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 273, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["shoes"] = { item = 1, texture = 6 },
		["mask"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["hat"] = { item = -1, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 }
	},
	["mp_f_freemode_01"] = {
		["pants"] = { item = 4, texture = 1 },
		["arms"] = { item = 14, texture = 0 },
		["tshirt"] = { item = 3, texture = 0 },
		["torso"] = { item = 338, texture = 2 },
		["vest"] = { item = 0, texture = 0 },
		["shoes"] = { item = 1, texture = 6 },
		["mask"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["hat"] = { item = -1, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["decals"] = { item = 0, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBERSHOPINIT
-----------------------------------------------------------------------------------------------------------------------------------------
BarbershopInit = {
	["mp_m_freemode_01"] = { 13,25,0,3,0,-1,-1,-1,-1,13,38,38,0,0,0,0,0.5,0,0,1,0,10,1,0,1,0.5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
	["mp_f_freemode_01"] = { 13,25,1,3,0,-1,-1,-1,-1,1,38,38,0,0,0,0,1,0,0,1,0,0,0,0,1,0.5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
}