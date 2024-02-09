return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		tag = '0.1.5',
		config = function()
			require('telescope').setup({})

			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
			vim.keymap.set('n', '<C-p>', builtin.git_files, {})
			vim.keymap.set('n', '<leader>ps', function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end)
            vim.keymap.set('n', '<leader>pws', function()
                builtin.grep_string({ search = vim.fn.expand("<cword>") })
            end)
            vim.keymap.set('n', '<leader>pWs', function()
                builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
            end)
			vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
		end
	},
}
