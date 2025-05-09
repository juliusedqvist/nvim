return {
	"nvim-lua/plenary.nvim", -- lazy.nvim wants a plugin; this is a safe dummy
	lazy = false,
	config = function()
		vim.api.nvim_create_user_command("Duplicate", function()
			local src = vim.fn.expand("%:p")
			local filename = vim.fn.expand("%:t")
			local current_folder = vim.fn.fnamemodify(src, ":p:h:t")
			local parent_folder = vim.fn.fnamemodify(vim.fn.fnamemodify(src, ":p:h:h"), ":t")

			local dest_dir = "/home/arch/Obsidian/Studier/" .. parent_folder .. "/" .. current_folder
			local dest_path = dest_dir .. "/" .. filename

			-- Create folder if it doesn't exist
			vim.fn.mkdir(dest_dir, "p")

			-- Write the file
			vim.cmd("silent! write! " .. vim.fn.fnameescape(dest_path))
			print("File duplicated to " .. dest_path)

			-- Prompt the user
			vim.ui.input({ prompt = "Also add to Anki via apy? (y/n): " }, function(input)
				if input == "y" or input == "Y" then
					local escaped_filename = vim.fn.shellescape(filename)
					local escaped_deck = vim.fn.shellescape(parent_folder)

					local cmd = "apy add-from-file " .. escaped_filename .. " -d " .. escaped_deck .. " && apy sync"

					-- Open a horizontal split terminal
					vim.cmd("belowright split")
					vim.cmd("resize 15")
					vim.cmd("term " .. cmd)
					vim.cmd("startinsert")
				end
			end)
		end, {
			nargs = 0,
		})

		vim.api.nvim_create_user_command("FlashcardPrompt", function()
			local api_key = os.getenv("OPENAI_API_KEY")
			if not api_key then
				vim.notify("OPENAI_API_KEY is not set!", vim.log.levels.ERROR)
				return
			end

			-- Get visual selection
			local start_pos = vim.fn.getpos("'<")
			local end_pos = vim.fn.getpos("'>")
			local bufnr = 0 -- current buffer

			local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos[2] - 1, end_pos[2], false)
			if #lines == 0 then
				vim.notify("No text selected", vim.log.levels.WARN)
				return
			end

			-- Adjust for partial selection on first/last line
			lines[1] = string.sub(lines[1], start_pos[3], -1)
			lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])

			local input = table.concat(lines, "\n")

			local curl_cmd = {
				"curl",
				"-s",
				"https://api.openai.com/v1/chat/completions",
				"-H",
				"Content-Type: application/json",
				"-H",
				"Authorization: Bearer " .. api_key,
				"-d",
				vim.fn.json_encode({
					model = "gpt-4o-mini",
					messages = {
						{ role = "user", content = input },
					},
					temperature = 0.7,
				}),
			}

			vim.fn.jobstart(curl_cmd, {
				stdout_buffered = true,
				on_stdout = function(_, data)
					if data then
						local decoded = vim.fn.json_decode(data)
						local content = decoded.choices[1].message.content

						vim.cmd("vsplit")
						local new_buf = vim.api.nvim_create_buf(false, true)
						vim.api.nvim_win_set_buf(0, new_buf)
						vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, vim.split(content, "\n"))
						vim.bo.filetype = "markdown"
					end
				end,
			})
		end, { range = true })
	end,
}
