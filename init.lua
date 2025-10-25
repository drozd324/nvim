-- Bootstrap lazy.nvim -- no idea what is going on here but it make Lazy work
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			'everviolet/nvim',
			name = 'evergarden',
			priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
			opts = {
				theme = {
					variant = 'fall', -- 'winter'|'fall'|'spring'|'summer'
					accent = 'green',
				},
				editor = {
					transparent_background = false,
					sign = { color = 'none' },
					float = {
						color = 'mantle',
						invert_border = false,
					},
					completion = {
						color = 'surface0',
					},
				},
			}
		},

		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = { "c", "cpp", "python", "bash", "lua", "html" },
					sync_install = false,
					highlight = { enable = true },
					indent = { enable = true },
				})
			end
		},

		{
			'nvim-telescope/telescope.nvim',
			tag = '0.1.8',
			dependencies = {
				'nvim-lua/plenary.nvim',
				{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
			},
		},

	},

	-- configure any other settings here. see the documentation for more details.
	-- automatically check for plugin updates
	checker = { enabled = true, notify = false },
})

--------------------------------- lsp stuff -------------------------------------------------

vim.lsp.config["lua-language-server"] = {
	cmd = { 'lua-language-server', '--background-index' },
	root_markers = { '.luarc.json' },
	filetypes = { 'lua' },
}
vim.lsp.enable('lua-language-server')


vim.lsp.config["clangd"] = {
	cmd = { 'clangd', '--background-index' },
	root_markers = { 'compile_commands.json', 'compile_flags.txt' },
	filetypes = { 'c', 'cpp', 'cu' },
}
vim.lsp.enable('clangd')


vim.lsp.config["bash-language-server"] = {
	cmd = { 'bash-language-server' },
	--root_markers = { 'compile_commands.json', 'compile_flags.txt' },
	filetypes = { 'sh', 'bash' },
}
vim.lsp.enable('bash-language-server')


vim.lsp.config["python-lsp-server"] = {
  cmd = { 'python-lsp-server', '--background-index' },
  --root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'py' },
}
vim.lsp.enable('python-lsp-server')


vim.api.nvim_create_autocmd('lspattach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		--    if client:supports_method('textdocument/completion') then
		--      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		--    end
	end,
})

----------------------------------------------------------------------------------

vim.cmd("colorscheme evergarden")

---- Toggle these for line number shenanigans
--vim.o.termguicolors = true
--vim.opt.termguicolors = true
--vim.opt.number = true
--vim.opt.relativenumber = true
--vim.cmd [[
--  highlight LineNr guifg=#444444
--]]

vim.o.laststatus = 0
vim.opt.clipboard = "unnamedplus"

---- Does good indenting with tab
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end
})

---- Disable automatic comment continuation on newline
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

---- transparent backgound
vim.cmd [[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
  hi Pmenu guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
  hi VertSplit guibg=NONE ctermbg=NONE
  hi StatusLine guibg=NONE ctermbg=NONE
]]

---- saves history even when closed
vim.o.undofile = true
