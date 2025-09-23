-- insert section ----------------------------------------------

local M = {}
M.width = 60

function M.insert_section()
	local cstr = vim.bo.commentstring or "# %s"
	local comment_char = cstr:match("^(.-)%%s") or "#"
	local line = comment_char .. " " .. string.rep("-", M.width)
	vim.api.nvim_set_current_line(line)

	local col = #comment_char 
	vim.api.nvim_win_set_cursor(0, {vim.fn.line("."), col})
	
	local keys = vim.api.nvim_replace_termcodes("R", true, false, true)
	vim.api.nvim_feedkeys("R", "n", false)
end

return M
