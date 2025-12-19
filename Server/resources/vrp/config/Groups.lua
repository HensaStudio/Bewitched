-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
Groups = {
	-- Permissões
	["Admin"] = {
		["Permission"] = {
			["Admin"] = true
		},
		["Hierarchy"] = { "Administrador", "Moderador", "Suporte" },
		["Service"] = {},
		["Client"] = true,
		["Chat"] = true
	},

	-- Trabalhos
	-- Los Santos Police Department
	["LSPD"] = {
		["Permission"] = {
			["LSPD"] = true
		},
		["Hierarchy"] = { "Comandante", "Capitão", "Tenente", "Sargento", "Oficial", "Cadete" },
		["Salary"] = { 2500, 2250, 2000, 1750, 1500, 1500 },
		["Service"] = {},
		["Type"] = "Work",
		["Client"] = true,
		["Chat"] = true,
		["Disconnect"] = true
	},
	-- Paleto Bay Police Department
	["PBPD"] = {
		["Permission"] = {
			["PBPD"] = true
		},
		["Hierarchy"] = { "Xerife", "Tenente", "Sargento", "Oficial", "Cadete" },
		["Salary"] = { 2500, 2250, 2000, 1750, 1500 },
		["Service"] = {},
		["Type"] = "Work",
		["Client"] = true,
		["Chat"] = true,
		["Disconnect"] = true
	},
	-- Sandy Shores Police Department
	["SSPD"] = {
		["Permission"] = {
			["SSPD"] = true
		},
		["Hierarchy"] = { "Xerife", "Tenente", "Sargento", "Oficial", "Cadete" },
		["Salary"] = { 2500, 2250, 2000, 1750, 1500 },
		["Service"] = {},
		["Type"] = "Work",
		["Client"] = true,
		["Chat"] = true,
		["Disconnect"] = true
	},
	-- Park Ranger Police Department
	["PRPD"] = {
		["Permission"] = {
			["PRPD"] = true
		},
		["Hierarchy"] = { "Chefe", "Fiscal", "Sargento", "Patrulheiro", "Aspirante", "Estagiário" },
		["Salary"] = { 2500, 2250, 2000, 1750, 1500, 1500 },
		["Service"] = {},
		["Type"] = "Work",
		["Client"] = true,
		["Chat"] = true,
		["Disconnect"] = true
	},
	["Paramedico"] = {
		["Permission"] = {
			["Paramedico"] = true
		},
		["Hierarchy"] = { "Chefe", "Médico", "Enfermeiro", "Residente" },
		["Salary"] = { 6050, 6050, 4000, 4000 },
		["Service"] = {},
		["Type"] = "Work",
		["Client"] = true,
		["Chat"] = true,
		["Disconnect"] = true
	},
	["Mecanico"] = {
		["Permission"] = {
			["Mecanico"] = true
		},
		["Hierarchy"] = { "Chefe", "Mecânico", "Borracheiro", "Estagiário" },
		["Salary"] = { 2500, 2250, 2000, 1750 },
		["Service"] = {},
		["Type"] = "Work",
		["Client"] = true,
		["Chat"] = true,
		["Disconnect"] = true
	},
	["Arriba"] = {
		["Permission"] = {
			["Arriba"] = true
		},
		["Hierarchy"] = { "Chefe", "Supervisor", "Funcionário" },
		["Salary"] = { 2250, 2000, 1750 },
		["Service"] = {},
		["Type"] = "Work",
		["Client"] = true,
		["Disconnect"] = true
	},
	["BurgerShot"] = {
		["Permission"] = {
			["BurgerShot"] = true
		},
		["Hierarchy"] = { "Chefe", "Supervisor", "Funcionário" },
		["Salary"] = { 2250, 2000, 1750 },
		["Service"] = {},
		["Type"] = "Work",
		["Client"] = true,
		["Disconnect"] = true
	},
	["Taxi"] = {
		["Permission"] = {
			["Taxi"] = true
		},
		["Hierarchy"] = { "Motorista"},
		["Service"] = {},
		["Type"] = "Work"
	},

	-- Premium
	["Premium"] = {
		["Permission"] = {
			["Premium"] = true
		},
		["Hierarchy"] = { "Ouro", "Prata", "Bronze" },
		["Salary"] = { 10000, 5000, 2500 },
		["Service"] = {},
		["Type"] = "Premium",
		["Client"] = true,
		["Chat"] = true
	},

	-- Gangs
	["Ballas"] = {
		["Permission"] = {
			["Ballas"] = true
		},
		["Hierarchy"] = { "Líder", "Sub-Líder", "Membro", "Recruta" },
		["Service"] = {},
		["Type"] = "Work",
		["Name"] = "Ballas",
		["Client"] = true,
		["Chat"] = true
	},
	["Vagos"] = {
		["Permission"] = {
			["Vagos"] = true
		},
		["Hierarchy"] = { "Líder", "Sub-Líder", "Membro", "Recruta" },
		["Service"] = {},
		["Type"] = "Work",
		["Name"] = "Los Santos Vagos",
		["Client"] = true,
		["Chat"] = true
	},
	["Families"] = {
		["Permission"] = {
			["Families"] = true
		},
		["Hierarchy"] = { "Líder", "Sub-Líder", "Membro", "Recruta" },
		["Service"] = {},
		["Type"] = "Work",
		["Name"] = "The Families",
		["Client"] = true,
		["Chat"] = true
	},

	-- Grupos
	["Emergencia"] = {
		["Permission"] = {
			["LSPD"] = true,
			["PBPD"] = true,
			["SSPD"] = true,
			["PRPD"] = true,
			["Paramedico"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},
	["Policia"] = {
		["Permission"] = {
			["LSPD"] = true,
			["PBPD"] = true,
			["SSPD"] = true,
			["PRPD"] = true,
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},
	["Gangs"] = {
		["Permission"] = {
			["Ballas"] = true,
			["Vagos"] = true,
			["Families"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},
	["Restaurante"] = {
		["Permission"] = {
			["Arriba"] = true,
			["BurgerShot"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},

	-- Sistema
	["Buff"] = {
		["Permission"] = {
			["Buff"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Salary"] = { 2250 },
		["Service"] = {}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function GroupsList()
	return Groups
end