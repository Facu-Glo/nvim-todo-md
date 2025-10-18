local M = {}

function M.add_task()
    vim.ui.input({ prompt = "Nueva tarea:" }, function(input)
        if input and input ~= "" then
            local line = "- [ ] " .. input
            local row = vim.api.nvim_win_get_cursor(0)[1] - 1
            vim.api.nvim_buf_set_lines(0, row, row, false, { line })
        end
    end)
end

function M.toggle_checkbox()
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

function M.make_task()
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

    if not line or line:match("^%-%s%[.%]%s") then return end

    local new_line = "- [ ] " .. line
    vim.api.nvim_buf_set_lines(0, row, row + 1, false, { new_line })
end

return M

