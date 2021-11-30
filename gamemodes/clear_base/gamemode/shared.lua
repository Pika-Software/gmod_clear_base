GM.Name 	= "Clear Base"
GM.Author 	= "Pika Software"
GM.Email 	= "prikolmen@pika-soft.ru"
GM.Website 	= "https://pika-soft.ru"

-- Engine
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

-- Gamemode
function GM:PreGamemodeLoaded()
end

function GM:OnGamemodeLoaded()
end

function GM:PostGamemodeLoaded()
end