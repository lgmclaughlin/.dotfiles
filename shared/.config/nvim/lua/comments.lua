local M = {}

-- insert section ----------------------------------------------

M.width = 61

function M.insert_new_section()
  local cstr = vim.bo.commentstring or '# %s'

  local prefix, suffix = cstr:match '^(.-)%%s(.-)$'
  prefix = prefix or ''
  suffix = suffix or ''

  local line = prefix .. string.rep('-', M.width) .. suffix

  local row = vim.fn.line '.'
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { line })

  local col = #prefix
  vim.api.nvim_win_set_cursor(0, { row, col })

  vim.api.nvim_feedkeys('R', 'n', false)
end

-- insert summary ----------------------------------------------

function M.insert_summary()
  local row = vim.fn.line '.'
  local line_text = vim.api.nvim_get_current_line()

  local indent = line_text:match '^%s*' or ''

  local summary = {
    indent .. '/// <summary>',
    indent .. '///  ',
    indent .. '/// </summary>',
  }

  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, summary)

  vim.api.nvim_win_set_cursor(0, { row + 1, #indent + 5 })

  vim.api.nvim_command 'startinsert'
end

-- return ------------------------------------------------------

return M
