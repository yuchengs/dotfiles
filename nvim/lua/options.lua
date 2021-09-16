---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--                          Options
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- Enable mouse mode
vim.o.mouse = 'a'
-- Scrolloff
vim.g.scrolloff = 5
-- Enable vertical rule
vim.wo.colorcolumn = '88'
-- Enable cursorline
vim.wo.cursorline = true
-- Enable line numbers
vim.wo.number = true
-- tab setting
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true
-- briefly jump to the matching bracket
vim.o.showmatch = true
-- Always show sign column
vim.wo.signcolumn = 'yes'
-- as requested by nvim-compe
vim.o.completeopt = "menuone,noselect"
-- maximum number of items in the popup menu
vim.o.pumheight = 5
