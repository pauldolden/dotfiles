local uv = vim.loop
local tmux = require("pdolden.utils.tmux")

-- Extract repo name from git URL
local function get_repo_name_from_url(url)
	-- Handle various git URL formats:
	-- https://github.com/user/repo.git
	-- git@github.com:user/repo.git
	-- https://github.com/user/repo
	local name = url:match("([^/]+)%.git$") or url:match("([^/]+)$")
	if name then
		return name:gsub("%.git$", "")
	end
	return nil
end

-- Main function to clone a project
local function CloneProject()
	-- Get current working directory and go up one level
	local current_dir = vim.fn.getcwd()
	local parent_dir = vim.fn.fnamemodify(current_dir, ":h")

	-- Prompt for git URL
	vim.ui.input({
		prompt = "Git repository URL: ",
		default = "",
	}, function(git_url)
		if not git_url or git_url == "" then
			vim.notify("Clone cancelled", vim.log.levels.INFO)
			return
		end

		-- Extract repository name from URL
		local repo_name = get_repo_name_from_url(git_url)
		if not repo_name then
			vim.notify("Could not determine repository name from URL", vim.log.levels.ERROR)
			return
		end

		local project_path = parent_dir .. "/" .. repo_name

		-- Check if directory already exists
		local stat = uv.fs_stat(project_path)
		if stat then
			vim.notify("Directory already exists: " .. project_path, vim.log.levels.ERROR)
			return
		end

		vim.notify("Cloning " .. git_url .. " to " .. project_path .. "...", vim.log.levels.INFO)

		-- Clone the repository asynchronously
		local cmd = string.format("git clone %s %s", vim.fn.shellescape(git_url), vim.fn.shellescape(project_path))

		vim.fn.jobstart(cmd, {
			on_exit = function(_, exit_code)
				if exit_code == 0 then
					vim.schedule(function()
						vim.notify("Clone completed: " .. project_path, vim.log.levels.INFO)
						-- Switch to the cloned project
						tmux.open_project_in_session(project_path, false)
					end)
				else
					vim.schedule(function()
						vim.notify("Clone failed with exit code: " .. exit_code, vim.log.levels.ERROR)
					end)
				end
			end,
			on_stdout = function(_, data)
				if data and #data > 0 then
					vim.schedule(function()
						for _, line in ipairs(data) do
							if line ~= "" then
								vim.notify(line, vim.log.levels.INFO)
							end
						end
					end)
				end
			end,
			on_stderr = function(_, data)
				if data and #data > 0 then
					vim.schedule(function()
						for _, line in ipairs(data) do
							if line ~= "" then
								vim.notify(line, vim.log.levels.WARN)
							end
						end
					end)
				end
			end,
			stdout_buffered = false,
			stderr_buffered = false,
		})
	end)
end

-- Create a command for the function
vim.api.nvim_create_user_command("CloneProject", CloneProject, {})

return { CloneProject = CloneProject }
