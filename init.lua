require("config.lazy")
require("rfoster")
require("recall")

vim.cmd("colorscheme cyberdream")

local sln_name = function()
    local sln_info = require("dotnet.solution").get()
    if sln_info then
        return sln_info.name
	end
	return ""
end

local hl = vim.api.nvim_get_hl(0, {name="Statement"})
require("lualine").setup({
	sections = {
		lualine_c = {
			{ sln_name, color = { fg = hl.fg and string.format("#%06x", hl.fg) or nil } },
			{ "filename" }
		}
	},
})

-- vim.cmd[[Startup display]]
