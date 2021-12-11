-- Player Viewmodel
function GM:CalcViewModelView(wep, vm, OldEyePos, OldEyeAng, EyePos, EyeAng)
	if not IsValid(wep) then return end

	local vm_origin, vm_angles = EyePos, EyeAng

	local func = wep.GetViewModelPosition
	if (func) then
		local pos, ang = func(wep, EyePos*1, EyeAng*1)
		vm_origin = pos or vm_origin
		vm_angles = ang or vm_angles
	end

	func = wep.CalcViewModelView
	if (func) then
		local pos, ang = func(wep, vm, OldEyePos*1, OldEyeAng*1, EyePos*1, EyeAng*1)
		vm_origin = pos or vm_origin
		vm_angles = ang or vm_angles
	end

	return vm_origin, vm_angles
end

function GM:PreDrawViewModel(vm, ply, wep)
	if not IsValid(wep) then
		return false
	end

	player_manager.RunClass(ply, "PreDrawViewModel", vm, wep)

	if (wep["PreDrawViewModel"] == nil) then
		return false
	end

	return wep:PreDrawViewModel(vm, wep, ply)
end

function GM:PostDrawViewModel(vm, ply, wep)
	if not IsValid(wep) then
		return false
	end

	if wep["UseHands"] or not wep:IsScripted() then
		local hands = ply:GetHands()
		if IsValid(hands) and IsValid(hands:GetParent()) then
			if not hook.Call("PreDrawPlayerHands", self, hands, vm, ply, wep) then
				if (wep.ViewModelFlip) then render.CullMode(MATERIAL_CULLMODE_CW) end
				hands:DrawModel()
				render.CullMode(MATERIAL_CULLMODE_CCW)
			end

			hook.Call("PostDrawPlayerHands", self, hands, vm, ply, wep)
		end
	end

	if (wep["PostDrawViewModel"] == nil) then
		return false
	end

	return wep:PostDrawViewModel(vm, wep, ply)
end