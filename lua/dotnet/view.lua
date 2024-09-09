local M = {}
local win_id = nil

local function set_view(win)
    M.clear()
    win_id = win
end

function M.clear()
    if win_id then
        pcall(vim.api.nvim_win_close, win_id, true)
        win_id = nil
    end
end

function M.output(cmd)
    require "dotnet.history".add_cmd(cmd)
    print(cmd)

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

    local bufnr = vim.api.nvim_create_buf(false, true)
    local window = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = "Output",
        title_pos = "left",
    })

    vim.wo[window].statusline = "Output"
    vim.wo[window].wrap = false
    set_view(window)

    local function on_output(_, data, _)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    line = " " .. line
                end
                vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {line})
            end
        end
    end

    vim.fn.jobstart(cmd, {
        on_stdout = on_output,
        on_stderr = on_output,
        stdout_buffered = false,
        stderr_buffered = false,
    })
end

function M.picker(opts)
    local finders = require "telescope.finders"
    local pickers = require "telescope.pickers"
    local sorters = require "telescope.sorters"

    M.clear()
    opts = opts or {}

    pickers.new(opts, {
        initial_mode = "normal",
        prompt_title = opts.prompt_title or "Viewer",
        finder = finders.new_table {
            results = opts.items or {},
        },
        sorter = sorters.get_generic_fuzzy_sorter(),
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
            prompt_position = "top",
            width = 0.5,
            height = 0.5,
        },
        attach_mappings = function(_, map)
            if opts.maps then
                for _, value in ipairs(opts.maps) do
                    map(value.mode, value.key, value.fn)
                end
            end
            return true
        end,
    }):find()
end

return M
