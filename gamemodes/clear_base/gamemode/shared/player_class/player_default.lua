local PLAYER = {
    ["DisplayName"] = "Default Class",

    -- Boolean
    ["TeammateNoCollide"] = true,
    ["CanUseFlashlight"] = true,
    ["DropWeaponOnDie"] = false,
    ["AvoidPlayers"] = true,
    ["UseVMHands"] = true,

    -- Health & Armor
    ["StartHealth"] = 100,
    ["MaxHealth"] = 100,

    ["StartArmor"] = 0,
    ["MaxArmor"]  = 100,

    -- Movement Speed (Walk & Run & Sprint)
    ["SlowWalkSpeed"] = 200,
    ["WalkSpeed"] = 400,
    ["RunSpeed"] = 600,

    -- Jump Hight
    ["JumpPower"] = 200,

    -- Speed Multipliers
    ["CrouchedWalkSpeed"] = 0.3,
    ["UnDuckSpeed"] = 0.3,
    ["DuckSpeed"] = 0.3
}

function PLAYER:SetupDataTables()
end

function PLAYER:Init()
end

if SERVER then

    -- Server
    function PLAYER:Spawn()
    end

    function PLAYER:Loadout()
        self["Player"]:Give("weapon_pistol")
        self["Player"]:GiveAmmo(255, "Pistol", true)
    end

    function PLAYER:SetModel()
        local cl_playermodel = self["Player"]:GetInfo("cl_playermodel")
        local modelname = player_manager.TranslatePlayerModel(cl_playermodel)
        util.PrecacheModel(modelname)
        self["Player"]:SetModel(modelname)

        print("modelname", modelname)
    end

    function PLAYER:Death(inflictor, attacker)
    end
else

    -- Client
    function PLAYER:CalcView(view)
    end

    function PLAYER:CreateMove(cmd)
    end

    function PLAYER:ShouldDrawLocal()
    end
end

-- Movement
function PLAYER:StartMove(cmd, mv)
end

function PLAYER:Move(mv)
end

function PLAYER:FinishMove(mv)
end

-- Viewmodel
function PLAYER:ViewModelChanged(vm, old, new)
end

function PLAYER:PreDrawViewModel(vm, weapon)
end

function PLAYER:PostDrawViewModel(vm, weapon)
end

-- Hands
function PLAYER:GetHandsModel()
	local playermodel = player_manager.TranslateToPlayerModelName(self["Player"]:GetModel())
	return player_manager.TranslatePlayerHands(playermodel)
    -- return { model = "models/weapons/c_arms_cstrike.mdl", skin = 1, body = "0100000" }
end

player_manager.RegisterClass("player_default", PLAYER)