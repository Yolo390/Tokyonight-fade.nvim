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
	local basic_fade = vim.api.nvim_create_augroup('basic_fade', { clear = true })
	-- local dashboard_fade = vim.api.nvim_create_augroup('dashboard_fade', { clear = true })

	vim.api.nvim_create_autocmd({ 'FileType', 'WinEnter' }, {
		group = basic_fade,
		callback = function ()
			-- Change CursorLine and ColorColumn of Telescope popup prompt
			local win_type = vim.fn.win_gettype(0)
			local filetype = vim.bo.filetype

			if (win_type == 'popup' and filetype == 'TelescopePrompt') then
				vim.cmd [[ highlight CursorLine guibg=#24283b ]]
				vim.cmd [[ highlight ColorColumn guibg=#24283b ]]
			end

			-- Deal with Dashboard plugin
			if (filetype == 'dashboard') then
				-- Set options
				vim.opt.colorcolumn = '0'
				vim.opt.signcolumn = 'no'
				vim.opt.cursorline = false
			elseif (filetype ~= 'dashboard') then
				-- Set options
				vim.opt.colorcolumn = options.cc == true and '80' or '0'
				vim.opt.signcolumn = options.sc == true and 'yes' or 'no'
				vim.opt.cursorline = true
			end
		end
	})

	vim.api.nvim_create_autocmd({ 'WinLeave' }, {
		group = basic_fade,
		callback = function ()
			-- Reset CursorLine and ColorColumn when leave Telescope popup prompt
			local win_type = vim.fn.win_gettype(0)
			local filetype = vim.bo.filetype

			if (win_type == 'popup' and filetype == 'TelescopePrompt') then
				vim.cmd [[ highlight CursorLine guibg=#2C3043 ]]
				vim.cmd [[ highlight ColorColumn guibg=#1f2335 ]]
			end

			-- Set options
			vim.opt.colorcolumn = '0'
			vim.opt.cursorline = false
			vim.opt.signcolumn = 'no'

			-- Change color of NvimTree Non Current background
			local current_buf_name = vim.fn.expand('%:t')

			if (options.nvimtree == true and current_buf_name == 'NvimTree_1') then
				vim.api.nvim_set_hl(0, 'NvimTreeNormalNC', { bg = '#2C3043' })
			end
		end
	})
end

return M
