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
    footer_2 = {
        type = "text",
        content = require("startup.functions").packer_plugins(),
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "",
        margin = 5,
        highlight = "TSString",
        default_color = "#FFFFFF",
        oldfiles_amount = 10,
    },

    options = {
        after = function()
            require("startup.utils").oldfiles_mappings()
        end,
        mapping_keys = true,
        cursor_column = 0.5,
        empty_lines_between_mappings = true,
        disable_statuslines = true,
        paddings = { 2, 2, 2, 2, 2, 2, 2 },
    },
    colors = {
        background = "#1f2227",
        folded_section = "#56b6c2",
    },
    parts = {
        "header",
        "header_2",
        "body",
        "footer_2",
    },
}
return settings
