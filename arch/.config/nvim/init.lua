-- allow opacity

vim.cmd("hi Normal guibg=none")
vim.cmd("hi NormalNC guibg=none")
vim.cmd("hi SignColumn guibg=none")
vim.cmd("hi LineNr guibg=none")

-- keymaps

vim.g.mapleader = ","

vim.api.nvim_set_keymap(
	'n', '<leader>cs',
	':lua require("comments").insert_section()<CR>',
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap('n', '<leader>r',
	':lua require("devtools").ReloadConfig()<CR>',
	{ noremap = true, silent = true }
)
