-- autoload.lua in .config/nvim/lua
local function load_directory(directory)
    local path = vim.fn.stdpath('config') .. '/lua/pdolden/' .. directory
    local scan = vim.loop.fs_scandir(path)
    if not scan then
        print("Failed to scan directory: " .. path)
        return
    end

    local function onread(err, file)
        if err then
            print("Error reading directory: " .. err)
            return
        end
        if file then
            local match = file:match("(.+).lua$")
            if match then
                require('pdolden.' .. directory .. '.' .. match)
            end
            return true -- continue reading
        end
    end

    while true do
        local file, type = vim.loop.fs_scandir_next(scan)
        if not file then break end
        if type == 'file' and file:match("%.lua$") then
            onread(nil, file)
        end
    end
end

return {
    load_directory = load_directory
}
