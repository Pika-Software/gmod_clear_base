-- Vehicle
function GM:VehicleMove(ply, vehicle, mv)
end

-- Player Movement
function GM:CreateMove(cmd)
	if drive.CreateMove(cmd) then
		return true
	end

	if player_manager.RunClass(LocalPlayer(), "CreateMove", cmd) then
		return true
	end
end

-- Binds
function GM:PlayerBindPress(ply, bind, down)
	return false
end