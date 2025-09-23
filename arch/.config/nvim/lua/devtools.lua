local M = {}

function M.ReloadLuaModules()
	local config_path = vim.fn.stdpath("config") .. "/lua/"
	for name,_ in pairs(package.loaded) do
		local module_path = package.searchpath(name, package.path)
		if module_path and module_path:sub(1, #config_path) == config_path then
			package.loaded[name] = nil
		end
	end
end

function M.ReloadConfig()
	M.ReloadLuaModules()
	dofile(vim.fn.stdpath("config") .. "/init.lua")
	print("Modules reloaded.")
end

return M
