local M = {}
local default_template = require("todo.template")

M.setup = function(opts)
    opts = opts or {}

    local path = vim.fn.expand(opts.path or "~/toDo.md")

    local keys = {
        open = opts.keys and opts.keys.open or "<leader>td",
        toggle = opts.keys and opts.keys.toggle or "<leader>tc",
        close = opts.keys and opts.keys.close or "q"
    }

    local template = opts.template or default_template

    vim.keymap.set("n", keys.open, function()
        if vim.fn.filereadable(path) == 0 then
            local file = io.open(path, "w")
            if file then
                file:write(template)
                file:close()
            else
                print("No se pudo crear el archivo: " .. path)
                return
            end
        end

        vim.cmd("edit " .. path)

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

        vim.api.nvim_buf_set_keymap(0, "n", keys.close, "<CMD>bdelete<CR>",
            { noremap = true, silent = true })

        vim.api.nvim_buf_set_keymap(0, "n", keys.toggle, "",
            { noremap = true, silent = true, callback = toggle_checkbox, desc = "Alternar estado de la tarea (✓/ )" })
    end, { desc = "Abrir ToDo.md" })
end

return M
