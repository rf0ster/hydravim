--- Solution tab

local M = {}

M.on_init = function(buf)
		local scandir = require "plenary.scandir"
		local buffer = require "dotnet.buffer"

		M.solutions = scandir.scan_dir(".", { search_pattern = { "%.sln$" } })
		buffer.append(buf, M.solutions)
		buffer.set_keymap_safe(buf, 'n', '<leader>b', '', {
			noremap = true,
			silent = true,
			callback = function()
				local solution = buffer.read_current_line(buf)
				local dotnet = require "dotnet.dotnet"
			  dotnet.build(solution, buf)
			end
		})
end

return M
