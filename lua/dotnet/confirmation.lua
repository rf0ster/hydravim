local M = {}

function M.open(opts)
    local prompt = opts.prompt or {"Are you sure?"}

	local height = #prompt + 3
	local width = 25
    for _, line in ipairs(prompt) do
        width = math.max(width, #line + 2)
    end

	local row = math.floor((vim.o.lines - height) / 4)
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
        title = opts.title or "Confirm",
        title_pos = "left",
    })

    vim.wo[win].wrap = false
    vim.wo[win].cursorline = false
    vim.wo[win].cursorcolumn = false
    vim.wo[win].statusline = "Output"
    vim.wo[win].wrap = false
    -- set_view(win)

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, prompt)
    vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, {"", " (Y)es / (N)o"})
    vim.bo[bufnr].modifiable = false

    local function close(answer)
        vim.api.nvim_win_close(win, true)
        if opts.on_close then
            opts.on_close(answer)
        end
    end

    vim.api.nvim_buf_set_keymap(bufnr, "n", "y", "", {
        noremap = true,
        silent = true,
        callback = function()
            close("yes")
        end
    })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "n", "", {
        noremap = true,
        silent = true,
        callback = function()
            close("no")
        end
    })
end

return M