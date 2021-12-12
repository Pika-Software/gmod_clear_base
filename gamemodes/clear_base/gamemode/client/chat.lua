local achievements_GetName = CLIENT and achievements.GetName
local chat_AddText = CLIENT and chat.AddText
local string_TrimRight = string.TrimRight
local string_gmatch = string.gmatch
local player_GetAll = player.GetAll
local string_lower = string.lower
local table_insert = table.insert
local string_find = string.find
local string_sub = string.sub
local string_len = string.len
local IsValid = IsValid
local unpack = unpack
local ipairs = ipairs
local Color = Color
local Msg = Msg

function GM:OnChatTab(str)
	str = string_TrimRight(str)

	local LastWord
	for word in string_gmatch(str, "[^ ]+") do
		LastWord = word
	end

	if (LastWord == nil) then return str end
	for _, ply in ipairs(player_GetAll()) do
		local nickname = ply:Nick()
		if (string_len(LastWord) < string_len(nickname) and string_find(string_lower(nickname), string_lower(LastWord), 0, true) == 1) then
			str = string_sub(str, 1, (string_len(LastWord) * -1) - 1)
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
		table_insert(tbl, Color(255, 30, 40))
		table_insert(tbl, "*DEAD* ")
	end

	if (isTeam == true) then
		table_insert(tbl, Color(30, 160, 40))
		table_insert(tbl, "(TEAM) ")
	end

	if IsValid(ply) then
		table_insert(tbl, ply)
	else
		table_insert(tbl, "Console")
	end

	table_insert(tbl, color_white)
	table_insert(tbl, ": " .. text)

	chat_AddText(unpack(tbl))

	return true
end

-- Achievements
function GM:OnAchievementAchieved(ply, achid)
	chat_AddText(ply, Color(230, 230, 230), " earned the achievement ", Color(255, 200, 0), achievements_GetName(achid))
end