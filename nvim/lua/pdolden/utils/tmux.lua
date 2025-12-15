-- Consolidated tmux utilities module
local M = {}

-- Cache for session list (reduces shelling out)
local session_cache = {
	sessions = {},
	timestamp = 0,
	ttl = 3, -- Cache for 3 seconds
}

-- Check if tmux is installed
local tmux_available = nil
local function is_tmux_installed()
	if tmux_available ~= nil then
		return tmux_available
	end
	tmux_available = vim.fn.executable('tmux') == 1
	return tmux_available
end

-- Get the current project name (basename of cwd)
local function get_project_name()
	local cwd = vim.fn.getcwd()
	return vim.fn.fnamemodify(cwd, ':t'):gsub('[^%w-_]', '-')
end

-- Get session name from path
function M.get_session_name_from_path(path)
	local name = vim.fn.fnamemodify(path, ':t')
	return name:gsub('[^%w-_]', '-')
end

-- Check if we're inside tmux
function M.is_in_tmux()
	return vim.env.TMUX ~= nil
end

-- Invalidate session cache (call this after creating/destroying sessions)
function M.invalidate_cache()
	session_cache.timestamp = 0
end

-- Get list of tmux sessions (with caching)
local function get_sessions()
	if not is_tmux_installed() then
		return {}
	end

	local now = os.time()

	-- Return cached sessions if still valid
	if now - session_cache.timestamp < session_cache.ttl then
		local result = {}
		for name, _ in pairs(session_cache.sessions) do
			table.insert(result, name)
		end
		return result
	end

	-- Fetch fresh session list
	local handle = io.popen('tmux list-sessions -F "#{session_name}" 2>/dev/null')
	if not handle then
		return {}
	end

	local sessions = {}
	local session_set = {}
	for session in handle:lines() do
		table.insert(sessions, session)
		session_set[session] = true
	end
	handle:close()

	-- Update cache
	session_cache.sessions = session_set
	session_cache.timestamp = now

	return sessions
end

-- Check if a tmux session exists (with caching)
function M.session_exists(name)
	local now = os.time()

	-- Use cache if valid
	if now - session_cache.timestamp < session_cache.ttl then
		return session_cache.sessions[name] == true
	end

	-- Refresh cache
	get_sessions()
	return session_cache.sessions[name] == true
end

-- Switch to session (fast, no UI)
local function switch_to_session(name)
	if not M.is_in_tmux() then
		vim.notify("Not inside tmux", vim.log.levels.WARN)
		return false
	end

	vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(name))
	return true
end

-- Setup tmux session with nvim in window 0 and shell in window 1
-- Using batched commands for better performance
function M.setup_project_session(session_name, path)
	if not is_tmux_installed() then
		vim.notify("tmux is not installed", vim.log.levels.ERROR)
		return false
	end

	local escaped_session = vim.fn.shellescape(session_name)
	local escaped_path = vim.fn.shellescape(path)

	-- Batch all tmux commands into a single shell call
	local cmd = string.format(
		'tmux new-session -d -s %s -c %s -n editor nvim \\; ' ..
		'new-window -t %s:1 -n terminal -c %s \\; ' ..
		'select-window -t %s:0',
		escaped_session, escaped_path,
		escaped_session, escaped_path,
		escaped_session
	)

	local result = vim.fn.system(cmd)
	local exit_code = vim.v.shell_error

	if exit_code ~= 0 then
		vim.notify("Failed to create tmux session: " .. result, vim.log.levels.ERROR)
		return false
	end

	-- Invalidate cache since we created a new session
	M.invalidate_cache()
	return true
end

-- Create or switch to a named tmux session based on project
function M.create_or_switch_session()
	if not M.is_in_tmux() then
		vim.notify("Not inside tmux", vim.log.levels.WARN)
		return
	end

	local project_name = get_project_name()

	if M.session_exists(project_name) then
		switch_to_session(project_name)
		vim.notify("Switched to session: " .. project_name, vim.log.levels.INFO)
	else
		M.setup_project_session(project_name, vim.fn.getcwd())
		switch_to_session(project_name)
		vim.notify("Created session: " .. project_name, vim.log.levels.INFO)
	end
end

-- Create and switch to tmux session for project (used by project management commands)
function M.open_project_in_session(path, force_new)
	local session_name = M.get_session_name_from_path(path)

	if not M.is_in_tmux() then
		-- Not in tmux, just change directory
		vim.cmd("cd " .. vim.fn.fnameescape(path))
		vim.notify("Changed to: " .. path .. " (not in tmux)", vim.log.levels.INFO)
		-- Use Snacks explorer instead of Neotree
		vim.schedule(function()
			require("snacks").explorer()
		end)
		return
	end

	-- If forcing new session, add timestamp
	if force_new and M.session_exists(session_name) then
		session_name = session_name .. "-" .. os.time()
	end

	if M.session_exists(session_name) then
		-- Session exists, just switch to it
		vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(session_name))
		vim.notify("Switched to session: " .. session_name, vim.log.levels.INFO)
	else
		-- Create new session with proper setup
		M.setup_project_session(session_name, path)

		-- Switch to the new session
		vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(session_name))
		vim.notify("Created session: " .. session_name, vim.log.levels.INFO)
	end
end

-- FZF-based session switcher
function M.fzf_sessions()
	if not M.is_in_tmux() then
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
					M.invalidate_cache()
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
	if not M.is_in_tmux() then
		vim.notify("Not inside tmux", vim.log.levels.WARN)
		return
	end

	vim.ui.input({
		prompt = 'New session name: ',
		default = get_project_name(),
	}, function(name)
		if name and name ~= '' then
			name = name:gsub('[^%w-_]', '-')
			if M.session_exists(name) then
				vim.notify("Session already exists: " .. name, vim.log.levels.WARN)
				return
			end
			M.setup_project_session(name, vim.fn.getcwd())
			switch_to_session(name)
			vim.notify("Created and switched to: " .. name, vim.log.levels.INFO)
		end
	end)
end

-- Kill a session interactively
function M.kill_session()
	if not M.is_in_tmux() then
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
			M.invalidate_cache()
			vim.notify("Killed session: " .. choice, vim.log.levels.INFO)
		end
	end)
end

-- Rename current session
function M.rename_session()
	if not M.is_in_tmux() then
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
			M.invalidate_cache()
			vim.notify("Renamed to: " .. name, vim.log.levels.INFO)
		end
	end)
end

-- Track last renamed filename to avoid redundant calls
local last_window_name = nil

-- Rename current tmux window to match file/buffer
function M.rename_window_to_file()
	if not M.is_in_tmux() then
		return
	end

	local filename = vim.fn.expand('%:t')
	if filename == '' or filename == last_window_name then
		return
	end

	last_window_name = filename
	vim.fn.system('tmux rename-window ' .. vim.fn.shellescape(filename))
end

-- Auto-rename window when entering a buffer (only sets up if in tmux)
function M.setup_auto_rename()
	-- Only set up autocommand if we're actually in tmux
	if not M.is_in_tmux() then
		return
	end

	vim.api.nvim_create_autocmd({ 'BufEnter', 'BufReadPost' }, {
		callback = function()
			M.rename_window_to_file()
		end,
	})
end

-- Open dotfiles in session
function M.open_dotfiles()
	local dotfiles_path = vim.fn.expand("~/.config")
	local session_name = "dotfiles"

	if not M.is_in_tmux() then
		-- Not in tmux, just change directory
		vim.cmd("cd " .. vim.fn.fnameescape(dotfiles_path))
		vim.notify("Changed to dotfiles", vim.log.levels.INFO)
		-- Use Snacks explorer instead of Neotree
		vim.schedule(function()
			require("snacks").explorer()
		end)
		return
	end

	if M.session_exists(session_name) then
		-- Session exists, just switch to it
		vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(session_name))
		vim.notify("Switched to dotfiles session", vim.log.levels.INFO)
	else
		-- Create new session with batched commands
		M.setup_project_session(session_name, dotfiles_path)

		-- Switch to the new session
		vim.fn.system('tmux switch-client -t ' .. vim.fn.shellescape(session_name))
		vim.notify("Created dotfiles session", vim.log.levels.INFO)
	end
end

-- Toggle between current and last session
function M.toggle_last_session()
	if not M.is_in_tmux() then
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
