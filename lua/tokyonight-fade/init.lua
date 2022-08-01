-- :lua require'tokyonight-fade'.setup()

-- TODO: fix gitsigns 'gg' and 'gh'
-- TODO: fix packer cursorline 
-- TODO: fix glow plugin

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

	-- NvimTree default background
	vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = '#1f2335' })


	local fade = vim.api.nvim_create_augroup('basic_fade', { clear = true })

	vim.api.nvim_create_autocmd({ 'FileType', 'WinEnter' }, {
		group = fade,
		callback = function ()
			-- Set Hightlight-groups 
			vim.cmd [[ highlight NormalNC guibg=#2C3043 ]]
			vim.cmd [[ highlight WinBarNC guibg=#2C3043 ]]

			vim.cmd [[ highlight TabLineSel guibg=#3d59a1 guifg=#FFFFFF ]] -- active Tab
			vim.cmd [[ highlight TabLine guibg=#2C3043 guifg=#CCCCCC ]] -- non active Tab
			vim.cmd [[ highlight TabLineFill guibG=#24283b ]] -- no labels Tab

			-- Deal with NvimTree
			local current_buf_name = vim.fn.expand('%:t')
			if (current_buf_name ~= 'NvimTree_1') then
				vim.api.nvim_set_hl(0, 'NvimTreeNormalNC', { bg = '#2C3043' })
			end

			-- Deal with Telescope popup
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

				vim.api.nvim_set_hl(0, 'Normal', { bg = '#24283b' })
			elseif (filetype ~= 'dashboard') then
				-- Set options
				vim.opt.colorcolumn = options.cc == true and '80' or '0'
				vim.opt.signcolumn = options.sc == true and 'yes' or 'no'
				vim.opt.cursorline = true
			end
		end
	})

	vim.api.nvim_create_autocmd({ 'WinLeave' }, {
		group = fade,
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

			-- Deal with NvimTree plugin
			local current_buf_name = vim.fn.expand('%:t')

			if (options.nvimtree == true and current_buf_name == 'NvimTree_1') then
				vim.api.nvim_set_hl(0, 'NvimTreeNormalNC', { bg = '#2C3043' })
				vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = '#1f2335' })
			end

			-- Deal with Dashboard plugin
			if (filetype == 'dashboard') then
				vim.api.nvim_set_hl(0, 'Normal', { bg = '#2C3043' })
			end
		end
	})
end

return M
