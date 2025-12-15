local uv = vim.loop
local tmux = require("pdolden.utils.tmux")

-- Main function to create a new project
local function CreateProject()
  -- Get current working directory and go up one level
  local current_dir = vim.fn.getcwd()
  local parent_dir = vim.fn.fnamemodify(current_dir, ':h')

  -- Prompt for project name
  vim.ui.input({
    prompt = 'Project name: ',
    default = '',
  }, function(project_name)
    if not project_name or project_name == '' then
      vim.notify("Project creation cancelled", vim.log.levels.INFO)
      return
    end

    -- Clean the project name (remove special chars, replace spaces with dashes)
    project_name = project_name:gsub('[^%w-_ ]', ''):gsub('%s+', '-')

    local project_path = parent_dir .. '/' .. project_name

    -- Check if directory already exists
    local stat = uv.fs_stat(project_path)
    if stat then
      vim.notify("Directory already exists: " .. project_path, vim.log.levels.ERROR)
      return
    end

    -- Create the directory
    local success, err = uv.fs_mkdir(project_path, 493) -- 493 = 0755 in octal
    if not success then
      vim.notify("Failed to create directory: " .. tostring(err), vim.log.levels.ERROR)
      return
    end

    vim.notify("Created project: " .. project_path, vim.log.levels.INFO)

    -- Switch to the new project
    tmux.open_project_in_session(project_path, false)
  end)
end

-- Create a command for the function
vim.api.nvim_create_user_command("CreateProject", CreateProject, {})

return { CreateProject = CreateProject }
