module("scripted_ents", package.seeall)

local Aliases = {}
Registered = {}

BaseClasses = {
	["anim"] = "base_anim",
	["point"] = "base_point",
	["brush"] = "base_brush",
	["filter"] = "base_filter"
}

local developer = GetConVar("developer"):GetInt()
timer.Simple(0, function()
	cvars.AddChangeCallback("developer", function(name, old, new)
		developer = tonumber(new)
	end)
end)

local function Log(...)
	if (developer > 0) then
		local tbl = {...}
		table.insert(tbl, "\n")
		Msg(unpack(tbl))
	end
end

--[[---------------------------------------------------------
	Name: TableInherit(tbl, base)
	Desc: Copies any missing data from base to tbl
-----------------------------------------------------------]]
local function TableInherit(tbl, base)
	for k, v in pairs(base) do
		if (tbl[k] == nil) then
			tbl[k] = v
		elseif (k != "BaseClass") and istable(tbl[k]) then
			TableInherit(tbl[k], v)
		end
	end

	tbl["BaseClass"] = base

	return tbl
end

--[[---------------------------------------------------------
	Name: IsBasedOn(class, base)
	Desc: Checks if class is based on base
-----------------------------------------------------------]]
function IsBasedOn(class, base)
	local tbl = GetStored(class)
	if not tbl then return false end
	if tbl["Base"] == class then return false end

	if tbl["Base"] == base then return true end
	return IsBasedOn(tbl["Base"], base)
end

function Register(tbl, class)
	assert(type(tbl) == "table", "bad argument #1 (table expected)")
	assert(type(class) == "string", "bad argument #2 (string expected)")

	if (hook.Run("PreRegisterSENT", tbl, class) == false) then
		Log('Hook "PreRegisterSENT" is blocked entity registration ("', class, '")')
		return
	end

	local base = tbl["Base"]
	if not base then
		base = BaseClasses[tbl["Type"]]
	end

	local old = Registered[class]
	local entity = {
		type		= tbl["Type"],
		tbl			= tbl,
		isBaseType	= true,
		Base		= base
	}

	entity["tbl"]["ClassName"] = class

	if not isstring(base) or (base == "") then
		Log("WARNING: Scripted entity " .. class .. " has an invalid base entity!\n")
	end

	Registered[class] = entity

	if not tbl["DisableDuplicator"] then
		duplicator.Allow(class)
	end

	if (old != nil) then
		for _, ent in ipairs(ents.GetAll()) do
			local ent_class = ent:GetClass()
			if IsBasedOn(ent_class, class) then
				table.Merge(ent, Get(ent_class))

				if isfunction(ent.OnReloaded) then
					ent:OnReloaded()
				end
			elseif (ent_class == class) then
				table.Merge(ent, entity["tbl"])

				if isfunction(ent.OnReloaded) then
					ent:OnReloaded()
				end
			end
		end
	end

	if (tbl["Spawnable"] == true) then
		list.Set("SpawnableEntities", class, {
			-- Required information
			PrintName		= tbl.PrintName,
			ClassName		= class,
			Category		= tbl.Category,

			-- Optional information
			NormalOffset	= tbl.NormalOffset,
			DropToFloor		= tbl.DropToFloor,
			Author			= tbl.Author,
			AdminOnly		= tbl.AdminOnly,
			Information		= tbl.Information,
			ScriptedEntityType = tbl.ScriptedEntityType,
			IconOverride	= tbl.IconOverride
		})
	end
end

function OnLoaded()
	for class, tbl in pairs(Registered) do
		baseclass.Set(class, Get(class))
	end
end

function Get(class, retval)
	-- Do we have an alias?
	if (Aliases[class]) then
		class = Aliases[class]
	end

	if (Registered[class] == nil) then
		return nil
	end

	-- Create/copy a new table
	local retval = retval or {}
	for k, v in pairs(Registered[class]["tbl"]) do
		if istable(v) then
			retval[k] = table.Copy(v)
		else
			retval[k] = v
		end
	end

	-- Derive from base class
	if (Registered[class]["Base"] != class) then
		local base = Get(Registered[class]["Base"])
		if not istable(base) then
			Log("ERROR: Trying to derive entity " .. tostring(class) .. " from non existant entity " .. tostring(Registered[class]["Base"]) .. "!\n")
		else
			retval = TableInherit(retval, base)
		end
	end

	return retval
end

function GetType(class)
	for type, base_class in pairs(BaseClasses) do
		if (class == base_class) then
			return type
		end
	end

	local ent = Registered[class]
	if (ent == nil) then
		return nil
	end

	local type = ent["type"]
	if isstring(type) and (type != "") then
		return type
	end

	local base = ent["Base"]
	if isstring(base) and (base != "") then
		return GetType(base)
	end

	return nil
end

--[[---------------------------------------------------------
	Name: GetStored(string)
	Desc: Gets the REAL sent table, not a copy
-----------------------------------------------------------]]
function GetStored(class)
	return Registered[class]
end

--[[---------------------------------------------------------
	Name: GetList(string)
	Desc: Get a list of all the registered SENTs
-----------------------------------------------------------]]
function GetList()
	local result = {}

	for class, tbl in pairs(Registered) do
		result[class] = tbl
	end

	return result
end

function GetSpawnable()
	local result = {}
	for k, v in pairs(Registered) do
		local tbl = v["tbl"]
		if istable(tbl) and (tbl.Spawnable == true) then
			table.insert(result, tbl)
		end
	end

	return result
end

function Alias(from, to)
	Aliases[from] = to
end

function GetMember(entity_name, membername)
	if not entity_name then return end

	local ent = Registered[entity_name]
	if (ent == nil) then return end

	local member = ent["tbl"][membername]
	if (member != nil) then return member end

	-- If our base is the same as us - don't infinite loop!
	if (entity_name == ent["Base"]) then return end

	return GetMember(ent["Base"], membername)
end