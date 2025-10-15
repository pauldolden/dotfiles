-- In lua/pdolden/cmds/tmux.lua
local M = {}

-- Get the current project name (basename of cwd)
local function get_project_name()
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(cwd, ':t'):gsub('[^%w-_]', '-')
end

-- Check if we're inside tmux
local function is_in_tmux()
  return vim.env.TMUX ~= nil
end

-- Get list of tmux sessions
local function get_sessions()
  local handle = io.popen('tmux list-sessions -F "#{session_name}" 2>/dev/null')
  if not handle then return {} end

  local sessions = {}
  for session in handle:lines() do
    table.insert(sessions, session)
  end
  handle:close()
  return sessions
end

-- Check if a tmux session exists
local function session_exists(name)
  local sessions = get_sessions()
  for _, session in ipairs(sessions) do
    if session == name then
      return true
    end
  end
  return false
end

-- Switch to session (fast, no UI)
local function switch_to_session(name)
  if not is_in_tmux() then
    vim.notify("Not inside tmux", vim.log.levels.WARN)
    return false
  end

  vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(name))
  return true
end

-- Create or switch to a named tmux session based on project
function M.create_or_switch_session()
  if not is_in_tmux() then
    vim.notify("Not inside tmux", vim.log.levels.WARN)
    return
  end

  local project_name = get_project_name()

  if session_exists(project_name) then
    switch_to_session(project_name)
    vim.notify("Switched to session: " .. project_name, vim.log.levels.INFO)
  else
    vim.fn.system('tmux new-session -d -s ' ..
      vim.fn.shellescape(project_name) .. ' -c ' .. vim.fn.shellescape(vim.fn.getcwd()))
    switch_to_session(project_name)
    vim.notify("Created session: " .. project_name, vim.log.levels.INFO)
  end
end

-- FZF-based session switcher
function M.fzf_sessions()
  if not is_in_tmux() then
    vim.notify("Not inside tmux", vim.log.levels.WARN)
    return
  end

  local has_fzf, fzf = pcall(require, 'fzf-lua')
  if not has_fzf then
    vim.notify("fzf-lua not found", vim.log.levels.WARN)
    return
  end

  local sessions = get_sessions()
  if #sessions == 0 then
    vim.notify("No tmux sessions found", vim.log.levels.INFO)
    return
  end

  fzf.fzf_exec(sessions, {
    prompt = 'Tmux Sessions> ',
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          switch_to_session(selected[1])
          vim.notify("Switched to: " .. selected[1], vim.log.levels.INFO)
        end
      end,
      ['ctrl-d'] = function(selected)
        if selected and #selected > 0 then
          vim.fn.system('tmux kill-session -t ' .. vim.fn.shellescape(selected[1]))
          vim.notify("Killed session: " .. selected[1], vim.log.levels.INFO)
          -- Reopen picker
          vim.schedule(function()
            M.fzf_sessions()
          end)
        end
      end,
    },
  })
end

-- Create new session with custom name
function M.new_session()
  if not is_in_tmux() then
    vim.notify("Not inside tmux", vim.log.levels.WARN)
    return
  end

  vim.ui.input({
    prompt = 'New session name: ',
    default = get_project_name(),
  }, function(name)
    if name and name ~= '' then
      name = name:gsub('[^%w-_]', '-')
      if session_exists(name) then
        vim.notify("Session already exists: " .. name, vim.log.levels.WARN)
        return
      end
      vim.fn.system('tmux new-session -d -s ' ..
        vim.fn.shellescape(name) .. ' -c ' .. vim.fn.shellescape(vim.fn.getcwd()))
      switch_to_session(name)
      vim.notify("Created and switched to: " .. name, vim.log.levels.INFO)
    end
  end)
end

-- Kill a session interactively
function M.kill_session()
  if not is_in_tmux() then
    vim.notify("Not inside tmux", vim.log.levels.WARN)
    return
  end

  local sessions = get_sessions()
  if #sessions == 0 then
    vim.notify("No sessions to kill", vim.log.levels.INFO)
    return
  end

  vim.ui.select(sessions, {
    prompt = 'Kill tmux session:',
  }, function(choice)
    if choice then
      vim.fn.system('tmux kill-session -t ' .. vim.fn.shellescape(choice))
      vim.notify("Killed session: " .. choice, vim.log.levels.INFO)
    end
  end)
end

-- Rename current session
function M.rename_session()
  if not is_in_tmux() then
    vim.notify("Not inside tmux", vim.log.levels.WARN)
    return
  end

  local current = vim.fn.system('tmux display-message -p "#S"'):gsub('\n', '')

  vim.ui.input({
    prompt = 'Rename session to: ',
    default = current,
  }, function(name)
    if name and name ~= '' and name ~= current then
      name = name:gsub('[^%w-_]', '-')
      vim.fn.system('tmux rename-session ' .. vim.fn.shellescape(name))
      vim.notify("Renamed to: " .. name, vim.log.levels.INFO)
    end
  end)
end

-- Rename current tmux window to match file/buffer
function M.rename_window_to_file()
  if not is_in_tmux() then
    return
  end

  local filename = vim.fn.expand('%:t')
  if filename ~= '' then
    vim.fn.system('tmux rename-window ' .. vim.fn.shellescape(filename))
  end
end

-- Auto-rename window when entering a buffer
function M.setup_auto_rename()
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufReadPost' }, {
    callback = function()
      M.rename_window_to_file()
    end,
  })
end

-- In lua/pdolden/cmds/tmux.lua (add this to your existing tmux module)

-- Open dotfiles in session
function M.open_dotfiles()
  local dotfiles_path = vim.fn.expand("~/.config")
  local session_name = "dotfiles"

  if not is_in_tmux() then
    -- Not in tmux, just change directory
    vim.cmd("cd " .. vim.fn.fnameescape(dotfiles_path))
    vim.notify("Changed to dotfiles", vim.log.levels.INFO)
    vim.cmd("Neotree focus")
    return
  end

  if session_exists(session_name) then
    -- Session exists, just switch to it
    vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(session_name))
    vim.notify("Switched to dotfiles session", vim.log.levels.INFO)
  else
    -- Create new session with nvim in first window
    vim.fn.system(string.format(
      'tmux new-session -d -s %s -c %s -n editor nvim',
      vim.fn.shellescape(session_name),
      vim.fn.shellescape(dotfiles_path)
    ))

    -- Create second window with shell
    vim.fn.system(string.format(
      'tmux new-window -t %s:1 -n terminal -c %s',
      vim.fn.shellescape(session_name),
      vim.fn.shellescape(dotfiles_path)
    ))

    -- Select the first window (editor)
    vim.fn.system(string.format(
      'tmux select-window -t %s:0',
      vim.fn.shellescape(session_name)
    ))

    -- Switch to the new session
    vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(session_name))
    vim.notify("Created dotfiles session", vim.log.levels.INFO)
  end
end

-- Toggle between current and last session
function M.toggle_last_session()
  if not is_in_tmux() then
    vim.notify("Not inside tmux", vim.log.levels.WARN)
    return
  end

  -- Tmux has a built-in "last session" concept
  -- Using 'switch-client -l' switches to the last session
  vim.fn.system('tmux switch-client -l')

  -- Get the session we just switched to for notification
  local session = vim.fn.system('tmux display-message -p "#S"'):gsub('\n', '')
  vim.notify("Switched to: " .. session, vim.log.levels.INFO)
end

return M
