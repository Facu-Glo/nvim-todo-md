local M = {}

M.setup = function(opts)
    opts = opts or {}
    local path = opts.path or "~/toDo.md"

    vim.keymap.set("n", "<leader>td", function()
        vim.cmd("edit " .. path)
        local bufnr = vim.fn.bufnr(path)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<CMD>bdelete<CR>",
            { noremap = true, silent = true })
    end, { desc = "Abrir ToDo.md" })
end

return M
