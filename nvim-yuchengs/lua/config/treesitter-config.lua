require("nvim-treesitter.configs").setup {
    ensure_installed = { "python", "cpp", "lua", "vim", "json", "toml" },
    ignore_install = {}, -- List of parsers to ignore installing
    highlight = {
        enable = true,
        disable = { 'help' }, -- list of language that will be disabled
    },
    matchup = {
        enable = true,
    }
}