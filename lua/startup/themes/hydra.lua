local settings = {
    -- every line should be same width without escaped \
    header = {
        type = "text",
        align = "center",
        fold_section = false,
        title = "Hydravim",
        margin = 5,
        content = require("startup.headers").hydra_header,
        highlight = "Statement",
        default_color = "",
        oldfiles_amount = 0,
    },
    header_2 = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = true,
        title = "Hydravim",
        margin = 5,
        content = { "" },
        highlight = "Statement",
        default_color = "",
        oldfiles_amount = 0,
    },
    -- name which will be displayed and command
    body = {
        type = "mapping",
        align = "center",
        fold_section = false,
        title = "Basic Commands",
        margin = 5,
        content = {
            { " File Explorer", "lua vim.cmd[[NvimTreeOpen]] vim.cmd[[bp]]", "<leader>ee" },
            { " Find File", "Telescope find_files", "<leader>ff" },
            { "󰍉 Find Word", "Telescope live_grep", "<leader>fg" },
            { " Plugins", "Lazy", "<leader>l" },
            { " LSP", "Mason", "<leader>m" },
            { "󰘐 Dotnet", "lua require('dotnet.projects').open()", "<leader>dp" },
            { "󰘐 Quit", "q!<CR>", "<leader>q" }
        },
        highlight = "String",
        default_color = "",
        oldfiles_amount = 0,
    },
    parts = {
        "header",
        "header_2",
        "body",
    },
}
return settings
