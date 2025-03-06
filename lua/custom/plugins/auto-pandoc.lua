return {
	"jghauser/auto-pandoc.nvim", -- Replace with actual GitHub repo if needed
	config = function()
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*.md",
			callback = function()
				vim.keymap.set("n", "go", function()
					require("auto-pandoc").run_pandoc()
				end, { silent = true, buffer = 0 })
			end,
			group = vim.api.nvim_create_augroup("setAutoPandocKeymap", { clear = true }),
			desc = "Set keymap for auto-pandoc",
		})
	end,
}
