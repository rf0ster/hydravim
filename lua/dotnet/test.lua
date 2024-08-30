local M = {}

function M.on_init(buf)
	require "dotnet.buffer".run_command(buf, 'dotnet test --list-tests')
end

return M
