-- User configuration
-- You can override these values by setting them before loading your config
local M = {}

-- Projects directory for FindProjects command
M.projects_dir = vim.env.PROJECTS_DIR or vim.fn.expand("~/dev")

-- Target depth for project search
M.projects_depth = 3

return M
