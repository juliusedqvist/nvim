return {
	"nvim-lua/plenary.nvim", -- lazy.nvim wants a plugin; this is a safe dummy
	lazy = false,
	config = function()
		vim.api.nvim_create_user_command("Duplicate", function(opts)
			local args = opts.fargs
			if #args < 2 then
				print("Usage: :Duplicate <folder_name> <file_name>")
				return
			end

			local folder = args[1]
			local file = args[2]

			local src = vim.fn.expand("%:p")
			local dest_dir = "/home/arch/Obsidian/Studier/" .. folder
			local dest_path = dest_dir .. "/" .. file

			-- Create folder if it doesn't exist
			vim.fn.mkdir(dest_dir, "p")

			-- Write the file
			vim.cmd("silent! write! " .. vim.fn.fnameescape(dest_path))
			print("File duplicated to " .. dest_path)
		end, {
			nargs = "+",
			complete = nil, -- optional: could add custom completions
		})
	end,
}
