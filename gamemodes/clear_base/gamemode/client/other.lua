-- PhysGun
function GM:DrawPhysgunBeam(ply, wep, bOn, target, boneid, pos)
	return true
end

-- Remove Spawnmenu Binds
concommand.Remove("+menu")
concommand.Remove("-menu")

concommand.Remove("+menu_context")
concommand.Remove("-menu_context")