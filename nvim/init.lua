-- [[
--                          Neovim Configuration
--                                                         Yucheng Shi
--                                                         yuchengs.euca [at] gmail.com
--      Note:
--      1. You still need to install language servers (use :LspInstall)
--      2. You still need to install treesitter parsers (use :TSInstall)
--      3. Upon first time setup, run :PackerInstall + :PackerSync to install
--         and update all plugins and configuration
--      4. Everytime configuration is changed, run :PackerCompile / :PackerSync
--         for the configuration to take effect
-- ]]

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--                          Load Packages/Plugins
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- Make sure packer is installed
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end
vim.api.nvim_exec(
  [[
    augroup Packer
      autocmd!
      autocmd BufWritePost init.lua PackerCompile
    augroup end
  ]],
  false
)
-- Plugins
local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- packer itself
  use 'folke/tokyonight.nvim' -- Tokyonight colortheme
  use 'simeji/winresizer' -- resize windows
  use 'itchyny/lightline.vim' -- Fancier statusline
  -- vim things picker, the mighty telescope!
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- Ad git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use 'lukas-reineke/indent-blankline.nvim' -- colorful indent
  use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
  use {'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons'}
  -------------------------------------------------------------------------------------
  -- tpope collections
  use 'tpope/vim-unimpaired' -- bufferlist, etc
  use 'tpope/vim-fugitive' -- Git commands in nvim
  use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines
  use 'tpope/vim-surround' -- Surround the selection with a pair of marks
  use 'tpope/vim-obsession' -- Autoload session
  -------------------------------------------------------------------------------------
  -- neovim lsp and related
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'kabouzeid/nvim-lspinstall' -- install lsp vis LspInstall
  use 'hrsh7th/nvim-compe'
  use 'windwp/nvim-autopairs' -- auto pairs, woohoo!
  -------------------------------------------------------------------------------------
  -- neovim treesitter
  use 'nvim-treesitter/nvim-treesitter' -- treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'romgrk/nvim-treesitter-context'
  -------------------------------------------------------------------------------------
  -- [[
  --  TODO: consider using following plugins
  --    1. folke/trouble.nvim
  --    2. michaelb/sniprun
  --    3. ray-x/lsp_signature.nvim
  -- ]]
end)


-- Map leader key before setup
-- why? see :help mapleader
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--                          Packages/Plugins Setup
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- Plugin name: tokyonight.nvim
-- :help tokyonight
vim.o.termguicolors = true
vim.g.tokyonight_style = "storm"
vim.cmd[[colorscheme tokyonight]]
-- Plugin name: lightline.vim
-- :help lightline
vim.g.lightline = {
  colorscheme = 'tokyonight',
  active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
  component_function = { gitbranch = 'fugitive#head' },
}
-- Plugin name: telescope.nvim
-- :help telescope
require('telescope').setup {
  defaults = {
    prompt_prefix = '🔭 ',
    selection_caret = " ",
    layout_config = {
        horizontal = {prompt_position = "bottom", results_width = 0.6},
        vertical = {mirror = false}
    },
    file_sorter = require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    winblend = 0,
    border = {},
    borderchars = {
        "─", "│", "─", "│", "╭", "╮", "╯", "╰"
    },
    color_devicons = true,
    use_less = true,
    set_env = {["COLORTERM"] = "truecolor"},
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = {"absolute"}
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
}
require('telescope').load_extension('fzf')
-- Plugin name: gitsigns.nvim
-- :help gitsigns
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  numhl = true,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,
    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
  watch_index = {
    interval = 1000
  },
  current_line_blame_opts = {
    delay = 500,
    virt_text_pos = 'eol'
  },
  current_line_blame = true,
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,    -- Use default
  diff_opts = {
    internal = true
  }
}
-- Plugin name: indent_blankline
-- :help indent_blankline
require("indent_blankline").setup {
  char = "|",
  use_treesitter = true,
  show_first_indent_level = true,
  filetype_exclude = {
    "dashboard", "log", "fugitive", "gitcommit",
    "packer", "vimwiki", "markdown", "json", "help",
    "NvimTree", "git", "TelescopePrompt", "undotree",
    "" -- for all buffers without a file type
  },
  buftype_exclude = {"terminal", "nofile"},
  show_trailing_blankline_indent = false,
  show_current_context = true,
  vim.cmd('autocmd CursorMoved * IndentBlanklineRefresh')
}
-- Plugin name: nvim-bufferline
-- :help bufferline
require'bufferline'.setup {}
-- Plugin name: nvim-tree
-- :help nvim-tree
vim.g.nvim_tree_width = 35
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_auto_open = 0
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_hide_dotfiles = 0
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_tab_open = 1
vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_disable_netrw = 1
vim.g.nvim_tree_hijack_netrw = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_ignore = {'.git', 'node_modules', '.cache'}
vim.g.nvim_special_files = {'README.md', 'Makefile', 'MAKEFILE', 'BUILD', 'WORKSPACE'}
vim.g.nvim_tree_icons = {
  default = '',
  symlink = '',
  git = {
    unstaged = "✚",
    staged = "✚",
    unmerged = "≠",
    renamed = "≫",
    untracked = "★"
  }
}
vim.g.nvim_tree_disable_keybindings = 0
local tree_cb = require'nvim-tree.config'.nvim_tree_callback
vim.g.nvim_tree_bindings = {
  {key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("tabnew")},
  {key = {"<2-RightMouse>", "<C-]>"}, cb = tree_cb("cd")},
  {key = "<C-v>", cb = tree_cb("vsplit")},
  {key = "<C-x>", cb = tree_cb("split")},
  {key = "<C-t>", cb = tree_cb("tabnew")},
  {key = "<", cb = tree_cb("prev_sibling")},
  {key = ">", cb = tree_cb("next_sibling")},
  {key = "P", cb = tree_cb("parent_node")},
  {key = "<BS>", cb = tree_cb("close_node")},
  {key = "<S-CR>", cb = tree_cb("close_node")},
  {key = "<Tab>", cb = tree_cb("preview")},
  {key = "K", cb = tree_cb("first_sibling")},
  {key = "J", cb = tree_cb("last_sibling")},
  {key = "I", cb = tree_cb("toggle_ignored")},
  {key = "H", cb = tree_cb("toggle_dotfiles")},
  {key = "R", cb = tree_cb("refresh")},
  {key = "a", cb = tree_cb("create")},
  {key = "d", cb = tree_cb("remove")},
  {key = "r", cb = tree_cb("rename")},
  {key = "<C-r>", cb = tree_cb("full_rename")},
  {key = "x", cb = tree_cb("cut")}, {key = "c", cb = tree_cb("copy")},
  {key = "p", cb = tree_cb("paste")},
  {key = "y", cb = tree_cb("copy_name")},
  {key = "Y", cb = tree_cb("copy_path")},
  {key = "gy", cb = tree_cb("copy_absolute_path")},
  {key = "[c", cb = tree_cb("prev_git_item")},
  {key = "]c", cb = tree_cb("next_git_item")},
  {key = "-", cb = tree_cb("dir_up")},
  {key = "s", cb = tree_cb("system_open")},
  {key = "q", cb = tree_cb("close")},
  {key = "g?", cb = tree_cb("toggle_help")}
}
-- Plugin name: nvim-lspconfig
-- :help lspconfig
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end
end
local lua_settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {'vim'},
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
  }
}
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
  }
end
local function setup_servers()
  require'lspinstall'.setup()
  -- get all installed servers
  local servers = require'lspinstall'.installed_servers()
  -- add manually installed servers
  table.insert(servers, "cpp")
  table.insert(servers, "lua")
  table.insert(servers, "python")
  for _, server in pairs(servers) do
    local config = make_config()
    -- language specific config
    if server == "lua" then
      config.settings = lua_settings
    end
    if server == "cpp" then
      config.filetypes = {"c", "cpp"}; -- we don't want objective-c and objective-cpp!
      -- TODO: check if VIMDATA is necessary
      config.cmd = {vim.fn.expand('$VIMDATA/lspinstall/cpp/clangd/bin/clangd'), "--background-index", "--fallback-style=google"}
    end
    require'lspconfig'[server].setup(config)
  end
end
setup_servers()
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
-- Plugin name: nvim-compe
-- :help TODO
require'compe'.setup {
  enabled = true;
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  resolve_timeout = 800,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,
  source = {
    path = true;
    buffer = true;
    tags = false;
    spell = false;
    calc = true;
    omni = false;
    emoji = false;
    nvim_lsp = true;
    nvim_lua = true;
    treesitter = true;
  };
}
-- Plugin name: nvim-autopairs
-- :help nvim-autopairs
require('nvim-autopairs').setup({
  disable_filetype = {"TelescopePrompt"},
  ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
  enable_moveright = true,
  -- add bracket pairs after quote
  enable_afterquote = true,
  -- check bracket in same line
  enable_check_bracket_line = true,
  check_ts = true
})
require("nvim-autopairs.completion.compe").setup({
  map_cr = true,
  map_complete = true,
  auto_select = false
})
-- Plugin name: nvim_treesitter
-- :help treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "cpp", "python", "lua" },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = { enable = true },
  -- autopairs = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}
-- Plugin name: nvim-treesitter-context
-- :help TODO
require'treesitter-context'.setup {}


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


---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--                          Mappings
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- Do NOT use arrow keys in normal mode :)
vim.api.nvim_set_keymap('n', '<Up>', '<Nop>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Left>', '<Nop>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Right>', '<Nop>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Down>', '<Nop>', { noremap = true })
-- Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })
-- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })
-- expand %% as current file directory
vim.api.nvim_set_keymap('c', '%%', "getcmdtype() == ':' ? expand('%:h').'/' : '%%'", { noremap = true, expr = true })
-- <C-l> to clear highlighted text
vim.api.nvim_set_keymap('n', '<C-l>', ':<C-u>nohlsearch<CR><C-l>', { noremap = true, silent = true })
-- window management
vim.api.nvim_set_keymap('n', '<M-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-l>', '<C-w>l', { noremap = true })
-- Use Esc to change back to normal terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\>i<C-n>', { noremap = true })
vim.api.nvim_set_keymap('t', '<C-v><Esc>', '<Esc>', { noremap = true })
-- telescope
vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })
-- nvim-tree
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true })
