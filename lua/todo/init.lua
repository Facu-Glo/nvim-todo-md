local M = {}

local default_opts = {
    path = nil,
    template = require("todo.template"),
    keys = {
        open = "<leader>td",
        close = "q",
        toggle = "<leader>tm",
    }
}

local function toggle_checkbox()
    local line = vim.api.nvim_get_current_line()
    local new_line = line:gsub("%[.?%]", function(match)
        if match == "[ ]" then
            return "[x]"
        elseif match == "[x]" then
            return "[ ]"
        else
            return nil
        end
    end)
    vim.api.nvim_set_current_line(new_line)
end

local function open_file(opts)
    local expanded_path = vim.fn.expand(opts.path or "~/toDo.md")

    if opts.path and vim.fn.filereadable(expanded_path) == 0 then
        vim.notify("Archivo no encontrado: " .. expanded_path, vim.log.levels.ERROR)
        return
    end

    if not opts.path and vim.fn.filereadable(expanded_path) == 0 then
        vim.fn.writefile(opts.template, expanded_path)
        vim.notify("Archivo toDo creado en: " .. expanded_path, vim.log.levels.INFO)
    end

    local buf = vim.fn.bufnr(expanded_path, true)

    if buf == -1 then
        vim.api.nvim_create_buf(false, false)
    end

    vim.bo[buf].swapfile = false

    vim.api.nvim_set_current_buf(buf)

    vim.api.nvim_buf_set_keymap(buf, "n", opts.keys.close, "", {
        noremap = true,
        silent = true,
        callback = function()
            if vim.api.nvim_get_option_value("modified", { buf = buf }) then
                vim.notify("Guarda los cambios realizados", vim.log.levels.WARN)
            else
                vim.cmd('bdelete')
            end
        end
    })

    vim.api.nvim_buf_set_keymap(0, "n", opts.keys.toggle, "", {
        noremap = true,
        silent = true,
        callback = toggle_checkbox,
        desc = "Alternar estado de la tarea (✓/ )"
    })
end

local function setup_user(opts)
    opts = vim.tbl_deep_extend("force", default_opts, opts)

    vim.api.nvim_create_user_command("ToDo", function()
        open_file(opts)
    end, {})

    vim.keymap.set("n", opts.keys.open, function()
        open_file(opts)
    end, { desc = "Abrir toDo" })
end

M.setup = function(opts)
    setup_user(opts)
end

return M
