local M = {}
local core = require("todo.core")
local tasks = require("todo.tasks")
local keymaps = require("todo.keymaps")
local template = require("todo.template")

local default_opts = {
    path = nil,
    template = template,
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

local function setup_user(opts)
    opts = vim.tbl_deep_extend("force", default_opts, opts)

    vim.api.nvim_create_user_command("ToDo", function()
        core.open_file(opts, keymaps.setup_keymaps)
    end, {})

    vim.api.nvim_create_user_command("ToDoCheck", tasks.toggle_checkbox, {})
    vim.api.nvim_create_user_command("ToDoAdd", tasks.add_task, {})

    vim.keymap.set("n", opts.keys.open, function()
        core.open_file(opts, keymaps.setup_keymaps)
    end, { desc = "Open ToDo" })
end

function M.setup(opts)
    setup_user(opts)
end

return M
