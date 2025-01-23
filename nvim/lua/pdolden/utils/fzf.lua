local fzf = require("fzf-lua")
local uv = vim.loop

-- Define the function
local function FindProjects()
  -- Update this to your projects directory
  local projects_dir = vim.fn.expand("~/Development/Projects")

  -- Get a list of directories in the projects directory
  local handle = uv.fs_scandir(projects_dir)
  if not handle then
    vim.notify("Projects directory not found!", vim.log.levels.ERROR)
    return
  end

  local projects = {}
  while true do
    local name, type = uv.fs_scandir_next(handle)
    if not name then break end
    if type == "directory" then
      table.insert(projects, projects_dir .. "/" .. name)
    end
  end

  -- Use fzf-lua to display the list
  fzf.fzf_exec(projects, {
    prompt = "Select a project > ",
    actions = {
      -- When an item is selected
      ["default"] = function(selected)
        if selected then
          -- Change directory to the selected project
          vim.cmd("cd " .. selected[1])

          -- Refresh NeoTree
          vim.cmd("Neotree focus")
        end
      end,
    },
  })
end

-- Create a command for the function
vim.api.nvim_create_user_command("FindProjects", FindProjects, {})
