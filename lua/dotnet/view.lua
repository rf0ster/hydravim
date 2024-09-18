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

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

    local bufnr = vim.api.nvim_create_buf(false, true)

    local win = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "double",
        title = "Output - " .. cmd,
    })

    vim.wo[win].wrap = false
    vim.wo[win].cursorline = false
    vim.wo[win].cursorcolumn = false
    vim.wo[win].statusline = "Output"
    vim.wo[win].wrap = false
    set_view(win)

    local function on_output(_, data, _)
        if data then
            for _, line in ipairs(data) do
                if line:match("^%s*$") then
                    line = ""
                end

                if line ~= "" then
                    -- Replace carriage return (^M) with nothing
                    -- Is this only on windows??
                    line = string.gsub(line, "\r", "")
                    -- Trim leading and trailing whitespace
                    line = line:gsub("^%s+", ""):gsub("%s+$", "")
                    -- Add indentation
                    line = " " .. line
                end
                vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {line})
            end
        end

        local last_line = vim.api.nvim_buf_line_count(bufnr)
        vim.api.nvim_win_set_cursor(0, {last_line, 0})
    end

    vim.fn.jobstart(cmd, {
        on_stdout = on_output,
        on_stderr = on_output,
        on_exit = function()
            vim.bo[bufnr].modifiable = false
        end,
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
        results_title = opts.results_title or "Results",
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
