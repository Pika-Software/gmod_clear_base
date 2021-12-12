local timer_Remove = timer.Remove
local hook_Remove = hook.Remove
local LocalPlayer = LocalPlayer
local hook_Add = hook.Add
local hook_Run = hook.Run
local IsValid = IsValid

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

-- // PlayerInit
local localPlayer = nil
hook_Add("RenderScene", "FirstFrames", function()
	hook_Remove("RenderScene", "FirstFrames")
	localPlayer = LocalPlayer()
	hook_Run("PlayerInitialized", localPlayer)
end)
-- //

function GM:HUDShouldDraw(name)
	if (localPlayer == nil) then return true end

	local wep = localPlayer:GetActiveWeapon()
	if IsValid(wep) then
		if (wep["HUDShouldDraw"] == nil) then return true end
		return wep:HUDShouldDraw(name)
	end

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

-- Voice HUD ( better not turn it off )

/*
	function GM:PlayerStartVoice(ply)
	end

	function GM:PlayerEndVoice(ply)
	end

	timer_Remove("VoiceClean")

	hook_Remove("InitPostEntity", "CreateVoiceVGUI")
*/

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