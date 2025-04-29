local M = {}

local win = nil

local default_opts = {
    path = nil,
    template = require("todo.template"),
    float = {
        enable = true,
        width  = 80,
        height = 20,
        border = "rounded",
        center = true,
    },
    keys = {
        open         = "<leader>td",
        toggle_check = "<leader>tm",
        add          = "<leader>ta",
        close        = "q",
    }
}

local function add_task()
    vim.ui.input({ prompt = "Nueva tarea:" }, function(input)
        if input and input ~= "" then
            local line = "- [ ] " .. input
            local row = vim.api.nvim_win_get_cursor(0)[1] - 1
            vim.api.nvim_buf_set_lines(0, row, row, false, { line })
        end
    end)
end

local function center(outer, inner)
    return (outer - inner) / 2
end

local function window_config(opts)
    local width = opts.float.width
    local height = opts.float.height

    local row = 0
    if opts.float.center then
        row = center(vim.o.lines, height)
    end
    return {
        relative = "editor",
        width = width,
        height = height,
        col = center(vim.o.columns, width),
        row = row,
        border = opts.float.border,
    }
end

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

local function comand_close(opts)
    if opts.float.enable and win then
        vim.api.nvim_win_close(win, true)
        win = nil
    else
        vim.cmd('bdelete')
    end
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

    vim.bo[buf].swapfile = false

    if win and vim.api.nvim_win_is_valid(win) then
        comand_close(opts)
    end

    if opts.float.enable then
        win = vim.api.nvim_open_win(buf, true, window_config(opts))
    else
        vim.api.nvim_set_current_buf(buf)
    end

    vim.api.nvim_buf_set_keymap(buf, "n", opts.keys.close, "", {
        noremap = true,
        silent = true,
        callback = function()
            if vim.api.nvim_get_option_value("modified", { buf = buf }) then
                vim.notify("Guarda los cambios realizados", vim.log.levels.WARN)
            else
                comand_close(opts)
            end
        end
    })

    vim.api.nvim_buf_set_keymap(0, "n", opts.keys.add, "", {
        noremap = true,
        silent = true,
        callback = add_task,
        desc = "Agregar tarea"
    })

    vim.api.nvim_buf_set_keymap(0, "n", opts.keys.toggle_check, "", {
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

    vim.api.nvim_create_user_command("ToDoCheck", function()
        toggle_checkbox()
    end, {})

    vim.api.nvim_create_user_command("ToDoAdd", function()
        add_task()
    end, {})

    vim.keymap.set("n", opts.keys.open, function()
        open_file(opts)
    end, { desc = "Abrir toDo" })
end

M.setup = function(opts)
    setup_user(opts)
end

return M
