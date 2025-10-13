-- In lua/pdolden/cmds/find_project.lua
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
        table.insert(results, full_path)
      else
        collect_dirs_at_depth(full_path, current_depth + 1, target_depth, results)
      end
    end
  end
end

-- Helper to get session name from path
local function get_session_name_from_path(path)
  local name = vim.fn.fnamemodify(path, ':t')
  return name:gsub('[^%w-_]', '-')
end

-- Check if we're in tmux
local function is_in_tmux()
  return vim.env.TMUX ~= nil
end

-- Check if a tmux session exists
local function session_exists(name)
  local handle = io.popen('tmux list-sessions -F "#{session_name}" 2>/dev/null')
  if not handle then return false end

  for session in handle:lines() do
    if session == name then
      handle:close()
      return true
    end
  end
  handle:close()
  return false
end

-- Setup tmux session with nvim in window 0 and shell in window 1
local function setup_project_session(session_name, path)
  -- Create session with nvim in first window
  vim.fn.system(string.format(
    'tmux new-session -d -s %s -c %s -n editor nvim',
    vim.fn.shellescape(session_name),
    vim.fn.shellescape(path)
  ))

  -- Create second window with shell
  vim.fn.system(string.format(
    'tmux new-window -t %s:1 -n terminal -c %s',
    vim.fn.shellescape(session_name),
    vim.fn.shellescape(path)
  ))

  -- Select the first window (editor)
  vim.fn.system(string.format(
    'tmux select-window -t %s:0',
    vim.fn.shellescape(session_name)
  ))
end

-- Create and switch to tmux session for project
local function open_project_in_session(path, force_new)
  local session_name = get_session_name_from_path(path)

  if not is_in_tmux() then
    -- Not in tmux, just change directory
    vim.cmd("cd " .. vim.fn.fnameescape(path))
    vim.notify("Changed to: " .. path .. " (not in tmux)", vim.log.levels.INFO)
    vim.cmd("Neotree focus")
    return
  end

  -- If forcing new session, add timestamp
  if force_new and session_exists(session_name) then
    session_name = session_name .. "-" .. os.time()
  end

  if session_exists(session_name) then
    -- Session exists, just switch to it
    vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(session_name))
    vim.notify("Switched to session: " .. session_name, vim.log.levels.INFO)
  else
    -- Create new session with proper setup
    setup_project_session(session_name, path)

    -- Switch to the new session
    vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(session_name))
    vim.notify("Created session: " .. session_name, vim.log.levels.INFO)
  end
end

-- Main function to find projects
local function FindProjects()
  local projects_dir = vim.fn.expand("~/dev")
  local projects = {}
  local target_depth = 3

  collect_dirs_at_depth(projects_dir, 1, target_depth, projects)

  if #projects == 0 then
    vim.notify("No projects found at depth " .. target_depth, vim.log.levels.WARN)
    return
  end

  -- Sort projects alphabetically for easier browsing
  table.sort(projects)

  fzf.fzf_exec(projects, {
    prompt = "Select a project > ",
    winopts = {
      height = 0.6,
      width = 0.8,
      preview = {
        -- Show directory tree preview if you have exa/eza installed
        type = "cmd",
        fn = function(items)
          local path = items[1]
          -- Try eza first (modern replacement), fall back to ls
          return string.format(
            "command -v eza >/dev/null && eza -T -L 2 --icons %s || ls -lah %s",
            vim.fn.shellescape(path),
            vim.fn.shellescape(path)
          )
        end,
      },
    },
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          open_project_in_session(selected[1], false)
        end
      end,
      ["ctrl-t"] = function(selected)
        -- Force new tmux session even if one exists
        if selected and #selected > 0 then
          if not is_in_tmux() then
            vim.notify("Not inside tmux", vim.log.levels.WARN)
            return
          end
          open_project_in_session(selected[1], true)
        end
      end,
      ["ctrl-v"] = function(selected)
        -- Just cd without creating session (original behaviour)
        if selected and #selected > 0 then
          vim.cmd("cd " .. vim.fn.fnameescape(selected[1]))
          vim.cmd("Neotree focus")
          vim.notify("Changed directory (no session)", vim.log.levels.INFO)
        end
      end,
      ["ctrl-s"] = function(selected)
        -- Split current window and cd there
        if selected and #selected > 0 then
          vim.cmd("split")
          vim.cmd("cd " .. vim.fn.fnameescape(selected[1]))
          vim.cmd("Neotree focus")
        end
      end,
    },
  })
end

-- Create a command for the function
vim.api.nvim_create_user_command("FindProjects", FindProjects, {})

return { FindProjects = FindProjects }
