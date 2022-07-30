-- :lua require'tokyonight-fade'.setup()

local M = {}

M.setup = function (opts)
	local options = opts or {}

	-- Detect user theme.
	local theme = vim.g.colors_name
	local tokyonight_version = vim.g.tokyonight_style
	local background = vim.o.background

	if (theme ~= 'tokyonight' or background ~= 'dark' or tokyonight_version ~= 'storm') then
		error'Theme installed is not Tokyonight storm !'
	end

	-- Set Hightlight-groups 
	vim.cmd [[ highlight ActiveWindows guibg=#24283b ]]
	vim.cmd [[ highlight NonActiveWindows guibg=#2C3043 ]]
	vim.cmd [[ highlight NonActiveWinbar guibg=#2C3043 ]]

	vim.cmd [[
		set winhighlight=Normal:ActiveWindows,NormalNC:NonActiveWindows,WinBarNC:NonActiveWinbar
	]]

	vim.cmd [[ highlight TabLineSel guibg=#3d59a1 guifg=#FFFFFF ]] -- active Tab
	vim.cmd [[ highlight TabLine guibg=#2C3043 guifg=#CCCCCC ]] -- non active Tab
	vim.cmd [[ highlight TabLineFill guibG=#24283b ]] -- no labels Tab

	-- Autocmd to change specific 'items'
	local group = vim.api.nvim_create_augroup('change_color', { clear = true })

	vim.api.nvim_create_autocmd({ 'WinEnter' }, {
		group = group,
		callback = function ()
			-- DEBUG: get current buffer path and current buffer name
			-- local current_buf_path = vim.api.nvim_buf_get_name(0)
			-- local current_buf_name = vim.fn.expand('%:t')
			-- print('Path: ' .. current_buf_path)
			-- print('Name: ' .. current_buf_name)

			vim.opt.colorcolumn = options.cc == '80' and '80' or '0'
			vim.opt.cursorline = options.cl == true and true or false
			vim.opt.signcolumn = options.sc == 'yes' and 'yes' or 'no'
		end
	})

	vim.api.nvim_create_autocmd({ 'WinLeave' }, {
		group = group,
		callback = function ()
			-- Get current buffer name
			local current_buf_name = vim.fn.expand('%:t')

			vim.opt.colorcolumn = options.cc
			vim.opt.cursorline = options.cl
			vim.opt.signcolumn = options.sc

			-- Change color of NvimTree Non Current background
			if (options.nvimtree and current_buf_name == 'NvimTree_1') then
				vim.api.nvim_set_hl(0, 'NvimTreeNormalNC', { bg = '#2C3043' })
			end
		end
	})
end

return M
