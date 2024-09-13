return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        require("neo-tree").setup {
            auto_open = false,
            update_to_buf_dir = {
                enable = true,
                auto_open = true,
            },
            view = {
                width = 30,
                side = "left",
                auto_resize = true,
            },
            filesystem = {
                filtered_items = {
                    visible = true,        -- Show hidden files
                    hide_dotfiles = false, -- Do not hide dotfiles (files/folders starting with .)
                    hide_gitignored = false, -- Do not hide gitignored files
                },
            },
            default_component_configs = {
                git_status = {
                    symbols = {
                        -- Change type
                        added     = "+",  -- File added
                        modified  = "m",  -- File modified
                        deleted   = "x",  -- File deleted
                        renamed   = "r",  -- File renamed
                        -- Status type
                        untracked = "u",  -- Untracked files
                        ignored   = "i",  -- Ignored files
                        unstaged  = "u",  -- Unstaged changes
                        staged    = "s",  -- Staged changes
                        conflict  = "c",  -- Conflic
                    }
                },
            },
        }
    end
}
