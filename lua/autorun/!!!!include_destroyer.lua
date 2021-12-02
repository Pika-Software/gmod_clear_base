function net.ReceiveRemove(name)
	net["Receivers"][name:lower()] = nil
end

function list.Remove(name, key)
	local tbl = list.GetForEdit(name)
	if (key == nil) then
		for k, _ in ipairs(tbl) do
			tbl[k] = nil
		end
	else
		tbl[key] = nil
	end
end

local gm = GAMEMODE or GM or {}
if gm["Clear_Base"] then
	for k, _ in pairs(net["Receivers"]) do
    	net["Receivers"][k] = nil
	end
end