function net.ReceiveRemove( name )
	net.Receivers[ name:lower() ] = nil
end

do

	local list_GetForEdit = list.GetForEdit
	local ipairs = ipairs

	function list.Remove( name, key )
		local tbl = list_GetForEdit( name )
		if (key == nil) then
			for key, value in ipairs( tbl ) do
				tbl[ key ] = nil
			end
		else
			tbl[ key ] = nil
		end
	end

end

local gm = GAMEMODE or GM or {}
if gm.IsClearBaseDerived then
	for key, value in pairs( net.Receivers ) do
    	net.Receivers[ key ] = nil
	end
end