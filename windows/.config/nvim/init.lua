-- window title ------------------------------------------------

vim.opt.title = true
vim.opt.titlestring = "%t"

-- leader ------------------------------------------------------

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- keymaps -----------------------------------------------------

vim.api.nvim_set_keymap(
	"n",
	"<leader>cn",
	':lua require("comments").insert_new_section()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>cs",
	':lua require("comments").insert_summary()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>r",
	':lua require("devtools").reload_config()<CR>',
	{ noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>rp", '"_diwP', { noremap = true, silent = true, desc = "Replace word with paste" })
vim.keymap.set(
	"n",
	"<leader>srp",
	'"_dgnP<Esc>n',
	{ noremap = true, silent = true, desc = "Replace search match and move next" }
)

-- option ------------------------------------------------------

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true

vim.o.mouse = "a" -- support mouse in all modes

vim.o.showmode = false -- already in status

vim.schedule(function()
	vim.o.clipboard = "unnamedplus" -- sync nvim and os clipboard
end)

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.o.breakindent = true

vim.o.undofile = true -- save undo history

vim.o.ignorecase = true -- case-insensitive search unless
vim.o.smartcase = true -- a capital is present

vim.o.signcolumn = "yes"

vim.o.updatetime = 250

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.o.inccommand = "split" -- live substitution preview

vim.o.scrolloff = 10 -- minimum # of lines above or below cursor

vim.o.confirm = true -- dialog for unsaved changes

vim.opt.termguicolors = true

-- wrapped line behavior
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- move by display lines, keep counts default
vim.keymap.set("n", "j", function()
	return vim.v.count > 0 and "j" or "gj"
end, { expr = true, silent = true })

vim.keymap.set("n", "k", function()
	return vim.v.count > 0 and "k" or "gk"
end, { expr = true, silent = true })

vim.keymap.set("v", "j", function()
	return vim.v.count > 0 and "j" or "gj"
end, { expr = true, silent = true })

vim.keymap.set("v", "k", function()
	return vim.v.count > 0 and "k" or "gk"
end, { expr = true, silent = true })

-- keymaps -----------------------------------------------------

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- autocmds ----------------------------------------------------

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- lazy nvim auto install ---------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- plugins -----------------------------------------------------

require("lazy").setup({
	"NMAC427/guess-indent.nvim",

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{ -- show pending keybinds
		"folke/which-key.nvim",
		event = "VimEnter", -- sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.o.timeoutlen
			delay = 0,
			icons = {
				-- set icon mappings to true if you have a nerd font
				mappings = vim.g.have_nerd_font,
				-- if you are using a nerd font, set icons.keys to an empty table which will use the
				-- default which-key.nvim defined nerd font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},

	{ -- fuzzy finder
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- if encountering errors, see telescope-fzf-native readme for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make", -- `build` to run some command when the plugin is installed/updated
				cond = function() -- determine if this plugin should install/load
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				-- defaults = {
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- search neovim config files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	{
		-- configures Lua LSP for your neovim config, runtime and plugins
		-- used for completion, annotations and signatures of neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- main lsp configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- automatically install lsps and related tools to stdpath for neovim
			-- mason must be loaded before its dependents
			{ "mason-org/mason.nvim", opts = {} }, -- `opts = {}` is the same as calling `require('mason').setup({})`
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} }, -- useful status updates
			"saghen/blink.cmp", -- allows extra capabilities provided by blink.cmp
		},
		config = function()
			-- relevant help section `:help lsp-vs-treesitter`

			--  run when an lsp attaches to a particular buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- rename variable
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- execute an lsp code action
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					-- find references
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- jump to implementation
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- jump to the definition (<C-t> to jump back)
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					--  jump to declaration
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- find all symbols in current doc (vars, funcs, types, etc.)
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

					-- find all symbols in current project
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

					-- jump to the defintion of a variable's type
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							---@diagnostic disable-next-line
							---a
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				-- ts_ls = {},
				--

				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--
			-- To check the current status of installed tools and/or manually install
			-- other tools, you can run
			--    :Mason
			--
			-- You can press `g?` for help in this menu.
			--
			-- `mason` had to be setup earlier: to configure its options see the
			-- `dependencies` table for `nvim-lspconfig` above.
			--
			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			vim.lsp.config("cssls", {
				cmd = { "vscode-css-language-server", "--stdio" },
				filetypes = { "css", "scss", "less" },
				root_dir = vim.fs.root(0, { ".git", "package.json" }),
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},

	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				-- 'default' (recommended) for mappings similar to built-in completions
				--   <c-y> to accept ([y]es) the completion.
				--    This will auto-import if your LSP supports it.
				--    This will expand snippets if the LSP sent a snippet.
				-- 'super-tab' for tab to accept
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- For an understanding of why the 'default' preset is recommended,
				-- you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				--
				-- All presets have the following mappings:
				-- <tab>/<s-tab>: move to right/left of your snippet expansion
				-- <c-space>: Open menu or open docs if already open
				-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
				-- <c-e>: Hide menu
				-- <c-k>: Toggle signature help
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				preset = "default",

				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			snippets = { preset = "luasnip" },

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = { implementation = "lua" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},

	-- Tokyo Night theme
	-- {
	--   'folke/tokyonight.nvim',
	--   priority = 1000, -- Make sure to load this before all the other start plugins.
	--   opts = {
	--     transparent = true,
	--     styles = {
	--       comments = { italic = false },
	--       sidebars = 'transparent',
	--       floats = 'transparent',
	--     },
	--   },
	--   ---@diagnostic disable-next-line: unused-local
	--   config = function(_, opts)
	--     require('tokyonight').setup(opts)
	--     vim.cmd.colorscheme 'tokyonight-night'
	--   end,
	-- },

	-- {
	--     'sainnhe/everforest',
	--     lazy = false,
	--     priority = 1000,
	--     config = function()
	--       -- Optionally configure and load the colorscheme
	--       -- directly inside the plugin declaration.
	--       vim.g.everforest_enable_italic = true
	--       vim.g.everforest_transparent_background = 2
	--       vim.cmd.colorscheme('everforest')
	--     end
	-- },

	-- Monochrome
	-- {
	--   "idr4n/github-monochrome.nvim",
	--   lazy = false,
	--   priority = 1000,
	--   opts = {
	--     style = "monochrome",        -- light/monochrome style
	--     transparent = true,      -- transparent background
	--     terminal_colors = true,  -- optional: use colorscheme for terminal
	--   },
	--   styles = {
	--     sidebars = "normal",
	--   },
	--   config = function(_, opts)
	--     require("github-monochrome").setup(opts)
	--     vim.cmd.colorscheme("github-monochrome-zenbones")
	--   end,
	-- },

	-- Heap
	-- {
	--   "valonmulolli/heap-nvim",
	--   priority = 1000,
	--   config = function()
	--     require('heap').setup({
	--       variant = "default", -- "default" or "dark"
	--       transparent = true,
	--       transparent_background = true
	--     })
	--     vim.cmd.colorscheme('heap')
	--   end,
	-- },
	--
	-- Aether Amethyst
	-- {
	--   "AetherSyscall/AetherAmethyst.nvim",
	--   priority = 1000,
	--   config = function()
	--     require("aetheramethyst").setup({
	--       transparent = true, -- Enable transparent background
	--       styles = {
	--         comments = { italic = true },
	--         keywords = { italic = true },
	--         functions = { bold = true },
	--         variables = {},
	--       }
	--     })
	--
	--     -- Load the variant: 'eclipse' (dark) or 'bliss' (light)
	--     vim.cmd("colorscheme aetheramethyst-eclipse")
	--   end,
	-- },

	--Monokai-nightasty
	-- {
	--   "polirritmico/monokai-nightasty.nvim",
	--   lazy = false,
	--   priority = 1000,
	--   keys = {
	--     { "<leader>tt", "<Cmd>MonokaiToggleLight<CR>", desc = "Monokai-Nightasty: Toggle dark/light theme." },
	--   },
	--   ---@module "monokai-nightasty"
	--   ---@type monokai.UserConfig
	--   opts = {
	--     dark_style_background = "transparent", -- default | dark | transparent | #RRGGBB
	--     light_style_background = "transparent", -- default | dark | transparent | #RRGGBB
	--     markdown_header_marks = true,
	--     -- hl_styles = { comments = { italic = false } },
	--     terminal_colors = function(colors) return { fg = colors.fg_dark } end,
	--   },
	--   config = function(_, opts)
	--     vim.opt.cursorline = true -- Highlight line at the cursor position
	--     vim.o.background = "dark" -- Default to dark theme
	--
	--     require("monokai-nightasty").load(opts)
	--   end,
	-- },

	-- Comments
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- Color picker
	{
		"uga-rosa/ccc.nvim",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "CccPick", "CccConvert", "CccHighlighterEnable" },
		keys = {
			{ "<leader>cp", "<cmd>CccPick<cr>", desc = "Color Picker" },
		},
		config = function()
			local ccc = require("ccc")
			ccc.setup({
				highlighter = {
					auto_enable = true,
					lsp = true,
				},
				inputs = {
					ccc.input.rgb,
					ccc.input.hsl,
				},
				outputs = {
					ccc.output.hex,
					ccc.output.hex_short,
				},
			})
		end,
	},

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		config = function(_, opts)
			require("nvim-treesitter.config").setup(opts)
		end,
	},

	-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
	-- init.lua. If you want these files, they are in the repository, so you can just download them and
	-- place them in the correct locations.

	-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
	--
	--  Here are some example plugins that I've included in the Kickstart repository.
	--  Uncomment any of the lines below to enable them (you will need to restart nvim).
	--
	-- require 'kickstart.plugins.debug',
	-- require 'kickstart.plugins.indent_line',
	-- require 'kickstart.plugins.lint',
	-- require 'kickstart.plugins.autopairs',
	-- require 'kickstart.plugins.neo-tree',
	-- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	{ import = "custom.plugins" },

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown" },
		opts = {
			enabled = false,
			heading = {
				backgrounds = {
					"RenderMarkdownH1Bg",
					"RenderMarkdownH2Bg",
					"RenderMarkdownH3Bg",
					"RenderMarkdownH4Bg",
					"RenderMarkdownH5Bg",
					"RenderMarkdownH6Bg",
				},
				left_pad = { 0, 1, 2, 3, 4, 5 },
				width = { "full", "full", "block", "block", "block", "block" },
			},
			code = {
				highlight = "RenderMarkdownCode",
				width = "block",
			},
			bold = {
				enabled = true,
				highlight = "RenderMarkdownBold",
			},
		},
		config = function(_, opts)
			require("render-markdown").setup(opts)
			-- Tokyo Night heading foregrounds
			vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#2d1e24", bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#2a1d22", bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#251a1f", bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#251a1f", bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#251a1f", bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = "#251a1f", bold = true })
			-- Subtle heading background strips
			vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#ffffff", fg = "#2d1e24", bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#e07898", fg = "#2a1d22", bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#ff2828", fg = "#ffffff", bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#980000", fg = "#ffffff", bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#980000", fg = "#ffffff", bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#980000", fg = "#ffffff", bold = true })
			-- Code blocks
			vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#282936" })
			vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = "#282936", fg = "#bbbdcc" })
			-- Misc
			vim.api.nvim_set_hl(0, "RenderMarkdownBold", { fg = "#7dcfff", bold = true })
			vim.api.nvim_set_hl(0, "@markup.strong", { fg = "#7dcfff", bold = true })
			vim.api.nvim_set_hl(0, "@markup.strong.markdown_inline", { fg = "#7dcfff", bold = true })
			vim.api.nvim_set_hl(0, "@markup.italic", { fg = "#e0af68", italic = true })
			vim.api.nvim_set_hl(0, "@markup.italic.markdown_inline", { fg = "#e0af68", italic = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#7aa2f7" })
			vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = "#bb9af7", italic = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownLink", { fg = "#7dcfff", underline = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = "#9ece6a" })
			vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = "#565f89" })
			vim.api.nvim_set_hl(0, "RenderMarkdownTableHead", { fg = "#7aa2f7", bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownTableRow", { fg = "#c0caf5" })
			vim.api.nvim_set_hl(0, "MarkdownBackground", { bg = "#1a1b26" })
		end,
		keys = {
			{
				"<leader>m",
				function()
					vim.cmd("RenderMarkdown toggle")
					if vim.wo.winhl == "" then
						vim.wo.winhl = "Normal:MarkdownBackground"
					else
						vim.wo.winhl = ""
					end
				end,
				desc = "Toggle Markdown Render",
			},
		},
	},

	--
	-- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
	-- Or use telescope!
	-- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
	-- you can continue same window with `<space>sr` which resumes last telescope search
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- theme changes -----------------------------------------------

-- vim.cmd [[highlight Visual guibg=#7a82c7 guifg=NONE]]
-- vim.cmd [[highlight Visual guibg=#263747 guifg=NONE]]

-- vim.cmd.colorscheme('honeywell')
vim.cmd.colorscheme("honeywell-cust")
-- vim.cmd.colorscheme('red-alert')
vim.opt.guicursor = "n-v-c:block,i:hor20"
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
