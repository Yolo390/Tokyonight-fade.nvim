local M = {}

M.setup = function ()
	print'tokyonight-fade loaded !'

	-- Detect user theme.
	local theme = vim.g.colors_name

	if (theme ~= 'tokyonight') then
		print'ERRORS'
		print'Theme installed is not Tokyonight...'
		return nil
	end

	-- TODO: find how to improve opacity between active and non active windows !
	-- TODO: change signcolumn or foldcolumn

	-- Set Hightlight-groups 
	vim.cmd [[ highlight ActiveWindows guibg=#24283b ]]
	vim.cmd [[ highlight NonActiveWindows guibg=#2C3043 ]]
	vim.cmd [[ highlight NonActiveWinbar guibg=#2C3043 ]]
	vim.cmd [[ highlight NonActiveStatusLine guibg=#2C3043 ]]
	vim.cmd [[ highlight TabLineSel guibg=#292e42 guifg=#ffffff ]] -- active Tab
	vim.cmd [[ highlight TabLine guibg=#2C3043 ]] -- non active Tab
	vim.cmd [[ highlight TabLineFill guibg=#000000 ]] -- no labels


	vim.cmd [[
		set winhighlight=Normal:ActiveWindows,NormalNC:NonActiveWindows,WinBarNC:NonActiveWinbar,StatusLineNC:NonActiveStatusLine
	]]

	-- NOT WORKING YET...
	-- local group = vim.api.nvim_create_augroup('change_color', { clear = true })
	-- vim.api.nvim_create_autocmd({ 'VimEnter', 'BufEnter', 'BufWinEnter' }, {
	-- 	command = 'set colorcolumn=80',
	-- 	group = group,
	-- 	buffer = 0
	-- })
	-- vim.api.nvim_create_autocmd({ 'BufLeave' }, {
	-- 	command = 'set colorcolumn=0',
	-- 	group = group,
	-- 	buffer = 0
	-- })
end

return M
