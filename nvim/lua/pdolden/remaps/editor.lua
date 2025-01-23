-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Paste under cursor without yanking
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Format file
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Search and replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


local function debug_definition()
    vim.lsp.buf_request(0, "textDocument/definition", vim.lsp.util.make_position_params(), function(_, result)
        print(vim.inspect(result))
    end)
end

vim.keymap.set("n", "<leader>dd", debug_definition, { noremap = true, silent = true })
