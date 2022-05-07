if SERVER then
	DspcGlobal = {}

	DspcGlobal.Path = table.pack(...)[1]
    dofile(DspcGlobal.Path .. "/Lua/dspc.lua")
end