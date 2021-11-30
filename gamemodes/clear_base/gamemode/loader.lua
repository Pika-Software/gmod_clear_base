local debug_getregistry = debug.getregistry
local string_EndsWith = string_EndsWith
local AddCSLuaFile = AddCSLuaFile
local file_Find = file.Find
local isstring = isstring
local include = include
local assert = assert
local unpack = unpack
local ipairs = ipairs
local type = type

if (SafeInclude == nil) then
    function SafeInclude(fileName)
        assert(type(fileName) == "string", "bad argument #1 (string expected)")

        local errorHandler = debug_getregistry()[1]
        local lastError
        debug_getregistry()[1] = function(err)
            lastError = err
            return err
        end

        local args = { include(fileName) }
        debug_getregistry()[1] = errorHandler

        if lastError then
            return false, lastError
        else
            return true, unpack(args)
        end
    end
end

local function getPath(dir, fl)
	if isstring(dir) then
		if isstring(fl) then
			if not string_EndsWith(dir, "/") then
				dir = dir .. "/"
			end
		else
			return false
		end
	elseif not isstring(fl) then
		return false
	end

	return (dir or "") .. (fl or "")
end

if SERVER then
    local function LoadServer(dir)
        dir = dir .. "/"
        local files, folders = file_Find(dir .. "*", "LUA")

        for _, fl in ipairs(files) do
            if string_EndsWith(fl, ".lua") then
                local path = getPath(dir, fl)
                assert(path, "Invalid path returned")

                SafeInclude(path)
            end
        end

        for _, fol in ipairs(folders) do
            LoadServer(dir .. fol, tag)
        end
    end

    LoadServer(GM.FolderName.."/server")
end

local function LoadClient(dir)
    dir = dir .. "/"
    local files, folders = file_Find(dir .. "*", "LUA")

    for _, fl in ipairs(files) do
        if string_EndsWith(fl, ".lua") then
            local path = getPath(dir, fl)
            assert(path, "Invalid path returned")

            if SERVER then
                AddCSLuaFile(path)
            else
                SafeInclude(path)
            end
        end
    end

    for _, fol in ipairs(folders) do
        if (fol == "vgui") then return end
        LoadClient(dir .. fol)
    end
end

LoadServer(GM.FolderName.."/client")

local function LoadShared(dir)
    dir = dir .. "/"
    local files, folders = file_Find(dir .. "*", "LUA")

    for _, fl in ipairs(files) do
        if string_EndsWith(fl, ".lua") then
            local path = getPath(dir, fl)
            assert(path, "Invalid path returned")

            if SERVER then
                AddCSLuaFile(path)
            end

            SafeInclude(path)
        end
    end

    for _, fol in ipairs(folders) do
        LoadServer(dir .. fol, tag)
    end
end

LoadServer(GM.FolderName.."/shared")