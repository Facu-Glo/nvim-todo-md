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
        convert      = "<leader>tc",
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


local function make_task()
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

    if not line or line:match("^%-%s%[.%]%s") then
        return
    end

    local new_line = "- [ ] " .. line
    vim.api.nvim_buf_set_lines(0, row, row + 1, false, { new_line })
end

local function comand_close(opts)
    if opts.float.enable and win then
        vim.api.nvim_win_close(win, true)
        win = nil
    else
        vim.cmd('bdelete')
    end
end

local function setup_keymaps(buf, opts, expanded_path)
    local modify = { initial = vim.api.nvim_buf_get_changedtick(buf) }

    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = buf,
        callback = function()
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            vim.fn.writefile(lines, expanded_path)
            vim.bo[buf].modified = false
            vim.notify("File saved: " .. expanded_path, vim.log.levels.INFO)
            modify.initial = vim.api.nvim_buf_get_changedtick(buf)
        end,
    })

    vim.api.nvim_buf_set_keymap(buf, "n", opts.keys.close, "", {
        noremap = true,
        silent = true,
        callback = function()
            local current_tick = vim.api.nvim_buf_get_changedtick(buf)
            if current_tick ~= modify.initial then
                vim.notify("Save the changes made.", vim.log.levels.WARN)
            else
                comand_close(opts)
            end
        end
    })

    vim.api.nvim_buf_set_keymap(buf, "n", opts.keys.add, "", {
        noremap = true,
        silent = true,
        callback = add_task,
        desc = "Add task"
    })

    vim.api.nvim_buf_set_keymap(buf, "n", opts.keys.toggle_check, "", {
        noremap = true,
        silent = true,
        callback = toggle_checkbox,
        desc = "Toggle task status (✓/ )"
    })

    vim.api.nvim_buf_set_keymap(buf, "n", opts.keys.convert, "", {
        noremap = true,
        silent = true,
        callback = make_task,
        desc = "Convert current line to task"
    })
end

local function open_file(opts)
    local expanded_path = vim.fn.expand(opts.path or "~/toDo.md")

    local buf = vim.api.nvim_create_buf(false, false)
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

    if win and vim.api.nvim_win_is_valid(win) then
        comand_close(opts)
    end

    if opts.float.enable then
        win = vim.api.nvim_open_win(buf, true, window_config(opts))
    else
        vim.api.nvim_set_current_buf(buf)
    end

    setup_keymaps(buf, opts, expanded_path)
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
    end, { desc = "Open toDo" })
end

M.setup = function(opts)
    setup_user(opts)
end

return M
