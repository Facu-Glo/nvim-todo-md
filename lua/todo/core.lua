local M = {}

local win = nil

function M.center(outer, inner)
    return (outer - inner) / 2
end

function M.window_config(opts)
    local width, height = opts.float.width, opts.float.height
    local row = 0
    if opts.float.center then
        row = M.center(vim.o.lines, height)
    end
    return {
        relative = "editor",
        width = width,
        height = height,
        col = M.center(vim.o.columns, width),
        row = row,
        border = opts.float.border,
    }
end

function M.comand_close(opts)
    if opts.float.enable and win then
        vim.api.nvim_win_close(win, true)
        win = nil
    else
        vim.cmd("bdelete")
    end
end

function M.open_file(opts, setup_keymaps)
    local expanded_path = vim.fn.expand(opts.path or "~/toDo.md")

    local buf = vim.fn.bufnr(expanded_path)
    if buf == -1 then
        buf = vim.api.nvim_create_buf(false, false)
        vim.bo[buf].buftype = "acwrite"
        vim.bo[buf].bufhidden = "wipe"
        vim.bo[buf].swapfile = false
        vim.bo[buf].filetype = "markdown"
        vim.api.nvim_buf_set_name(buf, expanded_path)

        if vim.fn.filereadable(expanded_path) == 1 then
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(expanded_path))
        elseif opts.template then
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, opts.template)
        end
    end

    if win and vim.api.nvim_win_is_valid(win) then
        M.comand_close(opts)
    end

    if opts.float.enable then
        win = vim.api.nvim_open_win(buf, true, M.window_config(opts))
    else
        vim.api.nvim_set_current_buf(buf)
    end

    if setup_keymaps then
        setup_keymaps(buf, opts, expanded_path)
    end
end

return M
