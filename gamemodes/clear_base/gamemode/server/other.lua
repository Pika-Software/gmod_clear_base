-- Entity
function GM:EntityTakeDamage(ent, info)
end

function GM:CreateEntityRagdoll(entity, ragdoll)
end

-- Password
function GM:CheckPassword(steamid64, ip, server_pass, pass, nick)
	if (server_pass != "") and (server_pass != pass) then
		return false
	end

	return true
end

-- Vehicle
function GM:VehicleMove(ply, vehicle, mv)
	if mv:KeyPressed(IN_DUCK) and vehicle["SetThirdPersonMode"] then
		vehicle:SetThirdPersonMode(!vehicle:GetThirdPersonMode())
	end

	local iWheel = ply:GetCurrentCommand():GetMouseWheel()
	if (iWheel != 0) and vehicle["SetCameraDistance"] then
		local newdist = math.Clamp(vehicle:GetCameraDistance() - iWheel * 0.03 * (1.1 + vehicle:GetCameraDistance()), -1, 10)
		vehicle:SetCameraDistance(newdist)
	end
end

-- Undo
function GM:PreUndo(undo)
	return false
end

function GM:PostUndo(undo, count)
end

-- VariableEdit
function GM:VariableEdited(ent, ply, key, val, editor)
	if not IsValid(ent) or not IsValid(ply) then return end
	if not hook.Run("CanEditVariable", ent, ply, key, val, editor) then return end

	ent:EditValue(key, val)
end

function GM:CanEditVariable(ent, ply, key, val, editor)
	return false
end

-- NPC
function GM:OnNPCKilled(ent, att, infl)
end

function GM:ScaleNPCDamage(npc, hitgroup, dmg)
end

-- PhysGun
function GM:OnPhysgunFreeze(weapon, phys, ent, ply)
	if not phys:IsMoveable() or ent:GetUnFreezable() then
		return false
	end

	phys:EnableMotion(false)
	ply:AddFrozenPhysicsObject(ent, phys)

	return true
end

function GM:OnPhysgunReload(weapon, ply)
	ply:PhysgunUnfreeze()
end

-- GravityGun
function GM:GravGunOnPickedUp(ply, ent)
end

function GM:GravGunOnDropped(ply, ent)
end

-- Remove stupid stuff
timer.Remove("HostnameThink")

-- Team stuff (need to check probably not working)
function GM:ShowTeam(ply)
end