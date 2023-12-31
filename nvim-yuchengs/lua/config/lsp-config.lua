local utils = require("utils")

local capabilities = vim.lsp.protocol.make_client_capabilities()

local mason_servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	-- tsserver = {},

	lua_ls = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr")
	vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

	local nmap = function(keys, cmd, desc)
		if desc then
			desc = "LSP: " .. desc
		end
		vim.keymap.set("n", keys, cmd, { buffer = bufnr, desc = desc })
	end

	-- Actions
	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	-- Jumping Around
	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gtd", vim.lsp.buf.type_definition, "[G]oto [T]ype [D]efinition")

	local status_ok, ts_builtin = pcall(require, "telescope.builtin")
	if status_ok then
		nmap("<leader>ds", ts_builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
		nmap("<leader>ws", ts_builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		nmap("gr", ts_builtin.lsp_references, "[G]oto [R]eferences")
	else
		nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
	end

	-- Help
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Workspace
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Document formatting.
	nmap("<leader>f", vim.lsp.buf.format, "[F]ormat")
	nmap("<leader>F", function()
		vim.lsp.buf.format()
		vim.api.nvim_command("write")
	end, "[F]ormat and save")

	vim.api.nvim_command("augroup LSP")
	vim.api.nvim_command("autocmd!")
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_command("autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()")
		vim.api.nvim_command("autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()")
		vim.api.nvim_command("autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()")
	end
	vim.api.nvim_command("augroup END")

	require("nvim-navic").attach(client, bufnr)
end

local get_nvim_lspconfig_deps = function() 
  local deps = {
    "cmp-nvim-lsp",
    "mason-lspconfig.nvim",
  }
  if utils.can_use_ciderlsp() then
    table.insert(deps, "cmp-nvim-ciderlsp")
  end
  return deps
end

return {
	{
		"SmiteshP/nvim-navic",
		opts = {},
		lazy = true,
		init = function()
			vim.g.navic_silence = true
		end,
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		config = function()
			--This is standard cmp_nvim_lsp config
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
		end,
		lazy = true,
	},
	{
		url = "sso://googler@user/piloto/cmp-nvim-ciderlsp",
		init = function()
			vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Required for go/ciderlsp
		end,
		config = function()
			-- This is where we advertise support for ML-completion.
			capabilities = require("cmp_nvim_ciderlsp").update_capabilities(capabilities)
		end,
    enable = utils.can_use_ciderlsp(),
		lazy = true,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = get_nvim_lspconfig_deps(),
		config = function()
			local lspconfig = require("lspconfig")
			local configs = require("lspconfig.configs")

			-- Cider LSP (otherwise clangd)
      if not utils.can_use_ciderlsp() then
        lspconfig.clangd.setup({
          capabilities = capabilities,
        })
      end
      if utils.can_use_ciderlsp() then
        configs.ciderlsp = {
          default_config = {
            cmd = {
              "/google/bin/releases/cider/ciderlsp/ciderlsp",
              "--tooltag=nvim-lsp",
              "--noforward_sync_responses",
            },
            filetypes = {
              "bzl",
              "c",
              "cpp",
              "go",
              "java",
              "javascript",
              "kotlin",
              "objc",
              "proto",
              "python",
              "soy",
              "textproto",
              "typescript",
            },
            root_dir = lspconfig.util.root_pattern("BUILD"),
            settings = {},
          }
        }
        lspconfig.ciderlsp.setup({
          capabilities = capabilities,
          on_attach = on_attach
        })
      end
		end,
		lazy = true,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"nvim-lspconfig",

			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"onsails/lspkind.nvim",
		},
		opts = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			lspkind.init()

			return {
				mapping = {
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<CR>"] = cmp.mapping.confirm(),
					["<C-E>"] = cmp.mapping.close(),
					["<C-D>"] = cmp.mapping.scroll_docs(-4),
					["<C-U>"] = cmp.mapping.scroll_docs(4),
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "vsnip" },
					{ name = "nvim_ciderlsp" },
					{ name = "buffer",       keyword_length = 5 },
				},
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				formatting = {
					format = lspkind.cmp_format({
						with_text = true,
						maxwidth = 60, -- Prev: 40 -- half max width
						menu = {
							nvim_ciderlsp = "[ML ]",
							nvim_lsp = "[LSP ]",
							buffer = "[buffer ]",
							nvim_lua = "[API ]",
							path = "[path ]",
							vsnip = "[snip ]",
						},
					}),
				},
				experimental = {
					native_menu = false,
					ghost_text = true,
				},
			}
		end,
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"williamboman/mason.nvim",
		opts = {},
		build = ":MasonUpdate",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"mason.nvim",
		},
		opts = {
			ensure_installed = vim.tbl_keys(mason_servers),
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = mason_servers[server_name],
					}
				end,
			})
		end,
		lazy = true,
	},
}