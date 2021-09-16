---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--                          Plugin Settings
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

-- Plugin name: tokyonight.nvim
vim.o.termguicolors = true
vim.g.tokyonight_style = "storm"
vim.cmd[[colorscheme tokyonight]]

-- Plugin name: lightline.vim
vim.g.lightline = {
  colorscheme = 'tokyonight',
  active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
  component_function = { gitbranch = 'fugitive#head' },
}

-- Plugin name: telescope.nvim
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
  update_debounce = 100
}

-- Plugin name: indent_blankline
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
require'bufferline'.setup {}

-- Plugin name: nvim-tree
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

-- Plugin name: nvim-compe
require'compe'.setup {
  enabled = true;
  autocomplete = true,
  debug = false,
  min_length = 2,
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
    calc = false;
    omni = false;
    emoji = false;
    nvim_lsp = true;
    nvim_lua = true;
    treesitter = true;
  };
}

-- Plugin name: nvim-autopairs
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
