local M = {}

function M.open()
	local solution = require "dotnet.solution"
	local project = require "dotnet.project"
	local nuget = require "dotnet.nuget"

	M.window = require "dotnet.window"
	M.window.create_window()

	M.window.create_tab("(S)olution", "S", solution.on_init)
	M.window.create_tab("(P)roject", "P", project.on_init)
	M.window.create_tab("(N)uget", "N", nuget.on_init)
  M.window.create_tab("(T)est", "T", require "dotnet.test".on_init)

	M.window.tab_to(1)
end

function M.close()
	if M.window == nil then
		return false
	end

	return M.window.close()
end

return M
