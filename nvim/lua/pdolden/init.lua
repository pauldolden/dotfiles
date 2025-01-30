local load = require('pdolden.utils.load')

-- Load initial config
load('options')
load('remaps')
load('extras')

-- Initialize lazy.nvim
require('pdolden.init_lazy')

-- Load dependent config
load('autocmds')
load('cmds')
