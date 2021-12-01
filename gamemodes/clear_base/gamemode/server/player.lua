function GM:DoPlayerDeath(ply, attacker, dmginfo)
	ply:CreateRagdoll()
	ply:AddDeaths(1)

	if (attacker:IsValid() and attacker:IsPlayer()) then
		if (attacker == ply) then
			attacker:AddFrags(-1)
		else
			attacker:AddFrags(1)
		end
	end
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	return true
end

function GM:PlayerHurt(player, attacker, healthleft, healthtaken)
end

function GM:PlayerAuthed(ply, SteamID, UniqueID)
end

function GM:PlayerCanPickupWeapon(ply, ent)
	return true
end

function GM:PlayerCanPickupItem(ply, ent)
	return true
end

function GM:CanPlayerUnfreeze(ply, ent, phys)
	return true
end

function GM:PlayerDisconnected(ply)
end

function GM:PlayerSay(ply, text, isTeam)
	return text
end

function GM:PlayerDeathThink(ply)
	ply:Spawn()
end

function GM:PlayerUse(ply, ent)
	return true
end

function GM:PlayerSilentDeath(ply)
end

function GM:PlayerDeath(ply, infl, att)
	if IsValid(att) and (att:GetClass() == "trigger_hurt") then
		att = ply
	end

	if IsValid(att) and att:IsVehicle() and IsValid(att:GetDriver()) then
		att = att:GetDriver()
	end

	if not IsValid(infl) and IsValid(att) then
		infl = att
	end

	if IsValid(infl) and (infl == att) and (infl:IsPlayer() or infl:IsNPC()) then
		infl = infl:GetActiveWeapon()
		if not IsValid(infl) then
			infl = att
		end
	end

	player_manager.RunClass(ply, "Death", infl, att)

	MsgAll(ply:Nick() .. " was killed by " .. att:GetClass() .. "\n")
end

function GM:PlayerInitialSpawn(ply, transiton)
	ply:SetTeam(TEAM_UNASSIGNED)
end

function GM:PlayerSpawnAsSpectator(ply)
	ply:StripWeapons()

	if (ply:Team() == TEAM_UNASSIGNED) then
		ply:Spectate(OBS_MODE_FIXED)
		return
	end

	ply:SetTeam(TEAM_SPECTATOR)
	ply:Spectate(OBS_MODE_ROAMING)
end

function GM:PlayerSpawn(ply, transiton)
	local tm = ply:Team()
	if (tm == TEAM_SPECTATOR) or (tm == TEAM_UNASSIGNED) then
		self:PlayerSpawnAsSpectator(ply)
		return
	end

	ply:UnSpectate()
	ply:SetupHands()

	player_manager.OnPlayerSpawn(ply, transiton)
	player_manager.RunClass(ply, "Spawn")

	if not transiton then
		hook.Call("PlayerLoadout", GAMEMODE, ply)
	end

	hook.Call("PlayerSetModel", GAMEMODE, ply)
end

function GM:PlayerSetModel(ply)
	player_manager.RunClass(ply, "SetModel")
end

function GM:PlayerSetHandsModel(ply, ent)
	local info = player_manager.RunClass(ply, "GetHandsModel")
	if not info then
		info = player_manager.TranslatePlayerHands(player_manager.TranslateToPlayerModelName(ply:GetModel()))
	end

	if info then
		ent:SetModel(info["model"])
		ent:SetSkin(info["skin"])
		ent:SetBodyGroups(info["body"])
	end
end

function GM:PlayerLoadout(ply)
	player_manager.RunClass(ply, "Loadout")
end

function GM:IsSpawnpointSuitable(ply, ent, killPlayers)
	local pos = ent:GetPos()

	if (ply:Team() == TEAM_SPECTATOR) then return true end

	local blockers = 0
	for _, pl in ipairs(ents.FindInBox(pos + Vector(-16, -16, 0), pos + Vector(16, 16, 64))) do
		if IsValid(pl) and (pl != ply) and pl:IsPlayer() and pl:Alive() then
			blockers = blockers + 1

			if killPlayers then
				pl:Kill()
			end
		end
	end

	if not killPlayers and (blockers > 0) then
		return false
	end

	return true
end

function GM:PlayerSelectSpawn(ply, transiton)
	if transiton then return end

	if not IsTableOfEntitiesValid(self["SpawnPoints"]) then

		self["LastSpawnPoint"] = 0
		self["SpawnPoints"] = ents.FindByClass("info_player_start")
		self["SpawnPoints"] = table.Add(self["SpawnPoints"], ents.FindByClass("info_player_deathmatch"))
		self["SpawnPoints"] = table.Add(self["SpawnPoints"], ents.FindByClass("info_player_combine"))
		self["SpawnPoints"] = table.Add(self["SpawnPoints"], ents.FindByClass("info_player_rebel"))

		-- CS Maps
		self["SpawnPoints"] = table.Add(self["SpawnPoints"], ents.FindByClass("info_player_counterterrorist"))
		self["SpawnPoints"] = table.Add(self["SpawnPoints"], ents.FindByClass("info_player_terrorist"))

		-- (Old) GMod Maps
		self["SpawnPoints"] = table.Add(self["SpawnPoints"], ents.FindByClass("gmod_player_start"))
	end

	local count = table.Count(self["SpawnPoints"])
	if (count == 0) then
		Msg("[PlayerSelectSpawn] Error! No spawn points!\n")
		return nil
	end

	for _, ent in ipairs(self["SpawnPoints"]) do
		if ent:HasSpawnFlags(1) and hook.Call("IsSpawnpointSuitable", GAMEMODE, ply, ent, true) then
			return ent
		end
	end

	local ChosenSpawnPoint = nil

	-- Try to work out the best, random spawnpoint
	for i = 1, count do
		ChosenSpawnPoint = table.Random(self["SpawnPoints"])

		if (IsValid(ChosenSpawnPoint) and ChosenSpawnPoint:IsInWorld()) then
			if ((ChosenSpawnPoint == ply:GetVar("LastSpawnpoint") or ChosenSpawnPoint == self["LastSpawnPoint"]) and count > 1) then continue end

			if (hook.Call("IsSpawnpointSuitable", GAMEMODE, ply, ChosenSpawnPoint, i == count)) then
				self["LastSpawnPoint"] = ChosenSpawnPoint
				ply:SetVar("LastSpawnpoint", ChosenSpawnPoint)

				return ChosenSpawnPoint
			end
		end
	end

	return ChosenSpawnPoint
end

function GM:WeaponEquip(weapon)
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
end

function GM:PlayerDeathSound()
	return false
end

function GM:SetupPlayerVisibility(pPlayer, pViewEntity)
	--AddOriginToPVS(vector_position_here)
end

function GM:OnDamagedByExplosion(ply, dmginfo)
	ply:SetDSP(35, false)
end

function GM:CanPlayerSuicide(ply)
	return true
end

function GM:CanPlayerEnterVehicle(ply, vehicle, role)
	return true
end

function GM:PlayerEnteredVehicle(ply, vehicle, role)
end

function GM:CanExitVehicle(vehicle, passenger)
	return true
end

function GM:PlayerLeaveVehicle(ply, vehicle)
end

function GM:PlayerSwitchFlashlight(ply, SwitchOn)
	return ply:CanUseFlashlight()
end

function GM:PlayerJoinTeam(ply, teamid)
end

function GM:PlayerSpray(ply)
	return false
end

function GM:OnPlayerHitGround(ply, bInWater, bOnFloater, flFallSpeed)
end

function GM:GetFallDamage(ply, flFallSpeed)
	return (flFallSpeed - 526.5) * (100 / 396)
end

function GM:PlayerCanSeePlayersChat(text, isTeam, listener, speaker)
	if isTeam then
		if IsValid(speaker) and IsValid(listener) then
			return speaker:Team() == listener:Team()
		end

		return false
	end

	return true
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
	return true, true
end

function GM:NetworkIDValidated(name, steamid)
	-- MsgN("GM:NetworkIDValidated", name, steamid)
end

function GM:PlayerShouldTaunt(ply, actid)
	return true
end

function GM:PlayerStartTaunt(ply, actid, length)
end

function GM:AllowPlayerPickup(ply, object)
	return true
end

function GM:PlayerDroppedWeapon(ply, weapon)
end

function GM:PlayerButtonDown(ply, btn) end
function GM:PlayerButtonUp(ply, btn) end