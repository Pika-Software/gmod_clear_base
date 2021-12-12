local player_manager_RunClass = player_manager.RunClass
local drive_CalcView = drive.CalcView
local util_TraceHull = util.TraceHull
local hook_Run = hook.Run
local IsValid = IsValid
local Vector = Vector
local Angle = Angle

local blockedHullEnts = {
	["prop_physics"] = true,
	["prop_dynamic"] = true,
	["prop_ragdoll"] = true,
	["phys_bone_follower"] = true,
}

function GM:CalcVehicleView(veh, ply, view)
	if (veh["GetThirdPersonMode"] == nil) or (ply:GetViewEntity() != ply) then
		return
	end

	if not veh:GetThirdPersonMode() then
		return view
	end

	local mn, mx = veh:GetRenderBounds()
	local radius = (mn - mx):Length()
	local radius = radius + radius * veh:GetCameraDistance()

	local TargetOrigin = view["origin"] + (view["angles"]:Forward() * -radius)
	local WallOffset = 4

	local tr = util_TraceHull({
		start = view["origin"],
		endpos = TargetOrigin,
		filter = function(ent)
			return blockedHullEnts[ent:GetClass()] or ent:IsVehicle()
		end,
		mins = Vector(-WallOffset, -WallOffset, -WallOffset),
		maxs = Vector(WallOffset, WallOffset, WallOffset),
	})

	view["origin"] = tr["HitPos"]
	view["drawviewer"] = true

	if (tr["Hit"] and !tr["StartSolid"]) then
		view["origin"] = view["origin"] + tr["HitNormal"] * WallOffset
	end

	return view
end

function GM:CalcView(ply, origin, angles, fov, znear, zfar)
	local view = {
		["origin"] = origin,
		["angles"] = angles,
		["fov"] = fov,
		["znear"] = znear,
		["zfar"] = zfar,
		["drawviewer"] = false,
	}

	local veh = ply:GetVehicle()
	if IsValid(veh) then
		return hook_Run("CalcVehicleView", veh, ply, view)
	end

	if drive_CalcView(ply, view) then
		return view
	end

	player_manager_RunClass(ply, "CalcView", view)

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) then
		if (wep["CalcView"] == nil) then return view end

		local origin, angles, fov = wep:CalcView(ply, Vector(view["origin"]), Angle(view["angles"]), view["fov"])
		view["origin"], view["angles"], view["fov"] = origin or view["origin"], angles or view["angles"], fov or view["fov"]
	end

	return view
end