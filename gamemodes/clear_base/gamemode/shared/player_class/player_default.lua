local player_manager_TranslateToPlayerModelName = player_manager.TranslateToPlayerModelName
local player_manager_TranslatePlayerModel = player_manager.TranslatePlayerModel
local player_manager_TranslatePlayerHands = player_manager.TranslatePlayerHands
local player_manager_RegisterClass = player_manager.RegisterClass
local util_PrecacheModel = util.PrecacheModel

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
        local modelname = player_manager_TranslatePlayerModel(self["Player"]:GetInfo("cl_playermodel"))
        util_PrecacheModel(modelname)
        self["Player"]:SetModel(modelname)
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
function PLAYER:PreDrawViewModel(vm, weapon)
end

function PLAYER:PostDrawViewModel(vm, weapon)
end

-- Hands
function PLAYER:GetHandsModel()
	return player_manager_TranslatePlayerHands(player_manager_TranslateToPlayerModelName(self["Player"]:GetModel()))
    -- return { model = "models/weapons/c_arms_cstrike.mdl", skin = 1, body = "0100000" }
end

player_manager_RegisterClass("player_default", PLAYER)