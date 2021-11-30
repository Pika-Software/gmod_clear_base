function GM:OnChatTab(str)
	str = string.TrimRight(str)

	local LastWord
	for word in string.gmatch(str, "[^ ]+") do
		LastWord = word
	end

	if (LastWord == nil) then return str end
	for _, ply in ipairs(player.GetAll()) do
		local nickname = ply:Nick()
		if (string.len(LastWord) < string.len(nickname) and string.find(string.lower(nickname), string.lower(LastWord), 0, true) == 1) then
			str = string.sub(str, 1, (string.len(LastWord) * -1) - 1)
			str = str .. nickname
			return str
		end
	end

	return str
end

function GM:StartChat(teamsay)
	return false
end

function GM:FinishChat()
end

function GM:ChatTextChanged(text)
end

function GM:ChatText(playerindex, playername, text, filter)
	if (filter == "chat") then
		Msg(playername, ": ", text, "\n")
	else
		Msg(text, "\n")
	end

	return false
end

function GM:OnPlayerChat(ply, text, isTeam, isDead)
	local tbl = {}

	if (isDead == true) then
		table.insert(tbl, Color(255, 30, 40))
		table.insert(tbl, "*DEAD* ")
	end

	if (isTeam == true) then
		table.insert(tbl, Color(30, 160, 40))
		table.insert(tbl, "(TEAM) ")
	end

	if IsValid(ply) then
		table.insert(tbl, ply)
	else
		table.insert(tbl, "Console")
	end

	table.insert(tbl, color_white)
	table.insert(tbl, ": " .. text)

	chat.AddText(unpack(tbl))

	return true
end

-- Achievements
function GM:OnAchievementAchieved(ply, achid)
	chat.AddText(ply, Color(230, 230, 230), " earned the achievement ", Color(255, 200, 0), achievements.GetName(achid))
end