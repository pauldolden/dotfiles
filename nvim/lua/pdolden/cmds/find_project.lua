-- In lua/pdolden/cmds/find_project.lua
local tmux = require("pdolden.utils.tmux")
local config = require("pdolden.config")

-- Main function to find projects using fzf-lua
local function FindProjects()
	local has_fzf, fzf = pcall(require, 'fzf-lua')
	if not has_fzf then
		vim.notify("fzf-lua not found", vim.log.levels.ERROR)
		return
	end

	-- Check if fd is available
	if vim.fn.executable('fd') ~= 1 then
		vim.notify("fd not found. Install with: brew install fd", vim.log.levels.ERROR)
		return
	end

	local projects_dir = vim.fn.expand(config.projects_dir)
	local target_depth = config.projects_depth

	-- Build fd command
	local fd_cmd = string.format(
		"fd . %s --min-depth %d --max-depth %d --type d",
		vim.fn.shellescape(projects_dir),
		target_depth,
		target_depth
	)

	-- Build preview command
	local preview_cmd = "eza --tree --level=2 --icons {}"

	fzf.fzf_exec(fd_cmd, {
		prompt = "Projects> ",
		preview = preview_cmd,
		actions = {
			['default'] = function(selected)
				if selected and #selected > 0 then
					local path = selected[1]
					-- Default action: cd and close buffers
					vim.cmd("cd " .. vim.fn.fnameescape(path))
					vim.schedule(function()
						vim.cmd("%bd!")
						require("snacks").explorer()
					end)
					vim.notify("Changed to: " .. vim.fn.fnamemodify(path, ":~"), vim.log.levels.INFO)
				end
			end,
			['ctrl-t'] = function(selected)
				if selected and #selected > 0 then
					local path = selected[1]
					if not tmux.is_in_tmux() then
						vim.notify("Not inside tmux", vim.log.levels.WARN)
						return
					end
					tmux.open_project_in_session(path, true)
				end
			end,
			['ctrl-v'] = function(selected)
				if selected and #selected > 0 then
					local path = selected[1]
					-- Just cd without closing buffers
					vim.cmd("cd " .. vim.fn.fnameescape(path))
					vim.notify("Changed to: " .. vim.fn.fnamemodify(path, ":~") .. " (kept buffers)", vim.log.levels.INFO)
				end
			end,
			['ctrl-s'] = function(selected)
				if selected and #selected > 0 then
					local path = selected[1]
					-- Open in split with local cd
					vim.cmd("split")
					vim.cmd("lcd " .. vim.fn.fnameescape(path))
					vim.schedule(function()
						require("snacks").explorer()
					end)
				end
			end,
		},
	})
end

-- Create a command for the function
vim.api.nvim_create_user_command("FindProjects", FindProjects, {})

return { FindProjects = FindProjects }
