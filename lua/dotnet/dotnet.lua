
local M = {}

-- Runs a dotnet build command and outputs the results
-- to the given buffer.
-- project: Filepath to the project
-- buffer: Buffer to output to
function M.build(project_path, buf)
	local buffer = require "dotnet.buffer"
	local command = 'dotnet build '.. vim.fn.shellescape(project_path)

	buffer.append(buf, {command})
	local function on_output(_, data, _)
		if data then
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
		end
	end

	-- Run the command asynchronously and print output live to the new buffer
	vim.fn.jobstart(command, {
			on_stdout = on_output,
			on_stderr = on_output,
			stdout_buffered = false,
			stderr_buffered = false,
	})
end

return M

