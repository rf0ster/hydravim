return {
    "nvim-tree/nvim-tree.lua",
    config = function()
        require("nvim-tree").setup({
            disable_netrw = true,
            view = {
                float = {
                    enable = false,
                }
            },
            renderer = {
                icons = {
                    git_placement = "after"
                }
            },
            diagnostics = {
                enable = true,
                icons = {
                    hint = "",
                    info = "",
                    warning = "",
                    error = "",
                }
            }
        })
    end,
}
