

local MOD_DIRECTORY = Utils.getLuaDir()..[[\Mods]]


local init = function()
	console.log("Loading mods from directory: " .. MOD_DIRECTORY)
	local modFolder = io.popen("dir \"" .. MOD_DIRECTORY .. "\" /b")
	
	for file in modFolder:lines() do
		local modId = bizstring.replace(file,".lua","")
		require("Mods." .. modId)	
	end
end	

init()