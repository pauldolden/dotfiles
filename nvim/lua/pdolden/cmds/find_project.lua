-- In lua/pdolden/cmds/find_project.lua
local uv = vim.loop
local tmux = require("pdolden.utils.tmux")
local config = require("pdolden.config")

-- Function to walk directories and collect only those at `target_depth`
local function collect_dirs_at_depth(root, current_depth, target_depth, results)
	if current_depth > target_depth then return end
	local handle = uv.fs_scandir(root)
	if not handle then return end
	while true do
		local name, type = uv.fs_scandir_next(handle)
		if not name then break end
		local full_path = root .. "/" .. name
		if type == "directory" then
			if current_depth == target_depth then
				table.insert(results, full_path)
			else
				collect_dirs_at_depth(full_path, current_depth + 1, target_depth, results)
			end
		end
	end
end

-- Main function to find projects
local function FindProjects()
	local projects_dir = config.projects_dir
	local projects = {}
	local target_depth = config.projects_depth

	collect_dirs_at_depth(projects_dir, 1, target_depth, projects)

	if #projects == 0 then
		vim.notify("No projects found at depth " .. target_depth, vim.log.levels.WARN)
		return
	end

	-- Sort projects alphabetically for easier browsing
	table.sort(projects)

	-- Convert to format Snacks expects
	local items = {}
	for _, path in ipairs(projects) do
		table.insert(items, {
			text = path,
			path = path,
		})
	end

	require("snacks").picker.pick({
		items = items,
		prompt = "Select a project > ",
		format = function(item)
			return vim.fn.fnamemodify(item.path, ":~")
		end,
		preview = function(item, ctx)
			-- Show directory tree preview if eza is available
			local has_eza = vim.fn.executable("eza") == 1
			if has_eza then
				return vim.system(
					{ "eza", "-T", "-L", "2", "--icons", item.path },
					{ text = true }
				):wait()
			else
				return vim.system(
					{ "ls", "-lah", item.path },
					{ text = true }
				):wait()
			end
		end,
		confirm = function(item)
			if item then
				tmux.open_project_in_session(item.path, false)
			end
		end,
		actions = {
			["ctrl-t"] = function(item)
				-- Force new tmux session even if one exists
				if item then
					if not tmux.is_in_tmux() then
						vim.notify("Not inside tmux", vim.log.levels.WARN)
						return
					end
					tmux.open_project_in_session(item.path, true)
				end
			end,
			["ctrl-v"] = function(item)
				-- Just cd without creating session
				if item then
					vim.cmd("cd " .. vim.fn.fnameescape(item.path))
					vim.schedule(function()
						require("snacks").explorer()
					end)
					vim.notify("Changed directory (no session)", vim.log.levels.INFO)
				end
			end,
			["ctrl-s"] = function(item)
				-- Split current window and cd there
				if item then
					vim.cmd("split")
					vim.cmd("cd " .. vim.fn.fnameescape(item.path))
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
