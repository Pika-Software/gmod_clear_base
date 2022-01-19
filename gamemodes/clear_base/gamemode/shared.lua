local include = include

GM.Name 	= "Clear Base"
GM.Author 	= "Pika Software"
GM.Email 	= "prikolmen@pika-soft.ru"
GM.Website 	= "https://pika-soft.ru"

-- One little thing
GM.IsClearBaseDerived = true

--	//		Includes	//
include("shared/entity.lua")
include("shared/other.lua")
include("shared/player.lua")
include("shared/player_class/player_default.lua")
--	//					//

--	//		Engine		//
function GM:GetGameDescription()
	return self["Name"]
end

function GM:OnReloaded()
end

function GM:Restored()
end

function GM:Saved()
end

function GM:Tick()
end

--	//		Gamemode		//
function GM:PreGamemodeLoaded()
end

function GM:OnGamemodeLoaded()
end

function GM:PostGamemodeLoaded()
end