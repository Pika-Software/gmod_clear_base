-- Overlay
function GM:DrawOverlay()
end

-- HUD
function GM:PreDrawHUD()
end

function GM:HUDPaintBackground()
end

function GM:HUDPaint()
end

function GM:PostDrawHUD()
end

function GM:HUDShouldDraw(name)
	-- local ply = LocalPlayer()
	-- if IsValid(ply) then
	-- 	local wep = ply:GetActiveWeapon()

	-- 	if IsValid(wep) and (wep["HUDShouldDraw"] != nil) then
	-- 		return wep.HUDShouldDraw(wep, name)
	-- 	end
	-- end

	return true
end

-- TargetID
function GM:HUDDrawTargetID()
end

-- Pickup HUD
function GM:HUDWeaponPickedUp(wep)
end

function GM:HUDItemPickedUp(itemname)
end

function GM:HUDAmmoPickedUp(itemname, amount)
end

function GM:HUDDrawPickupHistory()
end

-- Voice HUD
function GM:PlayerStartVoice(ply)
end

function GM:PlayerEndVoice(ply)
end

timer.Remove("VoiceClean")

hook.Remove("InitPostEntity", "CreateVoiceVGUI")

-- Death Notice
function GM:AddDeathNotice(att, team1, infl, ply, team2)
end

function GM:DrawDeathNotice(x, y)
end

-- Scoreboard
function GM:ScoreboardShow()
end

function GM:ScoreboardHide()
end

function GM:HUDDrawScoreBoard()
end

-- Screen Effects
function GM:RenderScreenspaceEffects()
end

-- VGUI
function GM:PostRenderVGUI()
end

-- Blur
function GM:GetMotionBlurValues(x, y, fwd, spin)
	return x, y, fwd, spin
end