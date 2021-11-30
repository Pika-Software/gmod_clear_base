-- Team stuff (need to check probably not working)
function GM:ShowTeam()
end

function GM:HideTeam()
end

function GM:GetTeamColor(ent)
	return self:GetTeamNumColor((ent["Team"] == nil) and TEAM_UNASSIGNED or ent:Team())
end

function GM:GetTeamNumColor(num)
	return team.GetColor(num)
end

function GM:PlayerClassChanged(ply, newID)
	if (newID < 1) then return end

	local classname = util.NetworkIDToString(newID)
	if (!classname) then return end

	player_manager.SetPlayerClass(ply, classname)
end