local player_manager_SetPlayerClass = player_manager.SetPlayerClass
local util_NetworkIDToString = util.NetworkIDToString
local team_GetColor = team.GetColor

-- Team stuff (need to check probably not working)
function GM:ShowTeam()
end

function GM:HideTeam()
end

function GM:GetTeamColor(ent)
	return self:GetTeamNumColor((ent["Team"] == nil) and TEAM_UNASSIGNED or ent:Team())
end

function GM:GetTeamNumColor(num)
	return team_GetColor(num)
end

function GM:PlayerClassChanged(ply, newID)
	if (newID < 1) then return end

	local classname = util_NetworkIDToString(newID)
	if (classname == nil) then return end

	player_manager_SetPlayerClass(ply, classname)
end