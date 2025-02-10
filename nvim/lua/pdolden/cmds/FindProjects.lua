local fzf = require("fzf-lua")
local uv = vim.loop

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
        table.insert(results, full_path) -- Add only if at exact depth
      else
        collect_dirs_at_depth(full_path, current_depth + 1, target_depth, results) -- Recurse
      end
    end
  end
end

-- Main function to find projects
local function FindProjects()
  local projects_dir = vim.fn.expand("~/Development") -- Change this if needed
  local projects = {}

  -- Set the exact depth to search (e.g., 3 means ~/Development/X/Y/Z)
  local target_depth = 3

  -- Collect directories exactly at `target_depth`
  collect_dirs_at_depth(projects_dir, 1, target_depth, projects)

  if #projects == 0 then
    vim.notify("No projects found at depth " .. target_depth, vim.log.levels.WARN)
    return
  end

  -- Use fzf-lua to display the list
  fzf.fzf_exec(projects, {
    prompt = "Select a project > ",
    actions = {
      ["default"] = function(selected)
        if selected then
          vim.cmd("cd " .. selected[1])
          vim.cmd("Neotree focus") -- Refresh NeoTree
        end
      end,
    },
  })
end

-- Create a command for the function
vim.api.nvim_create_user_command("FindProjects", FindProjects, {})
