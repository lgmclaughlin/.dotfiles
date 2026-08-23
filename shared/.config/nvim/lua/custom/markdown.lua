local M = {}

local function is_top_level_task(line)
	return line:match("^- %[[ x]%]") ~= nil
end

local function has_checkbox(line)
	return line:match("%[[ x]%]") ~= nil
end

local function is_checked(line)
	return line:match("%[x%]") ~= nil
end

local function is_h2(line)
	return line:match("^## ") ~= nil
end

local function find_completed_heading(lines)
	for i, line in ipairs(lines) do
		if line:match("^## Completed%s*$") then
			return i
		end
	end
	return nil
end

local function find_next_h2_after(lines, start)
	for i = start + 1, #lines do
		if is_h2(lines[i]) then
			return i
		end
	end
	return #lines + 1
end

local function parse_task_blocks(lines, region_end)
	local blocks = {}
	local current = nil

	for i = 1, region_end - 1 do
		local line = lines[i]
		if is_top_level_task(line) then
			if current then
				table.insert(blocks, current)
			end
			current = { start = i, lines = { line } }
		elseif current then
			table.insert(current.lines, line)
		end
	end

	if current then
		table.insert(blocks, current)
	end

	return blocks
end

local function block_is_complete(block)
	local found_any = false
	for _, line in ipairs(block.lines) do
		if has_checkbox(line) then
			found_any = true
			if not is_checked(line) then
				return false
			end
		end
	end
	return found_any
end

function M.archive_completed()
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	local completed_heading = find_completed_heading(lines)
	if not completed_heading then
		vim.notify("No ## Completed section found", vim.log.levels.WARN)
		return
	end

	local blocks = parse_task_blocks(lines, completed_heading)

	local to_archive = {}
	local to_keep = {}
	for _, block in ipairs(blocks) do
		if block_is_complete(block) then
			table.insert(to_archive, block)
		else
			table.insert(to_keep, block)
		end
	end

	if #to_archive == 0 then
		vim.notify("No completed blocks to archive", vim.log.levels.INFO)
		return
	end

	local insert_at = find_next_h2_after(lines, completed_heading)

	local remove = {}
	local archived_lines = {}
	for _, block in ipairs(to_archive) do
		for j = 0, #block.lines - 1 do
			remove[block.start + j] = true
		end
		for _, line in ipairs(block.lines) do
			table.insert(archived_lines, line)
		end
	end

	local result = {}
	for i = 1, completed_heading - 1 do
		if not remove[i] then
			table.insert(result, lines[i])
		end
	end
	for i = completed_heading, insert_at - 1 do
		table.insert(result, lines[i])
	end
	if result[#result]:match("^## Completed%s*$") then
		table.insert(result, "")
	end
	for _, line in ipairs(archived_lines) do
		table.insert(result, line)
	end
	for i = insert_at, #lines do
		table.insert(result, lines[i])
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
	vim.notify(#to_archive .. " block(s) archived", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("Cmp", function()
	M.archive_completed()
end, {})

return M
