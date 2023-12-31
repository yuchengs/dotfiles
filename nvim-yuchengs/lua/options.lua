---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--                          Options
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
local utils = require('utils')

-- Set encoding
vim.o.scriptencoding = 'utf-8'
vim.o.fileencoding='utf-8'
vim.o.fileencodings='ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1'

-- Disable swapfile
vim.o.noswapfile = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable vertical rule
vim.wo.colorcolumn = '88'
-- Enable cursorline
vim.wo.cursorline = true

-- Enable line numbers
vim.wo.number = true

-- Break line at predefined characters
vim.o.linebreak = true
-- Character to show before the lines that have been soft-wrapped
vim.o.showbreak = '↪'

-- tab setting
local indendation_width = 2
vim.bo.shiftwidth = indendation_width
vim.bo.tabstop = indendation_width
vim.bo.softtabstop = indendation_width
vim.bo.expandtab = true

-- Ignore certain files and folders when globing
vim.o.wildignore = vim.o.wildignore .. '*.o,*.obj,*.dylib,*.bin,*.dll,*.exe'
vim.o.wildignore = vim.o.wildignore .. '*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**'
vim.o.wildignore = vim.o.wildignore .. '*.pyc,*.pkl'
vim.o.wildignore = vim.o.wildignore .. '*.DS_Store'
vim.o.wildignore = vim.o.wildignore .. '*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.xdv'
-- Ignore file and dir name cases in cmd-completion
vim.o.wildignorecase = true 
-- Ignore case in general, but become case-sensitive when uppercase is present
vim.o.ignorecase = true
vim.o.smartcase = true

-- Disable showing current mode on command line since statusline plugins can show it.
vim.o.noshowmode = true

-- Ask for confirmation when handling unsaved or read-only files
vim.o.confirm = true

-- List all matches and complete till longest common string
vim.o.wildmode = 'list:longest'

-- Persistent undo even after you close a file and re-open it
vim.o.undofile = true

-- Always show sign column
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '80,100'
vim.opt.cursorline = true

-- code complete
vim.opt.completeopt:append('menu')
vim.opt.completeopt:append('menuone')
vim.opt.completeopt:append('noselect')

-- maximum number of items in the popup menu
vim.o.pumheight = 5
-- pseudo transparency for completion menu
vim.o.pumblend = 5

-- External program to use for grep command
if utils.executable('rg') then
  vim.o.grepprg='rg --vimgrep --no-heading --smart-case'
  vim.o.grepformat='%f:%l:%c:%m'
end

-- list chars
vim.opt.listchars:append({
	eol = '¬',
	extends = '→',
	nbsp = '+',
	precedes = '←',
	tab = '»·',
	trail = '·',
})
vim.opt.list = true

-- responsiveness
vim.opt.updatetime = 250