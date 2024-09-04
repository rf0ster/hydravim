return {
    'alanfortlink/blackjack.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    event = 'VeryLazy',
    config = function()
        require('blackjack').setup({
            card_style = 'large'
        })
    end,
}
