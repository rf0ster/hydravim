-- C# Test Runner Plugin for Neovim

local vim = vim
local api = vim.api

local M = {}

-- Store test results
local test_results = {}

-- Function to open the floating window
function M.open_test_window()
    -- Create a new buffer
    local buf = api.nvim_create_buf(false, true)

    -- Set buffer options
    api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

    -- Determine window size
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create the floating window
    local win = api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'single',
    })

    -- Load the list of tests
    local tests = M.get_test_list()

    -- Set buffer lines
    api.nvim_buf_set_lines(buf, 0, -1, false, tests)

    -- Set keymaps for the buffer
    api.nvim_buf_set_keymap(buf, 'n', 'q', ':bd!<CR>', { noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, 'n', '<CR>', ':lua require"dotnet.test".run_selected_test()<CR>', { noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, 'n', 'R', ':lua require"dotnet.test".run_all_tests()<CR>', { noremap = true, silent = true })

    -- Set buffer local options
    api.nvim_buf_set_option(buf, 'modifiable', false)
    api.nvim_buf_set_option(buf, 'filetype', 'cs_test_runner')

    -- Highlight the test status
    M.highlight_test_results(buf, tests)
end

-- Function to get the list of tests
function M.get_test_list()
    local cmd = 'dotnet test --list-tests'
    local output = vim.fn.systemlist(cmd)
    local tests = {}
    local capture = false
    for _, line in ipairs(output) do
        if line:find('The following Tests are available') then
            capture = true
        elseif capture and line ~= '' then
            table.insert(tests, line)
        end
    end
    return tests
end

-- Function to run the selected test
function M.run_selected_test()
    local bufnr = api.nvim_get_current_buf()
    local linenr = api.nvim_win_get_cursor(0)[1]
    local test_name = api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1]

    -- Run the test
    local cmd = 'dotnet test --filter FullyQualifiedName="' .. test_name .. '"'
    local output = vim.fn.systemlist(cmd)

    -- Check the result
    local passed = false
    for _, line in ipairs(output) do
        if line:find('Passed!') then
            passed = true
            break
        elseif line:find('Failed!') then
            passed = false
            break
        end
    end

    -- Update test results
    test_results[test_name] = passed

    -- Refresh highlights
    M.highlight_test_results(bufnr)

    -- Notify the user
    if passed then
        vim.notify('Test Passed: ' .. test_name, vim.log.levels.INFO)
    else
        vim.notify('Test Failed: ' .. test_name, vim.log.levels.ERROR)
    end
end

-- Function to run all tests
function M.run_all_tests()
    -- Run all tests
    local cmd = 'dotnet test'
    local output = vim.fn.systemlist(cmd)

    -- Parse the results
    for _, line in ipairs(output) do
        local test_name = line:match('%s*(.-)%s+%[%w+%]')
        if test_name then
            local result = line:match('%[(%w+)%]')
            if result == 'PASS' then
                test_results[test_name] = true
            elseif result == 'FAIL' then
                test_results[test_name] = false
            end
        end
    end

    -- Refresh highlights
    local bufnr = api.nvim_get_current_buf()
    M.highlight_test_results(bufnr)

    -- Notify the user
    vim.notify('All tests have been run.', vim.log.levels.INFO)
end

-- Function to highlight test results
function M.highlight_test_results(bufnr, tests)
    -- Clear existing highlights
    api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)

    -- Set highlights
    local ns_id = api.nvim_create_namespace('cs_test_runner')
    local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
    for i, line in ipairs(lines) do
        local test_name = line
        if test_results[test_name] ~= nil then
            if test_results[test_name] then
                api.nvim_buf_add_highlight(bufnr, ns_id, 'DiffAdd', i - 1, 0, -1)
            else
                api.nvim_buf_add_highlight(bufnr, ns_id, 'DiffDelete', i - 1, 0, -1)
            end
        end
    end
end

-- Map the hotkey to open the test window

return M
