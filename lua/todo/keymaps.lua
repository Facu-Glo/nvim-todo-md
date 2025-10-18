local M = {}
local core = require("todo.core")
local tasks = require("todo.tasks")

function M.setup_keymaps(buf, opts, expanded_path)
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

    local keymap = function(lhs, callback, desc)
        vim.api.nvim_buf_set_keymap(buf, "n", lhs, "", {
            noremap = true,
            silent = true,
            callback = callback,
            desc = desc,
        })
    end

    keymap(opts.keys.close, function()
        local current_tick = vim.api.nvim_buf_get_changedtick(buf)
        if current_tick ~= modify.initial then
            vim.notify("Save the changes made.", vim.log.levels.WARN)
        else
            core.comand_close(opts)
        end
    end, "Close ToDo")

    keymap(opts.keys.add, tasks.add_task, "Add task")
    keymap(opts.keys.toggle_check, tasks.toggle_checkbox, "Toggle task status")
    keymap(opts.keys.convert, tasks.make_task, "Convert line to task")
end

return M

