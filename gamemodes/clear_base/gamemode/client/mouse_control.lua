-- Mouse
function GM:InputMouseApply(cmd, x, y, angle)
end

function GM:GUIMouseDoublePressed(code, AimVector)
	self:GUIMousePressed(code, AimVector)
end

function GM:AdjustMouseSensitivity(fDefault)
	local ply = LocalPlayer()
	if not IsValid(ply) then
		return -1
	end

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) then
		if (wep["AdjustMouseSensitivity"] == nil) then return -1 end
		return wep:AdjustMouseSensitivity()
	end

	return -1
end

function GM:GUIMousePressed(mousecode, AimVector)
end

function GM:GUIMouseReleased(mousecode, AimVector)
end

function GM:PreventScreenClicks(cmd)
	return false
end