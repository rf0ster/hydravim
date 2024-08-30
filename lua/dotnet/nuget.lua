local M = {}

function M.on_init(buf)
	require "dotnet.buffer".run_command(buf, 'nuget source list')
end

return M
