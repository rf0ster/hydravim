
local M = {}

M.history = {}
M.current_index = 0

-- Function to add a file to history (if it's not already there)
function M.add_to_history()
    local bufname = vim.fn.expand('%:p') -- Get the full path of the current buffer
    if bufname == "" then return end -- Ignore empty buffers
    if vim.fn.filereadable(bufname) == 0 then return end -- Ignore non-readable buffers

    -- Check if the file is already in history
    for _, entry in ipairs(M.history) do
        if entry == bufname then
            return
        end
    end

    -- Add the file to history and update the current index
    table.insert(M.history, bufname)
    M.current_index = #M.history
end

local function recall_hint(index)
    local output = {}
    local prev = index - 1
    local next = index + 1

    local cwd = vim.fn.getcwd()
    local escaped_cwd = cwd:gsub("([%.%+%-%%%*%?%[%]%^%$%(%)])", "%%%1")
    local function relative_path(path)
        return path:gsub("^" .. escaped_cwd .. "/", "")
    end

    if prev > 0 then
        table.insert(output, "  " .. prev .. ": " .. relative_path(M.history[prev]))
    end
    table.insert(output, "> " .. index .. ": " .. relative_path(M.history[index]))
    if next <= #M.history then
        table.insert(output, "  " .. next .. ": " .. relative_path(M.history[next]))
    end

    local max_length = 0
    for _, line in ipairs(M.history) do
        if #line > max_length then
            max_length = #line
        end
    end

    -- Define the window size and position
    local width = math.min(math.floor(vim.o.columns / 2), max_length + 7)
    local height = 3
    local row = 0
    local col = vim.o.columns - width

    -- Set the window options
    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "single",  -- Adds a border around the window
    }

    local active_win = vim.api.nvim_get_current_win()

    -- Create the floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    vim.bo[buf].modifiable = false

    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_set_current_win(active_win)
    vim.wo[win].wrap = false
    vim.wo[win].cursorline = false
    vim.wo[win].cursorcolumn = false

    -- Set a timer to close the window after 1 second (1000 milliseconds)
    vim.defer_fn(function()
        vim.api.nvim_win_close(win, true)
    end, 1000)
end

-- Function to open a file from the history by index
function M.open_file_from_history(index)
    if M.history[index] then
        vim.api.nvim_command("e " .. M.history[index])
        M.current_index = index
    end
end

-- Function to move back in history
function M.move_back()
    if M.current_index > 1 then
        M.current_index = M.current_index - 1
        M.open_file_from_history(M.current_index)
        recall_hint(M.current_index)
    end
end

-- Function to move forward in history
function M.move_forward()
    if M.current_index < #M.history then
        M.current_index = M.current_index + 1
        M.open_file_from_history(M.current_index)
        recall_hint(M.current_index)
    end
end

function M.recall()
    local finders = require "telescope.finders"
    local pickers = require "telescope.pickers"
    local actions = require "telescope.actions"
    local actions_state = require "telescope.actions.state"

    local items = {}
    for i, file in ipairs(M.history) do
        table.insert(items, { display = file, value = i })
    end

    pickers.new({}, {
        initial_mode = "normal",
        prompt_title = "Recall",
        finder = finders.new_table {
            results = items,
            entry_maker = function(entry)
                return {
                    display = entry.value .. ": " .. entry.display,
                    value = entry.value,
                    ordinal = entry.display,
                }
            end,
        },
        sorter = nil,
        sorting_strategy = "ascending",
        layout_config = {
            prompt_position = "top",
            width = 0.5,
            height = 0.5,
        },
        attach_mappings = function(_, map)
            map('n', '<CR>', function(prompt_bufnr)
                local selection = actions_state.get_selected_entry()
                actions.close(prompt_bufnr)
                M.open_file_from_history(selection.value)
            end)
            return true
        end,
    }):find()
end

-- Autocommand to track file opening
vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
        M.add_to_history()
    end
})

-- Define commands to open the floating window, move back, and move forward
vim.api.nvim_create_user_command('Recall', function() M.recall() end, {})
vim.api.nvim_create_user_command('RecallBack', function() M.move_back() end, {})
vim.api.nvim_create_user_command('RecallForward', function() M.move_forward() end, {})

return M
