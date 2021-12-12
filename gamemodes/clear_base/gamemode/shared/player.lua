local constraint_GetAllConstrainedEntities = SERVER and constraint.GetAllConstrainedEntities
local player_manager_RunClass = player_manager.RunClass
local util_GetPlayerTrace = util.GetPlayerTrace
local IsConCommandBlocked = IsConCommandBlocked
local drive_FinishMove = drive.FinishMove
local drive_StartMove = drive.StartMove
local util_TraceLine = util.TraceLine
local gamemode_Call = gamemode.Call
local table_IsEmpty = table.IsEmpty
local table_remove = table.remove
local table_insert = table.insert
local drive_Start = drive.Start
local FrameNumber = FrameNumber
local drive_Move = drive.Move
local drive_End = drive.End
local hook_Add = hook.Add
local CurTime = CurTime
local IsValid = IsValid
local ipairs = ipairs

-- Gamemode
function GM:CreateTeams()
end

function GM:Move(ply, mv)
	if drive_Move(ply, mv) then
		return true
	end

	if player_manager_RunClass(ply, "Move", mv) then
		return true
	end
end

function GM:SetupMove(ply, mv, cmd)
	if drive_StartMove(ply, mv, cmd) then
		return true
	end

	if player_manager_RunClass(ply, "StartMove", mv, cmd) then
		return true
	end
end

function GM:FinishMove(ply, mv)
	if drive_FinishMove(ply, mv) then
		return true
	end

	if player_manager_RunClass(ply, "FinishMove", mv) then
		return true
	end
end

function GM:PlayerPostThink(ply)
end

function GM:KeyPress(ply, key)
end

function GM:KeyRelease(ply, key)
end

function GM:PlayerConnect(name, address)
end

function GM:PlayerFootstep(ply, pos, foot, sound, volume, CRF)
	if not IsValid(ply) or not ply:Alive() then
		return true
	end
end

function GM:StartEntityDriving(ent, ply)
	drive_Start(ply, ent)
end

function GM:EndEntityDriving(ent, ply)
	drive_End(ply, ent)
end

function GM:PlayerDriveAnimate(ply)
end

function GM:OnViewModelChanged(vm, old, new)
end

function GM:CanProperty(pl, property, ent)
	return false
end

-- Metatable
local PLAYER = FindMetaTable("Player")
function PLAYER:AddFrozenPhysicsObject(ent, phys)
	-- Get the player's table
	local tab = self:GetTable()

	-- Make sure the physics objects table exists
	tab["FrozenPhysicsObjects"] = tab["FrozenPhysicsObjects"] or {}

	table_insert(tab["FrozenPhysicsObjects"], {
		["ent"] = ent,
		["phys"] = phys
	})

	gamemode_Call("PlayerFrozeObject", self, ent, phys)
end

local function PlayerUnfreezeObject(ply, ent, object)
	-- Not frozen!
	if (object:IsMoveable()) then return 0 end

	-- Unfreezable means it can't be frozen or unfrozen.
	-- This prevents the player unfreezing the gmod_anchor entity.
	if (ent:GetUnFreezable()) then return 0 end

	-- NOTE: IF YOU'RE MAKING SOME KIND OF PROP PROTECTOR THEN HOOK "CanPlayerUnfreeze"
	if (!gamemode_Call("CanPlayerUnfreeze", ply, ent, object)) then return 0 end

	object:EnableMotion(true)
	object:Wake()

	gamemode_Call("PlayerUnfrozeObject", ply, ent, object)

	return 1
end

function PLAYER:PhysgunUnfreeze()
	-- Get the player's table
	local tab = self:GetTable()
	if (!tab["FrozenPhysicsObjects"]) then return 0 end

	-- Detect double click. Unfreeze all objects on double click.
	if (tab["LastPhysUnfreeze"] and CurTime() - tab["LastPhysUnfreeze"] < 0.25) then
		return self:UnfreezePhysicsObjects()
	end

	local tr = self:GetEyeTrace()
	if (tr["HitNonWorld"] and IsValid(tr["Entity"])) then
		local UnfrozenObjects = 0

		for _, ent in ipairs(constraint_GetAllConstrainedEntities(tr["Entity"])) do
			local objects = ent:GetPhysicsObjectCount()
			for i = 1, objects do
				local phys = ent:GetPhysicsObjectNum(i - 1)
				if IsValid(phys) then
					UnfrozenObjects = UnfrozenObjects + PlayerUnfreezeObject(self, ent, phys)
				end
			end
		end

		return UnfrozenObjects
	end

	tab["LastPhysUnfreeze"] = CurTime()

	return 0
end

function PLAYER:UnfreezePhysicsObjects()
	-- Get the player's table
	local tab = self:GetTable()

	-- If the table doesn't exist then quit here
	if (!tab["FrozenPhysicsObjects"]) then return 0 end

	local count = 0

	-- Loop through each table in our table
	for k, v in ipairs(tab["FrozenPhysicsObjects"]) do
		if IsValid(v["ent"]) then
			if (IsValid(v["phys"]) and not v["phys"]:IsMoveable()) then

				-- We need to freeze/unfreeze all physobj's in jeeps to stop it spazzing
				if (v["ent"]:GetClass() == "prop_vehicle_jeep") then
					-- How many physics objects we have
					local objects = v["ent"]:GetPhysicsObjectCount()

					-- Loop through each one
					for i = 0, (objects - 1) do
						local physobject = v["ent"]:GetPhysicsObjectNum(i)
						if IsValid(physobject) then
							PlayerUnfreezeObject(self, v["ent"], physobject)
						end
					end
				end

				count = count + PlayerUnfreezeObject(self, v["ent"], v["phys"])
			end
		end
	end

	-- Remove the table
	tab["FrozenPhysicsObjects"] = nil

	return count
end

local g_UniqueIDTable = {}
function PLAYER:UniqueIDTable(key)
	local id = 0

	if SERVER then
		id = self:UniqueID()
	end

	g_UniqueIDTable[id] = g_UniqueIDTable[id] or {}
	g_UniqueIDTable[id][key] = g_UniqueIDTable[id][key] or {}

	return g_UniqueIDTable[id][key]
end

function PLAYER:GetEyeTrace()
	if CLIENT then
		local framenum = FrameNumber()

		if (self.LastPlayerTrace == framenum) then
			return self.PlayerTrace
		end

		self.LastPlayerTrace = framenum
	end

	local tr = util_TraceLine(util_GetPlayerTrace(self))
	self.PlayerTrace = tr

	return tr
end

function PLAYER:GetEyeTraceNoCursor()
	if CLIENT then
		local framenum = FrameNumber()

		if (self.LastPlayerAimTrace == framenum) then
			return self.PlayerAimTrace
		end

		self.LastPlayerAimTrace = framenum
	end

	local tr = util_TraceLine(util_GetPlayerTrace(self, self:EyeAngles():Forward()))
	self.PlayerAimTrace = tr

	return tr
end

if CLIENT then
	if (PLAYER["OriginalConCommand"] == nil) then
		PLAYER["OriginalConCommand"] = PLAYER["ConCommand"]
	end

	local CommandList = nil
	local ply = nil

	function PLAYER:ConCommand(command, skip)
		if not IsValid(ply) then
			ply = self
		end

		if (skip == true) or IsConCommandBlocked(command) then
			self:OriginalConCommand(command)
		else
			CommandList = CommandList or {}
			table_insert(CommandList, command)
		end
	end

	hook_Add("Tick", "SendQueuedConsoleCommands", function()
		if (CommandList == nil) or (ply == nil) then return end

		local BytesSent = 0

		for num, cmd in ipairs(CommandList) do
			ply:OriginalConCommand(cmd)
			table_remove(CommandList, num)

			-- Only send x bytes per tick
			BytesSent = BytesSent + cmd:len()
			if (BytesSent > 128) then
				break
			end
		end

		if table_IsEmpty(CommandList) then
			CommandList = nil
		end
	end)
end